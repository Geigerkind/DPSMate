-- Global Variables
DPSMate.Modules.DetailsThreat = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailsUser, DetailsSelected  = {}, 0, {}, "", 1
local DetailsArrComp, DetailsTotalComp, DmgArrComp, DetailsUserComp, DetailsSelectedComp  = {}, 0, {}, "", 1
local g, g2,g3,g4,g7
local curKey = 1
local db, cbt = {}, 0
local tinsert = table.insert
local _G = getglobal
local strformat = string.format
local toggle, toggle3 = false, false
local mode = {[1]="total",[2]="current"}

function DPSMate.Modules.DetailsThreat:UpdateDetails(obj, key)
	DPSMate_Details_CompareThreat:Hide()
	DPSMate_Details_CompareThreat_Graph:Hide()

	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DetailsUserComp = nil
	DPSMate_Details_Threat_Title:SetText(DPSMate.L["threatdoneby"]..obj.user)
	DPSMate_Details_Threat_SubTitle:SetText(DPSMate.L["activity"]..strformat("%.2f", (DPSMateCombatTime["effective"][key][obj.user] or 0)+1).."s "..DPSMate.L["of"].." "..strformat("%.2f", DPSMateCombatTime[mode[key]]).."s ("..strformat("%.2f", 100*((DPSMateCombatTime["effective"][key][obj.user] or 0)+1)/DPSMateCombatTime[mode[key]]).."%)")
	DPSMate_Details_Threat:Show()
	DetailsArr, DetailsTotal, DmgArr = DPSMate.Modules.Threat:EvalTable(DPSMateUser[DetailsUser], curKey)
	DPSMate_Details_Threat.proc = "None"
	UIDropDownMenu_SetSelectedValue(DPSMate_Details_Threat_DiagramLegend_Procs, "None")
	UIDropDownMenu_Initialize(DPSMate_Details_Threat_DiagramLegend_Procs, self.ProcsDropDown)
	self:ScrollFrame_Update("")
	self:SelectCreatureButton(1,"")
	self:SelectDetailsButton(1,1,"")
	
	if not g then
		g=DPSMate.Options.graph:CreateStackedGraph("THStackedGraph",DPSMate_Details_Threat_DiagramLine,"CENTER","CENTER",0,0,850,230)
		g:SetGridColor({0.5,0.5,0.5,0.5})
		g:SetAxisDrawing(true,true)
		g:SetAxisColor({1.0,1.0,1.0,1.0})
		g:SetAutoScale(true)
		g:SetYLabels(true, false)
		g:SetXLabels(true)
		g2=DPSMate.Options.graph:CreateGraphLine("THLineGraph",DPSMate_Details_Threat_DiagramLine,"CENTER","CENTER",0,0,850,230)
	end
	
	if toggle then
		self:UpdateStackedGraph(g)
	else
		self:UpdateLineGraph(g2, "")
	end
	DPSMate_Details_Threat:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsThreat:UpdateCompare(obj, key, comp)
	self:UpdateDetails(obj, key)
	
	DPSMate_Details_CompareThreat.proc = "None"
	UIDropDownMenu_SetSelectedValue(DPSMate_Details_CompareThreat_DiagramLegend_Procs, "None")
	DetailsUserComp = comp
	DPSMate_Details_CompareThreat_Title:SetText(DPSMate.L["threatdoneby"]..comp)
	UIDropDownMenu_Initialize(DPSMate_Details_CompareThreat_DiagramLegend_Procs, DPSMate.Modules.DetailsThreat.ProcsDropDown_Compare)
	DetailsArrComp, DetailsTotalComp, DmgArrComp = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[comp], curKey)
	
	if not g3 then
		g3=DPSMate.Options.graph:CreateStackedGraph("THStackedGraphComp",DPSMate_Details_CompareThreat_DiagramLine,"CENTER","CENTER",0,0,850,230)
		g3:SetGridColor({0.5,0.5,0.5,0.5})
		g3:SetAxisDrawing(true,true)
		g3:SetAxisColor({1.0,1.0,1.0,1.0})
		g3:SetAutoScale(true)
		g3:SetYLabels(true, false)
		g3:SetXLabels(true)
		g4=DPSMate.Options.graph:CreateGraphLine("THLineGraphComp",DPSMate_Details_CompareThreat_DiagramLine,"CENTER","CENTER",0,0,850,230)
		g7=DPSMate.Options.graph:CreateGraphLine("THLineGraphSumComp",DPSMate_Details_CompareThreat_Graph,"CENTER","CENTER",0,0,1750,230)
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
	
	DPSMate_Details_CompareThreat:Show()
	DPSMate_Details_CompareThreat_Graph:Show()
