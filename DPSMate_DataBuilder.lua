-- Global Variables
DPSMate.DB.loaded = false

-- Local Variables
local CombatState = false
local cheatCombat = 0

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
								dispels = false,
							},
							[2] = {
								total = true,
								currentfight = false,
								segment1 = false,
								segment2 = false,
								segment3 = false,
								segment4 = false,
								segment5 = false,
							},
							[3] = {
								lock = false,
							},
						},
						CurMode = "damage",
						hidden = "false",
					}
				},
				lock = true,
				scale = 1,
				barfont = "ARIALN",
				barfontsize = 14,
				barfontflag = "Outline",
				bartexture = "Healbot",
				barspacing = 1,
				barheight = 12,
				classicons = false,
				ranks = true,
				titlebar = true,
				titlebarfont = "FRIZQT",
				titlebarfontflags = "None",
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
				dataresetsworld = false,
				dataresetsjoinparty = 0,
				dataresetsleaveparty = 0,
				dataresetspartyamount = 0,
			}
		end
		if DPSMateHistory == nil then DPSMateHistory = {} end
		if DPSMateUser == nil then DPSMateUser = {} end
		if DPSMateUserCurrent == nil then DPSMateUserCurrent = {} end
		if DPSMateCombatTime == nil then
			DPSMateCombatTime = {
				total = 1,
				current = 1,
				segments = {},
			}
		end
		DPSMate:OnLoad()
		DPSMate.Options:InitializeSegments()
		
		DPSMate.DB:CombatTime()
		
		DPSMate.DB.loaded = true
	elseif event == "PLAYER_REGEN_DISABLED" then
		if (cheatCombat+10<GetTime()) then
			DPSMate.Options:NewSegment()
		end
		CombatState = true
	elseif event == "PLAYER_REGEN_ENABLED" then
		CombatState = false
	elseif event == "PLAYER_AURAS_CHANGED" then
		DPSMate.DB:hasVanishedFeignDeath()
	end
	-- Performance!!!
	DPSMate.DB:AssignPet()
	DPSMate.DB:AssignClass()
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

function DPSMate.DB:AssignPet()
	local pets = DPSMate.DB:GetPets()
	for _, v in pairs({DPSMateUser, DPSMateUserCurrent}) do
		for cat, val in pairs(v) do
			if (pets[cat]) then
				v[cat]["pet"] = pets[cat]
				if (v[pets[cat]]) then
					v[pets[cat]]["isPet"] = true
				end
			end
		end
	end
end

function DPSMate.DB:AssignClass()
	local classEng
	if DPSMate.DB:PlayerInParty() then
		for i=1,4 do
			for _, v in pairs({DPSMateUser, DPSMateUserCurrent}) do
				if v[UnitName("party"..i)] then
					if (not v[UnitName("party"..i)].class) then
						_,classEng,_ = UnitClass("party"..i)
						if (classEng) then
							v[UnitName("party"..i)].class = strlower(classEng)
						end
					end
				end
			end
		end
	elseif UnitInRaid("player") then
		for i=1,40 do
			for _, v in pairs({DPSMateUser, DPSMateUserCurrent}) do
				if v[UnitName("raid"..i)] then
					if (not v[UnitName("raid"..i)].class) then
						_,classEng,_ = UnitClass("raid"..i)
						if (classEng) then
							v[UnitName("raid"..i)].class = strlower(classEng)
						end
					end
				end
			end
		end
	end
end

-- Duplicated at options?
function DPSMate.DB:PlayerInParty()
	if GetNumPartyMembers() > 0 and (not UnitInRaid("player")) then
		return true
	end
	return false
end

function DPSMate.DB:BuildUser(Dname, Dclass)
	if (not DPSMateUser[Dname]) then
		DPSMateUser[Dname] = {
			class = Dclass,
			damage = 0,
			damagetaken = 0,
			dmgTime = {},
			procs = {},
		}
	end
	if (not DPSMateUserCurrent[Dname]) then
		DPSMateUserCurrent[Dname] = {
			class = Dclass,
			damage = 0,
			damagetaken = 0,
			dmgTime = {},
			procs = {},
		}
	end
end

