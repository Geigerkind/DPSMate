-- Global Variables
DPSMate.Modules.DetailsProcs = {}

-- Local variables
local DetailsUser = ""
local curKey = 1
local db, cbt = {}, 0
local Buffpos = 0
local _G = getglobal
local tinsert = table.insert
local strformat = string.format
local hits = 1
local mab = {[DPSMate.BabbleSpell:GetTranslation("AutoAttack")] = true, [DPSMate.BabbleSpell:GetTranslation("Sinister Strike")] = true, [DPSMate.BabbleSpell:GetTranslation("Eviscerate")] = true, [DPSMate.BabbleSpell:GetTranslation("Execute")] = true, [DPSMate.BabbleSpell:GetTranslation("Overpower")] = true, [DPSMate.BabbleSpell:GetTranslation("Bloodthirst")] = true, [DPSMate.BabbleSpell:GetTranslation("Mortal Strike")] = true, [DPSMate.BabbleSpell:GetTranslation("Heroic Strike")] = true, [DPSMate.BabbleSpell:GetTranslation("Cleave")] = true, [DPSMate.BabbleSpell:GetTranslation("Whirlwind")] = true, [DPSMate.BabbleSpell:GetTranslation("Backstab")] = true, [DPSMate.BabbleSpell:GetTranslation("Shield Slam")] = true, [DPSMate.BabbleSpell:GetTranslation("Revenge")] = true, [DPSMate.BabbleSpell:GetTranslation("Sunder Armor")] = true}
		

function DPSMate.Modules.DetailsProcs:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DPSMate_Details_Procs_Title:SetText(DPSMate.L["procsof"]..obj.user)
	Buffpos = 0
	self:CleanTables()
	hits = self:GetTotalHits()
	self:UpdateBuffs()
	DPSMate_Details_Procs:Show()
end

function DPSMate.Modules.DetailsProcs:GetTotalHits()
	local num = 1;
	for cat, val in DPSMateDamageDone[1][DPSMateUser[DetailsUser][1]] do
		if cat~="i" then
			if mab[DPSMate:GetAbilityById(cat)] then
				num = num + val[1] + val[5]
			end
		end
	end
	return num
end

function DPSMate.Modules.DetailsProcs:CreateGraphTable(obj)
	local lines = {}
	for i=1, 6 do
		-- Horizontal
		DPSMate.Options.graph:DrawLine(obj, 5, 223-i*30, 655, 223-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	end
	-- Vertical
	DPSMate.Options.graph:DrawLine(obj, 235, 215, 235, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 300, 215, 300, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
end

function DPSMate.Modules.DetailsProcs:CleanTables()
	local path = "DPSMate_Details_Procs_Buffs_Row"
	for i=1, 6 do
		_G(path..i.."_Icon"):SetTexture()
		_G(path..i.."_Name"):SetText()
		_G(path..i.."_Count"):SetText()
		_G(path..i.."_Chance"):SetText()
	end
end

function DPSMate.Modules.DetailsProcs:UpdateBuffs(arg1)
	local a,b,c = DPSMate.Modules.Procs:EvalTable(DPSMateUser[DetailsUser], curKey)
	local t1TL = DPSMate:TableLength(a)-6
	local path = "DPSMate_Details_Procs_Buffs_Row"
	Buffpos=Buffpos-(arg1 or 0)
	if Buffpos<0 then Buffpos = 0 end
	if Buffpos>t1TL then Buffpos = t1TL end
	if t1TL<0 then Buffpos = 0 end
	for i=1, 6 do
		local pos = Buffpos + i
		if not a[pos] then break end
		local ab = DPSMate:GetAbilityById(a[pos])
		_G(path..i).id = a[pos]
		_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(ab))
		_G(path..i.."_Name"):SetText(ab)
		_G(path..i.."_Count"):SetText(c[pos])
		_G(path..i.."_Chance"):SetText(strformat("%.2f", 100*c[pos]/hits).."%")
	end
end

function DPSMate.Modules.DetailsProcs:ShowTooltip(obj)
	if obj.id then
		if db[DPSMateUser[DetailsUser][1]][obj.id] then
			GameTooltip:SetOwner(obj)
			GameTooltip:AddLine(DPSMate:GetAbilityById(obj.id))
			for cat, val in db[DPSMateUser[DetailsUser][1]][obj.id][3] do
				GameTooltip:AddDoubleLine(DPSMate:GetUserById(cat),val,1,1,1,1,1,1)
			end
			GameTooltip:Show()
		end
	end
end
