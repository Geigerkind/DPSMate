-- Global Variables
DPSMate.DB.loaded = false

-- Local Variables
local CombatState = false
local cheatCombat = 0
local UpdateTime = 0.25
local LastUpdate = 0

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
								dps = false,
								damage = true,
								damagetaken = false,
								enemydamagetaken = false,
								enemydamagedone = false,
								healing = false,
								effectivehealing = false,
								healingandabsorbs = false,
								overhealing = false,
								healingtaken = false,
								effectivehealingtaken = false,
								interrupts = false,
								deaths = false,
								dispels = false
							},
							[2] = {
								total = true,
								currentfight = false,
								segment1 = false,
								segment2 = false,
								segment3 = false,
								segment4 = false,
								segment5 = false,
								segment6 = false,
								segment7 = false,
								segment8 = false,
								segment9 = false,
								segment10 = false,
								segment11 = false,
								segment12 = false,
								segment13 = false
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
				showtooltips = true,
				informativetooltips = true,
				subviewrows = 3,
				tooltipanchor = 5
			}
		end
		if DPSMateHistory == nil then DPSMateHistory = {} end
		if DPSMateUser == nil then DPSMateUser = {} end
		if DPSMateDamageDone == nil then DPSMateDamageDone = {[1]={},[2]={}} end
		if DPSMateDamageTaken == nil then DPSMateDamageTaken = {[1]={},[2]={}} end
		if DPSMateEDD == nil then DPSMateEDD = {[1]={},[2]={}} end
		if DPSMateEDT == nil then DPSMateEDT = {[1]={},[2]={}} end
		if DPSMateTHealing == nil then DPSMateTHealing = {[1]={},[2]={}} end
		if DPSMateEHealing == nil then DPSMateEHealing = {[1]={},[2]={}} end
		if DPSMateOverhealing == nil then DPSMateOverhealing = {[1]={},[2]={}} end
		if DPSMateHealingTaken == nil then DPSMateHealingTaken = {[1]={},[2]={}} end
		if DPSMateEHealingTaken == nil then DPSMateEHealingTaken = {[1]={},[2]={}} end
		if DPSMateCombatTime == nil then
			DPSMateCombatTime = {
				total = 1,
				current = 1,
				segments = {},
			}
		end
		
		DPSMate:OnLoad()
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

-- Need to fix an error here l. 156(?)
function DPSMate.DB:GetPets()
	local pets = {}
	if DPSMate.DB:PlayerInParty() then
		for i=1, 4 do
			if UnitName("partypet"..i) then
				pets[UnitName("party"..i)] = UnitName("partypet"..i)
			end
		end
	elseif UnitInRaid("player") then
		for i=1, 40 do
			if UnitName("raidpet"..i) then
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
			if UnitExists("party"..i) then
				if not DPSMateUser[UnitName("party"..i)] then
					DPSMate.DB:BuildUser(UnitName("party"..i), nil)
				end
				if (not DPSMateUser[UnitName("party"..i)]["class"]) then
					t,classEng = UnitClass("party"..i)
					if (classEng) then
						DPSMateUser[UnitName("party"..i)]["class"] = strlower(classEng)
					end
				end
			end
		end
	elseif UnitInRaid("player") then
		for i=1,40 do
			if UnitExists("raid"..i) then
				if DPSMateUser[UnitName("raid"..i)] then
					DPSMate.DB:BuildUser(UnitName("raid"..i), nil)
				end
				if (not DPSMateUser[UnitName("raid"..i)]["class"]) then
					t,classEng = UnitClass("raid"..i)
					if (classEng) then
						DPSMateUser[UnitName("raid"..i)]["class"] = strlower(classEng)
					end
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
			DPSMateUser[name]["class"] = strlower(class)
		else
			DPSMate.DB:BuildUser(name, strlower(class))
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
	if (not DPSMateUser[Dname]) then
		DPSMateUser[Dname] = {
			id = DPSMate:TableLength(DPSMateUser)+1,
			class = Dclass,
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
			DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].hit = DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].hit + Dhit
			DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].crit = DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].crit + Dcrit
			DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].miss = DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].miss + Dmiss
			DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].parry = DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].parry + Dparry
			DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].dodge = DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].dodge + Ddodge
			DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].resist = DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].resist + Dresist
			DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].amount = DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].amount + Damount
			if Dhit == 1 then
				if (Damount < DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].hitlow or DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].hitlow == 0) then DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].hitlow = Damount end
				if Damount > DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].hithigh then DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].hithigh = Damount end
				DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname]["hitaverage"] = (DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname]["hitaverage"]+Damount)/2
			elseif Dcrit == 1 then
				if (Damount < DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].critlow or DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].critlow == 0) then DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].critlow = Damount end
				if Damount > DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].crithigh then DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].crithigh = Damount end
				DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname]["critaverage"] = (DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname]["critaverage"]+Damount)/2
			end
		else
			DPSMate.DB:BuildUser(Duser.name, Duser.class)
			for i=1, 2 do 
				if (not DPSMateDamageDone[i][DPSMateUser[Duser.name]["id"]]) then
					DPSMateDamageDone[i][DPSMateUser[Duser.name]["id"]] = {
						info = {
							[1] = {},
							[2] = {},
							[3] = 0,
						},
					}
				end
			end
			DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname] = {
				hit = Dhit,
				hitlow = 0,
				hithigh = 0,
				hitaverage = 0,
				crit = Dcrit,
				critlow = 0,
				crithigh = 0,
				critaverage = 0,
				miss = Dmiss,
				parry = Dparry,
				dodge = Ddodge,
				resist = Dresist,
				amount = Damount,
			}
			if (Dhit == 1) then DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].hitlow = Damount; DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].hithigh = Damount; DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].hitaverage = Damount end
			if (Dcrit == 1) then DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].critlow = Damount; DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].crithigh = Damount; DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]][Dname].critaverage = Damount end
		end
		DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]]["info"][3] = DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]]["info"][3] + Damount
		DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]]["info"][2][DPSMateCombatTime[val]] = Damount
	end
	DPSMate:SetStatusBarValue()
