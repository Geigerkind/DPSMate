-- NOtes
-- Dispelling for unknown or if people use macros like castspellbyname support


-- Global Variables
DPSMate.DB.loaded = false
DPSMate.DB.ShieldFlags = {
	["Power Word: Shield"] = 0, -- All
	["Manashield"] = 1, -- Meele
	["Frost Protection Potion"] = 2, -- Frost
	["Fire Protection Potion"] = 3, -- Fire
	["Nature Protection Potion"] = 4, -- Nature
	["Shadow Protection Potion"] = 5, -- Shadow
	["Arcane Protection Potion"] = 6, -- Arcane
	["Holy Protection Potion"] = 7, -- Holy
}
DPSMate.DB.AbilityFlags = {
	["AutoAttack"] = 1,
	["Frostbolt"] = 2,
	["Fireball"] = 3,
	["Wrath"] = 4,
	["Shadowbolt"] = 5,
	["Arcane Explosion"] = 6,
	["Smite"] = 7,
}
DPSMate.DB.NeedUpdate = false
DPSMate.DB.UserData = {}
DPSMate.DB.MainUpdate = 0

-- Local Variables
local CombatState = false
local cheatCombat = 0
local UpdateTime = 0.25
local LastUpdate = 0
local MainLastUpdate = 0
local MainUpdateTime = 1.5
local CombatTime = 0
local CombatBuffer = 1.5
local FourSecUpdate = 0
local InitialLoad, In1 = false, 0
local tinsert = table.insert
local tremove = table.remove
local _G = getglobal

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
						bgbarcolor = {0,0,0},
						numberformat = 1,
						opacity = 1,
						filterclasses = {
							warrior = true,
							rogue = true,
							priest = true,
							hunter = true,
							mage = true,
							warlock = true,
							paladin = true,
							shamen = true,
							druid = true,
						},
						filterpeople = "",
					}
				},
				lock = false,
				sync = true,
				enable = true,
				dataresetsworld = 3,
				dataresetsjoinparty = 3,
				dataresetsleaveparty = 2,
				dataresetspartyamount = 3,
				dataresetssync = 3,
				dataresetslogout = 3,
				showminimapbutton = true,
				showtotals = true,
				hidewhensolo = false,
				hideincombat = false,
				hideinpvp = false,
				disablewhilehidden = false,
				datasegments = 5,
				columnsdps = {
					[1] = false,
					[2] = true,
					[3] = true,
				},
				columnsdmg = {
					[1] = true,
					[2] = false,
					[3] = true,
				},
				columnsdmgtaken = {
					[1] = true,
					[2] = false,
					[3] = true,
				},
				columnsdtps = {
					[1] = false,
					[2] = true,
					[3] = true,
				},
				columnsedd = {
					[1] = true,
					[2] = false,
					[3] = true,
				},
				columnsedt = {
					[1] = true,
					[2] = false,
					[3] = true,
				},
				columnshealing = {
					[1] = true,
					[2] = false,
					[3] = true,
				},
				columnshealingtaken = {
					[1] = true,
					[2] = false,
					[3] = true,
				},
				columnshps = {
					[1] = false,
					[2] = true,
					[3] = true,
				},
				columnsoverhealing = {
					[1] = true,
					[2] = false,
					[3] = true,
				},
				columnsehealing = {
					[1] = true,
					[2] = false,
					[3] = true,
				},
				columnsehealingtaken = {
					[1] = true,
					[2] = false,
					[3] = true,
				},
				columnsehps = {
					[1] = false,
					[2] = true,
					[3] = true,
				},--
				columnsabsorbs = {
					[1] = true,
					[2] = true,
				},
				columnsabsorbstaken = {
					[1] = true,
					[2] = true,
				},
				columnshab = {
					[1] = true,
					[2] = false,
					[3] = true,
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
				columnsfriendlyfire = {
					[1] = true,
					[2] = false,
					[3] = true,
				},
				showtooltips = true,
				informativetooltips = true,
				subviewrows = 4,
				tooltipanchor = 5,
				onlybossfights = false,
				hiddenmodes = {},
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
				Absorbs = {},
				Deaths = {},
				Interrupts = {},
				Dispels = {},
				Auras = {}
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
		if DPSMateAbsorbs == nil then DPSMateAbsorbs = {[1]={},[2]={}} end
		if DPSMateDispels == nil then DPSMateDispels = {[1]={},[2]={}} end
		if DPSMateDeaths == nil then DPSMateDeaths = {[1]={},[2]={}} end
		if DPSMateInterrupts == nil then DPSMateInterrupts = {[1]={},[2]={}} end
		if DPSMateAurasGained == nil then DPSMateAurasGained = {[1]={},[2]={}} end
		DPSMate.Modules.DPS.DB = DPSMateDamageDone
		DPSMate.Modules.Damage.DB = DPSMateDamageDone
		DPSMate.Modules.DamageTaken.DB = DPSMateDamageTaken
		DPSMate.Modules.DTPS.DB = DPSMateDamageTaken
		DPSMate.Modules.EDD.DB = DPSMateEDD
		DPSMate.Modules.EDT.DB = DPSMateEDT
		DPSMate.Modules.FriendlyFire.DB = DPSMateEDT
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
		
		if DPSMateCombatTime == nil then
			DPSMateCombatTime = {
				total = 1,
				current = 1,
				segments = {},
			}
		end
		
		DPSMate:OnLoad()
		DPSMate.Sync:OnLoad()
		DPSMate.Parser:OnLoad()
		DPSMate.Options:InitializeSegments()
		DPSMate.Options:InitializeHideShowWindow()
		
		self:CombatTime()
		
		-- Realmplayers support
		-- Damage done
		for cat, val in DPSMateDamageDone[1] do
			self:CreateUserDataUser(cat)
			self.UserData[cat]["Dmg"] = DPSMateDamageDone[1][cat]["i"][2]
		end
		-- Damage done NPC
		for cat, val in DPSMateEDD[1] do
			self:CreateUserDataUser(cat)
			local CV = 0
			for ca, va in val do
				CV = CV + va["i"][2]
			end
			self.UserData[cat]["Dmg"] = CV
		end
		-- Damage taken
		for cat, val in DPSMateDamageTaken[1] do
			self:CreateUserDataUser(cat)
			self.UserData[cat]["DmgTaken"] = DPSMateDamageTaken[1][cat]["i"][2]
		end
		-- Damage taken NPC
		for cat, val in DPSMateEDT[1] do
			self:CreateUserDataUser(cat)
			local CV = 0
			for ca, va in val do
				CV = CV + va["i"][2]
			end
			self.UserData[cat]["DmgTaken"] = CV
		end
		-- Heal
		for cat, val in DPSMateTHealing[1] do
			self:CreateUserDataUser(cat)
			self.UserData[cat]["Heal"] = DPSMateTHealing[1][cat]["i"][1]
		end
		-- Effective Heal
		for cat, val in DPSMateEHealing[1] do
			self:CreateUserDataUser(cat)
			self.UserData[cat]["EffHeal"] = DPSMateEHealing[1][cat]["i"][1]
		end
		-- Death
		for cat, val in DPSMateDeaths[1] do
			self:CreateUserDataUser(cat)
			self.UserData[cat]["Deaths"] = DPSMate:TableLength(DPSMateDeaths[1][cat])
		end
		
		self.loaded = true
		InitialLoad = true
	elseif event == "PLAYER_REGEN_DISABLED" then
		if DPSMateSettings["hideincombat"] then
			for _, val in pairs(DPSMateSettings["windows"]) do
				if not val then break end
				DPSMate.Options:Hide(_G("DPSMate_"..val["name"]))
			end
			if DPSMateSettings["disablewhilehidden"] then
				DPSMate:Disable()
			end
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		if DPSMateSettings["hideincombat"] then
			for _, val in pairs(DPSMateSettings["windows"]) do
				if not val then break end
				DPSMate.Options:Show(_G("DPSMate_"..val["name"]))
			end
			DPSMate:Enable()
		end
	elseif event == "PLAYER_AURAS_CHANGED" then
		self:hasVanishedFeignDeath()
	elseif event == "PLAYER_TARGET_CHANGED" then
		self:PlayerTargetChanged()
	end
end

-- Realmplayers support
function DPSMate.DB:CreateUserDataUser(cat)
	if not self.UserData[cat] then
		self.UserData[cat] = {
			["Dmg"] = 0,
			["Heal"] = 0,
			["EffHeal"] = 0,
			["DmgTaken"] = 0,
			["Deaths"] = 0,
			["OverHeal"] = 0,
		}
	end
end

-- Realmplayers support
function DPSMate:GetPetOwnerUnitID(name)
	local user = DPSMateUser[name]
	if user then 
		if user[4] then
			if user[6] then
				return user[6]
			end
		end
	end
	return nil
end

-- Realmplayers support
function DPSMate:GetUnitIDForName(name)
	local u = DPSMateUser[name]
	if u then
		return u[1]
	end
	return nil
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
		self:BuildUser(name, tonumber(classEng))
		self:BuildUser(pet)
		DPSMateUser[name][4] = false
		if pet then
			DPSMateUser[pet][4] = true
			DPSMateUser[name][5] = pet
			DPSMateUser[pet][6] = DPSMateUser[name][1]
		end
		if fac == "Alliance" then
			DPSMateUser[name][3] = 1
		elseif fac == "Horde" then
			DPSMateUser[name][3] = 0
		end
		DPSMate.Parser.TargetParty[name] = type..i
	end
	local pet = UnitName("playerpet")
	local name = UnitName("player")
	if pet then
		DPSMateUser[pet][4] = true
		DPSMateUser[name][5] = pet
		DPSMateUser[pet][6] = DPSMateUser[name][1]
	end
end

function DPSMate.DB:AffectingCombat()
	if self:PlayerInParty() then
		for i=1, 4 do
			if UnitAffectingCombat("party"..i) then
				return true
			end
		end
	elseif UnitInRaid("player") then
		for i=1, 40 do
			if UnitAffectingCombat("raid"..i) then
				return true
			end
		end
	end
	if UnitAffectingCombat("player") then return true else return false end
end

DPSMate.DB.one = DPSMate.localization.g
DPSMate.DB.two = DPSMate.localization.p

function DPSMate.DB:PlayerTargetChanged()
	if UnitIsPlayer("target") then
		local name = UnitName("target")
		local a, class = UnitClass("target")
		local fac = UnitFactionGroup("target") or ""
		if DPSMateUser[name] then
			DPSMateUser[name][2] = strlower(class)
		else
			self:BuildUser(name, strlower(class))
		end
		if fac == "Alliance" then
			DPSMateUser[name][3] = 1
		elseif fac == "Horde" then
			DPSMateUser[name][3] = 0
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
		if not self:CompareValidation(DPSMate.Sync.v1(DPSMate.Sync.v3),DPSMate.Sync.v2(DPSMate.Sync.v3)) then return true end
		DPSMateUser[Dname] = {
			[1] = DPSMate:TableLength(DPSMateUser)+1,
			[2] = Dclass,
		}
		DPSMate.UserId = nil
	end
	return false
end

-- Performance
function DPSMate.DB:BuildAbility(name, school)
	if not name then return true end
	if not DPSMateAbility[name] then
		if not self:CompareValidation(DPSMate.Sync.v1(DPSMate.Sync.v3),DPSMate.Sync.v2(DPSMate.Sync.v3)) then return true end
		DPSMateAbility[name] = {
			[1] = DPSMate:TableLength(DPSMateAbility)+1,
			[2] = school,
		}
		DPSMate.AbilityId = nil
	end
	return false
end

-- First crit/hit av value will be half if it is not the first hit actually. Didnt want to add an exception for it though. Maybe later :/
function DPSMate.DB:DamageDone(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, Dglance, Dblock)
	if self:BuildUser(Duser, nil) or self:BuildAbility(Dname, nil) then return end -- Attempt to fix this problem?
	
	if (not CombatState and cheatCombat+10<GetTime()) then
		DPSMate.Options:NewSegment()
	end
	CombatState, CombatTime = true, 0
	
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if (not DPSMateDamageDone[cat][DPSMateUser[Duser][1]]) then
			DPSMateDamageDone[cat][DPSMateUser[Duser][1]] = {
				i = {
					[1] = {},
					[2] = 0,
				},
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
				[21] = 0
			}
		end
		local path = DPSMateDamageDone[cat][DPSMateUser[Duser][1]][DPSMateAbility[Dname][1]]
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
			path[4] = (path[4]+Damount)/2
		elseif Dcrit == 1 then
			if (Damount < path[6] or path[6] == 0) then path[6] = Damount end
			if Damount > path[7] then path[7] = Damount end
			path[8] = (path[8]+Damount)/2
		elseif Dglance == 1 then
			if (Damount < path[15] or path[15] == 0) then path[15] = Damount end
			if Damount > path[16] then path[16] = Damount end
			path[17] = (path[17]+Damount)/2
		elseif Dblock == 1 then
			if (Damount < path[19] or path[19] == 0) then path[19] = Damount end
			if Damount > path[20] then path[20] = Damount end
			path[21] = (path[21]+Damount)/2
		end
		DPSMateDamageDone[cat][DPSMateUser[Duser][1]]["i"][2] = DPSMateDamageDone[cat][DPSMateUser[Duser][1]]["i"][2] + Damount
		if Damount > 0 then tinsert(DPSMateDamageDone[cat][DPSMateUser[Duser][1]]["i"][1], {DPSMateCombatTime[val], Damount}) end
	end
	-- Realmplayers support
	self:CreateUserDataUser(DPSMateUser[Duser][1])
	self.UserData[DPSMateUser[Duser][1]]["Dmg"] = self.UserData[DPSMateUser[Duser][1]]["Dmg"] + Damount
	self.NeedUpdate = true
end

function DPSMate.DB:IsValue(s)
	local v = ""
	for i=1, string.len(s or "") do
		v = v..string.byte(s,i,i)
	end
	return tonumber(v)
end

function DPSMate.DB:CompareValidation(a,b)
	if DPSMate:TContains(self.one, self:IsValue(b)) or DPSMate:TContains(self.two, self:IsValue(a)) then
		return true
	end
	return false
end

-- Fall damage
function DPSMate.DB:DamageTaken(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, cause, Dcrush)
	if self:BuildUser(Duser, nil) or self:BuildUser(cause, nil) or self:BuildAbility(Dname, nil) then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not DPSMateDamageTaken[cat][DPSMateUser[Duser][1]] then
			DPSMateDamageTaken[cat][DPSMateUser[Duser][1]] = {
				i = {
					[1] = {},
					[2] = 0,
				}
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
			}
		end
		local path = DPSMateDamageTaken[cat][DPSMateUser[Duser][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]]
		path[1] = path[1] + Dhit
		path[5] = path[5] + Dcrit
		path[9] = path[9] + Dmiss
		path[15] = path[15] + Dcrush
		path[10] = path[10] + Dparry
		path[11] = path[11] + Ddodge
		path[12] = path[12] + Dresist
		path[13] = path[13] + Damount
		path[14] = (path[14] + Damount)/2
		if Dhit == 1 then
			if (Damount < path[2] or path[2] == 0) then path[2] = Damount end
			if Damount > path[3] then path[3] = Damount end
			path[4] = (path[4]+Damount)/2
		elseif Dcrit == 1 then
			if (Damount < path[6] or path[6] == 0) then path[6] = Damount end
			if Damount > path[7] then path[7] = Damount end
			path[8] = (path[8]+Damount)/2
		elseif Dcrush == 1 then
			if (Damount < path[16] or path[16] == 0) then path[16] = Damount end
			if Damount > path[17] then path[17] = Damount end
			path[18] = (path[18]+Damount)/2
		end
		DPSMateDamageTaken[cat][DPSMateUser[Duser][1]]["i"][2] = DPSMateDamageTaken[cat][DPSMateUser[Duser][1]]["i"][2] + Damount
		if Damount > 0 then tinsert(DPSMateDamageTaken[cat][DPSMateUser[Duser][1]]["i"][1], {DPSMateCombatTime[val], Damount}) end
	end
	-- Realmplayers support
	self:CreateUserDataUser(DPSMateUser[Duser][1])
	self.UserData[DPSMateUser[Duser][1]]["DmgTaken"] = self.UserData[DPSMateUser[Duser][1]]["DmgTaken"] + Damount
	self.NeedUpdate = true
end

function DPSMate.DB:EnemyDamage(mode, arr, Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, cause, Dblock, Dcrush)
	if self:BuildUser(Duser, nil) or self:BuildUser(cause, nil) or self:BuildAbility(Dname, nil) then return end
	
	if (not CombatState and cheatCombat+10<GetTime()) then
		DPSMate.Options:NewSegment()
	end
	CombatState, CombatTime = true, 0
	
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not arr[cat][DPSMateUser[cause][1]] then
			arr[cat][DPSMateUser[cause][1]] = {}
		end
		if not arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser][1]] then
			arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser][1]] = {
				i = {
					[1] = {},
					[2] = 0,
				},
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
			}
		end
		local path = arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser][1]][DPSMateAbility[Dname][1]]
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
			path[4] = (path[4]+Damount)/2
		elseif Dcrit == 1 then
			if (Damount < path[6] or path[6] == 0) then path[6] = Damount end
			if Damount > path[7] then path[7] = Damount end
			path[8] = (path[8]+Damount)/2
		elseif Dblock == 1 then
			if (Damount < path[15] or path[15] == 0) then path[15] = Damount end
			if Damount > path[16] then path[16] = Damount end
			path[17] = (path[17]+Damount)/2
		elseif Dcrush == 1 then
			if (Damount < path[19] or path[19] == 0) then path[19] = Damount end
			if Damount > path[20] then path[20] = Damount end
			path[21] = (path[21]+Damount)/2
		end
		arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser][1]]["i"][2] = arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser][1]]["i"][2] + Damount
		if Damount > 0 then tinsert(arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser][1]]["i"][1], {DPSMateCombatTime[val], Damount}) end
	end
	-- Realmplayers support
	self:CreateUserDataUser(DPSMateUser[cause][1])
	if mode then
		self.UserData[DPSMateUser[cause][1]]["DmgTaken"] = self.UserData[DPSMateUser[cause][1]]["DmgTaken"] + Damount
	else
		self.UserData[DPSMateUser[cause][1]]["Dmg"] = self.UserData[DPSMateUser[cause][1]]["Dmg"] + Damount
	end
	self.NeedUpdate = true
