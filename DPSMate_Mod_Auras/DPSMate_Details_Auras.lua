-- Global Variables
DPSMate.Modules.Auras = {}

-- Local variables
local DetailsUser = ""
local g, g2
local curKey = 1
local db, cbt = {}, 0
local Buffpos, Debuffpos = 0, 0
local BuffposComp, DebuffposComp = 0, 0
local t1, t2, t3, t4
local t1TL, t2TL, t3TL, t4TL = 0, 0
local _G = getglobal
local tinsert = table.insert
local strformat = string.format

-- Remember to update the processing list before starting to put on the localization
local Debuffs = {
	[DPSMate.BabbleSpell:GetTranslation("Rend")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Net")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Poison")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blizzard")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Winter's Chill")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Chilled")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Frostbolt")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Frostbite")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Cone of Cold")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Frost Nova")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Dazed")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Volatile Infection")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Disarm")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Psychic Scream")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Corrosive Acid Spit")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Poison Mind")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Knockdown")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Smite")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mind Flay")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Withering Heat")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ancient Dread")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ignite Mana")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ground Stomp")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blast Wave")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Lucifron's Curse")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Hand of Ragnaros")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Demoralizing Shout")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Incite Flames")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Magma Shackles")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Sunder Armor")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Melt Armor")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Rain of Fire")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Serrated Bite")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ancient Hysteria")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shazzrah's Curse")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Fist of Ragnaros")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Magma Spit")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Pyroclast Barrage")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Gehennas' Curse")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Impending Doom")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Conflagration")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Living Bomb")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mangle")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Panic")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Immolate")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Magma Splash")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Weakened Soul")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Elemental Fire")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shadow Word: Pain")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Soul Burn")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Consecration")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Judgement of the Crusader")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Curse of Agony")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Judgement of Wisdom")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Hunter's Mark")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Siphon Life")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Challenging Shout")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Vampiric Embrace")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mocking Blow")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Scorpid Sting")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Deep Wounds")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Drain Life")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Expose Weakness")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Serpent Sting")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Faerie Fire (Feral)")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Rupture")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Rake")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Taunt")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Thunderfury")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Rip")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Corruption")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Moonfire")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Judgement of Light")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shadow Vulnerability")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Forbearance")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Flamestrike")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Intercept Stun")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Volley")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Pyroclasm")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Curse of Recklessness")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Hellfire")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Essence of the Red")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Growing Flames")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Brood Affliction: Blue")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Brood Affliction: Green")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Brood Affliction: Red")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Brood Affliction: Black")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Brood Affliction: Bronze")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Brood Power: Green")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Brood Power: Red")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Brood Power: Blue")] = true,
	[DPSMate.BabbleSpell:GetTranslation("War Stomp")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Thunderclap")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Veil of Shadow")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Flame Buffet")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Flame Shock")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Suppression Aura")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Burning Adrenaline")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Flame Breath")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Bottle of Poison")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shadow of Ebonroc")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Tail Lash")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Dropped Weapon")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Bellowing Roar")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Greater Polymorph")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ignite Flesh")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mortal Strike")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Corrupted Healing")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Inferno Effect")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Time Lapse")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Frost Trap Aura")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Thorium Grenade")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Kreeg's Stout Beatdown")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mark of Detonation")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shadow Command")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Curse of Tongues")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Fear")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Siphon Blessing")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Recently Bandaged")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blind")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Involuntary Transformation")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Polymorph: Pig")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Stunning Blow")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Silence")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Touch of Weakness")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shadow Flame")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Demoralizing Roar")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Pyroblast")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Cauterizing Flames")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Poisonous Blood")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Poison Bolt Volley")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Venom Spit")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Delusions of Jin'do")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Intimidating Roar")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Poison Cloud")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Hex")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Enveloping Webs")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Will of Hakkar")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Polymorph")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Brain Wash")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Whirling Trip")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Gouge")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Threatening Gaze")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Corrupted Blood")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Cause Insanity")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Curse of Weakness")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Death Coil")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Entangling Roots")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Curse of Shadow")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mark of Arlokk")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Corrosive Poison")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Charge")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Scatter Shot")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blood Siphon")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Axe Flurry")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Fixate")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Sonic Burst")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Fall down")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Curse of Blood")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shrink")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Parasitic Serpent")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shield Slam")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Fireball")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Soul Tap")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Pierce Armor")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Holy Fire")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Slowing Poison")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Web Spin")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Infected Bite")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Tranquilizing Poison")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Intoxicating Venom")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Concussion Blow")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Faerie Fire")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Explosive Trap Effect")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mind Control")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ancient Despair")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Detect Magic")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Curse of the Elements")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Sand Trap")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Hive'Zara Catalyst")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Intimidating Shout")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Creeping Plague")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Sundering Cleave")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Poison Bolt")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Curse of Doom")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Consume")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shadowburn")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ignite")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Deadly Poison V")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Dreamless Sleep")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Corrosive Acid")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Chromatic Mutation")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Insect Swarm")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Greater Polymorph")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Brood Power: Bronze")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Sacrifice")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Toxic Volley")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mortal Wound")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Impale")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Noxious Poison")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Unbalancing Strike")] = true,
	[DPSMate.BabbleSpell:GetTranslation("True Fulfillment")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Acid Spit")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Debilitating Charge")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Plague")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Crippling Poison")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Entangle")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mind-numbing Poison")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Toxic Vapors")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Frost Burn")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Wild Magic")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Paralyze")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Hammer of Justice")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Flame Lash")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blinding Light")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Wild Polymorph")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mind Vision")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Berserk")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Summon Infernals")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Spell Vulnerability")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Wyvern Sting")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Hurricane")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ravage")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Greater Dreamless Sleep")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Speed Slash")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Deafening Screech")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mother's Milk")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Acid Splash")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Snap Kick")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Disease Cloud")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blood Craze")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Charge Stun")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Swoop")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Deadly Poison IV")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Unholy Frenzy")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mortal Cleave")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Freezing Trap Effect")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Garrote")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Hamstring")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Cheap Shot")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Kidney Shot")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shield Bash - Silenced")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Improved Concussive Shot")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Sleep")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Consuming Shadows")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Frost Breath")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Spell Blasting")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Tendon Rip")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Soul Siphon")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Evil Twin")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Counterspell - Silenced")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Toxin")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mana Burn")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Dust Cloud")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Digestive Acid")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Sand Blast")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Wing Clip")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Fire Vulnerability")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Fel Energy")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Hemorrhage")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Harvest Soul")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Whirlwind")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Mark of Korth'azz")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shadow Mark")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Chilling Touch")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Stomp")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Flesh Rot")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Infected Wound")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Terrifying Roar")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Slime")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Shockwave")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Itch")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Enveloping Winds")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Test Sunder Armor")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Dismember")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Harsh Winds")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Daze")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Diminish Soul")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Attack Order")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Lightning Cloud")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Devouring Plague")] = true,
}

