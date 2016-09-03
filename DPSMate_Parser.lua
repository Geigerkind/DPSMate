-- Notes
-- "Smbd reflects..." (Thorns etc.)
-- (%s%(%a-%))
-- /script local t = {}; for a,b,c,d in string.gfind("You hit Peter Hallow for 184.", "You (%a%a?)\it (.+) for (%d+)%.%s?(.*)") do t[1]=a;t[2]=b;t[3]=c;t[4]=d end; DPSMate:SendMessage(t[3]); DPSMate:SendMessage(t[4])
-- CHAT_MSG_SPELL_FAILED_LOCALPLAYER -> Examples: You fail to cast Heal: Interrupted. You fail to perform Bear Form: Not enough mana
-- SPELLCAST_INTERRUPTED

-- Global Variables
DPSMate.Parser.procs = {
	-- General
	[DPSMate.BabbleSpell:GetTranslation("Earthstrike")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Juju Flurry")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Holy Strength")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ephemeral Power")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Chromatic Infusion")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Brittle Armor")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Unstable Power")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Zandalarian Hero Medallion")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ascendance")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Essence of Sapphiron")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Hand of Justice")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Sword Specialization")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Bonereaver's Edge")] = true,
	
	--New
	[DPSMate.BabbleSpell:GetTranslation("Felstriker")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Sanctuary")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Fury of Forgewright")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Primal Blessing")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Spinal Reaper")] = true, -- To test
	[DPSMate.BabbleSpell:GetTranslation("Netherwind Focus")] = true, -- To test
	[DPSMate.BabbleSpell:GetTranslation("Parry")] = true, -- To test
	[DPSMate.BabbleSpell:GetTranslation("Untamed Fury")] = true,
	[DPSMate.BabbleSpell:GetTranslation("The Eye of Diminution")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Kiss of the Spider")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Glyph of Deflection")] = true,
	[DPSMate.BabbleSpell:GetTranslation("The Eye of the Dead")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Slayer's Crest")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Badge of the Swarmguard")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Arcane Shroud")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Persistent Shield")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Jom Gabbar")] = true,
	[DPSMate.BabbleSpell:GetTranslation("The Burrower's Shell")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Thrash")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Free Action")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Living Free Action")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Restoration")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Speed")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Invulnerability")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Aura of the Blue Dragon")] = true, -- Mana Darkmoon card
	[DPSMate.BabbleSpell:GetTranslation("Invulnerability")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Battle Squawk")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Devilsaur Fury")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Furious Howl")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Healing Potion")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Major Rejuvenation Potion")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mana Potion")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Restore Mana")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Dreamless Sleep")] = true,
	
	
	-- Rogue
	[DPSMate.BabbleSpell:GetTranslation("Slice and Dice")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blade Flurry")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Sprint")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Adrenaline Rush")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Vanish")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Relentless Strikes Effect")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ruthlessness")] = true, -- To Test!!!!
	[DPSMate.BabbleSpell:GetTranslation("Rogue Armor Energize Effect")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Rogue Armor Energize")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Invigorate")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Head Rush")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Venomous Totem")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Evasion")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Restore Energy")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Remorseless Attacks")] = true,
	
	-- Mage
	[DPSMate.BabbleSpell:GetTranslation("Arcane Power")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Combustion")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mind Quickening")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Enigma Resist Bonus")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Enigma Blizzard Bonus")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Adaptive Warding")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Not There")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Cold Snap")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Presence of Mind")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ice Block")] = true,
	
	-- Priest
	[DPSMate.BabbleSpell:GetTranslation("Power Infusion")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Oracle Healing Bonus")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Epiphany")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Aegis of Preservation")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Inspiration")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blessed Recovery")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Focused Casting")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Spirit Tap")] = true,
	
	-- Druid
	[DPSMate.BabbleSpell:GetTranslation("Symbols of Unending Life Finisher Bonus")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Metamorphosis Rune")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Clearcasting")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Nature's Grace")] = true,
	
	-- Paladin
	[DPSMate.BabbleSpell:GetTranslation("Battlegear of Eternal Justice")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blinding Light")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Divine Favor")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Divine Shield")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Redoubt")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Holy Shield")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Vengeance")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blessing of Freedom")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blessing of Sacrifice")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blessing of Protection")] = true,
	
	-- Shaman
	[DPSMate.BabbleSpell:GetTranslation("Stormcaller's Wrath")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Nature Aligned")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Elemental Mastery")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Windfury Weapon")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Windfury Totem")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Nature's Swiftness")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ancestral Healing")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Reincarnation")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Elemental Mastery")] = true,
	
	-- Warlock
	[DPSMate.BabbleSpell:GetTranslation("Vampirism")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Nightfall")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Soul Link")] = true,
	
	-- Warrior
	[DPSMate.BabbleSpell:GetTranslation("Cheat Death")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Gift of Life")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Bloodrage")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Flurry")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Enrage")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Sweeping Strikes")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Death Wish")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Recklessness")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mighty Rage")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Great Rage")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Rage")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Berserker Rage")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shield Wall")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Retaliation")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Diamond Flask")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shield Block")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Last Stand")] = true,
	
	-- Hunter
	[DPSMate.BabbleSpell:GetTranslation("Arcane Infused")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Quick Shots")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Rapid Fire")] = true,
	
	-- Boss Spells
	[DPSMate.BabbleSpell:GetTranslation("Lucifron's Curse")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Gehennas' Curse")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Panic")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Living Bomb")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Brood Affliction: Bronze")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Bellowing Roar")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Fear")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Entangle")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Digestive Acid")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Locust Swarm")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Web Wrap")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mutating Injection")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Terrifying Roar")] = true,
}

