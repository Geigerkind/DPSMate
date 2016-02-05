-- Global Variables
DPSMate.Modules.DetailsDamageTaken = {}

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

function DPSMate.Modules.DetailsDamageTaken:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	if (PieChart) then
		g2=DPSMate.Options.graph:CreateGraphLine("LineGraph",DPSMate_Details_DamageTaken_DiagramLine,"CENTER","CENTER",0,0,850,230)
		PieChart = false
	end
	DetailsUser = obj.user
	DPSMate_Details_DamageTaken_Title:SetText("Damage taken by "..obj.user)
	DPSMate_Details_DamageTaken:Show()
	DPSMate.Modules.DetailsDamageTaken:ScrollFrame_Update()
	DPSMate.Modules.DetailsDamageTaken:SelectCreatureButton(1)
	DPSMate.Modules.DetailsDamageTaken:SelectDetailsButton(1,1)
	DPSMate.Modules.DetailsDamageTaken:UpdateLineGraph()
end

function DPSMate.Modules.DetailsDamageTaken:ScrollFrame_Update()
	local line, lineplusoffset
	local path = "DPSMate_Details_DamageTaken_LogCreature"
	local obj = getglobal(path.."_ScrollFrame")
	local arr = db
	local pet, len = "", DPSMate:TableLength(arr[DPSMateUser[DetailsUser][1]])-5
	DetailsArr, DetailsTotal, DmgArr = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[DetailsUser], curKey)
	FauxScrollFrame_Update(obj,DPSMate:TableLength(arr),10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			local user = DPSMate:GetUserById(DetailsArr[lineplusoffset])
			getglobal(path.."_ScrollButton"..line.."_Name"):SetText(user)
			getglobal(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[lineplusoffset][1].." ("..string.format("%.2f", (DmgArr[lineplusoffset][1]*100/DetailsTotal)).."%)")
			getglobal(path.."_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
			if len < 10 then
				getglobal(path.."_ScrollButton"..line):SetWidth(235)
				getglobal(path.."_ScrollButton"..line.."_Name"):SetWidth(125)
			else
				getglobal(path.."_ScrollButton"..line):SetWidth(220)
				getglobal(path.."_ScrollButton"..line.."_Name"):SetWidth(110)
			end
			getglobal(path.."_ScrollButton"..line):Show()
		else
			getglobal(path.."_ScrollButton"..line):Hide()
		end
		getglobal(path.."_ScrollButton"..line.."_selected"):Hide()
		if DetailsSelected == lineplusoffset then
			getglobal(path.."_ScrollButton"..line.."_selected"):Show()
		end
	end
end

function DPSMate.Modules.DetailsDamageTaken:SelectCreatureButton(i)
	local line, lineplusoffset
	local path = "DPSMate_Details_DamageTaken_Log"
	local obj = getglobal(path.."_ScrollFrame")
	obj.index = i
	local arr = db
	local pet, len = "", DPSMate:TableLength(arr[DPSMateUser[DetailsUser][1]])-5
	FauxScrollFrame_Update(obj,DPSMate:TableLength(arr),10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DmgArr[i][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DmgArr[i][2][lineplusoffset])
			getglobal(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			getglobal(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[i][3][lineplusoffset].." ("..string.format("%.2f", (DmgArr[i][3][lineplusoffset]*100/DetailsTotal)).."%)")
			if icons[ability] then
				getglobal(path.."_ScrollButton"..line.."_Icon"):SetTexture(icons[ability])
			else
				getglobal(path.."_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
			end
			if len < 10 then
				getglobal(path.."_ScrollButton"..line):SetWidth(235)
				getglobal(path.."_ScrollButton"..line.."_Name"):SetWidth(125)
			else
				getglobal(path.."_ScrollButton"..line):SetWidth(220)
				getglobal(path.."_ScrollButton"..line.."_Name"):SetWidth(110)
			end
			getglobal(path.."_ScrollButton"..line):Show()
		else
			getglobal(path.."_ScrollButton"..line):Hide()
		end
		getglobal(path.."_ScrollButton"..line.."_selected"):Hide()
		getglobal(path.."_ScrollButton1_selected"):Show()
	end
	for p=1, 10 do
		getglobal("DPSMate_Details_DamageTaken_LogCreature_ScrollButton"..p.."_selected"):Hide()
	end
	getglobal("DPSMate_Details_DamageTaken_LogCreature_ScrollButton"..i.."_selected"):Show()
	DPSMate.Modules.DetailsDamageTaken:SelectDetailsButton(i,1)
end

function DPSMate.Modules.DetailsDamageTaken:SelectDetailsButton(p,i)
	local obj = getglobal("DPSMate_Details_DamageTaken_Log_ScrollFrame")
	local lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
	local arr = db
	
	DetailsSelected = lineplusoffset
	for p=1, 10 do
		getglobal("DPSMate_Details_DamageTaken_Log_ScrollButton"..p.."_selected"):Hide()
	end
	-- Performance?
	local ability = tonumber(DmgArr[p][2][lineplusoffset])
	local creature = tonumber(DetailsArr[p])
	getglobal("DPSMate_Details_DamageTaken_Log_ScrollButton"..i.."_selected"):Show()
	
	local path = arr[DPSMateUser[DetailsUser][1]][creature][ability]
	local hit, crit, miss, parry, dodge, resist, hitMin, hitMax, critMin, critMax, hitav, critav, crush, crushMin, crushMax, crushav = path[1], path[5], path[9], path[10], path[11], path[12], path[2], path[3], path[6], path[7], path[4], path[8], path[15], path[16], path[17], path[18]
	local total, max = hit+crit+miss+parry+dodge+resist+crush, DPSMate:TMax({hit, crit, miss, parry, dodge, resist, crush})
	
	-- Crush
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount1_Amount"):SetText(crush)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount1_Percent"):SetText(ceil(100*crush/total).."%")
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount1_StatusBar"):SetValue(ceil(100*crush/max))
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount1_StatusBar"):SetStatusBarColor(0.0,0.0,1.0,1)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Average1"):SetText(ceil(crushav))
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Min1"):SetText(crushMin)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Max1"):SetText(crushMax)
	
	-- Hit
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount2_Amount"):SetText(hit)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount2_Percent"):SetText(ceil(100*hit/total).."%")
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount2_StatusBar"):SetValue(ceil(100*hit/max))
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount2_StatusBar"):SetStatusBarColor(0.9,0.0,0.0,1)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Average2"):SetText(ceil(hitav))
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Min2"):SetText(hitMin)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Max2"):SetText(hitMax)
	
	-- Crit
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount3_Amount"):SetText(crit)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount3_Percent"):SetText(ceil(100*crit/total).."%")
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount3_StatusBar"):SetValue(ceil(100*crit/max))
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount3_StatusBar"):SetStatusBarColor(0.0,0.9,0.0,1)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Average3"):SetText(ceil(critav))
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Min3"):SetText(critMin)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Max3"):SetText(critMax)
	
	-- Miss
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount4_Amount"):SetText(miss)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount4_Percent"):SetText(ceil(100*miss/total).."%")
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount4_StatusBar"):SetValue(ceil(100*miss/max))
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount4_StatusBar"):SetStatusBarColor(0.0,0.0,1.0,1)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Average4"):SetText("-")
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Min4"):SetText("-")
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Max4"):SetText("-")
	
	-- Parry
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount5_Amount"):SetText(parry)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount5_Percent"):SetText(ceil(100*parry/total).."%")
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount5_StatusBar"):SetValue(ceil(100*parry/max))
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount5_StatusBar"):SetStatusBarColor(1.0,1.0,0.0,1)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Average5"):SetText("-")
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Min5"):SetText("-")
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Max5"):SetText("-")
	
	-- Dodge
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount6_Amount"):SetText(dodge)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount6_Percent"):SetText(ceil(100*dodge/total).."%")
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount6_StatusBar"):SetValue(ceil(100*dodge/max))
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount6_StatusBar"):SetStatusBarColor(1.0,0.0,1.0,1)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Average6"):SetText("-")
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Min6"):SetText("-")
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Max6"):SetText("-")
	
	-- Resist
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount7_Amount"):SetText(resist)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount7_Percent"):SetText(ceil(100*resist/total).."%")
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount7_StatusBar"):SetValue(ceil(100*resist/max))
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Amount7_StatusBar"):SetStatusBarColor(0.0,1.0,1.0,1)
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Average7"):SetText("-")
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Min7"):SetText("-")
	getglobal("DPSMate_Details_DamageTaken_LogDetails_Max7"):SetText("-")