function DPSMate.Modules.Auras:UpdateDetails(obj, key)
	DPSMate_Details_CompareAuras:Hide()
	
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DetailsUserComp = nil
	DPSMate_Details_Auras_Title:SetText(DPSMate.L["aurasof"]..obj.user)
	t2, t1 = DPSMate.Modules.Auras:SortTable()
	t1TL = DPSMate:TableLength(t1)-6
	t2TL = DPSMate:TableLength(t2)-6
	Buffpos, Debuffpos = 0, 0
	
	if not g then
		g = DPSMate.Options.graph:CreateStackedGraph("AurasStackedGraph",DPSMate_Details_Auras_DiagramLine,"CENTER","CENTER",0,0,660,170)
		g:SetGridColor({0.5,0.5,0.5,0.5})
		g:SetAxisDrawing(true,true)
		g:SetAxisColor({1.0,1.0,1.0,1.0})
		g:SetAutoScale(true)
		g:SetYLabels(true, false)
		g:SetXLabels(true)
		g:Show()
	end
	
	self:CleanTables("")
	self:UpdateBuffs(0, "")
	self:UpdateDebuffs(0, "")
	self:UpdateStackedGraph(g)
	DPSMate_Details_Auras:Show()
	DPSMate_Details_Auras:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.Auras:UpdateCompare(obj, key, comp)
	self:UpdateDetails(obj, key)
	
	DetailsUserComp = comp
	DPSMate_Details_CompareAuras_Title:SetText(DPSMate.L["aurasof"]..comp)
	t4, t3 = DPSMate.Modules.Auras:SortTable(comp)
	t3TL = DPSMate:TableLength(t3)-6
	t4TL = DPSMate:TableLength(t4)-6
	BuffposComp, DebuffposComp = 0, 0
	
	if not g2 then
		g2 = DPSMate.Options.graph:CreateStackedGraph("AurasStackedGraphComp",DPSMate_Details_CompareAuras_DiagramLine,"CENTER","CENTER",0,0,660,170)
		g2:SetGridColor({0.5,0.5,0.5,0.5})
		g2:SetAxisDrawing(true,true)
		g2:SetAxisColor({1.0,1.0,1.0,1.0})
		g2:SetAutoScale(true)
		g2:SetYLabels(true, false)
		g2:SetXLabels(true)
		g2:Show()
	end
	
	self:CleanTables("Compare")
	self:UpdateBuffs(0, "Compare")
	self:UpdateDebuffs(0, "Compare")
	self:UpdateStackedGraph(g2, comp)
	DPSMate_Details_CompareAuras:Show()
