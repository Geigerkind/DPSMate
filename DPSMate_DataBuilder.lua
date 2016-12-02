-- NOtes
-- Dispelling for unknown or if people use macros like castspellbyname support


-- Global Variables
DPSMate.DB.loaded = false
DPSMate.DB.ShieldFlags = {
	[DPSMate.BabbleSpell:GetTranslation("Power Word: Shield")] = 0, -- All
	[DPSMate.BabbleSpell:GetTranslation("Ice Barrier")] = 0, -- All
	[DPSMate.BabbleSpell:GetTranslation("The Burrower's Shell")] = 0, -- All
	[DPSMate.BabbleSpell:GetTranslation("Aura of Protection")] = 0, -- All
	[DPSMate.BabbleSpell:GetTranslation("Damage Absorb")] = 0, -- All
	[DPSMate.BabbleSpell:GetTranslation("Physical Protection")] = 1, -- Meele
	[DPSMate.BabbleSpell:GetTranslation("Harm Prevention Belt")] = 0, -- All
	[DPSMate.BabbleSpell:GetTranslation("Mana Shield")] = 1, -- Meele
	[DPSMate.BabbleSpell:GetTranslation("Frost Protection")] = 2, -- Frost
	[DPSMate.BabbleSpell:GetTranslation("Frost Resistance")] = 2, -- Frost
	[DPSMate.BabbleSpell:GetTranslation("Frost Ward")] = 2, -- Frost
	[DPSMate.BabbleSpell:GetTranslation("Fire Protection")] = 3, -- Fire
	[DPSMate.BabbleSpell:GetTranslation("Fire Ward")] = 3, -- Fire
	[DPSMate.BabbleSpell:GetTranslation("Nature Protection")] = 4, -- Nature
	[DPSMate.BabbleSpell:GetTranslation("Shadow Protection")] = 5, -- Shadow
	[DPSMate.BabbleSpell:GetTranslation("Arcane Protection")] = 6, -- Arcane
	[DPSMate.BabbleSpell:GetTranslation("Holy Protection")] = 7, -- Holy
}
DPSMate.DB.FixedShieldAmounts = {
	[DPSMate.BabbleSpell:GetTranslation("Power Word: Shield")] = 1000, -- All
	[DPSMate.BabbleSpell:GetTranslation("Ice Barrier")] = 818, -- All
	[DPSMate.BabbleSpell:GetTranslation("The Burrower's Shell")] = 900, -- All
	[DPSMate.BabbleSpell:GetTranslation("Aura of Protection")] = 1000, -- All
	[DPSMate.BabbleSpell:GetTranslation("Damage Absorb")] = 550, -- All
	[DPSMate.BabbleSpell:GetTranslation("Physical Protection")] = 500, -- Meele
	[DPSMate.BabbleSpell:GetTranslation("Harm Prevention Belt")] = 500, -- All
	[DPSMate.BabbleSpell:GetTranslation("Mana Shield")] = 570, -- Meele
	[DPSMate.BabbleSpell:GetTranslation("Frost Protection")] = 2500, -- Frost
	[DPSMate.BabbleSpell:GetTranslation("Frost Resistance")] = 600, -- Frost
	[DPSMate.BabbleSpell:GetTranslation("Frost Ward")] = 920, -- Frost
	[DPSMate.BabbleSpell:GetTranslation("Fire Protection")] = 2500, -- Fire
	[DPSMate.BabbleSpell:GetTranslation("Fire Ward")] = 920, -- Fire
	[DPSMate.BabbleSpell:GetTranslation("Nature Protection")] = 2500, -- Nature
	[DPSMate.BabbleSpell:GetTranslation("Shadow Protection")] = 2500, -- Shadow
	[DPSMate.BabbleSpell:GetTranslation("Arcane Protection")] = 2500, -- Arcane
	[DPSMate.BabbleSpell:GetTranslation("Holy Protection")] = 2500, -- Holy
}
local AbilityFlags = {
	["fire"] = 3,
	["holy"] = 7,
	["arcane"] = 6,
	["shadow"] = 5,
	["nature"] = 4,
	["frost"] = 2,
	["physical"] = 1,
	
	["feuer"] = 3,
	["heilig"] = 7,
	["arkan"] = 6,
	["schatten"] = 5,
	["natur"] = 4,
	["frost"] = 2,
	["physisch"] = 1
}
DPSMate.DB.NeedUpdate = false
DPSMate.DB.UserData = {}
DPSMate.DB.MainUpdate = 0
DPSMate.DB.Zones = {
	[DPSMate.L["mc"]] = true,
	[DPSMate.L["bwl"]] = true,
	[DPSMate.L["ony"]] = true,
	[DPSMate.L["zg"]] = true,
	[DPSMate.L["aq401"]] = true,
	[DPSMate.L["aq20"]] = true,
	[DPSMate.L["aq402"]] = true,
	[DPSMate.L["naxx"]] = true,
	[DPSMate.L["azs"]] = true, -- Azuregos
	[DPSMate.L["bl"]] = true, -- Kazzak
	[DPSMate.L["dw"]] = true, -- Emerald dragons, not sure if those zone names are correct.
	[DPSMate.L["hintl"]] = true,
	[DPSMate.L["ash"]] = true,
	[DPSMate.L["fe"]] = true
}
DPSMate.DB.KTMHOOK = {}
DPSMate.DB.NextSwing = {}
DPSMate.DB.NextSwingEDD = {}

