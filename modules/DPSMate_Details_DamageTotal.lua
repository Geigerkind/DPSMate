DPSMate.Modules.DetailsDamageTotal = {}

local g = nil
local curKey = 1
local db, cbt = {}, 0

function DPSMate.Modules.DetailsDamageTotal:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	if not g then
		g=DPSMate.Options.graph:CreateGraphLine("LineGraph",DPSMate_Details_DamageTotal_DiagramLine,"CENTER","CENTER",0,0,750,230)
		DPSMate.Modules.DetailsDamageTotal:CreateGraphTable()
	end
	DPSMate_Details_DamageTotal_Title:SetText("Damage done summary")
	DPSMate.Modules.DetailsDamageTotal:UpdateLineGraph()
	DPSMate.Modules.DetailsDamageTotal:LoadTable()
	DPSMate_Details_DamageTotal:Show()
end

function DPSMate.Modules.DetailsDamageTotal:UpdateLineGraph()
	--local arr = db
	--local sumTable = DPSMate.Modules.DetailsDamage:GetSummarizedTable(arr, cbt)
	--local max = DPSMate.Modules.DetailsDamage:GetMaxLineVal(sumTable)
	local max = 2000
	
	g:ResetData()
	g:SetXAxis(0,cbt)
	g:SetYAxis(0,max+200)
	g:SetGridSpacing(cbt/10,max/7)
	g:SetGridColor({0.5,0.5,0.5,0.5})
	g:SetAxisDrawing(true,true)
	g:SetAxisColor({1.0,1.0,1.0,1.0})
	g:SetAutoScale(true)
	g:SetYLabels(true, false)
	g:SetXLabels(true)

	local Data1={{0,0}}
	--for cat, val in pairs(sumTable) do
	--	table.insert(Data1, {val[1],val[2], DPSMate.Modules.DetailsDamage:CheckProcs(DPSMate_Details.proc, val[1])})
	--end

	--g:AddDataSeries(Data1,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, {})+
	DPSMate.Modules.DetailsDamageTotal:AddTotalDataSeries()
end

function DPSMate.Modules.DetailsDamageTotal:SortLineTable(t)
	local newArr = {}
	for cat, val in pairs(t) do
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

function DPSMate.Modules.DetailsDamageTotal:GetSummarizedTable(arr, cbt)
	local newArr, lastCBT, i = {}, 0, 1
	local TL = DPSMate:TableLength(arr)
	local dis = 1
	if TL>50 then dis = floor(TL/50) end
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

function DPSMate.Modules.DetailsDamageTotal:GetMaxLineVal(t)
	local max = 0
	for cat, val in pairs(t) do
		if val[2]>max then
			max=val[2]
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

function DPSMate.Modules.DetailsDamageTotal:AddTotalDataSeries()
	local sumTable = {[0]=0}
	
	for cat, val in pairs(db) do
		for ca, va in pairs(db[cat]["i"][1]) do
			if sumTable[ca] then
				sumTable[ca] = sumTable[ca] + va
			else
				sumTable[ca] = va
			end
		end
	end
	
	sumTable = DPSMate.Modules.DetailsDamageTotal:SortLineTable(sumTable)
	sumTable = DPSMate.Modules.DetailsDamageTotal:GetSummarizedTable(sumTable, cbt)
	
	for cat, val in pairs(sumTable) do
		val[2] = val[2]/4
	end
	local totMax = DPSMate.Modules.DetailsDamageTotal:GetMaxLineVal(sumTable)
	g:SetYAxis(0,totMax+200)
	g:SetGridSpacing(cbt/10,totMax/7)
	
	g:AddDataSeries(sumTable,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, {})
end

function DPSMate.Modules.DetailsDamageTotal:GetTableValues()
	local arr, total = {}, 0
	for cat, val in pairs(db) do
		local crit, totCrit, miss, totMiss, time, last = 0, 0.000001, 0, 0.000001, 0, 0
		local name = DPSMate:GetUserById(cat)
		for ca, va in pairs(val) do
			if ca~="i" then
				if va[5]>0 then
					totCrit=totCrit+va[1]+va[5]+va[9]+va[10]+va[11]+va[12]
					crit=crit+va[5]
				end
				if va[9]>0 or va[10]>0 or va[11]>0 or va[12]>0 then
					totMiss=totMiss+va[1]+va[5]+va[9]+va[10]+va[11]+va[12]
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
				for _, v in pairs(DPSMate.Modules.DetailsDamageTotal:SortLineTable(va[1])) do
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

local ColorTable={
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

local colorIndex = 1

function DPSMate.Modules.DetailsDamageTotal:AddLinesButton(uid)
	local sumTable = {[0]=0}
	
	sumTable = DPSMate.Modules.DetailsDamageTotal:SortLineTable(db[uid]["i"][1])
	sumTable = DPSMate.Modules.DetailsDamageTotal:GetSummarizedTable(sumTable, cbt)
	
	g:AddDataSeries(sumTable, {ColorTable[colorIndex], {}}, {})
	colorIndex = colorIndex+1
end

function DPSMate.Modules.DetailsDamageTotal:LoadTable()
	local arr, total = DPSMate.Modules.DetailsDamageTotal:GetTableValues()
	for i=1, 30 do
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..i):Hide()
	end
	for cat, val in pairs(arr) do
		local r,g,b = DPSMate:GetClassColor(DPSMateUser[val[1]][2])
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child"):SetHeight((cat)*30-210)
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..cat.."_Name"):SetText(val[1])
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..cat.."_Name"):SetTextColor(r,g,b)
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..cat.."_Amount"):SetText(val[2])
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..cat.."_StatusBar"):SetValue(100*val[2]/arr[1][2])
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..cat.."_StatusBar"):SetStatusBarColor(r,g,b, 1)
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..cat.."_AmountPerc"):SetText(string.format("%.1f", 100*val[2]/total).."%")
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..cat.."_Crit"):SetText(string.format("%.1f", 100*val[3]/val[6]).."%")
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..cat.."_Miss"):SetText(string.format("%.1f", 100*val[4]/val[7]).."%")
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..cat.."_DPS"):SetText(string.format("%.1f", val[2]/cbt))
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..cat.."_ActiveTime"):SetText(ceil(val[5]).."s | "..string.format("%.1f", 100*val[5]/cbt).."%")
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..cat).user = val[8]
		getglobal("DPSMate_Details_DamageTotal_PlayerList_Child_R"..cat):Show()
	end
end