end

function DPSMate.Modules.Auras:CreateGraphTable(obj)
	local lines = {}
	for i=1, 6 do
		-- Horizontal
		DPSMate.Options.graph:DrawLine(obj, 5, 223-i*30, 655, 223-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	end
	-- Vertical
	DPSMate.Options.graph:DrawLine(obj, 235, 215, 235, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 300, 215, 300, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
end

function DPSMate.Modules.Auras:UpdateStackedGraph(gg, cname)
	local Data1 = {}
	local maxX, maxY = 0, 0
	local label = {}
	
	for cat, val in db[DPSMateUser[cname or DetailsUser][1]] do -- ability
		local temp = {}
		for ca, va in val[1] do
			tinsert(temp, {va, 1})
		end
		tinsert(Data1, temp)
		tinsert(label, DPSMate:GetAbilityById(cat))
	end
	
	gg:ResetData()
	gg:SetGridSpacing(800/7,10/7)
	
	gg:AddDataSeries(Data1,{1.0,0.0,0.0,0.8}, {}, label)
end

function DPSMate.Modules.Auras:SortTable(cname)
	local t, u = {}, {}
	local a,_,b,c = DPSMate.Modules.AurasUptimers:EvalTable(DPSMateUser[cname or DetailsUser], curKey)
	local p1,p2 = 1, 1
	for cat, val in a do
		local name = DPSMate:GetAbilityById(val)
		local obj = {name, b[cat], c[cat]}
		if Debuffs[name] then
			tinsert(t, p1, obj)
			p1 = p1 + 1
		else
			tinsert(u, p2, obj)
			p2 = p2 + 1
		end
	end	
	return t, u
end

function DPSMate.Modules.Auras:CleanTables(comp)
	for _, val in {"Buffs", "Debuffs"} do
		local path = "DPSMate_Details_"..comp.."Auras_"..val.."_Row"
		for i=1, 6 do
			_G(path..i.."_Icon"):SetTexture()
			_G(path..i.."_Name"):SetText()
			_G(path..i.."_Count"):SetText()
			_G(path..i.."_CBT"):SetText()
			_G(path..i.."_CBTPerc"):SetText()
			_G(path..i.."_StatusBar"):SetValue(0)
		end
	end
end

function DPSMate.Modules.Auras:UpdateBuffs(arg1, comp)
	comp = comp or DPSMate_Details_Auras.LastScroll
	local path = "DPSMate_Details_"..comp.."Auras_Buffs_Row"
	Buffpos=Buffpos-(arg1 or 0)
	local arr = t1
	if comp~="" and comp then
		if Buffpos<0 then Buffpos = 0 end
		if Buffpos>t3TL then Buffpos = t3TL end
		if t3TL<0 then Buffpos = 0 end
		arr = t3
		for i=1, 6 do
			local pos = BuffposComp + i
			if not arr[pos] then break end
			_G(path..i).id = arr[pos][1]
			_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(arr[pos][1]))
			_G(path..i.."_Name"):SetText(arr[pos][1])
			_G(path..i.."_Count"):SetText(arr[pos][3])
			_G(path..i.."_CBT"):SetText(strformat("%.2f", arr[pos][2]*cbt/100).."s")
			_G(path..i.."_CBTPerc"):SetText(strformat("%.2f", arr[pos][2]).."%")
			_G(path..i.."_StatusBar"):SetValue(arr[pos][2])
		end
	else
		if Buffpos<0 then Buffpos = 0 end
		if Buffpos>t1TL then Buffpos = t1TL end
		if t1TL<0 then Buffpos = 0 end
		for i=1, 6 do
			local pos = Buffpos + i
			if not arr[pos] then break end
			_G(path..i).id = arr[pos][1]
			_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(arr[pos][1]))
			_G(path..i.."_Name"):SetText(arr[pos][1])
			_G(path..i.."_Count"):SetText(arr[pos][3])
			_G(path..i.."_CBT"):SetText(strformat("%.2f", arr[pos][2]*cbt/100).."s")
			_G(path..i.."_CBTPerc"):SetText(strformat("%.2f", arr[pos][2]).."%")
			_G(path..i.."_StatusBar"):SetValue(arr[pos][2])
		end
	end