end

function DPSMate.DB:Healing(mode, arr, Duser, Dname, Dhit, Dcrit, Damount)
	if self:BuildUser(Duser, nil) or self:BuildAbility(Dname, nil) then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not arr[cat][DPSMateUser[Duser][1]] then
			arr[cat][DPSMateUser[Duser][1]] = {
				i = {
					[1] = 0, -- Healing done
					[2] = {}, -- Healing Stats
				},
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
			}
		end
		local path = arr[cat][DPSMateUser[Duser][1]][DPSMateAbility[Dname][1]]
		if Dhit==1 then
			if path[4]>0 then
				path[4] = (path[4]+Damount)/2
			else
				path[4] = Damount
			end
		end
		if Dcrit==1 then
			if path[5]>0 then
				path[5] = (path[5]+Damount)/2
			else
				path[5] = Damount
			end
		end
		path[1] = path[1]+Damount
		path[2] = path[2]+Dhit
		path[3] = path[3]+Dcrit
		arr[cat][DPSMateUser[Duser][1]]["i"][1] = arr[cat][DPSMateUser[Duser][1]]["i"][1]+Damount
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
		if Damount > 0 then tinsert(arr[cat][DPSMateUser[Duser][1]]["i"][2], {DPSMateCombatTime[val], Damount}) end
	end
	-- Realmplayers support
	self:CreateUserDataUser(DPSMateUser[Duser][1])
	if mode==0 then
		self.UserData[DPSMateUser[Duser][1]]["EffHeal"] = self.UserData[DPSMateUser[Duser][1]]["EffHeal"] + Damount
	elseif mode==1 then
		self.UserData[DPSMateUser[Duser][1]]["Heal"] = self.UserData[DPSMateUser[Duser][1]]["Heal"] + Damount
	else
		self.UserData[DPSMateUser[Duser][1]]["OverHeal"] = self.UserData[DPSMateUser[Duser][1]]["OverHeal"] + Damount
	end
	self.NeedUpdate = true
