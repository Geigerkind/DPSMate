-- Notes
-- "Smbd reflects..." (Thorns etc.)
-- (%s%(%a-%))
-- /script local t = {}; for a,b,c,d in string.gfind("You hit Peter Hallow for 184.", "You (%a%a?)\it (.+) for (%d+)%.%s?(.*)") do t[1]=a;t[2]=b;t[3]=c;t[4]=d end; DPSMate:SendMessage(t[3]); DPSMate:SendMessage(t[4])
-- CHAT_MSG_SPELL_FAILED_LOCALPLAYER -> Examples: You fail to cast Heal: Interrupted. You fail to perform Bear Form: Not enough mana
-- SPELLCAST_INTERRUPTED

-- Global Variables
DPSMate.Parser.procs = {
	-- General
	["Earthstrike"] = true,
	["Juju Flurry"] = true,
	["Holy Strength"] = true,
	["Ephemeral Power"] = true,
	["Chromatic Infusion"] = true,
	["Brittle Armor"] = true,
	["Unstable Power"] = true,
	["Zandalarian Hero Medallion"] = true,
	["Ascendance"] = true,
	["Essence of Sapphiron"] = true,
	["Hand of Justice"] = true,
	["Sword Specialization"] = true,
	["Bonereaver's Edge"] = true,
	
	-- Rogue
	["Slice and Dice"] = true,
	["Blade Flurry"] = true,
	["Sprint"] = true,
	["Adrenaline Rush"] = true,
	["Vanish"] = true,
	["Relentless Strikes Effect"] = true,
	["Rogue Armor Energize Effect"] = true,
	
	-- Mage
	["Arcane Power"] = true,
	["Combustion"] = true,
	["Mind Quickening"] = true,
	
	-- Priest
	["Power Infusion"] = true,
	
	-- Druid
}
DPSMate.Parser.DmgProcs = {
	-- General
	["Life Steal"] = true,
	["Thunderfury"] = true
}
DPSMate.Parser.TargetParty = {}

-- Local Variables
local player = UnitName("player")
local _,playerclass = UnitClass("player")
local strgfind = string.gfind
local DB = DPSMate.DB
local t = {}
local Execute = {}
local tnbr = tonumber
local lastMouseover

-- Begin Functions

function DPSMate.Parser:OnLoad()
	if (not DPSMateUser[player]) then
		DPSMateUser[player] = {
			[1] = DPSMate:TableLength(DPSMateUser)+1,
			[2] = strlower(playerclass),
		}
	end
end

function DPSMate.Parser:GetPlayerValues()
	player = UnitName("player")
	DPSMatePlayer[1] = player
	DPSMatePlayer[2] = playerclass
	local _, fac = UnitFactionGroup("player")
	if fac == "Alliance" then
		DPSMatePlayer[3] = 1
	elseif fac == "Horde" then
		DPSMatePlayer[3] = -1
	end
	DPSMatePlayer[4] = GetRealmName()
	DPSMatePlayer[5] = GetGuildInfo("player")
end

function DPSMate.Parser:OnEvent(event)
	if Execute[event] then
		--DPSMate:SendMessage(event..": "..arg1)
		Execute[event](arg1)
	end
end

----------------------------------------------------------------------------------
--------------                    Damage Done                       --------------                                  
----------------------------------------------------------------------------------

-- You hit Blazing Elemental for 187.
-- You crit Blazing Elemental for 400.
function DPSMate.Parser:SelfHits(msg)
	t = {}
	for a,b,c,d in strgfind(msg, "You (%a%a?)\it (.+) for (%d+)\.%s?(.*)") do
		if a == "h" then t[1]=1;t[2]=0 end
		if d == "(glancing)" then t[3]=1;t[1]=0;t[2]=0 elseif d ~= "" then t[4]=1;t[1]=0;t[2]=0 end
		DB:EnemyDamage(true, DPSMateEDT, player, "AutoAttack", t[1] or 0, t[2] or 1, 0, 0, 0, 0, tnbr(c), b, t[4] or 0, t[3] or 0)
		DB:DamageDone(player, "AutoAttack", t[1] or 0, t[2] or 1, 0, 0, 0, 0, tnbr(c), t[3] or 0, t[4] or 0)
		return
	end
	for a in strgfind(msg, "You fall and lose (%d+) health%.") do
		DB:DamageTaken(player, "Falling", 1, 0, 0, 0, 0, 0, tnbr(a), "Environment", 0)
		DB:DeathHistory(player, "Environment", "Falling", tnbr(a), 1, 0, 0, 0)
		return
	end
	for a in strgfind(msg, "You lose (%d+) health for swimming in lava%.") do
		DB:DamageTaken(player, "Lava", 1, 0, 0, 0, 0, 0, tnbr(a), "Environment", 0)
		DB:DeathHistory(player, "Environment", "Lava", tnbr(a), 1, 0, 0, 0)
		return
	end
	for a in strgfind(msg, "You are drowning and lose (%d+) health%.") do
		DB:DamageTaken(player, "Drowning", 1, 0, 0, 0, 0, 0, tnbr(a), "Environment", 0)
		DB:DeathHistory(player, "Environment", "Drowning", tnbr(a), 1, 0, 0, 0)
		return
	end
end

