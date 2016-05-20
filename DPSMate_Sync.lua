-- Global Variables
DPSMate.Sync.Async = false
DPSMate.Sync.LU = 0

-- Local Variables
local player = UnitName("player")
local _, playerclass = UnitClass("player")
local pid = 0
local time, iterator, voteStarter = 0, 1, false
local t = {}
local strgsub = string.gsub
local tinsert = table.insert
local tremove = table.remove
local func = function(c) tinsert(t,c) end
local LastMouseover = nil
local DB = DPSMate.DB
local Buffer = {}
local Arrays = {
	[1] = {}, -- Damage
	[2] = {}, -- Damage Taken
	[3] = {}, -- EDD
	[4] = {}, -- EDT
	[5] = {}, -- Healing done
	[6] = {}, -- E Healing done
	[7] = {}, -- Healing taken
	[8] = {}, -- E Healing taken
	[9] = {}, -- Overhealing done
	[10] = {}, -- Absorbs
	[11] = {}, -- Deaths
	[12] = {}, -- Interrupts
	[13] = {}, -- Dispels
	[14] = {} -- Auras
}

-- Beginn Functions

function DPSMate.Sync:OnLoad()
	if (not DPSMateUser[player]) then
		DPSMateUser[player] = {
			[1] = DPSMate:TableLength(DPSMateUser)+1,
			[2] = strlower(playerclass),
		}
	end
	pid = DPSMateUser[player][1]
end

local co, cou = 1, 1
function DPSMate.Sync:SendAddonMessages(elapsed)
	if DPSMateSettings["sync"] then
		self.LU = self.LU + elapsed
		if self.LU > 1.1 then
			for i=1, 80 do
				--SendAddonMessage("Test"..co, "Test"..co, "RAID")
				if not Buffer[co] then break end
				SendAddonMessage(Buffer[co][1], Buffer[co][2], "RAID")
				Buffer[co] = nil
				co = co + 1
			end
			--DPSMate:SendMessage(co)
			--co = co + 1
			self.LU = 0
		end
	end
end

function DPSMate.Sync:OnUpdate(elapsed)
	if DB.loaded and DPSMateSettings["sync"] then
		time=time+elapsed
		if iterator==1 then
			Buffer[cou] = {"DPSMate_SyncStatus", "1"}
			cou = cou + 1
			self:DMGDoneAllOut()
			self:DMGDoneAbilityOut()
			self:DMGDoneStatOut()
			iterator = 2
		elseif time>=3 and iterator==2 then
			self:HealingAllOut(DPSMateEHealing, "E")
			self:HealingAbilityOut(DPSMateEHealing, "E")
			self:HealingStatOut(DPSMateEHealing, "E")
			self:AbsorbsOut() 
			self:AbsorbsStatOut()
			iterator = 3
		elseif time>=6 and iterator==3 then
			self:AurasOut()
			self:DeathsAllOut()
			self:DeathsOut()
			self:DispelsOut()
			iterator = 4
		elseif time>=9 and iterator==4 then
			self:EDAllOut(DPSMateEDD, "D")
			self:EDAbilityOut(DPSMateEDD, "D")
			self:EDStatOut(DPSMateEDD, "D")
			iterator = 5
		elseif time>=12 and iterator==5 then
			self:HealingAllOut(DPSMateTHealing, "T")
			self:HealingAbilityOut(DPSMateTHealing, "T")
			self:HealingStatOut(DPSMateTHealing, "T")
			self:InterruptsAllOut()
			self:InterruptsAbilityOut()
			iterator = 6
		elseif time>=15 and iterator==6 then
			self:DMGTakenAllOut()
			self:DMGTakenAbilityOut()
			self:DMGTakenStatOut()
			iterator = 7
		elseif time>=18 and iterator==7 then
			self:HealingAllOut(DPSMateEHealingTaken, "ETaken")
			self:HealingTakenAbilityOut(DPSMateEHealingTaken, "E")
			self:HealingStatOut(DPSMateEHealingTaken, "ETaken")
			iterator = 8
		elseif time>=21 and iterator==8 then
			self:HealingAllOut(DPSMateOverhealing, "O")
			self:HealingAbilityOut(DPSMateOverhealing, "O")
			self:HealingStatOut(DPSMateOverhealing, "O")
			iterator = 9
		elseif time>=24 and iterator==9 then
			self:HealingAllOut(DPSMateHealingTaken, "TTaken")
			self:HealingTakenAbilityOut(DPSMateHealingTaken, "T")
			self:HealingStatOut(DPSMateHealingTaken, "TTaken")
			iterator = 10
		elseif time>=27 and iterator==10 then
			self:EDAllOut(DPSMateEDT, "T")
			self:EDStatOut(DPSMateEDT, "T")
			self:EDAbilityOut(DPSMateEDT, "T")
			Buffer[cou] = {"DPSMate_SyncStatus", "0"}
			cou = cou + 1
			self.Async, iterator, time = false, 1, 0
		end
	else
		self.Async, iterator, time = false, 1, 0
	end
end

----------------------------------------------------------------------------------
--------------                       GENERAL                        --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:GetSummarizedTable(arr)
	local newArr, i, dmg, time, dis = {}, 1, 0, nil, 1
	local TL = DPSMate:TableLength(arr)
	if TL>100 then dis = floor(TL/100) end
	for cat, val in arr do
		if dis>1 then
			dmg=dmg+val[2]
			if time then
				if i>dis and (val[1]-time)>0 then
					tinsert(newArr, {(val[1]+time)/2, dmg/(val[1]-time)}) -- last time val // subtracting from each other to get the time in which the damage is being done
					time, dmg, i = nil, 0, 1
				end
			else
				time=val[1]
			end
		else
			tinsert(newArr, val)
		end
		i=i+1
	end
	return newArr
end

function DPSMate.Sync:Vote()
	DPSMate_Vote:Hide()
	SendAddonMessage("DPSMate_Vote", nil, "RAID")
end

function DPSMate.Sync:StartVote()
	if not voteStarter then
		SendAddonMessage("DPSMate_StartVote", nil, "RAID")
		voteStarter = true
	else
		DPSMate:SendMessage("Vote has already been started!")
	end
end

local voteCount = 1
local participants = 1
function DPSMate.Sync:CountVote()
	if voteStarter then
		voteCount=voteCount+1
		if voteCount >= (participants/2) then
			SendAddonMessage("DPSMate_VoteSuccess", nil, "RAID")
			voteStarter = false
			voteCount = 1
			participants = 1
			local num = GetNumRaidMembers()
			if num > 0 then
				for i=1, num-1 do
					SendAddonMessage("DPSMate_SyncTimer", UnitName("raid"..i)..","..(ceil(i/8)*30 - 30)..",", "RAID")
				end
			end
			DB.MainUpdate = ceil(num/8)*30 - 30
			self:VoteSuccess()
		end
	end
end

