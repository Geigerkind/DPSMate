-- Notes
-- "Smbd reflects..." (Thorns etc.)

-- Global Variables

-- Local Variables
local player = {}
player["name"] = UnitName("player")
local a,b = UnitClass("player")
player["class"] = strlower(b)

local procs = {
	-- General
	"Earthstrike",
	"Juju Flurry",
	"Holy Strength",
	"Ephemeral Power",
	"Chromatic Infusion",
	"Brittle Armor",
	"Unstable Power",
	"Zandalarian Hero Medallion",
	"Ascendance",
	"Essence of Sapphiron",
	
	-- Rogue
	"Slice and Dice",
	"Blade Flurry",
	"Sprint",
	"Adrenaline Rush",
	"Vanish",
	
	-- Mage
	"Arcane Power",
	"Combustion",
	"Mind Quickening",
	
	-- Priest
	"Power Infusion",
}

-- Begin Functions

function DPSMate.Parser:OnLoad()
end

function DPSMate.Parser:OnEvent(event)
	-- Damage Done
	if event == "CHAT_MSG_COMBAT_SELF_HITS" then
		if arg1 then DPSMate.Parser:SelfHits(arg1) end
	elseif event == "CHAT_MSG_COMBAT_SELF_MISSES" then
		if arg1 then DPSMate.Parser:SelfMisses(arg1) end
	elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		if arg1 then DPSMate.Parser:SelfSpellDMG(arg1) end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE" then
		--if arg1 then DPSMate:SendMessage(arg1.."PERIODIC") end
	elseif event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" then
		--if arg1 then DPSMate:SendMessage(arg1.."DIRECT") end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
		if arg1 then DPSMate.Parser:PeriodicDamage(arg1) end 
	elseif event == "CHAT_MSG_COMBAT_PARTY_HITS" then
		if arg1 then DPSMate.Parser:FriendlyPlayerHits(arg1) end
	elseif event == "CHAT_MSG_COMBAT_PARTY_MISSES" then
		if arg1 then DPSMate.Parser:FriendlyPlayerMisses(arg1) end 
	elseif event == "CHAT_MSG_SPELL_PARTY_DAMAGE" then 
		if arg1 then DPSMate.Parser:FriendlyPlayerDamage(arg1) end
	elseif event == "COMBAT_TEXT_UPDATE" then
		DPSMate.Parser:TextUpdate(arg1,arg2,arg3)
	elseif event == "CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE" then
		if arg1 then DPSMate.Parser:FriendlyPlayerDamage(arg1) end
	elseif event == "CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS" then
		if arg1 then DPSMate.Parser:FriendlyPlayerHits(arg1) end
	elseif event == "CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES" then
		if arg1 then DPSMate.Parser:FriendlyPlayerMisses(arg1) end
	-- Damage Taken
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" then
		if arg1 then 
			DPSMate.Parser:CreatureVsSelfHits(arg1) 
			DPSMate.Parser:CreatureVsSelfHitsAbsorb(arg1)
		end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES" then
		if arg1 then 
			DPSMate.Parser:CreatureVsSelfMisses(arg1) 
			DPSMate.Parser:CreatureVsSelfMissesAbsorb(arg1)
		end
	elseif event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE" then
		if arg1 then 
			DPSMate.Parser:CreatureVsSelfSpellDamage(arg1)
			DPSMate.Parser:CreatureVsSelfSpellDamageAbsorb(arg1)
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" then
		if arg1 then DPSMate.Parser:PeriodicSelfDamage(arg1) end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS" then
		if arg1 then DPSMate.Parser:CreatureVsCreatureHits(arg1) end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES" then
		if arg1 then DPSMate.Parser:CreatureVsCreatureMisses(arg1) end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE" then
		if arg1 then DPSMate.Parser:SpellPeriodicDamageTaken(arg1) end
	elseif event == "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE" then
		if arg1 then DPSMate.Parser:CreatureVsCreatureSpellDamage(arg1) end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS" then
		if arg1 then DPSMate.Parser:CreatureVsCreatureHits(arg1) end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES" then
		if arg1 then DPSMate.Parser:CreatureVsCreatureMisses(arg1) end
	elseif event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE" then
		if arg1 then 
			DPSMate.Parser:CreatureVsCreatureSpellDamage(arg1)
			DPSMate.Parser:CreatureVsCreatureSpellDamageInterrupts(arg1)
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE" then
		if arg1 then DPSMate.Parser:SpellPeriodicDamageTaken(arg1) end
	-- Healing
	elseif event == "CHAT_MSG_SPELL_SELF_BUFF" then
		if arg1 then 
			DPSMate.Parser:SpellSelfBuff(arg1) 
			DPSMate.Parser:SpellSelfBuffDispels(arg1)
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
		if arg1 then 
			DPSMate.Parser:SpellPeriodicSelfBuff(arg1)
			DPSMate.Parser:SpellPeriodicSelfBuffAbsorb(arg1)
		end
	elseif event == "CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF" then
		if arg1 then DPSMate.Parser:SpellFriendlyPlayerBuff(arg1) end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS" then
		if arg1 then DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(arg1) end
	elseif event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF" then
		if arg1 then 
			DPSMate.Parser:SpellHostilePlayerBuff(arg1) 
			DPSMate.Parser:SpellHostilePlayerBuffDispels(arg1)
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS" then
		if arg1 then DPSMate.Parser:SpellPeriodicHostilePlayerBuffs(arg1) end
	elseif event == "CHAT_MSG_SPELL_PARTY_BUFF" then
		if arg1 then 
			DPSMate.Parser:SpellPartyBuff(arg1) 
			DPSMate.Parser:SpellPartyBuffDispels(arg1)
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS" then
		if arg1 then DPSMate.Parser:SpellPeriodicPartyBuffs(arg1) end
	-- Absorb
	elseif event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF" then
		if arg1 then DPSMate.Parser:SpellDamageShieldsOnSelf(arg1) end
	elseif event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS" then
		if arg1 then DPSMate.Parser:SpellDamageShieldsOnOthers(arg1) end
	elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" then
		if arg1 then DPSMate.Parser:SpellAuraGoneSelf(arg1) end
	elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" then
		if arg1 then DPSMate.Parser:SpellAuraGoneOther(arg1) end
	elseif event == "CHAT_MSG_SPELL_AURA_GONE_PARTY" then
		if arg1 then DPSMate.Parser:SpellAuraGoneParty(arg1) end
	elseif event == "CHAT_MSG_ADDON" then
		if arg1=="DPSMate" then
			local owner, ability, abilityTarget, time = "", "", "", 0
			for o,a,at,t in string.gfind(arg2, "(.+),(.+),(.+),(.+)") do owner=o;ability=a;abilityTarget=at;time=tonumber(t) end
			if DPSMate:TContains(DPSMate.Parser.Kicks, ability) then DPSMate.DB:AwaitAfflictedStun(owner, ability, abilityTarget, time) end
			DPSMate.DB:AwaitingBuff(owner, ability, abilityTarget, time)
			DPSMate.DB:AwaitingAbsorbConfirmation(owner, ability, abilityTarget, time)
		end
	-- Dispels
	elseif event == "CHAT_MSG_SPELL_BREAK_AURA" then
		if arg1 then DPSMate.Parser:SpellBreakAura(arg1) end
	elseif event == "UNIT_AURA" then
		DPSMate.Parser:UnitAuraDispels(arg1)
	-- Deaths
	elseif event == "CHAT_MSG_COMBAT_FRIENDLY_DEATH" then
		if arg1 then DPSMate.Parser:CombatFriendlyDeath(arg1) end
	elseif event == "CHAT_MSG_COMBAT_HOSTILE_DEATH" then
		if arg1 then DPSMate.Parser:CombatHostileDeaths(arg1) end
	-- Interrupts
	elseif event == "CHAT_MSG_SPELL_CREATURE_VS_PARTY_BUFF" then
		--if arg1 then DPSMate:SendMessage(arg1) end
	elseif event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF" then
		--if arg1 then DPSMate:SendMessage(arg1.."SELF") end
	elseif event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF" then
		--if arg1 then DPSMate:SendMessage(arg1.."CREATURE") end
	elseif event == "CHAT_MSG_SPELL_CREATURE_VS_OTHERS_BUFF" then
		--if arg1 then DPSMate:SendMessage(arg1.."OTHERS") end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS" then
		--if arg1 then DPSMate:SendMessage(arg1.."PERIODIC") end
	end