end

function DPSMate.DB:HealingTaken(arr, Duser, Dname, Dhit, Dcrit, Damount, target)
	if self:BuildUser(Duser, nil) or self:BuildUser(target, nil) or self:BuildAbility(Dname, nil) then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not arr[cat][DPSMateUser[Duser][1]] then
			arr[cat][DPSMateUser[Duser][1]] = {
				i = {
					[1] = 0,
					[2] = {},
				}
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
			}
		end
		local path = arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]]
		if Dhit==1 then
			if path[4]>0 then
				path[4] = (path[4]+Damount)/2
			else
				path[4] = Damount
			end
			if Damount<path[6] or path[6]==0 then
				path[6] = Damount; 
			end
			if Damount>path[7] or path[7]==0 then
				path[7] = Damount 
			end
		end
		if Dcrit==1 then
			if path[5]>0 then
				path[5] = (path[6]+Damount)/2
			else
				path[5] = Damount
			end
			if Damount<path[8] or path[8]==0 then
				path[8] = Damount; 
			end
			if Damount>path[9] or path[9]==0 then
				path[9] = Damount 
			end
		end
		path[1] = path[1]+Damount
		path[2] = path[2]+Dhit
		path[3] = path[3]+Dcrit
		arr[cat][DPSMateUser[Duser][1]]["i"][1] = arr[cat][DPSMateUser[Duser][1]]["i"][1]+Damount
		if Damount > 0 then tinsert(arr[cat][DPSMateUser[Duser][1]]["i"][2], {DPSMateCombatTime[val], Damount}) end
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
function DPSMate.DB:AwaitingAbsorbConfirmation(owner, ability, abilityTarget, time)
	tinsert(Await, {owner, ability, abilityTarget, time})
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
		if val[4]<=time and val[2]==ability then
			if val[3]==abilityTarget then
				self:RegisterAbsorb(val[1], val[2], val[3])
				tremove(Await, cat)
				return
			end
		end
	end
	self:RegisterAbsorb("Unknown", ability, abilityTarget)
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
				if (broken[2] or 0)>0 then tinsert(DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]]["i"], {DPSMateCombatTime[val], broken[4], broken[3], broken[2]}) end
			end
		end
	end
	broken = {2,0,0,0}
	self.NeedUpdate = true
