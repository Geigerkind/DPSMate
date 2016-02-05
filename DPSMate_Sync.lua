-- Global Variables
DPSMate.Sync.Async = false

-- Local Variables
local player = {}
player["name"] = UnitName("player")
local a,b = UnitClass("player")
player["class"] = strlower(b)
local time = 0
local iterator = 1
local voteStarter = false

-- Beginn Functions

function DPSMate.Sync:OnUpdate(elapsed)
	if DPSMate.DB.loaded then
		time=time+elapsed
		if iterator==1 then
			DPSMate.Sync:DMGDoneAllOut()
			iterator = 2
		elseif time>=3 and iterator==2 then
			DPSMate.Sync:DMGDoneStatOut()
			iterator = 3
		elseif time>=6 and iterator==3 then
			DPSMate.Sync:DMGDoneAbilityOut()
			iterator = 4
		elseif time>=9 and iterator==4 then
			DPSMate.Sync:HealingAllOut(DPSMateEHealing, "E")
			iterator = 5
		elseif time>=12 and iterator==5 then
			DPSMate.Sync:HealingAbilityOut(DPSMateEHealing, "E")
			iterator = 6
		elseif time>=15 and iterator==6 then
			DPSMate.Sync:HealingAllOut(DPSMateTHealing, "T")
			iterator = 7
		elseif time>=18 and iterator==7 then
			DPSMate.Sync:HealingAbilityOut(DPSMateTHealing, "T")
			iterator = 8
		elseif time>=21 and iterator==8 then
			DPSMate.Sync:HealingAllOut(DPSMateOverhealing, "O")
			iterator = 9
		elseif time>=24 and iterator==9 then
			DPSMate.Sync:HealingAbilityOut(DPSMateOverhealing, "O")
			iterator = 10
		elseif time>=27 and iterator==10 then
			DPSMate.Sync:AbsorbsOut() 
			iterator = 11
		elseif time>=30 and iterator==11 then
			DPSMate.Sync:DispelsOut()
			iterator = 12
		elseif time>=33 and iterator==12 then
			DPSMate.Sync:DMGTakenAllOut()
			iterator = 13
		elseif time>=36 and iterator==13 then
			DPSMate.Sync:DMGTakenStatOut()
			iterator = 14
		elseif time>=39 and iterator==14 then
			DPSMate.Sync:DMGTakenAbilityOut()
			iterator = 15
		elseif time>=42 and iterator==15 then
			DPSMate.Sync:EDAllOut(DPSMateEDD, "D")
			iterator = 16
		elseif time>=45 and iterator==16 then
			DPSMate.Sync:EDAbilityOut(DPSMateEDD, "D")
			iterator = 17
		elseif time>=48 and iterator==17 then
			DPSMate.Sync:EDAllOut(DPSMateEDT, "T")
			iterator = 18
		elseif time>=51 and iterator==18 then
			DPSMate.Sync:EDAbilityOut(DPSMateEDT, "T")
			iterator = 19
		elseif time>=54 and iterator==19 then
			DPSMate.Sync:HealingTakenAllOut(DPSMateHealingTaken, "T")
			iterator = 20
		elseif time>=57 and iterator==20 then
			DPSMate.Sync:HealingTakenAbilityOut(DPSMateHealingTaken, "T")
			iterator = 21
		elseif time>=60 and iterator==21 then
			DPSMate.Sync:HealingTakenAllOut(DPSMateEHealingTaken, "E")
			iterator = 22
		elseif time>=63 and iterator==22 then
			DPSMate.Sync:HealingTakenAbilityOut(DPSMateEHealingTaken, "E")
			iterator = 23
		elseif time>=66 and iterator==23 then
			DPSMate.Sync:DeathsAllOut()
			iterator = 24
		elseif time>=69 and iterator==24 then
			DPSMate.Sync:DeathsOut()
			iterator = 25
		elseif time>=72 and iterator==25 then
			DPSMate.Sync:InterruptsAllOut()
			iterator = 26
		elseif time>=75 and iterator==26 then
			DPSMate.Sync:InterruptsAbilityOut()
			iterator = 27
		elseif time>=78 and iterator==27 then
			DPSMate.Sync:AurasOut()
			DPSMate.Sync.Async = false
			iterator = 1
			time = 0
		end
	end
end

----------------------------------------------------------------------------------
--------------                       GENERAL                        --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:GetSummarizedTable(arr)
	local newArr, i, dmg, time, dis = {}, 1, 0, nil, 1
	local TL = DPSMate:TableLength(arr)
	if TL>100 then dis = floor(TL/100) end
	for cat, val in pairs(arr) do
		if dis>1 then
			dmg=dmg+val[2]
			if i<dis then
				if not time then time=val[1] end -- first time val
			else
				table.insert(newArr, {(val[1]+time)/2, dmg/(val[1]-time)}) -- last time val // subtracting from each other to get the time in which the damage is being done
				time, dmg, i = nil, 0, 1
			end
		else
			table.insert(newArr, val)
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
function DPSMate.Sync:CountVote()
	if voteStarter then
		voteCount=voteCount+1
		if voteCount >= (participants/2) then
			SendAddonMessage("DPSMate_VoteSuccess", nil, "RAID")
			voteStarter = false
			voteCount = 1
			participants = 1
			DPSMate.Sync:VoteSuccess()
		end
	end
end

local voteTime = 0
local participants = 1
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
			DPSMate.Sync:VoteSuccess()
		end
	end
end

function DPSMate.Sync:VoteSuccess()
	DPSMate:SendMessage("Reset vote was successful! DPSMate has been resetted!")
	DPSMate.Options:PopUpAccept(true, true)
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
	DPSMate_Vote:Show()
	DPSMate.Sync:Participate()
end

