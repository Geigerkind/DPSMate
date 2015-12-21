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
		--if arg1 then DPSMate.Parser:ParsePeriodicDamage(arg1) end
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
		if arg1 then DPSMate.Parser:CreatureVsSelfHits(arg1) end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES" then
		if arg1 then DPSMate.Parser:CreatureVsSelfMisses(arg1) end
	elseif event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE" then
		if arg1 then DPSMate.Parser:CreatureVsSelfSpellDamage(arg1) end
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
		if arg1 then DPSMate.Parser:CreatureVsCreatureSpellDamage(arg1) end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE" then
		if arg1 then DPSMate.Parser:SpellPeriodicDamageTaken(arg1) end
	end
end

----------------------------------------------------------------------------------
--------------                    Damage Done                       --------------                                  
----------------------------------------------------------------------------------

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
			DPSMate.DB:DamageDone(player, "AutoAttack", hit, crit, 0, 0, 0, 0, tonumber(a))
		end
	end
end

function DPSMate.Parser:SelfMisses(msg)
	local miss, parry, dodge = 0, 0, 0
	if strfind(msg, DPSMate.localization.parser.youmiss) then miss = 1; elseif strfind(msg, DPSMate.localization.parser.parries) then parry = 1; elseif strfind(msg, DPSMate.localization.parser.dodges) then dodge = 1; end
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
	end
	DPSMate.DB:DamageDone(player, ability, hit, crit, miss, parry, dodge, resist, amount)
end

function DPSMate.Parser:PeriodicDamage(msg)
	local cause = {}
	-- (NAME) is afflicted by (ABILITY). => Filtered out for now.
	-- School has to be added and target
	for tar, dmg, name, ab in string.gfind(msg, "(.+) suffers (.+) from (.-) (.+)") do -- Here might be some loss
		if not name then return end
		cause.name = name
		if cause.name == DPSMate.localization.parser.your2 then cause = player; else cause.name = strsub(cause.name, 1, strlen(cause.name)-2); end
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
	end
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
		DPSMate.DB:DamageDone(cause, "AutoAttack", hit, crit, 0, 0, 0, 0, amount)
	end
end

function DPSMate.Parser:FriendlyPlayerMisses(msg)
	local miss, parry, dodge, cause = 0, 0, 0, {}
	if strfind(msg, "misses") then miss = 1 elseif strfind(msg, "parries") then parry = 1 elseif strfind(msg, "dodges") then dodge = 1 end
	cause.name = strsub(msg, 1, strfind(msg, " ")-1)
	DPSMate.DB:DamageDone(cause, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0)
end

----------------------------------------------------------------------------------
--------------                    Damage taken                      --------------                                  
----------------------------------------------------------------------------------

-- War Reaver hits/crits you for 66.
function DPSMate.Parser:CreatureVsSelfHits(msg)
	local cause, hit, crit, amount = "", 0, 0, 0
	for c, a in string.gfind(msg, "(.+) hits you for (.+)%.") do hit=1; cause=c; amount=tonumber(strsub(a, strfind(a, "%d+"))); end
	for c, a in string.gfind(msg, "(.+) crits you for (.+)%.") do crit=1; cause=c; amount=tonumber(strsub(a, strfind(a, "%d+"))); end
	DPSMate.DB:EnemyDamageDone(player, "AutoAttack", hit, crit, 0, 0, 0, 0, amount, cause)
	DPSMate.DB:DamageTaken(player, "AutoAttack", hit, crit, 0, 0, 0, 0, amount, cause)
end

-- Firetail Scorpid attacks. You parry.
-- Firetail Scorpid attacks. You dodge.
-- Firetail Scorpid misses you.
function DPSMate.Parser:CreatureVsSelfMisses(msg)
	local cause, miss, parry, dodge = "", 0, 0, 0
	for c, k in string.gfind(msg, "(.+) attacks. You (.+)%.") do cause=c; if k=="parry" then parry=1 else dodge=1 end end
	for c in string.gfind(msg, "(.+) misses you%.") do cause=c; miss=1 end
	DPSMate.DB:EnemyDamageDone(player, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0, cause)
	DPSMate.DB:DamageTaken(player, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0, cause)
end 

-- Thaurissan Spy performs Dazed on you. (Implementing it later)
-- Thaurissan Spy's Poison was resisted.
-- Thaurissan Spy's Backstab hits/crits you for 116.
-- Flamekin Torcher's Fireball hits/crits you for 86 Fire damage. (School?)
function DPSMate.Parser:CreatureVsSelfSpellDamage(msg)
	local cause, ability, amount, resist, hit, crit = "", "", 0, 0, 0, 0
	if not strfind(msg, "performs") then
		for c, ab, a in string.gfind(msg, "(.+)'s (.-) hits you for (.+)%.") do hit=1; cause=c; ability=ab; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
		for c, ab, a in string.gfind(msg, "(.+)'s (.-) crits you for (.+)%.") do crit=1; cause=c; ability=ab; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
		for c, ab, a in string.gfind(msg, "(.+)'s (.-) was resisted.") do resist=1; cause=c; ability=ab end
		DPSMate.DB:EnemyDamageDone(player, ability, hit, crit, 0, 0, 0, resist, amount, cause)
		DPSMate.DB:DamageTaken(player, ability, hit, crit, 0, 0, 0, resist, amount, cause)
	end
