-- Global Variables
DPSMate.Sync.Async = false

-- Local Variables
local player = {}
player["name"] = UnitName("player")
local a,b = UnitClass("player")
player["class"] = strlower(b)
local time = 0
local iterator = 1

-- Beginn Functions

function DPSMate.Sync:OnUpdate(elapsed)
	if DPSMate.DB.loaded then
		time=time+elapsed
		if iterator==1 then
			DPSMate.Sync:DMGDoneAllOut()
			DPSMate.Sync:DMGDoneStatOut()
			DPSMate.Sync:DMGDoneAbilityOut()
			iterator = 2
		elseif time>=3 and iterator==2 then
			DPSMate.Sync:HealingAllOut(DPSMateEHealing, "E")
			DPSMate.Sync:HealingAbilityOut(DPSMateEHealing, "E")
			iterator = 3
		elseif time>=6 and iterator==3 then
			DPSMate.Sync:HealingAllOut(DPSMateTHealing, "T")
			DPSMate.Sync:HealingAbilityOut(DPSMateTHealing, "T")
			iterator = 4
		elseif time>=9 and iterator==4 then
			DPSMate.Sync:HealingAllOut(DPSMateOverhealing, "O")
			DPSMate.Sync:HealingAbilityOut(DPSMateOverhealing, "O")
			iterator = 5
		elseif time>=12 and iterator==5 then
			DPSMate.Sync:AbsorbsOut() 
			DPSMate.Sync:DispelsOut()
			DPSMate.Sync.Async = false
			iterator = 1
			time = 0
		end
	end
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
				DPSMate.DB:AwaitingBuff(owner, ability, abilityTarget, time)
				DPSMate.DB:AwaitingAbsorbConfirmation(owner, ability, abilityTarget, time)
			elseif arg1 == "DPSMate_DMGDoneAll" then
				DPSMate.Sync:DMGDoneAllIn(arg2, arg4)
			elseif arg1 == "DPSMate_DMGDoneStat" then
				DPSMate.Sync:DMGDoneStatIn(arg2, arg4)
			elseif arg1 == "DPSMate_DMGDoneAbility" then
				DPSMate.Sync:DMGDoneAbilityIn(arg2, arg4)
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
			elseif arg1 == "DPSMate_Absorbs" then
				DPSMate.Sync:AbsorbsIn(arg2, arg4) 
			elseif arg1 == "DPSMate_iAbsorbs" then
				DPSMate.Sync:iAbsorbsIn(arg2, arg4) 
			elseif arg1 == "DPSMate_Dispels" then
				DPSMate.Sync:DispelsIn(arg2, arg4) 
			elseif arg1 == "DPSMate_iDispels" then
				DPSMate.Sync:iDispelsIn(arg2, arg4) 
			end
		end
	end
end

----------------------------------------------------------------------------------
--------------                    DAMAGE DONE                       --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DMGDoneAllIn(arg2, arg4)
	DPSMate.DB:BuildUser(arg4, oc)
	local ownerid = DPSMateUser[arg4][1]
	DPSMateDamageDone[1][ownerid] = {}
	for oc, am in string.gfind(arg2, "(.+),(.+)") do
		if not DPSMateDamageDone[1][ownerid] then
			DPSMateDamageDone[1][ownerid] = {
				i = {
					[1] = {},
					[2] = 0,
				},
			}
		end
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

function DPSMate.Sync:DMGDoneAbilityIn(arg2, arg4)
	-- ability, a1, b1, a2, b2 etc
	for a,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13 in string.gfind(arg2, "(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+)") do 
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
		DPSMateDamageDone[1][ownerid][abilityid] = {
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
	DPSMate.DB:BuildUser(arg4, oc)
	local ownerid = DPSMateUser[arg4][1]
	arr[1][ownerid] = {}
	for oc, am in string.gfind(arg2, "(.+),(.+)") do
		if not arr[1][ownerid] then
			arr[1][ownerid] = {
				i = {
					[1] = 0,
				},
			}
		end
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
			DPSMate:SendMessage("OVERWRITTEN!")
		end
		DPSMateAbsorbs[1][pid][ownerid][abilityid][tonumber(e)][enemyid] = {
			[1] = tonumber(v1),
			[2] = tonumber(v2),
		}
		DPSMate.DB.NeedUpdate = true
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
	for cat, val in (DPSMateDamageDone[1][DPSMateUser[player.name][1]]["i"][1]) do
		SendAddonMessage("DPSMate_DMGDoneStat", cat..","..val, "RAID")
	end
end

function DPSMate.Sync:DMGDoneAbilityOut()
	if not DPSMateDamageDone[1][DPSMateUser[player.name][1]] then return end
	for cat, val in (DPSMateDamageDone[1][DPSMateUser[player.name][1]]) do
		if cat~="i" then
			SendAddonMessage("DPSMate_DMGDoneAbility", DPSMate:GetAbilityById(cat)..","..val[1]..","..val[2]..","..val[3]..","..ceil(val[4])..","..val[5]..","..val[6]..","..val[7]..","..ceil(val[8])..","..val[9]..","..val[10]..","..val[11]..","..val[12]..","..val[13], "RAID")
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