----------------------------------------------------------------------------------
--------------                       SYNC IN                        --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:OnEvent(event)
	if event == "CHAT_MSG_ADDON" then
		if DPSMateSettings["sync"] and DPSMate.DB.loaded then
			if arg4 == player.name then return end 
			if arg1 == "DPSMate" then
				local owner, ability, abilityTarget, time = "", "", "", 0
				for o,a,at,t in string.gfind(arg2, "(.+),(.+),(.+),(.+)") do owner=o;ability=a;abilityTarget=at;time=tonumber(t) end
				if DPSMate:TContains(DPSMate.Parser.Kicks, ability) then DPSMate.DB:AwaitAfflictedStun(owner, ability, abilityTarget, time) end
				DPSMate.DB:AwaitHotDispel(ability, abilityTarget, owner, time)
				DPSMate.DB:AwaitingBuff(owner, ability, abilityTarget, time)
				DPSMate.DB:AwaitingAbsorbConfirmation(owner, ability, abilityTarget, time)
			elseif arg1 == "DPSMate_DMGDoneAll" then
				DPSMate.Sync:DMGDoneAllIn(arg2, arg4)
			elseif arg1 == "DPSMate_DMGDoneStat" then
				DPSMate.Sync:DMGDoneStatIn(arg2, arg4)
			elseif arg1 == "DPSMate_DMGDoneAbility" then
				DPSMate.Sync:DMGDoneAbilityIn(arg2, arg4, 1)
			elseif arg1 == "DPSMate_DMGDoneAbility2" then
				DPSMate.Sync:DMGDoneAbilityIn(arg2, arg4, 4)
			elseif arg1 == "DPSMate_DMGDoneAbility3" then
				DPSMate.Sync:DMGDoneAbilityIn(arg2, arg4, 7)
			elseif arg1 == "DPSMate_DMGDoneAbility4" then
				DPSMate.Sync:DMGDoneAbilityIn(arg2, arg4, 10)
			elseif arg1 == "DPSMate_DMGDoneAbility5" then
				DPSMate.Sync:DMGDoneAbilityIn(arg2, arg4, 13)
			elseif arg1 == "DPSMate_DMGDoneAbility6" then
				DPSMate.Sync:DMGDoneAbilityIn(arg2, arg4, 16)
			elseif arg1 == "DPSMate_DMGDoneAbility7" then
				DPSMate.Sync:DMGDoneAbilityIn(arg2, arg4, 19)
			elseif arg1 == "DPSMate_EHealingAll" then
				DPSMate.Sync:HealingAllIn(arg2, arg4, DPSMateEHealing)
			elseif arg1 == "DPSMate_EHealingAbility" then
				DPSMate.Sync:HealingAbilityIn(arg2, arg4, DPSMateEHealing)
			elseif arg1 == "DPSMate_THealingAll" then
				DPSMate.Sync:HealingAllIn(arg2, arg4, DPSMateTHealing)
			elseif arg1 == "DPSMate_THealingAbility" then
				DPSMate.Sync:HealingAbilityIn(arg2, arg4, DPSMateTHealing)
			elseif arg1 == "DPSMate_OHealingAll" then
				DPSMate.Sync:HealingAllIn(arg2, arg4, DPSMateOverhealing)
			elseif arg1 == "DPSMate_OHealingAbility" then
				DPSMate.Sync:HealingAbilityIn(arg2, arg4, DPSMateOverhealing)
			elseif arg1 == "DPSMate_THealingTakenAll" then
				DPSMate.Sync:HealingTakenAllIn(arg2, arg4, DPSMateHealingTaken)
			elseif arg1 == "DPSMate_THealingTakenAbility" then
				DPSMate.Sync:HealingTakenAbilityIn(arg2, arg4, DPSMateHealingTaken)
			elseif arg1 == "DPSMate_EHealingTakenAll" then
				DPSMate.Sync:HealingTakenAllIn(arg2, arg4, DPSMateEHealingTaken)
			elseif arg1 == "DPSMate_EHealingTakenAbility" then
				DPSMate.Sync:HealingTakenAbilityIn(arg2, arg4, DPSMateEHealingTaken)
			elseif arg1 == "DPSMate_Absorbs" then
				DPSMate.Sync:AbsorbsIn(arg2, arg4) 
			elseif arg1 == "DPSMate_iAbsorbs" then
				DPSMate.Sync:iAbsorbsIn(arg2, arg4) 
			elseif arg1 == "DPSMate_Dispels" then
				DPSMate.Sync:DispelsIn(arg2, arg4) 
			elseif arg1 == "DPSMate_iDispels" then
				DPSMate.Sync:iDispelsIn(arg2, arg4) 
			elseif arg1 == "DPSMate_DMGTakenAll" then
				DPSMate.Sync:DMGTakenAllIn(arg2, arg4)
			elseif arg1 == "DPSMate_DMGTakenStat" then
				DPSMate.Sync:DMGTakenStatIn(arg2, arg4)
			elseif arg1 == "DPSMate_DMGTakenAbility" then
				DPSMate.Sync:DMGTakenAbilityIn(arg2, arg4, 1)
			elseif arg1 == "DPSMate_DMGTakenAbility2" then
				DPSMate.Sync:DMGTakenAbilityIn(arg2, arg4, 4)
			elseif arg1 == "DPSMate_DMGTakenAbility3" then
				DPSMate.Sync:DMGTakenAbilityIn(arg2, arg4, 7)
			elseif arg1 == "DPSMate_DMGTakenAbility4" then
				DPSMate.Sync:DMGTakenAbilityIn(arg2, arg4, 10)
			elseif arg1 == "DPSMate_DMGTakenAbility5" then
				DPSMate.Sync:DMGTakenAbilityIn(arg2, arg4, 13)
			elseif arg1 == "DPSMate_DMGTakenAbility6" then
				DPSMate.Sync:DMGTakenAbilityIn(arg2, arg4, 16)
			elseif arg1 == "DPSMate_EDTAll" then
				DPSMate.Sync:EDAllIn(DPSMateEDT, arg2, arg4)
			elseif arg1 == "DPSMate_EDTAbility" then
				DPSMate.Sync:EDAbilityIn(DPSMateEDT, arg2, arg4)
			elseif arg1 == "DPSMate_EDDAll" then
				DPSMate.Sync:EDAllIn(DPSMateEDD, arg2, arg4)
			elseif arg1 == "DPSMate_EDDAbility" then
				DPSMate.Sync:EDAbilityIn(DPSMateEDD, arg2, arg4)
			elseif arg1 == "DPSMate_DeathsAll" then
				DPSMate.Sync:DeathsAllIn(arg2, arg4) 
			elseif arg1 == "DPSMate_Deaths" then
				DPSMate.Sync:DeathsIn(arg2, arg4)
			elseif arg1 == "DPSMate_InterruptsAll" then
				DPSMate.Sync:InterruptsAllIn(arg2, arg4)
			elseif arg1 == "DPSMate_InterruptsAbility" then
				DPSMate.Sync:InterruptsAbilityIn(arg2, arg4)
			elseif arg1 == "DPSMate_AurasAll" then
				DPSMate.Sync:AurasAllIn(arg2, arg4)
			elseif arg1 == "DPSMate_AurasStart" then
				DPSMate.Sync:AurasStartEndIn(arg2, arg4, 1)
			elseif arg1 == "DPSMate_AurasEnd" then
				DPSMate.Sync:AurasStartEndIn(arg2, arg4, 2)
			elseif arg1 == "DPSMate_AurasCause" then
				DPSMate.Sync:AurasCauseIn(arg2, arg4)
			elseif arg1 == "DPSMate_Vote" then
				DPSMate.Sync:CountVote()
			elseif arg1 == "DPSMate_StartVote" then
				DPSMate.Sync:ReceiveStartVote() 
			elseif arg1 == "DPSMate_VoteSuccess" then
				DPSMate.Sync:VoteSuccess()
			elseif arg1 == "DPSMate_VoteFail" then
				DPSMate:SendMessage("Reset voting has failed!")
			elseif arg1 == "DPSMate_Participate" then
				DPSMate.Sync:CountParticipants()
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                    DAMAGE DONE                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DMGDoneAllIn(arg2, arg4)
	for oc, am in string.gfind(arg2, "(.+),(.+)") do
		DPSMate.DB:BuildUser(arg4, oc)
		local ownerid = DPSMateUser[arg4][1]
		DPSMateDamageDone[1][ownerid] = {
			i = {
				[1] = {},
				[2] = 0,
			},
		}
		DPSMateDamageDone[1][ownerid]["i"][2] = tonumber(am)
		DPSMate.DB.NeedUpdate = true
	end
