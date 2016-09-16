-- Global Variables
DPSMate.Modules.DetailsAbsorbsTaken = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailsUser, DetailsSelected, DetailsSelectedTwo, DetailsSelectedThree  = {}, 0, {}, "", 1, 1, 1
local DetailsArrComp, DetailsTotalComp, DmgArrComp, DetailsUserComp, DetailsSelectedComp, DetailsSelectedTwoComp, DetailsSelectedThreeComp  = {}, 0, {}, "", 1, 1, 1
local PieChart = true
local g3, g2, g4, g5, g7
local curKey = 1
local db, cbt = {}, 0
local _G = getglobal
local tinsert = table.insert
local strformat = string.format
local toggle2, toggle3 = false, false

function DPSMate.Modules.DetailsAbsorbsTaken:UpdateDetails(obj, key)
	DPSMate_Details_CompareAbsorbsTaken:Hide()
	DPSMate_Details_CompareAbsorbsTaken_Graph:Hide()
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	if (PieChart) then
		g2=DPSMate.Options.graph:CreateGraphLine("AbsorbTakenLineGraph",DPSMate_Details_AbsorbsTaken_DiagramLine,"CENTER","CENTER",0,0,960,230)
		g3=DPSMate.Options.graph:CreateStackedGraph("AbsorbTakenStackedGraph",DPSMate_Details_AbsorbsTaken_DiagramLine,"CENTER","CENTER",0,0,960,230)
		g3:SetGridColor({0.5,0.5,0.5,0.5})
		g3:SetAxisDrawing(true,true)
		g3:SetAxisColor({1.0,1.0,1.0,1.0})
		g3:SetAutoScale(true)
		g3:SetYLabels(true, false)
		g3:SetXLabels(true)
		PieChart = false
	end
	DetailsSelected, DetailsSelectedTwo, DetailsSelectedThree = 1, 1, 1
	DetailsUser = obj.user
	DetailsUserComp = nil
	DPSMate_Details_AbsorbsTaken_Title:SetText(DPSMate.L["absorbstakenby"]..obj.user)
	DetailsArr, DetailsTotal, DmgArr = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[DetailsUser], curKey)
	DPSMate_Details_AbsorbsTaken:Show()
	self:ScrollFrame_Update("")
	self:SelectCreatureButton(1,"")
	self:SelectCauseButton(1,1,"")
	self:SelectCauseABButton(1,1,1,"")
	if toggle2 then
		self:UpdateStackedGraph(g3,"")
	else
		self:UpdateLineGraph(g2,"")
	end
	DPSMate_Details_AbsorbsTaken:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsAbsorbsTaken:UpdateCompare(obj, key, comp)
	self:UpdateDetails(obj, key)

	if not g4 then
		g4=DPSMate.Options.graph:CreateGraphLine("AbsorbTakenLineGraphComp",DPSMate_Details_CompareAbsorbsTaken_DiagramLine,"CENTER","CENTER",0,0,960,230)
		g5=DPSMate.Options.graph:CreateStackedGraph("AbsorbTakenStackedGraphComp",DPSMate_Details_CompareAbsorbsTaken_DiagramLine,"CENTER","CENTER",0,0,960,230)
		g5:SetGridColor({0.5,0.5,0.5,0.5})
		g5:SetAxisDrawing(true,true)
		g5:SetAxisColor({1.0,1.0,1.0,1.0})
		g5:SetAutoScale(true)
		g5:SetYLabels(true, false)
		g5:SetXLabels(true)
		g7=DPSMate.Options.graph:CreateGraphLine("AbsorbsTakenLineGraphSumComp",DPSMate_Details_CompareAbsorbsTaken_Graph,"CENTER","CENTER",0,0,1970,230)
	end
	DetailsSelectedComp, DetailsSelectedTwoComp, DetailsSelectedThreeComp = 1, 1, 1
	DetailsUserComp = comp
	DPSMate_Details_CompareAbsorbsTaken_Title:SetText(DPSMate.L["absorbstakenby"]..comp)
	DetailsArrComp, DetailsTotalComp, DmgArrComp = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[comp], curKey)
	DPSMate_Details_CompareAbsorbsTaken:Show()
	DPSMate_Details_CompareAbsorbsTaken_Graph:Show()
	self:ScrollFrame_Update("Compare")
	self:SelectCreatureButton(1, "Compare")
	self:SelectCauseButton(1,1, "Compare")
	self:SelectCauseABButton(1,1,1, "Compare")
	if toggle2 then
		self:UpdateStackedGraph(g5,"Compare")
	else
		self:UpdateLineGraph(g4,"Compare")
	end
	self:UpdateSumGraph()
