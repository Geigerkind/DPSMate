-- Global Variables
DPSMate.Modules.DetailsEHealing = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailUser, Details_EHealingSelected  = {}, 0, {}, "", 1
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

function DPSMate.Modules.DetailsEHealing:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DPSMate_Details_EHealing.proc = "None"
	UIDropDownMenu_SetSelectedValue(DPSMate_Details_EHealing_DiagramLegend_Procs, "None")
	if (PieChart) then
		g=DPSMate.Options.graph:CreateGraphPieChart("PieChart", DPSMate_Details_EHealing_Diagram, "CENTER", "CENTER", 0, 0, 200, 200)
		g2=DPSMate.Options.graph:CreateGraphLine("LineGraph",DPSMate_Details_EHealing_DiagramLine,"CENTER","CENTER",0,0,850,230)
		PieChart = false
	end
	DetailsUser = obj.user
	DPSMate_Details_EHealing_Title:SetText("Effective healing done by "..obj.user)
	DPSMate_Details_EHealing:Show()
	UIDropDownMenu_Initialize(DPSMate_Details_EHealing_DiagramLegend_Procs, DPSMate.Modules.DetailsEHealing.ProcsDropDown)
	DPSMate.Modules.DetailsEHealing:ScrollFrame_Update()
	DPSMate.Modules.DetailsEHealing:SelectDetails_EHealingButton(1)
	DPSMate.Modules.DetailsEHealing:UpdatePie()
	DPSMate.Modules.DetailsEHealing:UpdateLineGraph()
end