end

-- Here are many redundant points added most likely
function DPSMate.Sync:DMGDoneStatIn(arg2, arg4)
	DPSMate.DB:BuildUser(arg4, nil)
	local ownerid = DPSMateUser[arg4][1]
	for key, val in string.gfind(arg2, "(.+),(.+)") do
		if not DPSMateDamageDone[1][ownerid] then
			DPSMateDamageDone[1][ownerid] = {
				i = {
					[1] = {},
					[2] = 0,
				},
			}
		end
		DPSMateDamageDone[1][ownerid]["i"][1][tonumber(key)] = tonumber(val)
	end
end

function DPSMate.Sync:DMGDoneAbilityIn(arg2, arg4, p)
	-- ability, a1, b1, a2, b2 etc
	for a,a1,a2,a3 in string.gfind(arg2, "(.+),(.+),(.+),(.+)") do 
		DPSMate.DB:BuildUser(arg4, nil)
		local ownerid = DPSMateUser[arg4][1]
		DPSMate.DB:BuildAbility(a, nil)
		local abilityid = DPSMateAbility[a][1]
		if not DPSMateDamageDone[1][ownerid] then
			DPSMateDamageDone[1][ownerid] = {
				i = {
					[1] = {},
					[2] = 0,
				},
			}
		end
		if not DPSMateDamageDone[1][ownerid][abilityid] then
			DPSMateDamageDone[1][ownerid][abilityid] = {}
		end
		DPSMateDamageDone[1][ownerid][abilityid][p] = tonumber(a1)
		DPSMateDamageDone[1][ownerid][abilityid][p+1] = tonumber(a2)
		DPSMateDamageDone[1][ownerid][abilityid][p+2] = tonumber(a3)
	end
end

----------------------------------------------------------------------------------
--------------                    DAMAGE TAKEN                      --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DMGTakenAllIn(arg2, arg4)
	for oc,ta,am in string.gfind(arg2, "(.+),(.+),(.+)") do
		DPSMate.DB:BuildUser(arg4, oc)
		local ownerid = DPSMateUser[arg4][1]
		DPSMateDamageTaken[1][ownerid] = {}
		DPSMate.DB:BuildUser(ta, oc)
		local tarid = DPSMateUser[ta][1]
		if not DPSMateDamageTaken[1][ownerid] then
			DPSMateDamageTaken[1][ownerid] = {
				i = {},
			}
		end
		if not DPSMateDamageTaken[1][ownerid][tarid] then
			DPSMateDamageTaken[1][ownerid][tarid] = {
				i = 0,
			}
		end
		DPSMateDamageTaken[1][ownerid][tarid]["i"] = tonumber(am)
		DPSMate.DB.NeedUpdate = true
	end
end

function DPSMate.Sync:DMGTakenStatIn(arg2, arg4)
	DPSMate.DB:BuildUser(arg4, nil)
	local ownerid = DPSMateUser[arg4][1]
	if not ownerid then return end
	for key, val in string.gfind(arg2, "(.+),(.+)") do
		if not DPSMateDamageTaken[1][ownerid] then
			DPSMateDamageTaken[1][ownerid] = {
				i = {},
			}
		end
		DPSMateDamageDone[1][ownerid]["i"][tonumber(key)] = tonumber(val)
	end
end

