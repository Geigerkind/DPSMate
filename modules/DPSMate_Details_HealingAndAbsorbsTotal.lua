DPSMate.Modules.DetailsHABTotal = {}

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

function DPSMate.Modules.DetailsHABTotal:UpdateDetails(obj, key)
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
		g=DPSMate.Options.graph:CreateGraphLine("HABTLineGraph",DPSMate_Details_HABTotal_DiagramLine,"CENTER","CENTER",0,0,740,220)
		g2=DPSMate.Options.graph:CreateStackedGraph("HABTStackedGraph",DPSMate_Details_HABTotal_DiagramLine,"CENTER","CENTER",0,0,850,220)
		g2:SetGridColor({0.5,0.5,0.5,0.5})
		g2:SetAxisDrawing(true,true)
		g2:SetAxisColor({1.0,1.0,1.0,1.0})
		g2:SetAutoScale(true)
		g2:SetYLabels(true, false)
		g2:SetXLabels(true)
		g2:Hide()
		DPSMate.Modules.DetailsHABTotal:CreateGraphTable()
	end
	DPSMate_Details_HABTotal_PlayerList_CB:SetChecked(false)
	DPSMate_Details_HABTotal_PlayerList_CB.act = false
	DPSMate_Details_HABTotal_Title:SetText(DPSMate.L["habsum"])
	self:LoadTable()
	self:LoadLegendButtons()
	if toggle then
		self:UpdateStackedGraph()
	else
		self:UpdateLineGraph()
	end
	DPSMate_Details_HABTotal:Show()
	DPSMate_Details_HABTotal:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsHABTotal:UpdateLineGraph()	
	g:ResetData()
	g:SetGridColor({0.5,0.5,0.5,0.5})
	g:SetAxisDrawing(true,true)
	g:SetAxisColor({1.0,1.0,1.0,1.0})
	g:SetAutoScale(true)
	g:SetYLabels(true, false)
	g:SetXLabels(true)
	g2:Hide()
	DPSMate_Details_HABTotal_DiagramLine:SetWidth(770)
	DPSMate_Details_HABTotal_DiagramLegend:Show()
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

function DPSMate.Modules.DetailsHABTotal:UpdateStackedGraph()
	g:Hide()
	DPSMate_Details_HABTotal_DiagramLine:SetWidth(870)
	DPSMate_Details_HABTotal_DiagramLegend:Hide()
	
	local Data1 = {}
	local label = {}
	local maxX, maxY = 0,0
	local p = {}
	for cat, val in DPSMateEHealing[curKey] do
		local temp = {}
		local user = DPSMate:GetUserById(cat)
		if DPSMate:ApplyFilter(curKey, user) then
			for ca, va in val do
				if ca~="i" then
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
			tinsert(label, 1, user)
			tinsert(Data1, 1, temp)
		end
	end
	
	for cat, val in db do
		for qq, uu in val do
			local temp = {}
			local ownername = DPSMate:GetUserById(qq)
			if DPSMate:ApplyFilter(curKey, ownername) then
				for ca, va in uu["i"] do
					local i, dmg = 1, 5
					if DPSMateDamageTaken[1][cat] then
						if DPSMateDamageTaken[1][cat][va[2]] then
							if DPSMateDamageTaken[1][cat][va[2]][va[3]] then
								dmg = DPSMateDamageTaken[1][cat][va[2]][va[3]][14]
								if dmg>DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])] then
									dmg = DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])]
								end
							end
						end
					end
					if dmg==5 or dmg==0 then
						dmg = ceil((1/15)*((DPSMateUser[ownername][8] or 60)/60)*DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])]*0.33)
					end
					if va[4] then
						dmg = dmg + va[4]
					end
					if dmg>0 then
						local i = 1
						while true do
							if not temp[i] then
								tinsert(temp, i, {va[1], dmg})
								break
							elseif va[1]<=temp[i][1] then
								tinsert(temp, i, {va[1], dmg})
								break
							end
							i=i+1
						end
					end
				end
				tinsert(label, 1, ownername)
				tinsert(Data1, 1, temp)
			end
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

function DPSMate.Modules.DetailsHABTotal:ToggleMode()
	if toggle then
		self:UpdateLineGraph()
		toggle=false
	else
		self:UpdateStackedGraph()
		toggle=true
	end
end

function DPSMate.Modules.DetailsHABTotal:GetSummarizedTable(arr)
	return DPSMate.Sync:GetSummarizedTable(arr)
end