function DPSMate.DB:BuildUserAbility(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, Dtype)
	if (not Duser or Duser == {}) then return end -- Parsing failure, I guess at AEO periodic abilitys
	-- Total
	if DPSMate.DB:DataExist(Duser.name, Dname, DPSMateUser) then
		if Dtype == 0 then
			DPSMateUser[Duser.name].damage = DPSMateUser[Duser.name].damage + Damount
		elseif Dtype == 1 then
			DPSMateUser[Duser.name].damagetaken = DPSMateUser[Duser.name].damagetaken + Damount
		end
		DPSMateUser[Duser.name][Dname].hit = DPSMateUser[Duser.name][Dname].hit + Dhit
		DPSMateUser[Duser.name][Dname].crit = DPSMateUser[Duser.name][Dname].crit + Dcrit
		DPSMateUser[Duser.name][Dname].miss = DPSMateUser[Duser.name][Dname].miss + Dmiss
		DPSMateUser[Duser.name][Dname].parry = DPSMateUser[Duser.name][Dname].parry + Dparry
		DPSMateUser[Duser.name][Dname].dodge = DPSMateUser[Duser.name][Dname].dodge + Ddodge
		DPSMateUser[Duser.name][Dname].resist = DPSMateUser[Duser.name][Dname].resist + Dresist
		DPSMateUser[Duser.name][Dname].amount = DPSMateUser[Duser.name][Dname].amount + Damount
		if (Damount < DPSMateUser[Duser.name][Dname].hitlow or DPSMateUser[Duser.name][Dname].hitlow == 0) and Dhit == 1 then DPSMateUser[Duser.name][Dname].hitlow = Damount end
		if Damount > DPSMateUser[Duser.name][Dname].hithigh and Dhit == 1 then DPSMateUser[Duser.name][Dname].hithigh = Damount end
		if (Damount < DPSMateUser[Duser.name][Dname].critlow or DPSMateUser[Duser.name][Dname].critlow == 0) and Dcrit == 1 then DPSMateUser[Duser.name][Dname].critlow = Damount end
		if Damount > DPSMateUser[Duser.name][Dname].crithigh and Dcrit == 1 then DPSMateUser[Duser.name][Dname].crithigh = Damount end
	else
		if (not DPSMateUser[Duser.name])  then
			DPSMate.DB:BuildUser(Duser.name, Duser.class)
		end
		if Dtype == 0 then
			DPSMateUser[Duser.name].damage = DPSMateUser[Duser.name].damage + Damount
		elseif Dtype == 1 then
			DPSMateUser[Duser.name].damagetaken = DPSMateUser[Duser.name].damagetaken + Damount
		end
		DPSMateUser[Duser.name][Dname] = {
			hit = Dhit,
			hitlow = 0,
			hithigh = 0,
			crit = Dcrit,
			critlow = 0,
			crithigh = 0,
			miss = Dmiss,
			parry = Dparry,
			dodge = Ddodge,
			resist = Dresist,
			amount = Damount,
			type = Dtype,
		}
		if (Dhit == 1) then DPSMateUser[Duser.name][Dname].hitlow = Damount; DPSMateUser[Duser.name][Dname].hithigh = Damount end
		if (Dcrit == 1) then DPSMateUser[Duser.name][Dname].critlow = Damount; DPSMateUser[Duser.name][Dname].crithigh = Damount end
	end
	
	-- Current data
	if DPSMate.DB:DataExist(Duser.name, Dname, DPSMateUserCurrent) then
		if Dtype == 0 then
			DPSMateUserCurrent[Duser.name].damage = DPSMateUserCurrent[Duser.name].damage + Damount
		elseif Dtype == 1 then
			DPSMateUserCurrent[Duser.name].damagetaken = DPSMateUserCurrent[Duser.name].damagetaken + Damount
		end
		DPSMateUserCurrent[Duser.name][Dname].hit = DPSMateUserCurrent[Duser.name][Dname].hit + Dhit
		DPSMateUserCurrent[Duser.name][Dname].crit = DPSMateUserCurrent[Duser.name][Dname].crit + Dcrit
		DPSMateUserCurrent[Duser.name][Dname].miss = DPSMateUserCurrent[Duser.name][Dname].miss + Dmiss
		DPSMateUserCurrent[Duser.name][Dname].parry = DPSMateUserCurrent[Duser.name][Dname].parry + Dparry
		DPSMateUserCurrent[Duser.name][Dname].dodge = DPSMateUserCurrent[Duser.name][Dname].dodge + Ddodge
		DPSMateUserCurrent[Duser.name][Dname].resist = DPSMateUserCurrent[Duser.name][Dname].resist + Dresist
		DPSMateUserCurrent[Duser.name][Dname].amount = DPSMateUserCurrent[Duser.name][Dname].amount + Damount
		if (Damount < DPSMateUserCurrent[Duser.name][Dname].hitlow or DPSMateUserCurrent[Duser.name][Dname].hitlow == 0) and Dhit == 1 then DPSMateUserCurrent[Duser.name][Dname].hitlow = Damount end
		if Damount > DPSMateUserCurrent[Duser.name][Dname].hithigh and Dhit == 1 then DPSMateUserCurrent[Duser.name][Dname].hithigh = Damount end
		if (Damount < DPSMateUserCurrent[Duser.name][Dname].critlow or DPSMateUserCurrent[Duser.name][Dname].critlow == 0) and Dcrit == 1 then DPSMateUserCurrent[Duser.name][Dname].critlow = Damount end
		if Damount > DPSMateUserCurrent[Duser.name][Dname].crithigh and Dcrit == 1 then DPSMateUserCurrent[Duser.name][Dname].crithigh = Damount end
	else
		if (not DPSMateUserCurrent[Duser.name])  then
			DPSMate.DB:BuildUser(Duser.name, Duser.class)
		end
		if Dtype == 0 then
			DPSMateUserCurrent[Duser.name].damage = DPSMateUserCurrent[Duser.name].damage + Damount
		elseif Dtype == 1 then
			DPSMateUserCurrent[Duser.name].damagetaken = DPSMateUserCurrent[Duser.name].damagetaken + Damount
		end
		DPSMateUserCurrent[Duser.name][Dname] = {
			hit = Dhit,
			hitlow = 0,
			hithigh = 0,
			crit = Dcrit,
			critlow = 0,
			crithigh = 0,
			miss = Dmiss,
			parry = Dparry,
			dodge = Ddodge,
			resist = Dresist,
			amount = Damount,
			type = Dtype,
		}
		if (Dhit == 1) then DPSMateUserCurrent[Duser.name][Dname].hitlow = Damount; DPSMateUserCurrent[Duser.name][Dname].hithigh = Damount end
		if (Dcrit == 1) then DPSMateUserCurrent[Duser.name][Dname].critlow = Damount; DPSMateUserCurrent[Duser.name][Dname].crithigh = Damount end
	end
	DPSMateUser[Duser.name]["dmgTime"][DPSMateCombatTime["total"]] = Damount
	DPSMateUserCurrent[Duser.name]["dmgTime"][DPSMateCombatTime["current"]] = Damount
	DPSMate:SetStatusBarValue()