-- Local Variables
local CombatState = false
local cheatCombat = 0
local UpdateTime = 0.25
local LastUpdate = 0
local MainLastUpdate = 0
local MainUpdateTime = 1.5
local CombatTime = 0
local CombatBuffer = 1
local InitialLoad, In1 = false, 0
local tinsert = table.insert
local tremove = table.remove
local _G = getglobal
local player = ""
local GT = GetTime
local strfind = string.find
local UL = UnitLevel
local slower = strlower
local windfuryab = {
	[DPSMate.BabbleSpell:GetTranslation("Windfury Weapon")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Windfury Totem")] = true,
}

-- Begin Functions

function DPSMate.DB:OnEvent(event)
	if event == "ADDON_LOADED" and (not self.loaded) then
		if DPSMateSettings == nil then
			DPSMateSettings = {
				windows = {
					[1] = {
						name = "DPSMate",
						options = {
							[1] = {
								damage = true
							},
							[2] = {
								total = true
							}
						},
						CurMode = "damage",
						hidden = false,
						scale = 1,
						barfont = "ARIALN",
						barfontsize = 14,
						barfontflag = "Outline",
						bartexture = "Healbot",
						barspacing = 1,
						barheight = 19,
						classicons = true,
						ranks = true,
						titlebar = true,
						titlebarfont = "FRIZQT",
						titlebarfontflag = "None",
						titlebarfontsize = 12,
						titlebarheight = 18,
						titlebarreport = true,
						titlebarreset = true,
						titlebarsegments = true,
						titlebarconfig = true,
						titlebarsync = true,
						titlebarenable = true,
						titlebarfilter = true,
						titlebartexture = "Healbot",
						titlebarbgcolor = {0.01568627450980392,0,1},
						titlebarfontcolor = {1.0,0.82,0.0},
						barfontcolor = {1.0,1.0,1.0},
						contentbgtexture = "UI-Tooltip-Background",
						contentbgcolor = {0.01568627450980392,0,1},
						bgbarcolor = {1,1,1},
						numberformat = 1,
						opacity = 1,
						bgopacity = 1,
						titlebaropacity = 1,
						filterclasses = {
							warrior = true,
							rogue = true,
							priest = true,
							hunter = true,
							mage = true,
							warlock = true,
							paladin = true,
							shaman = true,
							druid = true,
						},
						filterpeople = "",
						grouponly = false,
						realtime = false,
						cbtdisplay = false,
						barbg = false,
						totopacity = 1.0,
						borderopacity = 1.0,
						contentbordercolor = {0,0,0},
						borderstrata = 1,
						bordertexture = "UI-Tooltip-Border",
					}
				},
				lock = false,
				sync = true,
				enable = true,
				dataresetsworld = 2,
				dataresetsjoinparty = 2,
				dataresetsleaveparty = 2,
				dataresetspartyamount = 2,
				dataresetssync = 3,
				dataresetslogout = 3,
				showminimapbutton = true,
				showtotals = true,
				hidewhensolo = false,
				hideincombat = false,
				hideinpvp = false,
				disablewhilehidden = false,
				datasegments = 8,
				mergepets = true,
				columnsdps = {
					[1] = false,
					[2] = true,
					[3] = true,
					[4] = false
				},
				columnsdmg = {
					[1] = true,
					[2] = false,
					[3] = true,
					[4] = false
				},
				columnsdmgtaken = {
					[1] = true,
					[2] = false,
					[3] = true,
					[4] = false
				},
				columnsdtps = {
					[1] = false,
					[2] = true,
					[3] = true,
					[4] = false
				},
				columnsedd = {
					[1] = true,
					[2] = false,
					[3] = true,
					[4] = false
				},
				columnsedt = {
					[1] = true,
					[2] = false,
					[3] = true,
					[4] = false
				},
				columnshealing = {
					[1] = true,
					[2] = false,
					[3] = true,
					[4] = false
				},
				columnshealingtaken = {
					[1] = true,
					[2] = false,
					[3] = true,
					[4] = false
				},
				columnshps = {
					[1] = false,
					[2] = true,
					[3] = true,
					[4] = false
				},
				columnsohps = {
					[1] = false,
					[2] = true,
					[3] = true,
					[4] = false
				},
				columnsoverhealing = {
					[1] = true,
					[2] = false,
					[3] = true,
					[4] = false
				},
				columnsohealingtaken = {
					[1] = true,
					[2] = false,
					[3] = true,
					[4] = false
				},
				columnsehealing = {
					[1] = true,
					[2] = false,
					[3] = true,
					[4] = false
				},
				columnsehealingtaken = {
					[1] = true,
					[2] = false,
					[3] = true,
					[4] = false
				},
				columnsehps = {
					[1] = false,
					[2] = true,
					[3] = true,
					[4] = false
				},
				columnsabsorbs = {
					[1] = true,
					[2] = true,
					[3] = false,
					[4] = false
				},
				columnsabsorbstaken = {
					[1] = true,
					[2] = true,
					[3] = false,
					[4] = false
				},
				columnshab = {
					[1] = true,
					[2] = false,
					[3] = true,
					[4] = false
				},
				columnsdeaths = {
					[1] = true,
					[2] = true,
				},
				columnsinterrupts = {
					[1] = true,
					[2] = true,
				},
				columnsdispels = {
					[1] = true,
					[2] = true,
				},
				columnsdispelsreceived = {
					[1] = true,
					[2] = true,
				},
				columnsdecurses = {
					[1] = true,
					[2] = true,
				},
				columnsdecursesreceived = {
					[1] = true,
					[2] = true,
				},
				columnsdisease = {
					[1] = true,
					[2] = true,
				},
				columnsdiseasereceived = {
					[1] = true,
					[2] = true,
				},
				columnspoison = {
					[1] = true,
					[2] = true,
				},
				columnspoisonreceived = {
					[1] = true,
					[2] = true,
				},
				columnsmagic = {
					[1] = true,
					[2] = true,
				},
				columnsmagicreceived = {
					[1] = true,
					[2] = true,
				},
				columnsaurasgained = {
					[1] = true,
					[2] = true,
				},
				columnsauraslost = {
					[1] = true,
					[2] = true,
				},
				columnsaurauptime = {
					[1] = true,
					[2] = true,
				},
				columnsprocs = {
					[1] = true,
					[2] = true,
				},
				columnscasts = {
					[1] = true,
					[2] = true,
				},
				columnsthreat = {
					[1] = true,
					[2] = false,
					[3] = true,
					[4] = false
				},
				columnstps = {
					[1] = false,
					[2] = true,
					[3] = true,
					[4] = false
				},
				columnsfails = {
					[1] = true,
					[2] = true,
				},
				columnsccbreaker = {
					[1] = true,
					[2] = true,
				},
				columnsfriendlyfire = {
					[1] = true,
					[2] = false,
					[3] = true,
					[4] = false
				},
				columnsfriendlyfiretaken = {
					[1] = true,
					[2] = false,
					[3] = true,
					[4] = false
				},
				showtooltips = true,
				informativetooltips = true,
				subviewrows = 4,
				tooltipanchor = 5,
				onlybossfights = true,
				hiddenmodes = {},
				broadcasting = false,
				bccd = false,
				bcress = false,
				bckb = false,
				bcfail = false,
				bcrw = false,
				targetscale=0.58,
				hideonlogin = false,
			}
		end
		if DPSMateHistory == nil then 
			DPSMateHistory = {
				names = {},
				DMGDone = {},
				DMGTaken = {},
				EDDone = {},
				EDTaken = {},
				THealing = {},
				EHealing = {},
				OHealing = {},
				EHealingTaken = {},
				THealingTaken = {},
				OHealingTaken = {},
				Absorbs = {},
				Deaths = {},
				Interrupts = {},
				Dispels = {},
				Auras = {},
				Threat = {},
				Fail = {},
				CCBreaker = {}
			}
		end
		if DPSMateUser == nil then DPSMateUser = {} end
		if DPSMateAbility == nil then DPSMateAbility = {} end
		if DPSMateDamageDone == nil then DPSMateDamageDone = {[1]={},[2]={}} end
		if DPSMateDamageTaken == nil then DPSMateDamageTaken = {[1]={},[2]={}} end
		if DPSMateEDD == nil then DPSMateEDD = {[1]={},[2]={}} end
		if DPSMateEDT == nil then DPSMateEDT = {[1]={},[2]={}} end
		if DPSMateTHealing == nil then DPSMateTHealing = {[1]={},[2]={}} end
		if DPSMateEHealing == nil then DPSMateEHealing = {[1]={},[2]={}} end
		if DPSMateOverhealing == nil then DPSMateOverhealing = {[1]={},[2]={}} end
		if DPSMateHealingTaken == nil then DPSMateHealingTaken = {[1]={},[2]={}} end
		if DPSMateEHealingTaken == nil then DPSMateEHealingTaken = {[1]={},[2]={}} end
		if DPSMateOverhealingTaken == nil then DPSMateOverhealingTaken = {[1]={},[2]={}} end
		if DPSMateAbsorbs == nil then DPSMateAbsorbs = {[1]={},[2]={}} end
		if DPSMateDispels == nil then DPSMateDispels = {[1]={},[2]={}} end
		if DPSMateDeaths == nil then DPSMateDeaths = {[1]={},[2]={}} end
		if DPSMateInterrupts == nil then DPSMateInterrupts = {[1]={},[2]={}} end
		if DPSMateAurasGained == nil then DPSMateAurasGained = {[1]={},[2]={}} end
		if DPSMateThreat == nil then DPSMateThreat = {[1]={},[2]={}} end
		if DPSMateFails == nil then DPSMateFails = {[1]={},[2]={}} end
		if DPSMateCCBreaker == nil then DPSMateCCBreaker = {[1]={},[2]={}} end
		-- Legacy Logs support
		if DPSMateAttempts == nil then DPSMateAttempts = {} end
		if DPSMatePlayer == nil then DPSMatePlayer = {} end
		if DPSMateLoot == nil then DPSMateLoot = {} end
		
		DPSMate.Modules.DPS.DB = DPSMateDamageDone
		DPSMate.Modules.Damage.DB = DPSMateDamageDone
		DPSMate.Modules.DamageTaken.DB = DPSMateDamageTaken
		DPSMate.Modules.DTPS.DB = DPSMateDamageTaken
		DPSMate.Modules.EDD.DB = DPSMateEDD
		DPSMate.Modules.EDT.DB = DPSMateEDT
		DPSMate.Modules.FriendlyFire.DB = DPSMateEDT
		DPSMate.Modules.FriendlyFireTaken.DB = DPSMateEDT
		DPSMate.Modules.Healing.DB = DPSMateTHealing
		DPSMate.Modules.HPS.DB = DPSMateTHealing
		DPSMate.Modules.Overhealing.DB = DPSMateOverhealing
		DPSMate.Modules.EffectiveHealing.DB = DPSMateEHealing
		DPSMate.Modules.EffectiveHPS.DB = DPSMateEHealing
		DPSMate.Modules.HealingTaken.DB = DPSMateHealingTaken
		DPSMate.Modules.EffectiveHealingTaken.DB = DPSMateEHealingTaken
		DPSMate.Modules.Absorbs.DB = DPSMateAbsorbs
		DPSMate.Modules.AbsorbsTaken.DB = DPSMateAbsorbs
		DPSMate.Modules.HealingAndAbsorbs.DB = DPSMateAbsorbs
		DPSMate.Modules.Deaths.DB = DPSMateDeaths
		DPSMate.Modules.Dispels.DB = DPSMateDispels
		DPSMate.Modules.DispelsReceived.DB = DPSMateDispels
		DPSMate.Modules.Decurses.DB = DPSMateDispels
		DPSMate.Modules.DecursesReceived.DB = DPSMateDispels
		DPSMate.Modules.CureDisease.DB = DPSMateDispels
		DPSMate.Modules.CureDiseaseReceived.DB = DPSMateDispels
		DPSMate.Modules.CurePoison.DB = DPSMateDispels
		DPSMate.Modules.CurePoisonReceived.DB = DPSMateDispels
		DPSMate.Modules.LiftMagic.DB = DPSMateDispels
		DPSMate.Modules.LiftMagicReceived.DB = DPSMateDispels
		DPSMate.Modules.Interrupts.DB = DPSMateInterrupts
		DPSMate.Modules.AurasGained.DB = DPSMateAurasGained
		DPSMate.Modules.AurasLost.DB = DPSMateAurasGained
		DPSMate.Modules.AurasLost.DB = DPSMateAurasGained
		DPSMate.Modules.AurasUptimers.DB = DPSMateAurasGained
		DPSMate.Modules.Procs.DB = DPSMateAurasGained
		DPSMate.Modules.Casts.DB = DPSMateEDT
		DPSMate.Modules.Threat.DB = DPSMateThreat
		DPSMate.Modules.TPS.DB = DPSMateThreat
		DPSMate.Modules.Fails.DB = DPSMateFails
		DPSMate.Modules.CCBreaker.DB = DPSMateCCBreaker
		DPSMate.Modules.OHPS.DB = DPSMateOverhealing
		DPSMate.Modules.OHealingTaken.DB = DPSMateOverhealingTaken
		DPSMate.Modules.Activity.DB = DPSMateCombatTime
		
		if not DPSMateSettings["columnsprocs"] then
			DPSMateSettings["columnsprocs"] = {
				[1] = true,
				[2] = true,
			}
		end
		if not DPSMateSettings["columnscasts"] then
			DPSMateSettings["columnscasts"] = {
				[1] = true,
				[2] = true,
			}
		end
		if not DPSMateSettings["columnsfails"] then
			DPSMateSettings["columnsfails"] = {
				[1] = true,
				[2] = true,
			}
		end
		if not DPSMateSettings["columnsthreat"] then
			DPSMateSettings["columnsthreat"] = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			}
		end
		if not DPSMateSettings["columnstps"] then
			DPSMateSettings["columnstps"] = {
				[1] = false,
				[2] = true,
				[3] = true,
				[4] = false
			}
		end
		if not DPSMateSettings["columnsohps"] then
			DPSMateSettings["columnsohps"] = {
				[1] = false,
				[2] = true,
				[3] = true,
				[4] = false
			}
		end
		if not DPSMateSettings["columnsohealingtaken"] then
			DPSMateSettings["columnsohealingtaken"] = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			}
		end
		if not DPSMateSettings["columnsccbreaker"] then
			DPSMateSettings["columnsccbreaker"] = {
				[1] = true,
				[2] = true
			}
		end
		if not DPSMateSettings["mergepets"] then
			DPSMateSettings["mergepets"] = true
		end
		if not DPSMateSettings["columnsfriendlyfiretaken"] then 
			DPSMateSettings["columnsfriendlyfiretaken"] = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			}
		end
		if not DPSMateSettings["targetscale"] then
			DPSMateSettings["targetscale"] = 0.58
		end
		
		-- Settings for each window
		for num, val in pairs(DPSMateSettings["windows"]) do
			if not val["contentbordercolor"] then
				DPSMateSettings["windows"][num]["contentbordercolor"] = {0,0,0}
			end
			if not val["borderstrata"] then
				DPSMateSettings["windows"][num]["borderstrata"] = 1
			end
			if not val["bordertexture"] then
				DPSMateSettings["windows"][num]["bordertexture"] = "UI-Tooltip-Border"
			end
			if not val["borderopacity"] then
				DPSMateSettings["windows"][num]["borderopacity"] = 1
			end
		end
		
		if DPSMateCombatTime == nil then
			DPSMateCombatTime = {
				total = 1,
				current = 1,
				segments = {},
				effective = {
					[1] = {},
					[2] = {}
				},
			}
		end
		
		DPSMate:OnLoad()
		DPSMate.Sync:OnLoad()
		DPSMate.Options:InitializeSegments()
		DPSMate.Options:InitializeHideShowWindow()
		
		self:CombatTime()
		
		player = UnitName("player")
		
		-- Fixing an Log Bug
		if not DPSMateUser["LASTRESETDPSMATE"] or DPSMateUser["LASTRESETDPSMATE"][2]<DPSMate.VERSION then
			DPSMateUser = {}
			DPSMateAbility = {}
			DPSMateUser["LASTRESETDPSMATE"] = {
				[1] = 1,
				[2] = DPSMate.VERSION
			}
			DPSMate.Options:PopUpAccept(true, true)
		end
		
		-- Look it up at NEC
		--SetCVar("CombatLogRangeParty", 150);
		--SetCVar("CombatLogRangePartyPet", 150);
		--SetCVar("CombatLogRangeFriendlyPlayers", 150);
		--SetCVar("CombatLogRangeFriendlyPlayersPets", 150);
		--SetCVar("CombatLogRangeHostilePlayers", 150);
		--SetCVar("CombatLogRangeHostilePlayersPets", 150);
		--SetCVar("CombatLogRangeCreature", 150);
		--SetCVar("CombatDeathLogRange", 150);
		
		DPSMate:SendMessage("DPSMate build "..DPSMate.VERSION.." has been loaded!")
		self.loaded = true
		InitialLoad = true
	elseif event == "PLAYER_REGEN_DISABLED" then
		if DPSMateSettings["hideincombat"] then
			for _, val in pairs(DPSMateSettings["windows"]) do
				if not val then break end
				_G("DPSMate_"..val["name"]):Hide()
			end
			if DPSMateSettings["disablewhilehidden"] then
				DPSMate:Disable()
			end
		end
		DPSMate.Options:HideWhenSolo()
		if (not CombatState and cheatCombat+10<GetTime()) then
			DPSMate.Options:NewSegment()
		end
		CombatState, CombatTime = true, 0
	elseif event == "PLAYER_REGEN_ENABLED" then
		if DPSMateSettings["hideincombat"] then
			for _, val in pairs(DPSMateSettings["windows"]) do
				if not val then break end
				if not val["hidden"] then
					_G("DPSMate_"..val["name"]):Show()
				end
			end
			DPSMate:Enable()
		end
		DPSMate.Options:HideWhenSolo()
	elseif event == "PLAYER_AURAS_CHANGED" then
		self:hasVanishedFeignDeath()
	elseif event == "PLAYER_TARGET_CHANGED" then
		self:PlayerTargetChanged()
	elseif event == "PLAYER_PET_CHANGED" then
		DPSMate.DB:OnGroupUpdate()
	end
