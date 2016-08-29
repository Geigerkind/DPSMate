-- Global Variables
DPSMate.Modules.DetailsCastsTotal = {}

-- Local variables
local curKey = 1
local db, cbt = {}, 0
local Buffpos = 0
local _G = getglobal
local tinsert = table.insert
local DetailsArr = {}
local TL = 0

function DPSMate.Modules.DetailsCastsTotal:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DPSMate_Details_CastsTotal_Title:SetText(DPSMate.L["castssum"])
	Buffpos = 0
	DetailsArr = self:EvalTable()
	TL = DPSMate:TableLength(DetailsArr)-6
	self:CleanTables()
	self:UpdateBuffs(0)
	DPSMate_Details_CastsTotal:Show()
	
	DPSMate_Details_CastsTotal:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsCastsTotal:EvalTable()
	local z, b = {}, {}
	for cat, _ in DPSMateDamageDone[curKey] do
		local user = DPSMate:GetUserById(cat)
		if DPSMate:ApplyFilter(curKey, user) then
			local a,_,c = DPSMate.Modules.Casts:EvalTable(DPSMateUser[DPSMate:GetUserById(cat)], curKey)
			for ca, va in a do
				if z[c[ca]] then
					z[c[ca]] = z[c[ca]] + va
				else
					z[c[ca]] = va
				end
			end
		end
	end
	for cat, val in z do
		local i=1
		while true do
			if not b[i] then
				tinsert(b, i, {val,cat})
				break
			elseif b[i][1]<val then
				tinsert(b, i, {val,cat})
				break
			end
			i=i+1
		end
	end
	z = nil
	return b
end

function DPSMate.Modules.DetailsCastsTotal:CreateGraphTable(obj)
	local lines = {}
	for i=1, 6 do
		-- Horizontal
		DPSMate.Options.graph:DrawLine(obj, 5, 223-i*30, 345, 223-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	end
	-- Vertical
	DPSMate.Options.graph:DrawLine(obj, 235, 215, 235, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
end

function DPSMate.Modules.DetailsCastsTotal:CleanTables(comp)
	local path = "DPSMate_Details_CastsTotal_Buffs_Row"
	for i=1, 6 do
		_G(path..i.."_Icon"):SetTexture()
		_G(path..i.."_Name"):SetText()
		_G(path..i.."_Count"):SetText()
	end
end

function DPSMate.Modules.DetailsCastsTotal:Replace(text)
	local a,b = strfind(text, "%(")
	if a and b then
		return strsub(text, 1, a-1)
	end
	return text
end

function DPSMate.Modules.DetailsCastsTotal:UpdateBuffs(arg1, comp, cname)
	local path = "DPSMate_Details_CastsTotal_Buffs_Row"
	Buffpos=Buffpos-(arg1 or 0)
	if Buffpos<0 then Buffpos = 0 end
	if Buffpos>TL then Buffpos = TL end
	if TL<0 then Buffpos = 0 end
	for i=1, 6 do
		local pos = Buffpos + i
		if not DetailsArr[pos] then break end
		local ab = DPSMate:GetAbilityById(DetailsArr[pos][2])
		_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(self:Replace(ab)))
		_G(path..i.."_Name"):SetText(ab)
		_G(path..i.."_Count"):SetText(DetailsArr[pos][1])
	end
end
