-- Global Variables
DPSMate.Modules.DetailsProcs = {}

-- Local variables
local DetailsUser, DetailsUserComp = "", ""
local curKey = 1
local db, cbt = {}, 0
local Buffpos = 0
local BuffposComp = 0
local _G = getglobal
local tinsert = table.insert
local strformat = string.format
local hits = 1
local hitsComp = 1
DPSMate.Modules.DetailsProcs.mab = {["AutoAttack"] = true, ["Sinister Strike"] = true, ["Eviscerate"] = true, ["Execute"] = true, ["Overpower"] = true, ["Bloodthirst"] = true, ["Mortal Strike"] = true, ["Heroic Strike"] = true, ["Cleave"] = true, ["Whirlwind"] = true, ["Backstab"] = true, ["Shield Slam"] = true, ["Revenge"] = true, ["Sunder Armor"] = true, ["Hamstring"] = true}
DPSMate.Modules.DetailsProcs.specialSnowflakes = {
	["Relentless Strikes Effect"] = {
		["Eviscerate"] = true,
		["Slice and Dice"] = true,
		["Kidney Shot"] = true,
		["Rupture"] = true,
	},
	["Ruthlessness"] = {
		["Eviscerate"] = true,
		["Slice and Dice"] = true,
		["Kidney Shot"] = true,
		["Rupture"] = true,
	},
	["Netherwind Focus"] = {
		["Arcane Missiles"] = true,
		["Fireball"] = true,
		["Frostbolt"] = true,
	},
	["Head Rush"] = {
		["Sinister Strike"] = true,
		["Backstab"] = true,
		["Hemorrhage"] = true,
	},
	["Enigma Resist Bonus"] = {
		["Arcane Missiles"] = true,
		["Fireball"] = true,
		["Frostbolt"] = true,
	},
	["Enigma Blizzard Bonus"] = {
		["Blizzard"] = true,
	},
	["Not There"] = {
		["Arcane Missiles"] = true,
		["Fireball"] = true,
		["Frostbolt"] = true,
	},
	["Clearcasting"] = {
		["Arcane Missiles"] = true,
		["Fireball"] = true,
		["Frostbolt"] = true,
		["Lightning Bolt"] = true,
		["Chain Lightning"] = true,
		["Earth Shock"] = true,
		["Flame Shock"] = true,
		["Frost Shock"] = true,
	},
	["Battlegear of Eternal Justice"] = {
		["Judgement"] = true,
	},
	["Stormcaller's Wrath"] = {
		["Lightning Bolt"] = true,
		["Chain Lightning"] = true,
		["Earth Shock"] = true,
		["Flame Shock"] = true,
		["Frost Shock"] = true,
	},
	["Vampirism"] = {
		["Shadow Bolt"] = true,
	},
	["Nightfall"] = {
		["Corruption"] = true,
		["Drain Life"] = true,
	},
	["Quick Shots"] = {
		["Auto Shot"] = true,
	}
}
DPSMate.Modules.DetailsProcs.specialSnowflakesDmgTaken = {
	[1] = { -- All
		["Cheat Death"] = true,
		["Redoubt"] = true,
	}, -- Just crits
	[2] = {
		["Enrage"] = true,
		["Blessed Recovery"] = true,
		["Focused Casting"] = true,
	}
}
DPSMate.Modules.DetailsProcs.specialSnowflakesHealTaken = {
	["Inspiration"] = {
		["Flash Heal"] = true,
		["Greater Heal"] = true,
		["Heal"] = true,
		["Prayer of Healing"] = true,
		["Lesser Heal"] = true,
		["Desperate Prayer"] = true,
	},
	["Ancestral Spirit"] = {
		["Chain Heal"] = true,
		["Healing Wave"] = true,
		["Lesser Healing Wave"] = true,
	}
}
DPSMate.Modules.DetailsProcs.specialSnowflakesHealDone = {
	["Nature's Grace"] = {
		["Regrowth"] = true,
		["Swiftmend"] = true,
		["Healing Touch"] = true,
	},
	["Epiphany"] = {
		["Flash Heal"] = true,
		["Greater Heal"] = true,
		["Heal"] = true,
		["Prayer of Healing"] = true,
		["Lesser Heal"] = true,
		["Desperate Prayer"] = true,
	},
	["Aura of the Blue Dragon"] = {
		["Flash Heal"] = true,
		["Greater Heal"] = true,
		["Heal"] = true,
		["Prayer of Healing"] = true,
		["Lesser Heal"] = true,
		["Desperate Prayer"] = true,
		["Flash of Light"] = true,
		["Holy Light"] = true,
		["Holy Shock"] = true,
		["Regrowth"] = true,
		["Swiftmend"] = true,
		["Healing Touch"] = true,
		["Chain Heal"] = true,
		["Healing Wave"] = true,
		["Lesser Healing Wave"] = true,
	},
}

function DPSMate.Modules.DetailsProcs:UpdateDetails(obj, key)
	DPSMate_Details_CompareProcs:Hide()
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DetailsUserComp = nil
	DPSMate_Details_Procs_Title:SetText(DPSMate.L["procsof"]..obj.user)
	Buffpos = 0
	self:CleanTables("")
	hits = 1
	hits = self:GetTotalHits()
	self:UpdateBuffs(0, "")
	DPSMate_Details_Procs:Show()
	DPSMate_Details_Procs:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsProcs:UpdateCompare(obj, key, comp)
	self:UpdateDetails(obj, key)
	
	DetailsUserComp = comp
	DPSMate_Details_CompareProcs_Title:SetText(DPSMate.L["procsof"]..comp)
	BuffposComp = 0
	self:CleanTables("Compare")
	hitsComp = 1
	hitsComp = self:GetTotalHits(comp)
	self:UpdateBuffs(0, "Compare")
	DPSMate_Details_CompareProcs:Show()
