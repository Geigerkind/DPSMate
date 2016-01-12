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

-- Local Variables
local CombatState = false
local cheatCombat = 0
local UpdateTime = 0.25
local LastUpdate = 0
local MainLastUpdate = 0
local MainUpdateTime = 1.5
local MainLastUpdateMinute = 0

-- Begin Functions

function DPSMate.DB:OnEvent(event)
	if event == "ADDON_LOADED" and (not DPSMate.DB.loaded) then
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
						titlebartexture = "Healbot",
						titlebarbgcolor = {1,1,1},
						contentbgtexture = "UI-Tooltip-Background",
						contentbgcolor = {1,1,1},
						numberformat = 1
					}
				},
				lock = true,
				sync = true,
				dataresetsworld = 3,
				dataresetsjoinparty = 1,
				dataresetsleaveparty = 2,
				dataresetspartyamount = 3,
				showminimapbutton = true,
				showtotals = false,
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
				subviewrows = 3,
				tooltipanchor = 5
			}
		end
		if DPSMateHistory == nil then 
			DPSMateHistory = {
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
		DPSMate.Modules.FriendlyFire.DB = DPSMateDamageTaken
		DPSMate.Modules.DTPS.DB = DPSMateDamageTaken
		DPSMate.Modules.EDD.DB = DPSMateEDD
		DPSMate.Modules.EDT.DB = DPSMateEDT
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
		DPSMate.Parser:OnLoad()
		DPSMate.Options:InitializeSegments()
		DPSMate.Options:InitializeHideShowWindow()
		
		DPSMate.DB:CombatTime()
		
		DPSMate.DB.loaded = true
	elseif event == "PLAYER_REGEN_DISABLED" then
		if DPSMateSettings["hideincombat"] then
			for _, val in pairs(DPSMateSettings["windows"]) do
				if not val then break end
				DPSMate.Options:Hide(getglobal("DPSMate_"..val["name"]))
			end
			if DPSMateSettings["disablewhilehidden"] then
				DPSMate:Disable()
			end
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		if DPSMateSettings["hideincombat"] then
			for _, val in pairs(DPSMateSettings["windows"]) do
				if not val then break end
				DPSMate.Options:Show(getglobal("DPSMate_"..val["name"]))
			end
			DPSMate:Enable()
		end
	elseif event == "PLAYER_AURAS_CHANGED" then
		DPSMate.DB:hasVanishedFeignDeath()
	elseif event == "PLAYER_TARGET_CHANGED" then
		DPSMate.DB:PlayerTargetChanged()
	end
end

function DPSMate.DB:IsReallyPet()
	if DPSMate.DB:PlayerInParty() then
		for i=1, 4 do
			local name = UnitName("party"..i)
			if name then
				DPSMateUser[name]["isPet"] = false
			end
		end
	elseif UnitInRaid("player") then
		for i=1, 40 do
			local name = UnitName("raid"..i)
			if name then
				DPSMateUser[name]["isPet"] = false
			end
		end
	end
end

function DPSMate.DB:GetPets()
	local pets = {}
	if DPSMate.DB:PlayerInParty() then
		for i=1, 4 do
			if UnitName("partypet"..i) and UnitName("party"..i) then
				pets[UnitName("party"..i)] = UnitName("partypet"..i)
			end
		end
	elseif UnitInRaid("player") then
		for i=1, 40 do
			if UnitName("raidpet"..i) and UnitName("raid"..i) then
				pets[UnitName("raid"..i)] = UnitName("raidpet"..i)
			end
		end
	else
		if UnitName("pet") then
			pets[UnitName("player")] = UnitName("pet")
		end
	end
	return pets
end

function DPSMate.DB:AffectingCombat()
	if DPSMate.DB:PlayerInParty() then
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

function DPSMate.DB:AssignPet()
	local pets = DPSMate.DB:GetPets()
	for cat, val in pairs(pets) do
		DPSMateUser[cat]["pet"] = val
		if not DPSMateUser[val] then DPSMate.DB:BuildUser(val, nil) end
		DPSMateUser[val]["isPet"] = true
	end
end

-- Decrease load if the group has been scanned once
-- Error if people are offline? l.229
function DPSMate.DB:AssignClass()
	local classEng
	if DPSMate.DB:PlayerInParty() then
		for i=1,4 do
			local name = UnitName("party"..i)
			if name then
				DPSMate.DB:BuildUser(name, nil)
				t,classEng = UnitClass("party"..i)
				if (classEng) then
					DPSMateUser[name][2] = strlower(classEng)
				end
				if UnitIsFriend("party"..i,"player") then
					DPSMateUser[name][3] = 1
				end
			end
		end
	elseif UnitInRaid("player") then
		for i=1,40 do
			local name = UnitName("raid"..i)
			if name then
				DPSMate.DB:BuildUser(name, nil)
				t,classEng = UnitClass("raid"..i)
				if (classEng) then
					DPSMateUser[name][2] = strlower(classEng)
				end
				if UnitIsFriend("raid"..i,"player") then
					DPSMateUser[name][3] = 1
				end
			end
		end
	end
end

function DPSMate.DB:PlayerTargetChanged()
	if UnitIsPlayer("target") then
		local name = UnitName("target")
		local a, class = UnitClass("target")
		if DPSMateUser[name] then
			DPSMateUser[name][2] = strlower(class)
		else
			DPSMate.DB:BuildUser(name, strlower(class))
		end
		if UnitIsFriend("target","player") then
			DPSMateUser[name][3] = 1
		end
	end
end

function DPSMate.DB:PlayerInParty()
	if GetNumPartyMembers() > 0 and (not UnitInRaid("player")) then
		return true
	end
	return false
end

function DPSMate.DB:BuildUser(Dname, Dclass)
	if (not DPSMateUser[Dname] and type(Dname)~="table") then -- Added to find the table bug
		DPSMateUser[Dname] = {
			[1] = DPSMate:TableLength(DPSMateUser)+1,
			[2] = Dclass,
		}
	end
end

function DPSMate.DB:BuildAbility(name, school)
	if not DPSMateAbility[name] then
		DPSMateAbility[name] = {
			[1] = DPSMate:TableLength(DPSMateAbility)+1,
			[2] = school,
		}
	end
end

-- First crit/hit av value will be half if it is not the first hit actually. Didnt want to add an exception for it though. Maybe later :/
function DPSMate.DB:DamageDone(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount)
	if (not Duser.name or DPSMate:TableLength(Duser)==0 or not Dname or not Damount) then return end -- Parsing failure, I guess at AEO periodic abilities
	if (not CombatState and cheatCombat+10<GetTime()) then
		DPSMate.Options:NewSegment()
	end
	CombatState = true
	
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if DPSMate.DB:DDExist(Duser.name, Dname, DPSMateDamageDone[cat]) then
			DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][1] = DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][1] + Dhit
			DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][5] = DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][5] + Dcrit
			DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][9] = DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][9] + Dmiss
			DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][10] = DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][10] + Dparry
			DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][11] = DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][11] + Ddodge
			DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][12] = DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][12] + Dresist
			DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][13] = DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][13] + Damount
			if Dhit == 1 then
				if (Damount < DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][2] or DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][2] == 0) then DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][2] = Damount end
				if Damount > DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][3] then DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][3] = Damount end
				DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][4] = (DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][4]+Damount)/2
			elseif Dcrit == 1 then
				if (Damount < DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][6] or DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][6] == 0) then DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][6] = Damount end
				if Damount > DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][7] then DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][7] = Damount end
				DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][8] = (DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][8]+Damount)/2
			end
		else
			DPSMate.DB:BuildUser(Duser.name, Duser.class)
			DPSMate.DB:BuildAbility(Dname, nil)
			if (not DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]]) then
				DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]] = {
					i = {
						[1] = {},
						[2] = {},
						[3] = 0,
					},
				}
			end
			DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]] = {
				[1] = Dhit, -- hit
				[2] = 0, -- hitlow
				[3] = 0, -- hithigh
				[4] = 0, -- hitaverage
				[5] = Dcrit, -- crit
				[6] = 0, -- critlow
				[7] = 0, -- crithigh
				[8] = 0, -- critaverage
				[9] = Dmiss, -- miss
				[10] = Dparry, -- parry
				[11] = Ddodge, -- dodge
				[12] = Dresist, -- resist 
				[13] = Damount, -- amount
			}
			if (Dhit == 1) then DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][2] = Damount; DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][3] = Damount; DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][4] = Damount end
			if (Dcrit == 1) then DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][6] = Damount; DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][7] = Damount; DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][8] = Damount end
		end
		DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]]["i"][3] = DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]]["i"][3] + Damount
		DPSMateDamageDone[cat][DPSMateUser[Duser.name][1]]["i"][2][DPSMateCombatTime[val]] = Damount
	end
	DPSMate.DB.NeedUpdate = true