local voteTime = 0
function DPSMate.Sync:DismissVote(elapsed)
	if voteStarter then
		voteTime=voteTime+elapsed
		if voteTime>=30 then
			SendAddonMessage("DPSMate_VoteFail", nil, "RAID")
			voteStarter = false
			voteCount = 1
			voteTime = 0
			participants = 1
			DPSMate:SendMessage("Reset vote failed!")
		elseif voteTime>=3 and participants==1 then
			voteStarter = false
			voteCount = 1
			voteTime = 0
			self:VoteSuccess()
		end
	end
end

function DPSMate.Sync:VoteSuccess()
	DPSMate:SendMessage("Reset vote was successful! DPSMate has been reset!")
	DPSMate.Options:PopUpAccept(true, true)
end

function DPSMate.Sync:SetTimer(arg2)
	t = {}
	strgsub(arg2, "(.-),", func)
	if t[1] == player then
		DB.MainUpdate = tonumber(t[2])
	end
end

function DPSMate.Sync:CountParticipants()
	if voteStarter then
		participants=participants+1
	end
end

function DPSMate.Sync:Participate()
	SendAddonMessage("DPSMate_Participate", nil, "RAID")
end

function DPSMate.Sync:ReceiveStartVote() 
	self:Participate()
	if DPSMateSettings["dataresetssync"] == 3 then
		DPSMate_Vote:Show()
	elseif DPSMateSettings["dataresetssync"] == 1 then
		self:Vote()
	end
end

local bc, am = false, 1
function DPSMate.Sync:HelloWorld()
	bc = true
	am = 1
	SendAddonMessage("DPSMate_HelloWorld", "NaN", "RAID")
end

function DPSMate.Sync:GreetBack()
	SendAddonMessage("DPSMate_Greet", DPSMate.VERSION, "RAID")
end

function DPSMate.Sync:ReceiveGreet(arg2, arg4)
	if bc then
		DPSMate:SendMessage(am..". "..arg4.." (v"..arg2..")")
		am = am + 1
	end
end

----------------------------------------------------------------------------------
--------------                       SYNC IN                        --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:OnEvent(event)
	if event == "CHAT_MSG_ADDON" then
		if DPSMateSettings["sync"] and DB.loaded then
			if arg4 == player then return end 
			if self.Exec[arg1] then
				self.Exec[arg1](arg2,arg4)
			end
		end
	elseif event == "UPDATE_MOUSEOVER_UNIT" then
		LastMouseover = UnitName("mouseover")
	end
end

function DPSMate.Sync:SyncStatus(arg2, arg4) 
	if arg2 == "0" then
		local usid = DPSMateUser[arg4][1]
		if Arrays[1][usid] then DPSMateDamageDone[1][usid] = Arrays[1][usid] end
		if Arrays[2][usid] then DPSMateDamageTaken[1][usid] = Arrays[2][usid] end
		for cat, val in Arrays[3] do
			if val[usid] then
				if not DPSMateEDD[1][cat] then DPSMateEDD[1][cat] = {} end
				DPSMateEDD[1][cat][usid] = val[usid]
			end
		end
		for cat, val in Arrays[4] do
			if val[usid] then
				if not DPSMateEDT[1][cat] then DPSMateEDT[1][cat] = {} end
				DPSMateEDT[1][cat][usid] = val[usid]
			end
		end
		if Arrays[5][usid] then DPSMateTHealing[1][usid] = Arrays[5][usid] end
		if Arrays[6][usid] then DPSMateEHealing[1][usid] = Arrays[6][usid] end
		if Arrays[7][usid] then DPSMateHealingTaken[1][usid] = Arrays[7][usid] end
		if Arrays[8][usid] then DPSMateEHealingTaken[1][usid] = Arrays[8][usid] end
		if Arrays[9][usid] then DPSMateOverhealing[1][usid] = Arrays[9][usid] end
		if Arrays[10][usid] then DPSMateAbsorbs[1][usid] = Arrays[10][usid] end
		if Arrays[11][usid] then DPSMateDeaths[1][usid] = Arrays[11][usid] end
		if Arrays[12][usid] then DPSMateInterrupts[1][usid] = Arrays[12][usid] end
		if Arrays[13][usid] then DPSMateDispels[1][usid] = Arrays[13][usid] end
		if Arrays[14][usid] then DPSMateAurasGained[1][usid] = Arrays[14][usid] end
		DB.NeedUpdate = true
	else
		DB:BuildUser(arg4, nil)
		local usid = DPSMateUser[arg4][1]
		for i=1, 14 do
			Arrays[i][usid] = nil
		end
	end
end

----------------------------------------------------------------------------------
--------------                    DAMAGE DONE                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DMGDoneAllIn(arg2, arg4)
	local userid = DPSMateUser[arg4][1]
	t = {}
	strgsub(arg2, "(.-),", func)
	Arrays[1][userid] = {
		i = {
			[1] = {},
			[2] = tonumber(t[1]),
		},
	}
end

function DPSMate.Sync:DMGDoneStatIn(arg2, arg4)
	local userid = DPSMateUser[arg4][1]
	t = {}
	strgsub(arg2, "(.-),", func)
	t[1] = tonumber(t[1])
	if not Arrays[1][userid] then return end
	tinsert(Arrays[1][userid]["i"][1], {t[1], tonumber(t[2])})
	if t[1]>DPSMateCombatTime["total"] then DPSMateCombatTime["total"]=t[1] end
end

function DPSMate.Sync:DMGDoneAbilityIn(arg2, arg4)
	local userid = DPSMateUser[arg4][1]
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildAbility(t[1], nil)
	if not Arrays[1][userid] then return end
	Arrays[1][userid][DPSMateAbility[t[1]][1]] = {
		[1] = tonumber(t[2]),
		[2] = tonumber(t[3]),
		[3] = tonumber(t[4]),
		[4] = tonumber(t[5]),
		[5] = tonumber(t[6]),
		[6] = tonumber(t[7]),
		[7] = tonumber(t[8]),
		[8] = tonumber(t[9]),
		[9] = tonumber(t[10]),
		[10] = tonumber(t[11]),
		[11] = tonumber(t[12]),
		[12] = tonumber(t[13]),
		[13] = tonumber(t[14]),
		[14] = tonumber(t[15]),
		[15] = tonumber(t[16]),
		[16] = tonumber(t[17]),
		[17] = tonumber(t[18]),
		[18] = tonumber(t[19]),
		[19] = tonumber(t[20]),
		[20] = tonumber(t[21]),
		[21] = tonumber(t[22]),
	}
end

----------------------------------------------------------------------------------
--------------                    DAMAGE TAKEN                      --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DMGTakenAllIn(arg2, arg4)
	local userid = DPSMateUser[arg4][1]
	t = {}
	strgsub(arg2, "(.-),", func)
	Arrays[2][userid] = {
		i = {
			[1] = {},
			[2] = tonumber(t[1]),
		},
	}
end

function DPSMate.Sync:DMGTakenStatIn(arg2, arg4)
	local userid = DPSMateUser[arg4][1]
	t = {}
	strgsub(arg2, "(.-),", func)
	if not Arrays[2][userid] then return end
	t[1] = tonumber(t[1])
	tinsert(Arrays[2][userid]["i"][1], {t[1], tonumber(t[2])})
	if t[1]>DPSMateCombatTime["total"] then DPSMateCombatTime["total"]=t[1] end