end

----------------------------------------------------------------------------------
--------------                    Damage Done                       --------------                                  
----------------------------------------------------------------------------------

-- You hit Blazing Elemental for 187.
-- You crit Blazing Elemental for 400.
function DPSMate.Parser:SelfHits(msg)
	local hit, crit = 0 , 0
	-- Fall damage
	if strfind(msg, DPSMate.localization.parser.youfall) then
		amount = tonumber(strsub(msg, strfind(msg, "%d+")))
		DPSMate.DB:DamageTaken(player, "Falling", 1, 0, 0, 0, 0, 0, amount, "Environment")
	-- Drown damage
	elseif strfind(msg, DPSMate.localization.parser.youdrown) then
		amount = tonumber(strsub(msg, strfind(msg, "%d+")))
		DPSMate.DB:DamageTaken(player, "Drowning", 1, 0, 0, 0, 0, 0, amount, "Environment")
	-- Lava damage
	elseif strfind(msg, DPSMate.localization.parser.swimminginlava) then
		amount = tonumber(strsub(msg, strfind(msg, "%d+")))
		DPSMate.DB:DamageTaken(player, "Lava", 1, 0, 0, 0, 0, 0, amount, "Environment")
	-- White hit Damage
	elseif strfind(msg, DPSMate.localization.parser.youhit) or strfind(msg, DPSMate.localization.parser.youcrit) then
		for k, t, a in string.gfind(msg, "You (.-) (.+) for (%d+).") do
			if k == DPSMate.localization.parser.hit then hit=1; else crit=1; end
			DPSMate.DB:EnemyDamage(DPSMateEDT, player, "AutoAttack", hit, crit, 0, 0, 0, 0, tonumber(a), t)
			DPSMate.DB:DamageDone(player, "AutoAttack", hit, crit, 0, 0, 0, 0, tonumber(a))
		end
	end
end

function DPSMate.Parser:SelfMisses(msg)
	local miss, parry, dodge = 0, 0, 0
	if strfind(msg, DPSMate.localization.parser.youmiss) then miss = 1; elseif strfind(msg, DPSMate.localization.parser.parries) then parry = 1; elseif strfind(msg, DPSMate.localization.parser.dodges) then dodge = 1; end
	DPSMate.DB:EnemyDamage(DPSMateEDT, player, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0, 0, "None")
	DPSMate.DB:DamageDone(player, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0, 0)
end

function DPSMate.Parser:SelfSpellDMG(msg)
	local target, hit, crit, amount, ability, resist, parry, dodge, miss, block = "", 0, 0, 0, "", 0, 0, 0, 0, 0
	if strfind(msg, DPSMate.localization.parser.wasresistedby) then
		for a, t in string.gfind(msg, "Your (.+) was resisted by (.+).") do resist=1; ability=a; target=t; end
	elseif strfind(msg, DPSMate.localization.parser.isparriedby) then
		for a, t in string.gfind(msg, "Your (.+) is parried by (.+).") do parry=1; ability=a; target=t; end
	elseif strfind(msg, DPSMate.localization.parser.wasdodgedby) then
		for a, t in string.gfind(msg, "Your (.+) was dodged by (.+).") do dodge=1; ability=a; target=t; end
	elseif strfind(msg, DPSMate.localization.parser.missed) then
		for a, t in string.gfind(msg, "Your (.+) missed (.+).") do miss=1; ability=a; target=t; end
	elseif strfind(msg, DPSMate.localization.parser.wasblockedby) then
		for a, t in string.gfind(msg, "Your (.+) was blocked by (.+).") do block=1; ability=a; target=t; end
	elseif strfind(msg, DPSMate.localization.parser.immune) then
		-- Decided not to collect immune data
		return
	else
		-- School and target to be added
		for ab, t, a in string.gfind(msg, "Your (.+) hits (.+) for (.+).") do ability = ab; target = t; amount = tonumber(strsub(a, strfind(a, "%d+"))); hit=1; end
		for ab, t, a in string.gfind(msg, "Your (.+) crits (.+) for (.+).") do ability = ab; target = t; amount = tonumber(strsub(a, strfind(a, "%d+"))); crit=1; end
		if DPSMate:TContains(DPSMate.Parser.Kicks, ability) then DPSMate.DB:AssignPotentialKick(player.name, ability, target, GetTime()) end
	end
	DPSMate.DB:EnemyDamage(DPSMateEDT, player, ability, hit, crit, miss, parry, dodge, resist, amount, target)
	DPSMate.DB:DamageDone(player, ability, hit, crit, miss, parry, dodge, resist, amount)