end

function DPSMate.DB:OnGroupUpdate()
	local type = "raid"
	local num = GetNumRaidMembers()
	DPSMate.Parser.TargetParty = {}
	if num<=0 then
		type = "party"
		num = GetNumPartyMembers()
	end
	for i=1, num do
		local name = UnitName(type..i)
		local pet = UnitName(type.."pet"..i)
		local _,classEng = UnitClass(type..i)
		local fac = UnitFactionGroup(type..i)
		local gname, _, _ = GetGuildInfo(type..i)
		local level = UL(type..i)
		self:BuildUser(name, strlower(classEng or ""))
		self:BuildUser(pet)
		if classEng then
			DPSMateUser[name][2] = strlower(classEng)
		end
		DPSMateUser[name][4] = false
		if pet and pet ~= DPSMate.L["unknown"] then
			DPSMateUser[pet][4] = true
			DPSMateUser[name][5] = pet
			DPSMateUser[pet][6] = DPSMateUser[name][1]
		end
		if fac == DPSMate.L["alliance"] then
			DPSMateUser[name][3] = 1
		elseif fac == DPSMate.L["horde"] then
			DPSMateUser[name][3] = -1
		end
		DPSMate.Parser.TargetParty[name] = type..i
		if (gname and gname ~= "") then
			DPSMateUser[name][7] = gname
		end
		if level and level>0 then
			DPSMateUser[name][8] = level
		end
	end
	local pet = UnitName("pet")
	local name = UnitName("player")
	if pet and pet ~= DPSMate.L["unknown"] then
		self:BuildUser(name, nil)
		self:BuildUser(pet, nil)
		DPSMateUser[pet][4] = true
		DPSMateUser[name][5] = pet
		DPSMateUser[pet][6] = DPSMateUser[name][1]
	end
	DPSMate.Parser.TargetParty[name] = "player"
end

-- Deprecated
function DPSMate.DB:AffectingCombat()
	if UnitAffectingCombat("player") then return true end
	local type = "raid"
	local num = GetNumRaidMembers()
	if num<=0 then
		type = "party"
		num = GetNumPartyMembers()
	end
	for i=1, num do
		if UnitAffectingCombat(type..i) then
			return true
		end
	end
	return false
end

function DPSMate.DB:PlayerTargetChanged()
	if UnitIsPlayer("target") then
		local name = UnitName("target")
		local a, class = UnitClass("target")
		local fac = UnitFactionGroup("target") or ""
		local level = UL("target")
		if DPSMateUser[name] then
			DPSMateUser[name][2] = strlower(class)
		else
			self:BuildUser(name, strlower(class))
		end
		if fac == DPSMate.L["alliance"] then
			DPSMateUser[name][3] = 1
		elseif fac == DPSMate.L["horde"] then
			DPSMateUser[name][3] = -1
		end
		if level and level>0 then
			DPSMateUser[name][8] = level
		end
	end
end

function DPSMate.DB:PlayerInParty()
	if GetNumPartyMembers() > 0 and (not UnitInRaid("player")) then
		return true
	end
	return false
end

function DPSMate.DB:InPartyOrRaid()
	if self:PlayerInParty() or UnitInRaid("player") then
		return true
	end
	return false
end

function DPSMate.DB:GetNumPartyMembers()
	if self:PlayerInParty() then
		return GetNumPartyMembers()
	elseif UnitInRaid("player") then
		return GetNumRaidMembers()
	end
end

-- Performance
function DPSMate.DB:BuildUser(Dname, Dclass)
	if not Dname then return true end
	if (not DPSMateUser[Dname] and Dname) then
		DPSMateUser[Dname] = {
			[1] = DPSMate:TableLength(DPSMateUser)+1,
			[2] = Dclass,
		}
		DPSMate.UserId = nil
	end
	return false
end

-- Performance
function DPSMate.DB:BuildAbility(name, kind, school)
	if not name then return true end
	if not DPSMateAbility[name] then
		DPSMateAbility[name] = {
			[1] = DPSMate:TableLength(DPSMateAbility)+1,
			[2] = kind,
			[3] = school,
		}
		DPSMate.AbilityId = nil
	end
	return false
end

-- KTMHOOK
local specialAbTrans = {
	["heroicstrike"] = DPSMate.BabbleSpell:GetTranslation("Heroic Strike"),
	["maul"] = DPSMate.BabbleSpell:GetTranslation("Maul"),	
	["swipe"] = DPSMate.BabbleSpell:GetTranslation("Swipe"),
	["shieldslam"] = DPSMate.BabbleSpell:GetTranslation("Shield Slam"),
	["revenge"] = DPSMate.BabbleSpell:GetTranslation("Revenge"),
	["shieldbash"] = DPSMate.BabbleSpell:GetTranslation("Shield Bash"),
	["sunder"] = DPSMate.BabbleSpell:GetTranslation("Sunder Armor"),
	["cleave"] = DPSMate.BabbleSpell:GetTranslation("Cleave"),
	--["feint"] = DPSMate.BabbleSpell:GetTranslation("Feint"),
	--["cower"] = DPSMate.BabbleSpell:GetTranslation("Cower"),
	["searingpain"] = DPSMate.BabbleSpell:GetTranslation("Searing Pain"),
	["earthshock"] = DPSMate.BabbleSpell:GetTranslation("Earth Shock"),
	["mindblast"] = DPSMate.BabbleSpell:GetTranslation("Mind Blast"),
	["holyshield"] = DPSMate.BabbleSpell:GetTranslation("Holy Shield"),
	--["distractingshot"] = DPSMate.BabbleSpell:GetTranslation("Distracting Shot"),
	["heroicstrike"] = DPSMate.BabbleSpell:GetTranslation("Heroic Strike"),
	["thunderfury"] = DPSMate.BabbleSpell:GetTranslation("Thunderfury"),
	["graceofearth"] = DPSMate.BabbleSpell:GetTranslation("Grace of Earth"),
	["blackamnesty"] = DPSMate.BabbleSpell:GetTranslation("Black Amnesty"),
	["whitedamage"] = DPSMate.BabbleSpell:GetTranslation("AutoAttack"),
}

if klhtm then
	local oldModSpecialAttack = klhtm.combat.specialattack
	klhtm.combat.specialattack = function(abilityid, target, damage, iscrit, spellschool)
		oldModSpecialAttack(abilityid, target, damage, iscrit, spellschool)
		if specialAbTrans[abilityid] then
			if not DPSMate.DB.KTMHOOK[specialAbTrans[abilityid]] then
				DPSMate.DB.KTMHOOK[specialAbTrans[abilityid]] = {}
			end
			tinsert(DPSMate.DB.KTMHOOK[specialAbTrans[abilityid]], {target, klhtm.combat.event.threat})
			DPSMate.DB:Threat(player, specialAbTrans[abilityid], target, klhtm.combat.event.threat, 1)
		end
	end

	local oldModNormalAttack = klhtm.combat.normalattack
	klhtm.combat.normalattack = function(spellname, spellid, damage, isdot, target, iscrit, spellschool)
		oldModNormalAttack(spellname, spellid, damage, isdot, target, iscrit, spellschool)
		if not DPSMate.DB.KTMHOOK[spellname] then
			DPSMate.DB.KTMHOOK[spellname] = {}
		end
		tinsert(DPSMate.DB.KTMHOOK[spellname], {target, klhtm.combat.event.threat})
		DPSMate.DB:Threat(player, spellname, target, klhtm.combat.event.threat, 1)
	end

	local oldModHeal = klhtm.combat.registerheal
	klhtm.combat.registerheal = function(spellname, spellid, amount, target)
		oldModNormalAttack(spellname, spellid, amount, target)
		if not DPSMate.DB.KTMHOOK[spellname] then
			DPSMate.DB.KTMHOOK[spellname] = {}
		end
		tinsert(DPSMate.DB.KTMHOOK[spellname], {target, klhtm.combat.event.threat})
		DPSMate.DB:Threat(player, spellname, target, klhtm.combat.event.threat, 1)
	end

	local oldModPowerGain = klhtm.combat.powergain
	klhtm.combat.powergain = function(amount, powertype, spellid)
		oldModPowerGain(amount, powertype, spellid)
		if not DPSMate.DB.KTMHOOK[powertype] then
			DPSMate.DB.KTMHOOK[powertype] = {}
		end
		local target = UnitName("target") or player
		tinsert(DPSMate.DB.KTMHOOK[powertype], {target, klhtm.combat.event.threat})
		DPSMate.DB:Threat(player, powertype, target, klhtm.combat.event.threat, 1)
	end
end

function DPSMate.DB:UpdateThreat()
	if self.KTMHOOK ~= {} then
		local str
		for cat, val in self.KTMHOOK do
			local curNpc, curNpcNum = {}, 0
			if str then
				str = str..',["'..cat..'"]={'
			else
				str = '["'..cat..'"]={'
			end
			for ca, va in val do
				if curNpc[va[1]] then
					str = str..','..va[2]
				else
					if curNpcNum==0 then
						str = str..'["'..va[1]..'"]={'..va[2]
					else
						str = str..'},["'..va[1]..'"]={'..va[2]
					end
					curNpc[va[1]] = true
					curNpcNum = curNpcNum + 1
				end
			end
			str = str..'}}'
		end
		if str then
			self.KTMHOOK = {}
			SendAddonMessage("KLHTMHOOK", str, "RAID")
		end
	end
end

function DPSMate.DB:Threat(cause, spellname, target, value, amount)
	if self:BuildUser(target, nil) or self:BuildUser(cause, nil) or self:BuildAbility(spellname, nil) or value==0 or cause=="" or spellname=="" or target=="" then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do
		if not DPSMateThreat[cat][DPSMateUser[cause][1]] then
			DPSMateThreat[cat][DPSMateUser[cause][1]] = {}
		end
		if not DPSMateThreat[cat][DPSMateUser[cause][1]][DPSMateUser[target][1]] then
			DPSMateThreat[cat][DPSMateUser[cause][1]][DPSMateUser[target][1]] = {}
		end
		if not DPSMateThreat[cat][DPSMateUser[cause][1]][DPSMateUser[target][1]][DPSMateAbility[spellname][1]] then
			DPSMateThreat[cat][DPSMateUser[cause][1]][DPSMateUser[target][1]][DPSMateAbility[spellname][1]] = {
				[1] = 0, -- Amount
				[2] = 0, -- Min
				[3] = 0, -- Max
				[4] = 0, -- Hits
				["i"] = {}
			}
		end
		local path = DPSMateThreat[cat][DPSMateUser[cause][1]][DPSMateUser[target][1]][DPSMateAbility[spellname][1]]
		path[1] = path[1] + value
		path[4] = path[4] + amount
		if path[2]==0 or path[2]>value then
			path[2] = value
		end
		if path[3]<value then
			path[3] = value
		end
		if path["i"][DPSMateCombatTime[val]] then
			path["i"][DPSMateCombatTime[val]] = path["i"][DPSMateCombatTime[val]] + value
		else
			path["i"][DPSMateCombatTime[val]] = value
		end
	end
	self.NeedUpdate = true
end

local savedValue = {
	["damage"] = 0,
	["dmgt"] = 0,
	["heal"] = 0,
	["eheal"] = 0
}
function DPSMate.DB:GetAlpha(k)
	if DPSMateSettings["windows"][k]["realtime"] then
		local p = savedValue[DPSMateSettings["windows"][k]["realtime"]] or 0
		savedValue[DPSMateSettings["windows"][k]["realtime"]] = 0
		if p > 50000 then -- That may solve the freeze issue
			p = 50000
		end
		return p
	end
end

function DPSMate.DB:WeightedAverage(a, b, c, d)
	return (a*(c/(c+d))+b*(d/(c+d))) or 0
