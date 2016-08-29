-- Global Variables
DPSMate.Modules.DetailsFailsTotal = {}

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

function DPSMate.Modules.DetailsFailsTotal:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DPSMate_Details_FailsTotal_Title:SetText(DPSMate.L["failssum"])
	DetailsArr = self:EvalTable()
	TL = DPSMate:TableLength(DetailsArr)-6
	Buffpos = 0
	self:CleanTables()
	self:UpdateBuffs(0)
	DPSMate_Details_FailsTotal:Show()
	
	DPSMate_Details_FailsTotal:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsFailsTotal:EvalTable()
	local a = {}
	for cat, val in db do -- each user
		local user = DPSMate:GetUserById(cat)
		if DPSMate:ApplyFilter(curKey, user) then
			for ca, va in val do -- each ab?
				if not a[va[1]] then
					a[va[1]] = {}
				end
				if not a[va[1]][va[2]] then
					a[va[1]][va[2]] = {}
				end
				if a[va[1]][va[2]][va[3]] then
					a[va[1]][va[2]][va[3]] = a[va[1]][va[2]][va[3]] + 1
				else
					a[va[1]][va[2]][va[3]] = 1
				end
			end
		end
	end
	local b = {}
	for cat, val in a do
		for ca, va in val do
			for c,v in va do
				local i=1
				while true do
					if not b[i] then
						tinsert(b, i, {v,cat,ca,c})
						break
					elseif b[i][1]<v then
						tinsert(b, i, {v,cat,ca,c})
						break
					end
					i=i+1
				end
			end
		end
	end
	a = nil
	return b
end

function DPSMate.Modules.DetailsFailsTotal:CreateGraphTable(obj)
	local lines = {}
	for i=1, 6 do
		-- Horizontal
		DPSMate.Options.graph:DrawLine(obj, 5, 223-i*30, 670, 223-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	end
	-- Vertical
	DPSMate.Options.graph:DrawLine(obj, 235, 215, 235, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 480, 215, 480, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 570, 215, 570, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
end

function DPSMate.Modules.DetailsFailsTotal:CleanTables()
	local path = "DPSMate_Details_FailsTotal_Buffs_Row"
	for i=1, 6 do
		_G(path..i.."_Icon"):SetTexture()
		_G(path..i.."_Ability"):SetText()
		_G(path..i.."_Victim"):SetText()
		_G(path..i.."_Type"):SetText()
		_G(path..i.."_Amount"):SetText()
	end
end

function DPSMate.Modules.DetailsFailsTotal:Replace(text)
	local a,b = strfind(text, "%(")
	if a and b then
		return strsub(text, 1, a-1)
	end
	return text
end

function DPSMate.Modules.DetailsFailsTotal:Type(id)
	if id == 1 then
		return DPSMate.L["friendlyfire"]
	elseif id == 2 then
		return DPSMate.L["damagetaken"]
	else
		return DPSMate.L["debufftaken"]
	end
end

function DPSMate.Modules.DetailsFailsTotal:UpdateBuffs(arg1)
	local path = "DPSMate_Details_FailsTotal_Buffs_Row"
	Buffpos=Buffpos-(arg1 or 0)
	if Buffpos<0 then Buffpos = 0 end
	if Buffpos>TL then Buffpos = TL end
	if TL<0 then Buffpos = 0 end
	for i=1, 6 do
		local pos = Buffpos + i
		if not DetailsArr[pos] then break end
		local ab = DPSMate:GetAbilityById(DetailsArr[pos][4])
		_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(self:Replace(ab)))
		_G(path..i.."_Ability"):SetText(ab)
		_G(path..i.."_Victim"):SetText(DPSMate:GetUserById(DetailsArr[pos][3]))
		_G(path..i.."_Type"):SetText(self:Type(DetailsArr[pos][2]))
		_G(path..i.."_Amount"):SetText(DetailsArr[pos][1])
	end
end

function DPSMate.Modules.DetailsFailsTotal:ShowTooltip(user, owner)
	GameTooltip:SetOwner(owner)
	GameTooltip:AddLine(user)
	GameTooltip:Show()
end