function DPSMate.Sync:DMGTakenAbilityIn(arg2, arg4, p)
	-- ability, a1, b1, a2, b2 etc
	for ta,a,a1,a2,a3 in string.gfind(arg2, "(.+),(.+),(.+),(.+),(.+)") do 
		DPSMate.DB:BuildUser(arg4, nil)
		local ownerid = DPSMateUser[arg4][1]
		DPSMate.DB:BuildUser(ta, nil)
		local tarid = DPSMateUser[ta][1]
		DPSMate.DB:BuildAbility(a, nil)
		local abilityid = DPSMateAbility[a][1]
		if not DPSMateDamageTaken[1][ownerid] then
			DPSMateDamageTaken[1][ownerid] = {
				i = {},
			}
		end
		if not DPSMateDamageTaken[1][ownerid][tarid] then
			DPSMateDamageTaken[1][ownerid][tarid] = {
				i = 0,
			}
		end
		if not DPSMateDamageTaken[1][ownerid][tarid][abilityid] then
			DPSMateDamageTaken[1][ownerid][tarid][abilityid] = {}
		end
		DPSMateDamageTaken[1][ownerid][tarid][abilityid][p] = tonumber(a1)
		DPSMateDamageTaken[1][ownerid][tarid][abilityid][p+1] = tonumber(a2)
		DPSMateDamageTaken[1][ownerid][tarid][abilityid][p+2] = tonumber(a3)
	end
end

----------------------------------------------------------------------------------
--------------                 ENEMY DAMAGE TAKEN                   --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:EDAllIn(arr, arg2, arg4)
	for oc,ta,am in string.gfind(arg2, "(.+),(.+),(.+)") do
		DPSMate.DB:BuildUser(arg4, oc)
		local ownerid = DPSMateUser[arg4][1]
		DPSMate.DB:BuildUser(ta, oc)
		local tarid = DPSMateUser[ta][1]
		if not arr[1][tarid] then
			arr[1][tarid] = {}
		end
		arr[1][tarid][ownerid] = {
			i = {
				[1] = {},
				[2] = 0,
			},
		}
		arr[1][tarid][ownerid]["i"][2] = tonumber(am)
		DPSMate.DB.NeedUpdate = true
	end
end

function DPSMate.Sync:EDAbilityIn(arr, arg2, arg4)
	-- ability, a1, b1, a2, b2 etc
	for ta,a,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13 in string.gfind(arg2, "(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+)") do 
		DPSMate.DB:BuildUser(arg4, nil)
		local ownerid = DPSMateUser[arg4][1]
		DPSMate.DB:BuildUser(ta, nil)
		local tarid = DPSMateUser[ta][1]
		DPSMate.DB:BuildAbility(a, nil)
		local abilityid = DPSMateAbility[a][1]
		if not arr[1][tarid] then
			arr[1][tarid] = {}
		end
		if not arr[1][tarid][ownerid] then
			arr[1][tarid][ownerid] = {
				i = {
					[1] = {},
					[2] = 0,
				},
			}
		end
		arr[1][tarid][ownerid][abilityid] = {
			[1] = tonumber(a1),
			[2] = tonumber(a2),
			[3] = tonumber(a3),
			[4] = tonumber(a4),
			[5] = tonumber(a5),
			[6] = tonumber(a6),
			[7] = tonumber(a7),
			[8] = tonumber(a8),
			[9] = tonumber(a9),
			[10] = tonumber(a10),
			[11] = tonumber(a11),
			[12] = tonumber(a12),
			[13] = tonumber(a13),
		}
	end
end

----------------------------------------------------------------------------------
--------------                        Healing                       --------------                                  
----------------------------------------------------------------------------------

-- Have to fix formatting for healing "i"[1]
function DPSMate.Sync:HealingAllIn(arg2, arg4, arr)
	for oc, am in string.gfind(arg2, "(.+),(.+)") do
		DPSMate.DB:BuildUser(arg4, oc)
		local ownerid = DPSMateUser[arg4][1]
		arr[1][ownerid] = {
			i = {
				[1] = 0,
			},
		}
		arr[1][ownerid]["i"][1] = tonumber(am)
		DPSMate.DB.NeedUpdate = true
	end
end

function DPSMate.Sync:HealingAbilityIn(arg2, arg4, arr)
	-- ability,target, a1, b1, a2, b2 etc
	for a,ta,a1,a2,a3,a4,a5,a6 in string.gfind(arg2, "(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+)") do
		-- Check if user exist if not, create him
		DPSMate.DB:BuildUser(arg4, nil)
		local ownerid = DPSMateUser[arg4][1]
		DPSMate.DB:BuildAbility(a, nil)
		local abilityid = DPSMateAbility[a][1]
		DPSMate.DB:BuildUser(ta, nil)
		local tarid = DPSMateUser[ta][1]
		if not arr[1][ownerid] then
			arr[1][ownerid] = {
				i = {
					[1] = 0,
				},
			}
		end
		if not arr[1][ownerid][abilityid] then
			arr[1][ownerid][abilityid] = {}
		end
		arr[1][ownerid][abilityid][tarid] = {
			[1] = tonumber(a1),
			[2] = tonumber(a2),
			[3] = tonumber(a3),
			[4] = tonumber(a4),
			[5] = tonumber(a5),
			[6] = tonumber(a6),
		}
	end
end

----------------------------------------------------------------------------------
--------------                    Healing taken                     --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:HealingTakenAllIn(arg2, arg4, arr)
	for oc, am in string.gfind(arg2, "(.+),(.+)") do
		DPSMate.DB:BuildUser(arg4, oc)
		local ownerid = DPSMateUser[arg4][1]
		arr[1][ownerid] = {
			i = 0,
		}
		arr[1][ownerid]["i"] = tonumber(am)
		DPSMate.DB.NeedUpdate = true
	end
end

function DPSMate.Sync:HealingTakenAbilityIn(arg2, arg4, arr)
	-- ability,target, a1, b1, a2, b2 etc
	for ta,ab,a1,a2,a3,a4,a5,a6 in string.gfind(arg2, "(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+)") do
		-- Check if user exist if not, create him
		DPSMate.DB:BuildUser(arg4, nil)
		local ownerid = DPSMateUser[arg4][1]
		DPSMate.DB:BuildAbility(ab, nil)
		local abilityid = DPSMateAbility[ab][1]
		DPSMate.DB:BuildUser(ta, nil)
		local tarid = DPSMateUser[ta][1]
		if not arr[1][ownerid] then
			arr[1][ownerid] = {
				i = 0,
			}
		end
		if not arr[1][ownerid][tarid] then
			arr[1][ownerid][tarid] = {}
		end
		arr[1][ownerid][tarid][abilityid] = {
			[1] = tonumber(a1),
			[2] = tonumber(a2),
			[3] = tonumber(a3),
			[4] = tonumber(a4),
			[5] = tonumber(a5),
			[6] = tonumber(a6),
		}
	end
