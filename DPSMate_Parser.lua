-- Notes
-- "Smbd reflects..." (Thorns etc.)

-- Global Variables

-- Local Variables
local player = {}
player["name"] = UnitName("player")
local a,b,c = UnitClass("player")
player["class"] = strlower(b)

-- Begin Functions

function DPSMate.Parser:OnLoad()
end

function DPSMate.Parser:OnEvent(event)
	if event == "CHAT_MSG_COMBAT_SELF_HITS" then
		if arg1 then DPSMate.Parser:ParseSelfHits(arg1) end
	elseif event == "CHAT_MSG_COMBAT_SELF_MISSES" then
		if arg1 then DPSMate.Parser:ParseSelfMisses(arg1) end
	elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		if arg1 then DPSMate.Parser:ParseSelfSpellDMG(arg1) end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE" then
		--if arg1 then DPSMate.Parser:ParsePeriodicDamage(arg1) end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
		if arg1 then DPSMate.Parser:ParsePeriodicDamage(arg1) end 
	elseif event == "CHAT_MSG_COMBAT_PARTY_HITS" then
		if arg1 then DPSMate.Parser:ParsePartyHits(arg1) end
	elseif event == "CHAT_MSG_COMBAT_PARTY_MISSES" then
		if arg1 then DPSMate.Parser:ParsePartyMisses(arg1) end 
	elseif event == "CHAT_MSG_SPELL_PARTY_DAMAGE" then 
		if arg1 then DPSMate.Parser:ParsePartySpellDMG(arg1) end
	end
end

function DPSMate.Parser:ParseSelfHits(msg)
	local hit, crit = 0 , 0
	-- Fall damage
	if strfind(msg, DPSMate.localization.parser.youfall) then
		amount = tonumber(strsub(msg, strfind(msg, "%d+")))
		DPSMate.DB:BuildUserAbility(player, "Falling", 1, 0, 0, 0, 0, 0, amount, 1)
	-- Drown damage
	elseif strfind(msg, DPSMate.localization.parser.youdrown) then
		amount = tonumber(strsub(msg, strfind(msg, "%d+")))
		DPSMate.DB:BuildUserAbility(player, "Drowning", 1, 0, 0, 0, 0, 0, amount, 1)
	-- Lava damage
	elseif strfind(msg, DPSMate.localization.parser.swimminginlava) then
		amount = tonumber(strsub(msg, strfind(msg, "%d+")))
		DPSMate.DB:BuildUserAbility(player, "Lava", 1, 0, 0, 0, 0, 0, amount, 1)
	-- White hit Damage
	elseif strfind(msg, DPSMate.localization.parser.youhit) or strfind(msg, DPSMate.localization.parser.youcrit) then
		for k, t, a in string.gfind(msg, "You (.-) (.+) for (%d+).") do
			if k == DPSMate.localization.parser.hit then hit=1; else crit=1; end
			DPSMate.DB:BuildUserAbility(player, "AutoAttack", hit, crit, 0, 0, 0, 0, tonumber(a), 0)
		end
	end
end

function DPSMate.Parser:ParseSelfMisses(msg)
	local miss, parry, dodge = 0, 0, 0
	if strfind(msg, DPSMate.localization.parser.youmiss) then miss = 1; elseif strfind(msg, DPSMate.localization.parser.parries) then parry = 1; elseif strfind(msg, DPSMate.localization.parser.dodges) then dodge = 1; end
	DPSMate.DB:BuildUserAbility(player, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0, 0)
end

function DPSMate.Parser:ParseSelfSpellDMG(msg)
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
	DPSMate.DB:BuildUserAbility(player, ability, hit, crit, miss, parry, dodge, resist, amount, 0)
end

function DPSMate.Parser:ParsePeriodicDamage(msg)
	local cause = {}
	-- School has to be added and target
	for tar, dmg, name, ab in string.gfind(msg, "(.+) suffers (.+) from (.-) (.+)") do
		cause.name = name
		if cause.name == DPSMate.localization.parser.your2 then cause = player; else cause.name = strsub(cause.name, 1, strfind(cause.name, "'s")-1); end
		DPSMate.DB:BuildUserAbility(cause, strsub(ab, 1, strfind(ab, "%.")-1).."(Periodic)", 1, 0, 0, 0, 0, 0, tonumber(strsub(dmg, strfind(dmg, "%d+"))), 0)
	end
end

function DPSMate.Parser:ParsePartyHits(msg)
	local cause, hit, crit = {}, 0, 0
	for c, k, t, a in string.gfind(msg, "(.-) (.-) (.+) for (%d+).") do
		cause.name = c
		if k == DPSMate.localization.parser.hits then hit=1; else crit=1; end
		DPSMate.DB:BuildUserAbility(cause, "AutoAttack", hit, crit, 0, 0, 0, 0, tonumber(a), 0)
	end
end

function DPSMate.Parser:ParsePartyMisses(msg)
	local miss, parry, dodge, cause = 0, 0, 0, {}
	if strfind(msg, DPSMate.localization.parser.misses) then miss = 1; elseif strfind(msg, DPSMate.localization.parser.parries) then parry = 1; elseif strfind(msg, DPSMate.localization.parser.dodges) then dodge = 1; end
	cause.name = strsub(msg, 1, strfind(msg, "%s")-1)
	DPSMate.DB:BuildUserAbility(cause, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0, 0)
end

function DPSMate.Parser:ParsePartySpellDMG(msg)
	local target, ability, cause, hit, crit, amount, resist, parry, dodge, miss, block = "", "", {}, 0, 0, 0, 0, 0, 0, 0, 0
	if strfind(msg, DPSMate.localization.parser.wasdodgedby) then
		for c, ab, t in string.gfind(msg, "(.-)'s (.+) was dodged by (.+).") do dodge=1; cause.name=c; ability=ab; target=t; end
	elseif strfind(msg, DPSMate.localization.parser.wasparriedby) then
		for c, ab, t in string.gfind(msg, "(.-)'s (.+) was parried by (.+).") do parry=1; cause.name=c; ability=ab; target=t; end
	elseif strfind(msg, DPSMate.localization.parser.wasresistedby) then
		for c, ab, t in string.gfind(msg, "(.-)'s (.+) was resisted by (.+).") do resist=1; cause.name=c; ability=ab; target=t; end
	elseif strfind(msg, DPSMate.localization.parser.missed) then
		for c, ab, t in string.gfind(msg, "(.-)'s (.+) missed (.+).") do miss=1; cause.name=c; ability=ab; target=t; end
	elseif strfind(msg, DPSMate.localization.parser.wasblockedby) then
		for c, ab, t in string.gfind(msg, "(.-)'s (.+) was blocked by (.+).") do block=1; cause.name=c; ability=ab; target=t; end
	elseif strfind(msg, DPSMate.localization.parser.immune) then
		-- Decided not to collect immune data
		return
	else
		for c, ab, t, a in string.gfind(msg, "(.-)'s (.+) hits (.+) for (.+).") do hit=1; cause.name=c; ability=ab; target=t; amount=tonumber(strsub(a, strfind(a, "%d+"))); end
		for c, ab, t, a in string.gfind(msg, "(.-)'s (.+) crits (.+) for (.+).") do crit=1; cause.name=c; ability=ab; target=t; amount=tonumber(strsub(a, strfind(a, "%d+"))); end
	end
	if (not cause.name) then return; end
	DPSMate.DB:BuildUserAbility(cause, ability, hit, crit, miss, parry, dodge, resist, amount, 0)
end