end

function DPSMate.Sync:DMGTakenAbilityIn(arg2, arg4)
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildUser(t[1], nil)
	DB:BuildAbility(t[2], nil)
	local userid, userid2 = DPSMateUser[arg4][1], DPSMateUser[t[1]][1]
	if not Arrays[2][userid] then return end
	if not Arrays[2][userid][userid2] then
		Arrays[2][userid][userid2] = {}
	end
	Arrays[2][userid][userid2][DPSMateAbility[t[2]][1]] = {
		[1] = tonumber(t[3]),
		[2] = tonumber(t[4]),
		[3] = tonumber(t[5]),
		[4] = tonumber(t[6]),
		[5] = tonumber(t[7]),
		[6] = tonumber(t[8]),
		[7] = tonumber(t[9]),
		[8] = tonumber(t[10]),
		[9] = tonumber(t[11]),
		[10] = tonumber(t[12]),
		[11] = tonumber(t[13]),
		[12] = tonumber(t[14]),
		[13] = tonumber(t[15]),
		[14] = tonumber(t[16]),
		[15] = tonumber(t[17]),
		[16] = tonumber(t[18]),
		[17] = tonumber(t[19]),
		[18] = tonumber(t[20]),
	}
end

----------------------------------------------------------------------------------
--------------                 ENEMY DAMAGE TAKEN                   --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:EDAllIn(arr, arg2, arg4)
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildUser(t[1], nil)
	local userid = DPSMateUser[t[1]][1]
	if not Arrays[arr][userid] then
		Arrays[arr][userid] = {}
	end
	Arrays[arr][userid][DPSMateUser[arg4][1]] = {
		i = {
			[1] = {},
			[2] = tonumber(t[2]),
		},
	}
end

function DPSMate.Sync:EDStatIn(arr, arg2, arg4)
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildUser(t[1], nil)
	local userid, userid2 = DPSMateUser[t[1]][1], DPSMateUser[arg4][1]
	if not Arrays[arr][userid] then return end
	if not Arrays[arr][userid][userid2] then return end
	t[2] = tonumber(t[2])
	tinsert(Arrays[arr][userid][userid2]["i"][1], {t[2], tonumber(t[3])}) -- attempt to index a nil value
	if t[2]>DPSMateCombatTime["total"] then DPSMateCombatTime["total"]=t[2] end
end

function DPSMate.Sync:EDAbilityIn(arr, arg2, arg4)
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildUser(t[1], nil)
	DB:BuildAbility(t[2], nil)
	local userid, userid2 = DPSMateUser[t[1]][1], DPSMateUser[arg4][1]
	if not Arrays[arr][userid] then return end
	if not Arrays[arr][userid][userid2] then return end
	Arrays[arr][userid][userid2][DPSMateAbility[t[2]][1]] = {
		[1] = tonumber(t[3]),
		[2] = tonumber(t[4]),
		[3] = tonumber(t[5]),
		[4] = tonumber(t[6]),
		[5] = tonumber(t[7]),
		[6] = tonumber(t[8]),
		[7] = tonumber(t[9]),
		[8] = tonumber(t[10]),
		[9] = tonumber(t[11]),
		[10] = tonumber(t[12]),
		[11] = tonumber(t[13]),
		[12] = tonumber(t[14]),
		[13] = tonumber(t[15]),
		[14] = tonumber(t[16]),
		[15] = tonumber(t[17]),
		[16] = tonumber(t[18]),
		[17] = tonumber(t[19]),
		[18] = tonumber(t[20]),
		[19] = tonumber(t[21]),
		[20] = tonumber(t[22]),
		[21] = tonumber(t[23]),
	}
end

----------------------------------------------------------------------------------
--------------                        Healing                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:HealingAllIn(arg2, arg4, arr)
	local userid = DPSMateUser[arg4][1]
	t = {}
	strgsub(arg2, "(.-),", func)
	Arrays[arr][userid] = {
		i = {
			[1] = tonumber(t[2]),
			[2] = {},
		},
	}
end

function DPSMate.Sync:HealingStatIn(arg2, arg4, arr)
	local userid = DPSMateUser[arg4][1]
	t = {}
	strgsub(arg2, "(.-),", func)
	t[1] = tonumber(t[1])
	if not Arrays[arr][userid] then return end
	tinsert(Arrays[arr][userid]["i"][2], {t[1], tonumber(t[2])})
	if t[1]>DPSMateCombatTime["total"] then DPSMateCombatTime["total"]=t[1] end
end

function DPSMate.Sync:HealingAbilityIn(arg2, arg4, arr)
	local userid = DPSMateUser[arg4][1]
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildAbility(t[1], nil)
	if not Arrays[arr][userid] then return end
	Arrays[arr][userid][DPSMateAbility[t[1]][1]] = {
		[1] = tonumber(t[2]),
		[2] = tonumber(t[3]),
		[3] = tonumber(t[4]),
		[4] = tonumber(t[5]),
		[5] = tonumber(t[6]),
		[6] = tonumber(t[7]),
		[7] = tonumber(t[8]),
		[8] = tonumber(t[9]),
		[9] = tonumber(t[10]),
	}
end

----------------------------------------------------------------------------------
--------------                    Healing taken                     --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:HealingTakenAbilityIn(arg2, arg4, arr)
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildUser(t[1], nil)
	DB:BuildAbility(t[2], nil)
	local userid, userid2 = DPSMateUser[arg4][1], DPSMateUser[t[1]][1]
	if not Arrays[arr][userid] then return end
	if not Arrays[arr][userid][userid2] then
		Arrays[arr][userid][userid2] = {}
	end
	Arrays[arr][userid][userid2][DPSMateAbility[t[2]][1]] = {
		[1] = tonumber(t[3]),
		[2] = tonumber(t[4]),
		[3] = tonumber(t[5]),
		[4] = tonumber(t[6]),
		[5] = tonumber(t[7]),
		[6] = tonumber(t[8]),
		[7] = tonumber(t[9]),
		[8] = tonumber(t[10]),
		[9] = tonumber(t[11]),
	}
end

----------------------------------------------------------------------------------
--------------                        Absorbs                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:iAbsorbsIn(arg2, arg4) 
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildUser(t[1], nil)
	DB:BuildAbility(t[2], nil)
	local userid, userid2, userid3 = DPSMateUser[arg4][1], DPSMateUser[t[1]][1], DPSMateAbility[t[2]][1]
	if not Arrays[10][userid] then
		Arrays[10][userid] = {}
	end
	if not Arrays[10][userid][userid2] then
		Arrays[10][userid][userid2] = {
			i = {},
		}
	end
	if not Arrays[10][userid][userid2][userid3] then
		Arrays[10][userid][userid2][userid3] = {}
	end
	Arrays[10][userid][userid2][userid3][tonumber(t[3])] = {
		i = {
			[1] = tonumber(t[4]),
			[2] = tonumber(t[5]),
			[3] = tonumber(t[6]),
			[4] = tonumber(t[7]),
		},
	}
