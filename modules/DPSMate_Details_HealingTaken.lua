-- Global Variables
DPSMate.Modules.DetailsHealingTaken = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailsUser, DetailsSelected  = {}, 0, {}, "", 1
local DetailsArrComp, DetailsTotalComp, DmgArrComp, DetailsUserComp, DetailsSelectedComp  = {}, 0, {}, "", 1
local g, g2, g3, g4
local curKey = 1
local db, cbt = {}, 0
local _G = getglobal
local tinsert = table.insert
local strformat = string.format
local toggle, toggle3 = false, false

function DPSMate.Modules.DetailsHealingTaken:UpdateDetails(obj, key)
	DPSMate_Details_CompareHealingTaken:Hide()
	DPSMate_Details_CompareHealingTaken_Graph:Hide()
	
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DetailsUserComp = nil
	DPSMate_Details_HealingTaken_Title:SetText(DPSMate.L["healtakenby"]..obj.user)
	DetailsArr, DetailsTotal, DmgArr = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[DetailsUser], curKey)
	DPSMate_Details_HealingTaken:Show()
	self:ScrollFrame_Update("")
	self:SelectCreatureButton(1,"")
	self:SelectDetailsButton(1,1,"")
	
	if not g then
		g=DPSMate.Options.graph:CreateStackedGraph("RHTStackedGraph",DPSMate_Details_HealingTaken_DiagramLine,"CENTER","CENTER",0,0,850,230)
		g:SetGridColor({0.5,0.5,0.5,0.5})
		g:SetAxisDrawing(true,true)
		g:SetAxisColor({1.0,1.0,1.0,1.0})
		g:SetAutoScale(true)
		g:SetYLabels(true, false)
		g:SetXLabels(true)
		g2=DPSMate.Options.graph:CreateGraphLine("RHTLineGraph",DPSMate_Details_HealingTaken_DiagramLine,"CENTER","CENTER",0,0,850,230)
	end
	
	if toggle then
		self:UpdateStackedGraph(g)
	else
		self:UpdateLineGraph(g2,"")
	end
	DPSMate_Details_HealingTaken:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsHealingTaken:UpdateCompare(obj, key, comp)
	self:UpdateDetails(obj, key)
	
	DPSMate_Details_CompareHealingTaken.proc = "None"
	--UIDropDownMenu_SetSelectedValue(DPSMate_Details_CompareEDD_DiagramLegend_Procs, "None")
	DetailsUserComp = comp
	DPSMate_Details_CompareHealingTaken_Title:SetText(DPSMate.L["healtakenby"]..comp)
	--UIDropDownMenu_Initialize(DPSMate_Details_CompareEDD_DiagramLegend_Procs, DPSMate.Modules.DetailsEDD.ProcsDropDown_Compare)
	DetailsArrComp, DetailsTotalComp, DmgArrComp = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[comp], curKey)
	
	if not g3 then
		g3=DPSMate.Options.graph:CreateStackedGraph("RHTStackedGraphComp",DPSMate_Details_CompareHealingTaken_DiagramLine,"CENTER","CENTER",0,0,850,230)
		g3:SetGridColor({0.5,0.5,0.5,0.5})
		g3:SetAxisDrawing(true,true)
		g3:SetAxisColor({1.0,1.0,1.0,1.0})
		g3:SetAutoScale(true)
		g3:SetYLabels(true, false)
		g3:SetXLabels(true)
		g4=DPSMate.Options.graph:CreateGraphLine("RHTLineGraphComp",DPSMate_Details_CompareHealingTaken_DiagramLine,"CENTER","CENTER",0,0,850,230)
		g7=DPSMate.Options.graph:CreateGraphLine("RHTGraphSumComp",DPSMate_Details_CompareHealingTaken_Graph,"CENTER","CENTER",0,0,1750,230)
	end
	
	self:ScrollFrame_Update("Compare", comp)
	self:SelectCreatureButton(1, "Compare", comp)
	self:SelectDetailsButton(1,1, "Compare", comp)
	
	if toggle then
		self:UpdateStackedGraph(g3, "Compare", comp)
	else
		self:UpdateLineGraph(g4, "Compare", comp)
	end
	self:UpdateSumGraph()
	
	DPSMate_Details_CompareHealingTaken:Show()
	DPSMate_Details_CompareHealingTaken_Graph:Show()
