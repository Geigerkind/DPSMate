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
								healingandabsorbs = false,
								overhealing = false,
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
	for _, v in pairs({DPSMateUser, DPSMateUserCurrent}) do
		if not v then break end
		for cat, val in pairs(v) do
			if not val then break end
			if (pets[cat]) then
				v[cat]["pet"] = pets[cat]
				if (v[pets[cat]]) then
					v[pets[cat]]["isPet"] = true
				end
			end
		end
	end
end

-- Decrease load if the group has been scanned once
function DPSMate.DB:AssignClass()
	local classEng
	if DPSMate.DB:PlayerInParty() then
		for i=1,4 do
			if UnitExists("party"..i) then
				for _, v in pairs({DPSMateUser, DPSMateUserCurrent}) do
					if not v then break end
					if v[UnitName("party"..i)] then
						if (not v[UnitName("party"..i)].class) then
							t,classEng = UnitClass("party"..i)
							if (classEng) then
								v[UnitName("party"..i)].class = strlower(classEng)
							end
						end
					end
				end
			end
		end
	elseif UnitInRaid("player") then
		for i=1,40 do
			if UnitExists("raid"..i) then
				for _, v in pairs({DPSMateUser, DPSMateUserCurrent}) do
					if not v then break end
					if v[UnitName("raid"..i)] then
						if (not v[UnitName("raid"..i)].class) then
							t,classEng = UnitClass("raid"..i)
							if (classEng) then
								v[UnitName("raid"..i)].class = strlower(classEng)
							end
						end
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
	if (not DPSMateDamageDone[1][DPSMateUser[Dname]["id"]]) then
		for i=1, 2 do 
			DPSMateDamageDone[i][DPSMateUser[Dname]["id"]] = {
				info = {
					[1] = {},
					[2] = {},
					[3] = 0,
				},
			}
		end
	end
end

-- First crit/hit av value will be half if it is not the first hit actually. Didnt want to add an exception for it though. Maybe later :/
function DPSMate.DB:BuildUserAbility(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, Dtype)
	if (DPSMate:TableLength(Duser)==0 or not Dname or not Damount) then return end -- Parsing failure, I guess at AEO periodic abilities
	if (not CombatState and cheatCombat+10<GetTime()) then
		DPSMate.Options:NewSegment()
	end
	CombatState = true
	
	for cat, val in pairs({[1]="total", [2]="current"}) do 
		if DPSMate.DB:DataExist(Duser.name, Dname, DPSMateDamageDone[cat]) then
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

function DPSMate.DB:DataExist(uname, aname, arr)
	if DPSMateUser[uname]~=nil then
		if arr[DPSMateUser[uname]["id"]] ~= nil then
			if arr[DPSMateUser[uname]["id"]][aname] ~= nil then
				return true
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