end

function DPSMate.Modules.DetailsAbsorbsTaken:UpdateSumGraph()
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
	g7:AddDataSeries(ata,{{0.5,0.8,0.9,0.8}, {0.2,0.8,0.2,0.8}}, {})
	g7:AddDataSeries(Data2,{{1.0,1.0,0.0,0.8}, {1.0,0.0,0.0,0.8}}, {})
	g7:Show()
end

function DPSMate.Modules.DetailsAbsorbsTaken:ScrollFrame_Update(comp)
	comp = comp or DPSMate_Details_AbsorbsTaken.LastScroll
	local line, lineplusoffset
	local path = "DPSMate_Details_"..comp.."AbsorbsTaken_LogCreature"
	local obj = _G(path.."_ScrollFrame")
	local uArr, dArr, dTot, dSel = DetailsArr, DmgArr, DetailsTotal, DetailsSelected
	if comp~="" and comp then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
		dSel = DetailsSelectedComp
	end
	local len = DPSMate:TableLength(uArr)
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

function DPSMate.Modules.DetailsAbsorbsTaken:SelectCreatureButton(i, comp)
	comp = comp or DPSMate_Details_AbsorbsTaken.LastScroll
	local line, lineplusoffset
	local path = "DPSMate_Details_"..comp.."AbsorbsTaken_Log"
	local obj = _G(path.."_ScrollFrame")
	if i then
		obj.index = i + FauxScrollFrame_GetOffset(_G("DPSMate_Details_"..comp.."AbsorbsTaken_LogCreature_ScrollFrame"))
	end
	local uArr, dArr, dTot, dSel = DetailsArr, DmgArr, DetailsTotal, DetailsSelectedTwo
	if comp~="" and comp then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
		dSel = DetailsSelectedTwoComp
		DetailsSelectedComp = obj.index
	else
		DetailsSelected = obj.index
	end
	local len = DPSMate:TableLength(dArr[obj.index][2])
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if dArr[obj.index][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(dArr[obj.index][2][lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(dArr[obj.index][3][lineplusoffset][1].." ("..strformat("%.2f", (dArr[obj.index][3][lineplusoffset][1]*100/dTot)).."%)")
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
		if dSel == lineplusoffset then
			_G(path.."_ScrollButton"..line.."_selected"):Show()
		end
	end
	DPSMate.Modules.DetailsAbsorbsTaken:SelectCauseButton(obj.index,1, comp)
	for p=1, 10 do
		_G("DPSMate_Details_"..comp.."AbsorbsTaken_LogCreature_ScrollButton"..p.."_selected"):Hide()
	end
	_G("DPSMate_Details_"..comp.."AbsorbsTaken_LogCreature_ScrollButton"..(obj.index-FauxScrollFrame_GetOffset(_G("DPSMate_Details_"..comp.."AbsorbsTaken_LogCreature_ScrollFrame"))).."_selected"):Show()
	if toggle3 then
		if toggle2 then
			if comp ~= "" and comp~=nil then
				DPSMate.Modules.DetailsAbsorbsTaken:UpdateStackedGraph(g5, "Compare")
			else
				DPSMate.Modules.DetailsAbsorbsTaken:UpdateStackedGraph(g3, "")
			end
		else
			if comp ~= "" and comp~=nil then
				DPSMate.Modules.DetailsAbsorbsTaken:UpdateLineGraph(g4, "Compare")
			else
				DPSMate.Modules.DetailsAbsorbsTaken:UpdateLineGraph(g2, comp)
			end
		end
		if DPSMateUserComp then
			DPSMate.Modules.DetailsAbsorbsTaken:UpdateSumGraph()
		end
	end
end

function DPSMate.Modules.DetailsAbsorbsTaken:SelectCauseButton(i,p, comp)
	comp = comp or DPSMate_Details_AbsorbsTaken.LastScroll
	local line, lineplusoffset
	local path = "DPSMate_Details_"..comp.."AbsorbsTaken_LogTwo"
	local obj = _G(path.."_ScrollFrame")
	local obj2 = _G("DPSMate_Details_"..comp.."AbsorbsTaken_Log_ScrollFrame")
	if p then
		obj.index = p
	end
	i = obj2.index or i
	p = obj.index or p
	local uArr, dArr, dTot, dSel = DetailsArr, DmgArr, DetailsTotal, DetailsSelectedThree
	if comp~="" and comp then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
		dSel = DetailsSelectedThreeComp
		DetailsSelectedTwoComp = obj.index
	else
		DetailsSelectedTwo = obj.index
	end
	local len = DPSMate:TableLength(dArr[i][3][p][2])
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if dArr[i][3][p][2][lineplusoffset] ~= nil then
			local user = DPSMate:GetUserById(dArr[i][3][p][2][lineplusoffset])
			local r,g,b,img = DPSMate:GetClassColor(DPSMateUser[user][2])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(user)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(dArr[i][3][p][3][lineplusoffset][1].." ("..strformat("%.2f", (dArr[i][3][p][3][lineplusoffset][1]*100/dArr[i][3][p][1])).."%)")
			if DPSMateUser[user][2] then
				_G(path.."_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\class\\"..img)
			else
				_G(path.."_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\npc")
			end
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
	DPSMate.Modules.DetailsAbsorbsTaken:SelectCauseABButton(i,p,1, comp)
	for qq=1, 10 do
		_G("DPSMate_Details_"..comp.."AbsorbsTaken_Log_ScrollButton"..qq.."_selected"):Hide()
	end
	if (p-FauxScrollFrame_GetOffset(obj2))>0 then
		_G("DPSMate_Details_"..comp.."AbsorbsTaken_Log_ScrollButton"..(p-FauxScrollFrame_GetOffset(obj2)).."_selected"):Show()
	end
end

function DPSMate.Modules.DetailsAbsorbsTaken:SelectCauseABButton(i,p,q,comp)
	comp = comp or DPSMate_Details_Absorbs.LastScroll
	local line, lineplusoffset
	local path = "DPSMate_Details_"..comp.."AbsorbsTaken_LogThree"
	local obj = _G(path.."_ScrollFrame")
	local obj2 = _G("DPSMate_Details_"..comp.."AbsorbsTaken_Log_ScrollFrame")
	local obj3 = _G("DPSMate_Details_"..comp.."AbsorbsTaken_LogTwo_ScrollFrame")
	local obj4 = _G("DPSMate_Details_"..comp.."AbsorbsTaken_LogCreature_ScrollFrame")
	if q then
		obj.index = q
	end
	q = obj.index or q
	p = obj3.index or p
	i = obj2.index or i
	local uArr, dArr, dTot = DetailsArr, DmgArr, DetailsTotal
	if comp~="" and comp then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
		DetailsSelectedThreeComp = obj.index
	else
		DetailsSelectedThree = obj.index
	end
	local len = DPSMate:TableLength(dArr[i][3][p][3][q][2])
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if dArr[i][3][p][3][q][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(dArr[i][3][p][3][q][2][lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(dArr[i][3][p][3][q][3][lineplusoffset].." ("..strformat("%.2f", (dArr[i][3][p][3][q][3][lineplusoffset]*100/dArr[i][3][p][3][q][1])).."%)")
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
	end
	for qq=1, 10 do
		_G("DPSMate_Details_"..comp.."AbsorbsTaken_LogTwo_ScrollButton"..qq.."_selected"):Hide()
	end
	if (q-FauxScrollFrame_GetOffset(obj3))>0 then
		_G("DPSMate_Details_"..comp.."AbsorbsTaken_LogTwo_ScrollButton"..(q-FauxScrollFrame_GetOffset(obj3)).."_selected"):Show()
	end
end

function DPSMate.Modules.DetailsAbsorbsTaken:UpdateLineGraph(gg,comp, cname)
	if g3 then
		g3:Hide()
	end
	if g5 then
		g5:Hide()
	end

	if comp ~= "" and comp~=nil then
		cname = DetailsUserComp
	end
	
	local sumTable
	if toggle3 then
		if comp ~= "" and comp~=nil then
			sumTable = self:GetSummarizedTable(db, DetailsArrComp[DetailsSelectedComp], DetailsUserComp)
		else
			sumTable = self:GetSummarizedTable(db, DetailsArr[DetailsSelected])
		end
	else
		sumTable = self:GetSummarizedTable(db, nil, cname)
	end
	local max = DPSMate:GetMaxValue(sumTable, 2)
	local time = DPSMate:GetMaxValue(sumTable, 1)
	
	gg:ResetData()
	gg:SetXAxis(0,time)
	gg:SetYAxis(0,max+200)
	gg:SetGridSpacing(time/10,max/7)
	gg:SetGridColor({0.5,0.5,0.5,0.5})
	gg:SetAxisDrawing(true,true)
	gg:SetAxisColor({1.0,1.0,1.0,1.0})
	gg:SetAutoScale(true)
	gg:SetYLabels(true, false)
	gg:SetXLabels(true)

	local Data1={{0,0}}
	for cat, val in sumTable do
		tinsert(Data1, {val[1],val[2], {}})
	end
	
	local colorT = {{1.0,0.0,0.0,0.8}, {1.0,0.0,0.0,0.8}}
	if comp ~= "" and comp~=nil then
		colorT = {{0.5,0.8,0.9,0.8}, {0.2,0.8,0.2,0.8}}
	end

	gg:AddDataSeries(Data1,colorT, {})
	gg:Show()
	toggle2=false
end

function DPSMate.Modules.DetailsAbsorbsTaken:UpdateStackedGraph(gg, comp, cname)
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
	
	local uArr, dSel = DetailsArr, DetailsSelected
	if comp~="" and comp then
		uArr = DetailsArrComp
		dSel = DetailsSelectedComp
		cname = DetailsUserComp
	end
	
	if toggle3 then
		local temp = {}
		if db[DPSMateUser[cname or DetailsUser][1]] then
			if db[DPSMateUser[cname or DetailsUser][1]][uArr[dSel]] then
				local ownername = DPSMate:GetUserById(uArr[dSel])
				for ca, va in db[DPSMateUser[cname or DetailsUser][1]][uArr[dSel]]["i"] do
					local i, dmg = 1, 5
					if DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]] then
						if DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]][va[2]] then
							if DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]][va[2]][va[3]] then
								dmg = DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]][va[2]][va[3]][14]
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
						if not temp[va[3]] then
							temp[va[3]] = {}
						end
						while true do
							if (not temp[va[3]][i]) then
								tinsert(temp[va[3]], i, {va[1], dmg})
								break
							elseif va[1]<=temp[va[3]][i][1] then
								tinsert(temp[va[3]], i, {va[1], dmg})
								break
							end
							i=i+1
						end
					end
				end
			end
		end
		for cat, val in temp do
			tinsert(label, 1, DPSMate:GetAbilityById(cat))
			tinsert(Data1, 1, val)
		end
		
		local min
		for cat, val in Data1 do
			local pmin = DPSMate:GetMinValue(val, 1)
			if not min or pmin<min then
				min = pmin
			end
		end
		for cat, val in Data1 do
			Data1[cat] = DPSMate:ScaleDown(val, min)
		end
		
		gg:ResetData()
	else
		-- Add absorbs points
		local temp = {}
		for cat, val in db[DPSMateUser[cname or DetailsUser][1]] do
			local ownername = DPSMate:GetUserById(cat)
			for ca, va in val["i"] do
				local i, dmg = 1, 5
				if DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]] then
					if DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]][va[2]] then
						if DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]][va[2]][va[3]] then
							dmg = DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]][va[2]][va[3]][14]
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
					if not temp[va[3]] then
						temp[va[3]] = {}
					end
					while true do
						if (not temp[va[3]][i]) then
							tinsert(temp[va[3]], i, {va[1], dmg})
							break
						elseif va[1]<=temp[va[3]][i][1] then
							tinsert(temp[va[3]], i, {va[1], dmg})
							break
						end
						i=i+1
					end
				end
			end
		end
		for cat, val in temp do
			tinsert(label, 1, DPSMate:GetAbilityById(cat))
			tinsert(Data1, 1, val)
		end
		
		gg:ResetData()
	end
	
	gg:AddDataSeries(Data1,{1.0,0.0,0.0,0.8}, {}, label)
	gg:Show()
	toggle2 = true