end

function DPSMate.Modules.DetailsHealingTaken:UpdateSumGraph()
	-- Executing the sumGraph
	local sumTable, sumTableTwo
	if toggle3 then
		sumTable = self:GetSummarizedTable(db, DetailsArrComp[DetailsSelectedComp], DetailsUserComp)
		sumTableTwo = self:GetSummarizedTable(db, DetailsArr[DetailsSelected])
	else
		sumTable = self:GetSummarizedTable(db, nil, DetailsUserComp)
		sumTableTwo = self:GetSummarizedTable(db, nil)
	end
	
	local max = DPSMate:GetMaxValue(sumTable, 2)
	local time = DPSMate:GetMaxValue(sumTable, 1)
	local min = DPSMate:GetMinValue(sumTable, 1)
	local maxT = DPSMate:GetMaxValue(sumTableTwo, 2)
	local timeT = DPSMate:GetMaxValue(sumTableTwo, 1)
	local minT = DPSMate:GetMinValue(sumTableTwo, 1)
	local smax, smin, stime = max, min, time
	
	if max<maxT then
		smax = maxT
	end
	if min>minT then
		smin = minT
	end
	if time<timeT then
		stime = timeT
	end
	g7:ResetData()
	g7:SetXAxis(0,stime-smin)
	g7:SetYAxis(0,smax+200)
	g7:SetGridSpacing((stime-smin)/20,smax/7)
	g7:SetGridColor({0.5,0.5,0.5,0.5})
	g7:SetAxisDrawing(true,true)
	g7:SetAxisColor({1.0,1.0,1.0,1.0})
	g7:SetAutoScale(true)
	g7:SetYLabels(true, false)
	g7:SetXLabels(true)
	
	local ata={{0,0}}
	for cat, val in DPSMate:ScaleDown(sumTable, min) do
		--tinsert(ata, {val[1],val[2], self:CheckProcs(DPSMate_Details_CompareEDD.proc, val[1]+min, DetailsUserComp)})
		tinsert(ata, {val[1],val[2], {}})
	end
	
	local Data2={{0,0}}
	for cat, val in DPSMate:ScaleDown(sumTableTwo, minT) do
		--tinsert(Data2, {val[1],val[2], self:CheckProcs(DPSMate_Details_EDD.proc, val[1]+minT)})
		tinsert(Data2, {val[1],val[2], {}})
	end

	--g7:AddDataSeries(ata,{{0.2,0.8,0.2,0.8}, {0.5,0.8,0.9,0.8}}, self:AddProcPoints(DPSMate_Details_CompareEDD.proc, ata, DetailsUserComp))
	--g7:AddDataSeries(Data2,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, self:AddProcPoints(DPSMate_Details_EDD.proc, Data2))
	g7:AddDataSeries(ata,{{0.2,0.8,0.2,0.8}, {0.5,0.8,0.9,0.8}}, {})
	g7:AddDataSeries(Data2,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, {})
	g7:Show()
end

