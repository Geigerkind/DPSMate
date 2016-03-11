-- Notes
-- "Smbd reflects..." (Thorns etc.)
-- (%s%(%a-%))
-- /script local t = {}; for a,b,c,d in string.gfind("You hit Peter Hallow for 184.", "You (%a%a?)\it (.+) for (%d+)%.%s?(.*)") do t[1]=a;t[2]=b;t[3]=c;t[4]=d end; DPSMate:SendMessage(t[3]); DPSMate:SendMessage(t[4])

-- Global Variables
DPSMate.Parser.procs = {
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
	"Hand of Justice",
	"Sword Specialization",
	
	-- Rogue
	"Slice and Dice",
	"Blade Flurry",
	"Sprint",
	"Adrenaline Rush",
	"Vanish",
	"Relentless Strikes Effect",
	"Rogue Armor Energize Effect",
	
	-- Mage
	"Arcane Power",
	"Combustion",
	"Mind Quickening",
	
	-- Priest
	"Power Infusion",
	
	-- Druid
}

-- Local Variables
local player = UnitName("player")
local _,playerclass = UnitClass("player")
local strgfind = string.gfind
local t = {}

-- Begin Functions

function DPSMate.Parser:OnLoad()
	DPSMate.DB:BuildUser(playername, strlower(playerclass))
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
		if arg1 then DPSMate.Parser:PeriodicDamage(arg1) end
	elseif event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" then
		if arg1 then DPSMate.Parser:FriendlyPlayerDamage(arg1) end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
		if arg1 then DPSMate.Parser:PeriodicDamage(arg1) end 
	elseif event == "CHAT_MSG_COMBAT_PARTY_HITS" then
		if arg1 then DPSMate.Parser:FriendlyPlayerHits(arg1) end
	elseif event == "CHAT_MSG_COMBAT_PARTY_MISSES" then
		if arg1 then DPSMate.Parser:FriendlyPlayerMisses(arg1) end 
	elseif event == "CHAT_MSG_SPELL_PARTY_DAMAGE" then 
		if arg1 then DPSMate.Parser:FriendlyPlayerDamage(arg1) end
	elseif event == "CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE" then
		if arg1 then DPSMate.Parser:FriendlyPlayerDamage(arg1) end
	elseif event == "CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS" then
		if arg1 then DPSMate.Parser:FriendlyPlayerHits(arg1) end
	elseif event == "CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES" then
		if arg1 then DPSMate.Parser:FriendlyPlayerMisses(arg1) end
	elseif event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF" then
		if arg1 then DPSMate.Parser:SpellDamageShieldsOnSelf(arg1) end
	elseif event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS" then
		if arg1 then DPSMate.Parser:SpellDamageShieldsOnOthers(arg1) end
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
		if arg1 then 
			DPSMate.Parser:PeriodicSelfDamage(arg1) 
		end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS" then
		if arg1 then 
			DPSMate.Parser:CreatureVsCreatureHits(arg1) 
			DPSMate.Parser:CreatureVsCreatureHitsAbsorb(arg1)
		end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES" then
		if arg1 then 
			DPSMate.Parser:CreatureVsCreatureMisses(arg1)
			DPSMate.Parser:CreatureVsCreatureMissesAbsorb(arg1)			
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE" then
		if arg1 then 
			DPSMate.Parser:SpellPeriodicDamageTaken(arg1) 
		end
	elseif event == "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE" then
		if arg1 then 
			DPSMate.Parser:CreatureVsCreatureSpellDamage(arg1) 
			DPSMate.Parser:CreatureVsCreatureSpellDamageAbsorb(arg1)
		end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS" then
		if arg1 then 
			DPSMate.Parser:CreatureVsCreatureHits(arg1) 
			DPSMate.Parser:CreatureVsCreatureHitsAbsorb(arg1)
		end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES" then
		if arg1 then 
			DPSMate.Parser:CreatureVsCreatureMisses(arg1) 
			DPSMate.Parser:CreatureVsCreatureMissesAbsorb(arg1)
		end
	elseif event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE" then
		if arg1 then 
			DPSMate.Parser:CreatureVsCreatureSpellDamage(arg1)
			DPSMate.Parser:CreatureVsCreatureSpellDamageAbsorb(arg1)
			DPSMate.Parser:CreatureVsCreatureSpellDamageInterrupts(arg1)
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE" then
		if arg1 then 
			DPSMate.Parser:SpellPeriodicDamageTaken(arg1) 
		end
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
		if arg1 then 
			DPSMate.Parser:SpellHostilePlayerBuff(arg1) 
			DPSMate.Parser:SpellHostilePlayerBuffDispels(arg1)
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS" then
		if arg1 then 
			DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(arg1)
			DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffsAbsorb(arg1)
		end
	elseif event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF" then
		if arg1 then 
			DPSMate.Parser:SpellHostilePlayerBuff(arg1) 
			DPSMate.Parser:SpellHostilePlayerBuffDispels(arg1)
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS" then
		if arg1 then 
			DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(arg1)
			DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffsAbsorb(arg1)
		end
	elseif event == "CHAT_MSG_SPELL_PARTY_BUFF" then
		if arg1 then 
			DPSMate.Parser:SpellHostilePlayerBuff(arg1)
			DPSMate.Parser:SpellHostilePlayerBuffDispels(arg1)
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS" then
		if arg1 then 
			DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(arg1)
			DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffsAbsorb(arg1)
		end
	-- Absorb
	elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" then
		if arg1 then DPSMate.Parser:SpellAuraGoneSelf(arg1) end
	elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" then
		if arg1 then DPSMate.Parser:SpellAuraGoneOther(arg1) end
	elseif event == "CHAT_MSG_SPELL_AURA_GONE_PARTY" then
		if arg1 then DPSMate.Parser:SpellAuraGoneParty(arg1) end
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
		DPSMate.DB:EnemyDamage(DPSMateEDT, player, "AutoAttack", t[1] or 0, t[2] or 1, 0, 0, 0, 0, tonumber(c), b, t[4] or 0, t[3] or 0)
		DPSMate.DB:DamageDone(player, "AutoAttack", t[1] or 0, t[2] or 1, 0, 0, 0, 0, tonumber(c), t[3] or 0, t[4] or 0)
		return
	end
	for a in strgfind(msg, "You fall and lose (%d+) health%.") do
		DPSMate.DB:DamageTaken(player, "Falling", 1, 0, 0, 0, 0, 0, tonumber(a), "Environment", 0)
		return
	end
	for a in strgfind(msg, "You lose (%d+) health for swimming in lava%.") do
		DPSMate.DB:DamageTaken(player, "Lava", 1, 0, 0, 0, 0, 0, tonumber(a), "Environment", 0)
		return
	end
	for a in strgfind(msg, "You are drowning and lose (%d+) health%.") do
		DPSMate.DB:DamageTaken(player, "Drowning", 1, 0, 0, 0, 0, 0, tonumber(a), "Environment", 0)
		return
	end
