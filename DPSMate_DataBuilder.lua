-- Global Variables

-- Local Variables
local CLASSTEXTURE = {}
CLASSTEXTURE["WARRIOR"] = ""
CLASSTEXTURE["PRIEST"] = ""
CLASSTEXTURE["ROGUE"] = ""
CLASSTEXTURE["MAGE"] = ""
CLASSTEXTURE["WARLOCK"] = ""
CLASSTEXTURE["HUNTER"] = ""
CLASSTEXTURE["PALADIN"] = ""
CLASSTEXTURE["SHAMAN"] = ""
CLASSTEXTURE["DRUID"] = ""

-- Begin Functions

function DPSMate.DB:OnEvent(event)
	if event == "ADDON_LOADED" then
		if DPSMateUser == nil then DPSMateUser = {} end
	end
end

function DPSMate.DB:BuildUser(Dname, Dclass, Dlevel, Dguild)
	if (not DPSMateUser[Dname]) then
		DPSMateUser[Dname] = {
			class = Dclass,
			classTex = CLASSTEXTURE[Dclass],
		}
	end
end

function DPSMate.DB:BuildUserAbility(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount)
	if DPSMate.DB:DataExist(Duser.name, Dname) then
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
		if (not DPSMateUser[Duser.name]) then
			DPSMate.DB:BuildUser(Duser.name, Duser.class)
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
		}
	end
end

function DPSMate.DB:DataExist(uname, aname)
	if DPSMateUser[uname] ~= nil then
		if DPSMateUser[uname][aname] ~= nil then
			return true
		end
	end
	return false
end