-- Events
DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_PET_HITS")
DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_PET_MISSES")
--DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PET_BUFF")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE")

DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE") --
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE") --
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_PARTY_HITS")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE")
DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_PARTY_MISSES")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE")
DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS")
DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES")

DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS")
DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES")

DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS")
DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS")
DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE")
DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS")
DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE") 

DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PARTY_BUFF")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS")

DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_BREAK_AURA")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
DPSMate.Parser:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY")

DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
DPSMate.Parser:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
DPSMate.Parser:RegisterEvent("PLAYER_AURAS_CHANGED")

DPSMate.Parser:RegisterEvent("PLAYER_LOGOUT")
DPSMate.Parser:RegisterEvent("PLAYER_ENTERING_WORLD")

BINDING_HEADER_DPSMATE = "DPSMate"
BINDING_NAME_DPSMATE_REPORT = DPSMate.L["togglereportframe"]
BINDING_NAME_DPSMATE_TOGGLE = DPSMate.L["toggleframes"]
BINDING_NAME_DPSMATE_RESET = DPSMate.L["resetdpsmate"]

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
	
	--New
	["Felstriker"] = true,
	["Sanctuary"] = true,
	["Fury of Forgewright"] = true,
	["Primal Blessing"] = true,
	["Spinal Reaper"] = true, -- To test
	["Netherwind Focus"] = true, -- To test
	["Parry"] = true, -- To test
	["Untamed Fury"] = true,
	["The Eye of Diminution"] = true,
	["Kiss of the Spider"] = true,
	["Glyph of Deflection"] = true,
	["The Eye of the Dead"] = true,
	["Slayer's Crest"] = true,
	["Badge of the Swarmguard"] = true,
	["Arcane Shroud"] = true,
	["Persistent Shield"] = true,
	["Jom Gabbar"] = true,
	["The Burrower's Shell"] = true,
	["Thrash"] = true,
	["Free Action"] = true,
	["Living Free Action"] = true,
	["Restoration"] = true,
	["Speed"] = true,
	["Invulnerability"] = true,
	["Aura of the Blue Dragon"] = true, -- Mana Darkmoon card
	["Invulnerability"] = true,
	["Battle Squawk"] = true,
	["Devilsaur Fury"] = true,
	["Furious Howl"] = true,
	["Healing Potion"] = true,
	["Major Rejuvenation Potion"] = true,
	["Mana Potion"] = true,
	["Restore Mana"] = true,
	["Dreamless Sleep"] = true,
	
	
	-- Rogue
	["Slice and Dice"] = true,
	["Blade Flurry"] = true,
	["Sprint"] = true,
	["Adrenaline Rush"] = true,
	["Vanish"] = true,
	["Relentless Strikes Effect"] = true,
	["Ruthlessness"] = true, -- To Test!!!!
	["Rogue Armor Energize Effect"] = true,
	["Rogue Armor Energize"] = true,
	["Invigorate"] = true,
	["Head Rush"] = true,
	["Venomous Totem"] = true,
	["Evasion"] = true,
	["Restore Energy"] = true,
	["Remorseless Attacks"] = true,
	
	-- Mage
	["Arcane Power"] = true,
	["Combustion"] = true,
	["Mind Quickening"] = true,
	["Enigma Resist Bonus"] = true,
	["Enigma Blizzard Bonus"] = true,
	["Adaptive Warding"] = true,
	["Not There"] = true,
	["Cold Snap"] = true,
	["Presence of Mind"] = true,
	["Ice Block"] = true,
	["Evocation"] = true,
	
	-- Priest
	["Power Infusion"] = true,
	["Oracle Healing Bonus"] = true,
	["Epiphany"] = true,
	["Aegis of Preservation"] = true,
	["Inspiration"] = true,
	["Blessed Recovery"] = true,
	["Focused Casting"] = true,
	["Spirit Tap"] = true,
	
	-- Druid
	["Symbols of Unending Life Finisher Bonus"] = true,
	["Metamorphosis Rune"] = true,
	["Clearcasting"] = true,
	["Nature's Grace"] = true,
	
	-- Paladin
	["Battlegear of Eternal Justice"] = true,
	["Blinding Light"] = true,
	["Divine Favor"] = true,
	["Divine Shield"] = true,
	["Redoubt"] = true,
	["Holy Shield"] = true,
	["Vengeance"] = true,
	["Blessing of Freedom"] = true,
	["Blessing of Sacrifice"] = true,
	["Blessing of Protection"] = true,
	
	-- Shaman
	["Stormcaller's Wrath"] = true,
	["Nature Aligned"] = true,
	["Elemental Mastery"] = true,
	["Windfury Weapon"] = true,
	["Windfury Totem"] = true,
	["Nature's Swiftness"] = true,
	["Ancestral Healing"] = true,
	["Reincarnation"] = true,
	["Elemental Mastery"] = true,
	
	-- Warlock
	["Vampirism"] = true,
	["Nightfall"] = true,
	["Soul Link"] = true,
	["Life Tap"] = true,
	
	-- Warrior
	["Cheat Death"] = true,
	["Gift of Life"] = true,
	["Bloodrage"] = true,
	["Flurry"] = true,
	["Enrage"] = true,
	["Sweeping Strikes"] = true,
	["Death Wish"] = true,
	["Recklessness"] = true,
	["Mighty Rage"] = true,
	["Great Rage"] = true,
	["Rage"] = true,
	["Berserker Rage"] = true,
	["Shield Wall"] = true,
	["Retaliation"] = true,
	["Diamond Flask"] = true,
	["Shield Block"] = true,
	["Last Stand"] = true,
	
	-- Hunter
	["Arcane Infused"] = true,
	["Quick Shots"] = true,
	["Rapid Fire"] = true,
	
	-- Boss Spells
	["Lucifron's Curse"] = true,
	["Gehennas' Curse"] = true,
	["Panic"] = true,
	["Living Bomb"] = true,
	["Brood Affliction: Bronze"] = true,
	["Bellowing Roar"] = true,
	["Fear"] = true,
	["Entangle"] = true,
	["Digestive Acid"] = true,
	["Locust Swarm"] = true,
	["Web Wrap"] = true,
	["Mutating Injection"] = true,
	["Terrifying Roar"] = true,
}