end

function DPSMate.Sync:AbsorbsStatIn(arg2, arg4)
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildUser(t[1], nil)
	local userid, userid2 = DPSMateUser[arg4][1], DPSMateUser[t[1]][1]
	if not DPSMateAbsorbs[1][DPSMateUser[arg4][1]] then return end
	if not DPSMateAbsorbs[1][DPSMateUser[arg4][1]][DPSMateUser[t[1]][1]] then return end
	t[2] = tonumber(t[2])
	if t[4] then
		tinsert(Arrays[10][userid][userid2]["i"], {t[2], tonumber(t[3]), tonumber(t[4]), tonumber(t[5])})
	else
		tinsert(Arrays[10][userid][userid2]["i"], {t[2], tonumber(t[3]), tonumber(t[4])})
	end
	if t[1]>DPSMateCombatTime["total"] then DPSMateCombatTime["total"]=t[1] end
end

function DPSMate.Sync:AbsorbsIn(arg2, arg4) 
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildUser(t[1], nil)
	DB:BuildUser(t[4], nil)
	DB:BuildAbility(t[2], nil)
	local userid, userid2, userid3 = DPSMateUser[arg4][1], DPSMateUser[t[1]][1], DPSMateAbility[t[2]][1]
	if not Arrays[10][userid] then return end
	if not Arrays[10][userid][userid2] then return end
	if not Arrays[10][userid][userid2][userid3] then Arrays[10][userid][userid2][userid3] = {} end
	if not Arrays[10][userid][userid2][userid3][tonumber(t[3])] then Arrays[10][userid][userid2][userid3][tonumber(t[3])] = {} end
	Arrays[10][userid][userid2][userid3][tonumber(t[3])][DPSMateUser[t[4]][1]] = {
		[1] = tonumber(t[5]),
		[2] = tonumber(t[6]),
	}
	DB.NeedUpdate = true
end

----------------------------------------------------------------------------------
--------------                        Deaths                        --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DeathsAllIn(arg2, arg4) 
	t = {}
	strgsub(arg2, "(.-),", func)
	local userid = DPSMateUser[arg4][1]
	if not Arrays[11][userid] then
		Arrays[11][userid] = {}
	end
	Arrays[11][userid][tonumber(t[2])] = {
		i = {
			[1] = tonumber(t[3]),
			[2] = t[4],
		},
	}
end

function DPSMate.Sync:DeathsIn(arg2, arg4)
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildUser(arg4, nil)
	DB:BuildUser(t[3], nil)
	DB:BuildAbility(t[4], nil)
	t[1] = tonumber(t[1])
	local userid = DPSMateUser[arg4][1]
	if not Arrays[11][userid] then return end
	if not Arrays[11][userid][t[1]] then return end
	Arrays[11][userid][t[1]][tonumber(t[2])] = {
		[1] = DPSMateUser[t[3]][1],
		[2] = DPSMateAbility[t[4]][1],
		[3] = tonumber(t[5]),
		[4] = tonumber(t[6]),
		[5] = tonumber(t[7]),
		[6] = tonumber(t[8]),
		[7] = t[9],
	}
end

----------------------------------------------------------------------------------
--------------                     Interrupts                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:InterruptsAllIn(arg2, arg4)
	t = {}
	strgsub(arg2, "(.-),", func)
	Arrays[12][DPSMateUser[arg4][1]] = {
		i = tonumber(t[2]),
	}
end

function DPSMate.Sync:InterruptsAbilityIn(arg2, arg4)
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildUser(t[2], nil)
	DB:BuildAbility(t[1], nil)
	DB:BuildAbility(t[3], nil)
	local userid, userid2, userid3 = DPSMateUser[arg4][1], DPSMateAbility[t[1]][1], DPSMateUser[t[2]][1]-- not really userids
	if not Arrays[12][userid] then return end
	if not Arrays[12][userid][userid2] then
		Arrays[12][userid][userid2] = {}
	end
	if not Arrays[12][userid][userid2][userid3] then
		Arrays[12][userid][userid2][userid3] = {}
	end
	Arrays[12][userid][userid2][userid3][DPSMateAbility[t[3]][1]] = tonumber(t[4])
end

----------------------------------------------------------------------------------
--------------                        Dispels                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:iDispelsIn(arg2, arg4)
	t = {}
	strgsub(arg2, "(.-),", func)
	if not Arrays[13][DPSMateUser[arg4][1]] then Arrays[13][DPSMateUser[arg4][1]] = {i={[1]=0,[2]={}}} end
	Arrays[13][DPSMateUser[arg4][1]]["i"][1] = tonumber(arg2);
end

function DPSMate.Sync:DispelsIn(arg2, arg4)
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildUser(t[2], nil)
	DB:BuildAbility(t[1], nil)
	DB:BuildAbility(t[3], nil)
	local userid, userid2, userid3 = DPSMateUser[arg4][1], DPSMateAbility[t[1]][1], DPSMateUser[t[2]][1] -- not really userids
	if not Arrays[13][userid] then Arrays[13][DPSMateUser[arg4][1]] = {i={[1]=0,[2]={}}} end
	if not Arrays[13][userid][userid2] then
		Arrays[13][userid][userid2] = {}
	end
	if not Arrays[13][userid][userid2][userid3] then
		Arrays[13][userid][userid2][userid3] = {}
	end
	Arrays[13][userid][userid2][userid3][DPSMateAbility[t[3]][1]] = tonumber(t[4])
end

----------------------------------------------------------------------------------
--------------                        Auras                         --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:AurasAllIn(arg2, arg4)
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildAbility(t[1], nil)
	local userid, userid2 = DPSMateUser[arg4][1], DPSMateAbility[t[1]][1] -- not really userids
	if not Arrays[14][userid] then
		Arrays[14][userid] = {}
	end
	Arrays[14][userid][userid2] = {
		[1] = {},
		[2] = {},
		[3] = {},
		[4] = false,
	}
	if t[2]=="1" then
		Arrays[14][userid][userid2][4] = true
	end
end

function DPSMate.Sync:AurasStartEndIn(arg2, arg4, prefix)
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildAbility(t[1], nil)
	if not Arrays[14][DPSMateUser[arg4][1]] then return end
	if not Arrays[14][DPSMateUser[arg4][1]][DPSMateAbility[t[1]][1]] then return end
	Arrays[14][DPSMateUser[arg4][1]][DPSMateAbility[t[1]][1]][prefix][tonumber(t[2])] = tonumber(t[3])
end

function DPSMate.Sync:AurasCauseIn(arg2, arg4)
	t = {}
	strgsub(arg2, "(.-),", func)
	DB:BuildUser(t[2], nil)
	DB:BuildAbility(t[1], nil)
	if not Arrays[14][DPSMateUser[arg4][1]] then return end
	if not Arrays[14][DPSMateUser[arg4][1]][DPSMateAbility[t[1]][1]] then return end
	Arrays[14][DPSMateUser[arg4][1]][DPSMateAbility[t[1]][1]][3][DPSMateUser[t[2]][1]] = tonumber(t[3])