DPSMate.Parser.BuffExceptions = {
	[DPSMate.BabbleSpell:GetTranslation("Fury of Forgewright")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Bloodfang")] = true,
}

DPSMate.Parser.OtherExceptions = {
	[DPSMate.BabbleSpell:GetTranslation("Mighty Rage")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Bloodrage")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Holy Strength")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Dreamless Sleep")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Vampirism")] = true,
}
DPSMate.Parser.DmgProcs = {
	-- General
	[DPSMate.BabbleSpell:GetTranslation("Life Steal")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Thunderfury")] = true,
	-- New
	[DPSMate.BabbleSpell:GetTranslation("Bloodfang")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Fatal Wound")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Decapitate")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Gutgore Ripper")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Firebolt")] = true,
	-- Can't add Hand of Ragnaros
	[DPSMate.BabbleSpell:GetTranslation("Expose Weakness")] = true, -- To Test
	[DPSMate.BabbleSpell:GetTranslation("Silence")] = true, -- To Test
	[DPSMate.BabbleSpell:GetTranslation("Chilled")] = true, -- To Test
	[DPSMate.BabbleSpell:GetTranslation("Glimpse of Madness")] = true, -- To Test
	[DPSMate.BabbleSpell:GetTranslation("Engulfing Shadows")] = true, -- To Test
	[DPSMate.BabbleSpell:GetTranslation("Elemental Vulnerability")] = true, -- To Test
	[DPSMate.BabbleSpell:GetTranslation("Holy Power")] = true, -- To Test
	[DPSMate.BabbleSpell:GetTranslation("Revealed Flaw")] = true, -- To Test
	[DPSMate.BabbleSpell:GetTranslation("Totemic Power")] = true, -- To Test
	[DPSMate.BabbleSpell:GetTranslation("Stygian Grasp")] = true, -- To Test
	[DPSMate.BabbleSpell:GetTranslation("Electric Discharge")] = true, -- To Test
	[DPSMate.BabbleSpell:GetTranslation("Flame Lash")] = true, -- To Test
	[DPSMate.BabbleSpell:GetTranslation("Spell Vulnerability")] = true, -- To Test
	[DPSMate.BabbleSpell:GetTranslation("Lightning Strike")] = true, -- To Test
	-- Deathbringer Skipped
}
DPSMate.Parser.TargetParty = {}
DPSMate.Parser.RCD = {
	[DPSMate.BabbleSpell:GetTranslation("Shield Wall")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Recklessness")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Retaliation")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Last Stand")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Innervate")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Divine Shield")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blessing of Protection")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Gift of Life")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Redemption")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Rebirth")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Resurrection")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Reincarnation")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ancestral Spirit")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Soulstone Resurrection")] = true,
}
DPSMate.Parser.FailDT = {
	-- Molten Core
	[DPSMate.BabbleSpell:GetTranslation("Rain of Fire")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Cone of Fire")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Lava Bomb")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Eruption")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Earthquake")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Hand of Ragnaros")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Wrath of Ragnaros")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Conflagration")] = true,
	
	-- Blackwing Lair
	[DPSMate.BabbleSpell:GetTranslation("War Stomp")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Incinerate")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Corrosive Acid")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Frost Burn")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ignite Flesh")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Time Lapse")] = true,
	
	-- Zul Gurub
	[DPSMate.BabbleSpell:GetTranslation("Whirlwind")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Charge")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Poison Cloud")] = true,
	
	-- AQ 20
	[DPSMate.BabbleSpell:GetTranslation("Arcane Eruption")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Harsh Winds")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Sand Trap")] = true,
	
	-- AQ 40
	[DPSMate.BabbleSpell:GetTranslation("Toxin Cloud")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Arcane Burst")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Eye Beam")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Dark Glare")] = true,
	
	-- Naxx
	[DPSMate.BabbleSpell:GetTranslation("Negative Charge")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Positive Charge")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Void Zone")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Plague Cloud")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blizzard")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Chill")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Frost Breath")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mana Detonation")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shadow Fissure")] = true,
	
}
DPSMate.Parser.FailDB = {
	-- Molten Core
	
	-- Blackwing Lair
	[DPSMate.BabbleSpell:GetTranslation("Suppression Aura")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Bellowing Roar")] = true,
}
DPSMate.Parser.CC = {
	[DPSMate.BabbleSpell:GetTranslation("Sap")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Gouge")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Sleep")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Polymorph")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Greater Polymorph")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Polymorph: Chicken")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Polymorph: Cow")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Polymorph: Pig")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Polymorph: Sheep")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Polymorph: Turtle")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blind")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Freezing Trap Effect")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Intimidating Shout")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Magic Dust")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Scatter Shot")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Wyvern Sting")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Seduction")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Repentance")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shackle Undead")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Reckless Charge")] = true,
}