end

-- Fall damage
function DPSMate.DB:DamageTaken(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, cause)
	if (not Duser.name or DPSMate:TableLength(Duser)==0 or not Dname or cause=="") then return end

	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if DPSMate.DB:DTExist(Duser.name, cause, Dname, DPSMateDamageTaken[cat]) then
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][1] = DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][1] + Dhit
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][5] = DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][5] + Dcrit
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][9] = DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][9] + Dmiss
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][10] = DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][10] + Dparry
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][11] = DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][11] + Ddodge
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][12] = DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][12] + Dresist
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][13] = DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][13] + Damount
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][14] = (DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][14] + Damount)/2
			if Dhit == 1 then
				if (Damount < DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][2] or DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][2] == 0) then DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][2] = Damount end
				if Damount > DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][3] then DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][3] = Damount end
				DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][4] = (DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][4]+Damount)/2
			elseif Dcrit == 1 then
				if (Damount < DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][6] or DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][6] == 0) then DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][6] = Damount end
				if Damount > DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][7] then DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][7] = Damount end
				DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][8] = (DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][8]+Damount)/2
			end
		else
			DPSMate.DB:BuildUser(Duser.name, Duser.class)
			DPSMate.DB:BuildUser(cause, nil)
			DPSMate.DB:BuildAbility(Dname, nil)
			if not DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]] then
				DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]] = {}
			end
			if not DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]] then
				DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]] = {
					i = {
						[1] = {},
						[2] = {},
						[3] = 0,
					},
				}
			end
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]] = {
				[1] = Dhit, -- hit
				[2] = 0, -- hitlow
				[3] = 0, -- hithigh
				[4] = 0, -- hitaverage
				[5] = Dcrit, -- crit
				[6] = 0, -- critlow
				[7] = 0, -- crithigh
				[8] = 0, -- critaverage
				[9] = Dmiss, -- miss
				[10] = Dparry, -- parry
				[11] = Ddodge, -- dodge
				[12] = Dresist, -- resist
				[13] = Damount, -- amount
				[14] = Damount, -- average
			}
			if (Dhit == 1) then DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][2] = Damount; DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][3] = Damount; DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][4] = Damount end
			if (Dcrit == 1) then DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][6] = Damount; DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][7] = Damount; DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]][DPSMateAbility[Dname][1]][8] = Damount end
		end
		DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]]["i"][3] = DPSMateDamageTaken[cat][DPSMateUser[Duser.name][1]][DPSMateUser[cause][1]]["i"][3] + Damount
	end
	DPSMate.DB.NeedUpdate = true