end

----------------------------------------------------------------------------------
--------------                       SYNC OUT                       --------------                                  
----------------------------------------------------------------------------------

-- Hooking useaction function in order to get the owner of the spell.
local oldUseAction = UseAction
DPSMate.Parser.UseAction = function(slot, checkCursor, onSelf)
	oldUseAction(slot, checkCursor, onSelf)
	DPSMate_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	DPSMate_Tooltip:ClearLines()
	DPSMate_Tooltip:SetAction(slot)
	local aura = DPSMate_TooltipTextLeft1:GetText()
	DPSMate_Tooltip:Hide()
	if aura then
		local target, time = UnitName("target"), GetTime()
		if not target then target = LastMouseover end
		--if target and DPSMateSettings["sync"] then SendAddonMessage("DPSMate", aura..","..target..",", "RAID");DPSMate:SendMessage("Test") end
		if DPSMate:TContains(DPSMate.Parser.Kicks, ability) then DB:AwaitAfflictedStun(player, aura, target, time) end
		DB:AwaitingBuff(player, aura, target, time)
		DB:AwaitingAbsorbConfirmation(player, aura, target, time)
	end
end
UseAction = DPSMate.Parser.UseAction

-- Hooking CastSpellByName function in order to get the owner of the spell.
local oldCastSpellByName = CastSpellByName
DPSMate.Parser.CastSpellByName = function(spellName, onSelf)
	oldCastSpellByName(spellName, onSelf)
	local target, time = UnitName("target"), GetTime()
	if not target then target = LastMouseover end
	--if target and DPSMateSettings["sync"] then SendAddonMessage("DPSMate", spellName..","..target..",", "RAID");DPSMate:SendMessage("Test") end
	if DPSMate:TContains(DPSMate.Parser.Kicks, ability) then DB:AwaitAfflictedStun(player, spellName, target, time) end
	DB:AwaitingBuff(player, spellName, target, time)
	DB:AwaitingAbsorbConfirmation(player, spellName, target, time)
end
CastSpellByName = DPSMate.Parser.CastSpellByName

-- Hooking CastSpell function in order to get the owner of the spell.
local oldCastSpell = CastSpell
DPSMate.Parser.CastSpell = function(spellID, spellbookType)
	oldCastSpell(spellID, spellbookType)
	local spellName, spellRank = GetSpellName(spellID, spellbookType)
	local target, time = UnitName("target"), GetTime()
	if not target then target = LastMouseover end
	--if target and DPSMateSettings["sync"] then SendAddonMessage("DPSMate", spellName..","..target..",", "RAID");DPSMate:SendMessage("Test") end
	if DPSMate:TContains(DPSMate.Parser.Kicks, ability) then DB:AwaitAfflictedStun(player, spellName, target, time) end
	DB:AwaitingBuff(player, spellName, target, time)
	DB:AwaitingAbsorbConfirmation(player, spellName, target, time)
end
CastSpell = DPSMate.Parser.CastSpell

----------------------------------------------------------------------------------
--------------                     DAMAGE DONE                      --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DMGDoneAllOut()
	if DPSMateDamageDone[1][pid] then
		Buffer[cou] = {"DPSMate_DMGDoneAll", DPSMateDamageDone[1][pid]["i"][2]..","}
		cou = cou + 1
		--SendAddonMessage("DPSMate_DMGDoneAll", playerclass..","..DPSMateDamageDone[1][pid]["i"][2]..",", "RAID")
	end
end

function DPSMate.Sync:DMGDoneStatOut()
	if not DPSMateDamageDone[1][pid] then return end
	for cat, val in self:GetSummarizedTable(DPSMateDamageDone[1][pid]["i"][1]) do
		Buffer[cou] = {"DPSMate_DMGDoneStat", val[1]..","..val[2]..","}
		cou = cou + 1
		--SendAddonMessage("DPSMate_DMGDoneStat", val[1]..","..val[2]..",", "RAID")
	end
end

function DPSMate.Sync:DMGDoneAbilityOut()
	if not DPSMateDamageDone[1][pid] then return end
	for cat, val in (DPSMateDamageDone[1][pid]) do
		if cat~="i" then
			Buffer[cou] = {"DPSMate_DMGDoneAbility", DPSMate:GetAbilityById(cat)..","..val[1]..","..val[2]..","..val[3]..","..ceil(val[4])..","..val[5]..","..val[6]..","..val[7]..","..ceil(val[8])..","..val[9]..","..val[10]..","..val[11]..","..val[12]..","..val[13]..","..val[14]..","..val[15]..","..val[16]..","..ceil(val[17])..","..val[18]..","..val[19]..","..val[20]..","..ceil(val[21])..","}
			cou = cou + 1
			--SendAddonMessage("DPSMate_DMGDoneAbility", DPSMate:GetAbilityById(cat)..","..val[1]..","..val[2]..","..val[3]..","..ceil(val[4])..","..val[5]..","..val[6]..","..val[7]..","..ceil(val[8])..","..val[9]..","..val[10]..","..val[11]..","..val[12]..","..val[13]..","..val[14]..","..val[15]..","..val[16]..","..ceil(val[17])..","..val[18]..","..val[19]..","..val[20]..","..ceil(val[21])..",", "RAID")
		end
	end
end

----------------------------------------------------------------------------------
--------------                    DAMAGE TAKEN                      --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DMGTakenAllOut()
	if DPSMateDamageTaken[1][pid] then
		Buffer[cou] = {"DPSMate_DMGTakenAll", DPSMateDamageTaken[1][pid]["i"][2]..","}
		cou = cou + 1
		--SendAddonMessage("DPSMate_DMGTakenAll", playerclass..","..DPSMateDamageTaken[1][pid]["i"][2]..",", "RAID")
	end
end

function DPSMate.Sync:DMGTakenStatOut()
	if not DPSMateDamageTaken[1][pid] then return end
	for cat, val in self:GetSummarizedTable(DPSMateDamageTaken[1][pid]["i"][1]) do
		Buffer[cou] = {"DPSMate_DMGTakenStat", val[1]..","..val[2]..","}
		cou = cou + 1
		--SendAddonMessage("DPSMate_DMGTakenStat", val[1]..","..val[2]..",", "RAID")
	end
end