function DPSMate.Modules.DetailsHABTotal:CreateGraphTable()
	local lines = {}
	for i=1, 8 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(DPSMate_Details_HABTotal_PlayerList, 10, 270-i*30, 860, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[9] = DPSMate.Options.graph:DrawLine(DPSMate_Details_HABTotal_PlayerList, 40, 260, 40, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(DPSMate_Details_HABTotal_PlayerList, 170, 260, 170, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(DPSMate_Details_HABTotal_PlayerList, 540, 260, 540, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
	
	lines[12] = DPSMate.Options.graph:DrawLine(DPSMate_Details_HABTotal_PlayerList, 600, 260, 600, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
	
	lines[13] = DPSMate.Options.graph:DrawLine(DPSMate_Details_HABTotal_PlayerList, 660, 260, 660, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[13]:Show()
	
	lines[13] = DPSMate.Options.graph:DrawLine(DPSMate_Details_HABTotal_PlayerList, 740, 260, 740, 10, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[13]:Show()
end

function DPSMate.Modules.DetailsHABTotal:AddTotalDataSeries()
	local sumTable, newArr = {[0]=0}, {}
	
	for cat, val in DPSMateEHealing[curKey] do
		if DPSMate:ApplyFilter(curKey, DPSMate:GetUserById(cat)) then
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
	end
	for cat, val in db do
		for qq, uu in val do
			local ownername = DPSMate:GetUserById(qq)
			if DPSMate:ApplyFilter(curKey, ownername) then
				for ca, va in uu["i"] do
					local i, dmg = 1, 5
					if DPSMateDamageTaken[1][cat] then
						if DPSMateDamageTaken[1][cat][va[2]] then
							if DPSMateDamageTaken[1][cat][va[2]][va[3]] then
								dmg = DPSMateDamageTaken[1][cat][va[2]][va[3]][14]
								if dmg>DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])] then
									dmg = DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])]
								end
							end
						end
					end
					if dmg==5 or dmg==0 then
						dmg = ceil((1/15)*((DPSMateUser[ownername][8] or 60)/60)*DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])]*0.33)
					end
					if va[4] then
						dmg = dmg + va[4]
					end
					if dmg>0 then
						if sumTable[va[1]] then
							sumTable[va[1]] = sumTable[va[1]] + dmg
						else
							sumTable[va[1]] = dmg
						end
					end
				end
			end
		end
	end
	
	local tl = DPSMate:TableLength(sumTable)
	if tl>50 then -- Hackfix.
		tl=50
	end
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