end

----------------------------------------------------------------------------------
--------------                        Absorbs                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:iAbsorbsIn(arg2, arg4) 
	-- owner, ability, each one, enemy, va1, va2
	for o,a,e,v1,v2 in string.gfind(arg2, "(.+),(.+),(.+),(.+),(.+)") do 
		DPSMate.DB:BuildUser(arg4, nil)
		local pid = DPSMateUser[arg4][1]
		DPSMate.DB:BuildUser(o, nil)
		local ownerid = DPSMateUser[o][1]
		DPSMate.DB:BuildAbility(a, nil)
		local abilityid = DPSMateAbility[a][1]
		if not DPSMateAbsorbs[1][pid] then
			DPSMateAbsorbs[1][pid] = {}
		end
		if not DPSMateAbsorbs[1][pid][ownerid] then
			DPSMateAbsorbs[1][pid][ownerid] = {}
		end
		if not DPSMateAbsorbs[1][pid][ownerid][abilityid] then
			DPSMateAbsorbs[1][pid][ownerid][abilityid] = {}
		end
		if not DPSMateAbsorbs[1][pid][ownerid][abilityid][tonumber(e)] then
			DPSMateAbsorbs[1][pid][ownerid][abilityid][tonumber(e)] = {
				i = {
					[1] = 0,
					[2] = 0,
				},
			}
		end
		DPSMateAbsorbs[1][pid][ownerid][abilityid][tonumber(e)]["i"][1] = tonumber(v1)
		DPSMateAbsorbs[1][pid][ownerid][abilityid][tonumber(e)]["i"][2] = tonumber(v2)
		DPSMate.DB.NeedUpdate = true
	end
end

function DPSMate.Sync:AbsorbsIn(arg2, arg4) 
	-- owner, ability, each one, enemy, va1, va2
	for o,a,e,en,v1,v2 in string.gfind(arg2, "(.+),(.+),(.+),(.+),(.+),(.+)") do 
		DPSMate.DB:BuildUser(arg4, nil)
		local pid = DPSMateUser[arg4][1]
		DPSMate.DB:BuildUser(o, nil)
		local ownerid = DPSMateUser[o][1]
		DPSMate.DB:BuildAbility(a, nil)
		local abilityid = DPSMateAbility[a][1]
		DPSMate.DB:BuildUser(en, nil)
		local enemyid = DPSMateUser[en][1]
		if not DPSMateAbsorbs[1][pid] then
			DPSMateAbsorbs[1][pid] = {}
		end
		if not DPSMateAbsorbs[1][pid][ownerid] then
			DPSMateAbsorbs[1][pid][ownerid] = {}
		end
		if not DPSMateAbsorbs[1][pid][ownerid][abilityid] then
			DPSMateAbsorbs[1][pid][ownerid][abilityid] = {}
		end
		if not DPSMateAbsorbs[1][pid][ownerid][abilityid][tonumber(e)] then
			DPSMateAbsorbs[1][pid][ownerid][abilityid][tonumber(e)] = {
				i = {
					[1] = 0,
					[2] = 0,
				},
			}
		end
		DPSMateAbsorbs[1][pid][ownerid][abilityid][tonumber(e)][enemyid] = {
			[1] = tonumber(v1),
			[2] = tonumber(v2),
		}
		DPSMate.DB.NeedUpdate = true
	end
end

----------------------------------------------------------------------------------
--------------                        Deaths                        --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DeathsAllIn(arg2, arg4) 
	for oc,cat,v1 in string.gfind(arg2, "(.+),(.+),(.+)") do 
		cat = tonumber(cat)
		DPSMate.DB:BuildUser(arg4, oc)
		local ownerid = DPSMateUser[arg4][1]
		if not DPSMateDeaths[1][ownerid] then
			DPSMateDeaths[1][ownerid] = {}
		end
		if not DPSMateDeaths[1][ownerid][cat] then
			DPSMateDeaths[1][ownerid][cat] = {
				i = 0,
			}
		end
		DPSMateDeaths[1][ownerid][cat]["i"] = tonumber(v1)
	end
end

function DPSMate.Sync:DeathsIn(arg2, arg4)
	for cat,ca,ta,ab,v1,v2,v3 in string.gfind(arg2, "(.+),(.+),(.+),(.+),(.+),(.+),(.+)") do 
		cat = tonumber(cat)
		ca = tonumber(ca)
		DPSMate.DB:BuildUser(arg4, nil)
		local ownerid = DPSMateUser[arg4][1]
		DPSMate.DB:BuildUser(ta, nil)
		local tarid = DPSMateUser[ta][1]
		DPSMate.DB:BuildAbility(ab, nil)
		local abilityid = DPSMateAbility[ab][1]
		if not DPSMateDeaths[1][ownerid] then
			DPSMateDeaths[1][ownerid] = {}
		end
		if not DPSMateDeaths[1][ownerid][cat] then
			DPSMateDeaths[1][ownerid][cat] = {
				i = 0,
			}
		end
		if not DPSMateDeaths[1][ownerid][cat][ca] then
			DPSMateDeaths[1][ownerid][cat][ca] = {}
		end
		DPSMateDeaths[1][ownerid][cat][ca] = {
			[1] = tarid,
			[2] = abilityid,
			[3] = tonumber(v1),
			[4] = tonumber(v2),
			[5] = tonumber(v3),
		}
		DPSMate.DB.NeedUpdate = true
	end
end

----------------------------------------------------------------------------------
--------------                     Interrupts                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:InterruptsAllIn(arg2, arg4)
	for oc,v1 in string.gfind(arg2, "(.+),(.+),(.+)") do 
		DPSMate.DB:BuildUser(arg4, oc)
		local ownerid = DPSMateUser[arg4][1]
		DPSMateInterrupts[1][ownerid] = {
			i = tonumber(v1),
		}
		DPSMate.DB.NeedUpdate = true
	end