end

function DPSMate.Parser:PeriodicDamage(msg)
	local cause = {}
	-- (NAME) is afflicted by (ABILITY). => Filtered out for now.
	for ta, ab in string.gfind(msg, "(.+) is afflicted by (.+)%.") do if DPSMate:TContains(DPSMate.Parser.Kicks, ab) then DPSMate.DB:ConfirmAfflictedStun(ta, ab, GetTime()) end end -- That is wrong, it is not always the player!
	-- School has to be added and target
	for tar, dmg, name, ab in string.gfind(msg, "(.+) suffers (.+) from (.-) (.+)") do -- Here might be some loss
		if not name then return end
		cause.name = name
		if cause.name == DPSMate.localization.parser.your2 then cause.name = player.name; else cause.name = strsub(cause.name, 1, strlen(cause.name)-2); end
		DPSMate.DB:EnemyDamage(DPSMateEDT, cause, strsub(ab, 1, strfind(ab, "%.")-1).."(Periodic)", 1, 0, 0, 0, 0, 0, tonumber(strsub(dmg, strfind(dmg, "%d+"))), tar)
		DPSMate.DB:DamageDone(cause, strsub(ab, 1, strfind(ab, "%.")-1).."(Periodic)", 1, 0, 0, 0, 0, 0, tonumber(strsub(dmg, strfind(dmg, "%d+"))))
	end
end

function DPSMate.Parser:TextUpdate(arg1,arg2,arg3) 
	if arg1 == "AURA_START" or arg1 == "AURA_END" then
		if DPSMate:TContains(procs, arg2) then
			DPSMate.DB:BuildUserProcs(player, arg2, false)
		end
	elseif arg1 == "ENERGY" then
		if arg2 == "25" then
			DPSMate.DB:BuildUserProcs(player, "Relentless Strikes", true)
			DPSMate.DB:BuildUserProcs(player, "Relentless Strikes", true)
		elseif arg2 == "35" then
			DPSMate.DB:BuildUserProcs(player, "Rogue Armor Energize", true)
			DPSMate.DB:BuildUserProcs(player, "Rogue Armor Energize", true)
		end
	end
end

function DPSMate.Parser:FriendlyPlayerDamage(msg)
	if strfind(msg, "begins") then return end
	local target, ability, cause, amount, resist, hit, crit = "", "", {}, 0, 0, 0, 0
	if strfind(msg, "was resisted by") then
		for c, ab, t in string.gfind(msg, "(.-)'s (.+) was resisted by (.+).") do resist=1; cause.name=c; ability=ab; target=t; end
	elseif strfind(msg, "immune") then
		-- Wont be collected
		return
	else
		for c, ab, t, a in string.gfind(msg, "(.-)'s (.+) hits (.+) for (.+).") do hit=1; cause.name=c; ability=ab; target=t; amount=tonumber(strsub(a, strfind(a, "%d+"))); end
		for c, ab, t, a in string.gfind(msg, "(.-)'s (.+) crits (.+) for (.+).") do crit=1; cause.name=c; ability=ab; target=t; amount=tonumber(strsub(a, strfind(a, "%d+"))); end
		if DPSMate:TContains(DPSMate.Parser.Kicks, ability) then DPSMate.DB:AssignPotentialKick(cause.name, ability, target, GetTime()) end
	end
	DPSMate.DB:EnemyDamage(DPSMateEDT, cause, ability, hit, crit, 0, 0, 0, resist, amount, target)
	DPSMate.DB:DamageDone(cause, ability, hit, crit, 0, 0, 0, resist, amount)
end

function DPSMate.Parser:FriendlyPlayerHits(msg)
	-- (...). (608 absorbed/resisted)
	local target, cause, hit, crit, amount = "", {}, 0, 0, 0
	if strfind(msg, "lava") then
		for c, a in string.gfind(msg, "(.-) loses (%d+) health for swimming in lava%.") do cause.name=c; amount=tonumber(a); end
		DPSMate.DB:DamageTaken(cause, "Lava", 1, 0, 0, 0, 0, 0, amount, "Environment")
	elseif strfind(msg, "falls") then
		for c, a in string.gfind(msg, "(.-) falls and loses (%d+) health%.") do cause.name=c; amount=tonumber(a); end
		DPSMate.DB:DamageTaken(cause, "Falling", 1, 0, 0, 0, 0, 0, amount, "Environment")
	elseif strfind(msg, "drowning") then
		for c, a in string.gfind(msg, "(.-) is drowning and loses (%d+) health%.") do cause.name=c; amount=tonumber(a); end
		DPSMate.DB:DamageTaken(cause, "Drowning", 1, 0, 0, 0, 0, 0, amount, "Environment")
	else
		for c, k, t, a in string.gfind(msg, "(.-) (.-) (.+) for (.+)%.") do cause.name=c; target=t; amount=tonumber(strsub(a, strfind(a, "%d+"))); if k=="hits" then hit=1 else crit=1 end end
		DPSMate.DB:EnemyDamage(DPSMateEDT, cause, "AutoAttack", hit, crit, 0, 0, 0, 0, amount, target)
		DPSMate.DB:DamageDone(cause, "AutoAttack", hit, crit, 0, 0, 0, 0, amount)
	end
end

function DPSMate.Parser:FriendlyPlayerMisses(msg)
	local miss, parry, dodge, cause = 0, 0, 0, {}
	if strfind(msg, "misses") then miss = 1 elseif strfind(msg, "parries") then parry = 1 elseif strfind(msg, "dodges") then dodge = 1 end
	cause.name = strsub(msg, 1, strfind(msg, " ")-1)
	DPSMate.DB:EnemyDamage(DPSMateEDT, cause, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0, "None")
	DPSMate.DB:DamageDone(cause, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0)
end

-- You reflect 20 Holy damage to Razzashi Serpent.
function DPSMate.Parser:SpellDamageShieldsOnSelf(msg)
	local target, amount = "", 0
	for a, ta in string.gfind(msg, "You reflect (.+) to (.+)%.") do target=ta; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
	DPSMate.DB:EnemyDamage(DPSMateEDT, player, "Reflection (Thorns etc.)", 1, 0, 0, 0, 0, 0, amount, target)
	DPSMate.DB:DamageDone(player, "Reflection (Thorns etc.)", 1, 0, 0, 0, 0, 0, amount)
end