end

local spellSchoolNames = {
	["fire"] = true,
	["nature"] = true,
	["shadow"] = true,
	["holy"] = true,
	["frost"] = true,
	["arcane"] = true,
	
	["feuer"] = true,
	["natur"] = true,
	["schatten"] = true,
	["arkan"] = true,
	["frost"] = true,
	["heilig"] = true
}
function DPSMate.DB:AddSpellSchool(ab, school)
	school = slower(school)
	local sc
	if spellSchoolNames[school] then
		sc = school
	else
		for c, _ in spellSchoolNames do
			if strfind(school, c) then
				sc = c
				break
			end
		end
	end
	if sc then
		if DPSMateAbility[ab] then
			DPSMateAbility[ab][3] = sc
		else
			self:BuildAbility(ab,nil,sc)
		end
	end
end

-- First crit/hit av value will be half if it is not the first hit actually. Didnt want to add an exception for it though. Maybe later :/
local CastsBuffer = {[1]={[1]={},[2]={}},[2]={[1]={},[2]={}},[3]={[1]={},[2]={}}}
local AAttack = DPSMate.BabbleSpell:GetTranslation("AutoAttack")
local hackOrder, hackOrder2 = {}, {}
function DPSMate.DB:DamageDone(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, Dglance, Dblock)
	if self:BuildUser(Duser, nil) or self:BuildAbility(Dname, nil) then return end -- Attempt to fix this problem?
	
	if (not CombatState and cheatCombat+10<GetTime()) then
		DPSMate.Options:NewSegment()
	end
	CombatState, CombatTime = true, 0
	
	-- Part to take extra swings as abilities into account
	if self.NextSwing[Duser] then
		if Dname == AAttack and self.NextSwing[Duser][1]>0 and ((hackOrder[Duser] and windfuryab[self.NextSwing[Duser][2]]) or not windfuryab[self.NextSwing[Duser][2]]) then
			Dname = self.NextSwing[Duser][2]
			self.NextSwing[Duser][1] = self.NextSwing[Duser][1] - 1
			hackOrder[Duser] = true
		elseif Dname == AAttack and self.NextSwing[Duser][1]>0 and not hackOrder[Duser] and windfuryab[self.NextSwing[Duser][2]] then
			hackOrder[Duser] = true
		else
			hackOrder[Duser] = false
		end
	end
	
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if (not DPSMateDamageDone[cat][DPSMateUser[Duser][1]]) then
			DPSMateDamageDone[cat][DPSMateUser[Duser][1]] = {
				i = 0,
			}
		end
		if not DPSMateDamageDone[cat][DPSMateUser[Duser][1]][DPSMateAbility[Dname][1]] then
			DPSMateDamageDone[cat][DPSMateUser[Duser][1]][DPSMateAbility[Dname][1]] = {
				[1] = 0, -- hit
				[2] = 0, -- hitlow
				[3] = 0, -- hithigh
				[4] = 0, -- hitaverage
				[5] = 0, -- crit
				[6] = 0, -- critlow
				[7] = 0, -- crithigh
				[8] = 0, -- critaverage
				[9] = 0, -- miss
				[10] = 0, -- parry
				[11] = 0, -- dodge
				[12] = 0, -- resist 
				[13] = 0, -- amount
				[14] = 0,
				[15] = 0,
				[16] = 0,
				[17] = 0,
				[18] = 0,
				[19] = 0,
				[20] = 0,
				[21] = 0,
				[22] = 0, -- Casts
				["i"] = {}
			}
		end
		local path = DPSMateDamageDone[cat][DPSMateUser[Duser][1]][DPSMateAbility[Dname][1]]
		-- Casts evaluation
		local time = GT()
		if CastsBuffer[1][cat][Duser] then
			if CastsBuffer[1][cat][Duser][Dname] then
				if time>=(CastsBuffer[1][cat][Duser][Dname]+0.1) then
					CastsBuffer[1][cat][Duser][Dname] = time
					path[22] = path[22] + 1
				end
			else
				CastsBuffer[1][cat][Duser][Dname] = time
				path[22] = path[22] + 1
			end
		else
			CastsBuffer[1][cat][Duser] = {}
			CastsBuffer[1][cat][Duser][Dname] = time
			path[22] = path[22] + 1
		end
		path[1] = path[1] + Dhit
		path[5] = path[5] + Dcrit
		path[9] = path[9] + Dmiss
		path[10] = path[10] + Dparry
		path[11] = path[11] + Ddodge
		path[12] = path[12] + Dresist
		path[13] = path[13] + Damount
		path[14] = path[14] + Dglance
		path[18] = path[18] + Dblock
		if Dhit == 1 then
			if (Damount < path[2] or path[2] == 0) then path[2] = Damount end
			if Damount > path[3] then path[3] = Damount end
			path[4] = self:WeightedAverage(path[4], Damount, path[1]-Dhit, Dhit)
		elseif Dcrit == 1 then
			if (Damount < path[6] or path[6] == 0) then path[6] = Damount end
			if Damount > path[7] then path[7] = Damount end
			path[8] = self:WeightedAverage(path[8], Damount, path[5]-Dcrit, Dcrit)
		elseif Dglance == 1 then
			if (Damount < path[15] or path[15] == 0) then path[15] = Damount end
			if Damount > path[16] then path[16] = Damount end
			path[17] = self:WeightedAverage(path[17], Damount, path[14]-Dglance, Dglance)
		elseif Dblock == 1 then
			if (Damount < path[19] or path[19] == 0) then path[19] = Damount end
			if Damount > path[20] then path[20] = Damount end
			path[21] = self:WeightedAverage(path[21], Damount, path[18]-Dblock, Dblock)
		end
		DPSMateDamageDone[cat][DPSMateUser[Duser][1]]["i"] = DPSMateDamageDone[cat][DPSMateUser[Duser][1]]["i"] + Damount
		if Damount > 0 then 
			local time = floor(DPSMateCombatTime[val])
			if path["i"][time] then
				path["i"][time] = path["i"][time] + Damount
			else
				path["i"][time] = Damount
			end
		end
	end
	savedValue["damage"] = savedValue["damage"] + Damount
	self.NeedUpdate = true
end

-- Fall damage
function DPSMate.DB:DamageTaken(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, cause, Dcrush, Dblock)
	if self:BuildUser(Duser, nil) or self:BuildUser(cause, nil) or self:BuildAbility(Dname, nil) then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not DPSMateDamageTaken[cat][DPSMateUser[Duser][1]] then
			DPSMateDamageTaken[cat][DPSMateUser[Duser][1]] = {
				i = 0,
			}
		end
		if not DPSMateDamageTaken[cat][DPSMateUser[Duser][1]][DPSMateUser[cause][1]] then
			DPSMateDamageTaken[cat][DPSMateUser[Duser][1]][DPSMateUser[cause][1]] = {}
		end
		if not DPSMateDamageTaken[cat][DPSMateUser[Duser][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]] then
			DPSMateDamageTaken[cat][DPSMateUser[Duser][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]] = {
				[1] = 0, -- hit
				[2] = 0, -- hitlow
				[3] = 0, -- hithigh
				[4] = 0, -- hitaverage
				[5] = 0, -- crit
				[6] = 0, -- critlow
				[7] = 0, -- crithigh
				[8] = 0, -- critaverage
				[9] = 0, -- miss
				[10] = 0, -- parry
				[11] = 0, -- dodge
				[12] = 0, -- resist
				[13] = 0, -- amount
				[14] = 0, -- average
				[15] = 0,
				[16] = 0,
				[17] = 0,
				[18] = 0,
				[19] = 0,
				[20] = 0,
				[21] = 0,
				[22] = 0,
				[23] = 0,
				["i"] = {}
			}
		end
		local path = DPSMateDamageTaken[cat][DPSMateUser[Duser][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]]
		-- Casts evaluation
		local time = GT()
		if CastsBuffer[2][cat][Duser] then
			if CastsBuffer[2][cat][Duser][Dname] then
				if time>=(CastsBuffer[2][cat][Duser][Dname]+0.1) then
					CastsBuffer[2][cat][Duser][Dname] = time
					path[19] = path[19] + 1
				end
			else
				CastsBuffer[2][cat][Duser][Dname] = time
				path[19] = path[19] + 1
			end
		else
			CastsBuffer[2][cat][Duser] = {}
			CastsBuffer[2][cat][Duser][Dname] = time
			path[19] = path[19] + 1
		end
		path[1] = path[1] + Dhit
		path[5] = path[5] + Dcrit
		path[9] = path[9] + Dmiss
		path[15] = path[15] + Dcrush
		path[20] = path[20] + Dblock
		path[10] = path[10] + Dparry
		path[11] = path[11] + Ddodge
		path[12] = path[12] + Dresist
		path[13] = path[13] + Damount
		if Dhit == 1 then
			if (Damount < path[2] or path[2] == 0) then path[2] = Damount end
			if Damount > path[3] then path[3] = Damount end
			path[4] = self:WeightedAverage(path[4], Damount, path[1]-Dhit, Dhit)
		elseif Dcrit == 1 then
			if (Damount < path[6] or path[6] == 0) then path[6] = Damount end
			if Damount > path[7] then path[7] = Damount end
			path[8] = self:WeightedAverage(path[8], Damount, path[5]-Dcrit, Dcrit)
		elseif Dcrush == 1 then
			if (Damount < path[16] or path[16] == 0) then path[16] = Damount end
			if Damount > path[17] then path[17] = Damount end
			path[18] = self:WeightedAverage(path[18], Damount, path[15]-Dcrush, Dcrush)
		elseif Dblock == 1 then
			if (Damount < path[21] or path[21] == 0) then path[21] = Damount end
			if Damount > path[22] then path[22] = Damount end
			path[23] = self:WeightedAverage(path[23], Damount, path[20]-Dblock, Dblock)
		end
		DPSMateDamageTaken[cat][DPSMateUser[Duser][1]]["i"] = DPSMateDamageTaken[cat][DPSMateUser[Duser][1]]["i"] + Damount
		if Damount > 0 then 
			path[14] = (path[14] + Damount)/2
			local time = floor(DPSMateCombatTime[val])
			if path["i"][time] then
				path["i"][time] = path["i"][time] + Damount
			else
				path["i"][time] = Damount
			end
		end
	end
	savedValue["dmgt"] = savedValue["dmgt"] + Damount
	self.NeedUpdate = true
end

