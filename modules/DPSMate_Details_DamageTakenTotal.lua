DPSMate.Modules.DetailsDamageTakenTotal = {}

local g = nil
local curKey = 1
local db, cbt = {}, 0
local buttons = {}
local ColorTable={}

function DPSMate.Modules.DetailsDamageTakenTotal:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	buttons = {}
	ColorTable={
		{0.95,0.90,0.5},
		{0.0,0.9,0.0},
		{0.0,0.0,1.0},
		{1.0,1.0,0.0},
		{1.0,0.0,1.0},
		{0.0,1.0,1.0},
		{1.0,1.0,1.0},
		{0.5,0.0,0.0},
		{0.0,0.5,0.0},
		{0.0,0.0,0.5},
		{0.5,0.5,0.0},
		{0.5,0.0,0.5},
		{0.0,0.5,0.5},
		{0.5,0.5,0.5},
		{0.75,0.25,0.25},
		{0.25,0.75,0.25},
		{0.25,0.25,0.75},
		{0.75,0.75,0.25},
		{0.75,0.25,0.75},
		{0.25,0.75,0.75},
		{1.0,0.5,0.0},	
		{0.0,0.5,1.0},
		{1.0,0.0,0.5},
		{0.5,1.0,0.0},
		{0.5,0.0,1.0},
		{0.0,1.0,0.5},
		{0.0,0.25,0.5},
		{0.25,0,0.5},
		{0.5,0.25,0.0},
		{0.5,0.0,0.25},
		{0.5,0.75,0.0},
		{0.5,0.0,0.75},
		{0.0,0.75,0.5},
		{0.75,0.0,0.5},
	}
	if not g then
		g=DPSMate.Options.graph:CreateGraphLine("LineGraph",DPSMate_Details_DamageTakenTotal_DiagramLine,"CENTER","CENTER",0,0,750,230)
		DPSMate.Modules.DetailsDamageTakenTotal:CreateGraphTable()
	end
	getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_CB"):SetChecked(false)
	getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_CB").act = false
	DPSMate_Details_DamageTakenTotal_Title:SetText("Damage taken summary")
	DPSMate.Modules.DetailsDamageTakenTotal:UpdateLineGraph()
	DPSMate.Modules.DetailsDamageTakenTotal:LoadTable()
	DPSMate.Modules.DetailsDamageTakenTotal:LoadLegendButtons()
	DPSMate_Details_DamageTakenTotal:Show()
end

function DPSMate.Modules.DetailsDamageTakenTotal:UpdateLineGraph()	
	g:ResetData()
	g:SetGridColor({0.5,0.5,0.5,0.5})
	g:SetAxisDrawing(true,true)
	g:SetAxisColor({1.0,1.0,1.0,1.0})
	g:SetAutoScale(true)
	g:SetYLabels(true, false)
	g:SetXLabels(true)
	DPSMate.Modules.DetailsDamageTakenTotal:AddTotalDataSeries()
end

function DPSMate.Modules.DetailsDamageTakenTotal:GetSummarizedTable(arr)
	return DPSMate.Sync:GetSummarizedTable(arr)
end

function DPSMate.Modules.DetailsDamageTakenTotal:GetMaxLineVal(t, p)
	local max = 0
	for cat, val in pairs(t) do
		if val[p]>max then
			max=val[p]
		end
	end
	return max
end

function DPSMate.Modules.DetailsDamageTakenTotal:CreateGraphTable()
	local lines = {}
	for i=1, 8 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTakenTotal_PlayerList, 10, 270-i*30, 860, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[9] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTakenTotal_PlayerList, 40, 260, 40, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTakenTotal_PlayerList, 170, 260, 170, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTakenTotal_PlayerList, 540, 260, 540, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
	
	lines[12] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTakenTotal_PlayerList, 600, 260, 600, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
	
	lines[13] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTakenTotal_PlayerList, 660, 260, 660, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[13]:Show()
	
	lines[14] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTakenTotal_PlayerList, 720, 260, 720, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[14]:Show()
	
	lines[15] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTakenTotal_PlayerList, 780, 260, 780, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[15]:Show()
end

