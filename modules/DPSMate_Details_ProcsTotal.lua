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
local mab = {[DPSMate.BabbleSpell:GetTranslation("AutoAttack")] = true, [DPSMate.BabbleSpell:GetTranslation("Sinister Strike")] = true, [DPSMate.BabbleSpell:GetTranslation("Eviscerate")] = true, [DPSMate.BabbleSpell:GetTranslation("Execute")] = true, [DPSMate.BabbleSpell:GetTranslation("Overpower")] = true, [DPSMate.BabbleSpell:GetTranslation("Bloodthirst")] = true, [DPSMate.BabbleSpell:GetTranslation("Mortal Strike")] = true, [DPSMate.BabbleSpell:GetTranslation("Heroic Strike")] = true, [DPSMate.BabbleSpell:GetTranslation("Cleave")] = true, [DPSMate.BabbleSpell:GetTranslation("Whirlwind")] = true, [DPSMate.BabbleSpell:GetTranslation("Backstab")] = true, [DPSMate.BabbleSpell:GetTranslation("Shield Slam")] = true, [DPSMate.BabbleSpell:GetTranslation("Revenge")] = true, [DPSMate.BabbleSpell:GetTranslation("Sunder Armor")] = true, [DPSMate.BabbleSpell:GetTranslation("Hamstring")] = true}
local specialSnowflakes = {
	[DPSMate.BabbleSpell:GetTranslation("Relentless Strikes Effect")] = {
		[DPSMate.BabbleSpell:GetTranslation("Eviscerate")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Slice and Dice")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Kidney Shot")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Rupture")] = true,
	},
	[DPSMate.BabbleSpell:GetTranslation("Ruthlessness")] = {
		[DPSMate.BabbleSpell:GetTranslation("Eviscerate")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Slice and Dice")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Kidney Shot")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Rupture")] = true,
	},
	[DPSMate.BabbleSpell:GetTranslation("Netherwind Focus")] = {
		[DPSMate.BabbleSpell:GetTranslation("Arcane Missiles")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Fireball")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Frostbolt")] = true,
	},
	[DPSMate.BabbleSpell:GetTranslation("Head Rush")] = {
		[DPSMate.BabbleSpell:GetTranslation("Sinister Strike")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Backstab")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Hemorrhage")] = true,
	},
	[DPSMate.BabbleSpell:GetTranslation("Enigma Resist Bonus")] = {
		[DPSMate.BabbleSpell:GetTranslation("Arcane Missiles")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Fireball")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Frostbolt")] = true,
	},
	[DPSMate.BabbleSpell:GetTranslation("Enigma Blizzard Bonus")] = {
		[DPSMate.BabbleSpell:GetTranslation("Blizzard")] = true,
	},
	[DPSMate.BabbleSpell:GetTranslation("Not There")] = {
		[DPSMate.BabbleSpell:GetTranslation("Arcane Missiles")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Fireball")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Frostbolt")] = true,
	},
	[DPSMate.BabbleSpell:GetTranslation("Clearcasting")] = {
		[DPSMate.BabbleSpell:GetTranslation("Arcane Missiles")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Fireball")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Frostbolt")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Lightning Bolt")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Chain Lightning")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Earth Shock")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Flame Shock")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Frost Shock")] = true,
	},
	[DPSMate.BabbleSpell:GetTranslation("Battlegear of Eternal Justice")] = {
		[DPSMate.BabbleSpell:GetTranslation("Judgement")] = true,
	},
	[DPSMate.BabbleSpell:GetTranslation("Stormcaller's Wrath")] = {
		[DPSMate.BabbleSpell:GetTranslation("Lightning Bolt")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Chain Lightning")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Earth Shock")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Flame Shock")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Frost Shock")] = true,
	},
	[DPSMate.BabbleSpell:GetTranslation("Vampirism")] = {
		[DPSMate.BabbleSpell:GetTranslation("Shadow Bolt")] = true,
	},
	[DPSMate.BabbleSpell:GetTranslation("Nightfall")] = {
		[DPSMate.BabbleSpell:GetTranslation("Corruption")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Drain Life")] = true,
	},
	[DPSMate.BabbleSpell:GetTranslation("Quick Shots")] = {
		[DPSMate.BabbleSpell:GetTranslation("Auto Shot")] = true,
	}
}
local specialSnowflakesDmgTaken = {
	[1] = { -- All
		[DPSMate.BabbleSpell:GetTranslation("Cheat Death")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Redoubt")] = true,
	}, -- Just crits
	[2] = {
		[DPSMate.BabbleSpell:GetTranslation("Enrage")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Blessed Recovery")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Focused Casting")] = true,
	}
}
local specialSnowflakesHealTaken = {
	[DPSMate.BabbleSpell:GetTranslation("Inspiration")] = {
		[DPSMate.BabbleSpell:GetTranslation("Flash Heal")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Greater Heal")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Heal")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Prayer of Healing")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Lesser Heal")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Desperate Prayer")] = true,
	},
	[DPSMate.BabbleSpell:GetTranslation("Ancestral Spirit")] = {
		[DPSMate.BabbleSpell:GetTranslation("Chain Heal")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Healing Wave")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Lesser Healing Wave")] = true,
	}
}
local specialSnowflakesHealDone = {
	[DPSMate.BabbleSpell:GetTranslation("Nature's Grace")] = {
		[DPSMate.BabbleSpell:GetTranslation("Regrowth")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Swiftmend")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Healing Touch")] = true,
		--[DPSMate.BabbleSpell:GetTranslation("Starfire")] = true,
		--[DPSMate.BabbleSpell:GetTranslation("Wrath")] = true,
		--[DPSMate.BabbleSpell:GetTranslation("Moonfire")] = true,
	},
	[DPSMate.BabbleSpell:GetTranslation("Epiphany")] = {
		[DPSMate.BabbleSpell:GetTranslation("Flash Heal")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Greater Heal")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Heal")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Prayer of Healing")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Lesser Heal")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Desperate Prayer")] = true,
	},
	[DPSMate.BabbleSpell:GetTranslation("Aura of the Blue Dragon")] = {
		[DPSMate.BabbleSpell:GetTranslation("Flash Heal")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Greater Heal")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Heal")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Prayer of Healing")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Lesser Heal")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Desperate Prayer")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Flash of Light")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Holy Light")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Holy Shock")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Regrowth")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Swiftmend")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Healing Touch")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Chain Heal")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Healing Wave")] = true,
		[DPSMate.BabbleSpell:GetTranslation("Lesser Healing Wave")] = true,
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
				if mab[DPSMate:GetAbilityById(cat)] then
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