local ActiveMob = {}
function DPSMate.DB:EnemyDamage(mode, arr, Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, cause, Dblock, Dcrush)
	if self:BuildUser(Duser, nil) or self:BuildUser(cause, nil) or self:BuildAbility(Dname, nil) then return end
	ActiveMob[cause] = true
	
	if mode then
		-- Part to take extra swings as abilities into account
		if self.NextSwingEDD[Duser] then
			if Dname == AAttack and self.NextSwingEDD[Duser][1]>0 and ((hackOrder2[Duser] and windfuryab[self.NextSwingEDD[Duser][2]]) or not windfuryab[self.NextSwingEDD[Duser][2]]) then
				Dname = self.NextSwingEDD[Duser][2]
				self.NextSwingEDD[Duser][1] = self.NextSwingEDD[Duser][1] - 1
			elseif Dname == AAttack and self.NextSwingEDD[Duser][1]>0 and not hackOrder2[Duser] and windfuryab[self.NextSwingEDD[Duser][2]] then
				hackOrder2[Duser] = true
			else
				hackOrder2[Duser] = false
			end
		end
	end
	
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not arr[cat][DPSMateUser[cause][1]] then
			arr[cat][DPSMateUser[cause][1]] = {}
		end
		if not arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser][1]] then
			arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser][1]] = {
				i = 0,
			}
		end
		if not arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser][1]][DPSMateAbility[Dname][1]] then
			arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser][1]][DPSMateAbility[Dname][1]] = {
				[1] = 0, -- hit
				[2] = 0, -- hitlow
				[3] = 0, -- hithigh
				[4] = 0, -- hitaverage
				[5] = 0, -- crit
				[6] = 0, -- critlow
				[7] = 0, -- crithigh
				[8] = 0, -- critaverage
				[9] = 0, -- miss
				[10] = 0, -- parry
				[11] = 0, -- dodge
				[12] = 0, -- resist
				[13] = 0, -- amount
				[14] = 0,
				[15] = 0,
				[16] = 0,
				[17] = 0,
				[18] = 0,
				[19] = 0,
				[20] = 0,
				[21] = 0,
				[22] = 0,
				["i"] = {}
			}
		end
		local path = arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser][1]][DPSMateAbility[Dname][1]]
		-- Casts evaluation
		local time = GT()
		if CastsBuffer[3][cat][Duser] then
			if CastsBuffer[3][cat][Duser][Dname] then
				if time>=(CastsBuffer[3][cat][Duser][Dname]+0.1) then
					CastsBuffer[3][cat][Duser][Dname] = time
					path[22] = path[22] + 1
				end
			else
				CastsBuffer[3][cat][Duser][Dname] = time
				path[22] = path[22] + 1
			end
		else
			CastsBuffer[3][cat][Duser] = {}
			CastsBuffer[3][cat][Duser][Dname] = time
			path[22] = path[22] + 1
		end
		path[1] = path[1] + Dhit
		path[5] = path[5] + Dcrit
		path[9] = path[9] + Dmiss
		path[10] = path[10] + Dparry
		path[11] = path[11] + Ddodge
		path[12] = path[12] + Dresist
		path[13] = path[13] + Damount
		path[14] = path[14] + Dblock
		path[18] = path[18] + Dcrush
		if Dhit == 1 then
			if (Damount < path[2] or path[2] == 0) then path[2] = Damount end
			if Damount > path[3] then path[3] = Damount end
			path[4] = self:WeightedAverage(path[4], Damount, path[1]-Dhit, Dhit)
		elseif Dcrit == 1 then
			if (Damount < path[6] or path[6] == 0) then path[6] = Damount end
			if Damount > path[7] then path[7] = Damount end
			path[8] = self:WeightedAverage(path[8], Damount, path[5]-Dcrit, Dcrit)
		elseif Dblock == 1 then
			if (Damount < path[15] or path[15] == 0) then path[15] = Damount end
			if Damount > path[16] then path[16] = Damount end
			path[17] = self:WeightedAverage(path[17], Damount, path[14]-Dblock, Dblock)
		elseif Dcrush == 1 then
			if (Damount < path[19] or path[19] == 0) then path[19] = Damount end
			if Damount > path[20] then path[20] = Damount end
			path[21] = self:WeightedAverage(path[21], Damount, path[18]-Dcrush, Dcrush)
		end
		arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser][1]]["i"] = arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser][1]]["i"] + Damount
		if Damount > 0 then
			local time = floor(DPSMateCombatTime[val])
			if path["i"][time] then
				path["i"][time] = path["i"][time] + Damount
			else
				path["i"][time] = Damount
			end
		end
	end
	if Damount>0 then self:CheckActiveCC(Duser, cause) end
	self.NeedUpdate = true
end

function DPSMate.DB:Healing(mode, arr, Duser, Dname, Dhit, Dcrit, Damount)
	if self:BuildUser(Duser, nil) or self:BuildAbility(Dname, nil) then return end
	if not CombatState then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not arr[cat][DPSMateUser[Duser][1]] then
			arr[cat][DPSMateUser[Duser][1]] = {
				i = 0,
			}
		end
		if not arr[cat][DPSMateUser[Duser][1]][DPSMateAbility[Dname][1]] then
			arr[cat][DPSMateUser[Duser][1]][DPSMateAbility[Dname][1]] = {
				[1] = 0, -- Healing done
				[2] = 0, -- Hit
				[3] = 0, -- Crit
				[4] = 0, -- hitav
				[5] = 0, -- critav
				[6] = 0, -- hitMin
				[7] = 0, -- hitMax
				[8] = 0, -- critMin
				[9] = 0, -- critMax
				["i"] = {}
			}
		end
		local path = arr[cat][DPSMateUser[Duser][1]][DPSMateAbility[Dname][1]]
		path[1] = path[1]+Damount
		path[2] = path[2]+Dhit
		path[3] = path[3]+Dcrit
		if Dhit==1 then
			path[4] = self:WeightedAverage(path[4], Damount, path[2]-Dhit, Dhit)
		end
		if Dcrit==1 then
			path[5] = self:WeightedAverage(path[5], Damount, path[3]-Dcrit, Dcrit)
		end
		arr[cat][DPSMateUser[Duser][1]]["i"] = arr[cat][DPSMateUser[Duser][1]]["i"]+Damount
		if Dhit==1 then 
			if Damount<path[6] or path[6]==0 then
				path[6] = Damount; 
			end
			if Damount>path[7] or path[7]==0 then
				path[7] = Damount 
			end
		end
		if Dcrit==1 then 
			if Damount<path[8] or path[8]==0 then
				path[8] = Damount; 
			end
			if Damount>path[9] or path[9]==0 then
				path[9] = Damount 
			end
		end
		if Damount > 0 then 
			local time = floor(DPSMateCombatTime[val])
			if path["i"][time] then
				path["i"][time] = path["i"][time] + Damount
			else
				path["i"][time] = Damount
			end
		end
	end
	if mode == 0 then
		savedValue["eheal"] = savedValue["eheal"] + Damount
	elseif mode == 1 then
		savedValue["heal"] = savedValue["heal"] + Damount
	end
	self.NeedUpdate = true
end

function DPSMate.DB:HealingTaken(arr, Duser, Dname, Dhit, Dcrit, Damount, target)
	if self:BuildUser(Duser, nil) or self:BuildUser(target, nil) or self:BuildAbility(Dname, nil) then return end
	if not CombatState then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not arr[cat][DPSMateUser[Duser][1]] then
			arr[cat][DPSMateUser[Duser][1]] = {
				i = 0,
			}
		end
		if not arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]] then
			arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]] = {}
		end
		if not arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]] then
			arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]] = {
				[1] = 0, -- Healing done
				[2] = 0, -- Hit
				[3] = 0, -- Crit
				[4] = 0, -- hitav
				[5] = 0, -- critav
				[6] = 0, -- hitMin
				[7] = 0, -- hitMax
				[8] = 0, -- critMin
				[9] = 0, -- critMax
				["i"] = {}
			}
		end
		local path = arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]]
		path[1] = path[1]+Damount
		path[2] = path[2]+Dhit
		path[3] = path[3]+Dcrit
		if Dhit==1 then
			path[4] = self:WeightedAverage(path[4], Damount, path[2]-Dhit, Dhit)
			if Damount<path[6] or path[6]==0 then
				path[6] = Damount; 
			end
			if Damount>path[7] or path[7]==0 then
				path[7] = Damount 
			end
		end
		if Dcrit==1 then
			path[5] = self:WeightedAverage(path[5], Damount, path[3]-Dcrit, Dcrit)
			if Damount<path[8] or path[8]==0 then
				path[8] = Damount; 
			end
			if Damount>path[9] or path[9]==0 then
				path[9] = Damount 
			end
		end
		arr[cat][DPSMateUser[Duser][1]]["i"] = arr[cat][DPSMateUser[Duser][1]]["i"]+Damount
		if Damount > 0 then 
			local time = floor(DPSMateCombatTime[val])
			if path["i"][time] then
				path["i"][time] = path["i"][time] + Damount
			else
				path["i"][time] = Damount
			end
		end
	end
	self.NeedUpdate = true
end

-- Fire etc. Prot Potion
-- Mage: Ice Barrier, Manashield, Fire Protection, Frost Protection
-- Warlock: Shadow Protection
-- Priest: Power Word: Shield
-- Always the first shield that is applied is absorbing the damage. Depending the school it iterates through the shields.
-- Example: Manashield is applied first then Frost Protection Potion.
-- Weasel casts Frostbolt. -> Game: Can Manashield absorb Frost damage? No -> Game: Can Frost Protection Potion Absorb Frost damage? Yes -> OK go for it!
-- Example two: Frost Protection Potion and Power Word Shield
-- Weasel casts Frostbolt. -> Game: Can FPP absorb the FD? Yes -> Go for it. (The Power Word Shield is ignored until FPP fades)
-- What if a shield is refreshed
local Await = {}
local realAbility = {
	[DPSMate.BabbleSpell:GetTranslation("Greater Fire Protection Potion")] = DPSMate.BabbleSpell:GetTranslation("Fire Protection"),
	[DPSMate.BabbleSpell:GetTranslation("Greater Frost Protection Potion")] = DPSMate.BabbleSpell:GetTranslation("Frost Protection"),
	[DPSMate.BabbleSpell:GetTranslation("Greater Nature Protection Potion")] = DPSMate.BabbleSpell:GetTranslation("Nature Protection"),
	[DPSMate.BabbleSpell:GetTranslation("Greater Holy Protection Potion")] = DPSMate.BabbleSpell:GetTranslation("Holy Protection"),
	[DPSMate.BabbleSpell:GetTranslation("Greater Shadow Protection Potion")] = DPSMate.BabbleSpell:GetTranslation("Shadow Protection"),
	[DPSMate.BabbleSpell:GetTranslation("Greater Arcane Protection Potion")] = DPSMate.BabbleSpell:GetTranslation("Arcane Protection"),
}
function DPSMate.DB:AwaitingAbsorbConfirmation(owner, ability, abilityTarget, time)
	tinsert(Await, {owner, realAbility[ability] or ability, abilityTarget, time})
	--DPSMate:SendMessage(time)
	--DPSMate:SendMessage("Awaiting confirmation!")
end

function DPSMate.DB:ClearAwaitAbsorb()
	for cat, val in pairs(Await) do
		if (GetTime()-val[4])>=10 then
			tremove(Await, cat)
			break
		end
	end
end

-- Gotta improve the function to prevent an overflow.
function DPSMate.DB:ConfirmAbsorbApplication(ability, abilityTarget, time)
	--DPSMate:SendMessage(time)
	for cat, val in pairs(Await) do
		--DPSMate:SendMessage(ability.."=="..val[2].."////"..val[4].."<="..time.."/////"..val[3].."=="..abilityTarget)
		if val[4]<=time and val[2]==ability then
			if val[3]==abilityTarget then
				self:RegisterAbsorb(val[1], ability, abilityTarget)
				--DPSMate:SendMessage("Aborb registered!")
				tremove(Await, cat)
				return
			end
		end
	end
	self:RegisterAbsorb(DPSMate.L["unknown"], ability, abilityTarget)
--	DPSMate:SendMessage("Aborb registered! (Unknown) /"..ability.."/"..abilityTarget)
end

function DPSMate.DB:RegisterAbsorb(owner, ability, abilityTarget)
	if self:BuildUser(owner, nil) or self:BuildUser(abilityTarget, nil) or self:BuildAbility(ability, nil) then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]] then
			DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]] = {}
		end
		if not DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][DPSMateUser[owner][1]] then
			DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][DPSMateUser[owner][1]] = {
				i = {},
			}
		end
		if not DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][DPSMateUser[owner][1]][DPSMateAbility[ability][1]] then
			DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][DPSMateUser[owner][1]][DPSMateAbility[ability][1]] = {}
		end
		tinsert(DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][DPSMateUser[owner][1]][DPSMateAbility[ability][1]], {
			i = {
				[1] = 0,
				[2] = 0,
				[3] = 0,
				[4] = 0,
			},
		})
	end
	self.NeedUpdate = true
end