local totSumTable = {}
function DPSMate.Modules.DetailsDamageTakenTotal:AddTotalDataSeries()
	local sumTable, newArr = {[0]=0}, {}
	
	for cat, val in pairs(db) do
		for ca, va in pairs(db[cat]["i"][1]) do
			if sumTable[va[1]] then
				sumTable[va[1]] = sumTable[va[1]] + va[2]
			else
				sumTable[va[1]] = va[2]
			end
		end
	end
	for cat, val in pairs(sumTable) do
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
	
	totSumTable = DPSMate.Modules.DetailsDamageTakenTotal:GetSummarizedTable(newArr)
	local totMax = DPSMate.Modules.DetailsDamageTakenTotal:GetMaxLineVal(totSumTable, 2)
	local time = DPSMate.Modules.DetailsDamageTakenTotal:GetMaxLineVal(totSumTable, 1)
	g:SetXAxis(0,time)
	g:SetYAxis(0,totMax+20)
	g:SetGridSpacing(time/10,(totMax+20)/7)
	
	g:AddDataSeries(totSumTable,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, {})
end

-- crushes?
function DPSMate.Modules.DetailsDamageTakenTotal:GetTableValues()
	local arr, total = {}, 0
	for cat, val in pairs(db) do
		local CV, crit, totCrit, miss, totMiss, hit, totHit, crush = 0, 0, 0.000001, 0, 0.000001, 0, 0.000001, 0
		local name = DPSMate:GetUserById(cat)
		for ca, va in pairs(val) do
			if ca~="i" then
				for c, v in pairs(va) do
					if c~="i" then
						if v[1]>0 or v[15]>0 then
							totHit=totHit+v[1]+v[5]+v[9]+v[10]+v[11]+v[12]+v[15]
							hit=hit+v[1]
							crush=crush+v[15]
						end
						if v[5]>0 then
							totCrit=totCrit+v[1]+v[5]+v[9]+v[10]+v[11]+v[12]+v[15]
							crit=crit+v[5]
						end
						if v[9]>0 or v[10]>0 or v[11]>0 or v[12]>0 then
							totMiss=totMiss+v[1]+v[5]+v[9]+v[10]+v[11]+v[12]+v[15]
							miss=miss+v[9]+v[10]+v[11]+v[12]
						end
						CV = CV + v[13]
					end
				end
			end
		end
		table.insert(arr, {name, CV, crit, miss, totCrit, totMiss, cat, hit, totHit, crush, totCrush})
		total = total + CV
	end
	local newArr = {}
	for cat, val in pairs(arr) do
		local i = 1
		while true do
			if (not newArr[i]) then
				table.insert(newArr, i, val)
				break
			else
				if newArr[i][2] < val[2] then
					table.insert(newArr, i, val)
					break
				end
			end
			i=i+1
		end
	end
	return newArr, total
end

function DPSMate.Modules.DetailsDamageTakenTotal:CheckButtonCheckAll(obj)
	if obj.act then
		obj.act = false
		for i=1, 30 do 
			local ob = getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..i)
			if ob.user then
				DPSMate.Modules.DetailsDamageTakenTotal:RemoveLinesButton(ob.user, ob)
				getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..i.."_CB"):SetChecked(obj.act)
			end
		end
	else
		obj.act = true
		for i=1, 30 do 
			local ob = getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..i)
			if ob.user then
				DPSMate.Modules.DetailsDamageTakenTotal:AddLinesButton(ob.user, ob)
				getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..i.."_CB"):SetChecked(obj.act)
			end
		end
	end
end

function DPSMate.Modules.DetailsDamageTakenTotal:AddLinesButton(uid, obj)
	local sumTable = db[uid]["i"][1]
	local user = DPSMate:GetUserById(uid)
	
	sumTable = DPSMate.Modules.DetailsDamageTakenTotal:GetSummarizedTable(sumTable, cbt)
	
	g:AddDataSeries(sumTable, {ColorTable[1], {}}, {})
	table.insert(buttons, {ColorTable[1], uid, sumTable})
	table.remove(ColorTable, 1)
	obj.act = true
	DPSMate.Modules.DetailsDamageTakenTotal:LoadLegendButtons()
end