function DPSMate.Modules.DetailsEHealing:ScrollFrame_Update()
	local line, lineplusoffset
	local obj = getglobal("DPSMate_Details_EHealing_Log_ScrollFrame")
	local arr = db
	local len = DPSMate:TableLength(arr[DPSMateUser[DetailsUser][1]])-5
	DetailsArr, DetailsTotal, DmgArr = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[DetailsUser], curKey)
	FauxScrollFrame_Update(obj,DPSMate:TableLength(arr),10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DetailsArr[lineplusoffset])
			getglobal("DPSMate_Details_EHealing_Log_ScrollButton"..line.."_Name"):SetText(ability)
			getglobal("DPSMate_Details_EHealing_Log_ScrollButton"..line.."_Value"):SetText(DmgArr[lineplusoffset].." ("..string.format("%.2f", (DmgArr[lineplusoffset]*100/DetailsTotal)).."%)")
			if icons[ability] then
				getglobal("DPSMate_Details_EHealing_Log_ScrollButton"..line.."_Icon"):SetTexture(icons[ability])
			else
				getglobal("DPSMate_Details_EHealing_Log_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
			end
			if len < 10 then
				getglobal("DPSMate_Details_EHealing_Log_ScrollButton"..line):SetWidth(235)
				getglobal("DPSMate_Details_EHealing_Log_ScrollButton"..line.."_Name"):SetWidth(125)
			else
				getglobal("DPSMate_Details_EHealing_Log_ScrollButton"..line):SetWidth(220)
				getglobal("DPSMate_Details_EHealing_Log_ScrollButton"..line.."_Name"):SetWidth(110)
			end
			getglobal("DPSMate_Details_EHealing_Log_ScrollButton"..line):Show()
		else
			getglobal("DPSMate_Details_EHealing_Log_ScrollButton"..line):Hide()
		end
		getglobal("DPSMate_Details_EHealing_Log_ScrollButton"..line.."_selected"):Hide()
		if Details_EHealingSelected == lineplusoffset then
			getglobal("DPSMate_Details_EHealing_Log_ScrollButton"..line.."_selected"):Show()
		end
	end
end

function DPSMate.Modules.DetailsEHealing:SelectDetails_EHealingButton(i)
	local obj = getglobal("DPSMate_Details_EHealing_Log_ScrollFrame")
	local lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
	local arr = db
	local user = DPSMateUser[DetailsUser][1]
	
	Details_EHealingSelected = lineplusoffset
	for p=1, 10 do
		getglobal("DPSMate_Details_EHealing_Log_ScrollButton"..p.."_selected"):Hide()
	end
	-- Performance?
	local ability = tonumber(DetailsArr[lineplusoffset])
	getglobal("DPSMate_Details_EHealing_Log_ScrollButton"..i.."_selected"):Show()
	
	local path = arr[user][ability]
	local hit, crit, hitav, critav, hitMin, hitMax, critMin, critMax = path[2], path[3], path[4], path[5], path[6], path[7], path[8], path[9]
	local total, max = hit+crit, DPSMate:TMax({hit, crit})
	
	-- Hit
	getglobal("DPSMate_Details_EHealing_LogDetails_EHealing_Amount0_Amount"):SetText(hit)
	getglobal("DPSMate_Details_EHealing_LogDetails_EHealing_Amount0_Percent"):SetText(ceil(100*hit/total).."%")
	getglobal("DPSMate_Details_EHealing_LogDetails_EHealing_Amount0_StatusBar"):SetValue(ceil(100*hit/max))
	getglobal("DPSMate_Details_EHealing_LogDetails_EHealing_Amount0_StatusBar"):SetStatusBarColor(0.3,0.7,1.0,1)
	getglobal("DPSMate_Details_EHealing_LogDetails_EHealing_Average0"):SetText(ceil(hitav))
	getglobal("DPSMate_Details_EHealing_LogDetails_EHealing_Min0"):SetText(hitMin)
	getglobal("DPSMate_Details_EHealing_LogDetails_EHealing_Max0"):SetText(hitMax)
	
	-- Crit
	getglobal("DPSMate_Details_EHealing_LogDetails_EHealing_Amount1_Amount"):SetText(crit)
	getglobal("DPSMate_Details_EHealing_LogDetails_EHealing_Amount1_Percent"):SetText(ceil(100*crit/total).."%")
	getglobal("DPSMate_Details_EHealing_LogDetails_EHealing_Amount1_StatusBar"):SetValue(ceil(100*crit/max))
	getglobal("DPSMate_Details_EHealing_LogDetails_EHealing_Amount1_StatusBar"):SetStatusBarColor(1.0,0.7,0.3,1)
	getglobal("DPSMate_Details_EHealing_LogDetails_EHealing_Average1"):SetText(ceil(critav))
	getglobal("DPSMate_Details_EHealing_LogDetails_EHealing_Min1"):SetText(critMin)
	getglobal("DPSMate_Details_EHealing_LogDetails_EHealing_Max1"):SetText(critMax)
end

function DPSMate.Modules.DetailsEHealing:UpdatePie()
	local arr = db
	g:ResetPie()
	for cat, val in pairs(DetailsArr) do
		local ability = tonumber(DetailsArr[cat])
		local percent = (arr[DPSMateUser[DetailsUser][1]][ability][1]*100/DetailsTotal)
		g:AddPie(percent, 0)
	end
end

function DPSMate.Modules.DetailsEHealing:UpdateLineGraph()
	local arr = db
	local sumTable = DPSMate.Modules.DetailsEHealing:GetSummarizedTable(arr[DPSMateUser[DetailsUser][1]]["i"][2])
	local max = DPSMate.Modules.DetailsEHealing:GetMaxLineVal(sumTable, 2)
	local time = DPSMate.Modules.DetailsEHealing:GetMaxLineVal(sumTable, 1)
	
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
		table.insert(Data1, {val[1],val[2], DPSMate.Modules.DetailsEHealing:CheckProcs(DPSMate_Details_EHealing.proc, val[1])})
	end

	g2:AddDataSeries(Data1,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, DPSMate.Modules.DetailsEHealing:AddProcPoints(DPSMate_Details_EHealing.proc, Data1))
end

function DPSMate.Modules.DetailsEHealing:CreateGraphTable()
	local lines = {}
	for i=1, 8 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(DPSMate_Details_EHealing_Log, 252, 270-i*30, 617, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[9] = DPSMate.Options.graph:DrawLine(DPSMate_Details_EHealing_Log, 302, 260, 302, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(DPSMate_Details_EHealing_Log, 437, 260, 437, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(DPSMate_Details_EHealing_Log, 497, 260, 497, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
	
	lines[12] = DPSMate.Options.graph:DrawLine(DPSMate_Details_EHealing_Log, 557, 260, 557, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
end

function DPSMate.Modules.DetailsEHealing:ProcsDropDown()
	local arr = DPSMate.Modules.DetailsEHealing:GetAuraGainedArr(curKey)
	DPSMate_Details_EHealing.proc = "None"
	
    local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_Details_EHealing_DiagramLegend_Procs, this.value)
		DPSMate_Details_EHealing.proc = this.value
		DPSMate.Modules.DetailsEHealing:UpdateLineGraph()
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
	
	if DPSMate_Details_EHealing.LastUser~=DetailsUser then
		UIDropDownMenu_SetSelectedValue(DPSMate_Details_EHealing_DiagramLegend_Procs, "None")
	end
	DPSMate_Details_EHealing.LastUser = DetailsUser
end

function DPSMate.Modules.DetailsEHealing:GetSummarizedTable(arr)
	return DPSMate.Sync:GetSummarizedTable(arr)
end

function DPSMate.Modules.DetailsEHealing:GetMaxLineVal(t, p)
	local max = 0
	for cat, val in pairs(t) do
		if val[p]>max then
			max=val[p]
		end
	end
	return max
end

function DPSMate.Modules.DetailsEHealing:GetAuraGainedArr(k)
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

function DPSMate.Modules.DetailsEHealing:CheckProcs(name, val)
	local arr = DPSMate.Modules.DetailsEHealing:GetAuraGainedArr(curKey)
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

function DPSMate.Modules.DetailsEHealing:AddProcPoints(name, dat)
	local bool, data, LastVal = false, {}, 0
	local arr = DPSMate.Modules.DetailsEHealing:GetAuraGainedArr(curKey)
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