DPSMate.Parser.BuffExceptions = {
	["Fury of Forgewright"] = true,
	["Bloodfang"] = true,
}

DPSMate.Parser.OtherExceptions = {
	["Mighty Rage"] = true,
	["Bloodrage"] = true,
	["Holy Strength"] = true,
	["Dreamless Sleep"] = true,
	["Vampirism"] = true,
}
DPSMate.Parser.DmgProcs = {
	-- General
	["Life Steal"] = true,
	["Thunderfury"] = true,
	-- New
	["Bloodfang"] = true,
	["Fatal Wound"] = true,
	["Decapitate"] = true,
	["Gutgore Ripper"] = true,
	["Firebolt"] = true,
	-- Can't add Hand of Ragnaros
	["Expose Weakness"] = true, -- To Test
	["Silence"] = true, -- To Test
	["Chilled"] = true, -- To Test
	["Glimpse of Madness"] = true, -- To Test
	["Engulfing Shadows"] = true, -- To Test
	["Elemental Vulnerability"] = true, -- To Test
	["Holy Power"] = true, -- To Test
	["Revealed Flaw"] = true, -- To Test
	["Totemic Power"] = true, -- To Test
	["Stygian Grasp"] = true, -- To Test
	["Electric Discharge"] = true, -- To Test
	["Flame Lash"] = true, -- To Test
	["Spell Vulnerability"] = true, -- To Test
	["Lightning Strike"] = true, -- To Test
	-- Deathbringer Skipped
}
DPSMate.Parser.TargetParty = {}
DPSMate.Parser.RCD = {
	["Shield Wall"] = true,
	["Recklessness"] = true,
	["Retaliation"] = true,
	["Last Stand"] = true,
	["Innervate"] = true,
	["Divine Shield"] = true,
	["Blessing of Protection"] = true,
	["Gift of Life"] = true,
	["Redemption"] = true,
	["Rebirth"] = true,
	["Resurrection"] = true,
	["Reincarnation"] = true,
	["Ancestral Spirit"] = true,
	["Soulstone Resurrection"] = true,
}
DPSMate.Parser.FailDT = {
	-- Molten Core
	["Rain of Fire"] = true,
	["Cone of Fire"] = true,
	["Lava Bomb"] = true,
	["Eruption"] = true,
	["Earthquake"] = true,
	["Hand of Ragnaros"] = true,
	["Wrath of Ragnaros"] = true,
	["Conflagration"] = true,
	
	-- Blackwing Lair
	["War Stomp"] = true,
	["Incinerate"] = true,
	["Corrosive Acid"] = true,
	["Frost Burn"] = true,
	["Ignite Flesh"] = true,
	["Time Lapse"] = true,
	
	-- Zul Gurub
	["Whirlwind"] = true,
	["Charge"] = true,
	["Poison Cloud"] = true,
	
	-- AQ 20
	["Arcane Eruption"] = true,
	["Harsh Winds"] = true,
	["Sand Trap"] = true,
	
	-- AQ 40
	["Toxin Cloud"] = true,
	["Arcane Burst"] = true,
	["Eye Beam"] = true,
	["Dark Glare"] = true,
	
	-- Naxx
	["Negative Charge"] = true,
	["Positive Charge"] = true,
	["Void Zone"] = true,
	["Plague Cloud"] = true,
	["Blizzard"] = true,
	["Chill"] = true,
	["Frost Breath"] = true,
	["Mana Detonation"] = true,
	["Shadow Fissure"] = true,
	
}
DPSMate.Parser.FailDB = {
	-- Molten Core
	
	-- Blackwing Lair
	["Suppression Aura"] = true,
	["Bellowing Roar"] = true,
}
DPSMate.Parser.CC = {
	["Sap"] = true,
	["Gouge"] = true,
	["Sleep"] = true,
	["Polymorph"] = true,
	["Greater Polymorph"] = true,
	["Polymorph: Chicken"] = true,
	["Polymorph: Cow"] = true,
	["Polymorph: Pig"] = true,
	["Polymorph: Sheep"] = true,
	["Polymorph: Turtle"] = true,
	["Blind"] = true,
	["Freezing Trap Effect"] = true,
	["Intimidating Shout"] = true,
	["Magic Dust"] = true,
	["Scatter Shot"] = true,
	["Wyvern Sting"] = true,
	["Seduction"] = true,
	["Repentance"] = true,
	["Shackle Undead"] = true,
	["Reckless Charge"] = true,
}

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
	-- Potion
	["Powerful Anti-Venom"] = true,
	["Restoration"] = true,
	["Purification"] = true,
	["Purification Potion"] = true,
	["Restorative Potion"] = true,
}
DPSMate.Parser.DeCurse = {
	["Remove Curse"] = true,
	["Remove Lesser Curse"] = true,
	["Restoration"] = true,
	["Purification"] = true,
}
DPSMate.Parser.DeMagic = {
	["Dispel Magic"] = true,
	["Devour Magic"] = true,
	["Purge"] = true,
	["Restoration"] = true,
}
DPSMate.Parser.DeDisease = {
	["Purify"] = true,
	["Abolish Disease"] = true,
	["Cure Disease"] = true,
	["Disease Cleansing Totem"] = true,
	["Restoration"] = true,
	["Purification"] = true,
}
DPSMate.Parser.DePoison = {
	["Abolish Poison"] = true,
	["Purify"] = true,
	["Poison Cleansing Totem"] = true,
	["Cure Poison"] = true,
	["Powerful Anti-Venom"] = true,
	["Restoration"] = true,
	["Purification"] = true,
}
DPSMate.Parser.DebuffTypes = {}
DPSMate.Parser.HotDispels = {
	["Abolish Poison"] = true,
	["Abolish Disease"] = true,
	["Restoration"] = true,
}