end

function DPSMate.DB:DamageTaken(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, cause)
	if (not Duser.name or DPSMate:TableLength(Duser)==0 or not Dname or not Damount) then return end

	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if DPSMate.DB:DTExist(Duser.name, cause, Dname, DPSMateDamageTaken[cat]) then
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].hit = DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].hit + Dhit
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].crit = DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].crit + Dcrit
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].miss = DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].miss + Dmiss
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].parry = DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].parry + Dparry
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].dodge = DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].dodge + Ddodge
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].resist = DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].resist + Dresist
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].amount = DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].amount + Damount
			if Dhit == 1 then
				if (Damount < DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].hitlow or DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].hitlow == 0) then DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].hitlow = Damount end
				if Damount > DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].hithigh then DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].hithigh = Damount end
				DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname]["hitaverage"] = (DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname]["hitaverage"]+Damount)/2
			elseif Dcrit == 1 then
				if (Damount < DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].critlow or DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].critlow == 0) then DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].critlow = Damount end
				if Damount > DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].crithigh then DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname].crithigh = Damount end
				DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname]["critaverage"] = (DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname]["critaverage"]+Damount)/2
			end
		else
			DPSMate.DB:BuildUser(Duser.name, Duser.class)
			for i=1, 2 do 
				if not DPSMateDamageTaken[i][DPSMateUser[Duser.name]["id"]] then
					DPSMateDamageTaken[i][DPSMateUser[Duser.name]["id"]] = {}
				end
				if not DPSMateDamageTaken[i][DPSMateUser[Duser.name]["id"]][cause] then
					DPSMateDamageTaken[i][DPSMateUser[Duser.name]["id"]][cause] = {
						info = {
							[1] = {},
							[2] = {},
							[3] = 0,
						},
					}
				end
			end
			DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname] = {
				hit = Dhit,
				hitlow = 0,
				hithigh = 0,
				hitaverage = 0,
				crit = Dcrit,
				critlow = 0,
				crithigh = 0,
				critaverage = 0,
				miss = Dmiss,
				parry = Dparry,
				dodge = Ddodge,
				resist = Dresist,
				amount = Damount,
			}
			if (Dhit == 1) then DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname]["hitlow"] = Damount; DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname]["hithigh"] = Damount; DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname]["hitaverage"] = Damount end
			if (Dcrit == 1) then DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname]["critlow"] = Damount; DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname]["crithigh"] = Damount; DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause][Dname]["critaverage"] = Damount end
		end
		DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause]["info"][3] = DPSMateDamageTaken[cat][DPSMateUser[Duser.name]["id"]][cause]["info"][3] + Damount
	end
	DPSMate:SetStatusBarValue()
end