end

function DPSMate.DB:EnemyDamage(arr, Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, cause)
	if (not Duser.name or DPSMate:TableLength(Duser)==0 or not Dname or not Damount) then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if DPSMate.DB:EDDExist(Duser.name, cause, Dname, arr[cat]) then
			arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][1] = arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][1] + Dhit
			arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][5] = arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][5] + Dcrit
			arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][9] = arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][9] + Dmiss
			arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][10] = arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][10] + Dparry
			arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][11] = arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][11] + Ddodge
			arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][12] = arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][12] + Dresist
			arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][13] = arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][13] + Damount
			if Dhit == 1 then
				if (Damount < arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][2] or arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][2] == 0) then arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][2] = Damount end
				if Damount > arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][3] then arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][3] = Damount end
				arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][4] = (arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][4]+Damount)/2
			elseif Dcrit == 1 then
				if (Damount < arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][6] or arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][6] == 0) then arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][6] = Damount end
				if Damount > arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][7] then arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][7] = Damount end
				arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][8] = (arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][8]+Damount)/2
			end
		else
			DPSMate.DB:BuildUser(Duser.name, Duser.class)
			DPSMate.DB:BuildUser(cause, nil)
			DPSMate.DB:BuildAbility(Dname, nil)
			if not arr[cat][DPSMateUser[cause][1]] then
				arr[cat][DPSMateUser[cause][1]] = {}
			end
			if not arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]] then
				arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]] = {
					i = {
						[1] = {},
						[2] = {},
						[3] = 0,
					},
				}
			end
			arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]] = {
				[1] = Dhit, -- hit
				[2] = 0, -- hitlow
				[3] = 0, -- hithigh
				[4] = 0, -- hitaverage
				[5] = Dcrit, -- crit
				[6] = 0, -- critlow
				[7] = 0, -- crithigh
				[8] = 0, -- critaverage
				[9] = Dmiss, -- miss
				[10] = Dparry, -- parry
				[11] = Ddodge, -- dodge
				[12] = Dresist, -- resist
				[13] = Damount, -- amount
			}
			if (Dhit == 1) then arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][2] = Damount; arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][3] = Damount; arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][4] = Damount end
			if (Dcrit == 1) then arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][6] = Damount; arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][7] = Damount; arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][8] = Damount end
		end
		arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]]["i"][3] = arr[cat][DPSMateUser[cause][1]][DPSMateUser[Duser.name][1]]["i"][3] + Damount
	end
	DPSMate.DB.NeedUpdate = true