end

function DPSMate.Modules.DetailsDamageTaken:UpdateLineGraph()
	local arr = db
	local sumTable = DPSMate.Modules.DetailsDamageTaken:GetSummarizedTable(arr)
	local max = DPSMate.Modules.DetailsDamageTaken:GetMaxLineVal(sumTable)
	
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
		table.insert(Data1, {val[1],val[2], {}})
	end

	g2:AddDataSeries(Data1,{{1.0,0.0,0.0,0.8}, {1.0,0.0,0.0,0.8}}, {})
end

function DPSMate.Modules.DetailsDamageTaken:CreateGraphTable()
	local lines = {}
	for i=1, 8 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTaken_Log, 252, 270-i*30, 617, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[9] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTaken_Log, 302, 260, 302, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTaken_Log, 437, 260, 437, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTaken_Log, 497, 260, 497, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
	
	lines[12] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTaken_Log, 557, 260, 557, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
end

function DPSMate.Modules.DetailsDamageTaken:GetSummarizedTable(arr)
	return DPSMate.Sync:GetSummarizedTable(arr[DPSMateUser[DetailsUser][1]]["i"])
end

function DPSMate.Modules.DetailsDamageTaken:GetMaxLineVal(t)
	local max = 0
	for cat, val in pairs(t) do
		if val[2]>max then
			max=val[2]
		end
	end
	return max
end

