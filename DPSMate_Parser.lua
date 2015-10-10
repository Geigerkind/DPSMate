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
	local target = ""
	local hit = 0
	local crit = 0
	
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
		if strfind(msg, DPSMate.localization.parser.youhit) then
			target = strsub(msg, string.len(DPSMate.localization.parser.youhit)+1, strfind(msg, DPSMate.localization.parser.Dfor)-1)
			hit = 1
		else
			target = strsub(msg, string.len(DPSMate.localization.parser.youcrit)+1, strfind(msg, DPSMate.localization.parser.Dfor)-1)
			crit = 1
		end
		local i, j = strfind(msg, DPSMate.localization.parser.Dfor)
		local nmsg = strsub(msg, j)
		local amount = tonumber(strsub(nmsg, strfind(nmsg, "%d+")))
		DPSMate.DB:BuildUserAbility(player, "AutoAttack", hit, crit, 0, 0, 0, 0, amount, 0)
	end
end

function DPSMate.Parser:ParseSelfMisses(msg)
	local miss = 0
	local parry = 0
	local dodge = 0
	if strfind(msg, DPSMate.localization.parser.youmiss) then
		miss = 1
	elseif strfind(msg, DPSMate.localization.parser.parries) then
		parry = 1
	elseif strfind(msg, DPSMate.localization.parser.dodges) then
		dodge = 1
	end
	DPSMate.DB:BuildUserAbility(player, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0, 0)
end

function DPSMate.Parser:ParseSelfSpellDMG(msg)
	local target = ""
	local hit = 0
	local crit = 0
	local amount = 0
	local ability = ""
	local resist = 0
	local parry = 0
	local dodge = 0
	local miss = 0
	local i, j
	if strfind(msg, DPSMate.localization.parser.wasresistedby) then
		resist = 1
		i, j = strfind(msg, DPSMate.localization.parser.wasresistedby)
		ability = strsub(msg, string.len(DPSMate.localization.parser.your)+1, i-1)
		target = strsub(msg, j+1, string.len(msg)-1)
	elseif strfind(msg, DPSMate.localization.parser.isparriedby) then
		parry = 1
		i, j = strfind(msg, DPSMate.localization.parser.isparriedby)
		ability = strsub(msg, string.len(DPSMate.localization.parser.your)+1, i-1)
		target = strsub(msg, j+1, string.len(msg)-1)
	elseif strfind(msg, DPSMate.localization.parser.wasdodgedby) then
		dodge = 1
		i, j = strfind(msg, DPSMate.localization.parser.wasdodgedby)
		ability = strsub(msg, string.len(DPSMate.localization.parser.your)+1, i-1)
		target = strsub(msg, j+1, string.len(msg)-1)
	elseif strfind(msg, DPSMate.localization.parser.missed) then
		miss = 1
		i, j = strfind(msg, DPSMate.localization.parser.missed)
		ability = strsub(msg, string.len(DPSMate.localization.parser.your)+1, i-1)
		target = strsub(msg, j+1, string.len(msg)-1)
	elseif strfind(msg, DPSMate.localization.parser.immune) then
		-- Decided not to collect immune data
	else
		if strfind(msg, DPSMate.localization.parser.hits) then
			i, j = strfind(msg, DPSMate.localization.parser.hits)
			target = strsub(msg, j+1, strfind(msg, DPSMate.localization.parser.Dfor)-1)
			ability = strsub(msg, string.len(DPSMate.localization.parser.your)+1, i-1)
			hit = 1
		else
			i, j = strfind(msg, DPSMate.localization.parser.crits)
			target = strsub(msg, j+1, strfind(msg, DPSMate.localization.parser.Dfor)-1)
			ability = strsub(msg, string.len(DPSMate.localization.parser.your)+1, i-1)
			crit = 1
		end
		local i, j = strfind(msg, DPSMate.localization.parser.Dfor)
		local nmsg = strsub(msg, j)
		amount = tonumber(strsub(nmsg, strfind(nmsg, "%d+")))	
	end
	DPSMate.DB:BuildUserAbility(player, ability, hit, crit, miss, parry, dodge, resist, amount, 0)
end

-- Error for (...) suffers from blblblaa's Curse of Agony. (32 resisted)
function DPSMate.Parser:ParsePeriodicDamage(msg)
	local target = ""
	local ability = ""
	local i, j, i2, j2
	local cause = {}
	local amount = 0
	if strfind(msg, DPSMate.localization.parser.suffers) then
		target = strsub(msg, 1, strfind(msg, DPSMate.localization.parser.suffers)-1)
		i, j = strfind(msg, "%b .")
		ability = strsub(msg, i+1, j-1)
		i2, j2 = strfind(msg, DPSMate.localization.parser.from)
		cause.name = strsub(msg, j2+1, i-1)
		if cause.name == DPSMate.localization.parser.your2 then
			cause = player
		else
			cause.name = strsub(msg, j2+1, i-3)
		end
		i, j = strfind(msg, DPSMate.localization.parser.suffers)
		local nmsg = strsub(msg, j)
		amount = tonumber(strsub(nmsg, strfind(nmsg, "%d+")))
		DPSMate.DB:BuildUserAbility(cause, ability.."(Periodic)", 1, 0, 0, 0, 0, 0, amount, 0)
	end