end

function DPSMate.DB:Healing(arr, Duser, Dname, Dhit, Dcrit, Damount, target)
	if (not Duser.name or DPSMate:TableLength(Duser)==0 or not Dname or Dname=="") then return end
	DPSMate.DB:BuildUser(Duser.name, Duser.class)
	DPSMate.DB:BuildUser(target, nil)
	DPSMate.DB:BuildAbility(Dname, nil)
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not arr[cat][DPSMateUser[Duser.name][1]] then
			arr[cat][DPSMateUser[Duser.name][1]] = {
				i = {
					[1] = 0, -- Healing done
				},
			}
		end
		if not arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]] then
			arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]] = {}
		end
		if not arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]] then 
			arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]] = {
				[1] = 0, -- Healing done
				[2] = 0, -- Hit
				[3] = 0, -- Crit
				[4] = 0, -- average
				[5] = 0, -- hitav
				[6] = 0, -- critav
			}
		end
		if Dhit==1 then
			if arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][5]>0 then
				arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][5] = (arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][5]+Damount)/2
			else
				arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][5] = Damount
			end
		end
		if Dcrit==1 then
			if arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][6]>0 then
				arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][6] = (arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][6]+Damount)/2
			else
				arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][6] = Damount
			end
		end
		if arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][4]>0 then arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][4] = (arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][4]+Damount)/2 else arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][4]=Damount end
		arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][1] = arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][1]+Damount
		arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][2] = arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][2]+Dhit
		arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][3] = arr[cat][DPSMateUser[Duser.name][1]][DPSMateAbility[Dname][1]][DPSMateUser[target][1]][3]+Dcrit
		arr[cat][DPSMateUser[Duser.name][1]]["i"][1] = arr[cat][DPSMateUser[Duser.name][1]]["i"][1]+Damount
	end
	DPSMate.DB.NeedUpdate = true
end

