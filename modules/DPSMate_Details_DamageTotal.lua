DPSMate.Modules.DetailsDamageTotal = {}

local g = nil
local curKey = 1
local db, cbt = {}, 0
local buttons = {}
local ColorTable={}
local _G = getglobal
local tinsert = table.insert
local tremove = table.remove
local strformat = string.format


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
		g=DPSMate.Options.graph:CreateGraphLine("LineGraph",DPSMate_Details_DamageTotal_DiagramLine,"CENTER","CENTER",0,0,750,230)
		DPSMate.Modules.DetailsDamageTotal:CreateGraphTable()
	end
	DPSMate_Details_DamageTotal_PlayerList_CB:SetChecked(false)
	DPSMate_Details_DamageTotal_PlayerList_CB.act = false
	DPSMate_Details_DamageTotal_Title:SetText(DPSMate.L["dmgdonesum"])
	self:UpdateLineGraph()
	self:LoadTable()
	self:LoadLegendButtons()
	DPSMate_Details_DamageTotal:Show()
end

function DPSMate.Modules.DetailsDamageTotal:UpdateLineGraph()	
	g:ResetData()
	g:SetGridColor({0.5,0.5,0.5,0.5})
	g:SetAxisDrawing(true,true)
	g:SetAxisColor({1.0,1.0,1.0,1.0})
	g:SetAutoScale(true)
	g:SetYLabels(true, false)
	g:SetXLabels(true)
	self:AddTotalDataSeries()
end

function DPSMate.Modules.DetailsDamageTotal:GetSummarizedTable(arr)
	return DPSMate.Sync:GetSummarizedTable(arr)
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
	local tl = DPSMate:TableLength(db)
	tl = floor(tl-0.3*tl)
	
	for cat, val in db do
		for ca, va in val do
			if ca~="i" and va["i"] then
				for c,v in va["i"] do
					if sumTable[c] then
						sumTable[c] = sumTable[c] + v
					else
						sumTable[c] = v
					end
				end
			end
		end
	end
	for cat, val in sumTable do
		local i=1
		while true do
			if (not newArr[i]) then 
				tinsert(newArr, i, {cat, val/tl})
				break
			end
			if cat<newArr[i][1] then
				tinsert(newArr, i, {cat, val/tl})
				break
			end
			i=i+1
		end
	end
	
	totSumTable = self:GetSummarizedTable(newArr)
	
	local totMax = DPSMate:GetMaxValue(totSumTable, 2)
	local time = DPSMate:GetMaxValue(totSumTable, 1)
	g:SetXAxis(0,time)
	g:SetYAxis(0,totMax)
	g:SetGridSpacing(time/10,(totMax)/2)
	
	g:AddDataSeries(totSumTable,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, {})
end

function DPSMate.Modules.DetailsDamageTotal:GetTableValues()
	local arr, total = {}, 0
	for cat, val in db do
		local crit, totCrit, miss, totMiss, time, last = 0, 0.000001, 0, 0.000001, 0, 0
		local name = DPSMate:GetUserById(cat)
		for ca, va in val do
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
				local delay, last = 2.8, 0
				local t = self:SortLineTable(cat)
				for cat, val in t do
					if last == 0 or (val[1]-last)>delay then
						last = val[1]
					else
						time = time + (val[1]-last)
					end
				end
			end
		end
		tinsert(arr, {name, val["i"], crit, miss, time, totCrit, totMiss, cat})
		total = total + val["i"]
	end
	local newArr = {}
	for cat, val in arr do
		local i = 1
		while true do
			if (not newArr[i]) then
				tinsert(newArr, i, val)
				break
			else
				if newArr[i][2] < val[2] then
					tinsert(newArr, i, val)
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
			local ob = _G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..i)
			if ob.user then
				self:RemoveLinesButton(ob.user, ob)
				_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..i.."_CB"):SetChecked(obj.act)
			end
		end
	else
		obj.act = true
		for i=1, 30 do 
			local ob = _G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..i)
			if ob.user then
				self:AddLinesButton(ob.user, ob)
				_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..i.."_CB"):SetChecked(obj.act)
			end
		end
	end
end

function DPSMate.Modules.DetailsDamageTotal:SortLineTable(uid)
	local user = DPSMate:GetUserById(uid)
	local newArr = {}
	-- user
	for cat, val in db[DPSMateUser[user][1]] do
		if cat~="i" and val["i"] then
			for c,v in val["i"] do
				local i = 1
				while true do
					if not newArr[i] then
						tinsert(newArr, i, {c,v})
						break
					elseif c<=newArr[i][1] then
						tinsert(newArr, i, {c,v})
						break
					end
					i = i+1
				end
			end
		end
	end
	-- Pet
	if DPSMateUser[user][5] then
		if db[DPSMateUser[DPSMateUser[user][5]][1]] then
			for cat, val in db[DPSMateUser[DPSMateUser[user][5]][1]] do
				if cat~="i" and val["i"] then
					for c,v in val["i"] do
						local i = 1
						while true do
							if not newArr[i] then
								tinsert(newArr, i, {c,v})
								break
							elseif c<=newArr[i][1] then
								tinsert(newArr, i, {c,v})
								break
							end
							i = i+1
						end
					end
				end
			end
		end
	end
	return newArr