function DPSMate.Modules.DetailsProcsTotal:GetSpecialSnowFlakeHits(ability, user)
	local num = 0;
	if specialSnowflakes[ability] then
		for cat, val in DPSMateDamageDone[1][user] do
			if cat~="i" then
				if specialSnowflakes[ability][DPSMate:GetAbilityById(cat)] then
					num = num + val[1] + val[5]
				end
			end
		end
	elseif specialSnowflakesDmgTaken[1][ability] then
		for cat, val in DPSMateDamageTaken[1][user] do
			if cat~="i" then
				for ca, va in val do
					if ca~="i" then
						if DPSMate:GetAbilityById(ca) == DPSMate.BabbleSpell:GetTranslation("AutoAttack") then
							num = num + va[1] + va[5] + va[15]
						end
					end
				end
			end
		end
	elseif specialSnowflakesDmgTaken[2][ability] then
		for cat, val in DPSMateDamageTaken[1][user] do
			if cat~="i" then
				for ca, va in val do
					if ca~="i" then
						if DPSMate:GetAbilityById(ca) == DPSMate.BabbleSpell:GetTranslation("AutoAttack") then
							num = num + va[5]
						end
					end
				end
			end
		end
	elseif specialSnowflakesHealTaken[ability] then
		for cat, val in DPSMateHealingTaken[1][user] do
			if cat~="i" then
				for ca, va in val do
					if specialSnowflakesHealTaken[ability][DPSMate:GetAbilityById(ca)] then
						num = num + va[2] + va[3]
					end
				end
			end
		end
	elseif specialSnowflakesHealDone[ability] then
		for cat, val in DPSMateTHealing[1][user] do
			if cat~="i" then
				if specialSnowflakesHealDone[ability][DPSMate:GetAbilityById(cat)] then
					num = num + val[2] + val[3]
				end
			end
		end
	elseif ability == DPSMate.BabbleSpell:GetTranslation("Vengeance") or ability == DPSMate.BabbleSpell:GetTranslation("Flurry") then
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
	if ability == DPSMate.BabbleSpell:GetTranslation("Relentless Strikes Effect") then
		for cat, val in DPSMateAurasGained[1][user] do
			if specialSnowflakes[ability][DPSMate:GetAbilityById(cat)] then
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
