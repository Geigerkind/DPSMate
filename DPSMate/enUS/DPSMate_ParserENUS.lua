local t = {}
local strgfind = string.gfind
local tnbr = tonumber
local npcdb = NPCDB
local strsub = string.sub
local GetTime = GetTime
local strfind = string.find
local DB = DPSMate.DB

----------------------------------------------------------------------------------
--------------                    Init                              --------------                                  
----------------------------------------------------------------------------------
local Kicks = {}
local DmgProcs = {}
local CC = {}
local FailDT = {}
local Procs = {}
local OtherExceptions = {}
local Dispels = {}
local RCD = {}
local FailDB = {}
local ShieldFlags = {}
local BuffExceptions = {}

local Player = ""
local AAttack = "AutoAttack"

local GlobalStrings = {
	"COMBATHITCRITOTHEROTHER", 
	"COMBATHITCRITSCHOOLOTHEROTHER",
	"COMBATHITCRITOTHERSELF", 
	"COMBATHITCRITSCHOOLOTHERSELF", 
	"COMBATHITCRITSCHOOLSELFOTHER", 
	"COMBATHITCRITSELFOTHER", 
	"COMBATHITOTHEROTHER", 
	"COMBATHITSCHOOLOTHEROTHER", 
	"COMBATHITSCHOOLOTHERSELF", 
	"COMBATHITOTHERSELF", 
	"COMBATHITSCHOOLSELFOTHER", 
	"COMBATHITSELFOTHER", 
	"DAMAGESHIELDOTHEROTHER", 
	"DAMAGESHIELDOTHERSELF", 
	"DAMAGESHIELDSELFOTHER", 
	"ERR_COMBAT_DAMAGE_SSI", 
	"HEALEDCRITOTHEROTHER", 
	"HEALEDCRITOTHERSELF", 
	"HEALEDCRITSELFOTHER", 
	"HEALEDCRITSELFSELF", 
	"HEALEDOTHEROTHER", 
	"HEALEDOTHERSELF", 
	"HEALEDSELFOTHER", 
	"HEALEDSELFSELF", 
	"PERIODICAURADAMAGEOTHEROTHER", 
	"PERIODICAURADAMAGEOTHERSELF", 
	"PERIODICAURADAMAGESELFOTHER", 
	"PERIODICAURADAMAGESELFSELF", 
	"PERIODICAURAHEALOTHEROTHER", 
	"PERIODICAURAHEALOTHERSELF", 
	"PERIODICAURAHEALSELFOTHER", 
	"PERIODICAURAHEALSELFSELF", 
	"PET_DAMAGE_PERCENTAGE", 
	"SPELLEXTRAATTACKSOTHER", 
	"SPELLEXTRAATTACKSOTHER_SINGULAR", 
	"SPELLEXTRAATTACKSSELF", 
	"SPELLEXTRAATTACKSSELF_SINGULAR", 
	"SPELLHAPPINESSDRAINOTHER", 
	"SPELLHAPPINESSDRAINSELF", 
	"SPELLLOGCRITOTHEROTHER", 
	"SPELLLOGCRITOTHERSELF", 
	"SPELLLOGCRITSCHOOLOTHEROTHER", 
	"SPELLLOGCRITSCHOOLOTHERSELF", 
	"SPELLLOGCRITSCHOOLSELFOTHER", 
	"SPELLLOGCRITSCHOOLSELFSELF", 
	"SPELLLOGCRITSELFOTHER", 
	"SPELLLOGCRITSELFSELF", 
	"SPELLLOGOTHEROTHER", 
	"SPELLLOGOTHERSELF", 
	"SPELLLOGSCHOOLOTHEROTHER", 
	"SPELLLOGSCHOOLOTHERSELF", 
	"SPELLLOGSCHOOLSELFOTHER", 
	"SPELLLOGSCHOOLSELFSELF", 
	"SPELLLOGSELFOTHER", 
	"SPELLLOGSELFSELF", 
	"SPELLPOWERDRAINOTHEROTHER", 
	"SPELLPOWERDRAINOTHERSELF", 
	"SPELLPOWERDRAINSELFOTHER", 
	"SPELLPOWERLEECHOTHEROTHER", 
	"SPELLPOWERLEECHOTHERSELF", 
	"SPELLPOWERLEECHSELFOTHER", 
	"SPELLSPLITDAMAGEOTHEROTHER", 
	"SPELLSPLITDAMAGEOTHERSELF", 
	"SPELLSPLITDAMAGESELFOTHER", 
	"VSENVIRONMENTALDAMAGE_DROWNING_OTHER", 
	"VSENVIRONMENTALDAMAGE_DROWNING_SELF", 
	"VSENVIRONMENTALDAMAGE_FALLING_OTHER", 
	"VSENVIRONMENTALDAMAGE_FALLING_SELF", 
	"VSENVIRONMENTALDAMAGE_FATIGUE_OTHER", 
	"VSENVIRONMENTALDAMAGE_FATIGUE_SELF", 
	"VSENVIRONMENTALDAMAGE_FIRE_OTHER", 
	"VSENVIRONMENTALDAMAGE_FIRE_SELF", 
	"VSENVIRONMENTALDAMAGE_LAVA_OTHER", 
	"VSENVIRONMENTALDAMAGE_LAVA_SELF", 
	"VSENVIRONMENTALDAMAGE_SLIME_OTHER", 
	"VSENVIRONMENTALDAMAGE_SLIME_SELF", 
	"POWERGAINOTHEROTHER", 
	"POWERGAINOTHERSELF", 
	"POWERGAINSELFOTHER", 
	"POWERGAINSELFSELF", 
	"AURAAPPLICATIONADDEDOTHERHARMFUL", 
	"AURAAPPLICATIONADDEDOTHERHELPFUL", 
	"AURAAPPLICATIONADDEDSELFHARMFUL", 
	"AURAAPPLICATIONADDEDSELFHELPFUL", 
	"AURAADDEDSELFHELPFUL",
	"AURAADDEDOTHERHELPFUL",
	"AURAREMOVEDSELF",
	"AURAREMOVEDOTHER",
	"AURAADDEDSELFHARMFUL",
	"AURAADDEDOTHERHARMFUL",
	"AURADISPELSELF",
	"AURADISPELOTHER",
	"AURASTOLENOTHEROTHER", 
	"AURASTOLENOTHERSELF", 
	"AURASTOLENSELFOTHER", 
	"AURASTOLENSELFSELF", 
	"AURA_END",
	"SIMPLECASTOTHEROTHER", 
	"SIMPLECASTOTHERSELF", 
	"SIMPLECASTSELFOTHER", 
	"SIMPLECASTSELFSELF", 
	"COMBATLOG_HONORGAIN", 
	"COMBATLOG_HONORAWARD", 
	"MISSEDSELFOTHER", 
	"MISSEDOTHERSELF", 
	"MISSEDOTHEROTHER", 
	"SPELLMISSSELFSELF", 
	"SPELLMISSSELFOTHER", 
	"SPELLMISSOTHERSELF", 
	"SPELLMISSOTHEROTHER", 
	"VSBLOCKSELFOTHER", 
	"VSBLOCKOTHERSELF", 
	"VSBLOCKOTHEROTHER", 
	"SPELLBLOCKEDSELFOTHER", 
	"SPELLBLOCKEDOTHERSELF", 
	"SPELLBLOCKEDOTHEROTHER", 
	"VSPARRYSELFOTHER", 
	"VSPARRYOTHERSELF", 
	"VSPARRYOTHEROTHER", 
	"SPELLPARRIEDOTHEROTHER", 
	"SPELLPARRIEDOTHERSELF", 
	"SPELLPARRIEDSELFOTHER", 
	"SPELLPARRIEDSELFSELF", 
	"SPELLINTERRUPTOTHEROTHER", 
	"SPELLINTERRUPTOTHERSELF", 
	"SPELLINTERRUPTSELFOTHER", 
	"SPELLEVADEDOTHEROTHER", 
	"SPELLEVADEDSELFOTHER", 
	"SPELLEVADEDOTHERSELF", 
	"SPELLEVADEDSELFSELF", 
	"VSEVADEOTHEROTHER", 
	"VSEVADEOTHERSELF", 
	"VSEVADESELFOTHER", 
	"VSABSORBSELFOTHER", 
	"VSABSORBOTHERSELF", 
	"VSABSORBOTHEROTHER", 
	"SPELLLOGABSORBSELFSELF", 
	"SPELLLOGABSORBSELFOTHER", 
	"SPELLLOGABSORBOTHERSELF", 
	"SPELLLOGABSORBOTHEROTHER", 
	"VSDODGESELFOTHER", 
	"VSDODGEOTHERSELF", 
	"VSDODGEOTHEROTHER", 
	"SPELLDODGEDSELFSELF", 
	"SPELLDODGEDSELFOTHER", 
	"SPELLDODGEDOTHERSELF", 
	"SPELLDODGEDOTHEROTHER", 
	"VSRESISTSELFOTHER", 
	"VSRESISTOTHERSELF", 
	"VSRESISTOTHEROTHER", 
	"SPELLRESISTSELFSELF", 
	"SPELLRESISTSELFOTHER", 
	"SPELLRESISTOTHERSELF", 
	"SPELLRESISTOTHEROTHER", 
	"PROCRESISTSELFSELF", 
	"PROCRESISTSELFOTHER", 
	"PROCRESISTOTHERSELF", 
	"PROCRESISTOTHEROTHER", 
	"SPELLREFLECTSELFSELF", 
	"SPELLREFLECTSELFOTHER", 
	"SPELLREFLECTOTHERSELF", 
	"SPELLREFLECTOTHEROTHER", 
	"VSDEFLECTSELFOTHER", 
	"VSDEFLECTOTHERSELF", 
	"VSDEFLECTOTHEROTHER", 
	"SPELLDEFLECTEDSELFSELF", 
	"SPELLDEFLECTEDSELFOTHER", 
	"SPELLDEFLECTEDOTHERSELF", 
	"SPELLDEFLECTEDOTHEROTHER", 
	"VSIMMUNESELFOTHER", 
	"VSIMMUNEOTHERSELF", 
	"VSIMMUNEOTHEROTHER", 
	"SPELLIMMUNESELFSELF", 
	"SPELLIMMUNESELFOTHER", 
	"SPELLIMMUNEOTHERSELF", 
	"SPELLIMMUNEOTHEROTHER", 
	"UNITDIESSELF",
	"UNITDIESOTHER", 
	"UNITDESTROYEDOTHER", 
	"ERR_KILLED_BY_S", 
	"SELFKILLOTHER", 
	"PARTYKILLOTHER", 
	"INSTAKILLSELF", 
	"INSTAKILLOTHER", 
	"SPELLCASTGOOTHER", 
	"SPELLCASTGOOTHERTARGETTED", 
	"SPELLCASTGOSELF", 
	"SPELLCASTGOSELFTARGETTED", 
	"SPELLCASTOTHERSTART", 
	"SPELLCASTSELFSTART", 
	"SPELLTERSE_OTHER", 
	"SPELLTERSE_SELF", 
	"SPELLTERSEPERFORM_OTHER", 
	"SPELLTERSEPERFORM_SELF", 
	"SIMPLEPERFORMOTHEROTHER", 
	"SIMPLEPERFORMOTHERSELF", 
	"SIMPLEPERFORMSELFOTHER", 
	"SIMPLEPERFORMSELFSELF", 
	"SPELLPERFORMGOOTHER", 
	"SPELLPERFORMGOOTHERTARGETTED", 
	"SPELLPERFORMGOSELF", 
	"SPELLPERFORMGOSELFTARGETTED", 
	"SPELLPERFORMOTHERSTART", 
	"SPELLPERFORMSELFSTART", 
	"DISPELFAILEDOTHEROTHER", 
	"DISPELFAILEDSELFOTHER", 
	"DISPELFAILEDOTHERSELF", 
	"DISPELFAILEDSELFSELF", 
	"IMMUNESPELLSELFSELF", 
	"IMMUNESPELLSELFOTHER", 
	"IMMUNESPELLOTHERSELF", 
	"IMMUNESPELLOTHEROTHER", 
	"IMMUNESELFSELF", 
	"IMMUNESELFOTHER", 
	"IMMUNEOTHERSELF", 
	"IMMUNEOTHEROTHER", 
}

