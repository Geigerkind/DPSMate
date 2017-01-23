DPSMate.Modules.DetailsFFTTotal = {}

local g, g2 = nil,nil
local curKey = 1
local db, cbt = {}, 0
local buttons = {}
local ColorTable={}
local _G = getglobal
local tinsert = table.insert
local tremove = table.remove
local strformat = string.format
local toggle = false
local totSumTable = {}
local totMax = 0
local totTime = 0

function DPSMate.Modules.DetailsFFTTotal:UpdateDetails(obj, key)
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
		g=DPSMate.Options.graph:CreateGraphLine("FFTTTLineGraph",DPSMate_Details_FFTTotal_DiagramLine,"CENTER","CENTER",0,0,740,220)
		g2=DPSMate.Options.graph:CreateStackedGraph("FFTTTStackedGraph",DPSMate_Details_FFTTotal_DiagramLine,"CENTER","CENTER",0,0,850,220)
		g2:SetGridColor({0.5,0.5,0.5,0.5})
		g2:SetAxisDrawing(true,true)
		g2:SetAxisColor({1.0,1.0,1.0,1.0})
		g2:SetAutoScale(true)
		g2:SetYLabels(true, false)
		g2:SetXLabels(true)
		g2:Hide()
		DPSMate.Modules.DetailsFFTTotal:CreateGraphTable()
	end
	DPSMate_Details_FFTTotal_PlayerList_CB:SetChecked(false)
	DPSMate_Details_FFTTotal_PlayerList_CB.act = false
	DPSMate_Details_FFTTotal_Title:SetText(DPSMate.L["fftsum"])
	self:LoadTable()
	self:LoadLegendButtons()
	if toggle then
		self:UpdateStackedGraph()
	else
		self:UpdateLineGraph()
	end
	DPSMate_Details_FFTTotal:Show()
	DPSMate_Details_FFTTotal:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsFFTTotal:UpdateLineGraph()	
	g:ResetData()
	g:SetGridColor({0.5,0.5,0.5,0.5})
	g:SetAxisDrawing(true,true)
	g:SetAxisColor({1.0,1.0,1.0,1.0})
	g:SetAutoScale(true)
	g:SetYLabels(true, false)
	g:SetXLabels(true)
	g2:Hide()
	DPSMate_Details_FFTTotal_DiagramLine:SetWidth(770)
	DPSMate_Details_FFTTotal_DiagramLegend:Show()
	g:Show()
	toggle=false
	self:AddTotalDataSeries()
	local Max = totMax
	for cat, val in pairs(buttons) do		
		g:AddDataSeries(val[3], {val[1], {}}, {})
		local temp = DPSMate:GetMaxValue(val[3], 2)
		if temp>Max then
			Max = temp
		end
	end
	g:SetGridSpacing(totTime/10,Max/7)
end

function DPSMate.Modules.DetailsFFTTotal:UpdateStackedGraph()
	g:Hide()
	DPSMate_Details_FFTTotal_DiagramLine:SetWidth(870)
	DPSMate_Details_FFTTotal_DiagramLegend:Hide()
	
	local Data1 = {}
	local label = {}
	local maxX, maxY = 0,0
	local p = {}
	
	for cat, val in db do
		local name = DPSMate:GetUserById(cat)
		local temp = {}
		for q, s in val do
			local catName = DPSMate:GetUserById(q)
			if DPSMate:ApplyFilter(curKey, catName) and  DPSMateUser[catName] and  DPSMateUser[name] then
				if DPSMateUser[name][3] == DPSMateUser[catName][3] and DPSMateUser[catName][3] and DPSMateUser[name][3] then
					for ca, va in s do
						if ca~="i" and va["i"] then
							for c,v in va["i"] do
								local i = 1
								while true do
									if not temp[i] then
										tinsert(temp, i, {c,v})
										break
									elseif c<=temp[i][1] then
										tinsert(temp, i, {c,v})
										break
									end
									i=i+1
								end
								if p[c] then
									p[c] = p[c] + v
								else
									p[c] = v
								end
								if maxX == 0 or maxX<c then
									maxX = c
								end
							end
						end
					end
				end
			end
		end
		if temp[1] then
			tinsert(label, 1, name)
			tinsert(Data1, 1, temp)
		end
	end
	
	for cat, val in p do
		if maxY<val then
			maxY = val
		end
	end
	
	g2:ResetData()
	g2:SetGridSpacing(maxX/7,(maxY/2)/14)
	
	g2:AddDataSeries(Data1,{1.0,0.0,0.0,0.8}, {}, label)
	g2:Show()
	toggle=true