function DPSMate.Modules.DetailsHealingTaken:ScrollFrame_Update(comp)
	if not comp then comp = DPSMate_Details_HealingTaken.LastScroll or "" end
	local line, lineplusoffset
	local path = "DPSMate_Details_"..comp.."HealingTaken_LogCreature"
	local obj = _G(path.."_ScrollFrame")
	local uArr, dArr, dTot, dSel = DetailsArr, DmgArr, DetailsTotal, DetailsSelected
	if comp ~= "" and comp~=nil then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
		dSel = DetailsSelectedComp
	end
	local len = DPSMate:TableLength(uArr)
	local coeff = len-10
	if not obj.oset or obj.oset<0 then
		obj.oset = 0
	end
	if coeff>0 then
		if (coeff-obj.oset)<0 then
			obj.oset = coeff
		end
		FauxScrollFrame_SetOffset(obj, obj.oset)
	end
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if uArr[lineplusoffset] ~= nil then
			local user = DPSMate:GetUserById(uArr[lineplusoffset])
			local r,g,b,img = DPSMate:GetClassColor(DPSMateUser[user][2])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(user)
			_G(path.."_ScrollButton"..line.."_Name"):SetTextColor(r,g,b)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(dArr[lineplusoffset][1].." ("..strformat("%.2f", (dArr[lineplusoffset][1]*100/dTot)).."%)")
			_G(path.."_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\class\\"..img)
			if len < 10 then
				_G(path.."_ScrollButton"..line):SetWidth(235)
				_G(path.."_ScrollButton"..line.."_Name"):SetWidth(125)
			else
				_G(path.."_ScrollButton"..line):SetWidth(220)
				_G(path.."_ScrollButton"..line.."_Name"):SetWidth(110)
			end
			_G(path.."_ScrollButton"..line):Show()
		else
			_G(path.."_ScrollButton"..line):Hide()
		end
		_G(path.."_ScrollButton"..line.."_selected"):Hide()
		if dSel == lineplusoffset then
			_G(path.."_ScrollButton"..line.."_selected"):Show()
		end
	end
end

