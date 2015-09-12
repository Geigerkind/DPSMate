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
	end
end

function DPSMate.Parser:ParseSelfHits(msg)
	local target = ""
	local hit = 0
	local crit = 0
	local amount = 0
	if strfind(msg, "hit") then
		target = strsub(msg, string.len("You hit ")+1, strfind(msg, "for")-2)
		hit = 1
	else
		target = strsub(msg, string.len("You crit ")+1, strfind(msg, "for")-2)
		crit = 1
	end
	local i, j = strfind(msg, " for ")
	local nmsg = strsub(msg, j)
	amount = tonumber(strsub(nmsg, strfind(nmsg, "%d+")))
	DPSMate.DB:BuildUserAbility(player, "AutoAttack", hit, crit, 0, 0, 0, amount)
end

function DPSMate.Parser:ParseSelfMisses(msg)
	local miss = 0
	local parry = 0
	local dodge = 0
	if strfind(msg, "You miss") then
		miss = 1
	elseif strfind(msg, "parries") then
		parry = 1
	elseif strfind(msg, "dodges") then
		dodge = 1
	end
	DPSMate.DB:BuildUserAbility(player, "AutoAttack", 0, 0, miss, parry, dodge, 0)
end