function DPSMate.DB:EnemyDamage(arr, Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, cause)
	if (not Duser.name or DPSMate:TableLength(Duser)==0 or not Dname or not Damount) then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if DPSMate.DB:EDDExist(Duser.name, cause, Dname, arr[cat]) then
			arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].hit = arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].hit + Dhit
			arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].crit = arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].crit + Dcrit
			arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].miss = arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].miss + Dmiss
			arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].parry = arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].parry + Dparry
			arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].dodge = arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].dodge + Ddodge
			arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].resist = arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].resist + Dresist
			arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].amount = arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].amount + Damount
			if Dhit == 1 then
				if (Damount < arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].hitlow or arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].hitlow == 0) then arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].hitlow = Damount end
				if Damount > arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].hithigh then arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].hithigh = Damount end
				arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname]["hitaverage"] = (arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname]["hitaverage"]+Damount)/2
			elseif Dcrit == 1 then
				if (Damount < arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].critlow or arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].critlow == 0) then arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].critlow = Damount end
				if Damount > arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].crithigh then arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname].crithigh = Damount end
				arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname]["critaverage"] = (arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname]["critaverage"]+Damount)/2
			end
		else
			DPSMate.DB:BuildUser(Duser.name, Duser.class)
			for i=1, 2 do 
				if not arr[i][cause] then
					arr[i][cause] = {}
				end
				if not arr[i][cause][DPSMateUser[Duser.name]["id"]] then
					arr[i][cause][DPSMateUser[Duser.name]["id"]] = {
						info = {
							[1] = {},
							[2] = {},
							[3] = 0,
						},
					}
				end
			end
			arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname] = {
				hit = Dhit,
				hitlow = 0,
				hithigh = 0,
				hitaverage = 0,
				crit = Dcrit,
				critlow = 0,
				crithigh = 0,
				critaverage = 0,
				miss = Dmiss,
				parry = Dparry,
				dodge = Ddodge,
				resist = Dresist,
				amount = Damount,
			}
			if (Dhit == 1) then arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname]["hitlow"] = Damount; arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname]["hithigh"] = Damount; arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname]["hitaverage"] = Damount end
			if (Dcrit == 1) then arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname]["critlow"] = Damount; arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname]["crithigh"] = Damount; arr[cat][cause][DPSMateUser[Duser.name]["id"]][Dname]["critaverage"] = Damount end
		end
		arr[cat][cause][DPSMateUser[Duser.name]["id"]]["info"][3] = arr[cat][cause][DPSMateUser[Duser.name]["id"]]["info"][3] + Damount
	end
	DPSMate:SetStatusBarValue()
end

function DPSMate.DB:Healing(arr, Duser, Dname, Dhit, Dcrit, Damount, target)
	if (not Duser.name or DPSMate:TableLength(Duser)==0 or not Dname or Dname=="") then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		DPSMate.DB:BuildUser(Duser.name, Duser.class)
		if not arr[cat][DPSMateUser[Duser.name]["id"]] then
			arr[cat][DPSMateUser[Duser.name]["id"]] = {
				info = {
					[1] = 0, -- Healing done
				},
			}
		end
		if not arr[cat][DPSMateUser[Duser.name]["id"]][Dname] then
			arr[cat][DPSMateUser[Duser.name]["id"]][Dname] = {}
		end
		if not arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target] then 
			arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target] = {
				[1] = 0, -- Healing done
				[2] = 0, -- Hit
				[3] = 0, -- Crit
				[4] = 0, -- average
				[5] = 0, -- hitav
				[6] = 0, -- critav
			}
		end
		if Dhit==1 then
			if arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][5]>0 then
				arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][5] = (arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][5]+Damount)/2
			else
				arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][5] = Damount
			end
		end
		if Dcrit==1 then
			if arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][6]>0 then
				arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][6] = (arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][6]+Damount)/2
			else
				arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][6] = Damount
			end
		end
		if arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][4]>0 then arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][4] = (arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][4]+Damount)/2 else arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][4]=Damount end
		arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][1] = arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][1]+Damount
		arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][2] = arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][2]+Dhit
		arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][3] = arr[cat][DPSMateUser[Duser.name]["id"]][Dname][target][3]+Dcrit
		arr[cat][DPSMateUser[Duser.name]["id"]]["info"][1] = arr[cat][DPSMateUser[Duser.name]["id"]]["info"][1]+Damount
	end
	DPSMate:SetStatusBarValue()