end

function DPSMate.Modules.DetailsFFTTotal:ToggleMode()
	if toggle then
		self:UpdateLineGraph()
		toggle=false
	else
		self:UpdateStackedGraph()
		toggle=true
	end
end

function DPSMate.Modules.DetailsFFTTotal:GetSummarizedTable(arr)
	return DPSMate.Sync:GetSummarizedTable(arr)
end

function DPSMate.Modules.DetailsFFTTotal:CreateGraphTable()
	local lines = {}
	for i=1, 8 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(DPSMate_Details_FFTTotal_PlayerList, 10, 270-i*30, 860, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[9] = DPSMate.Options.graph:DrawLine(DPSMate_Details_FFTTotal_PlayerList, 40, 260, 40, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(DPSMate_Details_FFTTotal_PlayerList, 170, 260, 170, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(DPSMate_Details_FFTTotal_PlayerList, 540, 260, 540, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
	
	lines[12] = DPSMate.Options.graph:DrawLine(DPSMate_Details_FFTTotal_PlayerList, 600, 260, 600, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
	
	lines[13] = DPSMate.Options.graph:DrawLine(DPSMate_Details_FFTTotal_PlayerList, 660, 260, 660, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[13]:Show()
	
	lines[13] = DPSMate.Options.graph:DrawLine(DPSMate_Details_FFTTotal_PlayerList, 740, 260, 740, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[13]:Show()
end

function DPSMate.Modules.DetailsFFTTotal:AddTotalDataSeries()
	local sumTable, newArr = {[0]=0}, {}
	local tl = 0
	local temp = {}
	
	for cat, val in db do
		local name = DPSMate:GetUserById(cat)
		for q, s in val do
			local catName = DPSMate:GetUserById(q)
			if DPSMate:ApplyFilter(curKey, catName) and  DPSMateUser[catName] and  DPSMateUser[name] then
				if DPSMateUser[name][3] == DPSMateUser[catName][3] and DPSMateUser[catName][3] and DPSMateUser[name][3] then
					temp[name] = true
					for ca, va in s do
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
			end
		end
	end
	
	tl = DPSMate:TableLength(temp)
	tl = ceil(tl-0.3*tl)
	
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
	
	totMax = DPSMate:GetMaxValue(totSumTable, 2)
	totTime = DPSMate:GetMaxValue(totSumTable, 1)
	g:SetXAxis(0,totTime)
	g:SetYAxis(0,totMax)
	g:SetGridSpacing(totTime/10,totMax/7)
	
	g:AddDataSeries(totSumTable,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, {})
end

function DPSMate.Modules.DetailsFFTTotal:GetTableValues()
	local total = 0
	local temp = {}
	for cat, val in db do
		local crit, totCrit, miss, totMiss, time, last = 0, 0.000001, 0, 0.000001, 0, 0
		local name = DPSMate:GetUserById(cat)
		for q, s in val do
			local CV = 0
			local catName = DPSMate:GetUserById(q)
			if DPSMate:ApplyFilter(curKey, catName) and  DPSMateUser[catName] and  DPSMateUser[name] then
				if DPSMateUser[name][3] == DPSMateUser[catName][3] and DPSMateUser[catName][3] and DPSMateUser[name][3] then
					for ca, va in s do
						if ca~="i" then
							totCrit=totCrit+va[1]+va[5]+va[9]+va[10]+va[11]+va[12]+va[14]
							crit=crit+va[5]
							totMiss=totMiss+va[1]+va[5]+va[9]+va[10]+va[11]+va[12]+va[14]
							miss=miss+va[9]+va[10]+va[11]+va[12]
							CV = CV + va[13]
						end
					end
					
					if temp[cat] then
						temp[cat][2] = temp[cat][2] + CV
						temp[cat][3] = temp[cat][3] + crit
						temp[cat][4] = temp[cat][4] + miss
						temp[cat][6] = temp[cat][6] + totCrit
						temp[cat][7] = temp[cat][7] + totMiss
					else
						temp[cat] = {name, CV, crit, miss, 0, totCrit, totMiss, cat}
					end
					total = total + CV
				end
			end
		end
	end
	local newArr = {}
	for cat, val in temp do
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

function DPSMate.Modules.DetailsFFTTotal:CheckButtonCheckAll(obj)
	if obj.act then
		obj.act = false
		for i=1, 30 do 
			local ob = _G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..i)
			if ob.user then
				self:RemoveLinesButton(ob.user, ob)
				_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..i.."_CB"):SetChecked(obj.act)
			end
		end
	else
		obj.act = true
		for i=1, 30 do 
			local ob = _G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..i)
			if ob.user then
				self:RemoveLinesButton(ob.user, ob)
				self:AddLinesButton(ob.user, ob)
				_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..i.."_CB"):SetChecked(obj.act)
			end
		end
	end
end

function DPSMate.Modules.DetailsFFTTotal:SortLineTable(uid)
	local user = DPSMate:GetUserById(uid)
	local newArr = {}
	-- user
	for cat, val in db do
		if cat~="i" then
			local name = DPSMate:GetUserById(cat)
			for q, s in val do
				if q==uid and q~="i" and DPSMate:ApplyFilter(curKey, user) and  DPSMateUser[user] and  DPSMateUser[name] then
					if DPSMateUser[name][3] == DPSMateUser[user][3] and DPSMateUser[user][3] and DPSMateUser[name][3] then
						for ca, va in s do
							if ca~="i" and va["i"] then
								for c,v in va["i"] do
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
			end
		end
	end
	return newArr
end

function DPSMate.Modules.DetailsFFTTotal:AddLinesButton(uid, obj)
	local sumTable = self:SortLineTable(uid)
	
	sumTable = self:GetSummarizedTable(sumTable)
	
	local Max = DPSMate:GetMaxValue(sumTable, 2)
	if Max > totMax then
		g:SetGridSpacing(totTime/10,Max/7)
	end
	
	g:AddDataSeries(sumTable, {ColorTable[1], {}}, {})
	tinsert(buttons, {ColorTable[1], uid, sumTable})
	tremove(ColorTable, 1)
	g2:Hide()
	DPSMate_Details_FFTTotal_DiagramLine:SetWidth(770)
	DPSMate_Details_FFTTotal_DiagramLegend:Show()
	g:Show()
	toggle=false
	obj.act = true
	self:LoadLegendButtons()
end

function DPSMate.Modules.DetailsFFTTotal:RemoveLinesButton(uid, obj)
	obj.act = false
	g:ResetData()
	for cat, val in pairs(buttons) do
		if val[2]==uid then
			tinsert(ColorTable, 1, val[1])
			tremove(buttons, cat)
			break
		end
	end
	
	local Max = totMax
	g:AddDataSeries(totSumTable,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, {})
	for cat, val in pairs(buttons) do		
		g:AddDataSeries(val[3], {val[1], {}}, {})
		local temp = DPSMate:GetMaxValue(val[3], 2)
		if temp>Max then
			Max = temp
		end
	end
	g:SetGridSpacing(totTime/10,Max/7)
	g2:Hide()
	DPSMate_Details_FFTTotal_DiagramLine:SetWidth(770)
	DPSMate_Details_FFTTotal_DiagramLegend:Show()
	g:Show()
	toggle = false
	self:LoadLegendButtons()
end

function DPSMate.Modules.DetailsFFTTotal:LoadLegendButtons()
	for i=1, 30 do
		_G("DPSMate_Details_FFTTotal_DiagramLegend_Child_C"..i):Hide()
	end
	for cat, val in buttons do
		local name = DPSMate:GetUserById(val[2])
		local font = _G("DPSMate_Details_FFTTotal_DiagramLegend_Child_C"..cat.."_Font")
		font:SetText(name)
		font:SetTextColor(DPSMate:GetClassColor(DPSMateUser[name][2]))
		_G("DPSMate_Details_FFTTotal_DiagramLegend_Child_C"..cat.."_SwatchBg"):SetTexture(val[1][1],val[1][2],val[1][3],1)
		_G("DPSMate_Details_FFTTotal_DiagramLegend_Child_C"..cat):Show()
	end
end

function DPSMate.Modules.DetailsFFTTotal:RoundToH(val)
	if val>100 then
		return 100
	end
	return val
end

function DPSMate.Modules.DetailsFFTTotal:CompareVal(x,y)
	if x>y then
		return y
	end
	return x
end

function DPSMate.Modules.DetailsFFTTotal:LoadTable()
	local arr, total = self:GetTableValues()
	local i = 0
	for i=1, 30 do
		_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..i):Hide()
		_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..i.."_CB"):SetChecked(false)
		_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..i.."_CB").act = false
	end
	for cat, val in arr do
		if DPSMateUser[val[1]][4] then
			i=i+1
		else
			if (cat-i)>30 then break end
			local r,g,b = DPSMate:GetClassColor(DPSMateUser[val[1]][2])
			_G("DPSMate_Details_FFTTotal_PlayerList_Child"):SetHeight((cat-i)*30)
			_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..(cat-i).."_Name"):SetText(val[1])
			_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..(cat-i).."_Name"):SetTextColor(r,g,b)
			_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..(cat-i).."_Amount"):SetText(val[2])
			_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..(cat-i).."_StatusBar"):SetValue(100*val[2]/arr[1][2])
			_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..(cat-i).."_StatusBar"):SetStatusBarColor(r,g,b, 1)
			_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..(cat-i).."_AmountPerc"):SetText(strformat("%.1f", 100*val[2]/total).."%")
			_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..(cat-i).."_Crit"):SetText(strformat("%.1f", 100*val[3]/val[6]).."%")
			_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..(cat-i).."_Miss"):SetText(strformat("%.1f", 100*val[4]/val[7]).."%")
			_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..(cat-i).."_DPS"):SetText(strformat("%.1f", val[2]/cbt))
			_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..(cat-i).."_ActiveTime"):SetText(self:CompareVal(ceil(val[5]), ceil(cbt)).."s | "..strformat("%.1f", self:RoundToH(100*val[5]/cbt)).."%")
			_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..(cat-i)).user = val[8]
			_G("DPSMate_Details_FFTTotal_PlayerList_Child_R"..(cat-i)):Show()
		end
	end
end

function DPSMate.Modules.DetailsFFTTotal:ShowTooltip(user, obj)
	local name = DPSMate:GetUserById(user)
	local a,b,c = DPSMate.Modules.FriendlyFireTaken:EvalTable(DPSMateUser[name], curKey)
	local pet = ""
	GameTooltip:SetOwner(obj, "TOPLEFT")
	GameTooltip:AddLine(name.."'s "..strlower(DPSMate.L["damagetaken"]), 1,1,1)
	for i=1, DPSMateSettings["subviewrows"] do
		if not a[i] then break end
		GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(a[i]),c[i][1].." ("..strformat("%.2f", 100*c[i][1]/b).."%)",1,1,1,1,1,1)
		for p=1, 3 do 
			if not c[i][2][p] or c[i][3][p]==0 then break end
			GameTooltip:AddDoubleLine("       "..p..". "..DPSMate:GetAbilityById(c[i][2][p]),c[i][3][p].." ("..strformat("%.2f", 100*c[i][3][p]/c[i][1]).."%)",0.5,0.5,0.5,0.5,0.5,0.5)
		end
	end
	GameTooltip:Show()
end
