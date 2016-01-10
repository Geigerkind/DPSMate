-- Global Variables

-- Local Variables
local player = {}
player["name"] = UnitName("player")
local a,b = UnitClass("player")
player["class"] = strlower(b)

-- Beginn Functions

function DPSMate.Sync:OnUpdate()
	if DPSMate.DB.loaded then
		DPSMate.Sync:DMGDoneAllOut()
		DPSMate.Sync:DMGDoneStatOut()
		DPSMate.Sync:DMGDoneAbilityOut()
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
		if not DPSMateDamageDone[1][ownerid] then
			DPSMateDamageDone[1][ownerid] = {
				i = {
					[2] = {},
					[3] = 0,
				},
			}
		end
		DPSMateDamageDone[1][ownerid]["i"][3] = tonumber(am)
		DPSMate.DB.NeedUpdate = true
	end
end

-- Here are many redundant points added most likely
function DPSMate.Sync:DMGDoneStatIn(arg2, arg4)
	for key, val in string.gfind(arg2, "(.+),(.+)") do
		DPSMate.DB:BuildUser(arg4, nil)
		local ownerid = DPSMateUser[arg4][1]
		if not DPSMateDamageDone[1][ownerid] then
			DPSMateDamageDone[1][ownerid] = {
				i = {
					[2] = {},
					[3] = 0,
				},
			}
		end
		DPSMateDamageDone[1][ownerid]["i"][2][tonumber(key)] = tonumber(val)
	end
end

function DPSMate.Sync:DMGDoneAbilityIn(arg2, arg4)
	-- ability, a1, b1, a2, b2 etc
	for a,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13 in string.gfind(arg2, "(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+)") do 
		-- Check if user exist if not, create him
		DPSMate.DB:BuildUser(arg4, nil)
		local ownerid = DPSMateUser[arg4][1]
		DPSMate.DB:BuildAbility(a, nil)
		local abilityid = DPSMateAbility[a][1]
		if not DPSMateDamageDone[1][ownerid] then
			DPSMateDamageDone[1][ownerid] = {
				i = {
					[2] = {},
					[3] = 0,
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
		DPSMate.DB.NeedUpdate = true
	end
end


----------------------------------------------------------------------------------
--------------                       SYNC OUT                       --------------                                  
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--------------                     DAMAGE DONE                      --------------                                  
----------------------------------------------------------------------------------

function DPSMate.Sync:DMGDoneAllOut()
	if DPSMateDamageDone[1][DPSMateUser[player.name][1]] then
		SendAddonMessage("DPSMate_DMGDoneAll", player.class..","..DPSMateDamageDone[1][DPSMateUser[player.name][1]]["i"][3], "RAID")
	end
end

-- I will change the index from 2 to 1 later at the clean up
function DPSMate.Sync:DMGDoneStatOut()
	if not DPSMateDamageDone[1][DPSMateUser[player.name][1]] then return end
	for cat, val in (DPSMateDamageDone[1][DPSMateUser[player.name][1]]["i"][2]) do
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
