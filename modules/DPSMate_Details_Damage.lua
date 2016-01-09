-- Global Variables
DPSMate.Modules.DetailsDamage = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailUser, DetailsSelected  = {}, 0, {}, "", 1
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

function DPSMate.Modules.DetailsDamage:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DPSMate_Details.proc = "None"
	UIDropDownMenu_SetSelectedValue(DPSMate_Details_DiagramLegend_Procs, "None")
	if (PieChart) then
		g=DPSMate.Options.graph:CreateGraphPieChart("PieChart", DPSMate_Details_Diagram, "CENTER", "CENTER", 0, 0, 200, 200)
		g2=DPSMate.Options.graph:CreateGraphLine("LineGraph",DPSMate_Details_DiagramLine,"CENTER","CENTER",0,0,850,230)
		PieChart = false
	end
	DetailsUser = obj.user
	DPSMate_Details_Title:SetText("Damage done of "..obj.user)
	DPSMate_Details:Show()
	UIDropDownMenu_Initialize(DPSMate_Details_DiagramLegend_Procs, DPSMate.Modules.DetailsDamage.ProcsDropDown)
	DPSMate.Modules.DetailsDamage:ScrollFrame_Update()
	DPSMate.Modules.DetailsDamage:SelectDetailsButton(1)
	DPSMate.Modules.DetailsDamage:UpdatePie()
	DPSMate.Modules.DetailsDamage:UpdateLineGraph()
end

function DPSMate.Modules.DetailsDamage:ScrollFrame_Update()
	local line, lineplusoffset
	local obj = getglobal("DPSMate_Details_Log_ScrollFrame")
	local arr = db
	local user, pet, len = "", 0, DPSMate:TableLength(arr[DPSMateUser[DetailsUser][1]])-5
	DetailsArr, DetailsTotal, DmgArr = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[DetailsUser], curKey)
	FauxScrollFrame_Update(obj,DPSMate:TableLength(arr),10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DetailsArr[lineplusoffset])
			getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Name"):SetText(ability)
			getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Value"):SetText(DmgArr[lineplusoffset].." ("..string.format("%.2f", (DmgArr[lineplusoffset]*100/DetailsTotal)).."%)")
			if icons[ability] then
				getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Icon"):SetTexture(icons[ability])
			else
				getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
			end
			if len < 10 then
				getglobal("DPSMate_Details_Log_ScrollButton"..line):SetWidth(235)
				getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Name"):SetWidth(125)
			else
				getglobal("DPSMate_Details_Log_ScrollButton"..line):SetWidth(220)
				getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Name"):SetWidth(110)
			end
			getglobal("DPSMate_Details_Log_ScrollButton"..line):Show()
		else
			getglobal("DPSMate_Details_Log_ScrollButton"..line):Hide()
		end
		getglobal("DPSMate_Details_Log_ScrollButton"..line.."_selected"):Hide()
		if DetailsSelected == lineplusoffset then
			getglobal("DPSMate_Details_Log_ScrollButton"..line.."_selected"):Show()
		end
	end
end