-- Helboar reflects 4 Fire damage to you.
function DPSMate.Parser:SpellDamageShieldsOnOthers(msg)
	local target, cause, amount = "", {}, 0
	for c, a, ta in string.gfind(msg, "(.+) reflects (.+) to (.+)%.") do cause.name=c; target=ta; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
	if target~="you" then DPSMate.DB:EnemyDamage(DPSMateEDT, cause, "Reflection (Thorns etc.)", 1, 0, 0, 0, 0, 0, amount, target) end
	DPSMate.DB:DamageDone(cause, "Reflection (Thorns etc.)", 1, 0, 0, 0, 0, 0, amount)
end

----------------------------------------------------------------------------------
--------------                    Damage taken                      --------------                                  
----------------------------------------------------------------------------------

-- War Reaver hits/crits you for 66.
function DPSMate.Parser:CreatureVsSelfHits(msg)
	local cause, hit, crit, amount, absorbed = "", 0, 0, 0, 0
	for c, a in string.gfind(msg, "(.+) hits you for (.+)%.") do hit=1; cause=c; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
	for c, a in string.gfind(msg, "(.+) crits you for (.+)%.") do crit=1; cause=c; amount=tonumber(strsub(a, strfind(a, "%d+"))) end -- Absorbtion has to be parsed individually
	DPSMate.DB:EnemyDamage(DPSMateEDD, player, "AutoAttack", hit, crit, 0, 0, 0, 0, amount, cause)
	DPSMate.DB:DamageTaken(player, "AutoAttack", hit, crit, 0, 0, 0, 0, amount, cause)
	DPSMate.DB:DeathHistory(player.name, cause, "AutoAttack", amount, hit, crit, 0)
end

-- Firetail Scorpid attacks. You parry.
-- Firetail Scorpid attacks. You dodge.
-- Firetail Scorpid misses you.
function DPSMate.Parser:CreatureVsSelfMisses(msg)
	local cause, miss, parry, dodge = "", 0, 0, 0
	for c, k in string.gfind(msg, "(.+) attacks. You (.+)%.") do cause=c; if k=="parry" then parry=1 else dodge=1 end end
	for c in string.gfind(msg, "(.+) misses you%.") do cause=c; miss=1 end
	DPSMate.DB:EnemyDamage(DPSMateEDD, player, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0, cause)
	DPSMate.DB:DamageTaken(player, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0, cause)
end 

-- Thaurissan Spy performs Dazed on you. (Implementing it later)
-- Thaurissan Spy's Poison was resisted.
-- Thaurissan Spy's Backstab hits/crits you for 116.
-- Flamekin Torcher's Fireball hits/crits you for 86 Fire damage. (School?)
function DPSMate.Parser:CreatureVsSelfSpellDamage(msg)
	local cause, ability, amount, resist, hit, crit, absorbed = "", "", 0, 0, 0, 0, 0
	if not strfind(msg, "performs") then
		for c, ab, a in string.gfind(msg, "(.+)'s (.-) hits you for (.+)%.") do hit=1; cause=c; ability=ab; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
		for c, ab, a in string.gfind(msg, "(.+)'s (.-) crits you for (.+)%.") do crit=1; cause=c; ability=ab; amount=tonumber(strsub(a, strfind(a, "%d+"))) end -- Absorbtion has to be parsed individually
		for c, ab in string.gfind(msg, "(.+)'s (.-) was resisted.") do resist=1; cause=c; ability=ab end
		DPSMate.DB:UnregisterPotentialKick(cause, ability, GetTime())
		DPSMate.DB:EnemyDamage(DPSMateEDD, player, ability, hit, crit, 0, 0, 0, resist, amount, cause)
		DPSMate.DB:DamageTaken(player, ability, hit, crit, 0, 0, 0, resist, amount, cause)
		DPSMate.DB:DeathHistory(player.name, cause, ability, amount, hit, crit, 0)
	end
end

-- You are afflicted by Dazed. (Implementing it later maybe)
-- You are afflicted by Infected Bite.
-- You suffer 8 Nature damage from Ember Worg's Infected Bite. (3 resisted) (School? + resist?)
function DPSMate.Parser:PeriodicSelfDamage(msg)
	local cause, ability, amount = "", "", 0
	if not strfind(msg, "afflicted") then
		for a, c, ab in string.gfind(msg, "You suffer (.+) from (.+)'s (.+)%.") do cause=c; ability=ab; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
		DPSMate.DB:EnemyDamage(DPSMateEDD, player, ability, 1, 0, 0, 0, 0, 0, amount, cause)
		DPSMate.DB:DamageTaken(player, ability, 1, 0, 0, 0, 0, 0, amount, cause)
		DPSMate.DB:DeathHistory(player.name, cause, ability, amount, hit, crit, 0)
	end
end

-- Ember Worg hits/crits Ikaa for 58.
function DPSMate.Parser:CreatureVsCreatureHits(msg) 
	local target, cause, hit, crit, amount = {}, "", 0, 0, 0
	for c, ta, a in string.gfind(msg, "(.+) hits (.-) for (.+)%.") do hit=1; cause=c; target.name = ta; amount=tonumber(strsub(a, strfind(a, "%d+"))); end
	for c, ta, a in string.gfind(msg, "(.+) crits (.-) for (.+)%.") do crit=1; cause=c; target.name = ta; amount=tonumber(strsub(a, strfind(a, "%d+"))); end
	DPSMate.DB:EnemyDamage(DPSMateEDD, target, "AutoAttack", hit, crit, 0, 0, 0, 0, amount, cause)
	DPSMate.DB:DamageTaken(target, "AutoAttack", hit, crit, 0, 0, 0, 0, amount, cause)
	DPSMate.DB:DeathHistory(target, cause, "AutoAttack", amount, hit, crit, 0)
end

-- Ember Worg attacks. Ikaa parries.
-- Ember Worg attacks. Ikaa dodges.
-- Ember Worg misses Ikaa.
-- Young Wolf attacks. Senpie absorbs all the damage.
function DPSMate.Parser:CreatureVsCreatureMisses(msg)
	local target, cause, miss, parry, dodge = {}, "", 0, 0, 0
	for c, ta, k in string.gfind(msg, "(.+) attacks%. (.-) (.+)%.") do cause=c; target.name = ta; if k=="parries" then parry=1 else dodge=1 end end
	for c, ta in string.gfind(msg, "(.+) misses (.+)%.") do cause=c; miss=1; target.name = ta end
	DPSMate.DB:EnemyDamage(DPSMateEDD, target, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0, cause)
	DPSMate.DB:DamageTaken(target, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0, cause)
end