end

function DPSMate.Parser:SelfMisses(msg)
	-- Filter out immune message --> using them?
	t = {}
	for a in strgfind(msg, "You miss (.+)%.") do 
		DPSMate.DB:EnemyDamage(DPSMateEDT, player, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
		DPSMate.DB:DamageDone(player, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	end
	for a,b in strgfind(msg, "You attack%. (.+) (%a-)%.") do 
		if b=="parries" then t[1]=1 elseif b=="dodges" then t[2]=1 else t[3]=1 end
		DPSMate.DB:EnemyDamage(DPSMateEDT, player, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, t[3] or 0, 0)
		DPSMate.DB:DamageDone(player, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, 0, t[3] or 0)
	end
end

-- /script for a,b,c,d in string.gfind("You hit Firetail Scorpid for 140. (445 blocked)", "You (%a%a?)\it (.+) for (%d+)\.%s?(%a?)") do if e ~= "" then DPSMate:SendMessage(d) else DPSMate:SendMessage("Test") end end
-- (...) 149 (Fire damage). (50 resisted) -> Some potential?
function DPSMate.Parser:SelfSpellDMG(msg)
	-- Filter out immune message -> using them?
	t = {}
	for a,b,c,d,e in strgfind(msg, "Your (.+) (%a%a?)\its (.+) for (%d+)(.*)\.%s?(.*)") do 
		t[1] = tonumber(d)
		if b=="h" then t[2]=1;t[3]=0 end
		if e ~= "" then t[4]=1;t[2]=0;t[3]=0 end
		if DPSMate:TContains(DPSMate.Parser.Kicks, a) then DPSMate.DB:AssignPotentialKick(player, a, c, GetTime()) end
		DPSMate.DB:EnemyDamage(DPSMateEDT, player, a,  t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], c, t[4] or 0, 0)
		DPSMate.DB:DamageDone(player, a, t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0)
		return
	end
	for a,b,c in strgfind(msg, "Your (.+) was (.-) by (.+)%.") do 
		if b=="dodged" then t[1]=1 elseif b=="blocked" then t[2]=1 else t[3]=1 end
		DPSMate.DB:EnemyDamage(DPSMateEDT, player, a, 0, 0, 0, 0, t[1] or 0, t[3] or 0, 0, c, t[2] or 0, 0)
		DPSMate.DB:DamageDone(player, a, 0, 0, 0, 0, t[1] or 0, t[3] or 0, 0, 0, t[2] or 0)
		return
	end
	for a,b in strgfind(msg, "Your (.+) is parried by (.+)%.") do 
		DPSMate.DB:EnemyDamage(DPSMateEDT, player, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
		DPSMate.DB:DamageDone(player, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
		return
	end
	for a,b in strgfind(msg, "Your (.+) missed (.+)%.") do 
		DPSMate.DB:EnemyDamage(DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
		DPSMate.DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	end
end

-- /script for a,b,c,d,e,f in string.gfind("IanUnderhill suffers 6 Nature damage from your Venom Sting. (6 resisted)", "(.+) suffers (%d+) (%a-) damage from (.+)(%'s?) (.+)%.") do DPSMate:SendMessage(d) end
function DPSMate.Parser:PeriodicDamage(msg)
	t = {}
	-- (NAME) is afflicted by (ABILITY). => Filtered out for now.
	for a,b in strgfind(msg, "(.+) is afflicted by (.+)%.") do if DPSMate:TContains(DPSMate.Parser.Kicks, b) then DPSMate.DB:ConfirmAfflictedStun(a, b, GetTime()) end; return end
	-- School can be used now but how and when?
	for a,b,c,d,e in strgfind(msg, "(.+) suffers (%d+) (%a-) damage from (.+)'s (.+)%.") do
		t[1] = tonumber(b)
		DPSMate.DB:EnemyDamage(DPSMateEDT, a, e.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], d, 0, 0)
		DPSMate.DB:DamageDone(d, e.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
		return
	end
	for a,b,c,d in strgfind(msg, "(.+) suffers (%d+) (%a-) damage from your (.+)%.") do
		t[1] = tonumber(b)
		DPSMate.DB:EnemyDamage(DPSMateEDT, a, d.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], player, 0, 0)
		DPSMate.DB:DamageDone(player, d.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
		return
	end
end

-- immune and begins
function DPSMate.Parser:FriendlyPlayerDamage(msg)
	t = {}
	for f,a,b,c,d,e in strgfind(msg, "(.-)'s (.+) (%a%a?)\its (.+) for (%d+)(.*)\.%s?(.*)") do 
		t[1] = tonumber(d)
		if b=="h" then t[2]=1;t[3]=0 end
		if e ~= "" then t[4]=1;t[2]=0;t[3]=0 end
		if DPSMate:TContains(DPSMate.Parser.Kicks, a) then DPSMate.DB:AssignPotentialKick(f, a, c, GetTime()) end
		DPSMate.DB:EnemyDamage(DPSMateEDT, f, a,  t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], c, t[4] or 0, 0)
		DPSMate.DB:DamageDone(f, a, t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0)
		return
	end
	for f,a,b,c in strgfind(msg, "(.-)'s (.+) was (.-) by (.+)%.") do 
		if b=="dodged" then t[1]=1 elseif b=="blocked" then t[2]=1 else t[3]=1 end
		DPSMate.DB:EnemyDamage(DPSMateEDT, f, a, 0, 0, 0, 0, t[1] or 0, t[3] or 0, 0, c, t[2] or 0, 0)
		DPSMate.DB:DamageDone(f, a, 0, 0, 0, 0, t[1] or 0, t[3] or 0, 0, 0, t[2] or 0)
		return
	end
	for f,a,b in strgfind(msg, "(.-)'s (.+) is parried by (.+)%.") do
		DPSMate.DB:EnemyDamage(DPSMateEDT, f, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
		DPSMate.DB:DamageDone(f, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
		return
	end
	for f,a,b in strgfind(msg, "(.-)'s (.+) missed (.+)%.") do 
		DPSMate.DB:EnemyDamage(DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
		DPSMate.DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	end
end

function DPSMate.Parser:FriendlyPlayerHits(msg)
	t = {}
	for a,b,c,d,e in strgfind(msg, "(.-) (%a%a?)\its (.+) for (%d+)\.%s?(.*)") do
		if b=="h" then t[3]=1;t[4]=0 end
		if e=="(glancing)" then t[1]=1;t[3]=0;t[4]=0 elseif e~="" then t[2]=1;t[3]=0;t[4]=0 end
		t[5] = tonumber(d)
		DPSMate.DB:EnemyDamage(DPSMateEDT, a, "AutoAttack", t[3] or 0, t[4] or 1, 0, 0, 0, 0, t[5], c, t[2] or 0, t[1] or 0)
		DPSMate.DB:DamageDone(a, "AutoAttack", t[3] or 0, t[4] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
		return
	end
	-- (...). (608 absorbed/resisted) -> Therefore here some loss
	for a,b in strgfind(msg, "(.-) loses (%d+) health for swimming in lava%.") do
		DPSMate.DB:DamageTaken(a, "Lava", 1, 0, 0, 0, 0, 0, tonumber(b), "Environment", 0)
		return
	end
	for a,b in strgfind(msg, "(.-) falls and loses (%d+) health%.") do
		DPSMate.DB:DamageTaken(a, "Falling", 1, 0, 0, 0, 0, 0, tonumber(b), "Environment", 0)
		return
	end
	for a,b in strgfind(msg, "(.-) is drowning and loses (%d+) health%.") do
		DPSMate.DB:DamageTaken(a, "Drowning", 1, 0, 0, 0, 0, 0, tonumber(b), "Environment", 0)
		return
	end
end

function DPSMate.Parser:FriendlyPlayerMisses(msg)
	t = {}
	for a,b in strgfind(msg, "(.-) misses (.+)%.") do 
		DPSMate.DB:EnemyDamage(DPSMateEDT, a, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
		DPSMate.DB:DamageDone(a, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	end
	for a,b,c in strgfind(msg, "(.-) attacks%. (.+) (%a-)%.") do 
		if c=="parries" then t[1]=1 elseif c=="dodges" then t[2]=1 else t[3]=1 end 
		DPSMate.DB:EnemyDamage(DPSMateEDT, a, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, b, t[3] or 0, 0)
		DPSMate.DB:DamageDone(a, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, 0, t[3] or 0)
		return
	end
end

-- You reflect 20 Holy damage to Razzashi Serpent.
function DPSMate.Parser:SpellDamageShieldsOnSelf(msg)
	for a,b,c in strgfind(msg, "You reflect (%d+) (%a-) damage to (.+)%.") do 
		local am = tonumber(a)
		DPSMate.DB:EnemyDamage(DPSMateEDT, player, "Reflection", 1, 0, 0, 0, 0, 0, am, c, 0, 0)
		DPSMate.DB:DamageDone(player, "Reflection", 1, 0, 0, 0, 0, 0, am, 0, 0)
	end
end

-- Helboar reflects 4 Fire damage to you.
function DPSMate.Parser:SpellDamageShieldsOnOthers(msg)
	for a,b,c,d in string.gfind(msg, "(.+) reflects (%d+) (%a-) damage to (.+)%.") do
		local am,ta = tonumber(b)
		if d == "you" then ta=player end
		DPSMate.DB:EnemyDamage(DPSMateEDT, a, "Reflection", 1, 0, 0, 0, 0, 0, am, ta or d, 0, 0)
		DPSMate.DB:DamageDone(a, "Reflection", 1, 0, 0, 0, 0, 0, am, 0, 0)
	end
end

----------------------------------------------------------------------------------
--------------                    Damage taken                      --------------                                  
----------------------------------------------------------------------------------

-- War Reaver hits/crits you for 66 (Fire damage). (45 resisted)
function DPSMate.Parser:CreatureVsSelfHits(msg)
	t = {}
	for a,b,c,d in strgfind(msg, "(.+) (%a%a?)\its you for (%d+)(.*)\.%s?(.*)") do
		if b=="h" then t[1]=1;t[2]=0 end
		if strfind(d, "crushing") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(d, "blocked") then t[4]=1;t[1]=0;t[2]=0 end
		t[5] = tonumber(c)
		DPSMate.DB:EnemyDamage(DPSMateEDD, player, "AutoAttack", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
		DPSMate.DB:DamageTaken(player, "AutoAttack", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0)
		DPSMate.DB:DeathHistory(player, a, "AutoAttack", t[5], t[1] or 0, t[2] or 1, 0, t[3] or 0)
		return
	end
end

-- Firetail Scorpid attacks. You parry.
-- Firetail Scorpid attacks. You dodge.
-- Firetail Scorpid misses you.
function DPSMate.Parser:CreatureVsSelfMisses(msg)
	t = {}
	for a in strgfind(msg, "(.+) misses you%.") do 
		DPSMate.DB:EnemyDamage(DPSMateEDD, player, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
		DPSMate.DB:DamageTaken(player, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, a, 0)
		return
	end
	for a,b in strgfind(msg, "(.+) attacks. You (.+)%.") do 
		if b=="parry" then t[1]=1 elseif b=="dodge" then t[2]=1 else t[3]=1 end 
		DPSMate.DB:EnemyDamage(DPSMateEDD, player, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, t[3] or 0, 0)
		DPSMate.DB:DamageTaken(player, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, 0)
		return
	end
end 

-- Thaurissan Spy performs Dazed on you. (Implementing it later) !!!!!
-- Thaurissan Spy's Poison was resisted.
-- Thaurissan Spy's Backstab hits/crits you for 116.
-- Flamekin Torcher's Fireball hits/crits you for 86 Fire damage. (School?)
function DPSMate.Parser:CreatureVsSelfSpellDamage(msg)
	t = {}
	for a,b,c,d,e in strgfind(msg, "(.+)'s (.+) (%a%a?)\its you for (%d+)(.*)\.%s?(.*)") do -- Potential here to track school and resisted damage
		if c=="h" then t[1]=1;t[2]=0 end
		t[3] = tonumber(d)
		DPSMate.DB:UnregisterPotentialKick(a, b, GetTime())
		DPSMate.DB:EnemyDamage(DPSMateEDD, player, b, t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[3], a, 0, 0)
		DPSMate.DB:DamageTaken(player, b, t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[3], a, 0)
		DPSMate.DB:DeathHistory(player, a, b, t[3], t[1] or 0, t[2] or 1, 0, 0)
		return
	end
	for a,b in strgfind(msg, "(.+)'s (.+) was resisted.") do
		DPSMate.DB:EnemyDamage(DPSMateEDD, player, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
		DPSMate.DB:DamageTaken(player, b, 0, 0, 0, 0, 0, 1, 0, a, 0)
		return
	end
end

-- You are afflicted by Dazed. (Implementing it later maybe) !!!!!!
-- You are afflicted by Infected Bite.
-- You suffer 8 Nature damage from Ember Worg's Infected Bite. (3 resisted) (School? + resist?)
function DPSMate.Parser:PeriodicSelfDamage(msg)
	t = {}
	for a,b,c,d,e in strgfind(msg, "You suffer (%d+) (%a+) damage from (.+)'s (.+)\.%s?(.*)") do -- Potential to track school and resisted damage
		t[1] = tonumber(a)
		DPSMate.DB:EnemyDamage(DPSMateEDD, player, d.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], c, 0, 0)
		DPSMate.DB:DamageTaken(player, d.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], c, 0)
		DPSMate.DB:DeathHistory(player, c, d.."(Periodic)", t[1], 1, 0, 0, 0)
		return
	end
end

-- Ember Worg hits/crits Ikaa for 58 (Fire damage). (41 resisted/blocked)
function DPSMate.Parser:CreatureVsCreatureHits(msg) 
	t = {}
	for a,b,c,d,e in strgfind(msg, "(.+) (%a%a?)\its (.+) for (%d+)(.*)\.%s?(.*)") do
		if b=="h" then t[1]=1;t[2]=0 end
		if strfind(e, "crushing") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(e, "blocked") then t[4]=1;t[1]=0;t[2]=0 end
		t[5] = tonumber(d)
		DPSMate.DB:EnemyDamage(DPSMateEDD, c, "AutoAttack", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
		DPSMate.DB:DamageTaken(c, "AutoAttack", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0)
		DPSMate.DB:DeathHistory(c, a, "AutoAttack", t[5], t[1] or 0, t[2] or 1, 0, t[3] or 0)
		return
	end
end

-- Ember Worg attacks. Ikaa parries.
-- Ember Worg attacks. Ikaa dodges.
-- Ember Worg misses Ikaa.
-- Young Wolf attacks. Senpie absorbs all the damage.
function DPSMate.Parser:CreatureVsCreatureMisses(msg)
	t = {}
	for a,b,c in strgfind(msg, "(.+) attacks%. (.-) (.+)%.") do 
		if c=="parries" then t[1]=1 elseif c=="dodges" then t[2]=1 else t[3]=1 end 
		DPSMate.DB:EnemyDamage(DPSMateEDD, b, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, t[3] or 0, 0)
		DPSMate.DB:DamageTaken(b, "AutoAttack", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, 0)
		return
	end
	for a,b in strgfind(msg, "(.+) misses (.+)%.") do 
		DPSMate.DB:EnemyDamage(DPSMateEDD, b, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
		DPSMate.DB:DamageTaken(b, "AutoAttack", 0, 0, 1, 0, 0, 0, 0, a, 0)
		return 
	end
end

-- Ikaa is afflicted by Infected Bite.
-- Ikaa suffers 15 Nature damage from Ember Worg's Infected Bite. (3 resisted)
function DPSMate.Parser:SpellPeriodicDamageTaken(msg)
	t = {}
	for a,b,c,d,e in string.gfind(msg, "(.+) suffers (%d+) (%a+) damage from (.+)'s (.+)\.%s?(.*)") do -- Potential to track resisted damage and school
		t[1] = tonumber(b)
		DPSMate.DB:EnemyDamage(DPSMateEDD, a, e.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], d, 0, 0)
		DPSMate.DB:DamageTaken(a, e.."(Periodic)", 1, 0, 0, 0, 0, 0, t[1], d, 0)
		DPSMate.DB:DeathHistory(a, d, e.."(Periodic)", t[1], 1, 0, 0, 0)
		return
	end
end

-- Black Broodling's Fireball was resisted by Ikaa.
-- Black Broodling's Fireball hits/crits Ikaa for 342 Fire damage. (100 resisted) (School + resist ?)
function DPSMate.Parser:CreatureVsCreatureSpellDamage(msg)
	t = {}
	for a,b,c,d,e,f in strgfind(msg, "(.+)'s (.+) (%a%a?)\its (.+) for (%d+)(.*)\.%s?(.*)") do
		if c=="h" then t[1]=1;t[2]=0 end
		t[3] = tonumber(e)
		DPSMate.DB:UnregisterPotentialKick(a, b, GetTime())
		DPSMate.DB:EnemyDamage(DPSMateEDD, d, b, t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[3], a, 0, 0)
		DPSMate.DB:DamageTaken(d, b, t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[3], a, 0)
		DPSMate.DB:DeathHistory(d, a, b, t[3], t[1] or 0, t[2] or 1, 0, 0)
		return
	end
	for a,b,c in strgfind(msg, "(.+)'s (.+) was resisted by (.+)%.") do
		DPSMate.DB:EnemyDamage(DPSMateEDD, c, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
		DPSMate.DB:DamageTaken(c, b, 0, 0, 0, 0, 0, 1, 0, a, 0)
		return
	end
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
	else
		if target==UnitName("player") then
			unit="player"
		elseif target==UnitName("target") then
			unit="target"
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
-- You gain 25 Energy from Relentless Strikes Effect.
function DPSMate.Parser:SpellSelfBuff(msg)
	t = {}
	for a,b,c in string.gfind(msg, "Your (.+) critically heals (.+) for (%d+)%.") do 
		if b=="you" then t[1]=player end
		t[2] = tonumber(c)
		overheal = DPSMate.Parser:GetOverhealByName(t[2], t[1] or b)
		DPSMate.DB:HealingTaken(DPSMateHealingTaken, t[1] or b, a, 0, 1, t[2], player)
		DPSMate.DB:HealingTaken(DPSMateEHealingTaken, t[1] or b, a, 0, 1, t[2]-overheal, player)
		DPSMate.DB:Healing(DPSMateEHealing, player, a, 0, 1, t[2]-overheal, t[1] or b)
		if overheal>0 then DPSMate.DB:Healing(DPSMateOverhealing, player, a, 0, 1, overheal, t[1] or b) end
		DPSMate.DB:Healing(DPSMateTHealing, player, a, 0, 1, t[2], t[1] or b)
		DPSMate.DB:DeathHistory(t[1] or b, player, a, t[2], 0, 1, 1, 0)
		return
	end
	for a,b,c in string.gfind(msg, "Your (.+) heals (.+) for (%d+)%.") do 
		if b=="you" then t[1]=player end
		t[2] = tonumber(c)
		overheal = DPSMate.Parser:GetOverhealByName(t[2], t[1] or b)
		DPSMate.DB:HealingTaken(DPSMateHealingTaken, t[1] or b, a, 1, 0, t[2], player)
		DPSMate.DB:HealingTaken(DPSMateEHealingTaken, t[1] or b, a, 1, 0, t[2]-overheal, player)
		DPSMate.DB:Healing(DPSMateEHealing, player, a, 1, 0, t[2]-overheal, t[1] or b)
		if overheal>0 then DPSMate.DB:Healing(DPSMateOverhealing, player, a, 1, 0, overheal, t[1] or b) end
		DPSMate.DB:Healing(DPSMateTHealing, player, a, 1, 0, t[2], t[1] or b)
		DPSMate.DB:DeathHistory(t[1] or b, player, a, t[2], 1, 0, 1, 0)
		return
	end
	for a,b in strgfind(msg, "You gain (%d+) Energy from (.+)%.") do -- Potential to gain energy values for class evaluation
		DPSMate.DB:BuildBuffs(player, player, b, true)
		DPSMate.DB:DestroyBuffs(player, b)
		return
	end
	for a,b in strgfind(msg, "You gain (%d) extra attack through (.+)%.") do -- Potential for more evaluation
		DPSMate.DB:BuildBuffs(player, player, b, true)
		DPSMate.DB:DestroyBuffs(player, b)
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
		t[1]=tonumber(a)
		overheal = DPSMate.Parser:GetOverhealByName(t[1], player)
		DPSMate.DB:HealingTaken(DPSMateHealingTaken, player, c.."(Periodic)", 1, 0, t[1], b)
		DPSMate.DB:HealingTaken(DPSMateEHealingTaken, player, c.."(Periodic)", 1, 0, t[1]-overheal, b)
		DPSMate.DB:Healing(DPSMateEHealing, b, c.."(Periodic)", 1, 0, t[1]-overheal, player)
		if overheal>0 then DPSMate.DB:Healing(DPSMateOverhealing, b, c.."(Periodic)", 1, 0, overheal, player) end
		DPSMate.DB:Healing(DPSMateTHealing, b, c.."(Periodic)", 1, 0, t[1], player)
		DPSMate.DB:DeathHistory(player, b, c.."(Periodic)", t[1], 1, 0, 1, 0)
		return
	end
	for a,b in strgfind(msg, "You gain (%d+) health from (.+)%.") do 
		t[1] = tonumber(a)
		overheal = DPSMate.Parser:GetOverhealByName(t[1], player)
		DPSMate.DB:HealingTaken(DPSMateHealingTaken, player, b.."(Periodic)", 1, 0, t[1], player)
		DPSMate.DB:HealingTaken(DPSMateEHealingTaken, player, b.."(Periodic)", 1, 0, t[1]-overheal, player)
		DPSMate.DB:Healing(DPSMateEHealing, player, b.."(Periodic)", 1, 0, t[1]-overheal, player)
		if overheal>0 then DPSMate.DB:Healing(DPSMateOverhealing, player, b.."(Periodic)", 1, 0, overheal, player) end
		DPSMate.DB:Healing(DPSMateTHealing, player, b.."(Periodic)", 1, 0, t[1], player)
		DPSMate.DB:DeathHistory(player, player, b.."(Periodic)", t[1], 1, 0, 1, 0)
		return
	end
	for a in strgfind(msg, "You gain (.+)%.") do
		DPSMate.DB:ConfirmBuff(player, a, GetTime())
		DPSMate.DB:RegisterHotDispel(player, a)
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
		t[1]=tonumber(a)
		overheal = DPSMate.Parser:GetOverhealByName(t[1], f)
		DPSMate.DB:HealingTaken(DPSMateHealingTaken, f, c.."(Periodic)", 1, 0, t[1], b)
		DPSMate.DB:HealingTaken(DPSMateEHealingTaken, f, c.."(Periodic)", 1, 0, t[1]-overheal, b)
		DPSMate.DB:Healing(DPSMateEHealing, b, c.."(Periodic)", 1, 0, t[1]-overheal, f)
		if overheal>0 then DPSMate.DB:Healing(DPSMateOverhealing, b, c.."(Periodic)", 1, 0, overheal, f) end
		DPSMate.DB:Healing(DPSMateTHealing, b, c.."(Periodic)", 1, 0, t[1], f)
		DPSMate.DB:DeathHistory(f, b, c.."(Periodic)", t[1], 1, 0, 1, 0)
		return
	end
	for f,a,b in strgfind(msg, "(.+) gains (%d+) health from (.+)%.") do 
		t[1] = tonumber(a)
		overheal = DPSMate.Parser:GetOverhealByName(t[1], f)
		DPSMate.DB:HealingTaken(DPSMateHealingTaken, f, b.."(Periodic)", 1, 0, t[1], f)
		DPSMate.DB:HealingTaken(DPSMateEHealingTaken, f, b.."(Periodic)", 1, 0, t[1]-overheal, f)
		DPSMate.DB:Healing(DPSMateEHealing, f, b.."(Periodic)", 1, 0, t[1]-overheal, f)
		if overheal>0 then DPSMate.DB:Healing(DPSMateOverhealing, f, b.."(Periodic)", 1, 0, overheal, f) end
		DPSMate.DB:Healing(DPSMateTHealing, f, b.."(Periodic)", 1, 0, t[1], f)
		DPSMate.DB:DeathHistory(f, f, b.."(Periodic)", t[1], 1, 0, 1, 0)
		return
	end
	for f,a in strgfind(msg, "(.+) gains (.+)%.") do
		DPSMate.DB:ConfirmBuff(f, a, GetTime())
		DPSMate.DB:RegisterHotDispel(f, a)
		return 
	end
end

-- A1bea's Flash of Light heals you/Baz for 90.
-- Albea's Flash of Light critically heals you/Baz for 135.
-- if strfind(msg, "begins to") or strfind(msg, "Rage") then return end
function DPSMate.Parser:SpellHostilePlayerBuff(msg)
	t = {}
	for a,b,c,d in strgfind(msg, "(.+)'s (.+) critically heals (.+) for (%d+)%.") do 
		t[1] = tonumber(d)
		if c=="you" then t[2]=player end
		overheal = DPSMate.Parser:GetOverhealByName(t[1], t[2] or c)
		DPSMate.DB:HealingTaken(DPSMateHealingTaken, t[2] or c, b, 0, 1, t[1], a)
		DPSMate.DB:HealingTaken(DPSMateEHealingTaken, t[2] or c, b, 0, 1, t[1]-overheal, a)
		DPSMate.DB:Healing(DPSMateEHealing, a, b, 0, 1, t[1]-overheal, t[2] or c)
		if overheal>0 then DPSMate.DB:Healing(DPSMateOverhealing, a, b, 0, 1, overheal, t[2] or c) end
		DPSMate.DB:Healing(DPSMateTHealing, a, b, 0, 1, t[1], t[2] or c)
		DPSMate.DB:DeathHistory(t[2] or c, a, b, t[1], 0, 1, 1, 0)
		return
	end
	for a,b,c,d in strgfind(msg, "(.+)'s (.+) heals (.+) for (%d+)%.") do 
		t[1] = tonumber(d)
		if c=="you" then t[2]=player end
		overheal = DPSMate.Parser:GetOverhealByName(t[1], t[2] or c)
		DPSMate.DB:HealingTaken(DPSMateHealingTaken, t[2] or c, b, 1, 0, t[1], a)
		DPSMate.DB:HealingTaken(DPSMateEHealingTaken, t[2] or c, b, 1, 0, t[1]-overheal, a)
		DPSMate.DB:Healing(DPSMateEHealing, a, b, 1, 0, t[1]-overheal, t[2] or c)
		if overheal>0 then DPSMate.DB:Healing(DPSMateOverhealing, a, b, 1, 0, overheal, t[2] or c) end
		DPSMate.DB:Healing(DPSMateTHealing, a, b, 1, 0, t[1], t[2] or c)
		DPSMate.DB:DeathHistory(t[2] or c, a, b, t[1], 1, 0, 1, 0)
		return
	end
	for a,b,c,d in strgfind(msg, "(.+) gains (%d+) Energy from (.+)'s (.+)%.") do
		DPSMate.DB:BuildBuffs(c, a, d, true)
		DPSMate.DB:DestroyBuffs(c, d)
		return 
	end
	for a,b,c in strgfind(msg, "(.+) gains (%d+) extra attack through (.+)%.") do
		DPSMate.DB:BuildBuffs(a, a, c, true)
		DPSMate.DB:DestroyBuffs(a, c)
		return 
	end
end

----------------------------------------------------------------------------------
--------------                       Absorbs                        --------------                                  
----------------------------------------------------------------------------------

-- Heavy War Golem hits/crits you for 8. (59 absorbed)
function DPSMate.Parser:CreatureVsSelfHitsAbsorb(msg)
	for c, b, a, absorbed in strgfind(msg, "(.+) (%a%a?)\its you for (.+)%. %((%d+) absorbed%)") do DPSMate.DB:SetUnregisterVariables(tonumber(absorbed), "AutoAttack", c) end
end

function DPSMate.Parser:CreatureVsCreatureHitsAbsorb(msg)
	for c, b, a, absorbed in strgfind(msg, "(.+) (%a%a?)\its (.+) for (.+)%. %((%d+) absorbed%)") do DPSMate.DB:SetUnregisterVariables(tonumber(absorbed), "AutoAttack", c) end
end

-- Heavy War Golem attacks. You absorb all the damage.
function DPSMate.Parser:CreatureVsSelfMissesAbsorb(msg)
	for c in strgfind(msg, "(.+) attacks%. You absorb all the damage%.") do DPSMate.DB:Absorb("AutoAttack", player, c) end
end

function DPSMate.Parser:CreatureVsCreatureMissesAbsorb(msg)
	for c, ta in strgfind(msg, "(.+) attacks%. (.+) absorbs all the damage%.") do DPSMate.DB:Absorb("AutoAttack", ta, c) end
end

-- Heavy War Golem's Trample hits/crits you for 51 (Fire damage). (48 absorbed)
function DPSMate.Parser:CreatureVsSelfSpellDamageAbsorb(msg)
	for c, ab, b, a, absorbed in strgfind(msg, "(.+)'s (.+) (%a%a?)\its you for (.+)%. %((%d+) absorbed%)") do DPSMate.DB:SetUnregisterVariables(tonumber(absorbed), ab, c) end
end

function DPSMate.Parser:CreatureVsCreatureSpellDamageAbsorb(msg)
	for c, ab, b, a, x, absorbed in strgfind(msg, "(.+)'s (.+) (%a%a?)\its (.+) for (.+)%. %((%d+) absorbed%)") do DPSMate.DB:SetUnregisterVariables(tonumber(absorbed), ab, c) end
end

function DPSMate.Parser:SpellPeriodicSelfBuffAbsorb(msg)
	for ab in strgfind(msg, "You gain (.+)%.") do if DPSMate:TContains(DPSMate.DB.ShieldFlags, ab) then DPSMate.DB:ConfirmAbsorbApplication(ab, player, GetTime()) end end
end

function DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffsAbsorb(msg)
	for ta, ab in strgfind(msg, "(.+) gains (.+)%.") do if DPSMate:TContains(DPSMate.DB.ShieldFlags, ab) then DPSMate.DB:ConfirmAbsorbApplication(ab, ta, GetTime()) end end
end

-- Power Word: Shield fades from you.
function DPSMate.Parser:SpellAuraGoneSelf(msg)
	for ab in strgfind(msg, "(.+) fades from you%.") do if DPSMate:TContains(DPSMate.DB.ShieldFlags, ab) then DPSMate.DB:UnregisterAbsorb(ab, player) end; DPSMate.DB:DestroyBuffs(player, ab); DPSMate.DB:UnregisterHotDispel(player, ab) end
end

-- Power Word: Shield fades from Senpie.
function DPSMate.Parser:SpellAuraGoneParty(msg)
	for ab, ta in strgfind(msg, "(.+) fades from (.+)%.") do if DPSMate:TContains(DPSMate.DB.ShieldFlags, ab) then DPSMate.DB:UnregisterAbsorb(ab, ta) end; DPSMate.DB:DestroyBuffs(ta, ab); DPSMate.DB:UnregisterHotDispel(ta, ab) end
end

function DPSMate.Parser:SpellAuraGoneOther(msg)
	for ab, ta in strgfind(msg, "(.+) fades from (.+)%.") do if DPSMate:TContains(DPSMate.DB.ShieldFlags, ab) then DPSMate.DB:UnregisterAbsorb(ab, ta) end; DPSMate.DB:DestroyBuffs(ta, ab); DPSMate.DB:UnregisterHotDispel(ta, ab) end
end

----------------------------------------------------------------------------------
--------------                       Dispels                        --------------                                  
----------------------------------------------------------------------------------

DPSMate.Parser.Dispels = {
	[1] = "Remove Curse",
	[2] = "Cleanse",
	[3] = "Remove Lesser Curse",
	[4] = "Purify",
	[5] = "Dispel Magic",
	[6] = "Abolish Poison",
	[7] = "Abolish Disease",
	[8] = "Devour Magic",
	[9] = "Cure Disease",
}
DPSMate.Parser.DeCurse = {
	[1] = "Remove Curse",
	[2] = "Remove Lesser Curse",
}
DPSMate.Parser.DeMagic = {
	[1] = "Cleanse",
	[2] = "Dispel Magic",
	[3] = "Devour Magic",
}
DPSMate.Parser.DeDisease = {
	[1] = "Cleanse",
	[2] = "Purify",
	[3] = "Abolish Disease",
	[4] = "Cure Disease",
}
DPSMate.Parser.DePoison = {
	[1] = "Cleanse",
	[2] = "Abolish Poison",
	[3] = "Purify",
}
DPSMate.Parser.DebuffTypes = {}
DPSMate.Parser.HotDispels = {
	[1] = "Abolish Poison",
	[2] = "Abolish Disease",
}
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
			DPSMateAbility[aura][2] = type
		end
	end
end

-- Is it really "yourself"?
function DPSMate.Parser:SpellSelfBuffDispels(msg)
	for ab in strgfind(msg, "You cast (.+)%.") do if DPSMate:TContains(DPSMate.Parser.Dispels, ab) then DPSMate.DB:AwaitDispel(ab, player, player, GetTime()) end end
end

-- Avrora casts Remove Curse on you.
-- Avrora casts Remove Curse on Avrora.
function DPSMate.Parser:SpellHostilePlayerBuffDispels(msg)
	for c, ab, ta in strgfind(msg, "(.+) casts (.+) on (.+)%.") do if DPSMate:TContains(DPSMate.Parser.Dispels, ab) then if ta=="you" then DPSMate.DB:AwaitDispel(ab, player, c, GetTime()) else  DPSMate.DB:AwaitDispel(ab, ta, c, GetTime()) end end end
end

-- Avrora's  Curse of Agony is removed.
-- Your Curse of Agony is removed.
function DPSMate.Parser:SpellBreakAura(msg) 
	for ta, ab in strgfind(msg, "(.+)'s (.+) is removed.") do DPSMate.DB:ConfirmRealDispel(ab, ta, GetTime()) end
	for ab in strgfind(msg, "Your (.+) is removed.") do DPSMate.DB:ConfirmRealDispel(ab, player, GetTime()) end
end

----------------------------------------------------------------------------------
--------------                       Deaths                         --------------                                  
----------------------------------------------------------------------------------

-- You die.
-- Senpie dies.
function DPSMate.Parser:CombatFriendlyDeath(msg)
	for ta in strgfind(msg, "(.-) (.-)%.") do if ta=="You" then DPSMate.DB:UnregisterDeath(player) else DPSMate.DB:UnregisterDeath(ta) end end
end

function DPSMate.Parser:CombatHostileDeaths(msg)
	for ta in strgfind(msg, "(.-) dies%.") do DPSMate.DB:UnregisterDeath(ta) end
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
	for c, ab in strgfind(msg, "(.+) begins to cast (.+)%.") do DPSMate.DB:RegisterPotentialKick(c, ab, GetTime()) end
end