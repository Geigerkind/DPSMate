DPSMate.Modules.DetailsDamageTotal = {}

local g = nil
local curKey = 1
local db, cbt = {}, 0
local buttons = {}
local ColorTable={}

function DPSMate.Modules.DetailsDamageTotal:UpdateDetails(obj, key)
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
	}
	if not g then
		g=DPSMate.Options.graph:CreateGraphLine("LineGraph",DPSMate_Details_DamageTotal_DiagramLine,"CENTER","CENTER",0,0,750,230)
		DPSMate.Modules.DetailsDamageTotal:CreateGraphTable()
	end
	getglobal("DPSMate_Details_DamageTotal_PlayerList_CB"):SetChecked(false)
	getglobal("DPSMate_Details_DamageTotal_PlayerList_CB").act = false
	DPSMate_Details_DamageTotal_Title:SetText("Damage done summary")
	DPSMate.Modules.DetailsDamageTotal:UpdateLineGraph()
	DPSMate.Modules.DetailsDamageTotal:LoadTable()
	DPSMate.Modules.DetailsDamageTotal:LoadLegendButtons()
	DPSMate_Details_DamageTotal:Show()
end

function DPSMate.Modules.DetailsDamageTotal:UpdateLineGraph()	
	g:ResetData()
	g:SetGridColor({0.5,0.5,0.5,0.5})
	g:SetAxisDrawing(true,true)
	g:SetAxisColor({1.0,1.0,1.0,1.0})
	g:SetAutoScale(false)
	g:SetYLabels(true, false)
	g:SetXLabels(true)
	DPSMate.Modules.DetailsDamageTotal:AddTotalDataSeries()
end

function DPSMate.Modules.DetailsDamageTotal:GetSummarizedTable(arr)
	return DPSMate.Sync:GetSummarizedTable(arr)
end

function DPSMate.Modules.DetailsDamageTotal:GetMaxLineVal(t, p)
	local max = 0
	for cat, val in pairs(t) do
		if val[p]>max then
			max=val[p]
		end
	end
	return max
end

function DPSMate.Modules.DetailsDamageTotal:CreateGraphTable()
	local lines = {}
	for i=1, 8 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTotal_PlayerList, 10, 270-i*30, 860, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[9] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTotal_PlayerList, 40, 260, 40, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTotal_PlayerList, 170, 260, 170, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTotal_PlayerList, 540, 260, 540, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
	
	lines[12] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTotal_PlayerList, 600, 260, 600, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
	
	lines[13] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTotal_PlayerList, 660, 260, 660, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[13]:Show()
	
	lines[13] = DPSMate.Options.graph:DrawLine(DPSMate_Details_DamageTotal_PlayerList, 740, 260, 740, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[13]:Show()
end

local totSumTable = {}
function DPSMate.Modules.DetailsDamageTotal:AddTotalDataSeries()
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
	
	totSumTable = DPSMate.Modules.DetailsDamageTotal:GetSummarizedTable(newArr)
	
	for cat, val in pairs(totSumTable) do
		val[2] = val[2]/4
	end
	local totMax = DPSMate.Modules.DetailsDamageTotal:GetMaxLineVal(totSumTable, 2)
	local time = DPSMate.Modules.DetailsDamageTotal:GetMaxLineVal(totSumTable, 1)
	g:SetXAxis(0,time)
	g:SetYAxis(0,totMax+200)
	g:SetGridSpacing(time/10,totMax/4)
	
	g:AddDataSeries(totSumTable,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, {})
end

function DPSMate.Modules.DetailsDamageTotal:GetTableValues()
	local arr, total = {}, 0
	for cat, val in pairs(db) do
		local crit, totCrit, miss, totMiss, time, last = 0, 0.000001, 0, 0.000001, 0, 0
		local name = DPSMate:GetUserById(cat)
		for ca, va in pairs(val) do
			if ca~="i" then
				if va[5]>0 then
					totCrit=totCrit+va[1]+va[5]+va[9]+va[10]+va[11]+va[12]+va[14]
					crit=crit+va[5]
				end
				if va[9]>0 or va[10]>0 or va[11]>0 or va[12]>0 then
					totMiss=totMiss+va[1]+va[5]+va[9]+va[10]+va[11]+va[12]+va[14]
					miss=miss+va[9]+va[10]+va[11]+va[12]
				end
			else
				-- That is just speculating, need to implement a proper way.
				local delay = 2.8
				if DPSMateUser[name][2] == "hunter" or DPSMateUser[name][2] == "paladin" then
					delay = 5
				elseif DPSMateUser[name][2] == "mage" or DPSMateUser[name][2] == "warlock" or DPSMateUser[name][2] == "shaman" or DPSMateUser[name][2] == "druid" then
					delay = 6.5
				end
				for _, v in pairs(va[1]) do
					if (v[1]-last)>=delay then
						last = v[1]
					else
						time=time+(v[1]-last)
					end
				end
			end
		end
		table.insert(arr, {name, val["i"][2], crit, miss, time, totCrit, totMiss, cat})
		total = total + val["i"][2]
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

function DPSMate.Modules.DetailsDamageTotal:CheckButtonCheckAll(obj)
	if obj.act then
		obj.act = false
		for i=1, 30 do 
			local ob = getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..i)
			if ob.user then
				DPSMate.Modules.DetailsDamageTotal:RemoveLinesButton(ob.user, ob)
				getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..i.."_CB"):SetChecked(obj.act)
			end
		end
	else
		obj.act = true
		for i=1, 30 do 
			local ob = getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..i)
			if ob.user then
				DPSMate.Modules.DetailsDamageTotal:AddLinesButton(ob.user, ob)
				getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..i.."_CB"):SetChecked(obj.act)
			end
		end
	end