end

function DPSMate.Sync:InterruptsAbilityIn(arg2, arg4)
	for cat,ca,c,v in string.gfind(arg2, "(.+),(.+),(.+),(.+)") do 
		DPSMate.DB:BuildUser(arg4, oc)
		local ownerid = DPSMateUser[arg4][1]
		DPSMate.DB:BuildUser(ca, nil)
		local tarid = DPSMateUser[ca][1]
		DPSMate.DB:BuildAbility(cat, nil)
		local cabilityid = DPSMateAbility[cat][1]
		DPSMate.DB:BuildAbility(c, nil)
		local tabilityid = DPSMateAbility[c][1]
		if not DPSMateInterrupts[1][ownerid] then
			DPSMateInterrupts[1][ownerid] = {
				i = 0,
			}
		end
		if not DPSMateInterrupts[1][ownerid][cabilityid] then
			DPSMateInterrupts[1][ownerid][cabilityid] = {}
		end
		if not DPSMateInterrupts[1][ownerid][cabilityid][tarid] then
			DPSMateInterrupts[1][ownerid][cabilityid][tarid] = {}
		end
		DPSMateInterrupts[1][ownerid][cabilityid][tarid][tabilityid] = tonumber(v)
	end
end

----------------------------------------------------------------------------------
--------------                        Dispels                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DispelsIn(arg2, arg4)
	-- Ability, Target, Ability, val
	for a, ta, a2, v1 in string.gfind(arg2, "(.+),(.+),(.+),(.+)") do
		DPSMate.DB:BuildAbility(a, nil)
		local abilityid = DPSMateAbility[a][1]
		DPSMate.DB:BuildAbility(a2, nil)
		local abilityid2 = DPSMateAbility[a2][1]
		DPSMate.DB:BuildUser(arg4, nil)
		local pid = DPSMateUser[arg4][1]
		DPSMate.DB:BuildUser(ta, nil)
		local tarid = DPSMateUser[ta][1]
		if not DPSMateDispels[1][pid] then
			DPSMateDispels[1][pid] = {
				i = 0,
			}
		end
		if not DPSMateDispels[1][pid][abilityid] then
			DPSMateDispels[1][pid][abilityid] = {}
		end
		if not DPSMateDispels[1][pid][abilityid][tarid] then
			DPSMateDispels[1][pid][abilityid][tarid] = {}
		end
		if not DPSMateDispels[1][pid][abilityid][tarid][abilityid2] then
			DPSMateDispels[1][pid][abilityid][tarid][abilityid2] = 0
		end
		DPSMateDispels[1][pid][abilityid][tarid][abilityid2] = tonumber(v1)
	end
end

function DPSMate.Sync:iDispelsIn(arg2, arg4)
	DPSMate.DB:BuildUser(arg4, nil)
	local pid = DPSMateUser[arg4][1]
	DPSMateDispels[1][pid] = {}
	-- Ability, val
	for a, v1 in string.gfind(arg2, "(.+),(.+)") do
		DPSMate.DB:BuildAbility(a, nil)
		local abilityid = DPSMateAbility[a][1]
		if not DPSMateDispels[1][pid] then
			DPSMateDispels[1][pid] = {
				i = 0,
			}
		end
		DPSMateDispels[1][pid]["i"] = tonumber(v1)
		DPSMate.DB.NeedUpdate = true
	end
end

----------------------------------------------------------------------------------
--------------                        Auras                         --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:AurasAllIn(arg2, arg4)
	for a,b in string.gfind(arg2, "(.+),(.+)") do
		DPSMate.DB:BuildUser(arg4, nil)
		local pid = DPSMateUser[arg4][1]
		DPSMateAurasGained[1][pid] = {}
		DPSMate.DB:BuildAbility(a, nil)
		local abilityid = DPSMateAbility[a][1]
		if not DPSMateAurasGained[1][pid][abilityid] then
			DPSMateAurasGained[1][pid][abilityid] = {
				[1] = {},
				[2] = {},
				[3] = {},
				[4] = false,
			}
		end
		if tonumber(b)==1 then
			DPSMateAurasGained[1][pid][abilityid][4] = true
		end
	end
end

function DPSMate.Sync:AurasStartEndIn(arg2, arg4, prefix)
	for a,b,c in string.gfind(arg2, "(.+),(.+),(.+)") do
		local pid = DPSMateUser[arg4][1]
		local abilityid = DPSMateAbility[a][1]
		DPSMateAurasGained[1][pid][abilityid][prefix][tonumber(b)] = tonumber(c)
	end
end

function DPSMate.Sync:AurasCauseIn(arg2, arg4)
	for a,b,c in string.gfind(arg2, "(.+),(.+),(.+)") do
		local pid = DPSMateUser[arg4][1]
		local abilityid = DPSMateAbility[a][1]
		DPSMate.DB:BuildUser(b, nil)
		local causeid = DPSMateUser[b][1]
		DPSMateAurasGained[1][pid][abilityid][3][causeid] = tonumber(c)
	end
end

----------------------------------------------------------------------------------
--------------                       SYNC OUT                       --------------                                  
----------------------------------------------------------------------------------

-- Hooking useaction function in order to get the owner of the spell.
DPSMate.Parser.oldUseAction = UseAction
DPSMate.Parser.UseAction = function(slot, checkCursor, onSelf)
	DPSMate_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	DPSMate_Tooltip:ClearLines()
	DPSMate_Tooltip:SetAction(slot)
	local aura = DPSMate_TooltipTextLeft1:GetText()
	DPSMate_Tooltip:Hide()
	if aura then
		local target, time = nil, GetTime()
		if not UnitName("target") or not UnitIsPlayer("target") then target = player.name else target = UnitName("target") end
		
		if DPSMateSettings["sync"] then SendAddonMessage("DPSMate", player.name..","..aura..","..target..","..time, "RAID") end
		
		if DPSMate:TContains(DPSMate.Parser.Kicks, ability) then DPSMate.DB:AwaitAfflictedStun(player.name, aura, target, time) end
		DPSMate.DB:AwaitingBuff(player.name, aura, target, time)
		DPSMate.DB:AwaitingAbsorbConfirmation(player.name, aura, target, time)
	end
	DPSMate.Parser.oldUseAction(slot, checkCursor, onSelf)