end

function DPSMate.Modules.Auras:UpdateDebuffs(arg1, comp)
	comp = comp or DPSMate_Details_Auras.LastScroll
	local path = "DPSMate_Details_"..comp.."Auras_Debuffs_Row"
	Debuffpos=Debuffpos-(arg1 or 0)
	local arr = t2
	if comp~="" and comp then
		if Debuffpos<0 then Debuffpos = 0 end
		if Debuffpos>t4TL then Debuffpos = t4TL end
		if t4TL<0 then Debuffpos = 0 end
		arr = t4
		for i=1, 6 do
			local pos = DebuffposComp + i
			if not arr[pos] then break end
			_G(path..i).id = arr[pos][1]
			_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(arr[pos][1]))
			_G(path..i.."_Name"):SetText(arr[pos][1])
			_G(path..i.."_Count"):SetText(arr[pos][3])
			_G(path..i.."_CBT"):SetText(strformat("%.2f", arr[pos][2]*cbt/100).."s")
			_G(path..i.."_CBTPerc"):SetText(strformat("%.2f", arr[pos][2]).."%")
			_G(path..i.."_StatusBar"):SetValue(arr[pos][2])
		end
	else
		if Debuffpos<0 then Debuffpos = 0 end
		if Debuffpos>t2TL then Debuffpos = t2TL end
		if t2TL<0 then Debuffpos = 0 end
		for i=1, 6 do
			local pos = Debuffpos + i
			if not arr[pos] then break end
			_G(path..i).id = arr[pos][1]
			_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(arr[pos][1]))
			_G(path..i.."_Name"):SetText(arr[pos][1])
			_G(path..i.."_Count"):SetText(arr[pos][3])
			_G(path..i.."_CBT"):SetText(strformat("%.2f", arr[pos][2]*cbt/100).."s")
			_G(path..i.."_CBTPerc"):SetText(strformat("%.2f", arr[pos][2]).."%")
			_G(path..i.."_StatusBar"):SetValue(arr[pos][2])
		end
	end
end

function DPSMate.Modules.Auras:ShowTooltip(obj)
	local user = DetailsUser
	if obj and string.find(obj:GetName(), "Compare") then
		user = DetailsUserComp
	end
	if obj.id and db[DPSMateUser[user][1]][DPSMateAbility[obj.id][1]] then
		GameTooltip:SetOwner(obj)
		GameTooltip:AddLine(obj.id)
		for cat, val in db[DPSMateUser[user][1]][DPSMateAbility[obj.id][1]][3] do
			GameTooltip:AddDoubleLine(DPSMate:GetUserById(cat),val,1,1,1,1,1,1)
		end
		GameTooltip:Show()
	end
end