function DPSMate.DB:HealingTaken(arr, Duser, Dname, Dhit, Dcrit, Damount, target)
	if (not Duser or not Dname or Dname=="") then return end
	DPSMate.DB:BuildUser(Duser, nil)
	DPSMate.DB:BuildUser(target, nil)
	DPSMate.DB:BuildAbility(Dname, nil)
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not arr[cat][DPSMateUser[Duser][1]] then
			arr[cat][DPSMateUser[Duser][1]] = {
				i = {
					[1] = 0,
				},
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
				[4] = 0, -- average
				[5] = 0, -- hitav
				[6] = 0, -- critav
			}
		end
		if Dhit==1 then
			if arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][5]>0 then
				arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][5] = (arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][5]+Damount)/2
			else
				arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][5] = Damount
			end
		end
		if Dcrit==1 then
			if arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][6]>0 then
				arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][6] = (arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][6]+Damount)/2
			else
				arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][6] = Damount
			end
		end
		if arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][4]>0 then arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][4] = (arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][4]+Damount)/2 else arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][4]=Damount end
		arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][1] = arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][1]+Damount
		arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][2] = arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][2]+Dhit
		arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][3] = arr[cat][DPSMateUser[Duser][1]][DPSMateUser[target][1]][DPSMateAbility[Dname][1]][3]+Dcrit
		arr[cat][DPSMateUser[Duser][1]]["i"][1] = arr[cat][DPSMateUser[Duser][1]]["i"][1]+Damount
	end
	DPSMate.DB.NeedUpdate = true
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
	table.insert(Await, {owner, ability, abilityTarget, time})
	--DPSMate:SendMessage(time)
	--DPSMate:SendMessage("Awaiting confirmation!")
end

function DPSMate.DB:ClearAwaitAbsorb()
	for cat, val in pairs(Await) do
		if (GetTime()-val[4])>=10 then
			table.remove(Await, cat)
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
				DPSMate.DB:RegisterAbsorb(val[1], val[2], val[3])
			--	DPSMate:SendMessage("Confirmed!")
				table.remove(Await, cat)
				break
			end
			if val[3]=="" then
			
			end
		end
	end
end

function DPSMate.DB:RegisterAbsorb(owner, ability, abilityTarget)
	DPSMate.DB:BuildUser(owner, nil)
	DPSMate.DB:BuildUser(abilityTarget, nil)
	DPSMate.DB:BuildAbility(ability, nil)
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]] then
			DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]] = {}
		end
		if not DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][DPSMateUser[owner][1]] then
			DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][DPSMateUser[owner][1]] = {}
		end
		if not DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][DPSMateUser[owner][1]][DPSMateAbility[ability][1]] then
			DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][DPSMateUser[owner][1]][DPSMateAbility[ability][1]] = {}
		end
		table.insert(DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][DPSMateUser[owner][1]][DPSMateAbility[ability][1]], {
			i = {
				[1] = 0,
				[2] = 0,
			},
		})
	end
end

local broken, brokenAbsorb = 2, 0
function DPSMate.DB:SetUnregisterVariables(broAbsorb)
	broken = 1
	brokenAbsorb = broAbsorb
end

function DPSMate.DB:UnregisterAbsorb(ability, abilityTarget)
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		local AbsorbingAbility = DPSMate.DB:GetActiveAbsorbAbilityByPlayer(ability, abilityTarget, cat)
		if AbsorbingAbility[1] then
			if DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]][AbsorbingAbility[2]][AbsorbingAbility[3]]["i"][1] == 0 then
				DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]][AbsorbingAbility[2]][AbsorbingAbility[3]]["i"][1] = broken
				DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]][AbsorbingAbility[2]][AbsorbingAbility[3]]["i"][2] = brokenAbsorb
			end
		end
	end
	broken = 2
	brokenAbsorb = 0
	DPSMate.DB.NeedUpdate = true
end

function DPSMate.DB:GetActiveAbsorbAbilityByPlayer(ability, abilityTarget, cat)
	local ActiveShield = {}
	DPSMate.DB:BuildAbility(ability, nil)
	if DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]] then
		for cat, val in pairs(DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]]) do
			for ca, va in pairs(val) do
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
	return ActiveShield
end