-- Ikaa is afflicted by Infected Bite.
-- Ikaa suffers 15 Nature damage from Ember Worg's Infected Bite. (3 resisted)
function DPSMate.Parser:SpellPeriodicDamageTaken(msg)
	local target, cause, ability, amount = {}, "", "", 0
	if not strfind(msg, "afflicted") then
		for ta, a, c, ab in string.gfind(msg, "(.-) suffers (.+) from (.+)'s (.+)%.") do target.name=ta; cause=c; ability=ab; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
		DPSMate.DB:EnemyDamage(DPSMateEDD, target, ability, 1, 0, 0, 0, 0, 0, amount, cause)
		DPSMate.DB:DamageTaken(target, ability, 1, 0, 0, 0, 0, 0, amount, cause)
		DPSMate.DB:DeathHistory(target, cause, ability, amount, 1, 0, 0)
	end
end

-- Black Broodling's Fireball was resisted by Ikaa.
-- Black Broodling's Fireball hits/crits Ikaa for 342 Fire damage. (100 resisted) (School + resist ?)
function DPSMate.Parser:CreatureVsCreatureSpellDamage(msg)
	local target, cause, hit, crit, resist, ability, amount = {}, "", 0, 0, 0, "", 0
	for c, ab, ta in string.gfind(msg, "(.+)'s (.+) was resisted by (.+)%.") do resist=1; cause=c; target.name = ta; ability=ab end
	for c, ab, ta, a in string.gfind(msg, "(.+)'s (.+) hits (.+) for (.+)%.") do hit=1; cause=c; target.name = ta; ability=ab; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
	for c, ab, ta, a in string.gfind(msg, "(.+)'s (.+) crits (.+) for (.+)%.") do crit=1; cause=c; target.name = ta; ability=ab; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
	DPSMate.DB:UnregisterPotentialKick(cause, ability, GetTime())
	DPSMate.DB:EnemyDamage(DPSMateEDD, target, ability, hit, crit, 0, 0, 0, resist, amount, cause)
	DPSMate.DB:DamageTaken(target, ability, hit, crit, 0, 0, 0, resist, amount, cause)
	DPSMate.DB:DeathHistory(target, cause, ability, amount, hit, crit, 0)
end

----------------------------------------------------------------------------------
--------------                       Healing                        --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Parser:GetUnitByName(target)
	local unit = nil
	if DPSMate.DB:PlayerInParty() then
		if target==UnitName("player") then
			unit="player"
		else
			for i=1, 4 do
				if UnitName("party"..i)==target then
					unit="party"..i; break
				end
			end
		end
	elseif UnitInRaid("player") then
		for i=1, 40 do
			if UnitName("raid"..i)==target then
				unit="raid"..i; break
			end
		end
	end
	return unit
end

function DPSMate.Parser:GetOverhealByName(amount, target)
	local result, unit = 0, DPSMate.Parser:GetUnitByName(target)
	if unit then result = amount-(UnitHealthMax(unit)-UnitHealth(unit)) end
	if result<0 then return 0 else return result end 
end

-- Your Flash of Light heals you for 194.
-- Your Flash of Light critically heals you for 130.
-- You cast Purify on Minihunden.
-- Your Healing Potion heals you for 507.
function DPSMate.Parser:SpellSelfBuff(msg)
	local ability, hit, crit, target, amount = "", 0, 0, "", 0
	for ab, ta, a in string.gfind(msg, "Your (.+) heals (.+) for (.+)%.") do hit=1; crit=0; ability=ab; target=ta; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
	for ab, ta, a in string.gfind(msg, "Your (.+) critically heals (.+) for (.+)%.") do crit=1; hit=0; ability=ab; target=ta; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
	if target=="you" then target=player.name end
	overheal = DPSMate.Parser:GetOverhealByName(amount, target)
	DPSMate.DB:HealingTaken(DPSMateHealingTaken, target, ability, hit, crit, amount, player.name)
	DPSMate.DB:HealingTaken(DPSMateEHealingTaken, target, ability, hit, crit, amount-overheal, player.name)
	DPSMate.DB:Healing(DPSMateEHealing, player, ability, hit, crit, amount-overheal, target)
	DPSMate.DB:Healing(DPSMateOverhealing, player, ability, hit, crit, overheal, target)
	DPSMate.DB:Healing(DPSMateTHealing, player, ability, hit, crit, amount, target)
	DPSMate.DB:DeathHistory(target, player.name, ability, amount, hit, crit, 1)
end

-- You gain First Aid.
-- You gain Mark of the Wild.
-- You gain Thorns.
-- You gain 11 health from First Aid.
-- You gain 61 health from Nenea's Rejuvenation.
function DPSMate.Parser:SpellPeriodicSelfBuff(msg) -- Maybe some loss here?
	local cause, ability, target, amount = {}, "", "", 0
	for ab in string.gfind(msg, "You gain (.+)%.") do if not strfind(msg, "from") then DPSMate.DB:ConfirmBuff(player.name, ab, GetTime()) end end
	for a, ab in string.gfind(msg, "You gain (.+) health from (.+)%.") do amount=tonumber(strsub(a, strfind(a, "%d+"))); ability=ab; target=player.name; cause.name=player.name end
	for a, ta, ab in string.gfind(msg, "You gain (.+) health from (.+)'s (.+)%.") do amount=tonumber(strsub(a, strfind(a, "%d+"))); ability=ab; target=player.name; cause.name=ta end
	if amount>0 then -- Workaround as long as I dont have buffs implemented
		overheal = DPSMate.Parser:GetOverhealByName(amount, target)
		DPSMate.DB:HealingTaken(DPSMateHealingTaken, target, ability, 1, 0, amount, cause.name)
		DPSMate.DB:HealingTaken(DPSMateEHealingTaken, target, ability, 1, 0, amount-overheal, cause.name)
		DPSMate.DB:Healing(DPSMateEHealing, cause, ability, 1, 0, amount-overheal, target)
		DPSMate.DB:Healing(DPSMateOverhealing, cause, ability, 1, 0, overheal, target)
		DPSMate.DB:Healing(DPSMateTHealing, cause, ability, 1, 0, amount, target)
		DPSMate.DB:DeathHistory(player.name, cause.name, ability, amount, 1, 0, 1)
	end
end