local broken = {}
function DPSMate.DB:SetUnregisterVariables(broAbsorb, ab, c)
	if broAbsorb then
		self:BuildAbility(ab, nil)
		self:BuildUser(c, nil)
		broken[1] = 1
		broken[2] = broAbsorb
		broken[3] = DPSMateAbility[ab][1]
		broken[4] = DPSMateUser[c][1]
		--DPSMate:SendMessage("Unregister Variables set")
	end
end

function DPSMate.DB:UnregisterAbsorb(ability, abilityTarget)
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		local AbsorbingAbility = self:GetActiveAbsorbAbilityByPlayer(ability, abilityTarget, cat)
		if AbsorbingAbility[1] then
			local path = DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]][AbsorbingAbility[2]][AbsorbingAbility[3]]["i"]
			if path[1] == 0 then
				path[1] = broken[1]
				path[2] = broken[2]
				path[3] = broken[3]
				path[4] = broken[4]
				if (broken[2] or 0)>0 then tinsert(DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]]["i"], {DPSMateCombatTime[val], broken[4], broken[3], broken[2], AbsorbingAbility[2]}) end
			end
		end
	end
	broken = {2,0,0,0}
	--DPSMate:SendMessage("Absorb unregistered!")
	self.NeedUpdate = true
end

function DPSMate.DB:GetActiveAbsorbAbilityByPlayer(ability, abilityTarget, cate)
	if self:BuildAbility(ability, nil) or self:BuildUser(abilityTarget, nil) then return end
	local ActiveShield = {}
	if DPSMateAbsorbs[cate][DPSMateUser[abilityTarget][1]] then
		for cat, val in pairs(DPSMateAbsorbs[cate][DPSMateUser[abilityTarget][1]]) do
			for ca, va in pairs(val) do
				if ca~="i" then
					for c, v in pairs(va) do
						for ce, ve in pairs(v) do
							if ve[1]==0 and ca==DPSMateAbility[ability][1] then
								ActiveShield = {cat, ca, c}
								break
							end
						end
					end
				end
			end
		end
	end
	return ActiveShield
end

function DPSMate.DB:GetAbsorbingShield(ability, abilityTarget, cate)
	-- Checking for active Shields
	local AbsorbingAbility = {}	
	local activeShields = {}
	if DPSMateAbsorbs[cate][DPSMateUser[abilityTarget][1]] then
		for cat, val in pairs(DPSMateAbsorbs[cate][DPSMateUser[abilityTarget][1]]) do
			for ca, va in pairs(val) do
				if ca~="i" then
					for c, v in pairs(va) do
						for ce, ve in pairs(v) do
							if ve[1]==0 then
								activeShields[cat] = {ca,c}
								break
							end
						end
					end
				end
			end
		end

		-- Checking for "All-Absorbing"-Shields
		-- Checking for Shields that just absorb the ability's school
		local AAS, ASS = {}, {}
		for cat, val in pairs(activeShields) do
			--DPSMate:SendMessage("Test 2 / "..DPSMate:GetAbilityById(val[1]).."//"..AbilityFlags[DPSMateAbility[ability][2]].."//"..DPSMateAbility[ability][2].."//"..self.ShieldFlags[DPSMate:GetAbilityById(val[1])].."//"..ability)
			if self.ShieldFlags[DPSMate:GetAbilityById(val[1])]==0 then
				AAS[cat] = {val[1],val[2]}
				--DPSMate:SendMessage("Fired! 3")
			elseif self.ShieldFlags[DPSMate:GetAbilityById(val[1])]==AbilityFlags[DPSMateAbility[ability][3]] then
				ASS[cat] = {val[1],val[2]}
				--DPSMate:SendMessage("Fired! 2")
			elseif not DPSMateAbility[ability][3] or not AbilityFlags[DPSMateAbility[ability][3]] then
				ASS[cat] = {val[1],val[2]}
				--DPSMate:SendMessage("Fired!")
			end
		end
		
		-- Checking buffs for order
		if AAS~={} or ASS~={} then
			local unit = DPSMate.Parser:GetUnitByName(abilityTarget)
			if unit then
				for i=1, 32 do
					DPSMate_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
					DPSMate_Tooltip:ClearLines()
					DPSMate_Tooltip:SetUnitBuff(unit, i, "HELPFUL")
					local buff = DPSMate_TooltipTextLeft1:GetText()
					DPSMate_Tooltip:Hide()
					if (not buff) then break end
					self:BuildAbility(buff, nil)
					buff = DPSMateAbility[buff][1]
					for cat, val in pairs(AAS) do
						if val[1]==buff then
							AbsorbingAbility = {cat, {val[1],val[2]}}
							break
						end
					end
					for cat, val in pairs(ASS) do
						if val[1]==buff then
							AbsorbingAbility = {cat, {val[1],val[2]}}
							break
						end
					end
				end
			else
				if AAS then
					for cat, val in pairs(AAS) do
						return {cat, {val[1],val[2]}}
					end
				else
					for cat, val in pairs(ASS) do
						return {cat, {val[1],val[2]}}
					end
				end
			end
		end
	end
	return AbsorbingAbility
end

function DPSMate.DB:Absorb(ability, abilityTarget, incTarget)
	if self:BuildUser(incTarget, nil) or self:BuildUser(abilityTarget, nil) or self:BuildAbility(ability, nil) then return end
	--DPSMate:SendMessage("Absorb: "..ability.."/"..abilityTarget.."/"..incTarget)
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		local AbsorbingAbility = self:GetAbsorbingShield(ability, abilityTarget, cat)
		--DPSMate:SendMessage(AbsorbingAbility)
		if AbsorbingAbility[1] then
		--	DPSMate:SendMessage("Test 1")
			if not DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]][AbsorbingAbility[2][1]][AbsorbingAbility[2][2]][DPSMateUser[incTarget][1]] then
				DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]][AbsorbingAbility[2][1]][AbsorbingAbility[2][2]][DPSMateUser[incTarget][1]] = {}
			end
			local path = DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]][AbsorbingAbility[2][1]][AbsorbingAbility[2][2]][DPSMateUser[incTarget][1]]
			if path[DPSMateAbility[ability][1]] then
				path[DPSMateAbility[ability][1]] = path[DPSMateAbility[ability][1]] + 1
			else
				path[DPSMateAbility[ability][1]] = 1
			end
			tinsert(DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]]["i"], {DPSMateCombatTime[val], DPSMateUser[incTarget][1], DPSMateAbility[ability][1], 0, AbsorbingAbility[2][1]})
		end
	end
end

local AwaitDispel = {}
local NextTotemDispel = false
local TotemDispelTimer = 0
function DPSMate.DB:AwaitDispel(ability, target, cause, time)
	if not AwaitDispel[target] then AwaitDispel[target] = {} end
	tinsert(AwaitDispel[target], {cause, ability, time})
	--DPSMate:SendMessage("Awaiting Dispel! - "..cause.." - "..target.." - "..ability.." - "..time)
	self:EvaluateDispel()
end

-- /script DPSMate.Parser.DebuffTypes["Frostbolt"] = "Magic"
-- /script DPSMate.DB:AwaitDispel("Cleanse", "Shino", "Shino", 1)
-- /script DPSMate.DB:ConfirmDispel("Frostbolt", "Shino", 1.2)

local AwaitHotDispel = {}
local Restor = DPSMate.BabbleSpell:GetTranslation("Restoration")
local RPotion = DPSMate.BabbleSpell:GetTranslation("Restorative Potion")
local PFication = DPSMate.BabbleSpell:GetTranslation("Purification")
local PPotion = DPSMate.BabbleSpell:GetTranslation("Purification Potion")
function DPSMate.DB:AwaitHotDispel(ability, target, cause, time)
	if ability == RPotion then
		ability = Restor
		target = cause
	end
	if ability == PPotion then
		ability = PFication
		target = cause
	end
	tinsert(AwaitHotDispel, {cause, target, ability, time})
	--DPSMate:SendMessage("Awaiting Dispel! - "..cause.." - "..target.." - "..ability.." - "..time)
end

local ActiveHotDispel = {}
local lastDispel = nil;
function DPSMate.DB:RemoveActiveHotDispel(target, ability)
	if ActiveHotDispel[target] then
		for ca, va in ActiveHotDispel[target] do -- Overwriting old active hot dispel
			if va[2]==ability then
				tremove(ActiveHotDispel[target], ca)
				self:RemoveActiveHotDispel(target, ability)
				break
			end
		end
	end
end

function DPSMate.DB:RegisterHotDispel(target, ability)
	for cat, val in AwaitHotDispel do
		if val[2]==target and val[3]==ability then
			if not ActiveHotDispel[val[2]] then ActiveHotDispel[val[2]] = {} end
			lastDispel = target;
			self:RemoveActiveHotDispel(val[2], val[3]) -- Overwrite active dispels
			tinsert(ActiveHotDispel[val[2]], {val[1], val[3]})
			self:EvaluateDispel()
			break
		end
 	end
end

function DPSMate.DB:ClearAwaitHotDispel()
	for cat, val in AwaitHotDispel do
		if (GetTime()-val[4])>=10 then
			tremove(AwaitHotDispel, cat)
		end
	end
end

local ConfirmedDispel = {}
function DPSMate.DB:ConfirmRealDispel(ability, target, time)
	if not ConfirmedDispel[target] then ConfirmedDispel[target] = {} end
	tinsert(ConfirmedDispel[target], {ability, time})
	lastDispel = target;
	self:EvaluateDispel()
	NextTotemDispel = true
end

function DPSMate.DB:ApplyRemainingDispels()
	local num = 0
	for cat, val in ConfirmedDispel do
		for ca, va in val do
			num = num + 1
			if (GetTime()-va[2])>10 then
				local type = "party"
				local num = GetNumPartyMembers()
				if num <= 0 then
					type="raid"
					num=GetNumRaidMembers()
				end
				if type=="party" then
					for i=1, num do
						if UnitClass(type..i)==DPSMate.L["shaman"] then
							self:Dispels(UnitName(type..i), DPSMate.L["poisoncleansingtotem"], cat, va[1])
							tremove(ConfirmedDispel[cat], ca)
							return
						end
					end
				else
					local subGRP = {}
					local PSGRP = nil
					for i=1, num do
						local a,b,c = GetRaidRosterInfo(i)
						if UnitClass(type..i)==DPSMate.L["shaman"] then
							subGRP[c] = UnitName(type..i)
						end
						if UnitName(type..i)==cat then
							PSGRP = c
						end
						if PSGRP and subGRP[PSGRP] then
							self:Dispels(subGRP[PSGRP], DPSMate.L["poisoncleansingtotem"], cat, va[1])
							tremove(ConfirmedDispel[cat], ca)
							return
						end
					end
				end
			end
		end
	end
	if num == 0 then
		NextTotemDispel = false
	end
end

-- Deprecated time component
function DPSMate.DB:EvaluateDispel()
	for cat, val in ActiveHotDispel do
		for ca, va in val do
			if ConfirmedDispel[cat] then
				if va[2]~=Restor or (va[2]==Restor and va[1]==cat) then
					local check = nil
					for q, t in ConfirmedDispel[cat] do
						if DPSMate.Parser.HotDispels[va[2]] then
							if not check then
								check = t[1]
								tremove(ConfirmedDispel[cat], q)
							end
						end
					end
					if check then
						self:Dispels(va[1], va[2], cat, check)
						lastDispel = nil;
						return
					end
				end
			end
		end
	end
	for cat, val in AwaitDispel do
		for ca, va in val do
			if (GetTime()-(va[3] or 0))<=10 then
				if ConfirmedDispel[cat] then
					if va[2]~=Restor then
						if ConfirmedDispel[cat][1] then
							self:Dispels(va[1], va[2], cat, ConfirmedDispel[cat][1][1])
							tremove(ConfirmedDispel[cat], 1)
							self:EvaluateDispel()
							--tremove(AwaitDispel[cat], ca)
							--lastDispel = nil;
							return
						end
					end
				end
				--DPSMate:SendMessage("Test 1")
				if cat == DPSMate.L["unknown"] and lastDispel then
					--DPSMate:SendMessage("Test 2")
					if ConfirmedDispel[lastDispel] then
						if ConfirmedDispel[lastDispel][1] then
							self:Dispels(va[1], va[2], lastDispel, ConfirmedDispel[lastDispel][1][1])
							tremove(ConfirmedDispel[lastDispel], 1)
							self:EvaluateDispel()
							--tremove(AwaitDispel[cat], ca)
							--lastDispel = nil;
							return
						end
					end
				end
			end
		end
	end