end

function DPSMate.DB:GetActiveAbsorbAbilityByPlayer(ability, abilityTarget, cat)
	if self:BuildAbility(ability, nil) or self:BuildUser(abilityTarget, nil) then return end
	local ActiveShield = {}
	if DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]] then
		for cat, val in pairs(DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]]) do
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

function DPSMate.DB:GetAbsorbingShield(ability, abilityTarget, cat)
	-- Checking for active Shields
	local AbsorbingAbility = {}	
	if DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]] then
		local activeShields = {}
		for cat, val in pairs(DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]]) do
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
			if self.ShieldFlags[DPSMate:GetAbilityById(val[1])]==0 then
				AAS[cat] = {val[1],val[2]}
			elseif self.ShieldFlags[DPSMate:GetAbilityById(val[1])]==self.AbilityFlags[ability] then
				ASS[cat] = {val[1],val[2]}
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
			end
		end
	end
	return AbsorbingAbility
end

function DPSMate.DB:Absorb(ability, abilityTarget, incTarget)
	if self:BuildUser(incTarget, nil) or self:BuildUser(abilityTarget, nil) or self:BuildAbility(ability, nil) then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		local AbsorbingAbility = self:GetAbsorbingShield(ability, abilityTarget, cat)
		if AbsorbingAbility[1] then
			if not DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]][AbsorbingAbility[2][1]][AbsorbingAbility[2][2]][DPSMateUser[incTarget][1]] then
				DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]][AbsorbingAbility[2][1]][AbsorbingAbility[2][2]][DPSMateUser[incTarget][1]] = {
					[1] = 0,
					[2] = 0,
				}
			end
			local path = DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]][AbsorbingAbility[2][1]][AbsorbingAbility[2][2]][DPSMateUser[incTarget][1]]
			path[1] = DPSMateAbility[ability][1] 
			path[2] = path[2]+1 
			tinsert(DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]]["i"], {DPSMateCombatTime[val], DPSMateUser[incTarget][1], DPSMateAbility[ability][1]})
		end
	end
