-- Global Variables
DPSMate.Modules.DetailsProcsTotal = {}

-- Local variables
local curKey = 1
local db, cbt = {}, 0
local Buffpos = 0
local _G = getglobal
local tinsert = table.insert
local strformat = string.format
local DetailsArr = {}
local TL = 0
DPSMate.Modules.DetailsProcsTotal.mab = {["AutoAttack"] = true, ["Sinister Strike"] = true, ["Eviscerate"] = true, ["Execute"] = true, ["Overpower"] = true, ["Bloodthirst"] = true, ["Mortal Strike"] = true, ["Heroic Strike"] = true, ["Cleave"] = true, ["Whirlwind"] = true, ["Backstab"] = true, ["Shield Slam"] = true, ["Revenge"] = true, ["Sunder Armor"] = true, ["Hamstring"] = true}
DPSMate.Modules.DetailsProcsTotal.specialSnowflakes = {
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
DPSMate.Modules.DetailsProcsTotal.specialSnowflakesDmgTaken = {
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
DPSMate.Modules.DetailsProcsTotal.specialSnowflakesHealTaken = {
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
DPSMate.Modules.DetailsProcsTotal.specialSnowflakesHealDone = {
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

function DPSMate.Modules.DetailsProcsTotal:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DPSMate_Details_ProcsTotal_Title:SetText(DPSMate.L["procssum"])
	Buffpos = 0
	DetailsArr = self:EvalTable()
	TL = DPSMate:TableLength(DetailsArr)-6
	self:CleanTables()
	self:UpdateBuffs(0)
	DPSMate_Details_ProcsTotal:Show()
	DPSMate_Details_ProcsTotal:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsProcsTotal:EvalTable()
	local a = {}
	for cat, val in db do -- each user
		local user = DPSMate:GetUserById(cat)
		if DPSMate:ApplyFilter(curKey, user) then
			local z,x,y = DPSMate.Modules.Procs:EvalTable(DPSMateUser[user], curKey)
			for ca, va in z do
				if a[va] then
					a[va] = a[va] + y[ca]
				else
					a[va] = y[ca]
				end
			end
		end
	end
	local b = {}
	for cat, val in a do
		local i=1
		local chance = self:GetChance(cat, val)
		while true do
			if not b[i] then
				tinsert(b, i, {val, cat, chance})
				break
			elseif b[i][1]<val then
				tinsert(b, i, {val, cat, chance})
				break
			end
			i=i+1
		end
	end
	return b
end

function DPSMate.Modules.DetailsProcsTotal:GetTotalHits(user)
	local hits = 0
	if DPSMateDamageDone[1][user] then
		for cat, val in DPSMateDamageDone[1][user] do
			if cat~="i" then
				if self.mab[DPSMate:GetAbilityById(cat)] then
					hits = hits + val[1] + val[5]
				end
			end
		end
	end
	return hits
end

function DPSMate.Modules.DetailsProcsTotal:GetChance(ab, amount)
	local hits = 0.0000001
	local abname = DPSMate:GetAbilityById(ab)
	for cat, val in db do
		if val[ab] then
			hits = hits + self:GetSpecialSnowFlakeHits(abname, cat)
		end
	end
	return 100*amount/hits
end

DPSMate.Modules.DetailsProcsTotal.Ven = "Vengeance"
DPSMate.Modules.DetailsProcsTotal.Flu = "Flurry"
DPSMate.Modules.DetailsProcsTotal.Rel = "Relentless Strikes Effect"
function DPSMate.Modules.DetailsProcsTotal:GetSpecialSnowFlakeHits(ability, user)
	local num = 0;
	if self.specialSnowflakes[ability] then
		for cat, val in DPSMateDamageDone[1][user] do
			if cat~="i" then
				if self.specialSnowflakes[ability][DPSMate:GetAbilityById(cat)] then
					num = num + val[1] + val[5]
				end
			end
		end
	elseif self.specialSnowflakesDmgTaken[1][ability] then
		for cat, val in DPSMateDamageTaken[1][user] do
			if cat~="i" then
				for ca, va in val do
					if ca~="i" then
						if DPSMate:GetAbilityById(ca) == DPSMate.DB.AAttack then
							num = num + va[1] + va[5] + va[15]
						end
					end
				end
			end
		end
	elseif self.specialSnowflakesDmgTaken[2][ability] then
		for cat, val in DPSMateDamageTaken[1][user] do
			if cat~="i" then
				for ca, va in val do
					if ca~="i" then
						if DPSMate:GetAbilityById(ca) == DPSMate.DB.AAttack then
							num = num + va[5]
						end
					end
				end
			end
		end
	elseif self.specialSnowflakesHealTaken[ability] then
		for cat, val in DPSMateHealingTaken[1][user] do
			if cat~="i" then
				for ca, va in val do
					if self.specialSnowflakesHealTaken[ability][DPSMate:GetAbilityById(ca)] then
						num = num + va[2] + va[3]
					end
				end
			end
		end
	elseif self.specialSnowflakesHealDone[ability] then
		for cat, val in DPSMateTHealing[1][user] do
			if cat~="i" then
				if self.specialSnowflakesHealDone[ability][DPSMate:GetAbilityById(cat)] then
					num = num + val[2] + val[3]
				end
			end
		end
	elseif ability == self.Ven or ability == self.Flu then
		if DPSMateDamageDone[1][user] then
			for cat, val in DPSMateDamageDone[1][user] do
				if cat~="i" then
					num = num + val[5]
				end
			end
		end
	else
		return self:GetTotalHits(user);
	end
	if ability == self.Rel then
		for cat, val in DPSMateAurasGained[1][user] do
			if self.specialSnowflakes[ability][DPSMate:GetAbilityById(cat)] then
				num = num + DPSMate:TableLength(val[2])
			end
		end
	end
	return num;
end

function DPSMate.Modules.DetailsProcsTotal:CreateGraphTable(obj)
	local lines = {}
	for i=1, 6 do
		-- Horizontal
		DPSMate.Options.graph:DrawLine(obj, 5, 223-i*30, 655, 223-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	end
	-- Vertical
	DPSMate.Options.graph:DrawLine(obj, 235, 215, 235, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 300, 215, 300, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
end

function DPSMate.Modules.DetailsProcsTotal:CleanTables()
	local path = "DPSMate_Details_ProcsTotal_Buffs_Row"
	for i=1, 6 do
		_G(path..i.."_Icon"):SetTexture()
		_G(path..i.."_Name"):SetText()
		_G(path..i.."_Count"):SetText()
		_G(path..i.."_Chance"):SetText()
	end
end

function DPSMate.Modules.DetailsProcsTotal:RoundToH(val)
	if val>100 then
		return 100
	end
	return val
end

function DPSMate.Modules.DetailsProcsTotal:UpdateBuffs(arg1)
	local path = "DPSMate_Details_ProcsTotal_Buffs_Row"
	Buffpos=Buffpos-(arg1 or 0)
	if Buffpos<0 then Buffpos = 0 end
	if Buffpos>TL then Buffpos = TL end
	if TL<0 then Buffpos = 0 end
	for i=1, 6 do
		local pos = Buffpos + i
		if not DetailsArr[pos] then break end
		local ab = DPSMate:GetAbilityById(DetailsArr[pos][2])
		_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(ab))
		_G(path..i.."_Name"):SetText(ab)
		_G(path..i.."_Count"):SetText(DetailsArr[pos][1])
		_G(path..i.."_Chance"):SetText(strformat("%.2f", self:RoundToH(DetailsArr[pos][3])).."%")
	end
end