function DPSMate.Parser:InitParser()
	-- Localizing pointer
	Kicks = self.Kicks
	DmgProcs = self.DmgProcs
	Player = self.player
	CC = self.CC
	FailDT = self.FailDT
	Procs = self.procs
	OtherExceptions = self.OtherExceptions
	Dispels = self.Dispels
	RCD = self.RCD
	FailDB = self.FailDB
	ShieldFlags = DB.ShieldFlags
	BuffExceptions = self.BuffExceptions
	
	-- Applying SWStats FixLogStrings function to Globals
	for _, val in GlobalStrings do
		local glb = getglobal(val)
		local str = string.gsub(glb, "(%%%d?$?s)('s)", "%1% %2")
		setglobal(val, str)
	end
end

function DPSMate.Parser:TestSuit()
	local hardName = "Peter's Cannonball"
	local hardName2 = "Shino's Cannonball's Head"
	local hardAbName = "Nature's Swiftness of Whatever"
	
	local test = 21
	for i=1,10 do
		for p=1,40 do
			if test == 1 then
				DPSMate.Parser:FriendlyPlayerDamage(hardName..p.." 's "..hardAbName.." hits "..hardName2.." for 22 Fire damage. (22 absorbed)");
				DPSMate.Parser:FriendlyPlayerDamage(hardName..p.." 's "..hardAbName.." was blocked by "..hardName2..".");
				DPSMate.Parser:FriendlyPlayerDamage(hardName..p.." 's "..hardAbName.." is parried by "..hardName2..".");
				DPSMate.Parser:FriendlyPlayerDamage(hardName..p.." 's "..hardAbName.." missed "..hardName2..".");
				DPSMate.Parser:FriendlyPlayerDamage(hardName..p.." interrupts "..hardName2.." 's "..hardAbName..".");
			elseif test == 2 then
				DPSMate.Parser:SelfHits("You hit "..hardName.." for 22 Fire damage. (22 absorbed)")
				DPSMate.Parser:SelfHits("You hit "..hardName.." for 22 Fire damage. (glancing)")
				DPSMate.Parser:SelfHits("You fall and lose 26 health.")
				DPSMate.Parser:SelfHits("You lose 25 health for swimming in lava.")
				DPSMate.Parser:SelfHits("You suffer 24 points of fire damage.")
				DPSMate.Parser:SelfHits("You are drowning and lose 23 health.")
				DPSMate.Parser:SelfHits("You lose 22 health for swimming in slime.")
			elseif test == 3 then
				DPSMate.Parser:SelfMisses("You miss "..hardName..".")
				DPSMate.Parser:SelfMisses("You attack. "..hardName.. " absorbs all the damage.")
				DPSMate.Parser:SelfMisses("You attack. "..hardName.. " dodges.")
				DPSMate.Parser:SelfMisses("You attack. "..hardName.. " parries.")
				DPSMate.Parser:SelfMisses("You attack. "..hardName.. " blocks.")
			elseif test == 4 then
				DPSMate.Parser:SelfSpellDMG("Your "..hardAbName.." hits "..hardName.." for 22 Fire damage. (22 absorbed)")
				DPSMate.Parser:SelfSpellDMG("Your "..hardAbName.." was blocked by "..hardName..".")
				DPSMate.Parser:SelfSpellDMG("Your "..hardAbName.." was dodged by "..hardName..".")
				DPSMate.Parser:SelfSpellDMG("Your "..hardAbName.." is parried by "..hardName..".")
				DPSMate.Parser:SelfSpellDMG("Your "..hardAbName.." missed "..hardName..".")
				DPSMate.Parser:SelfSpellDMG("Your "..hardAbName.." is absorbed by "..hardName..".")
			elseif test == 5 then
				DPSMate.Parser:FriendlyPlayerHits(hardName2.." hits "..hardName.." for 22 Fire damage. (22 absorbed)")
				DPSMate.Parser:FriendlyPlayerHits(hardName2.." hits "..hardName.." for 22 Fire damage. (glancing)")
				DPSMate.Parser:FriendlyPlayerHits(hardName2.." falls and loses 26 health.")
				DPSMate.Parser:FriendlyPlayerHits(hardName2.." loses 25 health for swimming in lava.")
				DPSMate.Parser:FriendlyPlayerHits(hardName2.." suffers 24 points of fire damage.")
				DPSMate.Parser:FriendlyPlayerHits(hardName2.." is drowning and loses 23 health.")
				DPSMate.Parser:FriendlyPlayerHits(hardName2.." loses 22 health for swimming in slime.")
			elseif test == 6 then
				DPSMate.Parser:PeriodicDamage(hardName.." is afflicted by "..hardAbName..".")
				DPSMate.Parser:PeriodicDamage(hardName.." suffers 22 Fire damage from "..hardName2.." 's "..hardAbName..". (22 absorbed)")
				DPSMate.Parser:PeriodicDamage(hardName.." suffers 22 Fire damage from your "..hardAbName..". (22 absorbed)")
				DPSMate.Parser:PeriodicDamage(hardName.." 's "..hardAbName.." is absorbed by "..hardName2..".")
				DPSMate.Parser:PeriodicDamage("Your "..hardAbName.." is absorbed by "..hardName2..".")
			elseif test == 7 then
				DPSMate.Parser:FriendlyPlayerMisses(hardName.." misses "..hardName2..".")
				DPSMate.Parser:FriendlyPlayerMisses(hardName.." attacks. "..hardName2.." absorbs all the damage.")
				DPSMate.Parser:FriendlyPlayerMisses(hardName.." attacks. You absorb all the damage.")
				DPSMate.Parser:FriendlyPlayerMisses(hardName.." attacks. "..hardName2.." dodges.")
				DPSMate.Parser:FriendlyPlayerMisses(hardName.." attacks. You dodge.")
				DPSMate.Parser:FriendlyPlayerMisses(hardName.." attacks. "..hardName2.." parries.")
				DPSMate.Parser:FriendlyPlayerMisses(hardName.." attacks. You parry.")
				DPSMate.Parser:FriendlyPlayerMisses(hardName.." attacks. "..hardName2.." blocks.")
				DPSMate.Parser:FriendlyPlayerMisses(hardName.." attacks. You block.")
			elseif test == 8 then
				DPSMate.Parser:SpellDamageShieldsOnSelf("You reflect 22 Fire damage to "..hardName..".")
			elseif test == 9 then
				DPSMate.Parser:SpellDamageShieldsOnOthers(hardName.." reflects 22 Fire damage to "..hardName2..".") -- No results o.o?
			elseif test == 10 then
				DPSMate.Parser:CreatureVsSelfHits(hardName.." hits you for 22 Fire damage. (22 blocked)")
			elseif test == 11 then
				DPSMate.Parser:CreatureVsSelfMisses("") -- TODO
			elseif test == 12 then
				DPSMate.Parser:CreatureVsSelfSpellDamage(hardName.." 's "..hardAbName.." hits you for 22 Fire damage. (22 blocked)")
				DPSMate.Parser:CreatureVsSelfSpellDamage(hardName.." 's "..hardAbName.." crits you for 22 Fire damage. (22 blocked)")
				DPSMate.Parser:CreatureVsSelfSpellDamage(hardName.." 's "..hardAbName.." misses you.")
				DPSMate.Parser:CreatureVsSelfSpellDamage(hardName.." 's "..hardAbName.." was parried.")
				DPSMate.Parser:CreatureVsSelfSpellDamage(hardName.." 's "..hardAbName.." was dodged.")
				DPSMate.Parser:CreatureVsSelfSpellDamage(hardName.." 's "..hardAbName.." was resisted.")
				DPSMate.Parser:CreatureVsSelfSpellDamage("You interrupt "..hardName.." 's "..hardAbName..".")
				DPSMate.Parser:CreatureVsSelfSpellDamage("You absorb "..hardName.." 's "..hardAbName..".")
			elseif test == 13 then
				DPSMate.Parser:PeriodicSelfDamage("You suffer 22 Fire damage from "..hardName.." 's "..hardAbName..". (22 resisted)")
				DPSMate.Parser:PeriodicSelfDamage("You suffer 22 Fire damage from your "..hardAbName..". (22 resisted)")
				DPSMate.Parser:PeriodicSelfDamage("You are afflicted by "..hardAbName.." (3).")
				DPSMate.Parser:PeriodicSelfDamage("You absorb "..hardName.." 's "..hardAbName..".")
			elseif test == 14 then
				DPSMate.Parser:CreatureVsCreatureHits(hardName.." hits "..hardName2.." for 22 Fire damage. (crushing)") 
				DPSMate.Parser:CreatureVsCreatureHits(hardName.." crits "..hardName2.." for 22 Fire damage. (crushing)") 
			elseif test == 15 then
				DPSMate.Parser:CreatureVsCreatureMisses(hardName.." attacks. "..hardName2.." absorbs all the damage.")
				DPSMate.Parser:CreatureVsCreatureMisses(hardName.." attacks. "..hardName2.." parries.")
				DPSMate.Parser:CreatureVsCreatureMisses(hardName.." attacks. "..hardName2.." dodges.")
				DPSMate.Parser:CreatureVsCreatureMisses(hardName.." attacks. "..hardName2.." blocks.")
				DPSMate.Parser:CreatureVsCreatureMisses(hardName.." misses "..hardName2..".")
			elseif test == 16 then
				DPSMate.Parser:SpellPeriodicDamageTaken(hardName.." suffers 22 Fire damage from "..hardName2.." 's "..hardAbName..". (22 resisted)")
				DPSMate.Parser:SpellPeriodicDamageTaken(hardName.." suffers 22 Fire damage from your "..hardAbName..". (22 resisted)")
				DPSMate.Parser:SpellPeriodicDamageTaken(hardName.." is afflicted by "..hardAbName.." (3).")
				DPSMate.Parser:SpellPeriodicDamageTaken(hardName.." 's "..hardAbName.." is absorbed by "..hardName2..".")
			elseif test == 17 then
				DPSMate.Parser:CreatureVsCreatureSpellDamage(hardName.." 's "..hardAbName.." hits "..hardName2.." for 22 Fire damage. (22 resisted)")
				DPSMate.Parser:CreatureVsCreatureSpellDamage(hardName.." 's "..hardAbName.." crits "..hardName2.." for 22 Fire damage. (22 resisted)")
				DPSMate.Parser:CreatureVsCreatureSpellDamage(hardName.." 's "..hardAbName.." was dodged by "..hardName2..".")
				DPSMate.Parser:CreatureVsCreatureSpellDamage(hardName.." 's "..hardAbName.." was parried by "..hardName2..".")
				DPSMate.Parser:CreatureVsCreatureSpellDamage(hardName.." 's "..hardAbName.." missed "..hardName2..".")
				DPSMate.Parser:CreatureVsCreatureSpellDamage(hardName.." 's "..hardAbName.." was resisted by "..hardName2..".")
				DPSMate.Parser:CreatureVsCreatureSpellDamage(hardName.." 's "..hardAbName.." is absorbed by "..hardName2..".")
			elseif test == 18 then
				DPSMate.Parser:SpellSelfBuff("Your "..hardAbName.." critically heals "..hardName.." for 22.")
				DPSMate.Parser:SpellSelfBuff("Your "..hardAbName.." heals "..hardName.." for 22.")
				DPSMate.Parser:SpellSelfBuff("You gain 22 Energy from "..hardAbName..".")
				DPSMate.Parser:SpellSelfBuff("You gain 22 Rage from "..hardAbName..".")
				DPSMate.Parser:SpellSelfBuff("You gain 22 Mana from "..hardAbName..".")
				DPSMate.Parser:SpellSelfBuff("You gain 2 extra attack through "..hardAbName..".")
				DPSMate.Parser:SpellSelfBuff("You gain 2 extra attacks through "..hardAbName..".")
			elseif test == 19 then
				DPSMate.Parser:SpellPeriodicSelfBuff("You gain 22 health from "..hardName.." 's "..hardAbName..".")
				DPSMate.Parser:SpellPeriodicSelfBuff("You gain 22 health from "..hardAbName..".")
				DPSMate.Parser:SpellPeriodicSelfBuff("You gain "..hardAbName..".")
			elseif test == 20 then
				DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(hardName.." gains 22 health from "..hardName2.." 's "..hardAbName..".")
				DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(hardName.." gains 22 health from your "..hardAbName..".")
				DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(hardName.." gains 22 health from "..hardAbName..".")
				DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(hardName.." gains "..hardAbName..".")
			elseif test == 21 then
				DPSMate.Parser:SpellHostilePlayerBuff(hardName.." 's "..hardAbName.." critically heals "..hardName2.." for 22.")
				DPSMate.Parser:SpellHostilePlayerBuff(hardName.." 's "..hardAbName.." heals "..hardName2.." for 22.")
				DPSMate.Parser:SpellHostilePlayerBuff(hardName.." begins to cast "..hardAbName..".")
				DPSMate.Parser:SpellHostilePlayerBuff(hardName.." gains 22 Energy from "..hardName2.." 's "..hardAbName..".")
				DPSMate.Parser:SpellHostilePlayerBuff(hardName.." gains 22 Rage from "..hardName2.." 's "..hardAbName..".")
				DPSMate.Parser:SpellHostilePlayerBuff(hardName.." gains 22 Mana from "..hardName2.." 's "..hardAbName..".")
				DPSMate.Parser:SpellHostilePlayerBuff(hardName.." gains 2 extra attack through "..hardAbName..".")
				DPSMate.Parser:SpellHostilePlayerBuff(hardName.." gains 2 extra attacks through "..hardAbName..".")
			end
		end
	end