-- Albea begins to cast Flash of Light.
-- Albea gains 35 Mana from Albea's Illumination.
-- Catrala performs Last Stand.
-- Albea's Holy Light (critically) heals Impalax for 922.
function DPSMate.Parser:SpellFriendlyPlayerBuff(msg)
	local cause, ability, target, amount, hit, crit = {}, "", "", 0, 0, 0
	for c, ab, ta, a in string.gfind(msg, "(.+)'s (.+) heals (.+) for (.+)%.") do hit=1; crit=0; amount=tonumber(strsub(a, strfind(a, "%d+"))); ability=ab; target=ta; cause.name=c end
	for c, ab, ta, a in string.gfind(msg, "(.+)'s (.+) critically heals (.+) for (.+)%.") do crit=1; hit=0; amount=tonumber(strsub(a, strfind(a, "%d+"))); ability=ab; target=ta; cause.name=c end
	overheal = DPSMate.Parser:GetOverhealByName(amount, target)
	DPSMate.DB:HealingTaken(DPSMateHealingTaken, target, ability, hit, crit, amount, cause.name)
	DPSMate.DB:HealingTaken(DPSMateEHealingTaken, target, ability, hit, crit, amount-overheal, cause.name)
	DPSMate.DB:Healing(DPSMateEHealing, cause, ability, hit, crit, amount-overheal, target)
	DPSMate.DB:Healing(DPSMateOverhealing, cause, ability, hit, crit, overheal, target)
	DPSMate.DB:Healing(DPSMateTHealing, cause, ability, hit, crit, amount, target)
	DPSMate.DB:DeathHistory(target, cause.name, ability, amount, hit, crit, 1)
end

-- Catrala gains Last Stand.
-- Raptor gains 35 Happiness from Giggity's Feed Pet Effect.
-- Sivir gains 11 health from your First Aid.
-- Sivir gains 11 health from Albea's First Aid.
function DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(msg)
	local cause, ability, target, amount = {}, "", "", 0
	for ta, ab in string.gfind(msg, "(.+) gains (.+)%.") do if not strfind(msg, "from") then DPSMate.DB:ConfirmBuff(ta, ab, GetTime()); return end end
	for ta, a, ab in string.gfind(msg, "(.+) gains (.+) health from your (.+)%.") do target=ta; amount=tonumber(strsub(a, strfind(a, "%d+"))); ability=ab; cause.name=player.name end
	for ta, a, c, ab in string.gfind(msg, "(.+) gains (.+) health from (.+)'s (.+)%.") do target=ta; amount=tonumber(strsub(a, strfind(a, "%d+"))); ability=ab; cause.name=c end
	overheal = DPSMate.Parser:GetOverhealByName(amount, target)
	DPSMate.DB:HealingTaken(DPSMateHealingTaken, target, ability, 1, 0, amount, cause.name)
	DPSMate.DB:HealingTaken(DPSMateEHealingTaken, target, ability, 1, 0, amount-overheal, cause.name)
	DPSMate.DB:Healing(DPSMateEHealing, cause, ability, 1, 0, amount-overheal, target)
	DPSMate.DB:Healing(DPSMateOverhealing, cause, ability, 1, 0, overheal, target)
	DPSMate.DB:Healing(DPSMateTHealing, cause, ability, 1, 0, amount, target)
	DPSMate.DB:DeathHistory(target, cause.name, ability, amount, 1, 0, 1)
end

-- Soulleacher gains Summon Felsteed.
-- Raptor gains 35 Happiness from Giggity's Feed Pet Effect.
-- Sivir gains 11 health from your First Aid.
-- Sivir gains 11 health from Albea's First Aid.
function DPSMate.Parser:SpellPeriodicHostilePlayerBuffs(msog)
	for ta, ab in string.gfind(msg, "(.+) gains (.+)%.") do if not strfind(msg, "from") then DPSMate.DB:ConfirmBuff(ta, ab, GetTime()); return end end
	for ta, a, ab in string.gfind(msg, "(.+) gains (.+) health from your (.+)%.") do target=ta; amount=tonumber(strsub(a, strfind(a, "%d+"))); ability=ab; cause.name=player.name end
	for ta, a, c, ab in string.gfind(msg, "(.+) gains (.+) health from (.+)'s (.+)%.") do target=ta; amount=tonumber(strsub(a, strfind(a, "%d+"))); ability=ab; cause.name=c end
	overheal = DPSMate.Parser:GetOverhealByName(amount, target)
	DPSMate.DB:HealingTaken(DPSMateHealingTaken, target, ability, 1, 0, amount, cause.name)
	DPSMate.DB:HealingTaken(DPSMateEHealingTaken, target, ability, 1, 0, amount-overheal, cause.name)
	DPSMate.DB:Healing(DPSMateEHealing, cause, ability, 1, 0, amount-overheal, target)
	DPSMate.DB:Healing(DPSMateOverhealing, cause, ability, 1, 0, overheal, target)
	DPSMate.DB:Healing(DPSMateTHealing, cause, ability, 1, 0, amount, target)
	DPSMate.DB:DeathHistory(target, cause.name, ability, amount, 1, 0, 1)
end

-- A1bea's Flash of Light heals you/Baz for 90.
-- Albea's Flash of Light critically heals you/Baz for 135.
function DPSMate.Parser:SpellHostilePlayerBuff(msg)
	local cause, ability, target, amount, hit, crit = {}, "", "", 0, 0, 0
	for c, ab, ta, a in string.gfind(msg, "(.+)'s (.+) heals (.+) for (.+)%.") do hit=1; crit=0; amount=tonumber(strsub(a, strfind(a, "%d+"))); ability=ab; target=ta; cause.name=c end
	for c, ab, ta, a in string.gfind(msg, "(.+)'s (.+) critically heals (.+) for (.+)%.") do crit=1; hit=0; amount=tonumber(strsub(a, strfind(a, "%d+"))); ability=ab; target=ta; cause.name=c end
	if target=="you" then target=player.name end
	overheal = DPSMate.Parser:GetOverhealByName(amount, target)
	DPSMate.DB:HealingTaken(DPSMateHealingTaken, target, ability, hit, crit, amount, cause.name)
	DPSMate.DB:HealingTaken(DPSMateEHealingTaken, target, ability, hit, crit, amount-overheal, cause.name)
	DPSMate.DB:Healing(DPSMateEHealing, cause, ability, hit, crit, amount-overheal, target)
	DPSMate.DB:Healing(DPSMateOverhealing, cause, ability, hit, crit, overheal, target)
	DPSMate.DB:Healing(DPSMateTHealing, cause, ability, hit, crit, amount, target)
	DPSMate.DB:DeathHistory(target, cause.name, ability, amount, hit, crit, 1)
end