function DPSMate.DB:GetAbsorbingShield(ability, abilityTarget, cat)
	-- Checking for active Shields
	local AbsorbingAbility = {}	
	if DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]] then
		local activeShields = {}
		for cat, val in pairs(DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]]) do
			for ca, va in pairs(val) do
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

		-- Checking for "All-Absorbing"-Shields
		-- Checking for Shields that just absorb the ability's school
		local AAS, ASS = {}, {}
		for cat, val in pairs(activeShields) do
			if DPSMate.DB.ShieldFlags[DPSMate:GetAbilityById(val[1])]==0 then
				AAS[cat] = {val[1],val[2]}
			elseif DPSMate.DB.ShieldFlags[DPSMate:GetAbilityById(val[1])]==DPSMate.DB.AbilityFlags[ability] then
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
					DPSMate.DB:BuildAbility(buff, nil)
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
	DPSMate.DB:BuildUser(incTarget, nil)
	DPSMate.DB:BuildUser(abilityTarget, nil)
	DPSMate.DB:BuildAbility(ability, nil)
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		local AbsorbingAbility = DPSMate.DB:GetAbsorbingShield(ability, abilityTarget, cat)
		if AbsorbingAbility[1] then
			if not DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]][AbsorbingAbility[2][1]][AbsorbingAbility[2][2]][DPSMateUser[incTarget][1]] then
				DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]][AbsorbingAbility[2][1]][AbsorbingAbility[2][2]][DPSMateUser[incTarget][1]] = {
					[1] = 0,
					[2] = 0,
				}
			end
			DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]][AbsorbingAbility[2][1]][AbsorbingAbility[2][2]][DPSMateUser[incTarget][1]][1] = DPSMateAbility[ability][1] 
			DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]][AbsorbingAbility[2][1]][AbsorbingAbility[2][2]][DPSMateUser[incTarget][1]][2] = DPSMateAbsorbs[cat][DPSMateUser[abilityTarget][1]][AbsorbingAbility[1]][AbsorbingAbility[2][1]][AbsorbingAbility[2][2]][DPSMateUser[incTarget][1]][2]+1 
		end
	end
end

local AwaitDispel = {}
function DPSMate.DB:AwaitDispel(ability, target, cause, time)
	table.insert(AwaitDispel, {cause, target, ability, time})
	--DPSMate:SendMessage("Awaiting Dispel! - "..cause.." - "..target.." - "..ability.." - "..time)
end

-- /script DPSMate.Parser.DebuffTypes["Frostbolt"] = "Magic"
-- /script DPSMate.DB:AwaitDispel("Cleanse", "Shino", "Shino", 1)
-- /script DPSMate.DB:ConfirmDispel("Frostbolt", "Shino", 1.2)

-- l. 957 
function DPSMate.DB:ConfirmDispel(ability, target, time)
	if ability and ability~="" then
		for cat, val in pairs(AwaitDispel) do
			if val[2] == target and (time-val[4])<=1 and DPSMate:TContains(DPSMate.Parser["Dispels"], val[3]) then -- Maybe a bug is caused now? Cause I changed the table
				DPSMate.DB:Dispels(val[1], val[3], val[2], ability)
				--DPSMate:SendMessage("Confirmed!")
				table.remove(AwaitDispel, cat)
				return
			end
		end
	end
	DPSMate.DB:Dispels("Unknown", "Unknown", target, ability)
end

local AwaitHotDispel = {}
function DPSMate.DB:AwaitHotDispel(ability, target, cause, time)
	table.insert(AwaitHotDispel, {cause, target, ability, time})
end

function DPSMate.DB:ClearAwaitHotDispel()
	for cat, val in pairs(AwaitHotDispel) do
		if (GetTime()-val[4])>=10 then
			table.remove(AwaitHotDispel, cat)
			break
		end
	end
end

local ActiveHotDispel = {}
function DPSMate.DB:RegisterHotDispel(target, ability, time)
	for cat, val in pairs(AwaitHotDispel) do
		if val[2]==target and val[3]==ability and val[4]<=time then
			table.insert(ActiveHotDispel, {val[1], val[2], val[3]})
			break
		end
 	end
end

function DPSMate.DB:UnregisterHotDispel(target, ability)
	for cat, val in pairs(ActiveHotDispel) do
		if val[2]==target and val[3]==ability then
			table.remove(ActiveHotDispel, cat)
			break
		end
	end
end

function DPSMate.DB:ConfirmHotDispel(target, ability)
	for cat, val in pairs(ActiveHotDispel) do
		if val[2]==target and DPSMate:TContains(DPSMate.Parser["De"..DPSMateAbility[ability][2]], val[3]) then
			DPSMate.DB:Dispels(val[1], val[3], val[2], ability)
			return
		end
	end
	DPSMate.DB:Dispels("Unknown", "Unknown", target, ability)