end

function DPSMate.Modules.DetailsThreat:UpdateSumGraph()
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
		tinsert(ata, {val[1],val[2], self:CheckProcs(DPSMate_Details_CompareThreat.proc, val[1]+min+1, DetailsUserComp)})
	end
	
	local Data2={{0,0}}
	for cat, val in DPSMate:ScaleDown(sumTableTwo, minT) do
		tinsert(Data2, {val[1],val[2], self:CheckProcs(DPSMate_Details_Threat.proc, val[1]+minT+1)})
	end

	g7:AddDataSeries(ata,{{0.2,0.8,0.2,0.8}, {0.5,0.8,0.9,0.8}}, self:AddProcPoints(DPSMate_Details_CompareThreat.proc, ata, DetailsUserComp))
	g7:AddDataSeries(Data2,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, self:AddProcPoints(DPSMate_Details_Threat.proc, Data2))
	g7:Show()
end

function DPSMate.Modules.DetailsThreat:ScrollFrame_Update(comp, cname)
	if not comp then comp = DPSMate_Details_Threat.LastScroll or "" end
	local line, lineplusoffset
	local path = "DPSMate_Details_"..comp.."Threat_LogCreature"
	local obj = _G(path.."_ScrollFrame")
	local uArr, dArr, dTot, dSel = DetailsArr, DmgArr, DetailsTotal, DetailsSelected
	if comp ~= "" and comp~=nil then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
		dSel = DetailsSelectedComp
	end
	local pet, len = "", DPSMate:TableLength(uArr)
	local coeff = len-8
	if not obj.oset or obj.oset<0 then
		obj.oset = 0
	end
	if coeff>0 then
		if (coeff-obj.oset)<0 then
			obj.oset = coeff
		end
		FauxScrollFrame_SetOffset(obj, obj.oset)
	end
	FauxScrollFrame_Update(obj,len,8,24)
	for line=1,8 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if uArr[lineplusoffset] ~= nil then
			local user = DPSMate:GetUserById(uArr[lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(user)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(strformat("%.2f", dArr[lineplusoffset][1]).." ("..strformat("%.2f", (dArr[lineplusoffset][1]*100/dTot)).."%)")
			_G(path.."_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\npc")
			if len < 8 then
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

function DPSMate.Modules.DetailsThreat:SelectCreatureButton(i, comp, cname)
	if not comp then comp = DPSMate_Details_Threat.LastScroll or "" end
	local line, lineplusoffset
	local path = "DPSMate_Details_"..comp.."Threat_Log"
	local obj = _G(path.."_ScrollFrame")
	i = i + FauxScrollFrame_GetOffset(_G("DPSMate_Details_"..comp.."Threat_LogCreature_ScrollFrame")) or obj.index
	obj.index = i
	local uArr, dArr, dTot, dSel = DetailsArr, DmgArr, DetailsTotal, DetailsSelected
	if comp ~= "" and comp~=nil then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
		DetailsSelectedComp = i
		dSel = DetailsSelectedComp
	else
		DetailsSelected = i
		dSel = DetailsSelected
	end
	local pet, len = "", DPSMate:TableLength(dArr[i][2])
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
		if dArr[i][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(dArr[i][2][lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(strformat("%.2f", dArr[i][3][lineplusoffset]).." ("..strformat("%.2f", (dArr[i][3][lineplusoffset]*100/dTot)).."%)")
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
	for p=1, 8 do
		_G("DPSMate_Details_"..comp.."Threat_LogCreature_ScrollButton"..p.."_selected"):Hide()
	end
	_G("DPSMate_Details_"..comp.."Threat_LogCreature_ScrollButton"..(i-FauxScrollFrame_GetOffset(_G("DPSMate_Details_"..comp.."Threat_LogCreature_ScrollFrame"))).."_selected"):Show()
	self:SelectDetailsButton(i,1, comp, cname)
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

function DPSMate.Modules.DetailsThreat:SelectDetailsButton(p,i,comp,cname)
	if not comp then comp = DPSMate_Details_Threat.LastScroll or "" end
	local obj = _G("DPSMate_Details_"..comp.."Threat_Log_ScrollFrame")
	local lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
	local uArr, dArr, dSel = DetailsArr, DmgArr, DetailsSelected
	
	for p=1, 10 do
		_G("DPSMate_Details_"..comp.."Threat_Log_ScrollButton"..p.."_selected"):Hide()
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
	_G("DPSMate_Details_"..comp.."Threat_Log_ScrollButton"..i.."_selected"):Show()
	
	local path = db[DPSMateUser[cname or DetailsUser][1]][creature][ability]
	local hit, min, max,amount = path[4],path[2],path[3],path[1]
	
	_G("DPSMate_Details_"..comp.."Threat_LogDetails_Casts"):SetText("C: "..hit)
	-- Crush
	_G("DPSMate_Details_"..comp.."Threat_LogDetails_Amount1_Amount"):SetText(hit)
	_G("DPSMate_Details_"..comp.."Threat_LogDetails_Amount1_Percent"):SetText("100%")
	_G("DPSMate_Details_"..comp.."Threat_LogDetails_Amount1_StatusBar"):SetValue(100)
	_G("DPSMate_Details_"..comp.."Threat_LogDetails_Amount1_StatusBar"):SetStatusBarColor(1.0,0.7,0.3,1)
	_G("DPSMate_Details_"..comp.."Threat_LogDetails_Average1"):SetText(ceil(amount/hit))
	_G("DPSMate_Details_"..comp.."Threat_LogDetails_Min1"):SetText(ceil(min))
	_G("DPSMate_Details_"..comp.."Threat_LogDetails_Max1"):SetText(ceil(max))
end

function DPSMate.Modules.DetailsThreat:UpdateLineGraph(gg, comp, cname)
	if g then
		g:Hide()
	end
	if g3 then
		g3:Hide()
	end
	local sumTable
	if toggle3 then
		if comp ~= "" and comp then
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
		tinsert(Data1, {val[1],val[2], self:CheckProcs(_G("DPSMate_Details_"..comp.."Threat").proc, val[1]+min+1, cname)})
	end
	
	local colorT = {{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}
	if cname then
		colorT = {{0.2,0.8,0.2,0.8}, {0.5,0.8,0.9,0.8}}
	end
	
	gg:AddDataSeries(Data1,colorT, self:AddProcPoints(_G("DPSMate_Details_"..comp.."Threat").proc, Data1, cname))
	gg:Show()
	toggle = false
end

function DPSMate.Modules.DetailsThreat:UpdateStackedGraph(gg, comp, cname)
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
	local dSel, uArr, dArr = DetailsSelected, DetailsArr, DmgArr
	if comp ~= "" and comp then
		uArr = DetailsArrComp
		dArr = DmgArrComp
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
		
		gg:ResetData()
		gg:SetGridSpacing(maxX/7,maxY/7)
	end
	
	gg:AddDataSeries(Data1,{1.0,0.0,0.0,0.8}, {}, label)
	gg:Show()
	toggle = true
end

function DPSMate.Modules.DetailsThreat:CreateGraphTable(comp)
	local lines = {}
	comp = comp or ""
	for i=1, 8 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details_"..comp.."Threat_Log"), 252, 270-i*30, 617, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[9] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details_"..comp.."Threat_Log"), 302, 260, 302, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details_"..comp.."Threat_Log"), 437, 260, 437, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details_"..comp.."Threat_Log"), 497, 260, 497, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
	
	lines[12] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details_"..comp.."Threat_Log"), 557, 260, 557, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
end

function DPSMate.Modules.DetailsThreat:SortLineTable(arr, b, cname)
	local newArr = {}
	if b then
		for cat, val in arr[DPSMateUser[cname or DetailsUser][1]][b] do
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
		for cat, val in arr[DPSMateUser[cname or DetailsUser][1]] do
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

function DPSMate.Modules.DetailsThreat:GetSummarizedTable(arr, b, cname)
	return DPSMate.Sync:GetSummarizedTable(self:SortLineTable(arr, b, cname))
end

function DPSMate.Modules.DetailsThreat:ProcsDropDown()
	local arr = DPSMate.Modules.DetailsThreat:GetAuraGainedArr(curKey)
	DPSMate_Details_Threat.proc = "None"
	
    local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_Details_Threat_DiagramLegend_Procs, this.value)
		DPSMate_Details_Threat.proc = this.value
		if not toggle then
			DPSMate.Modules.DetailsThreat:UpdateLineGraph(g2, "")
		end
		if DetailsUserComp then
			self:UpdateSumGraph()
		end
    end
	
	UIDropDownMenu_AddButton{
		text = "None",
		value = "None",
		func = on_click,
	}
	
	-- Adding dynamic channel
	if arr[DPSMateUser[DetailsUser][1]] then
		for cat, val in pairs(arr[DPSMateUser[DetailsUser][1]]) do
			local ability = DPSMate:GetAbilityById(cat)
			if DPSMate.Parser.procs[ability] or DPSMate.Parser.DmgProcs[ability] then
				UIDropDownMenu_AddButton{
					text = ability,
					value = cat,
					func = on_click,
				}
			end
		end
	end
	
	if DPSMate_Details_Threat.LastUser~=DetailsUser then
		UIDropDownMenu_SetSelectedValue(DPSMate_Details_Threat_DiagramLegend_Procs, "None")
	end
	DPSMate_Details_Threat.LastUser = DetailsUser
end

function DPSMate.Modules.DetailsThreat:ProcsDropDown_Compare()
	local arr = DPSMate.Modules.DetailsThreat:GetAuraGainedArr(curKey)
	DPSMate_Details_CompareThreat.proc = "None"
	
    local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_Details_CompareThreat_DiagramLegend_Procs, this.value)
		DPSMate_Details_CompareThreat.proc = this.value
		if not toggle then
			DPSMate.Modules.DetailsThreat:UpdateLineGraph(g4, "Compare", DetailsUserComp)
		end
		self:UpdateSumGraph()
    end
	
	UIDropDownMenu_AddButton{
		text = "None",
		value = "None",
		func = on_click,
	}
	
	-- Adding dynamic channel
	if arr[DPSMateUser[DetailsUserComp][1]] then
		for cat, val in pairs(arr[DPSMateUser[DetailsUserComp][1]]) do
			local ability = DPSMate:GetAbilityById(cat)
			if DPSMate.Parser.procs[ability] or DPSMate.Parser.DmgProcs[ability] then
				UIDropDownMenu_AddButton{
					text = ability,
					value = cat,
					func = on_click,
				}
			end
		end
	end
	
	if DPSMate_Details_CompareThreat.LastUser~=DetailsUserComp then
		UIDropDownMenu_SetSelectedValue(DPSMate_Details_CompareThreat_DiagramLegend_Procs, "None")
	end
	DPSMate_Details_CompareThreat.LastUser = DetailsUser
end

function DPSMate.Modules.DetailsThreat:GetAuraGainedArr(k)
	local modes = {["total"]=1,["currentfight"]=2}
	for cat, val in pairs(DPSMateSettings["windows"][k]["options"][2]) do
		if val then
			if strfind(cat, "segment") then
				local num = tonumber(strsub(cat, 8))
				return DPSMateHistory["Auras"][num]
			else
				return DPSMateAurasGained[modes[cat]]
			end
		end
	end
end

function DPSMate.Modules.DetailsThreat:CheckProcs(name, val, cname)
	local arr = DPSMate.Modules.DetailsThreat:GetAuraGainedArr(curKey)
	if arr[DPSMateUser[cname or DetailsUser][1]] then
		if arr[DPSMateUser[cname or DetailsUser][1]][name] then
			for i=1, DPSMate:TableLength(arr[DPSMateUser[cname or DetailsUser][1]][name][1]) do
				if not arr[DPSMateUser[cname or DetailsUser][1]][name][1][i] or not arr[DPSMateUser[cname or DetailsUser][1]][name][2][i] or arr[DPSMateUser[cname or DetailsUser][1]][name][4] then return false end
				if val > arr[DPSMateUser[cname or DetailsUser][1]][name][1][i] and val < arr[DPSMateUser[cname or DetailsUser][1]][name][2][i] then
					return true
				end
			end
		end
	end
	return false
end

function DPSMate.Modules.DetailsThreat:AddProcPoints(name, dat, cname)
	local bool, data, LastVal = false, {}, 0
	local arr = DPSMate.Modules.DetailsThreat:GetAuraGainedArr(curKey)
	if arr[DPSMateUser[cname or DetailsUser][1]] then
		if arr[DPSMateUser[cname or DetailsUser][1]][name] then
			if arr[DPSMateUser[cname or DetailsUser][1]][name][4] then
				for cat, val in pairs(dat) do
					for i=1, DPSMate:TableLength(arr[DPSMateUser[cname or DetailsUser][1]][name][1]) do
						if arr[DPSMateUser[cname or DetailsUser][1]][name][1][i]<=val[1] then
							local tempbool = true
							for _, va in pairs(data) do
								if va[1] == arr[DPSMateUser[cname or DetailsUser][1]][name][1][i] then
									tempbool = false
									break
								end
							end
							if tempbool then	
								bool = true
								tinsert(data, {arr[DPSMateUser[cname or DetailsUser][1]][name][1][i], LastVal, {val[1], val[2]}})
							end
						end
					end
					LastVal = {val[1], val[2]}
				end
			end
		end
	end
	return {bool, data}
end

function DPSMate.Modules.DetailsThreat:ToggleMode()
	if toggle then
		self:UpdateLineGraph(g2, "")
		if DetailsUserComp then
			self:UpdateLineGraph(g4, "Compare", DetailsUserComp)
		end
		toggle=false
	else
		self:UpdateStackedGraph(g)
		if DetailsUserComp then
			self:UpdateStackedGraph(g3, "Compare", DetailsUserComp)
		end
		toggle=true
	end
end

function DPSMate.Modules.DetailsThreat:ToggleIndividual()
	if toggle3 then
		toggle3 = false
	else
		toggle3 = true
	end
	if not toggle then
		self:UpdateLineGraph(g2, "")
		if DetailsUserComp then
			self:UpdateLineGraph(g4, "Compare", DetailsUserComp)
		end
	else
		self:UpdateStackedGraph(g)
		if DetailsUserComp then
			self:UpdateStackedGraph(g3, "Compare", DetailsUserComp)
		end
	end
	if DetailsUserComp then
		self:UpdateSumGraph()
	end
end
