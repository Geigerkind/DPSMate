-- Global Variables
DPSMate.Modules.DetailsFails = {}

-- Local variables
local DetailsUser = ""
local curKey = 1
local db, cbt = {}, 0
local Buffpos = 0
local _G = getglobal
local tinsert = table.insert

function DPSMate.Modules.DetailsFails:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DPSMate_Details_Fails_Title:SetText(DPSMate.L["failsof"]..obj.user)
	Buffpos = 0
	self:CleanTables()
	self:UpdateBuffs()
	DPSMate_Details_Fails:Show()
end

function DPSMate.Modules.DetailsFails:CreateGraphTable(obj)
	local lines = {}
	for i=1, 6 do
		-- Horizontal
		DPSMate.Options.graph:DrawLine(obj, 5, 223-i*30, 655, 223-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	end
	-- Vertical
	DPSMate.Options.graph:DrawLine(obj, 235, 215, 235, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 480, 215, 480, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 570, 215, 570, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
end

function DPSMate.Modules.DetailsFails:CleanTables()
	local path = "DPSMate_Details_Fails_Buffs_Row"
	for i=1, 6 do
		_G(path..i.."_Icon"):SetTexture()
		_G(path..i.."_Ability"):SetText()
		_G(path..i.."_Victim"):SetText()
		_G(path..i.."_Type"):SetText()
		_G(path..i.."_Amount"):SetText()
	end
end

function DPSMate.Modules.DetailsFails:Replace(text)
	local a,b = strfind(text, "%(")
	if a and b then
		return strsub(text, 1, a-1)
	end
	return text
end

function DPSMate.Modules.DetailsFails:Type(id)
	if id == 1 then
		return DPSMate.L["friendlyfire"]
	elseif id == 2 then
		return DPSMate.L["damagetaken"]
	else
		return DPSMate.L["debufftaken"]
	end
end

function DPSMate.Modules.DetailsFails:UpdateBuffs(arg1)
	local a = db[DPSMateUser[DetailsUser][1]]
	local t1TL = DPSMate:TableLength(a)-6
	local path = "DPSMate_Details_Fails_Buffs_Row"
	Buffpos=Buffpos-(arg1 or 0)
	if Buffpos<0 then Buffpos = 0 end
	if Buffpos>t1TL then Buffpos = t1TL end
	if t1TL<0 then Buffpos = 0 end
	for i=1, 6 do
		local pos = Buffpos + i
		if not a[pos] then break end
		local ab = DPSMate:GetAbilityById(a[pos][3])
		_G(path..i).id = a[pos][3]
		_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(self:Replace(ab)))
		_G(path..i.."_Ability"):SetText(ab)
		_G(path..i.."_Victim"):SetText(DPSMate:GetUserById(a[pos][2]))
		_G(path..i.."_Type"):SetText(self:Type(a[pos][1]))
		_G(path..i.."_Amount"):SetText(a[pos][4])
	end
end