end

function DPSMate.Modules.DetailsProcs:GetTotalHits(cname)
	if hits == 1 or (cname and hitsComp == 1) then
		for cat, val in DPSMateDamageDone[1][DPSMateUser[cname or DetailsUser][1]] do
			if cat~="i" then
				if self.mab[DPSMate:GetAbilityById(cat)] then
					if cname then
						hitsComp = hitsComp + val[1] + val[5]
					else
						hits = hits + val[1] + val[5]
					end
				end
			end
		end
	end
	if cname then
		return hitsComp
	end
	return hits
end

function DPSMate.Modules.DetailsProcs:GetSpecialSnowFlakeHits(ability, cname)
	local num = 0;
	if self.specialSnowflakes[ability] then
		for cat, val in DPSMateDamageDone[1][DPSMateUser[cname or DetailsUser][1]] do
			if cat~="i" then
				if self.specialSnowflakes[ability][DPSMate:GetAbilityById(cat)] then
					num = num + val[1] + val[5]
				end
			end
		end
	elseif self.specialSnowflakesDmgTaken[1][ability] then
		for cat, val in DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]] do
			if cat~="i" then
				for ca, va in val do
					if ca~="i" then
						if DPSMate:GetAbilityById(ca) == "AutoAttack" then
							num = num + va[1] + va[5] + va[15]
						end
					end
				end
			end
		end
	elseif self.specialSnowflakesDmgTaken[2][ability] then
		for cat, val in DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]] do
			if cat~="i" then
				for ca, va in val do
					if ca~="i" then
						if DPSMate:GetAbilityById(ca) == "AutoAttack" then
							num = num + va[5]
						end
					end
				end
			end
		end
	elseif self.specialSnowflakesHealTaken[ability] then
		for cat, val in DPSMateHealingTaken[1][DPSMateUser[cname or DetailsUser][1]] do
			if cat~="i" then
				for ca, va in val do
					if self.specialSnowflakesHealTaken[ability][DPSMate:GetAbilityById(ca)] then
						num = num + va[2] + va[3]
					end
				end
			end
		end
	elseif self.specialSnowflakesHealDone[ability] then
		for cat, val in DPSMateTHealing[1][DPSMateUser[cname or DetailsUser][1]] do
			if cat~="i" then
				if self.specialSnowflakesHealDone[ability][DPSMate:GetAbilityById(cat)] then
					num = num + val[2] + val[3]
				end
			end
		end
	elseif ability == "Vengeance" or ability == "Flurry" then
		for cat, val in DPSMateDamageDone[1][DPSMateUser[cname or DetailsUser][1]] do
			if cat~="i" then
				num = num + val[5]
			end
		end
	else
		if cname then
			return hitsComp
		end
		return hits;
	end
	if ability == "Relentless Strikes Effect" then
		for cat, val in DPSMateAurasGained[1][DPSMateUser[cname or DetailsUser][1]] do
			if self.specialSnowflakes[ability][DPSMate:GetAbilityById(cat)] then
				num = num + DPSMate:TableLength(val[2])
			end
		end
	end
	return num;
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

function DPSMate.Modules.DetailsProcs:CleanTables(comp)
	local path = "DPSMate_Details_"..comp.."Procs_Buffs_Row"
	for i=1, 6 do
		_G(path..i.."_Icon"):SetTexture()
		_G(path..i.."_Name"):SetText()
		_G(path..i.."_Count"):SetText()
		_G(path..i.."_Chance"):SetText()
	end
end

function DPSMate.Modules.DetailsProcs:RoundToH(val)
	if val>100 then
		return 100
	end
	return val
end

function DPSMate.Modules.DetailsProcs:UpdateBuffs(arg1, comp, cname)
	if comp~="" and comp then
		cname = DetailsUserComp
	end
	local a,b,c = DPSMate.Modules.Procs:EvalTable(DPSMateUser[cname or DetailsUser], curKey)
	local t1TL = DPSMate:TableLength(a)-6
	local path = "DPSMate_Details_"..comp.."Procs_Buffs_Row"
	if comp~="" and comp then
		BuffposComp=BuffposComp-(arg1 or 0)
		if BuffposComp<0 then BuffposComp = 0 end
		if BuffposComp>t1TL then BuffposComp = t1TL end
		if t1TL<0 then BuffposComp = 0 end
		for i=1, 6 do
			local pos = BuffposComp + i
			if not a[pos] then break end
			local ab = DPSMate:GetAbilityById(a[pos])
			_G(path..i).id = a[pos]
			_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(ab))
			_G(path..i.."_Name"):SetText(ab)
			_G(path..i.."_Count"):SetText(c[pos])
			_G(path..i.."_Chance"):SetText(strformat("%.2f", self:RoundToH(100*c[pos]/self:GetSpecialSnowFlakeHits(ab, cname))).."%")
		end
	else
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
			_G(path..i.."_Chance"):SetText(strformat("%.2f", self:RoundToH(100*c[pos]/self:GetSpecialSnowFlakeHits(ab))).."%")
		end
	end
end

function DPSMate.Modules.DetailsProcs:ShowTooltip(obj)
	if obj.id then
		local user = DetailsUser
		if string.find(obj:GetName(), "Compare") then
			user = DetailsUserComp
		end
		if db[DPSMateUser[user][1]][obj.id] then
			GameTooltip:SetOwner(obj)
			GameTooltip:AddLine(DPSMate:GetAbilityById(obj.id))
			for cat, val in db[DPSMateUser[user][1]][obj.id][3] do
				GameTooltip:AddDoubleLine(DPSMate:GetUserById(cat),val,1,1,1,1,1,1)
			end
			GameTooltip:Show()
		end
	end
end
