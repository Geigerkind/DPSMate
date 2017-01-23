-- Global Variables
DPSMate.Modules.DetailsCCBreakerTotal = {}

-- Local variables
local curKey = 1
local db, cbt = {}, 0
local Buffpos = 0
local _G = getglobal
local tinsert = table.insert
local strformat = string.format
local DetailsArr = {}
local TL = 0
local hexClassColor = {
	warrior = "C79C6E",
	rogue = "FFF569",
	priest = "FFFFFF",
	druid = "FF7D0A",
	warlock = "9482C9",
	mage = "69CCF0",
	hunter = "ABD473",
	paladin = "F58CBA",
	shaman = "0070DE",
}

function DPSMate.Modules.DetailsCCBreakerTotal:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DPSMate_Details_CCBreakerTotal_Title:SetText(DPSMate.L["ccbreakersum"])
	DetailsArr = self:EvalTable()
	TL = DPSMate:TableLength(DetailsArr)-6
	Buffpos = 0
	self:CleanTables()
	self:UpdateBuffs(0)
	DPSMate_Details_CCBreakerTotal:Show()
	
	DPSMate_Details_CCBreakerTotal:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsCCBreakerTotal:EvalTable()
	local a = {}
	for cat, val in db do -- each user
		local user = DPSMate:GetUserById(cat)
		if DPSMate:ApplyFilter(curKey, user) then
			for ca, va in val do -- each ab?
				local ab = DPSMate:GetAbilityById(va[1])
				local i=1
				while true do
					if not a[i] then
						tinsert(a, i, {ab, DPSMate.BabbleSpell:GetSpellIcon(self:Replace(ab)), DPSMate:GetUserById(va[2]), va[4], va[3], user})
						break
					elseif a[i][5]<va[3] then
						tinsert(a, i, {ab, DPSMate.BabbleSpell:GetSpellIcon(self:Replace(ab)), DPSMate:GetUserById(va[2]), va[4], va[3], user})
						break
					end
					i = i +1
				end
			end
		end
	end
	return a
end

function DPSMate.Modules.DetailsCCBreakerTotal:CreateGraphTable(obj)
	local lines = {}
	for i=1, 6 do
		-- Horizontal
		DPSMate.Options.graph:DrawLine(obj, 5, 223-i*30, 670, 223-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	end
	-- Vertical
	DPSMate.Options.graph:DrawLine(obj, 70, 215, 70, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 150, 215, 150, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 400, 215, 400, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
end

function DPSMate.Modules.DetailsCCBreakerTotal:CleanTables()
	local path = "DPSMate_Details_CCBreakerTotal_Buffs_Row"
	for i=1, 6 do
		_G(path..i).user = nil
		_G(path..i.."_Icon"):SetTexture()
		_G(path..i.."_Ability"):SetText()
		_G(path..i.."_Target"):SetText()
		_G(path..i.."_Time"):SetText()
		_G(path..i.."_CBT"):SetText()
	end
end

function DPSMate.Modules.DetailsCCBreakerTotal:Replace(text)
	local a,b = strfind(text, "%(")
	if a and b then
		return strsub(text, 1, a-1)
	end
	return text
end

function DPSMate.Modules.DetailsCCBreakerTotal:UpdateBuffs(arg1)
	local path = "DPSMate_Details_CCBreakerTotal_Buffs_Row"
	Buffpos=Buffpos-(arg1 or 0)
	if Buffpos<0 then Buffpos = 0 end
	if Buffpos>TL then Buffpos = TL end
	if TL<0 then Buffpos = 0 end
	for i=1, 6 do
		local pos = Buffpos + i
		if not DetailsArr[pos] then break end
		_G(path..i).user = DetailsArr[pos][6]
		_G(path..i.."_Icon"):SetTexture(DetailsArr[pos][2])
		_G(path..i.."_Ability"):SetText(DetailsArr[pos][1])
		_G(path..i.."_Target"):SetText("|cFF"..hexClassColor[DPSMateUser[DetailsArr[pos][3]][2] or "warrior"]..DetailsArr[pos][3].."|r")
		_G(path..i.."_Time"):SetText(DetailsArr[pos][4])
		_G(path..i.."_CBT"):SetText(strformat("%.2f", DetailsArr[pos][5]).."s")
	end
end

function DPSMate.Modules.DetailsCCBreakerTotal:ShowTooltip(user, owner)
	GameTooltip:SetOwner(owner)
	GameTooltip:AddLine(user)
	GameTooltip:Show()
end