DPSMate.Parser.Dispels = {
	[DPSMate.BabbleSpell:GetTranslation("Remove Curse")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Cleanse")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Remove Lesser Curse")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Purify")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Dispel Magic")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Abolish Poison")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Abolish Disease")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Devour Magic")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Cure Disease")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Poison Cleansing Totem")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Cure Poison")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Disease Cleansing Totem")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Purge")] = true,
	-- Potion
	[DPSMate.BabbleSpell:GetTranslation("Powerful Anti-Venom")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Restoration")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Purification")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Purification Potion")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Restorative Potion")] = true,
}
DPSMate.Parser.DeCurse = {
	[DPSMate.BabbleSpell:GetTranslation("Remove Curse")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Remove Lesser Curse")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Restoration")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Purification")] = true,
}
DPSMate.Parser.DeMagic = {
	[DPSMate.BabbleSpell:GetTranslation("Dispel Magic")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Devour Magic")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Purge")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Restoration")] = true,
}
DPSMate.Parser.DeDisease = {
	[DPSMate.BabbleSpell:GetTranslation("Purify")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Abolish Disease")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Cure Disease")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Disease Cleansing Totem")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Restoration")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Purification")] = true,
}
DPSMate.Parser.DePoison = {
	[DPSMate.BabbleSpell:GetTranslation("Abolish Poison")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Purify")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Poison Cleansing Totem")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Cure Poison")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Powerful Anti-Venom")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Restoration")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Purification")] = true,
}
DPSMate.Parser.DebuffTypes = {}
DPSMate.Parser.HotDispels = {
	[DPSMate.BabbleSpell:GetTranslation("Abolish Poison")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Abolish Disease")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Restoration")] = true,
}