function DPSMate.Modules.DetailsHABTotal:GetTableValues()
	local arr, total = {}, 0
	for cat, val in DPSMateEHealing[curKey] do
		local name = DPSMate:GetUserById(cat)
		if DPSMate:ApplyFilter(curKey, name) then
			local crit, totCrit, miss, totMiss, time, last = 0, 0.000001, 0, 0.000001, 0, 0
			for ca, va in val do
				if ca~="i" then
					totCrit=totCrit+va[3]+va[2]
					totMiss=totMiss+va[2]+va[3]
					crit=crit+va[3]
					miss=miss+va[2]
				else
					time = tonumber(strformat("%.2f", DPSMateCombatTime["effective"][curKey][name] or 0))
				end
			end
			tinsert(arr, {name, val["i"], crit, miss, time, totCrit, totMiss, cat})
			total = total + val["i"]
		end
	end
	
	local temp = {}
	for cat, val in db do -- 28 Target
		local PerPlayerAbsorb = 0
		local totHits = 0
		for ca, va in pairs(val) do -- 28 Owner
			local ownername = DPSMate:GetUserById(ca)
			if DPSMate:ApplyFilter(curKey, ownername) then
				local PerOwnerAbsorb = 0
				for c, v in pairs(va) do -- Power Word: Shield
					if c~="i" then
						local shieldname = DPSMate:GetAbilityById(c)
						local PerAbilityAbsorb = 0
						for ce, ve in pairs(v) do -- 1
							local PerShieldAbsorb = 0
							for cet, vel in pairs(ve) do
								if cet~="i" then
									local totalHits = 0
									for qq,ss in vel do
										totalHits = totalHits + ss
									end
									for qq,ss in vel do
										local p = 5
										if DPSMateDamageTaken[1][cat] then
											if DPSMateDamageTaken[1][cat][cet] then
												if DPSMateDamageTaken[1][cat][cet][qq] then
													if DPSMateDamageTaken[1][cat][cet][qq][14]~=0 then
														p=ceil(DPSMateDamageTaken[1][cat][cet][qq][14])
													end
												end
											end
										elseif DPSMateEDT[1][cat] then
											if DPSMateEDT[1][cat][cet] then
												if DPSMateEDT[1][cat][cet][qq] then
													if DPSMateEDT[1][cat][cet][qq][4]~=0 then
														p=ceil((DPSMateEDT[1][cat][cet][qq][4]+DPSMateEDT[1][cat][cet][qq][8])/2)
													end
												end
											end
										end
										if p>DPSMate.DB.FixedShieldAmounts[shieldname] then
											p = DPSMate.DB.FixedShieldAmounts[shieldname]
										end
										if p==5 or p==0 then
											p = ceil((1/totalHits)*((DPSMateUser[ownername][8] or 60)/60)*DPSMate.DB.FixedShieldAmounts[shieldname]*0.33)
										end
										PerShieldAbsorb=PerShieldAbsorb+ss*p
									end
									totHits = totHits + totalHits
								end
							end
							if ve["i"][1]==1 then
								PerShieldAbsorb=PerShieldAbsorb+ve["i"][2]
							end
							PerAbilityAbsorb = PerAbilityAbsorb+PerShieldAbsorb
						end
						PerOwnerAbsorb = PerOwnerAbsorb+PerAbilityAbsorb
					end
				end
				PerPlayerAbsorb = PerPlayerAbsorb+PerOwnerAbsorb
				if temp[ownername] then
					temp[ownername][2] = temp[ownername][2] + PerOwnerAbsorb
					temp[ownername][4] = temp[ownername][4] + totHits
					temp[ownername][6] = temp[ownername][6] + totHits
					temp[ownername][7] = temp[ownername][7] + totHits
				else
					temp[ownername] = {ownername, PerOwnerAbsorb, 0, totHits, DPSMateCombatTime["effective"][curKey][ownername] or 0, totHits, totHits, ca}
				end
			end
		end
	end
	
	-- Merging!
	for ca, va in temp do
		for c, v in arr do
			if v[1]==ca and temp[ca] then
				arr[c][2] = arr[c][2] + va[2]
				arr[c][4] = arr[c][4] + va[4]
				arr[c][6] = arr[c][6] + va[4]
				arr[c][7] = arr[c][7] + va[4]  
				total = total + va[2]
				temp[ca] = nil
			end
		end
	end
	
	for ca, va in temp do
		if va then
			tinsert(arr, va)
			total = total + va[2]
		end
	end
	temp = nil
	
	local newArr = {}
	for cat, val in arr do
		if val[2]>0 then
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
	end
	return newArr, total
end

function DPSMate.Modules.DetailsHABTotal:CheckButtonCheckAll(obj)
	if obj.act then
		obj.act = false
		for i=1, 30 do 
			local ob = _G("DPSMate_Details_HABTotal_PlayerList_Child_R"..i)
			if ob.user then
				self:RemoveLinesButton(ob.user, ob)
				_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..i.."_CB"):SetChecked(obj.act)
			end
		end
	else
		obj.act = true
		for i=1, 30 do 
			local ob = _G("DPSMate_Details_HABTotal_PlayerList_Child_R"..i)
			if ob.user then
				self:RemoveLinesButton(ob.user, ob)
				self:AddLinesButton(ob.user, ob)
				_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..i.."_CB"):SetChecked(obj.act)
			end
		end
	end
end

function DPSMate.Modules.DetailsHABTotal:SortLineTable(uid)
	local newArr = {}
	-- user
	for cat, val in DPSMateEHealing[curKey][uid] do
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
	
	local ownername = DPSMate:GetUserById(uid)
	for cat, val in db do
		if val[uid] then
			for ca, va in val[uid]["i"] do
				local i, dmg = 1, 5
				if DPSMateDamageTaken[1][cat] then
					if DPSMateDamageTaken[1][cat][va[2]] then
						if DPSMateDamageTaken[1][cat][va[2]][va[3]] then
							dmg = DPSMateDamageTaken[1][cat][va[2]][va[3]][14]
							if dmg>DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])] then
								dmg = DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])]
							end
						end
					end
				end
				if dmg==5 or dmg==0 then
					dmg = ceil((1/15)*((DPSMateUser[ownername][8] or 60)/60)*DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])]*0.33)
				end
				if va[4] then
					dmg = dmg + va[4]
				end
				if dmg>0 then
					while true do
						if (not newArr[i]) then
							tinsert(newArr, i, {va[1], dmg})
							break
						else
							if newArr[i][1] > va[1] then
								tinsert(newArr, i, {va[1], dmg})
								break
							end
						end
						i=i+1
					end
				end
			end
		end
	end
	return newArr