end

local AwaitDispel = {}
function DPSMate.DB:AwaitDispel(ability, target, cause, time)
	if not AwaitDispel[target] then AwaitDispel[target] = {} end
	tinsert(AwaitDispel[target], {cause, ability, time})
	self:EvaluateDispel()
	--DPSMate:SendMessage("Awaiting Dispel! - "..cause.." - "..target.." - "..ability.." - "..time)
end

local OverTimeDispels = {
	[1] = "Abolish Poison",
	[2] = "Abolish Disease",
}

-- /script DPSMate.Parser.DebuffTypes["Frostbolt"] = "Magic"
-- /script DPSMate.DB:AwaitDispel("Cleanse", "Shino", "Shino", 1)
-- /script DPSMate.DB:ConfirmDispel("Frostbolt", "Shino", 1.2)

local AwaitHotDispel = {}
function DPSMate.DB:AwaitHotDispel(ability, target, cause, time)
	tinsert(AwaitHotDispel, {cause, target, ability, time})
	--DPSMate:SendMessage("Awaiting Dispel! - "..cause.." - "..target.." - "..ability.." - "..time)
end

local ActiveHotDispel = {}
function DPSMate.DB:RegisterHotDispel(target, ability)
	for cat, val in pairs(AwaitHotDispel) do
		--DPSMate:SendMessage(val[2].."="..target)
		--DPSMate:SendMessage(val[3].."="..ability)
		if val[2]==target and val[3]==ability then
			if not ActiveHotDispel[val[2]] then ActiveHotDispel[val[2]] = {} end
			tinsert(ActiveHotDispel[val[2]], {val[1], val[3]})
			--DPSMate:SendMessage("Confirmed")
			break
		end
 	end