DPSMate.Parser.Kicks = {
	-- Interrupts
	-- Rogue
	[DPSMate.BabbleSpell:GetTranslation("Kick")] = true,
	-- Warrior
	[DPSMate.BabbleSpell:GetTranslation("Pummel")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shield Bash")] = true,
	
	-- Mage
	[DPSMate.BabbleSpell:GetTranslation("Counterspell")] = true,
	
	-- Shaman
	[DPSMate.BabbleSpell:GetTranslation("Earth Shock")] = true,
	
	-- Priest
	[DPSMate.BabbleSpell:GetTranslation("Silence")] = true,
	
	-- Stuns
	-- Rogue
	[DPSMate.BabbleSpell:GetTranslation("Gouge")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Kidney Shot")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Cheap Shot")] = true,
	
	-- Hunter
	[DPSMate.BabbleSpell:GetTranslation("Scatter Shot")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Improved Concussive Shot")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Wyvern Sting")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Intimidation")] = true,
	
	-- Warrior
	[DPSMate.BabbleSpell:GetTranslation("Charge Stun")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Intercept Stun")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Concussion Blow")] = true,
	
	-- Druid
	[DPSMate.BabbleSpell:GetTranslation("Feral Charge")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Feral Charge Effect")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Bash")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Pounce")] = true,
	
	-- Mage
	[DPSMate.BabbleSpell:GetTranslation("Impact")] = true,
	
	-- Paladin
	[DPSMate.BabbleSpell:GetTranslation("Repentance")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Hammer of Justice")] = true,
	
	-- Warlock
	[DPSMate.BabbleSpell:GetTranslation("Pyroclasm")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Death Coil")] = true,
	
	-- Priest
	[DPSMate.BabbleSpell:GetTranslation("Blackout")] = true,
	
	-- General
	[DPSMate.BabbleSpell:GetTranslation("Tidal Charm")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Reckless Charge")] = true,
}
DPSMate.Parser.player = UnitName("player")
DPSMate.Parser.playerclass = nil

-- Local Variables
local Execute = {}
local _,playerclass = UnitClass("player")
local DB = DPSMate.DB
local _G = getfenv(0)
local string_find = string.find
local UL = UnitLevel

-- Begin Functions

function DPSMate.Parser:OnLoad()
	if (not DPSMateUser[self.player]) then
		DPSMateUser[self.player] = {
			[1] = DPSMate:TableLength(DPSMateUser)+1,
			[2] = strlower(playerclass),
		}
	end
	DPSMateUser[self.player][8] = UL("player")
	-- Prevent this addon from causing issues
	if SW_FixLogStrings then
		DPSMate:SendMessage("Please disable SW_StatsFixLogStrings and SW_Stats. Those addons causes issues.")
	end
	
	-- Prevent error messages of NPCDB
	local oldError = _G.error
	_G.error = function(message, prio)
		if string_find(message, "NPCDB") then
			return
		end
		oldError(message, prio)
	end
	
	-- Changing the GetTranslation function
	local oldGetTranslation = DPSMate.BabbleSpell.GetTranslation
	DPSMate.BabbleSpell.GetTranslation = function(self, msg)
		if msg=="" or msg==" " then
			return msg
		else
			if DPSMate.BabbleSpell:HasTranslation(msg) then
				return oldGetTranslation(self, msg)
			elseif DPSMate.BabbleSpell:HasReverseTranslation(msg) then
				local revTra = DPSMate.BabbleSpell:GetReverseTranslation(msg)
				if DPSMate.BabbleSpell:HasTranslation(revTra) then
					return oldGetTranslation(self, revTra)
				else
					return msg
				end
			else
				return msg
			end
		end
	end
end

function DPSMate.Parser:GetPlayerValues()
	self.player = UnitName("player")
	_,playerclass = UnitClass("player")
	self.playerclass = playerclass
	DPSMatePlayer[1] = self.player
	DPSMatePlayer[2] = playerclass
	local _, fac = UnitFactionGroup("player")
	if fac == "Alliance" then
		DPSMatePlayer[3] = 1
	elseif fac == "Horde" then
		DPSMatePlayer[3] = -1
	end
	DPSMatePlayer[4] = GetRealmName()
	DPSMatePlayer[5] = GetGuildInfo("player")
	DPSMatePlayer[6] = GetLocale()
	self:OnLoad()
end

function DPSMate.Parser:OnEvent(event)
	if Execute[event] then
	--	DPSMate:SendMessage(event..": "..arg1)
		Execute[event](arg1)
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

-- The totem aura just reports a removed event in the chat.
-- Maybe we can guess here?
function DPSMate.Parser:UnitAuraDispels(unit)
	for i=0, 3 do
		DPSMate_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
		DPSMate_Tooltip:ClearLines()
		--DPSMate_Tooltip:SetUnitDebuff(unit, i, "HARMFUL")
		DPSMate_Tooltip:SetPlayerBuff(GetPlayerBuff(i, "HARMFUL"))
		local aura = DPSMate_TooltipTextLeft1:GetText()
		local type = DPSMate_TooltipTextRight1:GetText()
		DPSMate_Tooltip:Hide()
		if not aura then break end
		DB:BuildAbility(aura, type)
		DPSMateAbility[aura][2] = type
	end
end

Execute = {
	["CHAT_MSG_COMBAT_HOSTILE_DEATH"] = function(arg1) DPSMate.Parser:CombatHostileDeaths(arg1) end,
	["CHAT_MSG_COMBAT_FRIENDLY_DEATH"] = function(arg1) DPSMate.Parser:CombatFriendlyDeath(arg1) end,
	["PLAYER_AURAS_CHANGED"] = function(arg1) DPSMate.Parser:UnitAuraDispels(arg1) end, -- !
	["CHAT_MSG_SPELL_BREAK_AURA"] = function(arg1) DPSMate.Parser:SpellBreakAura(arg1) end,
	["CHAT_MSG_SPELL_AURA_GONE_PARTY"] = function(arg1) DPSMate.Parser:SpellAuraGoneParty(arg1) end,
	["CHAT_MSG_SPELL_AURA_GONE_OTHER"] = function(arg1) DPSMate.Parser:SpellAuraGoneOther(arg1) end,
	["CHAT_MSG_SPELL_AURA_GONE_SELF"] = function(arg1) DPSMate.Parser:SpellAuraGoneSelf(arg1) end,
	["CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS"] = function(arg1) DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(arg1);DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffsAbsorb(arg1) end,
	["CHAT_MSG_SPELL_PARTY_BUFF"] = function(arg1) DPSMate.Parser:SpellHostilePlayerBuff(arg1);DPSMate.Parser:SpellHostilePlayerBuffDispels(arg1) end,
	["CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS"] = function(arg1) DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(arg1);DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffsAbsorb(arg1) end,
	["CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF"] = function(arg1) DPSMate.Parser:SpellHostilePlayerBuff(arg1);DPSMate.Parser:SpellHostilePlayerBuffDispels(arg1);DPSMate.Parser:HostilePlayerSpellDamageInterrupts(arg1);DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffsAbsorb(arg1) end,
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