end


-- l. 798
function DPSMate.DB:Dispels(cause, Dname, target, ability)
	if (cause=="" or not Dname or Dname=="") then return end
	DPSMate.DB:BuildUser(cause, nil)
	DPSMate.DB:BuildUser(target, nil)
	DPSMate.DB:BuildAbility(Dname, nil)
	DPSMate.DB:BuildAbility(ability, nil)
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not DPSMateDispels[cat][DPSMateUser[cause][1]] then
			DPSMateDispels[cat][DPSMateUser[cause][1]] = {
				i = {
					[1] = 0, -- Dispels done
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
	end
	DPSMate.DB.NeedUpdate = true
end

function DPSMate.DB:UnregisterDeath(target)
	if not DPSMateUser[target] then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if DPSMateDeaths[cat][DPSMateUser[target][1]] then
			DPSMateDeaths[cat][DPSMateUser[target][1]][DPSMate:TableLength(DPSMateDeaths[cat][DPSMateUser[target][1]])]["i"]=1
		end
	end
end
-- l. 846
function DPSMate.DB:DeathHistory(target, cause, ability, amount, hit, crit, type)
	if (not target or target=="" or not cause or cause=="" or amount==0) then return end
	DPSMate.DB:BuildUser(target, nil)
	DPSMate.DB:BuildUser(cause, nil)
	DPSMate.DB:BuildAbility(ability, nil)
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not DPSMateDeaths[cat][DPSMateUser[target][1]] then
			DPSMateDeaths[cat][DPSMateUser[target][1]] = {}
		end
		if not DPSMateDeaths[cat][DPSMateUser[target][1]][1] then
			DPSMateDeaths[cat][DPSMateUser[target][1]][1] = {
				i = 0,
			}
		end
		if DPSMateDeaths[cat][DPSMateUser[target][1]][1]["i"]==1 then
			table.insert(DPSMateDeaths[cat][DPSMateUser[target][1]], 1, {i = 0})
		end
		local hitCrit = crit
		table.insert(DPSMateDeaths[cat][DPSMateUser[target][1]][1], 1, {
			[1] = DPSMateUser[cause][1],
			[2] = DPSMateAbility[ability][1],
			[3] = amount,
			[4] = hitCrit,
			[5] = type,
		})
		if DPSMateDeaths[cat][DPSMateUser[target][1]][1][7] then
			table.remove(DPSMateDeaths[cat][DPSMateUser[target][1]][1], 7)
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
	table.insert(AfflictedStun, {cause,ability,target,time})
end

function DPSMate.DB:ConfirmAfflictedStun(target, ability, time)
	for cat, val in pairs(AfflictedStun) do
		if val[2]==ability and val[3]==target and val[4]<=time then
			DPSMate.DB:AssignPotentialKick(val[1], val[2], val[3], time)
			table.remove(AfflictedStun, cat)
			break
		end
	end
end

function DPSMate.DB:RegisterPotentialKick(cause, ability, time)
	table.insert(AwaitKick, {cause, ability, time})
	--DPSMate:SendMessage("Potential kick registered!")
end

function DPSMate.DB:UnregisterPotentialKick(cause, ability, time)
	for cat, val in pairs(AwaitKick) do
		if val[1]==cause and val[2]==ability and val[3]<=time then
			table.remove(AwaitKick, cat)
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
				DPSMate.DB:Kick(val[4][1], val[1], val[4][2], val[2])
			end
			table.remove(AwaitKick, cat)
		end
	end
end

function DPSMate.DB:Kick(cause, target, causeAbility, targetAbility)
	if (not target or target=="" or not cause or cause=="") then return end
	DPSMate.DB:BuildUser(target, nil)
	DPSMate.DB:BuildUser(cause, nil)
	DPSMate.DB:BuildAbility(causeAbility, nil)
	DPSMate.DB:BuildAbility(targetAbility, nil)
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
	table.insert(AwaitBuff, {cause, ability, target, time})
	--DPSMate:SendMessage("Awaiting buff!"..ability)
end

function DPSMate.DB:ClearAwaitBuffs()
	for cat, val in pairs(AwaitBuff) do
		if (GetTime()-val[4])>=5 then
			table.remove(AwaitBuff, cat)
		end
	end
end

function DPSMate.DB:ConfirmBuff(target, ability, time)
	for cat, val in pairs(AwaitBuff) do
		if val[4]<=time then
			if val[2]==ability and val[3]==target then
				DPSMate.DB:BuildBuffs(val[1], target, ability, false)
				--DPSMate:SendMessage("Confirmed Buff!")
				return
			end
		end
	end
	DPSMate.DB:BuildBuffs("Unknown", target, ability, false)
end

function DPSMate.DB:BuildBuffs(cause, target, ability, bool)
	if (not target or target=="" or not cause or cause=="") then return end
	DPSMate.DB:BuildUser(target, nil)
	DPSMate.DB:BuildUser(cause, nil)
	DPSMate.DB:BuildAbility(ability, nil)
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
		table.insert(DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][1], DPSMateCombatTime[val])
		DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][3][DPSMateUser[cause][1]] = DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][3][DPSMateUser[cause][1]] + 1
	end
	DPSMate.DB.NeedUpdate = true