-- Glory casts Redemption on Bla.
-- Glory's Flash of Light heals Olimio for 741.
-- Glory's Flash of Light critically heals Olimio for 741.
function DPSMate.Parser:SpellPartyBuff(msg)
	local cause, ability, target, amount, hit, crit = {}, "", "", 0, 0, 0
	for c, ab, ta, a in string.gfind(msg, "(.+)'s (.+) heals (.+) for (.+)%.") do hit=1; crit=0; amount=tonumber(strsub(a, strfind(a, "%d+"))); ability=ab; target=ta; cause.name=c end
	for c, ab, ta, a in string.gfind(msg, "(.+)'s (.+) critically heals (.+) for (.+)%.") do crit=1; hit=0; amount=tonumber(strsub(a, strfind(a, "%d+"))); ability=ab; target=ta; cause.name=c end
	if target=="you" then target=player.name end
	overheal = DPSMate.Parser:GetOverhealByName(amount, target)
	DPSMate.DB:HealingTaken(DPSMateHealingTaken, target, ability, hit, crit, amount, cause.name)
	DPSMate.DB:HealingTaken(DPSMateEHealingTaken, target, ability, hit, crit, amount-overheal, cause.name)
	DPSMate.DB:Healing(DPSMateEHealing, cause, ability, hit, crit, amount-overheal, target)
	DPSMate.DB:Healing(DPSMateOverhealing, cause, ability, hit, crit, overheal, target)
	DPSMate.DB:Healing(DPSMateTHealing, cause, ability, hit, crit, amount, target)
	DPSMate.DB:DeathHistory(target, cause.name, ability, amount, hit, crit, 1)
end

-- Soulstoke gains First Aid.
-- Feith gains power word shield
-- Soulstoke gains 11 health from your/Albea's First Aid.
function DPSMate.Parser:SpellPeriodicPartyBuffs(msg)
	local cause, ability, target, amount = {}, "", "", 0
	for ta, a, ab in string.gfind(msg, "(.+) gains (.+) health from your (.+)%.") do target=ta; amount=tonumber(strsub(a, strfind(a, "%d+"))); ability=ab; cause.name=player.name end
	for ta, a, c, ab in string.gfind(msg, "(.+) gains (.+) health from (.+)'s (.+)%.") do target=ta; amount=tonumber(strsub(a, strfind(a, "%d+"))); ability=ab; cause.name=c end
	overheal = DPSMate.Parser:GetOverhealByName(amount, target)
	DPSMate.DB:HealingTaken(DPSMateHealingTaken, target, ability, 1, 0, amount, cause.name)
	DPSMate.DB:HealingTaken(DPSMateEHealingTaken, target, ability, 1, 0, amount-overheal, cause.name)
	DPSMate.DB:Healing(DPSMateEHealing, cause, ability, 1, 0, amount-overheal, target)
	DPSMate.DB:Healing(DPSMateOverhealing, cause, ability, 1, 0, overheal, target)
	DPSMate.DB:Healing(DPSMateTHealing, cause, ability, 1, 0, amount, target)
	DPSMate.DB:DeathHistory(target, cause.name, ability, amount, 1, 0, 1)
end

----------------------------------------------------------------------------------
--------------                       Absorbs                        --------------                                  
----------------------------------------------------------------------------------

-- Hooking CastSpellByName to emulate an chat msg event
--[[
DPSMate.Parser.oldCastSpellByName = CastSpellByName
 DPSMate.Parser.CastSpellByName = function(name, onself)
	DPSMate:SendMessage(name)
	DPSMate.Parser.oldCastSpellByName(name, onself)
end
CastSpellByName = DPSMate.Parser.CastSpellByName

DPSMate.Parser.oldCastSpell = CastSpell
 DPSMate.Parser.CastSpellByName = function(spellID, spellbookType)
	DPSMate:SendMessage(spellID)
	DPSMate.Parser.oldCastSpell(spellID, spellbookType)
end
CastSpell = DPSMate.Parser.CastSpell
]]--

DPSMate.Parser.oldUseAction = UseAction
 DPSMate.Parser.UseAction = function(slot, checkCursor, onSelf)
	DPSMate_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	DPSMate_Tooltip:ClearLines()
	DPSMate_Tooltip:SetAction(slot)
	local aura = DPSMate_TooltipTextLeft1:GetText()
	DPSMate_Tooltip:Hide()
	if aura and UnitName("target") then
		SendAddonMessage("DPSMate", player.name..","..aura..","..UnitName("target")..","..GetTime(), "RAID")
		if DPSMate:TContains(DPSMate.Parser.Kicks, ability) then DPSMate.DB:AwaitAfflictedStun(player.name, aura, UnitName("target"), GetTime()) end
		DPSMate.DB:AwaitingBuff(player.name, aura, UnitName("target"), GetTime())
		DPSMate.DB:AwaitingAbsorbConfirmation(player.name, aura, UnitName("target"), GetTime())
	end
	DPSMate.Parser.oldUseAction(slot, checkCursor, onSelf)
end
UseAction = DPSMate.Parser.UseAction

-- Heavy War Golem hits/crits you for 8. (59 absorbed)
function DPSMate.Parser:CreatureVsSelfHitsAbsorb(msg)
	for c, a, absorbed in string.gfind(msg, "(.+) hits you for (.+)%. ((.+) absorbed)") do DPSMate.DB:SetUnregisterVariables(tonumber(absorbed)) end
	for c, a, absorbed in string.gfind(msg, "(.+) crits you for (.+)%. ((.+) absorbed)") do DPSMate.DB:SetUnregisterVariables(tonumber(absorbed)) end
end

-- Heavy War Golem attacks. You absorb all the damage.
function DPSMate.Parser:CreatureVsSelfMissesAbsorb(msg)
	for c in string.gfind(msg, "(.+) attacks%. You absorb all the damage%.") do DPSMate.DB:Absorb("AutoAttack", player.name, c); DPSMate:SendMessage(c.." absorbed!") end
end

-- Heavy War Golem's Trample hits/crits you for 51 (Fire damage). (48 absorbed)
function DPSMate.Parser:CreatureVsSelfSpellDamageAbsorb(msg)
	for c, a, absorbed in string.gfind(msg, "(.+)'s (.+) hits you for (.+)%. ((.+) absorbed)") do DPSMate.DB:SetUnregisterVariables(tonumber(absorbed)) end
	for c, a, absorbed in string.gfind(msg, "(.+)'s (.+) crits you for (.+)%. ((.+) absorbed)") do DPSMate.DB:SetUnregisterVariables(tonumber(absorbed)) end
