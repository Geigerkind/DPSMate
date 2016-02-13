-- Global Variables
DPSMate.Modules.DetailsHealingAndAbsorbs = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailUser, Details_HealingAndAbsorbsSelected  = {}, 0, {}, "", 1
local PieChart = true
local g, g2
local icons = {
	-- General
	["AutoAttack"] = "Interface\\ICONS\\inv_sword_39",
	["Lightning Strike"] = "Interface\\ICONS\\spell_holy_mindvision",
	["Fatal Wound"] = "Interface\\ICONS\\ability_backstab",
	["Falling"] = "Interface\\ICONS\\spell_magic_featherfall",
	["Thorium Grenade"] = "Interface\\ICONS\\inv_misc_bomb_08",
	["Crystal Charge"] = "Interface\\ICONS\\inv_misc_gem_opal_01",
	["Shoot Bow"] = "Interface\\ICONS\\ability_marksmanship",
	
	-- Rogues
	["Sinister Strike"] = "Interface\\ICONS\\spell_shadow_ritualofsacrifice",
	["Blade Flurry"] = "Interface\\ICONS\\ability_warrior_punishingblow",
	["Eviscerate"] = "Interface\\ICONS\\ability_rogue_eviscerate",
	["Garrote(Periodic)"] = "Interface\\ICONS\\ability_rogue_garrote",
	["Rupture(Periodic)"] = "Interface\\ICONS\\ability_rogue_rupture",
	["Instant Poison VI"] = "Interface\\ICONS\\ability_poisons", 
	["Instant Poison V"] = "Interface\\ICONS\\ability_poisons", 
	["Instant Poison IV"] = "Interface\\ICONS\\ability_poisons", 
	["Instant Poison III"] = "Interface\\ICONS\\ability_poisons", 
	["Instant Poison II"] = "Interface\\ICONS\\ability_poisons", 
	["Instant Poison I"] = "Interface\\ICONS\\ability_poisons", 
	["Kick"] = "Interface\\ICONS\\ability_kick", 
	
}
local curKey = 1
local db, cbt = {}, 0