end

-- Lag machine!
function DPSMate.DB:DestroyBuffs(target, ability)
	if (not target or target=="" or ability=="") then return end
	DPSMate.DB:BuildUser(target, nil)
	DPSMate.DB:BuildAbility(ability, nil)
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if not DPSMateAurasGained[cat][DPSMateUser[target][1]] then
			DPSMate.DB:BuildBuffs("Unknown", target, ability, false)
		elseif not DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]] then
			DPSMate.DB:BuildBuffs("Unknown", target, ability, false)
		end
		table.insert(DPSMateAurasGained[cat][DPSMateUser[target][1]][DPSMateAbility[ability][1]][2], DPSMateCombatTime[val])
	end
	DPSMate.DB.NeedUpdate = true
end

-- Are those functions able to be combined?
function DPSMate.DB:DDExist(uname, aname, arr)
	if DPSMateUser[uname]~=nil and DPSMateAbility[aname]~=nil then
		if arr[DPSMateUser[uname][1]] ~= nil then
			if arr[DPSMateUser[uname][1]][DPSMateAbility[aname][1]] ~= nil then
				return true
			end
		end
	end
	return false
end

-- Line 802
function DPSMate.DB:DTExist(uname, cause, aname, arr)
	if DPSMateUser[uname]~=nil and DPSMateUser[cause]~=nil and DPSMateAbility[aname]~=nil then
		if arr[DPSMateUser[uname][1]] ~= nil then
			if arr[DPSMateUser[uname][1]][DPSMateUser[cause][1]] ~= nil then
				if arr[DPSMateUser[uname][1]][DPSMateUser[cause][1]][DPSMateAbility[aname][1]] ~= nil then
					return true
				end
			end
		end
	end
	return false
end

function DPSMate.DB:EDDExist(uname, cause, aname, arr)
	if DPSMateUser[uname]~=nil and DPSMateUser[cause]~=nil and DPSMateAbility[aname]~=nil then
		if arr[DPSMateUser[cause][1]] ~= nil then
			if arr[DPSMateUser[cause][1]][DPSMateUser[uname][1]] ~= nil then
				if arr[DPSMateUser[cause][1]][DPSMateUser[uname][1]][DPSMateAbility[aname][1]] ~= nil then
					return true
				end
			end
		end
	end
	return false
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
			if LastUpdate>=UpdateTime then
				DPSMateCombatTime["total"] = DPSMateCombatTime["total"] + LastUpdate
				DPSMateCombatTime["current"] = DPSMateCombatTime["current"] + LastUpdate
				if not DPSMate.DB:AffectingCombat() then CombatState = false end
				LastUpdate = 0
			end
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
		MainLastUpdateMinute = MainLastUpdateMinute + arg1
		if MainLastUpdateMinute>=60 then
			DPSMate.DB:ClearAwaitBuffs()
			DPSMate.DB:ClearAwaitAbsorb()
			DPSMate.DB:ClearAwaitHotDispel()
			MainLastUpdateMinute = 0
			DPSMate.Sync.Async = true
		end
		if DPSMate.Sync.Async then
			DPSMate.Sync:OnUpdate(arg1)
		end
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