end

-- You are afflicted by Dazed. (Implementing it later maybe)
-- You are afflicted by Infected Bite.
-- You suffer 8 Nature damage from Ember Worg's Infected Bite. (3 resisted) (School? + resist?)
function DPSMate.Parser:PeriodicSelfDamage(msg)
	local cause, ability, amount = "", "", 0
	if not strfind(msg, "afflicted") then
		for a, c, ab in string.gfind(msg, "You suffer (.+) from (.+)'s (.+)%.") do cause=c; ability=ab; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
		DPSMate.DB:EnemyDamageDone(player, ability, 1, 0, 0, 0, 0, 0, amount, cause)
		DPSMate.DB:DamageTaken(player, ability, 1, 0, 0, 0, 0, 0, amount, cause)
	end
end

-- Ember Worg hits/crits Ikaa for 58.
function DPSMate.Parser:CreatureVsCreatureHits(msg) 
	local target, cause, hit, crit, amount = {}, "", 0, 0, 0
	for c, ta, a in string.gfind(msg, "(.+) hits (.-) for (.+)%.") do hit=1; cause=c; target.name = ta; amount=tonumber(strsub(a, strfind(a, "%d+"))); end
	for c, ta, a in string.gfind(msg, "(.+) crits (.-) for (.+)%.") do crit=1; cause=c; target.name = ta; amount=tonumber(strsub(a, strfind(a, "%d+"))); end
	DPSMate.DB:EnemyDamageDone(target, "AutoAttack", hit, crit, 0, 0, 0, 0, amount, cause)
	DPSMate.DB:DamageTaken(target, "AutoAttack", hit, crit, 0, 0, 0, 0, amount, cause)
end

-- Ember Worg attacks. Ikaa parries.
-- Ember Worg attacks. Ikaa dodges.
-- Ember Worg misses Ikaa.
function DPSMate.Parser:CreatureVsCreatureMisses(msg)
	local target, cause, miss, parry, dodge = {}, "", 0, 0, 0
	for c, ta, k in string.gfind(msg, "(.+) attacks%. (.-) (.+)%.") do cause=c; target.name = ta; if k=="parries" then parry=1 else dodge=1 end end
	for c, ta in string.gfind(msg, "(.+) misses (.+)%.") do cause=c; miss=1; target.name = ta end
	DPSMate.DB:EnemyDamageDone(target, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0, cause)
	DPSMate.DB:DamageTaken(target, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0, cause)
end

-- Ikaa is afflicted by Infected Bite.
-- Ikaa suffers 15 Nature damage from Ember Worg's Infected Bite. (3 resisted)
function DPSMate.Parser:SpellPeriodicDamageTaken(msg)
	local target, cause, ability, amount = {}, "", "", 0
	if not strfind(msg, "afflicted") then
		for ta, a, c, ab in string.gfind(msg, "(.-) suffers (.+) from (.+)'s (.+)%.") do target.name=ta; cause=c; ability=ab; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
		DPSMate.DB:EnemyDamageDone(target, ability, 1, 0, 0, 0, 0, 0, amount, cause)
		DPSMate.DB:DamageTaken(target, ability, 1, 0, 0, 0, 0, 0, amount, cause)
	end
end

-- Black Broodling's Fireball was resisted by Ikaa.
-- Black Broodling's Fireball hits/crits Ikaa for 342 Fire damage. (100 resisted) (School + resist ?)
function DPSMate.Parser:CreatureVsCreatureSpellDamage(msg)
	local target, cause, hit, crit, resist, ability, amount = {}, "", 0, 0, 0, "", 0
	for c, ab, ta in string.gfind(msg, "(.+)'s (.+) was resisted by (.+)%.") do resist=1; cause=c; target.name = ta; ability=ab end
	for c, ab, ta, a in string.gfind(msg, "(.+)'s (.+) hits (.+) for (.+)%.") do hit=1; cause=c; target.name = ta; ability=ab; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
	for c, ab, ta, a in string.gfind(msg, "(.+)'s (.+) crits (.+) for (.+)%.") do crit=1; cause=c; target.name = ta; ability=ab; amount=tonumber(strsub(a, strfind(a, "%d+"))) end
	DPSMate.DB:EnemyDamageDone(target, ability, hit, crit, 0, 0, 0, resist, amount, cause)
	DPSMate.DB:DamageTaken(target, ability, hit, crit, 0, 0, 0, resist, amount, cause)
end