DPSMate.Parser.Kicks = {
	-- Interrupts
	-- Rogue
	["Kick"] = true,
	-- Warrior
	["Pummel"] = true,
	["Shield Bash"] = true,
	
	-- Mage
	["Counterspell"] = true,
	
	-- Shaman
	["Earth Shock"] = true,
	
	-- Priest
	["Silence"] = true,
	
	-- Stuns
	-- Rogue
	["Gouge"] = true,
	["Kidney Shot"] = true,
	["Cheap Shot"] = true,
	
	-- Hunter
	["Scatter Shot"] = true,
	["Improved Concussive Shot"] = true,
	["Wyvern Sting"] = true,
	["Intimidation"] = true,
	
	-- Warrior
	["Charge Stun"] = true,
	["Intercept Stun"] = true,
	["Concussion Blow"] = true,
	
	-- Druid
	["Feral Charge"] = true,
	["Feral Charge Effect"] = true,
	["Bash"] = true,
	["Pounce"] = true,
	
	-- Mage
	["Impact"] = true,
	
	-- Paladin
	["Repentance"] = true,
	["Hammer of Justice"] = true,
	
	-- Warlock
	["Pyroclasm"] = true,
	["Death Coil"] = true,
	
	-- Priest
	["Blackout"] = true,
	
	-- General
	["Tidal Charm"] = true,
	["Reckless Charge"] = true,
}
DPSMate.Parser.player = UnitName("player")
DPSMate.Parser.playerclass = nil

