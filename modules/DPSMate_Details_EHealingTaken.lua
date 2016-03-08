-- Global Variables
DPSMate.Modules.DetailsEHealingTaken = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailsUser, DetailsSelected  = {}, 0, {}, "", 1
local PieChart = true
local g, g2
local curKey = 1
local db, cbt = {}, 0

function DPSMate.Modules.DetailsEHealingTaken:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	if (PieChart) then
		g2=DPSMate.Options.graph:CreateGraphLine("LineGraph",DPSMate_Details_EHealingTaken_DiagramLine,"CENTER","CENTER",0,0,850,230)
		PieChart = false
	end
	DetailsUser = obj.user
	DPSMate_Details_EHealingTaken_Title:SetText("Effective healing taken by "..obj.user)
	DPSMate_Details_EHealingTaken:Show()
	DPSMate.Modules.DetailsEHealingTaken:ScrollFrame_Update()
	DPSMate.Modules.DetailsEHealingTaken:SelectCreatureButton(1)
	DPSMate.Modules.DetailsEHealingTaken:SelectDetailsButton(1,1)
	DPSMate.Modules.DetailsEHealingTaken:UpdateLineGraph()
end

function DPSMate.Modules.DetailsEHealingTaken:ScrollFrame_Update()
	local line, lineplusoffset
	local path = "DPSMate_Details_EHealingTaken_LogCreature"
	local obj = getglobal(path.."_ScrollFrame")
	local arr = db
	DetailsArr, DetailsTotal, DmgArr = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[DetailsUser], curKey)
	local len = DPSMate:TableLength(DetailsArr)
	FauxScrollFrame_Update(obj,len,10,24)
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

function DPSMate.Modules.DetailsEHealingTaken:SelectCreatureButton(i)
	local line, lineplusoffset
	local path = "DPSMate_Details_EHealingTaken_Log"
	local obj = getglobal(path.."_ScrollFrame")
	if i then obj.index = i else i=obj.index end
	local arr = db
	local pet, len = "", DPSMate:TableLength(DmgArr[i][2])
	FauxScrollFrame_Update(obj,len,10,24)
	DetailsSelected = i
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DmgArr[i][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DmgArr[i][2][lineplusoffset])
			getglobal(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			getglobal(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[i][3][lineplusoffset].." ("..string.format("%.2f", (DmgArr[i][3][lineplusoffset]*100/DmgArr[i][1])).."%)")
			getglobal(path.."_ScrollButton"..line.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(strsub(ability, 1, (strfind(ability, "%(") or 0)-1) or ability))
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
		getglobal("DPSMate_Details_EHealingTaken_LogCreature_ScrollButton"..p.."_selected"):Hide()
	end
	getglobal("DPSMate_Details_EHealingTaken_LogCreature_ScrollButton"..i.."_selected"):Show()
	DPSMate.Modules.DetailsEHealingTaken:SelectDetailsButton(i,1)
end

function DPSMate.Modules.DetailsEHealingTaken:SelectDetailsButton(p,i)
	local obj = getglobal("DPSMate_Details_EHealingTaken_Log_ScrollFrame")
	local lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
	local arr = db
	
	for p=1, 10 do
		getglobal("DPSMate_Details_EHealingTaken_Log_ScrollButton"..p.."_selected"):Hide()
	end
	-- Performance?
	local ability = tonumber(DmgArr[p][2][lineplusoffset])
	local creature = tonumber(DetailsArr[p])
	getglobal("DPSMate_Details_EHealingTaken_Log_ScrollButton"..i.."_selected"):Show()
	
	local path = arr[DPSMateUser[DetailsUser][1]][creature][ability]
	local hit, crit, hitav, critav, hitMin, hitMax, critMin, critMax = path[2], path[3], path[4], path[5], path[6], path[7], path[8], path[9]
	local total, max = hit+crit, DPSMate:TMax({hit, crit})
	
	-- Hit
	getglobal("DPSMate_Details_EHealingTaken_LogDetails_Amount1_Amount"):SetText(hit)
	getglobal("DPSMate_Details_EHealingTaken_LogDetails_Amount1_Percent"):SetText(ceil(100*hit/total).."%")
	getglobal("DPSMate_Details_EHealingTaken_LogDetails_Amount1_StatusBar"):SetValue(ceil(100*hit/max))
	getglobal("DPSMate_Details_EHealingTaken_LogDetails_Amount1_StatusBar"):SetStatusBarColor(1.0,0.7,0.3,1)
	getglobal("DPSMate_Details_EHealingTaken_LogDetails_Average1"):SetText(ceil(hitav))
	getglobal("DPSMate_Details_EHealingTaken_LogDetails_Min1"):SetText(hitMin)
	getglobal("DPSMate_Details_EHealingTaken_LogDetails_Max1"):SetText(hitMax)
	
	-- Crit
	getglobal("DPSMate_Details_EHealingTaken_LogDetails_Amount2_Amount"):SetText(crit)
	getglobal("DPSMate_Details_EHealingTaken_LogDetails_Amount2_Percent"):SetText(ceil(100*crit/total).."%")
	getglobal("DPSMate_Details_EHealingTaken_LogDetails_Amount2_StatusBar"):SetValue(ceil(100*crit/max))
	getglobal("DPSMate_Details_EHealingTaken_LogDetails_Amount2_StatusBar"):SetStatusBarColor(0.9,0.0,0.0,1)
	getglobal("DPSMate_Details_EHealingTaken_LogDetails_Average2"):SetText(ceil(critav))
	getglobal("DPSMate_Details_EHealingTaken_LogDetails_Min2"):SetText(critMin)
	getglobal("DPSMate_Details_EHealingTaken_LogDetails_Max2"):SetText(critMax)
end

function DPSMate.Modules.DetailsEHealingTaken:UpdateLineGraph()
	local arr = db
	local sumTable = DPSMate.Modules.DetailsEHealingTaken:GetSummarizedTable(arr)
	local max = DPSMate.Modules.DetailsEHealingTaken:GetMaxLineVal(sumTable, 2)
	local time = DPSMate.Modules.DetailsEHealingTaken:GetMaxLineVal(sumTable, 1)
	
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
		table.insert(Data1, {val[1],val[2], {}})
	end

	g2:AddDataSeries(Data1,{{1.0,0.0,0.0,0.8}, {1.0,0.0,0.0,0.8}}, {})
end

function DPSMate.Modules.DetailsEHealingTaken:CreateGraphTable()
	local lines = {}
	for i=1, 8 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(DPSMate_Details_EHealingTaken_Log, 252, 270-i*30, 617, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[9] = DPSMate.Options.graph:DrawLine(DPSMate_Details_EHealingTaken_Log, 302, 260, 302, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(DPSMate_Details_EHealingTaken_Log, 437, 260, 437, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(DPSMate_Details_EHealingTaken_Log, 497, 260, 497, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
	
	lines[12] = DPSMate.Options.graph:DrawLine(DPSMate_Details_EHealingTaken_Log, 557, 260, 557, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
end

function DPSMate.Modules.DetailsEHealingTaken:GetSummarizedTable(arr)
	return DPSMate.Sync:GetSummarizedTable(arr[DPSMateUser[DetailsUser][1]]["i"][1])
end

function DPSMate.Modules.DetailsEHealingTaken:GetMaxLineVal(t, p)
	local max = 0
	for cat, val in pairs(t) do
		if val[p]>max then
			max=val[p]
		end
	end
	return max
end