function DPSMate.Modules.DetailsDamage:SelectDetailsButton(i)
	local obj = getglobal("DPSMate_Details_Log_ScrollFrame")
	local lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
	local arr = db
	local user, pet = "", 0
	
	DetailsSelected = lineplusoffset
	for p=1, 10 do
		getglobal("DPSMate_Details_Log_ScrollButton"..p.."_selected"):Hide()
	end
	if (arr[DPSMateUser[DetailsUser][1]][DetailsArr[lineplusoffset]]) then user=DPSMateUser[DetailsUser][1]; pet=0; else if DPSMateUser[DetailsUser]["pet"] then user=DPSMateUser[DPSMateUser[DetailsUser]["pet"]][1]; pet=5; else user=DPSMateUser[DetailsUser][1]; pet=0; end; end
	getglobal("DPSMate_Details_Log_ScrollButton"..i.."_selected"):Show()
	
	local ability = tonumber(DetailsArr[lineplusoffset])
	local hit, crit, miss, parry, dodge, resist, hitMin, hitMax, critMin, critMax, hitav, critav = arr[user][ability][1], arr[user][ability][5], arr[user][ability][9], arr[user][ability][10], arr[user][ability][11], arr[user][ability][12], arr[user][ability][2], arr[user][ability][3], arr[user][ability][6], arr[user][ability][7], arr[user][ability][4], arr[user][ability][8]
	local total, max = hit+crit+miss+parry+dodge+resist, DPSMate:TMax({hit, crit, miss, parry, dodge, resist})
	
	-- Hit
	getglobal("DPSMate_Details_LogDetails_Amount1_Amount"):SetText(hit)
	getglobal("DPSMate_Details_LogDetails_Amount1_Percent"):SetText(ceil(100*hit/total).."%")
	getglobal("DPSMate_Details_LogDetails_Amount1_StatusBar"):SetValue(ceil(100*hit/max))
	getglobal("DPSMate_Details_LogDetails_Amount1_StatusBar"):SetStatusBarColor(0.9,0.0,0.0,1)
	getglobal("DPSMate_Details_LogDetails_Average1"):SetText(ceil(hitav))
	getglobal("DPSMate_Details_LogDetails_Min1"):SetText(hitMin)
	getglobal("DPSMate_Details_LogDetails_Max1"):SetText(hitMax)
	
	-- Crit
	getglobal("DPSMate_Details_LogDetails_Amount2_Amount"):SetText(crit)
	getglobal("DPSMate_Details_LogDetails_Amount2_Percent"):SetText(ceil(100*crit/total).."%")
	getglobal("DPSMate_Details_LogDetails_Amount2_StatusBar"):SetValue(ceil(100*crit/max))
	getglobal("DPSMate_Details_LogDetails_Amount2_StatusBar"):SetStatusBarColor(0.0,0.9,0.0,1)
	getglobal("DPSMate_Details_LogDetails_Average2"):SetText(ceil(critav))
	getglobal("DPSMate_Details_LogDetails_Min2"):SetText(critMin)
	getglobal("DPSMate_Details_LogDetails_Max2"):SetText(critMax)
	
	-- Miss
	getglobal("DPSMate_Details_LogDetails_Amount3_Amount"):SetText(miss)
	getglobal("DPSMate_Details_LogDetails_Amount3_Percent"):SetText(ceil(100*miss/total).."%")
	getglobal("DPSMate_Details_LogDetails_Amount3_StatusBar"):SetValue(ceil(100*miss/max))
	getglobal("DPSMate_Details_LogDetails_Amount3_StatusBar"):SetStatusBarColor(0.0,0.0,1.0,1)
	getglobal("DPSMate_Details_LogDetails_Average3"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Min3"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Max3"):SetText("-")
	
	-- Parry
	getglobal("DPSMate_Details_LogDetails_Amount4_Amount"):SetText(parry)
	getglobal("DPSMate_Details_LogDetails_Amount4_Percent"):SetText(ceil(100*parry/total).."%")
	getglobal("DPSMate_Details_LogDetails_Amount4_StatusBar"):SetValue(ceil(100*parry/max))
	getglobal("DPSMate_Details_LogDetails_Amount4_StatusBar"):SetStatusBarColor(1.0,1.0,0.0,1)
	getglobal("DPSMate_Details_LogDetails_Average4"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Min4"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Max4"):SetText("-")
	
	-- Dodge
	getglobal("DPSMate_Details_LogDetails_Amount5_Amount"):SetText(dodge)
	getglobal("DPSMate_Details_LogDetails_Amount5_Percent"):SetText(ceil(100*dodge/total).."%")
	getglobal("DPSMate_Details_LogDetails_Amount5_StatusBar"):SetValue(ceil(100*dodge/max))
	getglobal("DPSMate_Details_LogDetails_Amount5_StatusBar"):SetStatusBarColor(1.0,0.0,1.0,1)
	getglobal("DPSMate_Details_LogDetails_Average5"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Min5"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Max5"):SetText("-")
	
	-- Resist
	getglobal("DPSMate_Details_LogDetails_Amount6_Amount"):SetText(resist)
	getglobal("DPSMate_Details_LogDetails_Amount6_Percent"):SetText(ceil(100*resist/total).."%")
	getglobal("DPSMate_Details_LogDetails_Amount6_StatusBar"):SetValue(ceil(100*resist/max))
	getglobal("DPSMate_Details_LogDetails_Amount6_StatusBar"):SetStatusBarColor(0.0,1.0,1.0,1)
	getglobal("DPSMate_Details_LogDetails_Average6"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Min6"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Max6"):SetText("-")
end

function DPSMate.Modules.DetailsDamage:UpdatePie()
	local arr = db
	local user,pet = "",0
	g:ResetPie()
	for cat, val in pairs(DetailsArr) do
		local ability = tonumber(DetailsArr[cat])
		if (arr[DPSMateUser[DetailsUser][1]][ability]) then user=DPSMateUser[DetailsUser][1];pet=0; else user=DPSMateUser[DPSMateUser[DetailsUser]["pet"]][1];pet=5; end
		local percent = (arr[user][ability][13]*100/DetailsTotal)
		g:AddPie(percent, 0)
	end
end