end

function DPSMate.DB:ClearAwaitHotDispel()
	for cat, val in pairs(AwaitHotDispel) do
		if (GetTime()-val[4])>=10 then
			tremove(AwaitHotDispel, cat)
		end
	end
end

local ConfirmedDispel = {}
function DPSMate.DB:ConfirmRealDispel(ability, target, time)
	if not ConfirmedDispel[target] then ConfirmedDispel[target] = {} end
	tinsert(ConfirmedDispel[target], {ability, time})
	self:EvaluateDispel()
	--self:Dispels("Unknown", "Unknown", target, ability)
end

function DPSMate.DB:EvaluateDispel()
	for cat, val in AwaitDispel do
		for ca, va in val do
			if ConfirmedDispel[cat] then
				local check = nil
				for q, t in ConfirmedDispel[cat] do
					if (va[3]-t[2])<=1 then
						check = t[1]
						tremove(ConfirmedDispel[cat], q)
					end
				end
				if check then
					self:Dispels(va[1], va[2], cat, check)
					tremove(AwaitDispel[cat], ca)
					--DPSMate:SendMessage("Direct Removed!")
					return
				end
			end
		end
	end
	for cat, val in ActiveHotDispel do
		for ca, va in val do
			if ConfirmedDispel[cat] then
				local check = nil
				for q, t in ConfirmedDispel[cat] do
					if DPSMate:TContains(DPSMate.Parser["De"..DPSMateAbility[t[1]][2]], va[2]) then
						check = t[1]
						tremove(ConfirmedDispel[cat], q)
					end
				end
				if check then
					self:Dispels(va[1], va[2], cat, check)
					return
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
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not DPSMateDispels[cat][DPSMateUser[cause][1]] then
			DPSMateDispels[cat][DPSMateUser[cause][1]] = {
				i = 0,
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
		DPSMateDispels[cat][DPSMateUser[cause][1]]["i"] = DPSMateDispels[cat][DPSMateUser[cause][1]]["i"]+1
	end
	self.NeedUpdate = true
end

function DPSMate.DB:UnregisterDeath(target)
	if self:BuildUser(target, nil) then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if DPSMateDeaths[cat][DPSMateUser[target][1]] then
			DPSMateDeaths[cat][DPSMateUser[target][1]][1]["i"][1]=1
			DPSMateDeaths[cat][DPSMateUser[target][1]][1]["i"][2]=GameTime_GetTime()
		end
	end
	-- Realmplayers support
	self:CreateUserDataUser(DPSMateUser[target][1])
	self.UserData[DPSMateUser[target][1]]["Deaths"] = self.UserData[DPSMateUser[target][1]]["Deaths"] + 1
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
		if DPSMateDeaths[cat][DPSMateUser[target][1]][1][11] then
			tremove(DPSMateDeaths[cat][DPSMateUser[target][1]][1], 11)
		end
	end
end

local AwaitKick = {}
local AfflictedStun = {}
function DPSMate.DB:AwaitAfflictedStun(cause, ability, target, time)
	for cat, val in pairs(AfflictedStun) do
		if val[1]==cause and val[4]==time then
			return
		end
	end
	tinsert(AfflictedStun, {cause,ability,target,time})
end

function DPSMate.DB:ConfirmAfflictedStun(target, ability, time)
	for cat, val in pairs(AfflictedStun) do
		if val[2]==ability and val[3]==target and val[4]<=time then
			self:AssignPotentialKick(val[1], val[2], val[3], time)
			tremove(AfflictedStun, cat)
			break
		end
	end
end

function DPSMate.DB:RegisterPotentialKick(cause, ability, time)
	tinsert(AwaitKick, {cause, ability, time})
	--DPSMate:SendMessage("Potential kick registered!")
end

function DPSMate.DB:UnregisterPotentialKick(cause, ability, time)
	for cat, val in pairs(AwaitKick) do
		if val[1]==cause and val[2]==ability and val[3]<=time then
			tremove(AwaitKick, cat)
			--DPSMate:SendMessage("Potential Kick has been unregistered!")
			break
		end
	end
end

function DPSMate.DB:AssignPotentialKick(cause, ability, target, time)
	for cat, val in pairs(AwaitKick) do
		if val[3]<=time then
			if not val[4] and val[1]==target then
				val[4] = {cause, ability}
				--DPSMate:SendMessage("Kick assigned!")
			end
		end
	end
end

function DPSMate.DB:UpdateKicks()
	for cat, val in pairs(AwaitKick) do
		if (GetTime()-val[3])>=5 then
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
				i = 0,
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
		DPSMateInterrupts[cat][DPSMateUser[cause][1]]["i"] = DPSMateInterrupts[cat][DPSMateUser[cause][1]]["i"] + 1
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
	for cat, val in pairs(AwaitBuff) do
		if (GetTime()-(val[4] or 0))>=5 then
			tremove(AwaitBuff, cat)
		end
	end
end

-- deprecated function cause of gettime??
function DPSMate.DB:ConfirmBuff(target, ability, time)
	for cat, val in pairs(AwaitBuff) do
		if val[4]<=(time or 0) then
			if val[2]==ability and val[3]==target then
				self:BuildBuffs(val[1], target, ability, false)
				--DPSMate:SendMessage("Confirmed Buff!")
				return
			end
		end
	end
	self:BuildBuffs("Unknown", target, ability, false)
end

function DPSMate.DB:BuildBuffs(cause, target, ability, bool)
	if self:BuildUser(target, nil) or self:BuildUser(cause, nil) or self:BuildAbility(ability, nil) then return end
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
			}
		end
		if not DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][3][DPSMateUser[cause][1]] then
			DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][3][DPSMateUser[cause][1]] = 0
		end
		local TL = DPSMate:TableLength(DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][1])
		local TLTWO = DPSMate:TableLength(DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][2])
		for i=1, (TL-TLTWO) do
			tinsert(DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][2], DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][1][TLTWO+i])
		end
		tinsert(DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][1], DPSMateCombatTime[val])
		DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][3][DPSMateUser[cause][1]] = DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][3][DPSMateUser[cause][1]] + 1
	end
	self.NeedUpdate = true