end

function DPSMate.DB:HealingTaken(arr, Duser, Dname, Dhit, Dcrit, Damount, target)
	if (not Duser or not Dname or Dname=="") then return end
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		DPSMate.DB:BuildUser(Duser, nil)
		DPSMate.DB:BuildUser(target, nil)
		if not arr[cat][DPSMateUser[Duser]["id"]] then
			arr[cat][DPSMateUser[Duser]["id"]] = {
				info = {
					[1] = 0,
				},
			}
		end
		if not arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]] then
			arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]] = {}
		end
		if not arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname] then
			arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname] = {
				[1] = 0, -- Healing done
				[2] = 0, -- Hit
				[3] = 0, -- Crit
				[4] = 0, -- average
				[5] = 0, -- hitav
				[6] = 0, -- critav
			}
		end
		if Dhit==1 then
			if arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][5]>0 then
				arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][5] = (arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][5]+Damount)/2
			else
				arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][5] = Damount
			end
		end
		if Dcrit==1 then
			if arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][6]>0 then
				arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][6] = (arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][6]+Damount)/2
			else
				arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][6] = Damount
			end
		end
		if arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][4]>0 then arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][4] = (arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][4]+Damount)/2 else arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][4]=Damount end
		arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][1] = arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][1]+Damount
		arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][2] = arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][2]+Dhit
		arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][3] = arr[cat][DPSMateUser[Duser]["id"]][DPSMateUser[target]["id"]][Dname][3]+Dcrit
		arr[cat][DPSMateUser[Duser]["id"]]["info"][1] = arr[cat][DPSMateUser[Duser]["id"]]["info"][1]+Damount
	end
	DPSMate:SetStatusBarValue()
end

-- Are those functions able to be combined?
function DPSMate.DB:DDExist(uname, aname, arr)
	if DPSMateUser[uname]~=nil then
		if arr[DPSMateUser[uname]["id"]] ~= nil then
			if arr[DPSMateUser[uname]["id"]][aname] ~= nil then
				return true
			end
		end
	end
	return false
end

function DPSMate.DB:DTExist(uname, cause, aname, arr)
	if DPSMateUser[uname]~=nil then
		if arr[DPSMateUser[uname]["id"]] ~= nil then
			if arr[DPSMateUser[uname]["id"]][cause] ~= nil then
				if arr[DPSMateUser[uname]["id"]][cause][aname] ~= nil then
					return true
				end
			end
		end
	end
	return false
end

function DPSMate.DB:EDDExist(uname, cause, aname, arr)
	if DPSMateUser[uname]~=nil then
		if arr[cause] ~= nil then
			if arr[cause][DPSMateUser[uname]["id"]] ~= nil then
				if arr[cause][DPSMateUser[uname]["id"]][aname] ~= nil then
					return true
				end
			end
		end
	end
	return false
end

function DPSMate.DB:DataExistProcs(uname, aname, arr)
	if DPSMateUser[uname]~=nil then
		if arr[DPSMateUser[uname]["id"]] ~= nil then
			if arr[DPSMateUser[uname]["id"]]["info"][1][aname] ~= nil then
				return true
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

-- Improve Procs distplay in line graph -> if no damage is time inbetween a line, it is not colored.
function DPSMate.DB:BuildUserProcs(Duser, Dname, Dbool) -- has to be made dynamic again
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if DPSMate.DB:DataExistProcs(Duser.name, Dname, DPSMateDamageDone[cat]) then
			local len = DPSMate:TableLength(DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]]["info"][1][Dname]["start"])
			if DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]]["info"][1][Dname]["start"][len] and not DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]]["info"][1][Dname]["ending"][len] then
				DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]]["info"][1][Dname]["ending"][len] = DPSMateCombatTime[val]
			else
				DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]]["info"][1][Dname]["start"][len+1] = DPSMateCombatTime[val]
			end
		else
			DPSMate.DB:BuildUser(Duser.name, Duser.class)
			if DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]] then
				DPSMateDamageDone[cat][DPSMateUser[Duser.name]["id"]]["info"][1][Dname] = {
					start = {
						[1] = DPSMateCombatTime[val],
					},
					ending = {},
					point = Dbool,
				}
			end
		end
	end
end