-- Local Variables
local _,playerclass = UnitClass("player")
local fac = UnitFactionGroup("player")
local UL = UnitLevel

-- Begin Functions

function DPSMate.Parser:OnLoad()
	self.player = UnitName("player")
	_,playerclass = UnitClass("player")
	DPSMate.DB:BuildUser(self.player, strlower(playerclass))
	DPSMateUser[self.player][2] = strlower(playerclass)
	DPSMateUser[self.player][8] = UL("player")
	-- Prevent this addon from causing issues
	if SW_FixLogStrings then
		DPSMate:SendMessage("Please disable SW_StatsFixLogStrings and SW_Stats. Those addons cause issues.")
	end
end

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

local UnitClass = UnitClass
local UnitName = UnitName
local GetNumPartyMembers = GetNumPartyMembers
local GetNumRaidMembers = GetNumRaidMembers
local GetRaidRosterInfo = GetRaidRosterInfo
local subGRP, PSGRP, c
function DPSMate.Parser:AssociateShaman(name, old, update)
	if not subGRP or not PSGRP[name] or update then
		local tnum = GetNumPartyMembers()
		subGRP, PSGRP = {}, {}
		if tnum <= 0 then
			tnum=GetNumRaidMembers()
			for i=1, tnum do
				_, _, c = GetRaidRosterInfo(i)
				if UnitClass("raid"..i)==DPSMate.L["shaman"] then
					subGRP[c] = UnitName("raid"..i)
				end
				PSGRP[UnitName("raid"..i)] = c
			end
		else
			for i=1, tnum do
				if UnitClass("party"..i)==DPSMate.L["shaman"] then
					subGRP[1] = UnitName("party"..i)
				end
				PSGRP[UnitName("party"..i)] = 1
			end
			PSGRP[name] = 1
		end
	end
	if PSGRP[name] and subGRP[PSGRP[name]] then
		return subGRP[PSGRP[name]]
	end
	return old
end
-- The totem aura just reports a removed event in the chat.
-- Maybe we can guess here?
DPSMate.Parser.PLAYER_AURAS_CHANGED = function(unit)
	local aura, debuffDispelType
	for i=1, 4 do
		DPSMate_Tooltip:SetPlayerBuff(GetPlayerBuff(i, "HARMFUL"))
		aura = DPSMate_TooltipTextLeft1:GetText()
		DPSMate_Tooltip:Hide()
		if not aura then break end
		_, _, debuffDispelType = UnitDebuff("player", i);
		if debuffDispelType and DPSMateAbility[aura] then
			DPSMateAbility[aura][2] = debuffDispelType
		end
	end
end


