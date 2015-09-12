-- Global Variables

-- Local Variables
local player = {}
player["name"] = UnitName("player")
player["class"] = UnitClass("player")

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
		if arg1 then DPSMate.Parser:ParsePeriodicDamage(arg1) end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
		if arg1 then DPSMate.Parser:ParsePeriodicDamage(arg1) end 
	end
end

function DPSMate.Parser:ParseSelfHits(msg)
	local target = ""
	local hit = 0
	local crit = 0
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
	DPSMate.DB:BuildUserAbility(player, "AutoAttack", hit, crit, 0, 0, 0, 0, amount)
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
	DPSMate.DB:BuildUserAbility(player, "AutoAttack", 0, 0, miss, parry, dodge, 0, 0)
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
	DPSMate.DB:BuildUserAbility(player, ability, hit, crit, miss, parry, dodge, resist, amount)
end

function DPSMate.Parser:ParsePeriodicDamage(msg)
	local target = ""
	local ability = ""
	local i, j, i2, j2
	local cause = {}
	local amount = 0
	if strfind(msg, " suffers ") then
		target = strsub(msg, 1, strfind(msg, " suffers ")-1)
		i, j = strfind(msg, "%b .")
		ability = strsub(msg, i+1, j-1)
		i2, j2 = strfind(msg, " from ")
		cause.name = strsub(msg, j2+1, i-1)
		if cause.name == "your" then
			cause = player
		else
			cause.class = UnitClass(cause.name) -- not tested
		end
		i, j = strfind(msg, " suffers ")
		local nmsg = strsub(msg, j)
		amount = tonumber(strsub(nmsg, strfind(nmsg, "%d+")))
		DPSMate.DB:BuildUserAbility(cause, ability, 1, 0, 0, 0, 0, 0, amount)
	end
end