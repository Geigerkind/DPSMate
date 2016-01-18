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
	sumTable = DPSMate.Modules.DetailsDamageTotal:GetSummarizedTable(sumTable, 1000)
	
	local max = DPSMate.Modules.DetailsDamageTotal:GetMaxLineVal(sumTable)
	g:SetYAxis(0,max+200)
	g:SetGridSpacing(cbt/10,max/7)
	
	g:AddDataSeries(sumTable,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, {})
end