end

local function GetNextWord(msg, k, untilList, flg)
	for cat, val in pairs(untilList) do
		local i,j = strfind(msg, val, k, true);
		if i then
			if flg then
				return nil, cat, j+1
			else
				return strsub(msg, k, i-1), cat, j+1
			end
		end
	end
	return nil, -1 -- Nothing found
end

local function GetDamage(nextword)
	local i,j = strfind(nextword, " ", 1, true);
	if i then -- We have a prefix
		local amount = tnbr(strsub(nextword, 1, j-1));
		i = j + 1
		_,j = strfind(nextword, " ", j+1, true);
		return amount, strsub(nextword, i, j-1)
	else
		return tnbr(nextword), ""
	end	
	local debug = DPSMate.Debug and DPSMate.Debug:Store("GetDamage returns nil: Input:"..(nextword or "INPUT NIL")) or DPSMate:SendMessage("GetDamage returns nil: Input:"..(nextword or "INPUT NIL"))
	return nil, nil
end

local function GetPrefix(msg, k)
	-- Prefix like (x absorbed) etc.
	local i,j = strfind(msg, " (", k, true);
	if i then
		k = j+1
		i,j = strfind(msg, " ", k, true);
		
		local prefixAmount = 0;
		if i then
			prefixAmount = tnbr(strsub(msg, k, j-1));
			k = j+1
		end
		i,j = strfind(msg, ")", k, true);
		return prefixAmount, strsub(msg, k, j-1), k
	end
	return nil, nil, nil
end

----------------------------------------------------------------------------------
--------------                    Damage Done                       --------------                                  
----------------------------------------------------------------------------------

local SHChoices = {"hit ", "crit ", "fall and lose ", "lose ", "suffer ", "are drowning and lose "}
function DPSMate.Parser:SelfHits(msg)
	local i,j,k = 0,0,5
	local nextword, choice;
	_, choice, k = GetNextWord(msg, k, SHChoices, true)
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("1: Event not parsed yet => "..msg) or DPSMate:SendMessage("1: Event not parsed yet, inform Shino! => "..msg)
		return
	end
	if choice < 3 then
		local hit, crit = 0, 0
		if choice == 1 then hit = 1 else crit = 1 end
		i,j = strfind(msg, " for ", k, true)
		local target = strsub(msg, k, i-1)
		k = j+1
		i, j = strfind(msg, ".", k, true)
		nextword = strsub(msg, k, i-1);
		k = j+1
		
		local amount, school = GetDamage(nextword)
		local prefixAmount, prefixCase, k = GetPrefix(msg, k)
		
		local glance, block = 0,0
		if prefixCase then
			if prefixCase == "absorbed" then
				DB:SetUnregisterVariables(prefixAmount, AAttack, Player)
			elseif prefixCase == "glancing" then glance = 1; hit=0; crit=0
			else block = 1 end -- We could do more with that info
		end
		
		DB:EnemyDamage(true, nil, Player, AAttack, hit, crit, 0, 0, 0, 0, amount, target, block, 0) -- glance?
		DB:DamageDone(Player, AAttack, hit, crit, 0, 0, 0, 0, amount, glance, block)
		if self.TargetParty[target] then DB:BuildFail(1, target, Player, AAttack, amount);DB:DeathHistory(target, Player, AAttack, amount, hit, crit, 0, 0) end
		return
	elseif choice == 3 then
		i, j = strfind(msg, " health.", k, true)
		local amount = tnbr(strsub(msg, k, i-1))
		DB:DamageTaken(Player, "Falling", 1, 0, 0, 0, 0, 0, amount, "Environment", 0, 0)
		DB:DeathHistory(Player, "Environment", "Falling", amount, 1, 0, 0, 0)
		return
	elseif choice == 4 then
		i, j = strfind(msg, " health", k, true)
		local amount = tnbr(strsub(msg, k, i-1))
		k = j+1
		i, j = strfind(msg, "lava", k, true)
		if i then
			DB:DamageTaken(Player, "Lava", 1, 0, 0, 0, 0, 0, amount, "Environment", 0, 0)
			DB:DeathHistory(Player, "Environment", "Lava", amount, 1, 0, 0, 0)
			DB:AddSpellSchool("Lava","fire")
		else -- Slime
			DB:DamageTaken(Player, "Slime", 1, 0, 0, 0, 0, 0, amount, "Environment", 0, 0)
			DB:DeathHistory(Player, "Environment", "Slime", amount, 1, 0, 0, 0)
		end
		return
	elseif choice == 5 then
		i, j = strfind(msg, " points ", k, true)
		local amount = tnbr(strsub(msg, k, i-1))
		DB:DamageTaken(Player, "Fire", 1, 0, 0, 0, 0, 0, amount, "Environment", 0, 0)
		DB:DeathHistory(Player, "Environment", "Fire", amount, 1, 0, 0, 0)
		DB:AddSpellSchool("Fire","fire")
		return
	else
		i, j = strfind(msg, " health.", k, true)
		local amount = tnbr(strsub(msg, k, i-1))
		DB:DamageTaken(Player, "Drowning", 1, 0, 0, 0, 0, 0, amount, "Environment", 0, 0)
		DB:DeathHistory(Player, "Environment", "Drowning", amount, 1, 0, 0, 0)
		return
	end
end