end

function DPSMate.Modules.DetailsAbsorbsTaken:SortLineTable(arr, b, cname)
	local newArr = {}
	if b then
		local ownername = DPSMate:GetUserById(b)
		for ca, va in arr[DPSMateUser[cname or DetailsUser][1]][b]["i"] do
			local i, dmg = 1, 5
			if DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]] then
				if DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]][va[2]] then
					if DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]][va[2]][va[3]] then
						dmg = DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]][va[2]][va[3]][14]
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
	else
		for cat, val in arr[DPSMateUser[cname or DetailsUser][1]] do
			local ownername = DPSMate:GetUserById(cat)
			for ca, va in pairs(val["i"]) do
				local i, dmg = 1, 5
				if DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]] then
					if DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]][va[2]] then
						if DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]][va[2]][va[3]] then
							dmg = DPSMateDamageTaken[1][DPSMateUser[cname or DetailsUser][1]][va[2]][va[3]][14]
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

function DPSMate.Modules.DetailsAbsorbsTaken:GetSummarizedTable(arr,b,cname)
	return DPSMate.Sync:GetSummarizedTable(DPSMate.Modules.DetailsAbsorbsTaken:SortLineTable(arr,b,cname))
end

function DPSMate.Modules.DetailsAbsorbsTaken:ToggleMode()
	if toggle2 then
		self:UpdateLineGraph(g2, "")
		if DetailsUserComp then
			self:UpdateLineGraph(g4, "Compare")
		end
		toggle2 = false
	else
		self:UpdateStackedGraph(g3, "")
		if DetailsUserComp then
			self:UpdateStackedGraph(g5, "Compare")
		end
		toggle2 = true
	end
end

function DPSMate.Modules.DetailsAbsorbsTaken:ToggleIndividual()
	if toggle3 then
		toggle3=false
	else
		toggle3=true
	end
	if toggle2 then
		self:UpdateStackedGraph(g3, "")
		if DetailsUserComp then
			self:UpdateStackedGraph(g5, "Compare")
		end
	else
		self:UpdateLineGraph(g2, "")
		if DetailsUserComp then
			self:UpdateLineGraph(g4, "Compare")
		end
	end
	if DetailsUserComp then
		self:UpdateSumGraph()
	end
end