function DPSMate.Sync:DMGTakenAbilityOut()
	if not DPSMateDamageTaken[1][pid] then return end
	for cat, val in (DPSMateDamageTaken[1][pid]) do
		if cat~="i" then
			for ca, va in pairs(val) do
				Buffer[cou] = {"DPSMate_DMGTakenAbility", DPSMate:GetUserById(cat)..","..DPSMate:GetAbilityById(ca)..","..va[1]..","..va[2]..","..va[3]..","..ceil(va[4])..","..va[5]..","..va[6]..","..va[7]..","..ceil(va[8])..","..va[9]..","..va[10]..","..va[11]..","..va[12]..","..va[13]..","..ceil(va[14])..","..va[15]..","..va[16]..","..va[17]..","..ceil(va[18])..","}
				cou = cou + 1
				--SendAddonMessage("DPSMate_DMGTakenAbility", DPSMate:GetUserById(cat)..","..DPSMate:GetAbilityById(ca)..","..va[1]..","..va[2]..","..va[3]..","..ceil(va[4])..","..va[5]..","..va[6]..","..va[7]..","..ceil(va[8])..","..va[9]..","..va[10]..","..va[11]..","..va[12]..","..va[13]..","..ceil(va[14])..","..va[15]..","..va[16]..","..va[17]..","..ceil(va[18])..",", "RAID")
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                 ENEMY DAMAGE TAKEN                   --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:EDAllOut(arr, prefix)
	for cat, val in pairs(arr[1]) do
		if val[pid] then
			Buffer[cou] = {"DPSMate_ED"..prefix.."All", DPSMate:GetUserById(cat)..","..val[pid]["i"][2]..","}
			cou = cou + 1
			--SendAddonMessage("DPSMate_ED"..prefix.."All", playerclass..","..DPSMate:GetUserById(cat)..","..val[pid]["i"][2]..",", "RAID")
		end
	end
end

function DPSMate.Sync:EDStatOut(arr, prefix)
	for cat, val in arr[1] do
		if val[pid] then
			for ca, va in self:GetSummarizedTable(val[pid]["i"][1]) do
				Buffer[cou] = {"DPSMate_ED"..prefix.."Stat", DPSMate:GetUserById(cat)..","..va[1]..","..va[2]..","}
				cou = cou + 1
				--SendAddonMessage("DPSMate_ED"..prefix.."Stat", DPSMate:GetUserById(cat)..","..va[1]..","..va[2]..",", "RAID")
			end
		end
	end
end

function DPSMate.Sync:EDAbilityOut(arr, prefix)
	for cat, val in (arr[1]) do
		if val[pid] then
			for ca, va in pairs(val[pid]) do
				if ca~="i" then
					Buffer[cou] = {"DPSMate_ED"..prefix.."Ability", DPSMate:GetUserById(cat)..","..DPSMate:GetAbilityById(ca)..","..va[1]..","..va[2]..","..va[3]..","..ceil(va[4])..","..va[5]..","..va[6]..","..va[7]..","..ceil(va[8])..","..va[9]..","..va[10]..","..va[11]..","..va[12]..","..va[13]..","..va[14]..","..va[15]..","..va[16]..","..ceil(va[17])..","..va[18]..","..va[19]..","..va[20]..","..ceil(va[21])..","}
					cou = cou + 1
					--SendAddonMessage("DPSMate_ED"..prefix.."Ability", DPSMate:GetUserById(cat)..","..DPSMate:GetAbilityById(ca)..","..va[1]..","..va[2]..","..va[3]..","..ceil(va[4])..","..va[5]..","..va[6]..","..va[7]..","..ceil(va[8])..","..va[9]..","..va[10]..","..va[11]..","..va[12]..","..va[13]..","..va[14]..","..va[15]..","..va[16]..","..ceil(va[17])..","..va[18]..","..va[19]..","..va[20]..","..ceil(va[21])..",", "RAID")
				end
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                       Healing                        --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:HealingAllOut(arr, prefix)
	if arr[1][pid] then
		Buffer[cou] = {"DPSMate_"..prefix.."HealingAll", playerclass..","..arr[1][pid]["i"][1]..","}
		cou = cou + 1
		--SendAddonMessage("DPSMate_"..prefix.."HealingAll", playerclass..","..arr[1][pid]["i"][1]..",", "RAID")
	end
end

function DPSMate.Sync:HealingStatOut(arr, prefix)
	if not arr[1][pid] then return end
	for cat, val in self:GetSummarizedTable(arr[1][pid]["i"][2]) do
		Buffer[cou] = {"DPSMate_"..prefix.."HealingStat", val[1]..","..val[2]..","}
		cou = cou + 1
		--SendAddonMessage("DPSMate_"..prefix.."HealingStat", val[1]..","..val[2]..",", "RAID")
	end
end

function DPSMate.Sync:HealingAbilityOut(arr, prefix)
	if not arr[1][pid] then return end
	for cat, val in (arr[1][pid]) do
		if cat~="i" then
			Buffer[cou] = {"DPSMate_"..prefix.."HealingAbility", DPSMate:GetAbilityById(cat)..","..val[1]..","..val[2]..","..val[3]..","..ceil(val[4])..","..ceil(val[5])..","..val[6]..","..val[7]..","..val[8]..","..val[9]..","}
			cou = cou + 1
			--SendAddonMessage("DPSMate_"..prefix.."HealingAbility", DPSMate:GetAbilityById(cat)..","..val[1]..","..val[2]..","..val[3]..","..ceil(val[4])..","..ceil(val[5])..","..val[6]..","..val[7]..","..val[8]..","..val[9]..",", "RAID")
		end
	end
end

----------------------------------------------------------------------------------
--------------                    Healing taken                     --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:HealingTakenAbilityOut(arr, prefix)
	if not arr[1][pid] then return end
	for cat, val in arr[1][pid] do
		if cat~="i" then
			for ca, va in val do
				Buffer[cou] = {"DPSMate_"..prefix.."HealingTakenAbility", DPSMate:GetUserById(cat)..","..DPSMate:GetAbilityById(ca)..","..va[1]..","..va[2]..","..va[3]..","..ceil(va[4])..","..ceil(va[5])..","..va[6]..","..va[7]..","..va[8]..","..va[9]..","}
				cou = cou + 1
				--SendAddonMessage("DPSMate_"..prefix.."HealingTakenAbility", DPSMate:GetUserById(cat)..","..DPSMate:GetAbilityById(ca)..","..va[1]..","..va[2]..","..va[3]..","..ceil(va[4])..","..ceil(va[5])..","..va[6]..","..va[7]..","..va[8]..","..va[9]..",", "RAID")
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                        Absorbs                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:AbsorbsOut() 
	if not DPSMateAbsorbs[1][pid] then return end
	for cat, val in pairs(DPSMateAbsorbs[1][pid]) do -- owner
		for ca, va in pairs(val) do -- ability
			if ca~="i" then
				for c, v in pairs(va) do -- each one
					for ce, ve in pairs(v) do -- enemy
						if ce=="i" then
							Buffer[cou] = {"DPSMate_iAbsorbs", DPSMate:GetUserById(cat)..","..DPSMate:GetAbilityById(ca)..","..c..","..(ve[1] or 0)..","..(ve[2] or 0)..","..(ve[3] or 0)..","..(ve[4] or 0)..","}
							cou = cou + 1
							--SendAddonMessage("DPSMate_iAbsorbs", DPSMate:GetUserById(cat)..","..DPSMate:GetAbilityById(ca)..","..c..","..ve[1]..","..ve[2]..","..ve[3]..","..ve[4]..",", "RAID")
						else
							Buffer[cou] = {"DPSMate_Absorbs", DPSMate:GetUserById(cat)..","..DPSMate:GetAbilityById(ca)..","..c..","..DPSMate:GetUserById(ce)..","..ve[1]..","..ve[2]..","}
							cou = cou + 1
							--SendAddonMessage("DPSMate_Absorbs", DPSMate:GetUserById(cat)..","..DPSMate:GetAbilityById(ca)..","..c..","..DPSMate:GetUserById(ce)..","..ve[1]..","..ve[2]..",", "RAID")
						end
					end
				end
			end
		end
	end
