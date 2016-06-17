-- Global Variables
DPSMate.Modules.DetailsCasts = {}

-- Local variables
local DetailsUser = ""
local curKey = 1
local db, cbt = {}, 0
local Buffpos = 0
local _G = getglobal
local tinsert = table.insert

function DPSMate.Modules.DetailsCasts:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DPSMate_Details_Casts_Title:SetText("Casts of "..obj.user)
	Buffpos = 0
	self:CleanTables()
	self:UpdateBuffs()
	DPSMate_Details_Casts:Show()
end

function DPSMate.Modules.DetailsCasts:CreateGraphTable(obj)
	local lines = {}
	for i=1, 6 do
		-- Horizontal
		DPSMate.Options.graph:DrawLine(obj, 5, 223-i*30, 655, 223-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	end
	-- Vertical
	DPSMate.Options.graph:DrawLine(obj, 235, 215, 235, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 300, 215, 300, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
end

function DPSMate.Modules.DetailsCasts:CleanTables()
	local path = "DPSMate_Details_Casts_Buffs_Row"
	for i=1, 6 do
		_G(path..i.."_Icon"):SetTexture()
		_G(path..i.."_Name"):SetText()
		_G(path..i.."_Count"):SetText()
		_G(path..i.."_Chance"):SetText()
	end
end

function DPSMate.Modules.DetailsCasts:Replace(text)
	local a,b = strfind(text, "%(")
	if a and b then
		return strsub(text, 1, a-1)
	end
	return text
end

function DPSMate.Modules.DetailsCasts:UpdateBuffs(arg1)
	local a,b,c = DPSMate.Modules.Casts:EvalTable(DPSMateUser[DetailsUser], curKey)
	local t1TL = DPSMate:TableLength(a)-6
	local path = "DPSMate_Details_Casts_Buffs_Row"
	Buffpos=Buffpos-(arg1 or 0)
	if Buffpos<0 then Buffpos = 0 end
	if Buffpos>t1TL then Buffpos = t1TL end
	if t1TL<0 then Buffpos = 0 end
	for i=1, 6 do
		local pos = Buffpos + i
		if not a[pos] then break end
		local ab = DPSMate:GetAbilityById(c[pos])
		_G(path..i).id = c[pos]
		_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(self:Replace(ab)))
		_G(path..i.."_Name"):SetText(ab)
		_G(path..i.."_Count"):SetText(a[pos])
		_G(path..i.."_Chance"):SetText("-")
	end
end