function DPSMate.Modules.DetailsDamage:UpdateLineGraph()
	local arr = db
	local sumTable = DPSMate.Modules.DetailsDamage:GetSummarizedTable(arr, cbt)
	local max = DPSMate.Modules.DetailsDamage:GetMaxLineVal(sumTable)
	
	g2:ResetData()
	g2:SetXAxis(0,cbt)
	g2:SetYAxis(0,max+200)
	g2:SetGridSpacing(cbt/10,max/7)
	g2:SetGridColor({0.5,0.5,0.5,0.5})
	g2:SetAxisDrawing(true,true)
	g2:SetAxisColor({1.0,1.0,1.0,1.0})
	g2:SetAutoScale(true)
	g2:SetYLabels(true, false)
	g2:SetXLabels(true)

	local Data1={{0,0}}
	for cat, val in pairs(sumTable) do
		table.insert(Data1, {val[1],val[2], DPSMate.Modules.DetailsDamage:CheckProcs(DPSMate_Details.proc, val[1])})
	end

	g2:AddDataSeries(Data1,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, DPSMate.Modules.DetailsDamage:AddProcPoints(DPSMate_Details.proc, Data1))
end

function DPSMate.Modules.DetailsDamage:CreateGraphTable()
	local lines = {}
	for i=1, 7 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Log, 252, 270-i*30, 617, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[8] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Log, 302, 260, 302, 45, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[8]:Show()
	
	lines[9] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Log, 437, 260, 437, 45, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Log, 497, 260, 497, 45, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Log, 557, 260, 557, 45, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
end

function DPSMate.Modules.DetailsDamage:ProcsDropDown()
	local arr = DPSMate.Modules.DetailsDamage:GetAuraGainedArr(curKey)
	DPSMate_Details.proc = "None"
	
    local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_Details_DiagramLegend_Procs, this.value)
		DPSMate_Details.proc = this.value
		DPSMate.Modules.DetailsDamage:UpdateLineGraph()
    end
	
	UIDropDownMenu_AddButton{
		text = "None",
		value = "None",
		func = on_click,
	}
	
	-- Adding dynamic channel
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
	
	if DPSMate_Details.LastUser~=DetailsUser then
		UIDropDownMenu_SetSelectedValue(DPSMate_Details_DiagramLegend_Procs, "None")
	end
	DPSMate_Details.LastUser = DetailsUser
end

function DPSMate.Modules.DetailsDamage:SortLineTable(t)
	local newArr = {}
	for cat, val in pairs(t[DPSMateUser[DetailsUser][1]]["i"][2]) do
		local i=1
		while true do
			if (not newArr[i]) then 
				table.insert(newArr, i, {cat, val})
				break
			end
			if cat<newArr[i][1] then
				table.insert(newArr, i, {cat, val})
				break
			end
			i=i+1
		end
	end
	return newArr
end

function DPSMate.Modules.DetailsDamage:GetSummarizedTable(arr, cbt)
	arr = DPSMate.Modules.DetailsDamage:SortLineTable(arr)
	local newArr, lastCBT, i = {}, 0, 1
	local TL = DPSMate:TableLength(arr)
	local dis = 1
	if TL>100 then dis = floor(TL/100) end
	local dmg, time = 0, nil
	for cat, val in pairs(arr) do
		if dis>1 then
			dmg=dmg+val[2]
			if i<dis then
				if not time then time=val[1] end -- first time val
			else
				table.insert(newArr, {(val[1]+time)/2, dmg/(val[1]-time)}) -- last time val // subtracting from each other to get the time in which the damage is being done
				time = nil
				dmg = 0
				i=1
			end
		else
			table.insert(newArr, val)
		end
		i=i+1
	end
	
	return newArr
end

function DPSMate.Modules.DetailsDamage:GetMaxLineVal(t)
	local max = 0
	for cat, val in pairs(t) do
		if val[2]>max then
			max=val[2]
		end
	end
	return max
end

function DPSMate.Modules.DetailsDamage:GetAuraGainedArr(k)
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

function DPSMate.Modules.DetailsDamage:CheckProcs(name, val)
	local arr = DPSMate.Modules.DetailsDamage:GetAuraGainedArr(curKey)
	if arr[DPSMateUser[DetailsUser][1]][name] then
		for i=1, DPSMate:TableLength(arr[DPSMateUser[DetailsUser][1]][name][1]) do
			if not arr[DPSMateUser[DetailsUser][1]][name][1][i] or not arr[DPSMateUser[DetailsUser][1]][name][2][i] or arr[DPSMateUser[DetailsUser][1]][name][4] then return false end
			if val > arr[DPSMateUser[DetailsUser][1]][name][1][i] and val < arr[DPSMateUser[DetailsUser][1]][name][2][i] then
				return true
			end
		end
	end
	return false
end

function DPSMate.Modules.DetailsDamage:AddProcPoints(name, dat)
	local bool, data, LastVal = false, {}, 0
	local arr = DPSMate.Modules.DetailsDamage:GetAuraGainedArr(curKey)
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
	return {bool, data}
end