end

function DPSMate.Modules.DetailsDamageTotal:AddLinesButton(uid, obj)
	local sumTable = self:SortLineTable(uid)
	
	sumTable = self:GetSummarizedTable(sumTable)
	
	g:AddDataSeries(sumTable, {ColorTable[1], {}}, {})
	tinsert(buttons, {ColorTable[1], uid, sumTable})
	tremove(ColorTable, 1)
	obj.act = true
	self:LoadLegendButtons()
end

function DPSMate.Modules.DetailsDamageTotal:RemoveLinesButton(uid, obj)
	obj.act = false
	g:ResetData()
	for cat, val in pairs(buttons) do
		if val[2]==uid then
			tinsert(ColorTable, 1, val[1])
			tremove(buttons, cat)
			break
		end
	end
	
	g:AddDataSeries(totSumTable,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, {})
	for cat, val in pairs(buttons) do		
		g:AddDataSeries(val[3], {val[1], {}}, {})
	end
	self:LoadLegendButtons()
end

function DPSMate.Modules.DetailsDamageTotal:LoadLegendButtons()
	for i=1, 30 do
		_G("DPSMate_Details_DamageTotal_DiagramLegend_Child_C"..i):Hide()
	end
	for cat, val in buttons do
		local name = DPSMate:GetUserById(val[2])
		local font = _G("DPSMate_Details_DamageTotal_DiagramLegend_Child_C"..cat.."_Font")
		font:SetText(name)
		font:SetTextColor(DPSMate:GetClassColor(DPSMateUser[name][2]))
		_G("DPSMate_Details_DamageTotal_DiagramLegend_Child_C"..cat.."_SwatchBg"):SetTexture(val[1][1],val[1][2],val[1][3],1)
		_G("DPSMate_Details_DamageTotal_DiagramLegend_Child_C"..cat):Show()
	end
end

function DPSMate.Modules.DetailsDamageTotal:LoadTable()
	local arr, total = self:GetTableValues()
	local i = 0
	for i=1, 30 do
		_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..i):Hide()
		_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..i.."_CB"):SetChecked(false)
		_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..i.."_CB").act = false
	end
	for cat, val in arr do
		if DPSMateUser[val[1]][4] then
			i=i+1
		else
			if (cat-i)>30 then break end
			local r,g,b = DPSMate:GetClassColor(DPSMateUser[val[1]][2])
			_G("DPSMate_Details_DamageTotal_PlayerList_Child"):SetHeight((cat-i)*30-210)
			_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_Name"):SetText(val[1])
			_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_Name"):SetTextColor(r,g,b)
			_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_Amount"):SetText(val[2])
			_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_StatusBar"):SetValue(100*val[2]/arr[1][2])
			_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_StatusBar"):SetStatusBarColor(r,g,b, 1)
			_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_AmountPerc"):SetText(strformat("%.1f", 100*val[2]/total).."%")
			_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_Crit"):SetText(strformat("%.1f", 100*val[3]/val[6]).."%")
			_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_Miss"):SetText(strformat("%.1f", 100*val[4]/val[7]).."%")
			_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_DPS"):SetText(strformat("%.1f", val[2]/cbt))
			_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i).."_ActiveTime"):SetText(ceil(val[5]).."s | "..strformat("%.1f", 100*val[5]/cbt).."%")
			_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i)).user = val[8]
			_G("DPSMate_Details_DamageTotal_PlayerList_Child_R"..(cat-i)):Show()
		end
	end
end

function DPSMate.Modules.DetailsDamageTotal:ShowTooltip(user, obj)
	local name = DPSMate:GetUserById(user)
	local a,b,c = DPSMate.Modules.Damage:EvalTable(DPSMateUser[name], curKey)
	local pet = ""
	GameTooltip:SetOwner(obj, "TOPLEFT")
	GameTooltip:AddLine(name.."'s "..strlower(DPSMate.L["damagedone"]), 1,1,1)
	for i=1, DPSMateSettings["subviewrows"] do
		if not a[i] then break end
		if c[i][2] then pet="(Pet)" else pet="" end
		GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i])..pet,c[i][1].." ("..strformat("%.2f", 100*c[i][1]/b).."%)",1,1,1,1,1,1)
	end
	GameTooltip:Show()
end