end
UseAction = DPSMate.Parser.UseAction

----------------------------------------------------------------------------------
--------------                     DAMAGE DONE                      --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DMGDoneAllOut()
	if DPSMateDamageDone[1][DPSMateUser[player.name][1]] then
		SendAddonMessage("DPSMate_DMGDoneAll", player.class..","..DPSMateDamageDone[1][DPSMateUser[player.name][1]]["i"][2], "RAID")
	end
end

-- I will change the index from 2 to 1 later at the clean up
function DPSMate.Sync:DMGDoneStatOut()
	if not DPSMateDamageDone[1][DPSMateUser[player.name][1]] then return end
	for cat, val in DPSMate.Sync:GetSummarizedTable(DPSMateDamageDone[1][DPSMateUser[player.name][1]]["i"][1]) do
		SendAddonMessage("DPSMate_DMGDoneStat", val[1]..","..val[2], "RAID")
	end
end

function DPSMate.Sync:DMGDoneAbilityOut()
	if not DPSMateDamageDone[1][DPSMateUser[player.name][1]] then return end
	for cat, val in (DPSMateDamageDone[1][DPSMateUser[player.name][1]]) do
		if cat~="i" then
			local ability = DPSMate:GetAbilityById(cat)
			SendAddonMessage("DPSMate_DMGDoneAbility", ability..","..val[1]..","..val[2]..","..val[3], "RAID")
			SendAddonMessage("DPSMate_DMGDoneAbility2", ability..","..ceil(val[4])..","..val[5]..","..val[6], "RAID")
			SendAddonMessage("DPSMate_DMGDoneAbility3", ability..","..val[7]..","..ceil(val[8])..","..val[9], "RAID")
			SendAddonMessage("DPSMate_DMGDoneAbility4", ability..","..val[10]..","..val[11]..","..val[12], "RAID")
			SendAddonMessage("DPSMate_DMGDoneAbility5", ability..","..val[13]..","..val[14]..","..val[15], "RAID")
			SendAddonMessage("DPSMate_DMGDoneAbility6", ability..","..val[16]..","..ceil(val[17])..","..val[18], "RAID")
			SendAddonMessage("DPSMate_DMGDoneAbility7", ability..","..val[19]..","..val[20]..","..ceil(val[21]), "RAID")
		end
	end
end

----------------------------------------------------------------------------------
--------------                    DAMAGE TAKEN                      --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DMGTakenAllOut()
	if not DPSMateDamageTaken[1][DPSMateUser[player.name][1]] then return end
	for cat, val in pairs(DPSMateDamageTaken[1][DPSMateUser[player.name][1]]) do
		if cat~="i" then
			SendAddonMessage("DPSMate_DMGTakenAll", player.class..","..cat..","..val["i"], "RAID")
		end
	end
end

function DPSMate.Sync:DMGTakenStatOut()
	if not DPSMateDamageTaken[1][DPSMateUser[player.name][1]] then return end
	for cat, val in DPSMate.Sync:GetSummarizedTable(DPSMateDamageTaken[1][DPSMateUser[player.name][1]]["i"]) do
		SendAddonMessage("DPSMate_DMGTakenStat", val[1]..","..val[2], "RAID")
	end
end

function DPSMate.Sync:DMGTakenAbilityOut()
	if not DPSMateDamageTaken[1][DPSMateUser[player.name][1]] then return end
	for cat, val in (DPSMateDamageTaken[1][DPSMateUser[player.name][1]]) do
		if cat~="i" then
			for ca, va in pairs(val) do
				if ca~="i" then
					local ability = DPSMate:GetAbilityById(ca)
					local target = DPSMate:GetUserById(cat)
					SendAddonMessage("DPSMate_DMGTakenAbility", target..","..ability..","..va[1]..","..va[2]..","..va[3], "RAID")
					SendAddonMessage("DPSMate_DMGTakenAbility2", target..","..ability..","..ceil(va[4])..","..va[5]..","..va[6], "RAID")
					SendAddonMessage("DPSMate_DMGTakenAbility3", target..","..ability..","..va[7]..","..ceil(va[8])..","..va[9], "RAID")
					SendAddonMessage("DPSMate_DMGTakenAbility4", target..","..ability..","..va[10]..","..va[11]..","..va[12], "RAID")
					SendAddonMessage("DPSMate_DMGTakenAbility5", target..","..ability..","..va[13]..","..ceil(va[14])..","..va[15], "RAID")
					SendAddonMessage("DPSMate_DMGTakenAbility6", target..","..ability..","..va[16]..","..va[17]..","..ceil(va[18]), "RAID")
				end
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                 ENEMY DAMAGE TAKEN                   --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:EDAllOut(arr, prefix)
	local pid = DPSMateUser[player.name][1]
	for cat, val in pairs(arr[1]) do
		if val[pid] then
			SendAddonMessage("DPSMate_ED"..prefix.."All", player.class..","..DPSMate:GetUserById(cat)..","..val[pid]["i"][2], "RAID")
		end
	end
end

function DPSMate.Sync:EDAbilityOut(arr, prefix)
	local pid = DPSMateUser[player.name][1]
	for cat, val in (arr[1]) do
		if val[pid] then
			for ca, va in pairs(val[pid]) do
				if ca~="i" then
					SendAddonMessage("DPSMate_ED"..prefix.."Ability", DPSMate:GetUserById(cat)..","..DPSMate:GetAbilityById(ca)..","..va[1]..","..va[2]..","..va[3]..","..ceil(va[4])..","..va[5]..","..va[6]..","..va[7]..","..ceil(va[8])..","..va[9]..","..va[10]..","..va[11]..","..va[12]..","..va[13], "RAID")
				end
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                       Healing                        --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:HealingAllOut(arr, prefix)
	if arr[1][DPSMateUser[player.name][1]] then
		SendAddonMessage("DPSMate_"..prefix.."HealingAll", player.class..","..arr[1][DPSMateUser[player.name][1]]["i"][1], "RAID")
	end