end

function DPSMate.Sync:AbsorbsStatOut()
	if not DPSMateAbsorbs[1][pid] then return end
	for cat, val in DPSMateAbsorbs[1][pid] do -- owner
		for ca, va in val["i"] do
			if va[4] then
				Buffer[cou] = {"DPSMate_AbsorbsStat", DPSMate:GetUserById(cat)..","..va[1]..","..va[2]..","..va[3]..","..va[4]..","}
				cou = cou + 1
				--SendAddonMessage("DPSMate_AbsorbsStat", DPSMate:GetUserById(cat)..","..va[1]..","..va[2]..","..va[3]..","..va[4]..",", "RAID")
			else
				Buffer[cou] = {"DPSMate_AbsorbsStat", DPSMate:GetUserById(cat)..","..va[1]..","..va[2]..","..va[3]..","}
				cou = cou + 1
				--SendAddonMessage("DPSMate_AbsorbsStat", DPSMate:GetUserById(cat)..","..va[1]..","..va[2]..","..va[3]..",", "RAID")
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                        Deaths                        --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DeathsAllOut()
	if not DPSMateDeaths[1][pid] then return end
	for cat, val in pairs(DPSMateDeaths[1][pid]) do -- death count
		Buffer[cou] = {"DPSMate_DeathsAll", playerclass..","..cat..","..val["i"][1]..","..val["i"][2]..","}
		cou = cou + 1
		--SendAddonMessage("DPSMate_DeathsAll", playerclass..","..cat..","..val["i"][1]..","..val["i"][2]..",", "RAID")
	end
end

function DPSMate.Sync:DeathsOut()
	if not DPSMateDeaths[1][pid] then return end
	for cat, val in pairs(DPSMateDeaths[1][pid]) do -- death count
		for ca, va in pairs(val) do -- each part
			if ca~="i" then -- Testing if this prevents the error
				Buffer[cou] = {"DPSMate_Deaths", cat..","..ca..","..DPSMate:GetUserById(va[1])..","..DPSMate:GetAbilityById(va[2])..","..va[3]..","..va[4]..","..va[5]..","..va[6]..","..va[7]..","}
				cou = cou + 1
				--SendAddonMessage("DPSMate_Deaths", cat..","..ca..","..DPSMate:GetUserById(va[1])..","..DPSMate:GetAbilityById(va[2])..","..va[3]..","..va[4]..","..va[5]..","..va[6]..","..va[7]..",", "RAID")
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                     Interrupts                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:InterruptsAllOut()
	if DPSMateInterrupts[1][pid] then
		Buffer[cou] = {"DPSMate_InterruptsAll", playerclass..","..DPSMateInterrupts[1][pid]["i"][1]..","}
		cou = cou + 1
		--SendAddonMessage("DPSMate_InterruptsAll", playerclass..","..DPSMateInterrupts[1][pid]["i"]..",", "RAID")
	end
end

function DPSMate.Sync:InterruptsAbilityOut()
	if not DPSMateInterrupts[1][pid] then return end
	for cat, val in pairs(DPSMateInterrupts[1][pid]) do
		if cat~="i" then
			for ca, va in pairs(val) do
				for c, v in pairs(va) do
					Buffer[cou] = {"DPSMate_InterruptsAbility", DPSMate:GetAbilityById(cat)..","..DPSMate:GetUserById(ca)..","..DPSMate:GetAbilityById(c)..","..v..","}
					cou = cou + 1
					--SendAddonMessage("DPSMate_InterruptsAbility", DPSMate:GetAbilityById(cat)..","..DPSMate:GetUserById(ca)..","..DPSMate:GetAbilityById(c)..","..v..",", "RAID")
				end
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                        Dispels                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DispelsOut()
	if not DPSMateDispels[1][pid] then return end
	for cat, val in pairs(DPSMateDispels[1][pid]) do -- Ability
		if cat=="i" then
			Buffer[cou] = {"DPSMate_iDispels", val[1]}
			cou = cou + 1
			--SendAddonMessage("DPSMate_iDispels", DPSMate:GetAbilityById(cat)..","..val..",", "RAID")
		else
			for ca, va in pairs(val) do -- Target
				for c, v in pairs(va) do -- Ability
					Buffer[cou] = {"DPSMate_Dispels", DPSMate:GetAbilityById(cat)..","..DPSMate:GetUserById(ca)..","..DPSMate:GetAbilityById(c)..","..v..","}
					cou = cou + 1
					--SendAddonMessage("DPSMate_Dispels", DPSMate:GetAbilityById(cat)..","..DPSMate:GetUserById(ca)..","..DPSMate:GetAbilityById(c)..","..v..",", "RAID")
				end
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                        Auras                         --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:AurasOut()
	if not DPSMateAurasGained[1][pid] then return end
	local p = 0
	for cat, val in pairs(DPSMateAurasGained[1][pid]) do -- ability
		if val[4] then p = 1 end
		local ability = DPSMate:GetAbilityById(cat)
		Buffer[cou] = {"DPSMate_AurasAll", ability..","..p..","}
		cou = cou + 1
		--SendAddonMessage("DPSMate_AurasAll", ability..","..p..",", "RAID")
		for ca, va in pairs(val[1]) do
			Buffer[cou] = {"DPSMate_AurasStart", ability..","..ca..","..va..","}
			cou = cou + 1
			--SendAddonMessage("DPSMate_AurasStart", ability..","..ca..","..va..",", "RAID")
		end
		for ca, va in pairs(val[2]) do
			Buffer[cou] = {"DPSMate_AurasEnd", ability..","..ca..","..va..","}
			cou = cou + 1
			--SendAddonMessage("DPSMate_AurasEnd", ability..","..ca..","..va..",", "RAID")
		end
		for ca, va in pairs(val[3]) do
			Buffer[cou] = {"DPSMate_AurasCause", ability..","..DPSMate:GetUserById(ca)..","..va..","}
			cou = cou + 1
			--SendAddonMessage("DPSMate_AurasCause", ability..","..DPSMate:GetUserById(ca)..","..va..",", "RAID")
		end
	end
end