end

function DPSMate.DB:UnregisterHotDispel(target, ability)
	if not ActiveHotDispel[target] then return end
	for cat, val in pairs(ActiveHotDispel[target]) do
		if val[2]==ability then
			tremove(ActiveHotDispel[target], cat)
			--DPSMate:SendMessage("Unregistered!")
			break
		end
	end
end

function DPSMate.DB:Dispels(cause, Dname, target, ability)
	if self:BuildUser(cause, nil) or self:BuildUser(target, nil) or self:BuildAbility(Dname, nil) or self:BuildAbility(ability, nil) then return end
	--DPSMate:SendMessage("Cause: "..cause.." Dname: "..Dname.." Target: "..target.." Ability: "..ability)
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not DPSMateDispels[cat][DPSMateUser[cause][1]] then
			DPSMateDispels[cat][DPSMateUser[cause][1]] = {
				i = {
					[1] = 0,
					[2] = {}
				},
			}
		end
		if not DPSMateDispels[cat][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]] then
			DPSMateDispels[cat][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]] = {}
		end
		if not DPSMateDispels[cat][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]] then 
			DPSMateDispels[cat][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]] = {}
		end
		if not DPSMateDispels[cat][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][DPSMateAbility[ability][1]] then
			DPSMateDispels[cat][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][DPSMateAbility[ability][1]] = 0
		end
		DPSMateDispels[cat][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][DPSMateAbility[ability][1]] = DPSMateDispels[cat][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][DPSMateAbility[ability][1]]+1
		DPSMateDispels[cat][DPSMateUser[cause][1]]["i"][1] = DPSMateDispels[cat][DPSMateUser[cause][1]]["i"][1]+1
		tinsert(DPSMateDispels[cat][DPSMateUser[cause][1]]["i"][2], {DPSMateCombatTime[val], DPSMateAbility[ability][1], DPSMateUser[target][1], GameTime_GetTime()})
	end
	self.NeedUpdate = true
end

function DPSMate.DB:UnregisterDeath(target)
	if self:BuildUser(target, nil) then return end
	if strfind(target, "%s") then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if DPSMateDeaths[cat][DPSMateUser[target][1]] then
			DPSMateDeaths[cat][DPSMateUser[target][1]][1]["i"][1]=1
			DPSMateDeaths[cat][DPSMateUser[target][1]][1]["i"][2]=GameTime_GetTime()
			if cat==1 and DPSMate.Parser.TargetParty[target] then 
				local p = DPSMateDeaths[cat][DPSMateUser[target][1]][1][1]
				DPSMate:Broadcast(4, target, DPSMate:GetUserById(p[1]), DPSMate:GetAbilityById(p[2]), p[3]) 
			end
		end
	end
end

function DPSMate.DB:DeathHistory(target, cause, ability, amount, hit, crit, type, crush)
	if self:BuildUser(target, nil) or self:BuildUser(cause, nil) or self:BuildAbility(ability, nil) then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not DPSMateDeaths[cat][DPSMateUser[target][1]] then
			DPSMateDeaths[cat][DPSMateUser[target][1]] = {}
		end
		if not DPSMateDeaths[cat][DPSMateUser[target][1]][1] then
			DPSMateDeaths[cat][DPSMateUser[target][1]][1] = {
				i = {
					[1] = 0,
					[2] = "",
				},
			}
		end
		if DPSMateDeaths[cat][DPSMateUser[target][1]][1]["i"][1]==1 then
			tinsert(DPSMateDeaths[cat][DPSMateUser[target][1]], 1, {i = {0,""}})
		end
		local hitCritCrush = 0
		if crit==1 then hitCritCrush = 1 elseif crush==1 then hitCritCrush = 2 end
		tinsert(DPSMateDeaths[cat][DPSMateUser[target][1]][1], 1, {
			[1] = DPSMateUser[cause][1],
			[2] = DPSMateAbility[ability][1],
			[3] = amount,
			[4] = hitCritCrush,
			[5] = type,
			[6] = DPSMateCombatTime[val],
			[7] = GameTime_GetTime(),
		})
		if DPSMateDeaths[cat][DPSMateUser[target][1]][1][21] then
			tremove(DPSMateDeaths[cat][DPSMateUser[target][1]][1], 21)
		end
	end
end

local AwaitKick = {}
local AfflictedStun = {}
function DPSMate.DB:AwaitAfflicted(cause, ability, target, time)
	for cat, val in AfflictedStun do
		if val[1]==cause and ((val[4]+0.5)<=time or (val[4]-0.5)>=time) then
			--DPSMate:SendMessage("That happened!")
			return
		end
	end
	--DPSMate:SendMessage("Await Afflicted Stun: "..ability)
	--DPSMate:SendMessage(cause..","..ability..","..target..","..time)
	tinsert(AfflictedStun, {cause,ability,target,time})
end

function DPSMate.DB:ConfirmAfflicted(target, ability, time)
	--DPSMate:SendMessage("Try to confirm: "..ability)
	for cat, val in AfflictedStun do	
		--DPSMate:SendMessage(val[2].."=="..(ability or "").." and "..val[3].."=="..(target or "").." AND "..val[4].."<="..(time or ""))
		if val[2]==ability and val[3]==target and val[4]<=time then
			if DPSMate.Parser.Kicks[ability] then self:AssignPotentialKick(val[1], val[2], val[3], time) end
			self:EnemyDamage(true, DPSMateEDT, val[1], ability, 1, 0, 0,0,0, 0,0, target, 0, 0)
			tremove(AfflictedStun, cat)
			return 
		end
	end
end

function DPSMate.DB:RegisterPotentialKick(cause, ability, time)
	tinsert(AwaitKick, {cause, ability, time})
	--DPSMate:SendMessage("Potential kick registered!")
end

function DPSMate.DB:UnregisterPotentialKick(cause, ability, time)
	for cat, val in AwaitKick do
		if val[1]==cause and val[2]==ability and val[3]<=time then
			tremove(AwaitKick, cat)
			--DPSMate:SendMessage("Potential Kick has been unregistered! "..ability)
			break
		end
	end
end

function DPSMate.DB:AssignPotentialKick(cause, ability, target, time)
	for cat, val in AwaitKick do
		if val[3]<=time then
			if not val[4] and val[1]==target then
				val[4] = {cause, ability}
			--	DPSMate:SendMessage("Kick assigned! "..ability)
			end
		end
	end
end

function DPSMate.DB:UpdateKicks()
	for cat, val in AwaitKick do
		if (GetTime()-val[3])>=2.5 then
			if val[4] then
				self:Kick(val[4][1], val[1], val[4][2], val[2])
			end
			tremove(AwaitKick, cat)
		end
	end
end

function DPSMate.DB:Kick(cause, target, causeAbility, targetAbility)
	if self:BuildUser(target, nil) or self:BuildUser(cause, nil) or self:BuildAbility(causeAbility, nil) or self:BuildAbility(targetAbility, nil) then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not DPSMateInterrupts[cat][DPSMateUser[cause][1]] then
			DPSMateInterrupts[cat][DPSMateUser[cause][1]] = {
				i = {
					[1] = 0,
					[2] = {}
				},
			}
		end
		if not DPSMateInterrupts[cat][DPSMateUser[cause][1]][DPSMateAbility[causeAbility][1]] then
			DPSMateInterrupts[cat][DPSMateUser[cause][1]][DPSMateAbility[causeAbility][1]] = {}
		end
		if not DPSMateInterrupts[cat][DPSMateUser[cause][1]][DPSMateAbility[causeAbility][1]][DPSMateUser[target][1]] then
			DPSMateInterrupts[cat][DPSMateUser[cause][1]][DPSMateAbility[causeAbility][1]][DPSMateUser[target][1]] = {}
		end
		if not DPSMateInterrupts[cat][DPSMateUser[cause][1]][DPSMateAbility[causeAbility][1]][DPSMateUser[target][1]][DPSMateAbility[targetAbility][1]] then
			DPSMateInterrupts[cat][DPSMateUser[cause][1]][DPSMateAbility[causeAbility][1]][DPSMateUser[target][1]][DPSMateAbility[targetAbility][1]] = 0
		end
		DPSMateInterrupts[cat][DPSMateUser[cause][1]]["i"][1] = DPSMateInterrupts[cat][DPSMateUser[cause][1]]["i"][1] + 1
		tinsert(DPSMateInterrupts[cat][DPSMateUser[cause][1]]["i"][2], {DPSMateCombatTime[val], GameTime_GetTime(), DPSMateAbility[targetAbility][1], DPSMateUser[target][1]})
		DPSMateInterrupts[cat][DPSMateUser[cause][1]][DPSMateAbility[causeAbility][1]][DPSMateUser[target][1]][DPSMateAbility[targetAbility][1]]=DPSMateInterrupts[cat][DPSMateUser[cause][1]][DPSMateAbility[causeAbility][1]][DPSMateUser[target][1]][DPSMateAbility[targetAbility][1]]+1
	end
end

local AwaitBuff = {}
function DPSMate.DB:AwaitingBuff(cause, ability, target, time)
	tinsert(AwaitBuff, {cause, ability, target, time})
	--DPSMate:SendMessage("Awaiting buff!"..ability)
end

-- deprecated function cause of gettime??
function DPSMate.DB:ClearAwaitBuffs()
	for cat, val in AwaitBuff do
		if (GetTime()-(val[4] or 0))>=5 then
			tremove(AwaitBuff, cat)
		end
	end
end

-- deprecated function cause of gettime??
function DPSMate.DB:ConfirmBuff(target, ability, time)
	for cat, val in AwaitBuff do
		if val[4]<=(time or 0) then
			if val[2]==ability and val[3]==target then
				self:BuildBuffs(val[1], target, ability, false)
				--DPSMate:SendMessage("Fired 2: "..time)
				--DPSMate:SendMessage("Confirmed Buff!")
				return
			end
		end
	end
	--DPSMate:SendMessage("Fired 1: "..time)
	self:BuildBuffs("Unknown", target, ability, false)
end

-- Sometimes the fade event is not fired.
-- What if the fade event is fired after a gain event for some reason

function DPSMate.DB:BuildBuffs(cause, target, ability, bool)
	if self:BuildUser(target, nil) or self:BuildUser(cause, nil) or self:BuildAbility(ability, nil) then return end
	--if windfuryab[ability] then
	--	self.NextSwing[target] = {
	--		[1] = 1,
	--		[2] = ability
	--	}
	--	self.NextSwingEDD[target] = {
	--		[1] = 1,
	--		[2] = ability
	--	}
	--end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not DPSMateAurasGained[cat][DPSMateUser[target][1]] then
			DPSMateAurasGained[cat][DPSMateUser[target][1]] = {}
		end
		if not DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]] then
			DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]] = {
				[1] = {},
				[2] = {},
				[3] = {},
				[4] = bool,
				[5] = 0,
				[6] = 0,
			}
		end
		local path = DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]]
		if not path[3][DPSMateUser[cause][1]] then
			path[3][DPSMateUser[cause][1]] = 0
		end
		for i=1, (path[5]-path[6]) do
			tinsert(path[2], path[1][path[6]+1])
			path[6] = path[6] + 1
		end
		tinsert(path[1], DPSMateCombatTime[val])
		path[5] = path[5] + 1
		path[3][DPSMateUser[cause][1]] = path[3][DPSMateUser[cause][1]] + 1
	end
	self.NeedUpdate = true