end

function DPSMate.DB:DataExist(uname, aname, arr)
	if arr[uname] ~= nil then
		if arr[uname][aname] ~= nil then
			return true
		end
	end
	return false
end

function DPSMate.DB:DataExistProcs(uname, aname, arr)
	if arr[uname] ~= nil then
		if arr[uname]["procs"][aname] ~= nil then
			return true
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
			DPSMateCombatTime["total"] = DPSMateCombatTime["total"] + arg1
			DPSMateCombatTime["current"] = DPSMateCombatTime["current"] + arg1
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

function DPSMate.DB:BuildUserProcs(Duser, Dname, Dbool)
	for cat, val in pairs({total=DPSMateUser, current=DPSMateUserCurrent}) do
		if DPSMate.DB:DataExistProcs(Duser.name, Dname, val) then
			local len = DPSMate:TableLength(val[Duser.name]["procs"][Dname]["start"])
			if val[Duser.name]["procs"][Dname]["start"][len] and not val[Duser.name]["procs"][Dname]["ending"][len] then
				val[Duser.name]["procs"][Dname]["ending"][len] = DPSMateCombatTime[cat]
			else
				val[Duser.name]["procs"][Dname]["start"][len+1] = DPSMateCombatTime[cat]
			end
		else
			if (not val[Duser.name])  then
				DPSMate.DB:BuildUser(Duser.name, Duser.class)
			end
			val[Duser.name]["procs"][Dname] = {
				start = {
					[1] = DPSMateCombatTime[cat],
				},
				ending = {},
				point = Dbool,
			}
		end
	end
end