end

function DPSMate.Modules.DetailsHABTotal:AddLinesButton(uid, obj)
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
	DPSMate_Details_HABTotal_DiagramLine:SetWidth(770)
	DPSMate_Details_HABTotal_DiagramLegend:Show()
	g:Show()
	toggle=false
	obj.act = true
	self:LoadLegendButtons()
end

function DPSMate.Modules.DetailsHABTotal:RemoveLinesButton(uid, obj)
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
	DPSMate_Details_HABTotal_DiagramLine:SetWidth(770)
	DPSMate_Details_HABTotal_DiagramLegend:Show()
	g:Show()
	toggle = false
	self:LoadLegendButtons()
end

function DPSMate.Modules.DetailsHABTotal:LoadLegendButtons()
	for i=1, 30 do
		_G("DPSMate_Details_HABTotal_DiagramLegend_Child_C"..i):Hide()
	end
	for cat, val in buttons do
		local name = DPSMate:GetUserById(val[2])
		local font = _G("DPSMate_Details_HABTotal_DiagramLegend_Child_C"..cat.."_Font")
		font:SetText(name)
		font:SetTextColor(DPSMate:GetClassColor(DPSMateUser[name][2]))
		_G("DPSMate_Details_HABTotal_DiagramLegend_Child_C"..cat.."_SwatchBg"):SetTexture(val[1][1],val[1][2],val[1][3],1)
		_G("DPSMate_Details_HABTotal_DiagramLegend_Child_C"..cat):Show()
	end
end

function DPSMate.Modules.DetailsHABTotal:RoundToH(val)
	if val>100 then
		return 100
	end
	return val
end

function DPSMate.Modules.DetailsHABTotal:CompareVal(x,y)
	if x>y then
		return y
	end
	return x
end

function DPSMate.Modules.DetailsHABTotal:LoadTable()
	local arr, total = self:GetTableValues()
	local i = 0
	for i=1, 30 do
		_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..i):Hide()
		_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..i.."_CB"):SetChecked(false)
		_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..i.."_CB").act = false
	end
	for cat, val in arr do
		if DPSMateUser[val[1]][4] then
			i=i+1
		else
			if (cat-i)>30 then break end
			local r,g,b = DPSMate:GetClassColor(DPSMateUser[val[1]][2])
			_G("DPSMate_Details_HABTotal_PlayerList_Child"):SetHeight((cat-i)*30)
			_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..(cat-i).."_Name"):SetText(val[1])
			_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..(cat-i).."_Name"):SetTextColor(r,g,b)
			_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..(cat-i).."_Amount"):SetText(val[2])
			_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..(cat-i).."_StatusBar"):SetValue(100*val[2]/arr[1][2])
			_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..(cat-i).."_StatusBar"):SetStatusBarColor(r,g,b, 1)
			_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..(cat-i).."_AmountPerc"):SetText(strformat("%.1f", 100*val[2]/total).."%")
			_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..(cat-i).."_Crit"):SetText(strformat("%.1f", 100*val[3]/val[6]).."%")
			_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..(cat-i).."_Hit"):SetText(strformat("%.1f", 100*val[4]/val[7]).."%")
			_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..(cat-i).."_HPS"):SetText(strformat("%.1f", val[2]/cbt))
			_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..(cat-i).."_ActiveTime"):SetText(self:CompareVal(ceil(val[5]), ceil(cbt)).."s | "..strformat("%.1f", self:RoundToH(100*val[5]/cbt)).."%")
			_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..(cat-i)).user = val[8]
			_G("DPSMate_Details_HABTotal_PlayerList_Child_R"..(cat-i)):Show()
		end
	end
end

function DPSMate.Modules.DetailsHABTotal:ShowTooltip(user, obj)
	local name = DPSMate:GetUserById(user)
	local a,b,c = DPSMate.Modules.HealingAndAbsorbs:EvalTable(DPSMateUser[name], curKey)
	GameTooltip:SetOwner(obj, "TOPLEFT")
	GameTooltip:AddLine(name.."'s "..strlower(DPSMate.L["tehealing"]), 1,1,1)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i][1].." ("..strformat("%.2f", 100*c[i][1]/b).."%)",1,1,1,1,1,1)
		end
	end
	GameTooltip:Show()
end