end

function DPSMate.Modules.DetailsDamageTotal:AddLinesButton(uid, obj)
	local sumTable = db[uid]["i"][1]
	local user = DPSMate:GetUserById(uid)
	if DPSMateUser[user]["pet"] then
		if db[DPSMateUser[DPSMateUser[user]["pet"]][1]] then
			for cat, val in pairs(db[DPSMateUser[DPSMateUser[user]["pet"]][1]]["i"][1]) do
				if sumTable[cat] then
					sumTable[cat] = sumTable[cat]+val
				else
					sumTable[cat] = val
				end
			end
		end
	end
	
	sumTable = DPSMate.Modules.DetailsDamageTotal:GetSummarizedTable(sumTable)
	
	g:AddDataSeries(sumTable, {ColorTable[1], {}}, {})
	table.insert(buttons, {ColorTable[1], uid, sumTable})
	table.remove(ColorTable, 1)
	obj.act = true
	DPSMate.Modules.DetailsDamageTotal:LoadLegendButtons()
end

function DPSMate.Modules.DetailsDamageTotal:RemoveLinesButton(uid, obj)
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
	DPSMate.Modules.DetailsDamageTotal:LoadLegendButtons()
end

function DPSMate.Modules.DetailsDamageTotal:LoadLegendButtons()
	for i=1, 30 do
		getglobal("DPSMate_Details_DamageTotal_DiagramLegend_Child_C"..i):Hide()
	end
	for cat, val in pairs(buttons) do
		local name = DPSMate:GetUserById(val[2])
		local font = getglobal("DPSMate_Details_DamageTotal_DiagramLegend_Child_C"..cat.."_Font")
		font:SetText(name)
		font:SetTextColor(DPSMate:GetClassColor(DPSMateUser[name][2]))
		getglobal("DPSMate_Details_DamageTotal_DiagramLegend_Child_C"..cat.."_SwatchBg"):SetTexture(val[1][1],val[1][2],val[1][3],1)
		getglobal("DPSMate_Details_DamageTotal_DiagramLegend_Child_C"..cat):Show()
	end
end

function DPSMate.Modules.DetailsDamageTotal:LoadTable()
	local arr, total = DPSMate.Modules.DetailsDamageTotal:GetTableValues()
	local i = 0
	for i=1, 30 do
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..i):Hide()
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..i.."_CB"):SetChecked(false)
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..i.."_CB").act = false
	end
	for cat, val in pairs(arr) do
		if DPSMateUser[val[1]]["isPet"] then
			i=i+1
		else
			if (cat-i)>30 then break end
			local r,g,b = DPSMate:GetClassColor(DPSMateUser[val[1]][2])
			getglobal("DPSMate_Details_DamageTotal_PlayerList_Child"):SetHeight((cat-i)*30-210)
			getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_Name"):SetText(val[1])
			getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_Name"):SetTextColor(r,g,b)
			getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_Amount"):SetText(val[2])
			getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_StatusBar"):SetValue(100*val[2]/arr[1][2])
			getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_StatusBar"):SetStatusBarColor(r,g,b, 1)
			getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_AmountPerc"):SetText(string.format("%.1f", 100*val[2]/total).."%")
			getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_Crit"):SetText(string.format("%.1f", 100*val[3]/val[6]).."%")
			getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_Miss"):SetText(string.format("%.1f", 100*val[4]/val[7]).."%")
			getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_DPS"):SetText(string.format("%.1f", val[2]/cbt))
			getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_ActiveTime"):SetText(ceil(val[5]).."s | "..string.format("%.1f", 100*val[5]/cbt).."%")
			getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i)).user = val[8]
			getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i)):Show()
		end
	end
end

function DPSMate.Modules.DetailsDamageTotal:ShowTooltip(user, obj)
	local name = DPSMate:GetUserById(user)
	local a,b,c = DPSMate.Modules.Damage:EvalTable(DPSMateUser[name], curKey)
	local pet = ""
	GameTooltip:SetOwner(obj, "TOPLEFT")
	GameTooltip:AddLine(name.."'s damage done", 1,1,1)
	for i=1, DPSMateSettings["subviewrows"] do
		if not a[i] then break end
		if a[i][2] then pet="(Pet)" else pet="" end
		GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i][1])..pet,c[i],1,1,1,1,1,1)
	end
	GameTooltip:Show()
end