DPSMate.Parser.CHAT_MSG_COMBAT_HOSTILE_DEATH = function(arg1)
	this:CombatHostileDeaths(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_FRIENDLY_DEATH = function(arg1)
	this:CombatFriendlyDeath(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_BREAK_AURA = function(arg1)
	this:SpellBreakAura(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_AURA_GONE_PARTY = function(arg1)
	this:SpellAuraGoneParty(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_AURA_GONE_OTHER = function(arg1)
	this:SpellAuraGoneOther(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_AURA_GONE_SELF = function(arg1)
	this:SpellAuraGoneSelf(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS = function(arg1)
	this:SpellPeriodicFriendlyPlayerBuffs(arg1)
	this:SpellPeriodicFriendlyPlayerBuffsAbsorb(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_PARTY_BUFF = function(arg1)
	this:SpellHostilePlayerBuff(arg1)
	this:SpellHostilePlayerBuffDispels(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS = function(arg1)
	this:SpellPeriodicFriendlyPlayerBuffs(arg1)
	this:SpellPeriodicFriendlyPlayerBuffsAbsorb(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF = function(arg1)
	this:SpellHostilePlayerBuff(arg1)
	this:SpellHostilePlayerBuffDispels(arg1)
	this:HostilePlayerSpellDamageInterrupts(arg1)
	this:SpellPeriodicFriendlyPlayerBuffsAbsorb(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS = function(arg1)
	this:SpellPeriodicFriendlyPlayerBuffs(arg1)
	this:SpellPeriodicFriendlyPlayerBuffsAbsorb(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF = function(arg1)
	this:SpellHostilePlayerBuff(arg1)
	this:SpellHostilePlayerBuffDispels(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS = function(arg1)
	this:SpellPeriodicSelfBuff(arg1)
	this:SpellPeriodicSelfBuffAbsorb(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_SELF_BUFF = function(arg1)
	this:SpellSelfBuff(arg1)
	this:SpellSelfBuffDispels(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE = function(arg1)
	this:SpellPeriodicDamageTaken(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE = function(arg1)
	this:CreatureVsCreatureSpellDamage(arg1)
	this:CreatureVsCreatureSpellDamageAbsorb(arg1)
	this:CreatureVsCreatureSpellDamageInterrupts(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES = function(arg1)
	this:CreatureVsCreatureMisses(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS = function(arg1)
	this:CreatureVsCreatureHits(arg1)
	this:CreatureVsCreatureHitsAbsorb(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE = function(arg1)
	this:CreatureVsCreatureSpellDamage(arg1)
	this:CreatureVsCreatureSpellDamageAbsorb(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE = function(arg1)
	this:SpellPeriodicDamageTaken(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES = function(arg1)
	this:CreatureVsCreatureMisses(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS = function(arg1)
	this:CreatureVsCreatureHits(arg1)
	this:CreatureVsCreatureHitsAbsorb(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE = function(arg1)
	this:PeriodicSelfDamage(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE = function(arg1)
	this:CreatureVsSelfSpellDamage(arg1)
	this:CreatureVsSelfSpellDamageAbsorb(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES = function(arg1)
	this:CreatureVsSelfMisses(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS = function(arg1)
	this:CreatureVsSelfHits(arg1)
	this:CreatureVsSelfHitsAbsorb(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS = function(arg1)
	this:SpellDamageShieldsOnOthers(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF = function(arg1)
	this:SpellDamageShieldsOnSelf(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES = function(arg1)
	this:FriendlyPlayerMisses(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES = function(arg1)
	this:FriendlyPlayerMisses(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS = function(arg1)
	this:FriendlyPlayerHits(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS = function(arg1)
	this:FriendlyPlayerHits(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE = function(arg1)
	this:FriendlyPlayerDamage(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_PARTY_DAMAGE = function(arg1)
	this:FriendlyPlayerDamage(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_PARTY_MISSES = function(arg1)
	this:FriendlyPlayerMisses(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_PARTY_HITS = function(arg1)
	this:FriendlyPlayerHits(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE = function(arg1)
	this:PeriodicDamage(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE = function(arg1)
	this:FriendlyPlayerDamage(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE = function(arg1)
	this:PeriodicDamage(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_SELF_DAMAGE = function(arg1)
	this:SelfSpellDMG(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_SELF_MISSES = function(arg1)
	this:SelfMisses(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_SELF_HITS = function(arg1)
	this:SelfHits(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_PET_HITS = function(arg1)
	this:PetHits(arg1)
end

DPSMate.Parser.CHAT_MSG_COMBAT_PET_MISSES = function(arg1)
	this:PetMisses(arg1)
end

DPSMate.Parser.CHAT_MSG_SPELL_PET_DAMAGE = function(arg1)
	this:PetSpellDamage(arg1)
end

DPSMate.Parser:SetScript("OnEvent", function() if this[event] then this[event](arg1) end end)