end

function DPSMate.Parser:SpellPeriodicSelfBuffAbsorb(msg)
	for ab in string.gfind(msg, "You gain (.+)%.") do if DPSMate:TContains(DPSMate.DB.ShieldFlags, ab) then DPSMate.DB:ConfirmAbsorbApplication(ab, player.name, GetTime()) end end
end

-- Power Word: Shield fades from you.
function DPSMate.Parser:SpellAuraGoneSelf(msg)
	for ab in string.gfind(msg, "(.+) fades from you%.") do if DPSMate:TContains(DPSMate.DB.ShieldFlags, ab) then DPSMate.DB:UnregisterAbsorb(ab, player.name) end; DPSMate.DB:DestroyBuffs(player.name, ab) end
end

-- Power Word: Shield fades from Senpie.
function DPSMate.Parser:SpellAuraGoneParty(msg)
	for ab, ta in string.gfind(msg, "(.+) fades from (.+)%.") do if DPSMate:TContains(DPSMate.DB.ShieldFlags, ab) then DPSMate.DB:UnregisterAbsorb(ab, ta) end; DPSMate.DB:DestroyBuffs(ta, ab) end
end

function DPSMate.Parser:SpellAuraGoneOther(msg)
	for ab, ta in string.gfind(msg, "(.+) fades from (.+)%.") do if DPSMate:TContains(DPSMate.DB.ShieldFlags, ab) then DPSMate.DB:UnregisterAbsorb(ab, ta) end; DPSMate.DB:DestroyBuffs(ta, ab) end
end

----------------------------------------------------------------------------------
--------------                       Dispels                        --------------                                  
----------------------------------------------------------------------------------

DPSMate.Parser.Dispels = {
	[1] = "Remove Curse",
	[2] = "Cleanse",
	[3] = "Remove Lesser Curse",
}
DPSMate.Parser.DeCurse = {
	[1] = "Remove Curse",
	[2] = "Remove Lesser Curse",
}
DPSMate.Parser.DeMagic = {
	[1] = "Cleanse",
}
DPSMate.Parser.DeDisease = {
	[1] = "Cleanse",
}
DPSMate.Parser.DePoison = {
	[1] = "Cleanse",
	[2] = "Abolish Poison",
}
DPSMate.Parser.DebuffTypes = {}

-- You gain Abolish Poison.
-- Abolish Poison fades from you.
-- Your Poison is removed.

function DPSMate.Parser:UnitAuraDispels(unit)
	for i=1, 16 do
		DPSMate_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
		DPSMate_Tooltip:ClearLines()
		DPSMate_Tooltip:SetUnitDebuff(unit, i, "HARMFUL")
		local aura = DPSMate_TooltipTextLeft1:GetText()
		local type = DPSMate_TooltipTextRight1:GetText()
		DPSMate_Tooltip:Hide()
		if aura and type then
			DPSMate.DB:BuildAbility(aura, type)
		end
	end
end

-- Is it really "yourself"?
function DPSMate.Parser:SpellSelfBuffDispels(msg)
	for ab, ta in string.gfind(msg, "You cast (.+) on (.+)%.") do if DPSMate:TContains(Dispels, ab) then if ta=="yourself" then DPSMate.DB:AwaitDispel(ab, player.name, player.name, GetTime()) else  DPSMate.DB:AwaitDispel(ab, ta, player.name, GetTime()) end end end
end

function DPSMate.Parser:SpellPartyBuffDispels(msg)
	for c, ab, ta in string.gfind(msg, "(.+) casts (.+) on (.+)%.") do if DPSMate:TContains(Dispels, ab) then if ta=="you" then DPSMate.DB:AwaitDispel(ab, player.name, c, GetTime()) else  DPSMate.DB:AwaitDispel(ab, ta, c, GetTime()) end end end
end

-- Avrora casts Remove Curse on you.
-- Avrora casts Remove Curse on Avrora.
function DPSMate.Parser:SpellHostilePlayerBuffDispels(msg)
	for c, ab, ta in string.gfind(msg, "(.+) casts (.+) on (.+)%.") do if DPSMate:TContains(Dispels, ab) then if ta=="you" then DPSMate.DB:AwaitDispel(ab, player.name, c, GetTime()) else  DPSMate.DB:AwaitDispel(ab, ta, c, GetTime()) end end end
end

-- Avrora's  Curse of Agony is removed.
-- Your Curse of Agony is removed.
function DPSMate.Parser:SpellBreakAura(msg) 
	for ta, ab in string.gfind(msg, "(.+)'s (.+) is removed.") do DPSMate.DB:ConfirmDispel(ab, ta, GetTime()) end
	for ab in string.gfind(msg, "Your (.+) is removed.") do DPSMate.DB:ConfirmDispel(ab, player.name, GetTime()) end
end

----------------------------------------------------------------------------------
--------------                       Deaths                         --------------                                  
----------------------------------------------------------------------------------

-- You die.
-- Senpie dies.
function DPSMate.Parser:CombatFriendlyDeath(msg)
	for ta in string.gfind(msg, "(.-) (.-)%.") do if ta=="You" then DPSMate.DB:UnregisterDeath(player.name) else DPSMate.DB:UnregisterDeath(ta) end end
end

function DPSMate.Parser:CombatHostileDeaths(msg)
	for ta in string.gfind(msg, "(.-) dies%.") do DPSMate.DB:UnregisterDeath(ta) end
end

----------------------------------------------------------------------------------
--------------                     Interrupts                       --------------                                  
----------------------------------------------------------------------------------

DPSMate.Parser.Kicks = {
	-- Interrupts
	-- Rogue
	[1] = "Kick",
	-- Warrior
	[2] = "Pummel",
	[3] = "Shield Bash",
	
	-- Mage
	[8] = "Counterspell",
	
	-- Stuns
	-- Rogue
	[4] = "Gouge",
	[5] = "Kidney Shot",
	[6] = "Cheap Shot",
	
	-- Hunter
	[7] = "Scatter Shot",
	
	-- Warrior
	[9] = "Charge Stun",
	[10] = "Intercept Stun",
	[11] = "Concussion Blow",
}

-- Scalding Broodling begins to cast Fireball.
function DPSMate.Parser:CreatureVsCreatureSpellDamageInterrupts(msg)
	for c, ab in string.gfind(msg, "(.+) begins to cast (.+)%.") do DPSMate.DB:RegisterPotentialKick(c, ab, GetTime()) end
end