function DPSMate.Modules.DetailsDamageTakenTotal:RemoveLinesButton(uid, obj)
	obj.act = false
	g:ResetData()
	for cat, val in pairs(buttons) do
		if val[2]==uid then
			table.insert(ColorTable, 1, val[1])
			table.remove(buttons, cat)
			break
		end
	end
	
	g:AddDataSeries(totSumTable,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, {})
	for cat, val in pairs(buttons) do		
		g:AddDataSeries(val[3], {val[1], {}}, {})
	end
	DPSMate.Modules.DetailsDamageTakenTotal:LoadLegendButtons()
end

function DPSMate.Modules.DetailsDamageTakenTotal:LoadLegendButtons()
	for i=1, 30 do
		getglobal("DPSMate_Details_DamageTakenTotal_DiagramLegend_Child_C"..i):Hide()
	end
	for cat, val in pairs(buttons) do
		local name = DPSMate:GetUserById(val[2])
		local font = getglobal("DPSMate_Details_DamageTakenTotal_DiagramLegend_Child_C"..cat.."_Font")
		font:SetText(name)
		font:SetTextColor(DPSMate:GetClassColor(DPSMateUser[name][2]))
		getglobal("DPSMate_Details_DamageTakenTotal_DiagramLegend_Child_C"..cat.."_SwatchBg"):SetTexture(val[1][1],val[1][2],val[1][3],1)
		getglobal("DPSMate_Details_DamageTakenTotal_DiagramLegend_Child_C"..cat):Show()
	end
end

function DPSMate.Modules.DetailsDamageTakenTotal:LoadTable()
	local arr, total = DPSMate.Modules.DetailsDamageTakenTotal:GetTableValues()
	for i=1, 30 do
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..i):Hide()
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..i.."_CB"):SetChecked(false)
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..i.."_CB").act = false
	end
	for cat, val in pairs(arr) do
		if cat>30 then break end
		local r,g,b = DPSMate:GetClassColor(DPSMateUser[val[1]][2])
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child"):SetHeight(cat*30-210)
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..cat.."_Name"):SetText(val[1])
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..cat.."_Name"):SetTextColor(r,g,b)
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..cat.."_Amount"):SetText(val[2])
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..cat.."_StatusBar"):SetValue(100*val[2]/arr[1][2])
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..cat.."_StatusBar"):SetStatusBarColor(r,g,b, 1)
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..cat.."_AmountPerc"):SetText(string.format("%.1f", 100*val[2]/total).."%")
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..cat.."_Crush"):SetText(string.format("%.1f", 100*val[10]/val[9]).."%")
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..cat.."_Hit"):SetText(string.format("%.1f", 100*val[8]/val[9]).."%")
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..cat.."_Crit"):SetText(string.format("%.1f", 100*val[3]/val[5]).."%")
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..cat.."_Miss"):SetText(string.format("%.1f", 100*val[4]/val[6]).."%")
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..cat.."_DTPS"):SetText(string.format("%.1f", val[2]/cbt))
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..cat).user = val[7]
		getglobal("DPSMate_Details_DamageTakenTotal_PlayerList_Child_R"..cat):Show()
	end
end

function DPSMate.Modules.DetailsDamageTakenTotal:ShowTooltip(user, obj)
	local name = DPSMate:GetUserById(user)
	local a,b,c = DPSMate.Modules.DamageTaken:EvalTable(DPSMateUser[name], curKey)
	local pet = ""
	GameTooltip:SetOwner(obj, "TOPLEFT")
	GameTooltip:AddLine(name.."'s damage taken", 1,1,1)
	for i=1, DPSMateSettings["subviewrows"] do
		if not a[i] then break end
		GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(a[i]),c[i][1].." ("..string.format("%.2f", 100*c[i][1]/b).."%)",1,1,1,1,1,1)
		for p=1, 3 do 
			if not c[i][2][p] or c[i][3][p]==0 then break end
			GameTooltip:AddDoubleLine("       "..p..". "..DPSMate:GetAbilityById(c[i][2][p]),c[i][3][p].." ("..string.format("%.2f", 100*c[i][3][p]/c[i][1]).."%)",0.5,0.5,0.5,0.5,0.5,0.5)
		end
	end
	GameTooltip:Show()
end
