-- Global Variables
DPSMate.DB.loaded = false

-- Local Variables
local lastCurReset = GetTime()

-- Begin Functions

function DPSMate.DB:OnEvent(event)
	if event == "ADDON_LOADED" and (not DPSMate.DB.loaded) then
		if DPSMateSettings == nil then
			DPSMateSettings = {
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
					},
					[3] = {
						lock = false,
					},
				},
			}
		end
		if DPSMateUser == nil then DPSMateUser = {} end
		if DPSMateUserCurrent == nil then DPSMateUserCurrent = {} end
		DPSMate:OnLoad()
		DPSMate.Options:ToggleDrewDrop(1, DPSMate.DB:GetOptionsTrue(1))
		DPSMate.Options:ToggleDrewDrop(2, DPSMate.DB:GetOptionsTrue(2))
		DPSMate.Options:ToggleDrewDrop(3, DPSMateSettings["options"][3]["lock"])
		DPSMate.DB.loaded = true
	elseif event == "PLAYER_REGEN_DISABLED" and (lastCurReset+5 < GetTime()) then
		DPSMateUserCurrent = {}
		DPSMate:SetStatusBarValue()
		lastCurReset = GetTime()
	end
end

function DPSMate.DB:BuildUser(Dname, Dclass)
	if (not DPSMateUser[Dname]) then
		DPSMateUser[Dname] = {
			class = Dclass,
			damage = 0,
			damagetaken = 0,
		}
	end
	if (not DPSMateUserCurrent[Dname]) then
		DPSMateUserCurrent[Dname] = {
			class = Dclass,
			damage = 0,
			damagetaken = 0,
		}
	end
end

function DPSMate.DB:BuildUserAbility(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, Dtype)
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
		if Damount < DPSMateUser[Duser.name][Dname].hitlow and Dhit == 1 then DPSMateUser[Duser.name][Dname].hitlow = Damount end
		if Damount > DPSMateUser[Duser.name][Dname].hithigh and Dhit == 1 then DPSMateUser[Duser.name][Dname].hithigh = Damount end
		if Damount < DPSMateUser[Duser.name][Dname].critlow and Dcrit == 1 then DPSMateUser[Duser.name][Dname].critlow = Damount end
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
			hitlow = Damount,
			hithigh = Damount,
			crit = Dcrit,
			critlow = Damount,
			crithigh = Damount,
			miss = Dmiss,
			parry = Dparry,
			dodge = Ddodge,
			resist = Dresist,
			amount = Damount,
			type = Dtype,
		}
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
		if Damount < DPSMateUserCurrent[Duser.name][Dname].hitlow and Dhit == 1 then DPSMateUserCurrent[Duser.name][Dname].hitlow = Damount end
		if Damount > DPSMateUserCurrent[Duser.name][Dname].hithigh and Dhit == 1 then DPSMateUserCurrent[Duser.name][Dname].hithigh = Damount end
		if Damount < DPSMateUserCurrent[Duser.name][Dname].critlow and Dcrit == 1 then DPSMateUserCurrent[Duser.name][Dname].critlow = Damount end
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
			hitlow = Damount,
			hithigh = Damount,
			crit = Dcrit,
			critlow = Damount,
			crithigh = Damount,
			miss = Dmiss,
			parry = Dparry,
			dodge = Ddodge,
			resist = Dresist,
			amount = Damount,
			type = Dtype,
		}
	end
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

function DPSMate.DB:GetOptionsTrue(i)
	for cat,val in pairs(DPSMateSettings["options"][i]) do
		if val == true then
			return cat
		end
	end
end