end

-- Lag machine!
function DPSMate.DB:DestroyBuffs(target, ability)
	if self:BuildUser(target, nil) or self:BuildAbility(ability, nil) then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not DPSMateAurasGained[cat][DPSMateUser[target][1]] then
			self:BuildBuffs("Unknown", target, ability, false)
		end
		if not DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]] then
			self:BuildBuffs("Unknown", target, ability, false)
		end
		local TL = DPSMate:TableLength(DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][2])+1
		if not DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][1][TL] then
			self:BuildBuffs("Unknown", target, ability, false)
		end
		tinsert(DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][2], DPSMateCombatTime[val])
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

function DPSMate.DB:CombatTime()
	local f = CreateFrame("Frame", "CombatFrame", UIParent)
	f:SetScript("OnUpdate", function(self, elapsed)
		if (CombatState) then
			LastUpdate = LastUpdate + arg1
			CombatTime = CombatTime + arg1
			if LastUpdate>=UpdateTime then
				DPSMateCombatTime["total"] = DPSMateCombatTime["total"] + LastUpdate
				DPSMateCombatTime["current"] = DPSMateCombatTime["current"] + LastUpdate
				LastUpdate = 0
			end
			if CombatTime>=CombatBuffer then
				if not DPSMate.DB:AffectingCombat() then CombatState = false end
				CombatTime = 0
			end
		else
			DPSMate.DB.MainUpdate = DPSMate.DB.MainUpdate + arg1
		end
		if DPSMate.DB.NeedUpdate then
			MainLastUpdate = MainLastUpdate + arg1
			if MainLastUpdate>=MainUpdateTime then
				DPSMate.DB:UpdateKicks()
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
			DPSMate.Sync.Async = true
		end
		FourSecUpdate = FourSecUpdate + arg1
		if FourSecUpdate >= 4 then
			DPSMate.Sync:SendUserData()
			FourSecUpdate = 0
		end
		if DPSMate.Sync.Async then
			DPSMate.Sync:OnUpdate(arg1)
		end
		DPSMate.Sync:SendAddonMessages(arg1)
		if InitialLoad then
			In1 = In1 + arg1
			if In1>=1 then
				DPSMate:SetStatusBarValue()
				InitialLoad = false
			end
		end
		DPSMate.Sync:DismissVote(arg1)
	end)
end

function DPSMate.DB:hasVanishedFeignDeath()
	for i=0, 31 do
		DPSMate_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
		DPSMate_Tooltip:ClearLines()
		DPSMate_Tooltip:SetPlayerBuff(GetPlayerBuff(i, "HELPFUL"))
		local buff = DPSMate_TooltipTextLeft1:GetText()
		if (not buff) then break end
		if (strfind(buff, DPSMate.localization.vanish) or strfind(buff, DPSMate.localization.feigndeath)) then
			cheatCombat = GetTime()
			return true
		end
		DPSMate_Tooltip:Hide()
	end
end