function DPSMate.Modules.DetailsHealingTaken:SelectCreatureButton(i, comp)
	if not comp then comp = DPSMate_Details_HealingTaken.LastScroll or "" end
	local line, lineplusoffset
	local path = "DPSMate_Details_"..comp.."HealingTaken_Log"
	local obj = _G(path.."_ScrollFrame")
	local uArr, dArr, dTot, dSel = DetailsArr, DmgArr, DetailsTotal, DetailsSelected
	if comp ~= "" and comp~=nil then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
		DetailsSelectedComp = i+FauxScrollFrame_GetOffset(_G("DPSMate_Details_"..comp.."HealingTaken_LogCreature_ScrollFrame"))
		dSel = DetailsSelectedComp
	else
		DetailsSelected = i+FauxScrollFrame_GetOffset(_G("DPSMate_Details_"..comp.."HealingTaken_LogCreature_ScrollFrame"))
		dSel = DetailsSelected
	end
	local len = DPSMate:TableLength(dArr[i][2])
	local coeff = len-10
	if not obj.oset or obj.oset<0 then
		obj.oset = 0
	end
	if coeff>0 then
		if (coeff-obj.oset)<0 then
			obj.oset = coeff
		end
		FauxScrollFrame_SetOffset(obj, obj.oset)
	end
	FauxScrollFrame_Update(obj,len,10,24)
	obj.index = dSel
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if dArr[dSel][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(dArr[dSel][2][lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(dArr[dSel][3][lineplusoffset].." ("..strformat("%.2f", (dArr[dSel][3][lineplusoffset]*100/dArr[dSel][1])).."%)")
			_G(path.."_ScrollButton"..line.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(strsub(ability, 1, (strfind(ability, "%(") or 0)-1) or ability))
			if len < 10 then
				_G(path.."_ScrollButton"..line):SetWidth(235)
				_G(path.."_ScrollButton"..line.."_Name"):SetWidth(125)
			else
				_G(path.."_ScrollButton"..line):SetWidth(220)
				_G(path.."_ScrollButton"..line.."_Name"):SetWidth(110)
			end
			_G(path.."_ScrollButton"..line):Show()
		else
			_G(path.."_ScrollButton"..line):Hide()
		end
		_G(path.."_ScrollButton"..line.."_selected"):Hide()
		_G(path.."_ScrollButton1_selected"):Show()
	end
	for p=1, 10 do
		_G("DPSMate_Details_"..comp.."HealingTaken_LogCreature_ScrollButton"..p.."_selected"):Hide()
	end
	_G("DPSMate_Details_"..comp.."HealingTaken_LogCreature_ScrollButton"..i.."_selected"):Show()
	self:SelectDetailsButton(DetailsSelected,1, comp)
	if toggle3 then
		if toggle then
			if comp ~= "" and comp~=nil then
				self:UpdateStackedGraph(g3, "Compare", DetailsUserComp)
			else
				self:UpdateStackedGraph(g)
			end
		else
			if comp ~= "" and comp~=nil then
				self:UpdateLineGraph(g4, "Compare", DetailsUserComp)
			else
				self:UpdateLineGraph(g2, "")
			end
		end
		if DetailsUserComp then
			self:UpdateSumGraph()
		end
	end
end

function DPSMate.Modules.DetailsHealingTaken:SelectDetailsButton(p,i, comp, cname)
	if not comp then comp = DPSMate_Details_HealingTaken.LastScroll or "" end
	local obj = _G("DPSMate_Details_"..comp.."HealingTaken_Log_ScrollFrame")
	local lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
	local uArr, dArr, dSel = DetailsArr, DmgArr, DetailsSelected
	
	for p=1, 10 do
		_G("DPSMate_Details_"..comp.."HealingTaken_Log_ScrollButton"..p.."_selected"):Hide()
	end
	
	if comp ~= "" and comp~=nil then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dSel = DetailsSelectedComp
		if not cname then
			cname = DetailsUserComp
		end
	end
	
	-- Performance?
	local ability = tonumber(dArr[p][2][lineplusoffset])
	local creature = tonumber(uArr[p])
	_G("DPSMate_Details_"..comp.."HealingTaken_Log_ScrollButton"..i.."_selected"):Show()
	
	local path = db[DPSMateUser[cname or DetailsUser][1]][creature][ability]
	local hit, crit, hitav, critav, hitMin, hitMax, critMin, critMax = path[2], path[3], path[4], path[5], path[6], path[7], path[8], path[9]
	local total, max = hit+crit, DPSMate:TMax({hit, crit})
	
	-- Hit
	_G("DPSMate_Details_"..comp.."HealingTaken_LogDetails_Amount1_Amount"):SetText(hit)
	_G("DPSMate_Details_"..comp.."HealingTaken_LogDetails_Amount1_Percent"):SetText(strformat("%.1f", 100*hit/total).."%")
	_G("DPSMate_Details_"..comp.."HealingTaken_LogDetails_Amount1_StatusBar"):SetValue(ceil(100*hit/max))
	_G("DPSMate_Details_"..comp.."HealingTaken_LogDetails_Amount1_StatusBar"):SetStatusBarColor(1.0,0.7,0.3,1)
	_G("DPSMate_Details_"..comp.."HealingTaken_LogDetails_Average1"):SetText(ceil(hitav))
	_G("DPSMate_Details_"..comp.."HealingTaken_LogDetails_Min1"):SetText(hitMin)
	_G("DPSMate_Details_"..comp.."HealingTaken_LogDetails_Max1"):SetText(hitMax)
	
	-- Crit
	_G("DPSMate_Details_"..comp.."HealingTaken_LogDetails_Amount2_Amount"):SetText(crit)
	_G("DPSMate_Details_"..comp.."HealingTaken_LogDetails_Amount2_Percent"):SetText(strformat("%.1f", 100*crit/total).."%")
	_G("DPSMate_Details_"..comp.."HealingTaken_LogDetails_Amount2_StatusBar"):SetValue(ceil(100*crit/max))
	_G("DPSMate_Details_"..comp.."HealingTaken_LogDetails_Amount2_StatusBar"):SetStatusBarColor(0.9,0.0,0.0,1)
	_G("DPSMate_Details_"..comp.."HealingTaken_LogDetails_Average2"):SetText(ceil(critav))
	_G("DPSMate_Details_"..comp.."HealingTaken_LogDetails_Min2"):SetText(critMin)
	_G("DPSMate_Details_"..comp.."HealingTaken_LogDetails_Max2"):SetText(critMax)
end

function DPSMate.Modules.DetailsHealingTaken:UpdateLineGraph(gg, comp, cname)
	if g then
		g:Hide()
	end
	if g3 then
		g3:Hide()
	end
	local sumTable
	if toggle3 then
		if comp~="" and comp then
			sumTable = self:GetSummarizedTable(db, DetailsArrComp[DetailsSelectedComp], DetailsUserComp)
		else
			sumTable = self:GetSummarizedTable(db, DetailsArr[DetailsSelected])
		end
	else
		sumTable = self:GetSummarizedTable(db, nil, cname)
	end
	local max = DPSMate:GetMaxValue(sumTable, 2)
	local time = DPSMate:GetMaxValue(sumTable, 1)
	local min = DPSMate:GetMinValue(sumTable, 1)
	
	gg:ResetData()
	gg:SetXAxis(0,time-min)
	gg:SetYAxis(0,max+200)
	gg:SetGridSpacing((time-min)/10,max/7)
	gg:SetGridColor({0.5,0.5,0.5,0.5})
	gg:SetAxisDrawing(true,true)
	gg:SetAxisColor({1.0,1.0,1.0,1.0})
	gg:SetAutoScale(true)
	gg:SetYLabels(true, false)
	gg:SetXLabels(true)

	local Data1={{0,0}}
	for cat, val in DPSMate:ScaleDown(sumTable, min) do
		tinsert(Data1, {val[1],val[2], {}})
	end
	local colorT = {{1.0,0.0,0.0,0.8}, {1.0,0.0,0.0,0.8}}
	

	gg:AddDataSeries(Data1,colorT, {})
	gg:Show()
end

function DPSMate.Modules.DetailsHealingTaken:UpdateStackedGraph(gg, comp, cname)
	if g2 then
		g2:Hide()
	end
	if g4 then
		g4:Hide()
	end
	
	local Data1 = {}
	local label = {}
	local b = {}
	local p = {}
	local maxY = 0
	local maxX = 0
	local temp = {}
	local temp2 = {}
	
	local dSel, uArr = DetailsSelected, DetailsArr
	if comp~="" and comp then
		uArr = DetailsArrComp
		dSel = DetailsSelectedComp
	end
	
	if toggle3 then
		for cat, val in db[DPSMateUser[cname or DetailsUser][1]][uArr[dSel]] do
			if val["i"] then
				for c, v in val["i"] do
					local key = tonumber(strformat("%.1f", c))
					if not temp[cat] then
						temp[cat] = {}
						temp2[cat] = 0
					end
					if p[key] then
						p[key] = p[key] + v
					else
						p[key] = v
					end
					local i = 1
					while true do
						if not temp[cat][i] then
							tinsert(temp[cat], i, {c,v})
							break
						elseif c<=temp[cat][i][1] then
							tinsert(temp[cat], i, {c,v})
							break
						end
						i = i + 1
					end
					temp2[cat] = temp2[cat] + val[1]
					maxY = math.max(p[key], maxY)
					maxX = math.max(c, maxX)
				end
			end
		end	
	else
		for cat, val in db[DPSMateUser[cname or DetailsUser][1]] do
			if cat~="i" then
				for ca, va in val do
					if va["i"] then
						for c, v in va["i"] do
							local key = tonumber(strformat("%.1f", c))
							if not temp[ca] then
								temp[ca] = {}
								temp2[ca] = 0
							end
							if p[key] then
								p[key] = p[key] + v
							else
								p[key] = v
							end
							local i = 1
							while true do
								if not temp[ca][i] then
									tinsert(temp[ca], i, {c,v})
									break
								elseif c<=temp[ca][i][1] then
									tinsert(temp[ca], i, {c,v})
									break
								end
								i = i + 1
							end
							temp2[ca] = temp2[ca] + va[1]
							maxY = math.max(p[key], maxY)
							maxX = math.max(c, maxX)
						end
					end
				end
			end
		end
	end
	local min
	for cat, val in temp do
		local pmin = DPSMate:GetMinValue(val, 1)
		if not min or pmin<min then
			min = pmin
		end
	end
	for cat, val in temp do
		local i = 1
		while true do
			if not b[i] then
				tinsert(b, i, temp2[cat])
				tinsert(label, i, DPSMate:GetAbilityById(cat))
				tinsert(Data1, i, val)
				break
			elseif b[i]>=temp2[cat] then
				tinsert(b, i, temp2[cat])
				tinsert(label, i, DPSMate:GetAbilityById(cat))
				tinsert(Data1, i, val)
				break
			end
			i = i + 1
		end
	end
	
	for cat, val in Data1 do
		Data1[cat] = DPSMate:ScaleDown(val, min)
	end
	
	gg:ResetData()
	gg:SetGridSpacing((maxX-min)/7,maxY/7)
	
	gg:AddDataSeries(Data1,{1.0,0.0,0.0,0.8}, {}, label)
	gg:Show()
end

function DPSMate.Modules.DetailsHealingTaken:CreateGraphTable(comp)
	local lines = {}
	comp = comp or ""
	for i=1, 8 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details_"..comp.."HealingTaken_Log"), 252, 270-i*30, 617, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[9] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details_"..comp.."HealingTaken_Log"), 302, 260, 302, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details_"..comp.."HealingTaken_Log"), 437, 260, 437, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details_"..comp.."HealingTaken_Log"), 497, 260, 497, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
	
	lines[12] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details_"..comp.."HealingTaken_Log"), 557, 260, 557, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
end

function DPSMate.Modules.DetailsHealingTaken:SortLineTable(t,b, cname)
	local newArr = {}
	if b then
		for cat, val in t[DPSMateUser[cname or DetailsUser][1]][b] do
			if val["i"] then
				for ca, va in val["i"] do
					local i=1
					while true do
						if (not newArr[i]) then 
							tinsert(newArr, i, {ca, va})
							break
						end
						if ca<=newArr[i][1] then
							tinsert(newArr, i, {ca, va})
							break
						end
						i=i+1
					end
				end
			end
		end
	else
		for cat, val in t[DPSMateUser[cname or DetailsUser][1]] do
			if cat~="i" then
				for c,v in val do
					if v["i"] then
						for ca, va in v["i"] do
							local i=1
							while true do
								if (not newArr[i]) then 
									tinsert(newArr, i, {ca, va})
									break
								end
								if ca<=newArr[i][1] then
									tinsert(newArr, i, {ca, va})
									break
								end
								i=i+1
							end
						end
					end
				end
			end
		end
	end
	return newArr
end

function DPSMate.Modules.DetailsHealingTaken:GetSummarizedTable(arr,b, cname)
	return DPSMate.Sync:GetSummarizedTable(self:SortLineTable(arr,b,cname))
end

function DPSMate.Modules.DetailsHealingTaken:ToggleMode() 
	if toggle then
		self:UpdateLineGraph(g2, "")
		if DetailsUserComp then
			self:UpdateLineGraph(g4, "Compare", DetailsUserComp)
		end
		toggle = false
	else
		self:UpdateStackedGraph(g)
		if DetailsUserComp then
			self:UpdateStackedGraph(g3, "Compare", DetailsUserComp)
		end
		toggle = true
	end
end

function DPSMate.Modules.DetailsHealingTaken:ToggleIndividual()
	if toggle3 then
		toggle3 = false
	else
		toggle3 = true
	end
	if toggle then
		self:UpdateStackedGraph(g)
		if DetailsUserComp then
			self:UpdateStackedGraph(g3, "Compare", DetailsUserComp)
		end
	else
		self:UpdateLineGraph(g2, "")
		if DetailsUserComp then
			self:UpdateLineGraph(g4, "Compare", DetailsUserComp)
		end
	end
	if DetailsUserComp then
		self:UpdateSumGraph()
	end
end