end

function DPSMate.Sync:HealingAbilityOut(arr, prefix)
	if not arr[1][DPSMateUser[player.name][1]] then return end
	for cat, val in (arr[1][DPSMateUser[player.name][1]]) do
		if cat~="i" then
			for ca, va in pairs(val) do
				SendAddonMessage("DPSMate_"..prefix.."HealingAbility", DPSMate:GetAbilityById(cat)..","..DPSMate:GetUserById(ca)..","..va[1]..","..va[2]..","..va[3]..","..ceil(va[4])..","..va[5]..","..va[6], "RAID")
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                    Healing taken                     --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:HealingTakenAllOut(arr, prefix)
	if arr[1][DPSMateUser[player.name][1]] then
		SendAddonMessage("DPSMate_"..prefix.."HealingTakenAll", player.class..","..arr[1][DPSMateUser[player.name][1]]["i"], "RAID")
	end
end

function DPSMate.Sync:HealingTakenAbilityOut(arr, prefix)
	if not arr[1][DPSMateUser[player.name][1]] then return end
	for cat, val in (arr[1][DPSMateUser[player.name][1]]) do
		if cat~="i" then
			for ca, va in pairs(val) do
				SendAddonMessage("DPSMate_"..prefix.."HealingTakenAbility", DPSMate:GetUserById(cat)..","..DPSMate:GetAbilityById(ca)..","..va[1]..","..va[2]..","..va[3]..","..ceil(va[4])..","..va[5]..","..va[6], "RAID")
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                        Absorbs                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:AbsorbsOut() 
	if not DPSMateAbsorbs[1][DPSMateUser[player.name][1]] then return end
	for cat, val in pairs(DPSMateAbsorbs[1][DPSMateUser[player.name][1]]) do -- owner
		for ca, va in pairs(val) do -- ability
			for c, v in pairs(va) do -- each one
				for ce, ve in pairs(v) do -- enemy
					if ce=="i" then
						SendAddonMessage("DPSMate_iAbsorbs", DPSMate:GetUserById(cat)..","..DPSMate:GetAbilityById(ca)..","..c..","..ve[1]..","..ve[2], "RAID")
					else
						SendAddonMessage("DPSMate_Absorbs", DPSMate:GetUserById(cat)..","..DPSMate:GetAbilityById(ca)..","..c..","..DPSMate:GetUserById(ce)..","..ve[1]..","..ve[2], "RAID")
					end
				end
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                        Deaths                        --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DeathsAllOut()
	if not DPSMateDeaths[1][DPSMateUser[player.name][1]] then return end
	for cat, val in pairs(DPSMateDeaths[1][DPSMateUser[player.name][1]]) do -- death count
		SendAddonMessage("DPSMate_DeathsAll", player.class..","..cat..","..val["i"], "RAID")
	end
end

function DPSMate.Sync:DeathsOut()
	if not DPSMateDeaths[1][DPSMateUser[player.name][1]] then return end
	for cat, val in pairs(DPSMateDeaths[1][DPSMateUser[player.name][1]]) do -- death count
		for ca, va in pairs(val) do -- each part
			if ca~="i" then -- Testing if this prevents the error
				SendAddonMessage("DPSMate_Deaths", cat..","..ca..","..DPSMate:GetUserById(va[1])..","..DPSMate:GetAbilityById(va[2])..","..va[3]..","..va[4]..","..va[5], "RAID")
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                     Interrupts                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:InterruptsAllOut()
	if DPSMateInterrupts[1][DPSMateUser[player.name][1]] then
		SendAddonMessage("DPSMate_InterruptsAll", player.class..","..DPSMateInterrupts[1][DPSMateUser[player.name][1]]["i"], "RAID")
	end
end

function DPSMate.Sync:InterruptsAbilityOut()
	if not DPSMateInterrupts[1][DPSMateUser[player.name][1]] then return end
	for cat, val in pairs(DPSMateInterrupts[1][DPSMateUser[player.name][1]]) do
		if cat~="i" then
			for ca, va in pairs(val) do
				for c, v in pairs(va) do
					SendAddonMessage("DPSMate_InterruptsAbility", DPSMate:GetAbilityById(cat)..","..DPSMate:GetUserById(ca)..","..DPSMate:GetAbilityById(c)..","..v, "RAID")
				end
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                        Dispels                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DispelsOut()
	if not DPSMateDispels[1][DPSMateUser[player.name][1]] then return end
	for cat, val in pairs(DPSMateDispels[1][DPSMateUser[player.name][1]]) do -- Ability
		if cat=="i" then
			SendAddonMessage("DPSMate_iDispels", DPSMate:GetAbilityById(cat)..","..val["i"], "RAID")
		else
			for ca, va in pairs(val) do -- Target
				for c, v in pairs(v) do -- Ability
					SendAddonMessage("DPSMate_Dispels", DPSMate:GetAbilityById(cat)..","..DPSMate:GetUserById(ca)..","..DPSMate:GetAbilityById(c)..","..v, "RAID")
				end
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                        Auras                         --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:AurasOut()
	if not DPSMateAurasGained[1][DPSMateUser[player.name][1]] then return end
	local p = 0
	for cat, val in pairs(DPSMateAurasGained[1][DPSMateUser[player.name][1]]) do -- ability
		if val[4] then p = 1 end
		local ability = DPSMate:GetAbilityById(cat)
		SendAddonMessage("DPSMate_AurasAll", ability..","..p, "RAID")
		for ca, va in pairs(val[1]) do
			SendAddonMessage("DPSMate_AurasStart", ability..","..ca..","..va, "RAID")
		end
		for ca, va in pairs(val[2]) do
			SendAddonMessage("DPSMate_AurasEnd", ability..","..ca..","..va, "RAID")
		end
		for ca, va in pairs(val[3]) do
			SendAddonMessage("DPSMate_AurasCause", ability..","..DPSMate:GetUserById(ca)..","..va, "RAID")
		end
	end
end