end

-- Lag machine!
function DPSMate.DB:DestroyBuffs(target, ability)
	if self:BuildUser(target, nil) or self:BuildAbility(ability, nil) then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not DPSMateAurasGained[cat][DPSMateUser[target][1]] then
			DPSMateAurasGained[cat][DPSMateUser[target][1]] = {}
		end
		if not DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]] then
			DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]] = {
				[1] = {},
				[2] = {},
				[3] = {},
				[4] = bool,
				[5] = 0,
				[6] = 0,
			}
		end
		local path = DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]]
		local TL = path[6]+1
		if not path[1][TL] then
			path[1][TL] = DPSMateCombatTime[val]
			path[5] = path[5] + 1
		end
		tinsert(path[2], DPSMateCombatTime[val])
		path[6] = path[6] + 1
	end
	self.NeedUpdate = true
end

function DPSMate.DB:GetOptionsTrue(i,k)
	for cat,val in pairs(DPSMateSettings["windows"][k]["options"][i]) do
		if val == true then
			return cat
		end
	end
end

function DPSMate.DB:UnitIsSaved(unit)
	for i=1, 32 do
		DPSMate_Tooltip:ClearLines()
		DPSMate_Tooltip:SetUnitBuff(unit, i)
		local buff = DPSMate_TooltipTextLeft1:GetText()
		if (not buff) then break end
		if (strfind(buff, DPSMate.L["vanish"]) or strfind(buff, DPSMate.L["feigndeath"])) or strfind(buff, DPSMate.L["divineintervention"]) or strfind(buff, DPSMate.L["stealth"]) then
			return true
		end
	end
	return false
end

function DPSMate.DB:IsWipe()
	local am = 0
	for i=1, GetNumRaidMembers() do
		if not UnitIsDead("raid"..i) then
			-- People who are saved with pala bubble or feight death or vanish
			if not DPSMate.DB:UnitIsSaved("raid"..i) then
				am = am + 1
			end
		end
	end
	if am > 3 then
		return false
	else
		return true
	end
end
local UAC = UnitAffectingCombat
local UN = UnitName
function DPSMate.DB:UpdatePlayerCBT(cbt)
	local notInCombat = true
	local type = "raid"
	local num = GetNumRaidMembers()
	if num<=0 then
		type = "party"
		num = GetNumPartyMembers()
		if UAC("player") then
			DPSMateCombatTime["effective"][1][player] = (DPSMateCombatTime["effective"][1][player] or 0) + cbt
			DPSMateCombatTime["effective"][2][player] = (DPSMateCombatTime["effective"][2][player] or 0) + cbt
			notInCombat = false
		end
	end
	for i=1, num do
		if UAC(type..i) then
			local name = UN(type..i)
			DPSMateCombatTime["effective"][1][name] = (DPSMateCombatTime["effective"][1][name] or 0) + cbt
			DPSMateCombatTime["effective"][2][name] = (DPSMateCombatTime["effective"][2][name] or 0) + cbt
			notInCombat = false
		end
	end
	return notInCombat
end

function DPSMate.DB:CombatTime()
	if not CombatFrame then
		local f = CreateFrame("Frame", "CombatFrame", UIParent)
		f:SetScript("OnUpdate", function(self, elapsed)
			if (CombatState) then
				local notInCombat = false
				LastUpdate = LastUpdate + arg1
				CombatTime = CombatTime + arg1
				if LastUpdate>=UpdateTime then
					DPSMateCombatTime["total"] = DPSMateCombatTime["total"] + LastUpdate
					DPSMateCombatTime["current"] = DPSMateCombatTime["current"] + LastUpdate
					notInCombat = DPSMate.DB:UpdatePlayerCBT(LastUpdate)
					
					-- Check NPC E CBT Time (May be inaccurate) -> Can be used as active time later
					for cat, _ in ActiveMob do
						DPSMateCombatTime["effective"][1][cat] = (DPSMateCombatTime["effective"][1][cat] or 0) + LastUpdate
						DPSMateCombatTime["effective"][2][cat] = (DPSMateCombatTime["effective"][2][cat] or 0) + LastUpdate
					end
					ActiveMob = {}
					
					DPSMate.Parser.SendSpell = {}
					CastsBuffer = {[1]={[1]={},[2]={}},[2]={[1]={},[2]={}},[3]={[1]={},[2]={}}}
					LastUpdate = 0
				end
				
				if CombatTime>=CombatBuffer then
					if notInCombat then 
						CombatState = false
						CombatTime = 0
						DPSMate.DB:Attempt(true, DPSMate.DB:IsWipe(), nil)
					end
				end
				
				if NextTotemDispel then
					TotemDispelTimer = TotemDispelTimer + arg1
					if TotemDispelTimer>2 then
						DPSMate.DB:ApplyRemainingDispels()
						TotemDispelTimer = 0
					end
				end
			else
				DPSMate.DB.MainUpdate = DPSMate.DB.MainUpdate + arg1
				DPSMate.Sync:SendAddonMessages(arg1)
			end
			if DPSMate.DB.NeedUpdate then
				MainLastUpdate = MainLastUpdate + arg1
				if MainLastUpdate>=MainUpdateTime then
					DPSMate.DB:UpdateKicks()
					DPSMate.DB:UpdateThreat()
					DPSMate:SetStatusBarValue()
					DPSMate.DB.NeedUpdate = false
					MainLastUpdate = 0
				end
			end
			if DPSMate.DB.MainUpdate>=150 then
				DPSMate.DB:ClearAwaitBuffs()
				DPSMate.DB:ClearAwaitAbsorb()
				DPSMate.DB:ClearAwaitHotDispel()
				DPSMate.DB.MainUpdate = 0
				--DPSMate:SendMessage("150 !!")
				DPSMate.Sync.Async = true
			end
			if DPSMate.Sync.Async then
				DPSMate.Sync:OnUpdate(arg1)
			end
			if InitialLoad then
				In1 = In1 + arg1
				if In1>=1 then
					DPSMate:SetStatusBarValue()
					DPSMate.Parser:GetPlayerValues()
					DPSMate.DB:OnGroupUpdate()
					InitialLoad = false
				end
			end
			DPSMate.Sync:DismissVote(arg1)
		end)
	end
end

function DPSMate.DB:hasVanishedFeignDeath()
	for i=0, 31 do
		DPSMate_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
		DPSMate_Tooltip:ClearLines()
		DPSMate_Tooltip:SetPlayerBuff(GetPlayerBuff(i, "HELPFUL"))
		local buff = DPSMate_TooltipTextLeft1:GetText()
		if (not buff) then break end
		if (strfind(buff, DPSMate.L["vanish"]) or strfind(buff, DPSMate.L["feigndeath"])) then
			cheatCombat = GetTime()
			return true
		end
		DPSMate_Tooltip:Hide()
	end
end

local oldRepopMe = RepopMe
function NewRepopMe()
	if CombatState then
		DPSMate.DB:Attempt(true, true, nil)
	else
		DPSMate.DB:Attempt(true, DPSMate.DB:IsWipe(), nil)
	end
	oldRepopMe()
end
RepopMe = NewRepopMe


-- No idea how this error occours.
function DPSMate.DB:Attempt(mode, check, tar)
	local zone = GetRealZoneText()
	if self.Zones[zone] then -- Need to find a solution for world bosses.
		if not DPSMateAttempts[zone] then DPSMateAttempts[zone] = {} end
		if mode then
			if DPSMateAttempts[zone][1] and not DPSMateAttempts[zone][1][4] then
				local _,_,a = DPSMate.Modules.EDT:GetSortedTable(DPSMateEDT[2])
				local name = DPSMate:GetUserById(a[1])
				if DPSMateAttempts[zone][1][1]=="" or DPSMateAttempts[zone][1][1]==DPSMate.L["unknown"] then
					if name == "" then
						DPSMateAttempts[zone][1][1] = DPSMate.L["unknown"]
					else
						DPSMateAttempts[zone][1][1] = name or DPSMate.L["unknown"]
					end
				end
				DPSMateAttempts[zone][1][4] = DPSMateCombatTime["total"]
				DPSMateAttempts[zone][1][5] = check
			end
		else
			if check then
				if DPSMateAttempts[zone] and DPSMateAttempts[zone][1] then
					tinsert(DPSMateAttempts[zone][1][6], {DPSMateCombatTime["total"], tar or DPSMate.L["unknown"]})
				end
			else
				tinsert(DPSMateAttempts[zone], 1, {
					[1] = DPSMate.L["unknown"],
					[2] = DPSMateCombatTime["total"],
					[3] = GameTime_GetTime(),
					[6] = {}
				})
			end
		end
	end
end

local banedItems = {
	[20725] = true,
	[18562] = true
}
function DPSMate.DB:Loot(user, quality, itemid)
	if quality>3 and not banedItems[itemid] then
		local zone = GetRealZoneText()
		if not DPSMateLoot[zone] then DPSMateLoot[zone] = {} end
		if self.Zones[zone] then -- Need to find a solution for world bosses.
			tinsert(DPSMateLoot[zone], {
				[1] = DPSMateCombatTime["total"],
				[2] = itemid,
				[3] = quality,
				[4] = user
			})
		end
	end
end

-- Type: 1 => FriendlyFire, 2 => Damage taken, 3 => Debuff taken
function DPSMate.DB:BuildFail(type, user, cause, ability, amount)
	self:BuildUser(user)
	self:BuildUser(cause)
	self:BuildAbility(ability)
	for cat, val in {[1] = "total", [2] = "current"} do
		if not DPSMateFails[cat][DPSMateUser[cause][1]] then
			DPSMateFails[cat][DPSMateUser[cause][1]] = {}
		end
		tinsert(DPSMateFails[cat][DPSMateUser[cause][1]], 1, {
			[1] = type,
			[2] = DPSMateUser[user][1],
			[3] = DPSMateAbility[ability][1],
			[4] = amount,
			[5] = DPSMateCombatTime[val],
			[6] = GameTime_GetTime(),
		})
	end
	DPSMate:Broadcast(3, user, cause, ability, amount, type)
	self.NeedUpdate = true
end

local ActiveCC = {}
function DPSMate.DB:BuildActiveCC(target, ability)
	if not ActiveCC[target] then
		ActiveCC[target] = {}
	end
	ActiveCC[target][ability] = true
end

function DPSMate.DB:RemoveActiveCC(target, ability)
	if not ActiveCC[target] then
		ActiveCC[target] = {}
	end
	if ActiveCC[target][ability] then
		ActiveCC[target][ability] = false;
	end
end

function DPSMate.DB:CheckActiveCC(cause, target)
	if ActiveCC[target] then
		for cat, val in ActiveCC[target] do
			if val then
				for c, v in ActiveCC[target] do
					ActiveCC[target][c] = false
				end
				self:CCBreaker(target, cat, cause)
				return true
			end
		end
	end
	return false
end

function DPSMate.DB:CCBreaker(target, ability, cause)
	self:BuildAbility(ability)
	for cat, val in {[1]="total",[2]="current"} do
		if not DPSMateCCBreaker[cat][DPSMateUser[cause][1]] then
			DPSMateCCBreaker[cat][DPSMateUser[cause][1]] = {}
		end
		tinsert(DPSMateCCBreaker[cat][DPSMateUser[cause][1]], 1, {
			[1] = DPSMateAbility[ability][1],
			[2] = DPSMateUser[target][1],
			[3] = DPSMateCombatTime[val],
			[4] = GameTime_GetTime()
		})
	end
end