DPSMate.Sync.Exec = {
	["DPSMate"] = function(arg2,arg4) 
		t = {}
		strgsub(arg2, "(.-),", func) -- name, aura, target, time
		t[3] = GetTime()
		if DPSMate:TContains(DPSMate.Parser.Kicks, ability) then DB:AwaitAfflictedStun(arg4, t[1], t[2], t[3]) end
		if DPSMate:TContains(DPSMate.Parser.HotDispels, ability) then DB:AwaitHotDispel(t[1], t[2], arg4, t[3]) end
		DB:AwaitingBuff(arg4, t[1], t[2], t[3])
		DB:AwaitingAbsorbConfirmation(arg4, t[1], t[2], t[3])
	end,
	["DPSMate_UserData"] = function(arg2,arg4) DPSMate.Sync:ReceiveUserData(arg2, arg4) end,
	["DPSMate_HelloWorld"] = function() DPSMate.Sync:GreetBack() end,
	["DPSMate_Greet"] = function(arg2,arg4) DPSMate.Sync:ReceiveGreet(arg2, arg4) end,
	["DPSMate_DMGDoneAll"] = function(arg2,arg4) DPSMate.Sync:DMGDoneAllIn(arg2, arg4) end,
	["DPSMate_DMGDoneStat"] = function(arg2,arg4) DPSMate.Sync:DMGDoneStatIn(arg2, arg4) end,
	["DPSMate_DMGDoneAbility"] = function(arg2,arg4) DPSMate.Sync:DMGDoneAbilityIn(arg2, arg4) end,
	["DPSMate_EHealingAll"] = function(arg2,arg4) DPSMate.Sync:HealingAllIn(arg2, arg4, 6) end,
	["DPSMate_EHealingStat"] = function(arg2,arg4) DPSMate.Sync:HealingStatIn(arg2, arg4, 6) end,
	["DPSMate_EHealingAbility"] = function(arg2,arg4) DPSMate.Sync:HealingAbilityIn(arg2, arg4, 6) end,
	["DPSMate_THealingAll"] = function(arg2,arg4) DPSMate.Sync:HealingAllIn(arg2, arg4, 5) end,
	["DPSMate_THealingStat"] = function(arg2,arg4) DPSMate.Sync:HealingStatIn(arg2, arg4, 5) end,
	["DPSMate_THealingAbility"] = function(arg2,arg4) DPSMate.Sync:HealingAbilityIn(arg2, arg4, 5) end,
	["DPSMate_OHealingAll"] = function(arg2,arg4) DPSMate.Sync:HealingAllIn(arg2, arg4, 9) end,
	["DPSMate_OHealingStat"] = function(arg2,arg4) DPSMate.Sync:HealingStatIn(arg2, arg4, 9) end,
	["DPSMate_OHealingAbility"] = function(arg2,arg4) DPSMate.Sync:HealingAbilityIn(arg2, arg4, 9) end,
	["DPSMate_TTakenHealingAll"] = function(arg2,arg4) DPSMate.Sync:HealingAllIn(arg2, arg4, 7) end,
	["DPSMate_TTakenHealingStat"] = function(arg2,arg4) DPSMate.Sync:HealingStatIn(arg2, arg4, 7) end,
	["DPSMate_THealingTakenAbility"] = function(arg2,arg4) DPSMate.Sync:HealingTakenAbilityIn(arg2, arg4, 7) end,
	["DPSMate_ETakenHealingAll"] = function(arg2,arg4) DPSMate.Sync:HealingAllIn(arg2, arg4, 8) end,
	["DPSMate_ETakenHealingStat"] = function(arg2,arg4) DPSMate.Sync:HealingStatIn(arg2, arg4, 8) end,
	["DPSMate_EHealingTakenAbility"] = function(arg2,arg4) DPSMate.Sync:HealingTakenAbilityIn(arg2, arg4, 8) end,
	["DPSMate_Absorbs"] = function(arg2,arg4) DPSMate.Sync:AbsorbsIn(arg2, arg4) end,
	["DPSMate_iAbsorbs"] = function(arg2,arg4) DPSMate.Sync:iAbsorbsIn(arg2, arg4) end,
	["DPSMate_Dispels"] = function(arg2,arg4) DPSMate.Sync:DispelsIn(arg2, arg4) end,
	["DPSMate_iDispels"] = function(arg2,arg4) DPSMate.Sync:iDispelsIn(arg2, arg4) end,
	["DPSMate_DMGTakenAll"] = function(arg2,arg4) DPSMate.Sync:DMGTakenAllIn(arg2, arg4) end,
	["DPSMate_DMGTakenStat"] = function(arg2,arg4) DPSMate.Sync:DMGTakenStatIn(arg2, arg4) end,
	["DPSMate_DMGTakenAbility"] = function(arg2,arg4) DPSMate.Sync:DMGTakenAbilityIn(arg2, arg4) end,
	["DPSMate_EDTAll"] = function(arg2,arg4) DPSMate.Sync:EDAllIn(4, arg2, arg4) end,
	["DPSMate_EDTAbility"] = function(arg2,arg4) DPSMate.Sync:EDAbilityIn(4, arg2, arg4) end,
	["DPSMate_EDTStat"] = function(arg2,arg4) DPSMate.Sync:EDStatIn(4, arg2, arg4) end,
	["DPSMate_EDDAll"] = function(arg2,arg4) DPSMate.Sync:EDAllIn(3, arg2, arg4) end,
	["DPSMate_EDDAbility"] = function(arg2,arg4) DPSMate.Sync:EDAbilityIn(3, arg2, arg4) end,
	["DPSMate_EDDStat"] = function(arg2,arg4) DPSMate.Sync:EDStatIn(3, arg2, arg4) end,
	["DPSMate_DeathsAll"] = function(arg2,arg4) DPSMate.Sync:DeathsAllIn(arg2, arg4) end,
	["DPSMate_Deaths"] = function(arg2,arg4) DPSMate.Sync:DeathsIn(arg2, arg4) end,
	["DPSMate_InterruptsAll"] = function(arg2,arg4) DPSMate.Sync:InterruptsAllIn(arg2, arg4) end,
	["DPSMate_InterruptsAbility"] = function(arg2,arg4) DPSMate.Sync:InterruptsAbilityIn(arg2, arg4) end,
	["DPSMate_AurasAll"] = function(arg2,arg4) DPSMate.Sync:AurasAllIn(arg2, arg4) end,
	["DPSMate_AurasStart"] = function(arg2,arg4) DPSMate.Sync:AurasStartEndIn(arg2, arg4, 1) end,
	["DPSMate_AurasEnd"] = function(arg2,arg4) DPSMate.Sync:AurasStartEndIn(arg2, arg4, 2) end,
	["DPSMate_AurasCause"] = function(arg2,arg4) DPSMate.Sync:AurasCauseIn(arg2, arg4) end,
	["DPSMate_Vote"] = function() DPSMate.Sync:CountVote() end,
	["DPSMate_StartVote"] = function() DPSMate.Sync:ReceiveStartVote() end,
	["DPSMate_VoteSuccess"] = function() DPSMate.Sync:VoteSuccess() end,
	["DPSMate_VoteFail"] = function() DPSMate:SendMessage("Reset voting has failed!") end,
	["DPSMate_Participate"] = function() DPSMate.Sync:CountParticipants() end,
	["DPSMate_SyncTimer"] = function(arg2) DPSMate.Sync:SetTimer(arg2) end,
	["DPSMate_SyncStatus"] = function(arg2,arg4) DPSMate.Sync:SyncStatus(arg2, arg4) end,
}