end

function DPSMate.Parser:ParsePartyHits(msg)
	local target = ""
	local cause = {}
	local amount = 0
	local i, j
	local hit = 0
	local crit = 0
	
	if strfind(msg, DPSMate.localization.parser.hits) then
		cause.name = strsub(msg, 1, strfind(msg, DPSMate.localization.parser.hits)-1)
		i, j = strfind(msg, DPSMate.localization.parser.hits)
		hit = 1
	else
		cause.name = strsub(msg, 1, strfind(msg, DPSMate.localization.parser.crits)-1)
		i, j = strfind(msg, DPSMate.localization.parser.crits)
		crit = 1
	end
	target = strsub(msg, j+1, strfind(msg, DPSMate.localization.parser.Dfor)-1)
	i, j = strfind(msg, "%b .")
	amount = tonumber(strsub(msg, i+1, j-1))
	
	-- Hackfix will be in another event I guess
	if (not DPSMateUser[cause.name]) then
		for p=1, 4 do
			if UnitName("party"..p) == cause.name then
				cause.class = UnitClass("party"..p)
				DPSMateUser[cause.name].class = cause.class
				break
			end
		end
	end
	
	DPSMate.DB:BuildUserAbility(cause, "AutoAttack", hit, crit, 0, 0, 0, 0, amount, 0)
end

function DPSMate.Parser:ParsePartyMisses(msg)
	local miss = 0
	local parry = 0
	local dodge = 0
	local cause = {}
	local i, j
	if strfind(msg, DPSMate.localization.parser.misses) then
		miss = 1
	elseif strfind(msg, DPSMate.localization.parser.parries) then
		parry = 1
	elseif strfind(msg, DPSMate.localization.parser.dodges) then
		dodge = 1
	end
	cause.name = strsub(msg, 1, strfind(msg, "%s")-1)
	DPSMate.DB:BuildUserAbility(cause, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0, 0)
end

function DPSMate.Parser:ParsePartySpellDMG(msg)
	local target = ""
	local ability = ""
	local cause = {}
	local i, j, i2, j2
	local hit = 0
	local crit = 0
	local amount = 0
	-- cases are missing
	local resist = 0
	local parry = 0
	local dodge = 0
	local miss = 0
	
	i2, j2 = strfind(msg, "%s")
	if strfind(msg, DPSMate.localization.parser.wasdodgedby) then
		ability = strsub(msg, i2+1, strfind(msg, DPSMate.localization.parser.wasdodgedby)-1)
		target = strsub(msg, strfind(msg, "%b ."))
		dodge=1
	elseif strfind(msg, DPSMate.localization.parser.wasparriedby) then
		ability = strsub(msg, i2+1, strfind(msg, DPSMate.localization.parser.wasparriedby)-1)
		target = strsub(msg, strfind(msg, "%b ."))
		parry=1
	elseif strfind(msg, DPSMate.localization.parser.wasresistedby) then
		ability = strsub(msg, i2+1, strfind(msg, DPSMate.localization.parser.wasresistedby)-1)
		target = strsub(msg, strfind(msg, "%b ."))
		resist=1
	elseif strfind(msg, DPSMate.localization.parser.missed) then
		ability = strsub(msg, i2+1, strfind(msg, DPSMate.localization.parser.missed)-1)
		target = strsub(msg, strfind(msg, "%b ."))
		miss=1
	else
		if strfind(msg, DPSMate.localization.parser.hits) then
			i, j = strfind(msg, DPSMate.localization.parser.hits)
			ability = strsub(msg, i2+1, i-1)
			hit = 1
		else
			i, j = strfind(msg, DPSMate.localization.parser.crits)
			ability = strsub(msg, i2+1, i-1)
			crit = 1
		end
		target = strsub(msg, j+1, strfind(msg, DPSMate.localization.parser.Dfor)-1)
		i, j = strfind(msg, DPSMate.localization.parser.Dfor)
		local nmsg = strsub(msg, j)
		amount = tonumber(strsub(nmsg, strfind(nmsg, "%d+")))
	end
	cause.name = strsub(msg, 1, i2-3)
	
	DPSMate.DB:BuildUserAbility(cause, ability, hit, crit, miss, parry, dodge, resist, amount, 0)
end