local SMChoices = {"miss ", "attack. ", "tack but "}
local SMChoices2 = {" absorbs ", " dodges.", " parries.", " blocks.", " deflects."}
function DPSMate.Parser:SelfMisses(msg)
	local i,j,k = 0,0,5
	local nextword, choice;
	_, choice, k = GetNextWord(msg, k, SMChoices, true)
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("2: Event not parsed yet => "..msg) or DPSMate:SendMessage("2: Event not parsed yet, inform Shino! => "..msg)
		return
	end
	if choice == 3 then return end

	if choice == 1 then
		i, j = strfind(msg, ".", k, true)
		local target = strsub(msg, k, i-1)
		DB:EnemyDamage(true, DPSMateEDT, Player, AAttack, 0, 0, 1, 0, 0, 0, 0, target, 0, 0)
		DB:DamageDone(Player, AAttack, 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	else
		nextword, choice, k = GetNextWord(msg, k, SMChoices2, false)
		if choice == 1 then
			DB:Absorb(AAttack, nextword, Player)
		else
			local parry, dodge, block = 0,0,0
			if choice == 2 then dodge = 1
			elseif choice == 3 then parry = 1
			else block = 1 end -- Contains deflect(?)
			DB:EnemyDamage(true, nil, Player, AAttack, 0, 0, 0, parry, dodge, 0, 0, nextword, block, 0)
			DB:DamageDone(Player, AAttack, 0, 0, 0, parry, dodge, 0, 0, 0, block)
		end
		return
	end
end

local SSDChoices = {" hits ", " crits ", " was ", " is parried by ", " missed ", " is absorbed by ", "ast ", " failed.", "You interrupt ", " is reflected back ", "You perform ", "You resisted "}
function DPSMate.Parser:SelfSpellDMG(msg)
	local i,j,k = 0,0,0
	local nextword, choice, ability;
	ability, choice, k = GetNextWord(msg, k, SSDChoices, false)
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("3: Event not parsed yet => "..msg) or DPSMate:SendMessage("3: Event not parsed yet, inform Shino! => "..msg)
		return
	end
	local o,p = strfind(ability, "Your ", 1, true);
	if o then
		ability = strsub(ability, p+1);
	end

	if choice == 8 then return end
	if choice == 10 then return end
	if choice == 11 then return end
	--if choice == 13 then return end

	-- TODO: You resisted your Flames.
	if choice == 12 then
		return
	end
	
	if choice < 3 then
		local hit, crit = 0,0
		if choice == 1 then hit = 1 else crit = 1 end
		i,j = strfind(msg, " for ", k, true)
		local target = strsub(msg, k, i-1)
		k = j+1
		i, j = strfind(msg, ".", k, true)
		nextword = strsub(msg, k, i-1);
		k = j+1
		
		local amount, school = GetDamage(nextword)
		local prefixAmount, prefixCase, k = GetPrefix(msg, k)
		
		DB:AddSpellSchool(ability,school)
		local block = 0
		if prefixCase then
			if prefixCase == "absorbed" then DB:SetUnregisterVariables(amount, ability, Player)
			elseif prefixCase == "blocked" then block = 1; hit=0; crit=0
			else end -- Partial resists(?)
		end
		
		if Kicks[ability] then DB:AssignPotentialKick(Player, ability, target, GetTime()) end
		if DmgProcs[ability] then DB:BuildBuffs(Player, Player, ability, true) end
		DB:EnemyDamage(true, nil, Player, ability, hit, crit, 0, 0, 0, 0, amount, target, block, 0)
		DB:DamageDone(Player, ability, hit, crit, 0, 0, 0, 0, amount, 0, block)
		if self.TargetParty[target] then DB:BuildFail(1, target, Player, ability, amount);DB:DeathHistory(target, Player, ability, amount, hit, crit, 0, 0) end
		return
	elseif choice == 3 then
		i,j = strfind(msg, " by ", k, true);
		local case = strsub(msg, k, i-1);
		k = j+1
		i,j = strfind(msg, ".", k, true);
		local target = strsub(msg, k, j-1);
		
		if case == "dodged" then
			DB:EnemyDamage(true, nil, Player, ability, 0, 0, 0, 0, 1, 0, 0, target, 0, 0)
			DB:DamageDone(Player, ability, 0, 0, 0, 0, 1, 0, 0, 0, 0)
		elseif case == "blocked" then
			DB:EnemyDamage(true, nil, Player, ability, 0, 0, 0, 0, 0, 0, 0, target, 1, 0)
			DB:DamageDone(Player, ability, 0, 0, 0, 0, 0, 0, 0, 0, 1)
		else
			DB:EnemyDamage(true, nil, Player, ability, 0, 0, 0, 0, 0, 1, 0, target, 0, 0)
			DB:DamageDone(Player, ability, 0, 0, 0, 0, 0, 1, 0, 0, 0)
		end
		return
	elseif choice == 4 then
		i,j = strfind(msg, ".", k, true);
		local target = strsub(msg, k, j-1);
		DB:EnemyDamage(true, nil, Player, ability, 0, 0, 0, 1, 0, 0, 0, target, 0, 0)
		DB:DamageDone(Player, ability, 0, 0, 0, 1, 0, 0, 0, 0, 0)
		return
	elseif choice == 5 then
		i,j = strfind(msg, ".", k, true);
		local target = strsub(msg, k, j-1);
		DB:EnemyDamage(true, nil, Player, ability, 0, 0, 1, 0, 0, 0, 0, target, 0, 0)
		DB:DamageDone(Player, ability, 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	elseif choice == 6 then
		i,j = strfind(msg, ".", k, true);
		local target = strsub(msg, k, j-1);
		DB:Absorb(ability, target, Player)
		return
	elseif choice == 7 then
		i,j = strfind(msg, " on ", k, true)
		if i then
			ability = strsub(msg, k, i-1)
			k = j+1
			i,j = strfind(msg, ".", k, true)
			local target = strsub(msg, k, i-1)
			if target=="you" then target = Player end
			if Dispels[ability] then DB:AwaitDispel(ability, target, Player, GetTime()) end
			if RCD[ability] then DPSMate:Broadcast(2, Player, target, ability) end
			return
		else
			i,j = strfind(msg, ".", k, true)
			ability = strsub(msg, k, i-1)
			if Dispels[ability] then DB:AwaitDispel(ability, "Unknown", Player, GetTime()) end
			return
		end	
		return
	elseif choice == 9 then
		i,j = strfind(msg, ".", k, true);
		nextword = strsub(msg, k, j-1);
		i,j = strfind(nextword, " 's ", 1, true)
		local target = strsub(nextword, 1, i-1)
		ability = strsub(nextword, j+1)
		
		local causeAbility = "Counterspell"
		local usr = DPSMateUser[source]
		if usr then
			if usr[2] == "priest" then
				causeAbility = "Silence"
			end
			if usr[4] and usr[6] then
				local owner = DPSMate:GetUserById(usr[6])
				if owner and DPSMateUser[owner] then
					causeAbility = "Spell Lock"
					source = owner
				end
			end
		end
		DB:Kick(Player, target, causeAbility, ability)
		return
	end
end

local PDChoices = {" suffers ", " is afflicted by ", " is absorbed by ", " drains ", " was resisted by "}
function DPSMate.Parser:PeriodicDamage(msg)
	local i,j,k = 0,0,0
	local nextword, choice, source;
	source, choice, k = GetNextWord(msg, k, PDChoices, false)
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("4: Event not parsed yet => "..msg) or DPSMate:SendMessage("4: Event not parsed yet, inform Shino! => "..msg)
		return
	end
	if choice == 4 then return end
	
	if choice == 1 then
		i,j = strfind(msg, " from ", k, true)
		nextword = strsub(msg, k, i-1)
		k = j+1
		local amount, school = GetDamage(nextword)
		i,j = strfind(msg, " 's ", k, true)
		local target;
		if i and j then
			target = strsub(msg, k, i-1)
			k = j+1
		else
			target = Player
			k = k + 5
		end
		i,j = strfind(msg, ".", k, true)
		local ability = strsub(msg, k, i-1);
		local prefixAmount, prefixCase, k = GetPrefix(msg, k)
		
		if prefixCase and prefixCase == "absorbed" then
			DB:SetUnregisterVariables(prefixAmount, ability.."(Periodic)", target)
		end
		DB:EnemyDamage(true, nil, target, ability.."(Periodic)", 1, 0, 0, 0, 0, 0, amount, source, 0, 0)
		DB:DamageDone(target, ability.."(Periodic)", 1, 0, 0, 0, 0, 0, amount, 0, 0)
		if self.TargetParty[source] and self.TargetParty[target] then DB:BuildFail(1, source, target, ability.."(Periodic)", amount);DB:DeathHistory(source, target, ability.."(Periodic)", amount, 1, 0, 0, 0) end
		DB:AddSpellSchool(ability.."(Periodic)",school)
		return
	elseif choice == 2 then
		i,j = strfind(msg, ".", k, true)
		local ability = strsub(msg, k, i-1)
		i,j = strfind(ability, "(", 1, true)
		if i then ability = strsub(ability, 1, i-2) end
		DB:ConfirmAfflicted(source, ability, GetTime())
		if CC[ability] then 
			DB:BuildActiveCC(source, ability)
		end
		return
	elseif choice == 5 then
		i,j = strfind(source, " 's ", 1, true)
		local ability = strsub(source, j+1)
		source = strsub(msg, 1, i-1)
		i,j = strfind(msg, ".", k, true)
		local target = strsub(msg, k, i-1)
		DB:EnemyDamage(true, nil, source, ability.."(Periodic)", 0, 0, 0, 0, 0, 1, amount, target, 0, 0)
		DB:DamageDone(source, ability.."(Periodic)", 0, 0, 0, 0, 0, 1, amount, 0, 0)
		return
	else
		nextword = source
		i,j = strfind(nextword, " 's ", 1, true)
		local ability;
		if i then
			source = strsub(nextword, 1, i-1);
			ability = strsub(nextword, j+1)
		else
			source = Player
			ability = strsub(nextword, 5)
		end
		i,j = strfind(msg, ".", k, true)
		local target = strsub(msg, k, i-1)
		DB:Absorb(ability.."(Periodic)", target, source)
		return
	end
end

local FPDList = {" hits ", " crits ", " was ", " is parried by ", " missed ", " misses ", " is absorbed by ", " fail", " is reflected back ", " immune "}
local FPDList2 = {" begins to cast ", " begins to perform ", " is killed by ", " casts ", " performs "}
function DPSMate.Parser:FriendlyPlayerDamage(msg)
	local i,j,k = 0,0,0;
	local nextword, choice;
	i,j = strfind(msg, " interrupts ", 1, true);
	if not i then
		i,j = strfind(msg, " 's ", 1, true);
		if not i then
			local source
			source, choice, k = GetNextWord(msg, k, FPDList2, false)
			if choice == -1 then
				local debug = DPSMate.Debug and DPSMate.Debug:Store("5: Event not parsed yet => "..msg) or DPSMate:SendMessage("5: Event not parsed yet, inform Shino! => "..msg)
				return
			end
			
			if choice < 3 then
				i,j = strfind(msg, ".", k, true)
				local ability = strsub(msg, k, i-1)
				DB:RegisterPotentialKick(source, ability, GetTime());
			elseif choice == 3 then
				return -- Not handled
			else
				i,j = strfind(msg, " on ", k, true)
				if i then
					local ability = strsub(msg, k, i-1)
					k = j+1
					i,j = strfind(msg, ".", k, true)
					local target = strsub(msg, k, i-1)
					if target=="you" then target = Player end
					if Dispels[ability] then DB:AwaitDispel(ability, target, source, GetTime()) end
					if RCD[ability] then DPSMate:Broadcast(2, source, target, ability) end
					return
				else
					i,j = strfind(msg, ".", k, true)
					local ability = strsub(msg, k, i-1)
					if Dispels[ability] then DB:AwaitDispel(ability, "Unknown", source, GetTime()) end
					return
				end	
			end
			return
		else
			if strfind(msg, "You absorb ", 1, true) then
				i,j = strfind(msg, " 's ", 1, true);
				local target = strsub(msg, 1, i-1)
				k = j+1
				i,j = strfind(msg, ".", k, true)
				local ability = strsub(msg, k, i-1)
				DB:Absorb(ability, Player, target)
				return
			else
				local o,p = strfind(msg, " resists? ", 1);
				if o then
					local tar = strsub(msg, 1, o-1);
					if tar == "You" then
						tar = Player;
					end

					i,j = strfind(msg, " 's ", 1, true);
					local src = strsub(msg, p+1, i-1)
					i,j = strfind(msg, ".", j+1, true)
					local ab = strsub(msg, j+1, i-1)
					DB:EnemyDamage(true, nil, src, ability, 0, 0, 0, 0, 0, 1, 0, tar, 0, 0)
					DB:DamageDone(src, ability, 0, 0, 0, 0, 0, 1, 0, 0, 0)
					return
				end

				local ability;
				local source = strsub(msg, 1, j-4);
				k = j+1
				
				ability, choice, k = GetNextWord(msg, k, FPDList, false)
				if choice == -1 then
					local debug = DPSMate.Debug and DPSMate.Debug:Store("6: Event not parsed yet => "..msg) or DPSMate:SendMessage("6: Event not parsed yet, inform Shino! => "..msg)
					return
				end
				if choice == 8 then return end -- fails
				if choice == 9 then return end -- is reflected back
				if choice == 10 then return end -- immune
				
				if choice < 3 then
					local hit = 0
					if choice == 1 then hit=1 end
					local crit = 0
					if choice == 2 then crit=1 end
					
					i,j = strfind(msg, " for ", k, true);
					local target = strsub(msg, k, i-1);
					k = j+1
					i,j = strfind(msg, ".", k, true);
					nextword = strsub(msg, k, j-1);
					local amount, school = GetDamage(nextword)
					
					if target=="you" then target=Player end
					
					local prefixAmount, prefixCase, k = GetPrefix(msg, k)
					if prefixCase and prefixCase == "absorbed" then
						DB:SetUnregisterVariables(prefixAmount, ability, source)
					end
					
					if Kicks[ability] then DB:AssignPotentialKick(source, ability, target, GetTime()) end
					if DmgProcs[ability] then DB:BuildBuffs(source, source, ability, true) end
					DB:EnemyDamage(true, nil, source, ability, hit, crit, 0, 0, 0, 0, amount, target, 0, 0)
					DB:DamageDone(source, ability, hit, crit, 0, 0, 0, 0, amount, 0, 0)
					
					if self.TargetParty[target] then -- Fixes the issue for pvp death logging
						if self.TargetParty[source] then
							DB:BuildFail(1, target, source, ability, amount);
						end
						DB:DeathHistory(target, source, ability, amount, hit, crit, 0, 0) 
					end
					DB:AddSpellSchool(ability,school)
					
					return
				elseif (choice == 3) then
					i,j = strfind(msg, " by ", k, true);
					if not i then
						-- Resisted
						DB:EnemyDamage(true, nil, source, ability, 0, 0, 0, 0, 0, 1, 0, "Unknown", 0, 0)
						DB:DamageDone(source, ability, 0, 0, 0, 0, 0, 1, 0, 0, 0)
						return
					end
				
					local case = strsub(msg, k, i-1);
					k = j+1
					i,j = strfind(msg, ".", k, true);
					local target = strsub(msg, k, j-1);
					
					if case == "dodged" then
						DB:EnemyDamage(true, nil, source, ability, 0, 0, 0, 0, 1, 0, 0, target, 0, 0)
						DB:DamageDone(source, ability, 0, 0, 0, 0, 1, 0, 0, 0, 0)
					elseif case == "blocked" then
						DB:EnemyDamage(true, nil, source, ability, 0, 0, 0, 0, 0, 0, 0, target, 1, 0)
						DB:DamageDone(source, ability, 0, 0, 0, 0, 0, 0, 0, 0, 1)
					else
						DB:EnemyDamage(true, nil, source, ability, 0, 0, 0, 0, 0, 1, 0, target, 0, 0)
						DB:DamageDone(source, ability, 0, 0, 0, 0, 0, 1, 0, 0, 0)
					end
					return
				elseif (choice == 4) then
					i,j = strfind(msg, ".", k, true);
					local target = strsub(msg, k, j-1);
					DB:EnemyDamage(true, nil, source, ability, 0, 0, 0, 1, 0, 0, 0, target, 0, 0)
					DB:DamageDone(source, ability, 0, 0, 0, 1, 0, 0, 0, 0, 0)
					return
				elseif choice < 7 then
					i,j = strfind(msg, ".", k, true);
					local target = strsub(msg, k, j-1);
					DB:EnemyDamage(true, nil, source, ability, 0, 0, 1, 0, 0, 0, 0, target, 0, 0)
					DB:DamageDone(source, ability, 0, 0, 1, 0, 0, 0, 0, 0, 0)
					return
				elseif choice == 7 then
					i,j = strfind(msg, ".", k, true);
					local target = strsub(msg, k, j-1);
					DB:Absorb(ability, target, source)
					return
				end
			end
		end
	else
		local source = strsub(msg, k, i-1);
		k = j+1
		i,j = strfind(msg, " 's ", k, true);
		if not i then
			local debug = DPSMate.Debug and DPSMate.Debug:Store("26: Event not parsed yet => "..msg) or DPSMate:SendMessage("26: Event not parsed, inform Shino: "..msg)
			return
		end
		
		local target = strsub(msg, k, j-4);
		k = j+1
		i,j = strfind(msg, ".", k, true);
		local ability = strsub(msg, k, j-1);
		
		local causeAbility = "Counterspell"
		local usr = DPSMateUser[source]
		if usr then
			if usr[2] == "priest" then
				causeAbility = "Silence"
			end
			if usr[4] and usr[6] then
				local owner = DPSMate:GetUserById(usr[6])
				if owner and DPSMateUser[owner] then
					causeAbility = "Spell Lock"
					source = owner
				end
			end
		end
		DB:Kick(source, target, causeAbility, ability)
	end
end

local FPHChoices = {" hits ", " crits ", " falls and loses ", " loses ", " suffers ", " is drowning and loses "}
function DPSMate.Parser:FriendlyPlayerHits(msg)
	local i,j,k = 0,0,0
	local nextword, choice, source;
	source, choice, k = GetNextWord(msg, k, FPHChoices, false)
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("7: Event not parsed yet => "..msg) or DPSMate:SendMessage("7: Event not parsed yet, inform Shino! => "..msg)
		return
	end
	if choice < 3 then
		local hit, crit = 0, 0
		if choice == 1 then hit = 1 else crit = 1 end
		i,j = strfind(msg, " for ", k, true)
		local target = strsub(msg, k, i-1)
		k = j+1
		i, j = strfind(msg, ".", k, true)
		nextword = strsub(msg, k, i-1);
		k = j+1
		
		if target=="you" then target=Player end
		
		local amount, school = GetDamage(nextword)
		local prefixAmount, prefixCase, k = GetPrefix(msg, k)
		
		local glance, block = 0,0
		if prefixCase then
			if prefixCase == "absorbed" then
				DB:SetUnregisterVariables(prefixAmount, AAttack, source)
			elseif prefixCase == "glancing" then glance = 1; hit=0; crit=0
			else block = 1 end -- We could do more with that info
		end
		
		DB:EnemyDamage(true, nil, source, AAttack, hit, crit, 0, 0, 0, 0, amount, target, block, 0) -- glance?
		DB:DamageDone(source, AAttack, hit, crit, 0, 0, 0, 0, amount, glance, block)
		if self.TargetParty[target] then 
			if self.TargetParty[source] then
				DB:BuildFail(1, target, source, AAttack, amount);
			end
			DB:DeathHistory(target, source, AAttack, amount, hit, crit, 0, 0)
		end
		return
	elseif choice == 3 then
		i, j = strfind(msg, " health.", k, true)
		local amount = tnbr(strsub(msg, k, i-1))
		DB:DamageTaken(source, "Falling", 1, 0, 0, 0, 0, 0, amount, "Environment", 0, 0)
		DB:DeathHistory(source, "Environment", "Falling", amount, 1, 0, 0, 0)
		return
	elseif choice == 4 then
		i, j = strfind(msg, " health", k, true)
		local amount = tnbr(strsub(msg, k, i-1))
		k = j+1
		i, j = strfind(msg, "lava", k, true)
		if i then
			DB:DamageTaken(source, "Lava", 1, 0, 0, 0, 0, 0, amount, "Environment", 0, 0)
			DB:DeathHistory(source, "Environment", "Lava", amount, 1, 0, 0, 0)
			DB:AddSpellSchool("Lava","fire")
		else -- Slime
			DB:DamageTaken(source, "Slime", 1, 0, 0, 0, 0, 0, amount, "Environment", 0, 0)
			DB:DeathHistory(source, "Environment", "Slime", amount, 1, 0, 0, 0)
		end
		return
	elseif choice == 5 then
		i, j = strfind(msg, " points ", k, true)
		local amount = tnbr(strsub(msg, k, i-1))
		DB:DamageTaken(source, "Fire", 1, 0, 0, 0, 0, 0, amount, "Environment", 0, 0)
		DB:DeathHistory(source, "Environment", "Fire", amount, 1, 0, 0, 0)
		DB:AddSpellSchool("Fire","fire")
		return
	else
		i, j = strfind(msg, " health.", k, true)
		local amount = tnbr(strsub(msg, k, i-1))
		DB:DamageTaken(source, "Drowning", 1, 0, 0, 0, 0, 0, amount, "Environment", 0, 0)
		DB:DeathHistory(source, "Environment", "Drowning", amount, 1, 0, 0, 0)
		return
	end
end

local FPMChoices = {" misses ", " attacks. ", " attacks but "}
local FPMChoices2 = {" dodge", " parr", " block"}
function DPSMate.Parser:FriendlyPlayerMisses(msg)
	local i,j,k = 0,0,0
	local nextword, choice, source;
	source, choice, k = GetNextWord(msg, k, FPMChoices, false)
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("8: Event not parsed yet => "..msg) or DPSMate:SendMessage("8: Event not parsed yet, inform Shino! => "..msg)
		return
	end
	if choice == 1 then
		i, j = strfind(msg, ".", k, true)
		local target = strsub(msg, k, i-1);
		k = j+1
		if target == "you" then target = Player end
		DB:EnemyDamage(true, nil, source, AAttack, 0, 0, 1, 0, 0, 0, 0, target, 0, 0)
		DB:DamageDone(source, AAttack, 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	elseif choice == 2 then
		i, j = strfind(msg, "absorb", k, true)
		local target;
		if i then
			target = strsub(msg, k, i-1)
			if target == "You" then target = Player end
			DB:Absorb(AAttack, target, source)
			return
		else
			target, choice, _ = GetNextWord(msg, k, FPMChoices2, false)
			if target == "You" then target = Player end
			local parry, dodge, block = 0,0,0
			if choice == 1 then dodge = 1
			elseif choice == 2 then parry = 1
			else block = 1 end
			
			DB:EnemyDamage(true, nil, source, AAttack, 0, 0, 0, parry, dodge, 0, 0, target, block, 0)
			DB:DamageDone(source, AAttack, 0, 0, 0, parry, dodge, 0, 0, 0, block)
			return
		end
	else
		-- Ignore but is immune etc
		return
	end
end

function DPSMate.Parser:SpellDamageShieldsOnSelf(msg)
	local i,j = strfind(msg, " to ", 1, true)
	if not i then
		return
	end
	local nextword = strsub(msg, 13, i-1)
	local amount, _ = GetDamage(nextword)
	_,i = strfind(msg, ".", j+1, true)
	local target = strsub(msg, j+1, i-1)
	
	if target == "you" then target = Player end
	DB:EnemyDamage(true, nil, Player, "Reflection", 1, 0, 0, 0, 0, 0, amount, target, 0, 0)
	DB:DamageDone(Player, "Reflection", 1, 0, 0, 0, 0, 0, amount, 0, 0)
	return
end

function DPSMate.Parser:SpellDamageShieldsOnOthers(msg)
	local k;
	local i,j = strfind(msg, " reflects ", 1, true)
	if not i then
		-- There may be resist events, but dont think they are relevant
		return
	end
	
	local source = strsub(msg, 1, i-1)
	k = j+1
	i,j = strfind(msg, " to ", k, true)
	local amount, _ = GetDamage(strsub(msg, k, i-1))
	k = j+1
	i,j = strfind(msg, ".", k, true)
	local target = strsub(msg, k, i-1)
	
	if npcdb:Contains(source) or strfind(source, "%s") then
		DB:EnemyDamage(false, nil, target, "Reflection", 1, 0, 0, 0, 0, 0, amount, source, 0, 0)
		DB:DamageTaken(target, "Reflection", 1, 0, 0, 0, 0, 0, amount, source, 0, 0)
		DB:DeathHistory(target, source, "Reflection", amount, 1, 0, 0, 0)
	else
		DB:EnemyDamage(true, nil, source, "Reflection", 1, 0, 0, 0, 0, 0, amount, target, 0, 0)
		DB:DamageDone(source, "Reflection", 1, 0, 0, 0, 0, 0, amount, 0, 0)
	end
	return
end

----------------------------------------------------------------------------------
--------------                    Damage taken                      --------------                                  
----------------------------------------------------------------------------------

local CVSHChoices = {" hits ", " crits ", " performs "}
function DPSMate.Parser:CreatureVsSelfHits(msg)
	local i,j,k = 0,0,0
	local source, choice, nextword;
	source, choice, k = GetNextWord(msg, k, CVSHChoices, false)
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("9: Event not parsed yet => "..msg) or DPSMate:SendMessage("9: Event not parsed yet, inform Shino! => "..msg)
		return
	end
	if choice < 3 then
		local hit, crit = 0,0
		if choice == 1 then hit = 1 else crit = 1 end
		i,j = strfind(msg, " for ", k, true)
		local target = strsub(msg, k, i-1);
		k = j+1
		if target == "you" then target = Player end
		i,j = strfind(msg, ".", k, true)
		nextword = strsub(msg, k, i-1)
		k = j+1
		local amount, _ = GetDamage(nextword)
		local prefixAmount, prefixCase, _ = GetPrefix(msg, k)
		local crush, block = 0,0
		if prefixCase then
			if prefixCase == "crushing" then crush = 1; hit=0; crit=0;
			elseif prefixCase == "blocked" then block = 1; hit=0; crit=0;
			elseif prefixCase == "absorbed" then
				DB:SetUnregisterVariables(prefixAmount, AAttack, source)
			end
		end
		DB:EnemyDamage(false, nil, target, AAttack, hit, crit, 0, 0, 0, 0, amount, source, block, crush)
		DB:DamageTaken(target, AAttack, hit, crit, 0, 0, 0, 0, amount, source, crush)
		DB:DeathHistory(target, a, AAttack, amount, hit, crit, 0, crush)
	else
		i,j = strfind(msg, " on ", k, true)
		if i then
			local ability = strsub(msg, k, i-1)
			k = j+1
			i,j = strfind(msg, ".", k, true)
			local target = strsub(msg, k, i-1)
			if target=="you" then target = Player end
			if Dispels[ability] then DB:AwaitDispel(ability, target, source, GetTime()) end
			if RCD[ability] then DPSMate:Broadcast(2, source, target, ability) end
			return
		else
			i,j = strfind(msg, ".", k, true)
			local ability = strsub(msg, k, i-1)
			if Dispels[ability] then DB:AwaitDispel(ability, "Unknown", source, GetTime()) end
			return
		end	
		return
	end
	return
end

local CVSMChoices = {" misses ", " attacks. You absorb ", " attacks. ", " attacks but "}
local CVSMChoices2 = {" dodge", " parry", " block", " crush"}
function DPSMate.Parser:CreatureVsSelfMisses(msg)
	local i,j,k = 0,0,0
	local source, choice;
	source, choice, k = GetNextWord(msg, k, CVSMChoices, false)
	
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("10: Event not parsed yet => "..msg) or DPSMate:SendMessage("10: Event not parsed yet, inform Shino! => "..msg)
		return
	end
	if choice == 4 then return end
	
	if choice == 1 then
		i,j = strfind(msg, ".", k, true)
		local target = strsub(msg, k, i-1);
		if target == "you" then target = Player end
		DB:EnemyDamage(false, nil, target, AAttack, 0, 0, 1, 0, 0, 0, 0, source, 0, 0)
		DB:DamageTaken(target, AAttack, 0, 0, 1, 0, 0, 0, 0, source, 0, 0)
	elseif choice == 2 then
		DB:Absorb(AAttack, Player, source)
	else
		local target;
		target, choice, k = GetNextWord(msg, k, CVSMChoices2, false)
		if target == "You" then target = Player end
		local parry, dodge, crush = 0,0,0
		if choice == 2 then parry = 1
		elseif choice == 1 then dodge = 1
		else crush = 1 end
		DB:EnemyDamage(false, nil, target, AAttack, 0, 0, 0, parry, dodge, 0, 0, source, crush, 0)
		DB:DamageTaken(target, AAttack, 0, 0, 0, parry, dodge, 0, 0, source, 0, crush)
	end
	return
end 

local CVSSDChoices = {" hits ", " crits ", " misses you.", " was parried.", " was dodged.", " was resisted.", "You interrupt ", "You absorb ", " performs ", " fail", " was resisted by ", " was blocked.", " missed ", " was dodged by ", " was parried by ", " was blocked by ", "You resist "}
function DPSMate.Parser:CreatureVsSelfSpellDamage(msg)
	local i,j,k = 0,0,0
	local nextword, choice;
	nextword, choice, k = GetNextWord(msg, k, CVSSDChoices, false)
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("11: Event not parsed yet => "..msg) or DPSMate:SendMessage("11: Event not parsed yet, inform Shino! => "..msg)
		return
	end
	if choice == 10 then return end
	
	if choice < 3 then
		local hit,crit = 0,0
		if choice == 1 then hit=1 else crit=1 end
		i,j = strfind(nextword, " 's ", 1, true);
		local source = strsub(nextword, 1, i-1);
		local ability = strsub(nextword, j+1)
		i,j = strfind(msg, " for ", k, true);
		local target = strsub(msg, k, i-1)
		if target == "you" then target = Player end
		k = j+1
		i,j = strfind(msg, ".", k, true)
		nextword = strsub(msg, k, i-1)
		k = j+1
		local amount, school = GetDamage(nextword)
		local prefixAmount, prefixCase = GetPrefix(msg, k)
		
		local block = 0
		if prefixCase then
			if prefixCase == "blocked" then block=1; hit=0; crit=0
			elseif prefixCase == "absorbed" then
				DB:SetUnregisterVariables(prefixAmount, ability, source)
			end
		end
		
		DB:UnregisterPotentialKick(target, ability, GetTime())
		DB:EnemyDamage(false, nil, target, ability, hit, crit, 0, 0, 0, 0, amount, source, block, 0)
		DB:DamageTaken(target, ability, hit, crit, 0, 0, 0, 0, amount, source, 0, block)
		DB:DeathHistory(target, source, ability, amount, hit, crit, 0, 0)
		if FailDT[ability] then DB:BuildFail(2, source, target, ability, amount) end
		DB:AddSpellSchool(ability,school)
		return
	elseif choice < 7 or choice == 12 or choice == 17 then
		local miss, parry, dodge, resist, block = 0,0,0,0,0
		if choice == 3 then miss = 1
		elseif choice == 4 then parry = 1
		elseif choice == 5 then dodge = 1
		elseif choice == 12 then block = 1
		else resist = 1 end
		
		i,j = strfind(nextword, " 's ", 1, true);
		local source = strsub(nextword, 1, i-1);
		local ability = strsub(nextword, j+1)
		
		DB:EnemyDamage(false, nil, Player, ability, 0, 0, miss, parry, dodge, resist, 0, source, block, 0)
		DB:DamageTaken(Player, ability, 0, 0, miss, parry, dodge, resist, 0, source, 0, block)
		return
	elseif choice == 8 then
		i,j = strfind(msg, ".", k, true)
		nextword = strsub(msg, k, i-1)
		
		i,j = strfind(nextword, " 's ", 1, true);
		local source = strsub(nextword, 1, i-1);
		local ability = strsub(nextword, j+1)
		
		if choice == 7 then
			local causeAbility = "Counterspell"
			local usr = DPSMateUser[Player]
			if usr then
				if usr[2] == "priest" then
					causeAbility = "Silence"
				end
			end
			DB:Kick(Player, source, causeAbility, ability)
		else
			DB:Absorb(ability, Player, source)
		end
		return
	elseif choice < 11 then
		i,j = strfind(msg, " on ", k, true)
		if i then
			local ability = strsub(msg, k, i-1)
			if Dispels[ability] then DB:AwaitDispel(ability, Player, source, GetTime()) end
			if RCD[ability] then DPSMate:Broadcast(2, source, Player, ability) end
			return
		else
			i,j = strfind(msg, ".", k, true)
			local ability = strsub(msg, k, i-1)
			if Dispels[ability] then DB:AwaitDispel(ability, Player, source, GetTime()) end
			return
		end	
		return
	else
		local miss, dodge, parry, block, resist = 0,0,0,0,0
		if choice == 13 then miss = 1
		elseif choice == 14 then dodge = 1
		elseif choice == 15 then parry = 1
		elseif choice == 16 then block = 1
		else resist = 1 end

		i,j = strfind(nextword, " 's ", 1, true);
		local source = strsub(nextword, 1, i-1);
		local ability = strsub(nextword, j+1);
		i,j = strfind(msg, ".", k, true);
		local target = strsub(msg, k, i-1);
		DB:EnemyDamage(false, nil, target, ability, 0, 0, miss, parry, dodge, resist, 0, source, 0, block);
		DB:DamageTaken(target, ability, 0, 0, miss, parry, dodge, resist, 0, source, 0, block);
		return
	end
end

local PSDChoices = {"You suffer ", " suffers ", "You are afflicted by ", " is afflicted by ", "You absorb ", " absorbs ", " was resisted.", " was resisted by ", " drains "}
function DPSMate.Parser:PeriodicSelfDamage(msg)
	local i,j,k = 0,0,0
	local nextword, choice;
	local target;
	target, choice, k = GetNextWord(msg, k, PSDChoices, false)
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("12: Event not parsed yet => "..msg) or DPSMate:SendMessage("12: Event not parsed yet, inform Shino! => "..msg)
		return
	end

	-- Do not track drain gains
	if choice == 9 then return end

	if choice < 3 then
		if choice == 1 then target = Player end
		i,j = strfind(msg, " from ", k, true);
		nextword = strsub(msg, k, i-1);
		local amount, school = GetDamage(nextword)
		k = j+1
		
		i,j = strfind(msg, ".", k, true)
		nextword = strsub(msg, k, i-1)
		
		i,j = strfind(nextword, " 's ", 1, true);
		local source, ability
		if i then
			source = strsub(nextword, 1, i-1);
			ability = strsub(nextword, j+1)
		else
			source = Player
			ability = strsub(nextword, 6)
		end
		
		-- Not used
		--local prefixAmount, prefixCase = GetPrefix(msg, k)
		
		DB:EnemyDamage(false, nil, target, ability.."(Periodic)", 1, 0, 0, 0, 0, 0, amount, source, 0, 0)
		DB:DamageTaken(target, ability.."(Periodic)", 1, 0, 0, 0, 0, 0, amount, source, 0, 0)
		DB:DeathHistory(target, source, ability.."(Periodic)", amount, 1, 0, 0, 0)
		if FailDT[ability] then DB:BuildFail(2, source, target, ability, amount) end
		DB:AddSpellSchool(ability.."(Periodic)",school)
		return
	elseif choice < 5 then
		if choice == 3 then target = Player end
		i,j = strfind(msg, ".", k, true)
		local ability = strsub(msg, k, i-1)
		i,j = strfind(ability, "(", 1, true)
		if i then ability=strsub(ability, 1, i-2) end
		
		DB:BuildBuffs("Unknown", target, ability, false)
		if CC[ability] then DB:BuildActiveCC(target, ability) end
		return
	elseif choice < 7 then
		if choice == 5 then target = Player end
		i,j = strfind(msg, " 's ", k, true);
		local source = strsub(msg, k, i-1);
		local ability = strsub(msg, j+1)
		DB:Absorb(ability.."(Periodic)", target, source)
		return
	elseif choice == 8 then
		i,j = strfind(nextword, " 's ", 1, true);
		local source = strsub(nextword, 1, i-1);
		local ability = strsub(nextword, j+1);
		i,j = strfind(msg, ".", k, true)
		local target = strsub(msg, k, i-1)

		DB:EnemyDamage(false, nil, target, ability.."(Periodic)", 0, 0, 0, 0, 0, 1, 0, source, 0, 0)
		DB:DamageTaken(target, ability.."(Periodic)", 0, 0, 0, 0, 0, 1, 0, source, 0, 0)
		return
	else
		i,j = strfind(msg, " 's ", 1, true);
		local source = strsub(msg, 1, i-1);
		local ability = strsub(msg, j+1)
		
		DB:EnemyDamage(false, nil, Player, ability, 0, 0, 0, 0, 0, 1, 0, source, 0, 0)
		DB:DamageTaken(Player, ability, 0, 0, 0, 0, 0, 1, 0, source, 0, 0)
	end
end

local CVCHChoices = {" hits ", " crits "}
function DPSMate.Parser:CreatureVsCreatureHits(msg) 
	local i,j,k = 0,0,0
	local nextword, choice, source;
	source, choice, k = GetNextWord(msg, k, CVCHChoices, false)
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("13: Event not parsed yet => "..msg) or DPSMate:SendMessage("13: Event not parsed yet, inform Shino! => "..msg)
		return
	end
	local hit, crit = 0,0
	if choice == 1 then hit = 1 else crit = 1 end
	i,j = strfind(msg, " for ", k, true)
	local target = strsub(msg, k, i-1)
	k = j+1
	i,j = strfind(msg, ".", k, true)
	nextword = strsub(msg, k, i-1)
	local amount = GetDamage(nextword)
	k = j+1
	local prefixAmount, prefixCase = GetPrefix(msg, k)
	
	local crush, block = 0,0
	if prefixCase then
		if prefixCase == "crushing" then crush = 1; hit=0; crit=0;
		elseif prefixCase == "blocked" then block = 1; hit = 0; crit = 0;
		elseif prefixCase == "absorbed" then
			DB:SetUnregisterVariables(prefixAmount, AAttack, source)
		end
	end
	
	DB:EnemyDamage(false, nil, target, AAttack, hit, crit, 0, 0, 0, 0, amount, source, block, crush)
	DB:DamageTaken(target, AAttack, hit, crit, 0, 0, 0, 0, amount, source, crush, block)
	DB:DeathHistory(target, source, AAttack, amount, hit, crit, 0, crush)
	return
end

local CVCMChoices = {" attacks. ", " misses ", " attacks but "}
local CVCMChoices2 = {" parries.", " dodges.", " blocks."}
function DPSMate.Parser:CreatureVsCreatureMisses(msg)
	local i,j,k = 0,0,0
	local nextword, choice, source;
	source, choice, k = GetNextWord(msg, k, CVCMChoices, false)
	
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("14: Event not parsed yet => "..msg) or DPSMate:SendMessage("14: Event not parsed yet, inform Shino! => "..msg)
		return
	end
	if choice == 1 then
		i,j = strfind(msg, " absorbs ", k, true)
		if i then
			local target = strsub(msg, k, i-1)
			DB:Absorb(AAttack, target, source)
			return
		else
			local target;
			target, choice = GetNextWord(msg, k, CVCMChoices2, false)
			local parry, dodge, block = 0,0,0
			if choice == 1 then parry = 1
			elseif choice == 2 then dodge = 1
			else block = 1 end
			
			DB:EnemyDamage(false, nil, target, AAttack, 0, 0, 0, parry, dodge, 0, 0, source, block, 0)
			DB:DamageTaken(target, AAttack, 0, 0, 0, parry, dodge, 0, 0, source, 0, block)
			return
		end
	elseif choice == 2 then
		i,j = strfind(msg, ".", k, true)
		local target = strsub(msg, k, i-1)
		DB:EnemyDamage(false, nil, target, AAttack, 0, 0, 1, 0, 0, 0, 0, source, 0, 0)
		DB:DamageTaken(target, AAttack, 0, 0, 1, 0, 0, 0, 0, source, 0, 0)
		return
	else
		-- Is immune stuff
		return
	end
end

local SPDTChoices = {" suffers ", " is afflicted by ", " is absorbed by ", " was resisted by ", " Mana "}
function DPSMate.Parser:SpellPeriodicDamageTaken(msg)
	local i,j,k = 0,0,0
	local nextword, choice, source;
	source, choice, k = GetNextWord(msg, k, SPDTChoices, false)
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("15: Event not parsed yet => "..msg) or DPSMate:SendMessage("15: Event not parsed yet, inform Shino! => "..msg)
		return
	end
	
	if choice == 1 then
		i,j = strfind(msg, " from ", k, true);
		nextword = strsub(msg, k, i-1);
		local amount, school = GetDamage(nextword)
		k = j+1
		
		i,j = strfind(msg, ".", k, true)
		nextword = strsub(msg, k, i-1)
		
		i,j = strfind(nextword, " 's ", 1, true);
		local target, ability
		if i then
			target = strsub(nextword, 1, i-1);
			ability = strsub(nextword, j+1)
		else
			target = Player
			ability = strsub(nextword, 6)
		end
		
		-- local prefixAmount, prefixCase = GetPrefix(msg, k)
		DB:EnemyDamage(false, nil, source, ability.."(Periodic)", 1, 0, 0, 0, 0, 0, amount, target, 0, 0)
		DB:DamageTaken(source, ability.."(Periodic)", 1, 0, 0, 0, 0, 0, amount, target, 0, 0)
		DB:DeathHistory(source, target, ability.."(Periodic)", amount, 1, 0, 0, 0)
		if FailDT[ability] then DB:BuildFail(2, target, source, ability, amount) end
		DB:AddSpellSchool(ability.."(Periodic)", school)
		return
	elseif choice == 2 then
		i,j = strfind(msg, ".", k, true)
		local ability = strsub(msg, k, i-1)
		i,j = strfind(ability, "(", 1, true)
		if i then ability=strsub(ability, 1, i-2) end
		DB:BuildBuffs("Unknown", source, ability, false)
		if CC[ability] then DB:BuildActiveCC(source, ability) end
		return
	elseif choice == 3 then
		nextword = source
		i,j = strfind(nextword, " 's ", 1, true)
		source = strsub(nextword, 1, i-1)
		local ability = strsub(nextword, j+1)
		
		i,j = strfind(msg, ".", k, true)
		local target = strsub(msg, k, i-1)
		DB:Absorb(ability.."(Periodic)", source, target)
		return
	elseif choice == 4 then
		i,j = strfind(msg, ".", k, true)
		local target = strsub(msg, k, i-1)
		
		nextword = source
		i,j = strfind(nextword, " 's ", 1, true);
		source = strsub(nextword, 1, i-1);
		local ability = strsub(nextword, j+1)
		DB:EnemyDamage(false, nil, target, ability, 0, 0, 0, 0, 0, 1, 0, source, 0, 0)
		DB:DamageTaken(target, ability, 0, 0, 0, 0, 0, 1, 0, source, 0, 0)
		return
	else
		-- Ignore mana events, we dont track them yet
		return
	end
end

local CVCSDChoices = {" hits ", " crits ", " was dodged by ", " was parried by ", " missed ", " was resisted by ", " is absorbed by ", " begins to cast ", " begins to perform ", " performs ", " casts ", " fails.", " was blocked by ", " interrupts ", " causes ", " is immune to ", " is killed by ", " was evaded by "}
function DPSMate.Parser:CreatureVsCreatureSpellDamage(msg)
	local i,j,k = 0,0,0
	local nextword, choice, source, ability;
	nextword, choice, k = GetNextWord(msg, k, CVCSDChoices, false)
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("16: Event not parsed yet => "..msg) or DPSMate:SendMessage("16: Event not parsed yet, inform Shino! => "..msg)
		return
	end
	if choice == 12 or choice == 16 then return end -- Fail events
	if choice == 15 then return end -- BoS causes damage (Negligable?)
	-- We do not track monster deaths
	if choice == 17 then return end
	-- We do not track evades
	if choice == 18 then return end
	
	if choice == 10 or choice == 11 then
		source = nextword
		i,j = strfind(msg, " on ", k, true)
		if i then
			local ability = strsub(msg, k, i-1)
			k = j+1
			i,j = strfind(msg, ".", k, true)
			local target = strsub(msg, k, i-1)
			if target=="you" then target = Player end
			if Dispels[ability] then DB:AwaitDispel(ability, target, source, GetTime()) end
			if RCD[ability] then DPSMate:Broadcast(2, source, target, ability) end
			return
		else
			i,j = strfind(msg, ".", k, true)
			local ability = strsub(msg, k, i-1)
			if Dispels[ability] then DB:AwaitDispel(ability, "Unknown", source, GetTime()) end
			return
		end	
	elseif choice == 14 then
		source = nextword;
		i,j = strfind(msg, " 's ", 1, true);
		local target = strsub(msg, k, i-1)
		k = j+1
		i,j = strfind(msg, ".", k, true)
		ability = strsub(msg, k, i-1)
		DB:Kick(source, target, "Unknown", ability)
		return
	else
		i,j = strfind(nextword, " 's ", 1, true)
		
		if not i then
			i,j = strfind(msg, ".", k, true)
			local ability = strsub(msg, k, i-1)
			DB:RegisterPotentialKick(nextword, ability, GetTime());
			return
		end
		
		source = strsub(nextword, 1, i-1)
		ability = strsub(nextword, j+1)
		
		if choice < 3 then
			local hit,crit = 0,0
			if choice == 1 then hit=1 else crit = 1 end
			i,j = strfind(msg, " for ", k, true)
			local target = strsub(msg, k, i-1)
			k = j+1
			i,j = strfind(msg, ".", k, true)
			nextword = strsub(msg, k, i-1)
			local amount, school = GetDamage(nextword)
			local prefixAmount, prefixCase = GetPrefix(msg, k)
			
			local block = 0
			if prefixCase then 
				if prefixCase == "blocked" then block = 1
				elseif prefixCase == "absorbed" then
					DB:SetUnregisterVariables(prefixAmount, ability, source)
				end
			end
			
			DB:UnregisterPotentialKick(target, ability, GetTime())
			DB:EnemyDamage(false, nil, target, ability, hit, crit, 0, 0, 0, 0, amount, source, block, 0)
			DB:DamageTaken(target, ability, hit, crit, 0, 0, 0, 0, amount, source, 0, block)
			DB:DeathHistory(target, source, ability, amount, hit, crit, 0, 0)
			if FailDT[ability] then DB:BuildFail(2, source, target, ability, amount) end
			DB:AddSpellSchool(ability,school)
			return
		elseif choice < 7 then
			i,j = strfind(msg, ".", k, true)
			local target = strsub(msg, k, i-1)
			local miss, parry, dodge, resist = 0,0,0,0
			if choice == 3 then dodge = 1
			elseif choice == 4 then parry = 1
			elseif choice == 5 then miss = 1
			else resist = 1 end
			DB:EnemyDamage(false, nil, target, ability, 0, 0, miss, parry, dodge, resist, 0, source, 0, 0)
			DB:DamageTaken(target, ability, 0, 0, miss, parry, dodge, resist, 0, source, 0, 0)
			return
		elseif choice == 7 then
			i,j = strfind(msg, ".", k, true)
			local target = strsub(msg, k, i-1)
			DB:Absorb(ability, source, target)
			return
		else
			i,j = strfind(msg, ".", k, true)
			local target = strsub(msg, k, i-1)
			DB:EnemyDamage(false, nil, target, ability, 0, 0, 0, 0, 0, 0, 0, source, 1, 0)
			DB:DamageTaken(target, ability, 0, 0, 0, 0, 0, 0, 0, source, 0, 1)
			return
		end
	end
end

----------------------------------------------------------------------------------
--------------                       Healing                        --------------                                  
----------------------------------------------------------------------------------

local SSBChoices = {"Your ", "You gain ", "You cast ", "You perform "}
local SSBChoices2 = {" critically heals ", " heals "}
local SSBChoices3 = {" Energy from ", " extra attack through ", " extra attacks through ", " Rage from ", " Mana from "}
function DPSMate.Parser:SpellSelfBuff(msg)
	local i,j,k = 0,0,0
	local nextword, choice;
	_, choice, k = GetNextWord(msg, k, SSBChoices, true)
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("17: Event not parsed yet => "..msg) or DPSMate:SendMessage("17: Event not parsed yet, inform Shino! => "..msg)
		return
	end
	
	if choice == 1 then
		local ability
		ability, choice, k = GetNextWord(msg, k, SSBChoices2, false)
		local hit, crit = 0,0
		if choice == 1 then crit = 1 else hit = 1 end
		i,j = strfind(msg, " for ", k, true)
		local target = strsub(msg, k, i-1)
		k = j+1
		i,j = strfind(msg, ".", k, true)
		local amount = tnbr(strsub(msg, k, i-1))
		
		
		if target=="you" then target=Player end
		local overheal = self:GetOverhealByName(amount, target)
		DB:HealingTaken(0, nil, target, ability, hit, crit, amount, Player)
		DB:HealingTaken(1, nil, target, ability, hit, crit, amount-overheal, Player)
		DB:Healing(0, nil, Player, ability, hit, crit, amount-overheal, target)
		if overheal>0 then 
			DB:Healing(2, nil, Player, ability, hit, crit, overheal, target)
			DB:HealingTaken(2, nil, target, ability, hit, crit, overheal, Player)
		end
		DB:Healing(1, nil, Player, ability, hit, crit, amount, target)
		DB:DeathHistory(target, Player, ability, amount, hit, crit, 1, 0)
		return
	elseif choice == 2 then
		local nextword
		nextword, choice, k = GetNextWord(msg, k, SSBChoices3, false)
		i,j = strfind(msg, ".", k, true)
		local ability = strsub(msg, k, i-1)
		if choice == 1 then
			DB:BuildBuffs(Player, Player, ability, true)
			DB:DestroyBuffs(Player, ability)
		elseif choice < 4 then
			DB:RegisterNextSwing(Player, tnbr(nextword), ability)
			DB:BuildBuffs(Player, Player, ability, true)
			DB:DestroyBuffs(Player, ability)
		elseif choice == 4 then
			if Procs[ability] and not OtherExceptions[ability] then
				DB:BuildBuffs(Player, Player, ability, true)
				DB:DestroyBuffs(Player, ability)
			end
		elseif choice == 5 then
			if Procs[ability] then
				DB:BuildBuffs(Player, Player, ability, true)
				DB:DestroyBuffs(Player, ability)
			end
		end
		return
	elseif choice >= 3 then
		i,j = strfind(msg, " on ", k, true)
		if i then
			local ability = strsub(msg, k, i-1)
			k = j+1
			i,j = strfind(msg, ".", k, true)
			local target = strsub(msg, k, i-1)
			if Dispels[ability] then DB:AwaitDispel(ability, target, Player, GetTime()) end
			if RCD[ability] then DPSMate:Broadcast(2, Player, target, ability) end
			return
		else
			i,j = strfind(msg, ".", k, true)
			local ability = strsub(msg, k, i-1)
			if Dispels[ability] then DB:AwaitDispel(ability, Player, Player, GetTime()) end
			return
		end
	end
end

local HealingStream = "Healing Stream"
local SPSBChoices = { " health from ", "."}
local SPSBChoices1 = { "Happiness", "fades"}
function DPSMate.Parser:SpellPeriodicSelfBuff(msg)
	local i,j,k = 0,0,0
	local nextword, choice, _;
		local source = Player;
		local i,j = strfind(msg, " gains ", 1, true)
		if i and j then
			source = strsub(msg, 1, i-1);
			nextword = strsub(msg, j+1);
			k = j + 1
	else
			k = 10
	end
	
	nextword, choice, k = GetNextWord(msg, k, SPSBChoices, false)
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("18: Event not parsed yet => "..msg) or DPSMate:SendMessage("18: Event not parsed yet, inform Shino! => "..msg)
				return
			end
	if choice == 1 then
		local amount = GetDamage(nextword)
		i,j = strfind(msg, ".", k, true)
		nextword = strsub(msg, k, i-1)
		i,j = strfind(nextword, " 's ", 1, true)
		local target, ability
		if i then
			target = strsub(nextword, 1, i-1)
			ability = strsub(nextword, j+1)
		else
			target = Player
			ability = strsub(nextword, 1)
		end
		
		if ability==HealingStream then
			target = self:AssociateShaman(source, target, false)
		end
		local overheal = self:GetOverhealByName(amount, source)
		DB:HealingTaken(0, nil, source, ability.."(Periodic)", 1, 0, amount, target)
		DB:HealingTaken(1, nil, source, ability.."(Periodic)", 1, 0, amount-overheal, target)
		DB:Healing(0, nil, target, ability.."(Periodic)", 1, 0, amount-overheal, source)
		if overheal>0 then 
			DB:Healing(2, nil, target, ability.."(Periodic)", 1, 0, overheal, source)
			DB:HealingTaken(2, nil, source, ability.."(Periodic)", 1, 0, overheal, target)
		end
		DB:Healing(1, nil, target, ability.."(Periodic)", 1, 0, amount, source)
		DB:DeathHistory(source, target, ability.."(Periodic)", amount, 1, 0, 1, 0)
		return
	else
		_, choice, k = GetNextWord(msg, 1, SPSBChoices1, false)

		if choice > 0 then return end
		i,j = strfind(nextword, "(", 1, true)
		if i then nextword = strsub(nextword, 1, i-2) end
		DB:ConfirmBuff(source, nextword, GetTime())
		if Dispels[nextword] then 
			DB:RegisterHotDispel(source, nextword)
		end
		if ShieldFlags[nextword] then DB:ConfirmAbsorbApplication(nextword, source, GetTime()) end
		if RCD[nextword] then DPSMate:Broadcast(1, source, nextword) end
		if FailDB[nextword] then DB:BuildFail(3, "Environment", source, nextword, 0) end
		return
	end
end

function DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(msg)
	local i,j,k = 0,0,0
	i,j = strfind(msg, " gains ", 1, true)
	if not i then
		-- Drain event
		-- Also you gain whatever
		-- Is Slain whatever
		return
	end
	
	local source = strsub(msg, 1, i-1)
	k = j+1
	i,j = strfind(msg, " health from ", k, true)
	if i then
		local amount = tnbr(strsub(msg, k, i-1))
		k = j+1
		i,j = strfind(msg, ".", k, true)
		local nextword = strsub(msg, k, i-1)
		
		local target, ability
		i,j = strfind(nextword, " 's ", 1, true)
		if i then
			target = strsub(nextword, 1, i-1)
			ability = strsub(nextword, j+1)
		else
			i,j = strfind(nextword, "your ", 1, true)
			if i then
				target = Player
				ability = strsub(nextword, j+1)
			else
				target = source
				ability = nextword
			end
		end
		
		if ability==HealingStream then
			target = self:AssociateShaman(amount, target, false)
		end
		local overheal = self:GetOverhealByName(amount, source)
		DB:HealingTaken(0, nil, source, ability.."(Periodic)", 1, 0, amount, target)
		DB:HealingTaken(1, nil, source, ability.."(Periodic)", 1, 0, amount-overheal, target)
		DB:Healing(0, nil, target, ability.."(Periodic)", 1, 0, amount-overheal, source)
		if overheal>0 then 
			DB:Healing(2, nil, target, ability.."(Periodic)", 1, 0, overheal, source)
			DB:HealingTaken(2, nil, source, ability.."(Periodic)", 1, 0, overheal, target)
		end
		DB:Healing(1, nil, target, ability.."(Periodic)", 1, 0, amount, source)
		DB:DeathHistory(source, target, ability.."(Periodic)", amount, 1, 0, 1, 0)
		return
	else
		i,j = strfind(msg, ".", k, true)
		local ability = strsub(msg, k, i-1)
		i,j = strfind(ability, "(", 1, true)
		if i then ability = strsub(ability, 1, i-2) end
		
		if self.BuffExceptions[ability] then return end
		
		if ShieldFlags[ability] then DB:ConfirmAbsorbApplication(ability, source, GetTime()) end
		
		DB:ConfirmBuff(source, ability, GetTime())
		if Dispels[ability] then
			DB:RegisterHotDispel(source, ability)
		end
		if RCD[ability] then DPSMate:Broadcast(1, source, ability) end
		if FailDB[ability] then DB:BuildFail(3, "Environment", source, ability, 0) end
		return
	end
end

local SHPBChoices = {" critically heals ", " heals ", " begins to cast ", " begins to perform ", " gains ", " casts ", " performs ", " were resisted by ", " was resisted by ", " resists ", " fail", "You gain ", " is reflected back by ", "You resist ", " was evaded by "}
local SHPBChoices2 = {" extra attack through ", " extra attacks through ", " Energy from ", " Rage from ", " Mana from "}
function DPSMate.Parser:SpellHostilePlayerBuff(msg)
	local i,j,k = 0,0,0
	local nextword, choice;
	nextword, choice, k = GetNextWord(msg, k, SHPBChoices, false)
	if choice == -1 then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("19: Event not parsed yet => "..msg) or DPSMate:SendMessage("19: Event not parsed yet, inform Shino! => "..msg)
		return
	end
	
	-- Ignoring for now
	-- Saltpillar's Thorns were resisted by Blackhand Veteran
	if choice >= 8 then return end
	-- TODO: Spell reflect handling
	if choice == 12 then return end
	-- TODO: Spell resists
	if choice == 13 then return end

	-- Do not track
	if choice == 14 then return end
	
	if choice < 3 then
		i,j = strfind(nextword, " 's ", 1, true)
		local source = strsub(nextword, 1, i-1)
		local ability = strsub(nextword, j+1)
		i,j = strfind(msg, " for ", k, true)
		local target = strsub(msg, k, i-1)
		k = j+1
		i,j = strfind(msg, ".", k, true)
		local amount = tnbr(strsub(msg, k, i-1))
		
		local hit,crit = 0,0
		if choice == 1 then crit=1 else hit =1 end
		if target == "you" then target = Player end
		
		local overheal = self:GetOverhealByName(amount, target)
		DB:HealingTaken(0, nil, target, ability, hit, crit, amount, source)
		DB:HealingTaken(1, nil, target, ability, hit, crit, amount-overheal, source)
		DB:Healing(0, nil, source, ability, hit, crit, amount-overheal, target)
		if overheal>0 then 
			DB:Healing(2, nil, source, ability, hit, crit, overheal, target)
			DB:HealingTaken(2, nil, target, ability, hit, crit, overheal, source)
		end
		DB:Healing(1, nil, source, ability, hit, crit, amount, target)
		DB:DeathHistory(target, source, ability, amount, hit, crit, 1, 0)
		
		if Procs[ability] and not OtherExceptions[ability] then
			DB:BuildBuffs(source, target, ability, true)
		end
		return
	elseif choice < 5 then
		i,j = strfind(msg, ".", k, true)
		local ability = strsub(msg, k, i-1)
		DB:RegisterPotentialKick(nextword, ability, GetTime())
		return
	elseif choice == 5 or choice == 12 then
		local source = nextword
		if choice == 12 then
			source = Player
		end
		nextword, choice, k = GetNextWord(msg, k, SHPBChoices2, false)
		local amount = tnbr(nextword)
		i,j = strfind(msg, ".", k, true)
		nextword = strsub(msg, k, i-1)

		-- TODO: Dafuq? => This will never happen
		if choice < 3 then
			local ability = nextword
			
			if ShieldFlags[ability] then DB:ConfirmAbsorbApplication(ability, source, GetTime()) end
			DB:RegisterNextSwing(source, amount, ability)
			DB:BuildBuffs(source, source, ability, true)
			DB:DestroyBuffs(source, ability)
		else
			i,j = strfind(nextword, " 's ", 1, true)
			local target = strsub(nextword, 1, i-1)
			local ability = strsub(nextword, j+1)
			
			if choice == 3 then
				DB:BuildBuffs(target, source, ability, true)
				DB:DestroyBuffs(target, ability)
			elseif choice == 4 then
				if Procs[ability] and not OtherExceptions[ability] then
					DB:BuildBuffs(target, source, ability, true)
					DB:DestroyBuffs(target, ability)
				end
			elseif choice == 5 then
				if Procs[ability] then
					DB:BuildBuffs(target, source, ability, true)
					DB:DestroyBuffs(target, ability)
				end
			end
		end
		return
	else
		i,j = strfind(msg, " on ", k, true)
		if i then
			local ability = strsub(msg, k, i-1)
			k = j+1
			i,j = strfind(msg, ".", k, true)
			local target = strsub(msg, k, i-1)
			if target=="you" then target = Player end
			if Dispels[ability] then DB:AwaitDispel(ability, target, nextword, GetTime()) end
			if RCD[ability] then DPSMate:Broadcast(2, nextword, target, ability) end
			return
		else
			i,j = strfind(msg, ".", k, true)
			local ability = strsub(msg, k, i-1)
			if Dispels[ability] then DB:AwaitDispel(ability, "Unknown", source, GetTime()) end
			return
		end	
	end
end

----------------------------------------------------------------------------------
--------------                       Absorbs                        --------------                                  
----------------------------------------------------------------------------------

-- At CreatureVsSelfHits 
function DPSMate.Parser:CreatureVsSelfHitsAbsorb(msg)
	return
end

-- At CreatureVsCreatureHits
function DPSMate.Parser:CreatureVsCreatureHitsAbsorb(msg)
	return
end

-- At CreatureVsSelfSpellDamage
function DPSMate.Parser:CreatureVsSelfSpellDamageAbsorb(msg)
	return
end

-- At CreatureVsCreatureSpellDamage
function DPSMate.Parser:CreatureVsCreatureSpellDamageAbsorb(msg)
	return
end

-- At SpellPeriodicSelfBuff
function DPSMate.Parser:SpellPeriodicSelfBuffAbsorb(msg)
	return
end

-- At SpellPeriodicFriendlyPlayerBuffs
function DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffsAbsorb(msg)
	return
end

function DPSMate.Parser:SpellAuraGoneSelf(msg)
	local i,j = strfind(msg, " from ", 1, true)
	i = strfind(msg, ".", j+1, true)
	local source = strsub(msg, j+1, i -1)
	if source == "you" then source = Player end
	local i,j = strfind(msg, " fades ", 1, true)
	local ability = strsub(msg, 1, i-1)
	i,j = strfind(ability, "(", 1, true)
	if i then ability = strsub(ability, 1, i-2) end
	if BuffExceptions[ability] then return end
	if ShieldFlags[ability] then DB:UnregisterAbsorb(ability, source) end
	if RCD[ability] then DPSMate:Broadcast(6, source, ability) end
	DB:DestroyBuffs(source, ability)
	DB:UnregisterHotDispel(source, ability)
	DB:RemoveActiveCC(source, ability)
	return
end

function DPSMate.Parser:SpellAuraGoneParty(msg)
	local i,j = strfind(msg, " fades from ", 1, true)
	local ability = strsub(msg, 1, i-1)
	local i = strfind(msg, ".", j+1, true)
	local target = strsub(msg, j+1, i-1)
	
	i,j = strfind(ability, "(", 1, true)
	if i then ability = strsub(ability, 1, i-2) end
	if self.BuffExceptions[ability] then return end
	if ShieldFlags[ability] then DB:UnregisterAbsorb(ability, target) end
	if RCD[ability] then DPSMate:Broadcast(6, target, ability) end
	DB:DestroyBuffs(target, ability)
	DB:UnregisterHotDispel(target, ability)
	DB:RemoveActiveCC(target, ability)
	return
end

function DPSMate.Parser:SpellAuraGoneOther(msg)
	local i,j = strfind(msg, " fades from ", 1, true)
	local ability = strsub(msg, 1, i-1)
	local i = strfind(msg, ".", j+1, true)
	local target = strsub(msg, j+1, i-1)
	
	i,j = strfind(ability, "(", 1, true)
	if i then ability = strsub(ability, 1, i-2) end
	if BuffExceptions[ability] then return end
	if ShieldFlags[ability] then DB:UnregisterAbsorb(ability, target) end
	if RCD[ability] then DPSMate:Broadcast(6, target, ability) end
	DB:DestroyBuffs(target, ability)
	DB:UnregisterHotDispel(target, ability)
	DB:RemoveActiveCC(target, ability)
	return
end

----------------------------------------------------------------------------------
--------------                       Dispels                        --------------                                  
----------------------------------------------------------------------------------

-- At SpellSelfBuff
function DPSMate.Parser:SpellSelfBuffDispels(msg)
	return
end

-- At SpellHostilePlayerBuff
function DPSMate.Parser:SpellHostilePlayerBuffDispels(msg)
	return
end

function DPSMate.Parser:SpellBreakAura(msg) 
	local i,j = strfind(msg, " is removed.", 1, true)
	local nextword = strsub(msg, 1, i-1)
	i,j = strfind(msg, " 's ", 1, true)
	local source, ability
	if i then
		source = strsub(nextword, 1, i-1)
		ability = strsub(nextword, j+1)
	else
		source = Player
		ability = strsub(nextword, 6)
	end
	DB:ConfirmRealDispel(ability, source, GetTime())
	return
end

----------------------------------------------------------------------------------
--------------                       Deaths                         --------------                                  
----------------------------------------------------------------------------------

local CFDChoices = {" dies. ", " die.", " dies.", " is slain by ", " is destroyed.", "You have slain ", " slays "}
function DPSMate.Parser:CombatFriendlyDeath(msg)
	local i,j,k = 0,0,0
	local source, choice
	source, choice, k = GetNextWord(msg, k, CFDChoices, false)
	if not source then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("30: Event not parsed correctly : "..msg) or DPSMate:SendMessage("30: Event not parsed correctly, inform Shino!: "..msg);
		return;
	end
	if choice == 2 then
		source = Player
	end

	if choice == 6 then
		source = strsub(msg, k, -1);
	end
	
	if choice == 7 then
		return;
	end
	
	DB:UnregisterDeath(source)
	return
end

function DPSMate.Parser:CombatHostileDeaths(msg)
	local i,j = strfind(msg, "You have ", 1, true)
	if i then return end
	
	i,j = strfind(msg, " dies.", 1, true)
	if not i then
		return
	end
	local source = strsub(msg, 1, i-1)
	if not source then
		local debug = DPSMate.Debug and DPSMate.Debug:Store("31: Event not parsed correctly : "..msg) or DPSMate:SendMessage("31: Event not parsed correctly, inform Shino!: "..msg);
		return;
	end
	DB:UnregisterDeath(source)
	return
end

----------------------------------------------------------------------------------
--------------                     Interrupts                       --------------                                  
----------------------------------------------------------------------------------

-- At CreatureVsCreatureSpellDamage
function DPSMate.Parser:CreatureVsCreatureSpellDamageInterrupts(msg)
	return
end

-- At SpellHostilePlayerBuff
function DPSMate.Parser:HostilePlayerSpellDamageInterrupts(msg)
	return
end

function DPSMate.Parser:PetHits(msg)
	self:FriendlyPlayerHits(msg)
end

function DPSMate.Parser:PetMisses(msg)
	self:FriendlyPlayerMisses(msg)
end

function DPSMate.Parser:PetSpellDamage(msg)
	self:FriendlyPlayerDamage(msg)
end