function DPSMate.Modules.DetailsHealingAndAbsorbs:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DPSMate_Details_HealingAndAbsorbs.proc = "None"
	UIDropDownMenu_SetSelectedValue(DPSMate_Details_HealingAndAbsorbs_DiagramLegend_Procs, "None")
	if (PieChart) then
		g=DPSMate.Options.graph:CreateGraphPieChart("PieChart", DPSMate_Details_HealingAndAbsorbs_Diagram, "CENTER", "CENTER", 0, 0, 200, 200)
		g2=DPSMate.Options.graph:CreateGraphLine("LineGraph",DPSMate_Details_HealingAndAbsorbs_DiagramLine,"CENTER","CENTER",0,0,850,230)
		PieChart = false
	end
	DetailsUser = obj.user
	DPSMate_Details_HealingAndAbsorbs_Title:SetText("Healing and Absorbs by "..obj.user)
	DPSMate_Details_HealingAndAbsorbs:Show()
	UIDropDownMenu_Initialize(DPSMate_Details_HealingAndAbsorbs_DiagramLegend_Procs, DPSMate.Modules.DetailsHealingAndAbsorbs.ProcsDropDown)
	DPSMate.Modules.DetailsHealingAndAbsorbs:ScrollFrame_Update()
	DPSMate.Modules.DetailsHealingAndAbsorbs:SelectDetails_HealingAndAbsorbsButton(1)
	DPSMate.Modules.DetailsHealingAndAbsorbs:UpdatePie()
	DPSMate.Modules.DetailsHealingAndAbsorbs:UpdateLineGraph()
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:ScrollFrame_Update()
	local line, lineplusoffset
	local obj = getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollFrame")
	local arr = db
	local len = DPSMate:TableLength(arr[DPSMateUser[DetailsUser][1]])-5
	DetailsArr, DetailsTotal, DmgArr = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[DetailsUser], curKey)
	FauxScrollFrame_Update(obj,DPSMate:TableLength(arr),10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DetailsArr[lineplusoffset])
			getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollButton"..line.."_Name"):SetText(ability)
			getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollButton"..line.."_Value"):SetText(DmgArr[lineplusoffset][1].." ("..string.format("%.2f", (DmgArr[lineplusoffset][1]*100/DetailsTotal)).."%)")
			if icons[ability] then
				getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollButton"..line.."_Icon"):SetTexture(icons[ability])
			else
				getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
			end
			if len < 10 then
				getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollButton"..line):SetWidth(235)
				getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollButton"..line.."_Name"):SetWidth(125)
			else
				getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollButton"..line):SetWidth(220)
				getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollButton"..line.."_Name"):SetWidth(110)
			end
			getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollButton"..line):Show()
		else
			getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollButton"..line):Hide()
		end
		getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollButton"..line.."_selected"):Hide()
		if Details_HealingAndAbsorbsSelected == lineplusoffset then
			getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollButton"..line.."_selected"):Show()
		end
	end
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:SelectDetails_HealingAndAbsorbsButton(i)
	local obj = getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollFrame")
	local lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
	local arr = DPSMateEHealing[curKey]
	local user = DPSMateUser[DetailsUser][1]
	
	Details_HealingAndAbsorbsSelected = lineplusoffset
	for p=1, 10 do
		getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollButton"..p.."_selected"):Hide()
	end
	
	getglobal("DPSMate_Details_HealingAndAbsorbs_Log_ScrollButton"..i.."_selected"):Show()
	
	local ability = tonumber(DetailsArr[lineplusoffset])
	local hit, crit, hitav, critav, hitMin, hitMax, critMin, critMax, total, max = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	if DmgArr[lineplusoffset][2] then
		for cat, val in db do 
			for ca, va in val do
				if ca == DPSMateUser[DetailsUser][1] then
					for c, v in va[ability] do
						for ce, ve in v do
							local dmg = 5
							if ce=="i" then
								dmg = ve[2]
							else
								if DPSMateDamageTaken[1][cat][ce][ve[1]] then
									dmg = ceil(DPSMateDamageTaken[1][cat][ce][ve[1]][14]*ve[2])
								end
							end
							if dmg>hitMax then hitMax = dmg end
							if dmg<hitMin or hitMin == 0 then hitMin = dmg end
							hitav = (hitav+dmg)/2
							hit=hit+1
						end
					end
				end
			end
		end
		total, max = hit, hit
	else
		local path = arr[user][ability]
		hit, crit, hitav, critav, hitMin, hitMax, critMin, critMax = path[2], path[3], path[4], path[5], path[6], path[7], path[8], path[9]
		total, max = hit+crit, DPSMate:TMax({hit, crit})
	end
	
	-- Hit
	getglobal("DPSMate_Details_HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount0_Amount"):SetText(hit)
	getglobal("DPSMate_Details_HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount0_Percent"):SetText(ceil(100*hit/total).."%")
	getglobal("DPSMate_Details_HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount0_StatusBar"):SetValue(ceil(100*hit/max))
	getglobal("DPSMate_Details_HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount0_StatusBar"):SetStatusBarColor(0.3,0.7,1.0,1)
	getglobal("DPSMate_Details_HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Average0"):SetText(ceil(hitav))
	getglobal("DPSMate_Details_HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Min0"):SetText(hitMin)
	getglobal("DPSMate_Details_HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Max0"):SetText(hitMax)
	
	-- Crit
	getglobal("DPSMate_Details_HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount1_Amount"):SetText(crit)
	getglobal("DPSMate_Details_HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount1_Percent"):SetText(ceil(100*crit/total).."%")
	getglobal("DPSMate_Details_HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount1_StatusBar"):SetValue(ceil(100*crit/max))
	getglobal("DPSMate_Details_HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount1_StatusBar"):SetStatusBarColor(1.0,0.7,0.3,1)
	getglobal("DPSMate_Details_HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Average1"):SetText(ceil(critav))
	getglobal("DPSMate_Details_HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Min1"):SetText(critMin)
	getglobal("DPSMate_Details_HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Max1"):SetText(critMax)
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:UpdatePie()
	local arr = DPSMateEHealing[curKey]
	g:ResetPie()
	for cat, val in pairs(DmgArr) do
		g:AddPie(val[1]*100/DetailsTotal, 0)
	end
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:UpdateLineGraph()
	local sumTable = DPSMate.Modules.DetailsHealingAndAbsorbs:GetSummarizedTable()
	local max = DPSMate.Modules.DetailsHealingAndAbsorbs:GetMaxLineVal(sumTable, 2)
	local time = DPSMate.Modules.DetailsHealingAndAbsorbs:GetMaxLineVal(sumTable, 1)

	g2:ResetData()
	g2:SetXAxis(0,time)
	g2:SetYAxis(0,max+200)
	g2:SetGridSpacing(time/10,max/7)
	g2:SetGridColor({0.5,0.5,0.5,0.5})
	g2:SetAxisDrawing(true,true)
	g2:SetAxisColor({1.0,1.0,1.0,1.0})
	g2:SetAutoScale(true)
	g2:SetYLabels(true, false)
	g2:SetXLabels(true)

	local Data1={{0,0}}
	for cat, val in pairs(sumTable) do
		table.insert(Data1, {val[1],val[2], DPSMate.Modules.DetailsHealingAndAbsorbs:CheckProcs(DPSMate_Details_HealingAndAbsorbs.proc, val[1])})
	end

	g2:AddDataSeries(Data1,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, DPSMate.Modules.DetailsHealingAndAbsorbs:AddProcPoints(DPSMate_Details_HealingAndAbsorbs.proc, Data1))
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:CreateGraphTable()
	local lines = {}
	for i=1, 8 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(DPSMate_Details_HealingAndAbsorbs_Log, 252, 270-i*30, 617, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[9] = DPSMate.Options.graph:DrawLine(DPSMate_Details_HealingAndAbsorbs_Log, 302, 260, 302, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(DPSMate_Details_HealingAndAbsorbs_Log, 437, 260, 437, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(DPSMate_Details_HealingAndAbsorbs_Log, 497, 260, 497, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
	
	lines[12] = DPSMate.Options.graph:DrawLine(DPSMate_Details_HealingAndAbsorbs_Log, 557, 260, 557, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:ProcsDropDown()
	local arr = DPSMate.Modules.DetailsHealingAndAbsorbs:GetAuraGainedArr(curKey)
	DPSMate_Details_HealingAndAbsorbs.proc = "None"
	
    local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_Details_HealingAndAbsorbs_DiagramLegend_Procs, this.value)
		DPSMate_Details_HealingAndAbsorbs.proc = this.value
		DPSMate.Modules.DetailsHealingAndAbsorbs:UpdateLineGraph()
    end
	
	UIDropDownMenu_AddButton{
		text = "None",
		value = "None",
		func = on_click,
	}
	
	-- Adding dynamic channel
	if arr[DPSMateUser[DetailsUser][1]] then
		for cat, val in pairs(arr[DPSMateUser[DetailsUser][1]]) do
			local ability = DPSMate:GetAbilityById(cat)
			if DPSMate:TContains(DPSMate.Parser.procs, ability) then
				UIDropDownMenu_AddButton{
					text = ability,
					value = cat,
					func = on_click,
				}
			end
		end
	end
	
	if DPSMate_Details_HealingAndAbsorbs.LastUser~=DetailsUser then
		UIDropDownMenu_SetSelectedValue(DPSMate_Details_HealingAndAbsorbs_DiagramLegend_Procs, "None")
	end
	DPSMate_Details_HealingAndAbsorbs.LastUser = DetailsUser
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:SortLineTable()
	local newArr = {}
	for cat, val in pairs(DPSMateAbsorbs[curKey]) do
		if val[DPSMateUser[DetailsUser][1]] then
			for ca, va in pairs(val[DPSMateUser[DetailsUser][1]]["i"]) do
				local i, dmg = 1, 5
				if va[4] then
					dmg = va[4]
				elseif DPSMateDamageTaken[1][DPSMateUser[DetailsUser][1]][va[2]][va[3]][14] then
					dmg = DPSMateDamageTaken[1][DPSMateUser[DetailsUser][1]][va[2]][va[3]][14]
				end
				if dmg>0 then
					while true do
						if (not newArr[i]) then
							table.insert(newArr, i, {va[1], dmg})
							break
						else
							if newArr[i][1] > va[1] then
								table.insert(newArr, i, {va[1], dmg})
								break
							end
						end
						i=i+1
					end
				end
			end
		end
	end
	for cat, val in DPSMateEHealing[curKey][DPSMateUser[DetailsUser][1]]["i"][2] do
		local i = 1
		while true do
			if (not newArr[i]) then
				table.insert(newArr, i, val)
				break
			else
				if newArr[i][1] > val[1] then
					table.insert(newArr, i, val)
					break
				end
			end
			i=i+1
		end
	end
	return newArr
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:GetSummarizedTable()
	return DPSMate.Sync:GetSummarizedTable(DPSMate.Modules.DetailsHealingAndAbsorbs:SortLineTable())
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:GetMaxLineVal(t, p)
	local max = 0
	for cat, val in pairs(t) do
		if val[p]>max then
			max=val[p]
		end
	end
	return max
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:GetAuraGainedArr(k)
	local modes = {["total"]=1,["currentfight"]=2}
	for cat, val in pairs(DPSMateSettings["windows"][k]["options"][2]) do
		if val then
			if strfind(cat, "segment") then
				local num = tonumber(strsub(cat, 8))
				return DPSMateHistory["Auras"][num]
			else
				return DPSMateAurasGained[modes[cat]]
			end
		end
	end
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:CheckProcs(name, val)
	local arr = DPSMate.Modules.DetailsHealingAndAbsorbs:GetAuraGainedArr(curKey)
	if arr[DPSMateUser[DetailsUser][1]] then
		if arr[DPSMateUser[DetailsUser][1]][name] then
			for i=1, DPSMate:TableLength(arr[DPSMateUser[DetailsUser][1]][name][1]) do
				if not arr[DPSMateUser[DetailsUser][1]][name][1][i] or not arr[DPSMateUser[DetailsUser][1]][name][2][i] or arr[DPSMateUser[DetailsUser][1]][name][4] then return false end
				if val > arr[DPSMateUser[DetailsUser][1]][name][1][i] and val < arr[DPSMateUser[DetailsUser][1]][name][2][i] then
					return true
				end
			end
		end
	end
	return false
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:AddProcPoints(name, dat)
	local bool, data, LastVal = false, {}, 0
	local arr = DPSMate.Modules.DetailsHealingAndAbsorbs:GetAuraGainedArr(curKey)
	if arr[DPSMateUser[DetailsUser][1]] then
		if arr[DPSMateUser[DetailsUser][1]][name] then
			if arr[DPSMateUser[DetailsUser][1]][name][4] then
				for cat, val in pairs(dat) do
					for i=1, DPSMate:TableLength(arr[DPSMateUser[DetailsUser][1]][name][1]) do
						if arr[DPSMateUser[DetailsUser][1]][name][1][i]<=val[1] then
							local tempbool = true
							for _, va in pairs(data) do
								if va[1] == arr[DPSMateUser[DetailsUser][1]][name][1][i] then
									tempbool = false
									break
								end
							end
							if tempbool then	
								bool = true
								table.insert(data, {arr[DPSMateUser[DetailsUser][1]][name][1][i], LastVal, {val[1], val[2]}})
							end
						end
					end
					LastVal = {val[1], val[2]}
				end
			end
		end
	end
	return {bool, data}
end