function DPSMate.Parser:SelfMisses(msg)
	-- Filter out immune message --> using them?
	t = {}
	for a in strgfind(msg, "You miss (.+)%.") do 
		DB:EnemyDamage(true, DPSMateEDT, player, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
		DB:DamageDone(player, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	end
	for a,b in strgfind(msg, "You attack%. (.+) (%a-)%.") do 
		if b=="parries" then t[1]=1 elseif b=="dodges" then t[2]=1 else t[3]=1 end
		DB:EnemyDamage(true, DPSMateEDT, player, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, t[3] or 0, 0)
		DB:DamageDone(player, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, 0, t[3] or 0)
	end
end

-- /script for a,b,c,d in string.gfind("Your Fireball hits Firetail Scorpid for 140. (445 blocked)", "You (%a%a?)\it (.+) for (%d+)\.%s?(%a?)") do DPSMate:SendMessage(d) end
-- /script for a,b,c,d,e in string.gfind("Your Fireball hits Firetail Scorpid for 140. (47 resisted)", "Your (.+) (%a%a?)\its (.+) for (%d+)(.*)\.%s?(.*)") do DPSMate:SendMessage(e) end
-- (...) 149 (Fire damage). (50 resisted) -> Some potential?
function DPSMate.Parser:SelfSpellDMG(msg)
	-- Filter out immune message -> using them?
	t = {}
	for a,b,c,d,e in strgfind(msg, "Your (.+) (%a%a?)\its (.+) for (%d+)(.*)\.%s?(.*)") do 
		t[1] = tnbr(d)
		if b=="h" then t[2]=1;t[3]=0 end
		if strfind(e, "blocked") then t[4]=1;t[2]=0;t[3]=0 end
		if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(player, a, c, GetTime()) end
		if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(player, player, a, true) end
		DB:EnemyDamage(true, DPSMateEDT, player, a,  t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], c, t[4] or 0, 0)
		DB:DamageDone(player, a, t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0)
		return
	end
	for a,b,c in strgfind(msg, "Your (.+) was (.-) by (.+)%.") do 
		if b=="dodged" then t[1]=1 elseif b=="blocked" then t[2]=1 else t[3]=1 end
		DB:EnemyDamage(true, DPSMateEDT, player, a, 0, 0, 0, 0, t[1] or 0, t[3] or 0, 0, c, t[2] or 0, 0)
		DB:DamageDone(player, a, 0, 0, 0, 0, t[1] or 0, t[3] or 0, 0, 0, t[2] or 0)
		return
	end
	for a,b in strgfind(msg, "Your (.+) is parried by (.+)%.") do 
		DB:EnemyDamage(true, DPSMateEDT, player, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
		DB:DamageDone(player, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
		return
	end
	for a,b in strgfind(msg, "Your (.+) missed (.+)%.") do 
		DB:EnemyDamage(true, DPSMateEDT, player, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
		DB:DamageDone(player, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	end
end

-- /script for a,b,c,d,e,f in string.gfind("IanUnderhill suffers 6 Nature damage from your Venom Sting. (6 resisted)", "(.+) suffers (%d+) (%a-) damage from (.+)(%'s?) (.+)%.") do DPSMate:SendMessage(d) end
function DPSMate.Parser:PeriodicDamage(msg)
	t = {}
	-- (NAME) is afflicted by (ABILITY). => Filtered out for now.
	for a,b in strgfind(msg, "(.+) is afflicted by (.+)%.") do DB:ConfirmAfflicted(a, b, GetTime()); return end
	-- School can be used now but how and when?
	for a,b,c,d,e in strgfind(msg, "(.+) suffers (%d+) (%a-) damage from (.+)'s (.+)%.") do
		t[1] = tnbr(b)
		DB:EnemyDamage(true, DPSMateEDT, d, e.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
		DB:DamageDone(d, e.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
		return
	end
	for a,b,c,d in strgfind(msg, "(.+) suffers (%d+) (%a-) damage from your (.+)%.") do
		t[1] = tnbr(b)
		DB:EnemyDamage(true, DPSMateEDT, player, d.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
		DB:DamageDone(player, d.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
		return
	end
end

-- immune and begins
function DPSMate.Parser:FriendlyPlayerDamage(msg)
	t = {}
	for f,a,b,c,d,e in strgfind(msg, "(.-)'s (.+) (%a%a?)\its (.+) for (%d+)(.*)\.%s?(.*)") do 
		t[1] = tnbr(d)
		if b=="h" then t[2]=1;t[3]=0 end
		if strfind(e, "blocked") then t[4]=1;t[2]=0;t[3]=0 end
		if d=="you" then d=player end
		if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, c, GetTime()) end
		if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
		DB:EnemyDamage(true, DPSMateEDT, f, a,  t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], c, t[4] or 0, 0)
		DB:DamageDone(f, a, t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0)
		return
	end
	for f,a,b,c in strgfind(msg, "(.-)'s (.+) was (.-) by (.+)%.") do 
		if b=="dodged" then t[1]=1 elseif b=="blocked" then t[2]=1 else t[3]=1 end
		DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, t[1] or 0, t[3] or 0, 0, c, t[2] or 0, 0)
		DB:DamageDone(f, a, 0, 0, 0, 0, t[1] or 0, t[3] or 0, 0, 0, t[2] or 0)
		return
	end
	for f,a,b in strgfind(msg, "(.-)'s (.+) is parried by (.+)%.") do
		DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
		DB:DamageDone(f, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
		return
	end
	for f,a,b in strgfind(msg, "(.-)'s (.+) missed (.+)%.") do 
		DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
		DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	end
	-- Hostile Player vs you
	for f,a,b in strgfind(msg, "(.-)'s (.+) was (.-)%.") do 
		if b=="dodged" then t[1]=1 elseif b=="blocked" then t[2]=1 elseif b=="parried" then t[4]=1 else t[3]=1 end
		DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, t[4] or 0, t[1] or 0, t[3] or 0, 0, player, t[2] or 0, 0)
		DB:DamageDone(f, a, 0, 0, 0, t[4] or 0, t[1] or 0, t[3] or 0, 0, 0, t[2] or 0)
		return
	end
	for f,a in strgfind(msg, "(.-)'s (.+) misses you%.") do 
		DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, player, 0, 0)
		DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	end
end

function DPSMate.Parser:FriendlyPlayerHits(msg)
	t = {}
	for a,b,c,d,e in strgfind(msg, "(.-) (%a%a?)\its (.+) for (%d+)\.%s?(.*)") do
		if b=="h" then t[3]=1;t[4]=0 end
		if e=="(glancing)" then t[1]=1;t[3]=0;t[4]=0 elseif e~="" then t[2]=1;t[3]=0;t[4]=0 end
		if c=="you" then c=player end
		t[5] = tnbr(d)
		DB:EnemyDamage(true, DPSMateEDT, a, "AutoAttack", t[3] or 0, t[4] or 1, 0, 0, 0, 0, t[5], c, t[2] or 0, t[1] or 0)
		DB:DamageDone(a, "AutoAttack", t[3] or 0, t[4] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
		return
	end
	-- (...). (608 absorbed/resisted) -> Therefore here some loss
	for a,b in strgfind(msg, "(.-) loses (%d+) health for swimming in lava%.") do
		DB:DamageTaken(a, "Lava", 1, 0, 0, 0, 0, 0, tnbr(b), "Environment", 0)
		return
	end
	for a,b in strgfind(msg, "(.-) falls and loses (%d+) health%.") do
		DB:DamageTaken(a, "Falling", 1, 0, 0, 0, 0, 0, tnbr(b), "Environment", 0)
		return
	end
	for a,b in strgfind(msg, "(.-) is drowning and loses (%d+) health%.") do
		DB:DamageTaken(a, "Drowning", 1, 0, 0, 0, 0, 0, tnbr(b), "Environment", 0)
		return
	end
end

function DPSMate.Parser:FriendlyPlayerMisses(msg)
	t = {}
	for a,b in strgfind(msg, "(.-) misses (.+)%.") do 
		if b=="you" then b=player end
		DB:EnemyDamage(true, DPSMateEDT, a, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
		DB:DamageDone(a, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	end
	for a,b,c in strgfind(msg, "(.-) attacks%. (.+) (%a-)%.") do 
		if c=="parries" or c=="parry" then t[1]=1 elseif c=="dodges" or c=="dodge" then t[2]=1 else t[3]=1 end 
		if b=="You" then b=player end
		DB:EnemyDamage(true, DPSMateEDT, a, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, b, t[3] or 0, 0)
		DB:DamageDone(a, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, 0, t[3] or 0)
		return
	end
end

-- You reflect 20 Holy damage to Razzashi Serpent.
function DPSMate.Parser:SpellDamageShieldsOnSelf(msg)
	for a,b,c in strgfind(msg, "You reflect (%d+) (%a-) damage to (.+)%.") do 
		local am = tnbr(a)
		DB:EnemyDamage(true, DPSMateEDT, player, "Reflection", 1, 0, 0, 0, 0, 0, am, c, 0, 0)
		DB:DamageDone(player, "Reflection", 1, 0, 0, 0, 0, 0, am, 0, 0)
	end
	
	-- The rebirth support
	for a,b,c in strgfind(msg, "Your (.+) was (.-) by (.+)%.") do 
		if b=="dodged" then t[1]=1 elseif b=="blocked" then t[2]=1 else t[3]=1 end
		DB:EnemyDamage(true, DPSMateEDT, player, a, 0, 0, 0, 0, t[1] or 0, t[3] or 0, 0, c, t[2] or 0, 0)
		DB:DamageDone(player, a, 0, 0, 0, 0, t[1] or 0, t[3] or 0, 0, 0, t[2] or 0)
		return
	end
	for a,b in strgfind(msg, "Your (.+) is parried by (.+)%.") do 
		DB:EnemyDamage(true, DPSMateEDT, player, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
		DB:DamageDone(player, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
		return
	end
	for a,b in strgfind(msg, "Your (.+) missed (.+)%.") do 
		DB:EnemyDamage(true, DPSMateEDT, player, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
		DB:DamageDone(player, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	end
end

-- Helboar reflects 4 Fire damage to you.
function DPSMate.Parser:SpellDamageShieldsOnOthers(msg)
	for a,b,c,d in strgfind(msg, "(.+) reflects (%d+) (%a-) damage to (.+)%.") do
		local am,ta = tnbr(b)
		if d == "you" then ta=player end
		DB:EnemyDamage(true, DPSMateEDT, a, "Reflection", 1, 0, 0, 0, 0, 0, am, ta or d, 0, 0)
		DB:DamageDone(a, "Reflection", 1, 0, 0, 0, 0, 0, am, 0, 0)
	end
	
	-- The rebirth support
	for f,a,b,c in strgfind(msg, "(.-)'s (.+) was (.-) by (.+)%.") do 
		if b=="dodged" then t[1]=1 elseif b=="blocked" then t[2]=1 else t[3]=1 end
		DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, t[1] or 0, t[3] or 0, 0, c, t[2] or 0, 0)
		DB:DamageDone(f, a, 0, 0, 0, 0, t[1] or 0, t[3] or 0, 0, 0, t[2] or 0)
		return
	end
	for f,a,b in strgfind(msg, "(.-)'s (.+) is parried by (.+)%.") do
		DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
		DB:DamageDone(f, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
		return
	end
	for f,a,b in strgfind(msg, "(.-)'s (.+) missed (.+)%.") do 
		DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
		DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	end
end

----------------------------------------------------------------------------------
--------------                    Damage taken                      --------------                                  
----------------------------------------------------------------------------------

-- War Reaver hits/crits you for 66 (Fire damage). (45 resisted)
function DPSMate.Parser:CreatureVsSelfHits(msg)
	t = {}
	for a,b,c,d in strgfind(msg, "(.+) (%a%a?)\its you for (%d+)(.*)") do
		if b=="h" then t[1]=1;t[2]=0 end
		if strfind(d, "crushing") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(d, "blocked") then t[4]=1;t[1]=0;t[2]=0 end
		t[5] = tnbr(c)
		DB:EnemyDamage(false, DPSMateEDD, player, "AutoAttack", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
		DB:DamageTaken(player, "AutoAttack", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0)
		DB:DeathHistory(player, a, "AutoAttack", t[5], t[1] or 0, t[2] or 1, 0, t[3] or 0)
		return
	end
end

-- Firetail Scorpid attacks. You parry.
-- Firetail Scorpid attacks. You dodge.
-- Firetail Scorpid misses you.
function DPSMate.Parser:CreatureVsSelfMisses(msg)
	t = {}
	for c in strgfind(msg, "(.+) attacks%. You absorb all the damage%.") do DB:Absorb("AutoAttack", player, c); return end
	for a in strgfind(msg, "(.+) misses you%.") do 
		DB:EnemyDamage(false, DPSMateEDD, player, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
		DB:DamageTaken(player, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, a, 0)
		return
	end
	for a,b in strgfind(msg, "(.+) attacks. You (.+)%.") do 
		if b=="parry" then t[1]=1 elseif b=="dodge" then t[2]=1 else t[3]=1 end 
		DB:EnemyDamage(false, DPSMateEDD, player, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, t[3] or 0, 0)
		DB:DamageTaken(player, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, 0)
		return
	end
end 

-- Thaurissan Spy performs Dazed on you. (Implementing it later) !!!!!
-- Thaurissan Spy's Poison was resisted.
-- Thaurissan Spy's Backstab hits/crits you for 116.
-- Flamekin Torcher's Fireball hits/crits you for 86 Fire damage. (School?)
function DPSMate.Parser:CreatureVsSelfSpellDamage(msg)
	t = {}
	for a,b,c,d,e in strgfind(msg, "(.+)'s (.+) (%a%a?)\its you for (%d+)(.*)") do -- Potential here to track school and resisted damage
		if c=="h" then t[1]=1;t[2]=0 end
		if strfind(e, "blocked") then t[4]=1 end
		t[3] = tnbr(d)
		DB:UnregisterPotentialKick(player, b, GetTime())
		DB:EnemyDamage(false, DPSMateEDD, player, b, t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[3], a, t[4] or 0, 0)
		DB:DamageTaken(player, b, t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[3], a, 0)
		DB:DeathHistory(player, a, b, t[3], t[1] or 0, t[2] or 1, 0, 0)
		return
	end
	for a,b in strgfind(msg, "(.+)'s (.+) misses you.") do
		DB:EnemyDamage(false, DPSMateEDD, player, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
		DB:DamageTaken(player, b, 0, 0, 1, 0, 0, 0, 0, a, 0)
		return
	end
	for a,b in strgfind(msg, "(.+)'s (.+) was parried.") do
		DB:EnemyDamage(false, DPSMateEDD, player, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
		DB:DamageTaken(player, b, 0, 0, 0, 1, 0, 0, 0, a, 0)
		return
	end
	for a,b in strgfind(msg, "(.+)'s (.+) was dodged.") do
		DB:EnemyDamage(false, DPSMateEDD, player, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
		DB:DamageTaken(player, b, 0, 0, 0, 0, 1, 0, 0, a, 0)
		return
	end
	for a,b in strgfind(msg, "(.+)'s (.+) was resisted.") do
		DB:EnemyDamage(false, DPSMateEDD, player, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
		DB:DamageTaken(player, b, 0, 0, 0, 0, 0, 1, 0, a, 0)
		return
	end
end

-- You are afflicted by Dazed. (Implementing it later maybe) !!!!!!
-- You are afflicted by Infected Bite.
-- You suffer 8 Nature damage from Ember Worg's Infected Bite. (3 resisted) (School? + resist?)
function DPSMate.Parser:PeriodicSelfDamage(msg)
	t = {}
	for a,b,c,d,e in strgfind(msg, "You suffer (%d+) (%a+) damage from (.+)'s (.+)%.(.*)") do -- Potential to track school and resisted damage
		t[1] = tnbr(a)
		DB:EnemyDamage(false, DPSMateEDD, player, d.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], c, 0, 0)
		DB:DamageTaken(player, d.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], c, 0)
		DB:DeathHistory(player, c, d.."(Periodic)", t[1], 1, 0, 0, 0)
		return
	end
	for a in strgfind(msg, "You are afflicted by (.+)%.") do
		DPSMate.DB:BuildBuffs("Unknown", player, a, false)
		return
	end
	for a,b,d,e in strgfind(msg, "You suffer (%d+) (%a+) damage from your (.+)%.(.*)") do -- Potential to track school and resisted damage
		t[1] = tnbr(a)
		DB:EnemyDamage(false, DPSMateEDD, player, d.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], player, 0, 0)
		DB:DamageTaken(player, d.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], player, 0)
		DB:DeathHistory(player, player, d.."(Periodic)", t[1], 1, 0, 0, 0)
		return
	end
end

-- Ember Worg hits/crits Ikaa for 58 (Fire damage). (41 resisted/blocked)
function DPSMate.Parser:CreatureVsCreatureHits(msg) 
	t = {}
	for a,b,c,d,e in strgfind(msg, "(.+) (%a%a?)\its (.+) for (%d+)(.*)") do
		if b=="h" then t[1]=1;t[2]=0 end
		if strfind(e, "crushing") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(e, "blocked") then t[4]=1;t[1]=0;t[2]=0 end
		t[5] = tnbr(d)
		DB:EnemyDamage(false, DPSMateEDD, c, "AutoAttack", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
		DB:DamageTaken(c, "AutoAttack", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0)
		DB:DeathHistory(c, a, "AutoAttack", t[5], t[1] or 0, t[2] or 1, 0, t[3] or 0)
		return
	end
end

-- Ember Worg attacks. Ikaa parries.
-- Ember Worg attacks. Ikaa dodges.
-- Ember Worg misses Ikaa.
-- Young Wolf attacks. Senpie absorbs all the damage.
function DPSMate.Parser:CreatureVsCreatureMisses(msg)
	t = {}
	for c, ta in strgfind(msg, "(.+) attacks%. (.+) absorbs all the damage%.") do DB:Absorb("AutoAttack", ta, c); return end
	for a,b,c in strgfind(msg, "(.+) attacks%. (.-) (.+)%.") do 
		if c=="parries" then t[1]=1 elseif c=="dodges" then t[2]=1 else t[3]=1 end 
		DB:EnemyDamage(false, DPSMateEDD, b, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, t[3] or 0, 0)
		DB:DamageTaken(b, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, 0)
		return
	end
	for a,b in strgfind(msg, "(.+) misses (.+)%.") do 
		DB:EnemyDamage(false, DPSMateEDD, b, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
		DB:DamageTaken(b, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, a, 0)
		return 
	end
end

-- Ikaa is afflicted by Infected Bite.
-- Ikaa suffers 15 Nature damage from Ember Worg's Infected Bite. (3 resisted)
function DPSMate.Parser:SpellPeriodicDamageTaken(msg)
	t = {}
	for a,b,c,d,e,f in strgfind(msg, "(.+) suffers (%d+) (%a+) damage from (.+)'s (.+)%.(.*)") do -- Potential to track resisted damage and school
		t[1] = tnbr(b)
		DB:EnemyDamage(false, DPSMateEDD, a, e.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], d, 0, 0)
		DB:DamageTaken(a, e.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], d, 0)
		DB:DeathHistory(a, d, e.."(Periodic)", t[1], 1, 0, 0, 0)
		return
	end
	for a, b in strgfind(msg, "(.+) is afflicted by (.+)%.") do
		DPSMate.DB:BuildBuffs("Unknown", a, b, false)
		return
	end
end

-- Black Broodling's Fireball was resisted by Ikaa.
-- Black Broodling's Fireball hits/crits Ikaa for 342 Fire damage. (100 resisted) (School + resist ?)
function DPSMate.Parser:CreatureVsCreatureSpellDamage(msg)
	t = {}
	for a,b,c,d,e,f in strgfind(msg, "(.+)'s (.+) (%a%a?)\its (.+) for (%d+)(.*)") do
		if c=="h" then t[1]=1;t[2]=0 end
		if strfind(f, "blocked") then t[4]=1 end
		t[3] = tnbr(e)
		DB:UnregisterPotentialKick(d, b, GetTime())
		DB:EnemyDamage(false, DPSMateEDD, d, b, t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[3], a, t[4] or 0, 0)
		DB:DamageTaken(d, b, t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[3], a, 0)
		DB:DeathHistory(d, a, b, t[3], t[1] or 0, t[2] or 1, 0, 0)
		return
	end
	for a,b,c in strgfind(msg, "(.+)'s (.+) was dodged by (.+)%.") do
		DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
		DB:DamageTaken(c, b, 0, 0, 0, 0, 1, 0, 0, a, 0)
		return
	end
	for a,b,c in strgfind(msg, "(.+)'s (.+) was parried by (.+)%.") do
		DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
		DB:DamageTaken(c, b, 0, 0, 0, 1, 0, 0, 0, a, 0)
		return
	end
	for a,b,c in strgfind(msg, "(.+)'s (.+) missed (.+)%.") do
		DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
		DB:DamageTaken(c, b, 0, 0, 1, 0, 0, 0, 0, a, 0)
		return
	end
	for a,b,c in strgfind(msg, "(.+)'s (.+) was resisted by (.+)%.") do
		DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
		DB:DamageTaken(c, b, 0, 0, 0, 0, 0, 1, 0, a, 0)
		return
	end
end

----------------------------------------------------------------------------------
--------------                       Healing                        --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Parser:GetUnitByName(target)
	local unit = self.TargetParty[target]
	if not unit then
		if target==UnitName("player") then
			unit="player"
		elseif target==UnitName("target") then
			unit="target"
		end
	end
	return unit
end

function DPSMate.Parser:GetOverhealByName(amount, target)
	local result, unit = 0, self:GetUnitByName(target)
	if unit then result = amount-(UnitHealthMax(unit)-UnitHealth(unit)) end
	if result<0 then return 0 else return result end 
end

-- Your Flash of Light heals you for 194.
-- Your Flash of Light critically heals you for 130.
-- You cast Purify on Minihunden.
-- Your Healing Potion heals you for 507.
-- You gain 25 Energy from Relentless Strikes Effect.
function DPSMate.Parser:SpellSelfBuff(msg)
	t = {}
	for a,b,c in strgfind(msg, "Your (.+) critically heals (.+) for (%d+)%.") do 
		if b=="you" then t[1]=player end
		t[2] = tnbr(c)
		overheal = self:GetOverhealByName(t[2], t[1] or b)
		DB:HealingTaken(DPSMateHealingTaken, t[1] or b, a, 0, 1, t[2], player)
		DB:HealingTaken(DPSMateEHealingTaken, t[1] or b, a, 0, 1, t[2]-overheal, player)
		DB:Healing(0, DPSMateEHealing, player, a, 0, 1, t[2]-overheal, t[1] or b)
		if overheal>0 then DB:Healing(2, DPSMateOverhealing, player, a, 0, 1, overheal, t[1] or b) end
		DB:Healing(1, DPSMateTHealing, player, a, 0, 1, t[2], t[1] or b)
		DB:DeathHistory(t[1] or b, player, a, t[2], 0, 1, 1, 0)
		return
	end
	for a,b,c in strgfind(msg, "Your (.+) heals (.+) for (%d+)%.") do 
		if b=="you" then t[1]=player end
		t[2] = tnbr(c)
		overheal = self:GetOverhealByName(t[2], t[1] or b)
		DB:HealingTaken(DPSMateHealingTaken, t[1] or b, a, 1, 0, t[2], player)
		DB:HealingTaken(DPSMateEHealingTaken, t[1] or b, a, 1, 0, t[2]-overheal, player)
		DB:Healing(0, DPSMateEHealing, player, a, 1, 0, t[2]-overheal, t[1] or b)
		if overheal>0 then DB:Healing(2, DPSMateOverhealing, player, a, 1, 0, overheal, t[1] or b) end
		DB:Healing(1, DPSMateTHealing, player, a, 1, 0, t[2], t[1] or b)
		DB:DeathHistory(t[1] or b, player, a, t[2], 1, 0, 1, 0)
		return
	end
	for a,b in strgfind(msg, "You gain (%d+) Energy from (.+)%.") do -- Potential to gain energy values for class evaluation
		DB:BuildBuffs(player, player, b, true)
		DB:DestroyBuffs(player, b)
		return
	end
	for a,b in strgfind(msg, "You gain (%d) extra attack through (.+)%.") do -- Potential for more evaluation
		DB:BuildBuffs(player, player, b, true)
		DB:DestroyBuffs(player, b)
		return
	end	
end

-- You gain First Aid.
-- You gain Mark of the Wild.
-- You gain Thorns.
-- You gain 11 health from First Aid.
-- You gain 61 health from Nenea's Rejuvenation.
function DPSMate.Parser:SpellPeriodicSelfBuff(msg) -- Maybe some loss here?
	t = {}
	for a,b,c in strgfind(msg, "You gain (%d+) health from (.+)'s (.+)%.") do
		t[1]=tnbr(a)
		overheal = self:GetOverhealByName(t[1], player)
		DB:HealingTaken(DPSMateHealingTaken, player, c.."(Periodic)", 1, 0, t[1], b)
		DB:HealingTaken(DPSMateEHealingTaken, player, c.."(Periodic)", 1, 0, t[1]-overheal, b)
		DB:Healing(0, DPSMateEHealing, b, c.."(Periodic)", 1, 0, t[1]-overheal, player)
		if overheal>0 then DB:Healing(2, DPSMateOverhealing, b, c.."(Periodic)", 1, 0, overheal, player) end
		DB:Healing(1, DPSMateTHealing, b, c.."(Periodic)", 1, 0, t[1], player)
		DB:DeathHistory(player, b, c.."(Periodic)", t[1], 1, 0, 1, 0)
		return
	end
	for a,b in strgfind(msg, "You gain (%d+) health from (.+)%.") do 
		t[1] = tnbr(a)
		overheal = self:GetOverhealByName(t[1], player)
		DB:HealingTaken(DPSMateHealingTaken, player, b.."(Periodic)", 1, 0, t[1], player)
		DB:HealingTaken(DPSMateEHealingTaken, player, b.."(Periodic)", 1, 0, t[1]-overheal, player)
		DB:Healing(0, DPSMateEHealing, player, b.."(Periodic)", 1, 0, t[1]-overheal, player)
		if overheal>0 then DB:Healing(2, DPSMateOverhealing, player, b.."(Periodic)", 1, 0, overheal, player) end
		DB:Healing(1, DPSMateTHealing, player, b.."(Periodic)", 1, 0, t[1], player)
		DB:DeathHistory(player, player, b.."(Periodic)", t[1], 1, 0, 1, 0)
		return
	end
	for a in strgfind(msg, "You gain (.+)%.") do
		if strfind(a, "from") then return end
		if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end -- Unstable Power (12)
		DB:ConfirmBuff(player, a, GetTime())
		if DPSMate.Parser.Dispels[a] then 
			DB:RegisterHotDispel(player, a)
			--DB:AwaitDispel(a, player, "Unknown", GetTime());
		end
		return 
	end
end

-- Catrala gains Last Stand.
-- Raptor gains 35 Happiness from Giggity's Feed Pet Effect. --> Causes error
-- Sivir gains 11 health from your First Aid.
-- Sivir gains 11 health from Albea's First Aid.
-- Soulstoke gains 25 Energy from Soulstoke's Relentless Strikes Effect.
function DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(msg)
	t = {}
	for f,a,b,c in strgfind(msg, "(.+) gains (%d+) health from (.+)'s (.+)%.") do
		t[1]=tnbr(a)
		overheal = self:GetOverhealByName(t[1], f)
		DB:HealingTaken(DPSMateHealingTaken, f, c.."(Periodic)", 1, 0, t[1], b)
		DB:HealingTaken(DPSMateEHealingTaken, f, c.."(Periodic)", 1, 0, t[1]-overheal, b)
		DB:Healing(0, DPSMateEHealing, b, c.."(Periodic)", 1, 0, t[1]-overheal, f)
		if overheal>0 then DB:Healing(2, DPSMateOverhealing, b, c.."(Periodic)", 1, 0, overheal, f) end
		DB:Healing(1, DPSMateTHealing, b, c.."(Periodic)", 1, 0, t[1], f)
		DB:DeathHistory(f, b, c.."(Periodic)", t[1], 1, 0, 1, 0)
		return
	end
	for f,a,b in strgfind(msg, "(.+) gains (%d+) health from your (.+)%.") do 
		t[1] = tnbr(a)
		overheal = self:GetOverhealByName(t[1], f)
		DB:HealingTaken(DPSMateHealingTaken, f, b.."(Periodic)", 1, 0, t[1], player)
		DB:HealingTaken(DPSMateEHealingTaken, f, b.."(Periodic)", 1, 0, t[1]-overheal, player)
		DB:Healing(0, DPSMateEHealing, player, b.."(Periodic)", 1, 0, t[1]-overheal)
		if overheal>0 then DB:Healing(2, DPSMateOverhealing, player, b.."(Periodic)", 1, 0, overheal) end
		DB:Healing(1, DPSMateTHealing, player, b.."(Periodic)", 1, 0, t[1])
		DB:DeathHistory(f, player, b.."(Periodic)", t[1], 1, 0, 1, 0)
		return
	end
	for f,a,b in strgfind(msg, "(.+) gains (%d+) health from (.+)%.") do 
		t[1] = tnbr(a)
		overheal = self:GetOverhealByName(t[1], f)
		DB:HealingTaken(DPSMateHealingTaken, f, b.."(Periodic)", 1, 0, t[1], f)
		DB:HealingTaken(DPSMateEHealingTaken, f, b.."(Periodic)", 1, 0, t[1]-overheal, f)
		DB:Healing(0, DPSMateEHealing, f, b.."(Periodic)", 1, 0, t[1]-overheal, f)
		if overheal>0 then DB:Healing(2, DPSMateOverhealing, f, b.."(Periodic)", 1, 0, overheal, f) end
		DB:Healing(1, DPSMateTHealing, f, b.."(Periodic)", 1, 0, t[1], f)
		DB:DeathHistory(f, f, b.."(Periodic)", t[1], 1, 0, 1, 0)
		return
	end
	for f,a in strgfind(msg, "(.+) gains (.+)%.") do
		if strfind(a, "from") then return end
		if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end -- Unstable Power (12)
		DB:ConfirmBuff(f, a, GetTime())
		if DPSMate.Parser.Dispels[a] then
			DB:RegisterHotDispel(f, a)
			--DB:AwaitDispel(a, f, "Unknown", GetTime());
		end
		return 
	end
end

-- A1bea's Flash of Light heals you/Baz for 90.
-- Albea's Flash of Light critically heals you/Baz for 135.
-- if strfind(msg, "begins to") or strfind(msg, "Rage") then return end
function DPSMate.Parser:SpellHostilePlayerBuff(msg)
	t = {}
	for a,b,c,d in strgfind(msg, "(.+)'s (.+) critically heals (.+) for (%d+)%.") do 
		t[1] = tnbr(d)
		if c=="you" then t[2]=player end
		overheal = self:GetOverhealByName(t[1], t[2] or c)
		DB:HealingTaken(DPSMateHealingTaken, t[2] or c, b, 0, 1, t[1], a)
		DB:HealingTaken(DPSMateEHealingTaken, t[2] or c, b, 0, 1, t[1]-overheal, a)
		DB:Healing(0, DPSMateEHealing, a, b, 0, 1, t[1]-overheal, t[2] or c)
		if overheal>0 then DB:Healing(2, DPSMateOverhealing, a, b, 0, 1, overheal, t[2] or c) end
		DB:Healing(1, DPSMateTHealing, a, b, 0, 1, t[1], t[2] or c)
		DB:DeathHistory(t[2] or c, a, b, t[1], 0, 1, 1, 0)
		return
	end
	for a,b,c,d in strgfind(msg, "(.+)'s (.+) heals (.+) for (%d+)%.") do 
		t[1] = tnbr(d)
		if c=="you" then t[2]=player end
		overheal = self:GetOverhealByName(t[1], t[2] or c)
		DB:HealingTaken(DPSMateHealingTaken, t[2] or c, b, 1, 0, t[1], a)
		DB:HealingTaken(DPSMateEHealingTaken, t[2] or c, b, 1, 0, t[1]-overheal, a)
		DB:Healing(0, DPSMateEHealing, a, b, 1, 0, t[1]-overheal, t[2] or c)
		if overheal>0 then DB:Healing(2, DPSMateOverhealing, a, b, 1, 0, overheal, t[2] or c) end
		DB:Healing(1, DPSMateTHealing, a, b, 1, 0, t[1], t[2] or c)
		DB:DeathHistory(t[2] or c, a, b, t[1], 1, 0, 1, 0)
		return
	end
	for a,b,c,d in strgfind(msg, "(.+) gains (%d+) Energy from (.+)'s (.+)%.") do
		DB:BuildBuffs(c, a, d, true)
		DB:DestroyBuffs(c, d)
		return 
	end
	for a,b,c in strgfind(msg, "(.+) gains (%d+) extra attack through (.+)%.") do
		DB:BuildBuffs(a, a, c, true)
		DB:DestroyBuffs(a, c)
		return 
	end
end

----------------------------------------------------------------------------------
--------------                       Absorbs                        --------------                                  
----------------------------------------------------------------------------------

-- Heavy War Golem hits/crits you for 8. (59 absorbed)
function DPSMate.Parser:CreatureVsSelfHitsAbsorb(msg)
	for c, b, a, absorbed in strgfind(msg, "(.+) (%a%a?)\its you for (.+)%. %((%d+) absorbed%)") do DB:SetUnregisterVariables(tnbr(absorbed), "AutoAttack", c) end
end

function DPSMate.Parser:CreatureVsCreatureHitsAbsorb(msg)
	for c, b, a, absorbed in strgfind(msg, "(.+) (%a%a?)\its (.+) for (.+)%. %((%d+) absorbed%)") do DB:SetUnregisterVariables(tnbr(absorbed), "AutoAttack", c) end
end

-- Heavy War Golem's Trample hits/crits you for 51 (Fire damage). (48 absorbed)
function DPSMate.Parser:CreatureVsSelfSpellDamageAbsorb(msg)
	for c, ab, b, a, absorbed in strgfind(msg, "(.+)'s (.+) (%a%a?)\its you for (.+)%. %((%d+) absorbed%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, c) end
end

function DPSMate.Parser:CreatureVsCreatureSpellDamageAbsorb(msg)
	for c, ab, b, a, x, absorbed in strgfind(msg, "(.+)'s (.+) (%a%a?)\its (.+) for (.+)%. %((%d+) absorbed%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, c) end
end

function DPSMate.Parser:SpellPeriodicSelfBuffAbsorb(msg)
	for ab in strgfind(msg, "You gain (.+)%.") do if DB.ShieldFlags[ab] then DB:ConfirmAbsorbApplication(ab, player, GetTime()) end end
end

function DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffsAbsorb(msg)
	for ta, ab in strgfind(msg, "(.+) gains (.+)%.") do if DB.ShieldFlags[ab] then DB:ConfirmAbsorbApplication(ab, ta, GetTime()) end end
end

-- Power Word: Shield fades from you.
function DPSMate.Parser:SpellAuraGoneSelf(msg)
	for ab in strgfind(msg, "(.+) fades from you%.") do if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, player) end; DB:DestroyBuffs(player, ab); DB:UnregisterHotDispel(player, ab) end
end

-- Power Word: Shield fades from Senpie.
function DPSMate.Parser:SpellAuraGoneParty(msg)
	--DPSMate:SendMessage(msg)
	for ab, ta in strgfind(msg, "(.+) fades from (.+)%.") do if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, ta) end; DB:DestroyBuffs(ta, ab); DB:UnregisterHotDispel(ta, ab) end
end

function DPSMate.Parser:SpellAuraGoneOther(msg)
	for ab, ta in strgfind(msg, "(.+) fades from (.+)%.") do if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, ta) end; DB:DestroyBuffs(ta, ab); DB:UnregisterHotDispel(ta, ab) end
end

----------------------------------------------------------------------------------
--------------                       Dispels                        --------------                                  
----------------------------------------------------------------------------------

DPSMate.Parser.Dispels = {
	["Remove Curse"] = true,
	["Cleanse"] = true,
	["Remove Lesser Curse"] = true,
	["Purify"] = true,
	["Dispel Magic"] = true,
	["Abolish Poison"] = true,
	["Abolish Disease"] = true,
	["Devour Magic"] = true,
	["Cure Disease"] = true,
	["Poison Cleansing Totem"] = true,
	["Cure Poison"] = true,
	["Disease Cleansing Totem"] = true,
	["Purge"] = true,
}
DPSMate.Parser.DeCurse = {
	[1] = "Remove Curse",
	[2] = "Remove Lesser Curse",
}
DPSMate.Parser.DeMagic = {
	[1] = "Cleanse",
	[2] = "Dispel Magic",
	[3] = "Devour Magic",
	[4] = "Purge"
}
DPSMate.Parser.DeDisease = {
	[1] = "Cleanse",
	[2] = "Purify",
	[3] = "Abolish Disease",
	[4] = "Cure Disease",
	[5] = "Disease Cleansing Totem"
}
DPSMate.Parser.DePoison = {
	[1] = "Cleanse",
	[2] = "Abolish Poison",
	[3] = "Purify",
	[4] = "Poison Cleansing Totem",
	[5] = "Cure Poison"
}
DPSMate.Parser.DebuffTypes = {}
DPSMate.Parser.HotDispels = {
	["Abolish Poison"] = true,
	["Abolish Disease"] = true,
}
-- You gain Abolish Poison.
-- Abolish Poison fades from you.
-- Your Poison is removed.

-- The totem aura just reports a removed event in the chat.
-- Maybe we can guess here?
function DPSMate.Parser:UnitAuraDispels(unit)
	if unit=="player" or unit=="target" then
		for i=1, 16 do
			DPSMate_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
			DPSMate_Tooltip:ClearLines()
			DPSMate_Tooltip:SetUnitDebuff(unit, i, "HARMFUL")
			local aura = DPSMate_TooltipTextLeft1:GetText()
			local type = DPSMate_TooltipTextRight1:GetText()
			DPSMate_Tooltip:Hide()
			if not aura then break end
			DB:BuildAbility(aura, type)
			DPSMateAbility[aura][2] = type
		end
	end
end

-- Is it really "yourself"?
function DPSMate.Parser:SpellSelfBuffDispels(msg)
	for ab, tar in strgfind(msg, "You cast (.+) on (.+)%.") do if DPSMate.Parser.Dispels[ab] then DB:AwaitDispel(ab, tar, player, GetTime()) end; return end
	for ab in strgfind(msg, "You cast (.+)%.") do if DPSMate.Parser.Dispels[ab] then DB:AwaitDispel(ab, "Unknown", player, GetTime()) end; return end
end

-- Avrora casts Remove Curse on you.
-- Avrora casts Remove Curse on Avrora.
function DPSMate.Parser:SpellHostilePlayerBuffDispels(msg)
	for c, ab, ta in strgfind(msg, "(.+) casts (.+) on (.+)%.") do if DPSMate.Parser.Dispels[ab] then if ta=="you" then DB:AwaitDispel(ab, player, c, GetTime()) else  DB:AwaitDispel(ab, ta, c, GetTime()) end end; return end
	for c, ab in strgfind(msg, "(.+) casts (.+)%.") do if DPSMate.Parser.Dispels[ab] then DB:AwaitDispel(ab, "Unknown", c, GetTime()) end; return end
end

-- Avrora's  Curse of Agony is removed.
-- Your Curse of Agony is removed.
function DPSMate.Parser:SpellBreakAura(msg) 
	for ta, ab in strgfind(msg, "(.+)'s (.+) is removed.") do DB:ConfirmRealDispel(ab, ta, GetTime()); return end
	for ab in strgfind(msg, "Your (.+) is removed.") do DB:ConfirmRealDispel(ab, player, GetTime()); return end
end

----------------------------------------------------------------------------------
--------------                       Deaths                         --------------                                  
----------------------------------------------------------------------------------

-- You die.
-- Senpie dies.
function DPSMate.Parser:CombatFriendlyDeath(msg)
	for ta in strgfind(msg, "(.-) (.-)%.") do if ta=="You" then DB:UnregisterDeath(player) else DB:UnregisterDeath(ta) end end
end

function DPSMate.Parser:CombatHostileDeaths(msg)
	for ta in strgfind(msg, "(.+) dies%.") do 
		DB:UnregisterDeath(ta)
		DB:Attempt(false, true, ta)
	end
end

----------------------------------------------------------------------------------
--------------                     Interrupts                       --------------                                  
----------------------------------------------------------------------------------

DPSMate.Parser.Kicks = {
	-- Interrupts
	-- Rogue
	["Kick"] = true,
	-- Warrior
	["Pummel"] = true,
	["Shield Bash"] = true,
	
	-- Mage
	["Counterspell"] = true,
	
	-- Stuns
	-- Rogue
	["Gouge"] = true,
	["Kidney Shot"] = true,
	["Cheap Shot"] = true,
	
	-- Hunter
	["Scatter Shot"] = true,
	
	-- Warrior
	["Charge Stun"] = true,
	["Intercept Stun"] = true,
	["Concussion Blow"] = true,
}

-- Scalding Broodling begins to cast Fireball.
function DPSMate.Parser:CreatureVsCreatureSpellDamageInterrupts(msg)
	for c, ab in strgfind(msg, "(.+) begins to cast (.+)%.") do DB:RegisterPotentialKick(c, ab, GetTime()); return end
	for c, ab in strgfind(msg, "(.+) begins to perform (.+)%.") do DB:RegisterPotentialKick(c, ab, GetTime()) end
end
function DPSMate.Parser:HostilePlayerSpellDamageInterrupts(msg)
	for c, ab in strgfind(msg, "(.-) begins to cast (.+)%.") do DB:RegisterPotentialKick(c, ab, GetTime()); return end
	for c, ab in strgfind(msg, "(.-) begins to perform (.+)%.") do DB:RegisterPotentialKick(c, ab, GetTime()) end
end

-- Legacy Logs support
-- You receive loot: [White Spider Meat] (Itemlink)
-- Shino receives loot: [White Spider Meat] (Itemlink)
-- Itemlink: \124cffffffff\124Hitem:8956:0:0:0:0:0:0:0:0\124h[Oil of Immolation]\124h\124r (White)
-- Itemlink: \124cffa335ee\124Hitem:19352:0:0:0:0:0:0:0:0\124h[Chromatically Tempered Sword]\124h\124r (Epic)
local linkQuality = {
	["9d9d9d"] = 0,
	["ffffff"] = 1,
	["1eff00"] = 2,
	["0070dd"] = 3,
	["a335ee"] = 4,
	["ff8000"] = 5
}
function DPSMate.Parser:Loot(msg)
	for a,b,c,d,e in strgfind(msg, "(.-) receives loot: |cff(.-)|Hitem:(%d+)(.+)%[(.+)%]|h|r") do
		DPSMate.DB:Loot(a, linkQuality[b], tnbr(c), e)
		return
	end
	for a,b,c,d in strgfind(msg, "You receive loot: |cff(.-)|Hitem:(%d+)(.+)%[(.+)%]|h|r") do
		DPSMate.DB:Loot(player, linkQuality[a], tnbr(b), d)
		return
	end
end

-- Pet section

function DPSMate.Parser:PetHits(msg)
	t = {}
	for a,b,c,d,e in strgfind(msg, "(.-) (%a%a?)\its (.+) for (%d+)\.%s?(.*)") do
		if b=="h" then t[3]=1;t[4]=0 end
		if e=="(glancing)" then t[1]=1;t[3]=0;t[4]=0 elseif e~="" then t[2]=1;t[3]=0;t[4]=0 end
		if c=="you" then c=player end
		t[5] = tnbr(d)
		DB:EnemyDamage(true, DPSMateEDT, a, "AutoAttack", t[3] or 0, t[4] or 1, 0, 0, 0, 0, t[5], c, t[2] or 0, t[1] or 0)
		DB:DamageDone(a, "AutoAttack", t[3] or 0, t[4] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
		return
	end
end

function DPSMate.Parser:PetMisses(msg)
	t = {}
	for a,b in strgfind(msg, "(.-) misses (.+)%.") do 
		if b=="you" then b=player end
		DB:EnemyDamage(true, DPSMateEDT, a, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
		DB:DamageDone(a, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	end
	for a,b,c in strgfind(msg, "(.-) attacks%. (.+) (%a-)%.") do 
		if c=="parries" or c=="parry" then t[1]=1 elseif c=="dodges" or c=="dodge" then t[2]=1 else t[3]=1 end 
		if b=="You" then b=player end
		DB:EnemyDamage(true, DPSMateEDT, a, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, b, t[3] or 0, 0)
		DB:DamageDone(a, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, 0, t[3] or 0)
		return
	end
end

-- Marktast casts bla on bla.
function DPSMate.Parser:PetSpellDamage(msg)
	t = {}
	for f,a,b,c,d,e in strgfind(msg, "(.-)'s (.+) (%a%a?)\its (.+) for (%d+)(.*)\.%s?(.*)") do 
		t[1] = tnbr(d)
		if b=="h" then t[2]=1;t[3]=0 end
		if strfind(e, "blocked") then t[4]=1;t[2]=0;t[3]=0 end
		if d=="you" then d=player end
		DB:EnemyDamage(true, DPSMateEDT, f, a,  t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], c, t[4] or 0, 0)
		DB:DamageDone(f, a, t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0)
		return
	end
	for a,b,c in strgfind(msg, "(.-)'s (.+) was resisted by (.+)%.") do 
		if d=="you" then d=player end
		DB:EnemyDamage(true, DPSMateEDT, a, b,  0, 0, 0, 0, 0, 1, 0, c, t[4] or 0, 0)
		DB:DamageDone(a, c, 0, 0, 0, 0, 0, 1, 0, 0, 0)
		return
	end
	for f,a,b,c in strgfind(msg, "(.-)'s (.+) was (.-) by (.+)%.") do 
		if b=="dodged" then t[1]=1 elseif b=="blocked" then t[2]=1 else t[3]=1 end
		DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, t[1] or 0, t[3] or 0, 0, c, t[2] or 0, 0)
		DB:DamageDone(f, a, 0, 0, 0, 0, t[1] or 0, t[3] or 0, 0, 0, t[2] or 0)
		return
	end
	for f,a,b in strgfind(msg, "(.-)'s (.+) is parried by (.+)%.") do
		DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
		DB:DamageDone(f, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
		return
	end
	for f,a,b in strgfind(msg, "(.-)'s (.+) missed (.+)%.") do 
		DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
		DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	end
end

Execute = {
	["CHAT_MSG_COMBAT_HOSTILE_DEATH"] = function(arg1) DPSMate.Parser:CombatHostileDeaths(arg1) end,
	["CHAT_MSG_COMBAT_FRIENDLY_DEATH"] = function(arg1) DPSMate.Parser:CombatFriendlyDeath(arg1) end,
	["UNIT_AURA"] = function(arg1) DPSMate.Parser:UnitAuraDispels(arg1) end, -- !
	["CHAT_MSG_SPELL_BREAK_AURA"] = function(arg1) DPSMate.Parser:SpellBreakAura(arg1) end,
	["CHAT_MSG_SPELL_AURA_GONE_PARTY"] = function(arg1) DPSMate.Parser:SpellAuraGoneParty(arg1) end,
	["CHAT_MSG_SPELL_AURA_GONE_OTHER"] = function(arg1) DPSMate.Parser:SpellAuraGoneOther(arg1) end,
	["CHAT_MSG_SPELL_AURA_GONE_SELF"] = function(arg1) DPSMate.Parser:SpellAuraGoneSelf(arg1) end,
	["CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS"] = function(arg1) DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(arg1);DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffsAbsorb(arg1) end,
	["CHAT_MSG_SPELL_PARTY_BUFF"] = function(arg1) DPSMate.Parser:SpellHostilePlayerBuff(arg1);DPSMate.Parser:SpellHostilePlayerBuffDispels(arg1) end,
	["CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS"] = function(arg1) DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(arg1);DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffsAbsorb(arg1) end,
	["CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF"] = function(arg1) DPSMate.Parser:SpellHostilePlayerBuff(arg1);DPSMate.Parser:SpellHostilePlayerBuffDispels(arg1);DPSMate.Parser:HostilePlayerSpellDamageInterrupts(arg1) end,
	["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS"] = function(arg1) DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(arg1);DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffsAbsorb(arg1) end,
	["CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF"] = function(arg1) DPSMate.Parser:SpellHostilePlayerBuff(arg1);DPSMate.Parser:SpellHostilePlayerBuffDispels(arg1) end,
	["CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS"] = function(arg1) DPSMate.Parser:SpellPeriodicSelfBuff(arg1);DPSMate.Parser:SpellPeriodicSelfBuffAbsorb(arg1) end,
	["CHAT_MSG_SPELL_SELF_BUFF"] = function(arg1) DPSMate.Parser:SpellSelfBuff(arg1);DPSMate.Parser:SpellSelfBuffDispels(arg1) end,
	["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE"] = function(arg1) DPSMate.Parser:SpellPeriodicDamageTaken(arg1) end,
	["CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"] = function(arg1) DPSMate.Parser:CreatureVsCreatureSpellDamage(arg1);DPSMate.Parser:CreatureVsCreatureSpellDamageAbsorb(arg1);DPSMate.Parser:CreatureVsCreatureSpellDamageInterrupts(arg1) end,
	["CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES"] = function(arg1) DPSMate.Parser:CreatureVsCreatureMisses(arg1) end,
	["CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS"] = function(arg1) DPSMate.Parser:CreatureVsCreatureHits(arg1);DPSMate.Parser:CreatureVsCreatureHitsAbsorb(arg1) end,
	["CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE"] = function(arg1) DPSMate.Parser:CreatureVsCreatureSpellDamage(arg1);DPSMate.Parser:CreatureVsCreatureSpellDamageAbsorb(arg1) end,
	["CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE"] = function(arg1) DPSMate.Parser:SpellPeriodicDamageTaken(arg1) end,
	["CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES"] = function(arg1) DPSMate.Parser:CreatureVsCreatureMisses(arg1) end,
	["CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS"] = function(arg1) DPSMate.Parser:CreatureVsCreatureHits(arg1);DPSMate.Parser:CreatureVsCreatureHitsAbsorb(arg1) end,
	["CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE"] = function(arg1) DPSMate.Parser:PeriodicSelfDamage(arg1) end,
	["CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"] = function(arg1) DPSMate.Parser:CreatureVsSelfSpellDamage(arg1);DPSMate.Parser:CreatureVsSelfSpellDamageAbsorb(arg1) end,
	["CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES"] = function(arg1) DPSMate.Parser:CreatureVsSelfMisses(arg1) end,
	["CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS"] = function(arg1) DPSMate.Parser:CreatureVsSelfHits(arg1);DPSMate.Parser:CreatureVsSelfHitsAbsorb(arg1) end,
	["CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS"] = function(arg1) DPSMate.Parser:SpellDamageShieldsOnOthers(arg1) end,
	["CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF"] = function(arg1) DPSMate.Parser:SpellDamageShieldsOnSelf(arg1) end,
	["CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES"] = function(arg1) DPSMate.Parser:FriendlyPlayerMisses(arg1) end,
	["CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES"] = function(arg1) DPSMate.Parser:FriendlyPlayerMisses(arg1) end,
	["CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS"] = function(arg1) DPSMate.Parser:FriendlyPlayerHits(arg1) end,
	["CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS"] = function(arg1) DPSMate.Parser:FriendlyPlayerHits(arg1) end,
	["CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE"] = function(arg1) DPSMate.Parser:FriendlyPlayerDamage(arg1) end,
	["CHAT_MSG_SPELL_PARTY_DAMAGE"] = function(arg1) DPSMate.Parser:FriendlyPlayerDamage(arg1) end,
	["CHAT_MSG_COMBAT_PARTY_MISSES"] = function(arg1) DPSMate.Parser:FriendlyPlayerMisses(arg1) end,
	["CHAT_MSG_COMBAT_PARTY_HITS"] = function(arg1) DPSMate.Parser:FriendlyPlayerHits(arg1) end,
	["CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE"] = function(arg1) DPSMate.Parser:PeriodicDamage(arg1) end,
	["CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE"] = function(arg1) DPSMate.Parser:FriendlyPlayerDamage(arg1) end,
	["CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE"] = function(arg1) DPSMate.Parser:PeriodicDamage(arg1) end, -- To be tested
	["CHAT_MSG_SPELL_SELF_DAMAGE"] = function(arg1) DPSMate.Parser:SelfSpellDMG(arg1) end,
	["CHAT_MSG_COMBAT_SELF_MISSES"] = function(arg1) DPSMate.Parser:SelfMisses(arg1) end,
	["CHAT_MSG_COMBAT_SELF_HITS"] = function(arg1) DPSMate.Parser:SelfHits(arg1) end,
	["CHAT_MSG_LOOT"] = function(arg1) DPSMate.Parser:Loot(arg1) end,
	["CHAT_MSG_COMBAT_PET_HITS"] = function(arg1) DPSMate.Parser:PetHits(arg1) end,
	["CHAT_MSG_COMBAT_PET_MISSES"] = function(arg1) DPSMate.Parser:PetMisses(arg1) end,
	--["CHAT_MSG_SPELL_PET_BUFF"] = function(arg1) DPSMate:SendMessage(arg1.."Test 3"); end,
	["CHAT_MSG_SPELL_PET_DAMAGE"] = function(arg1) DPSMate.Parser:PetSpellDamage(arg1) end
}