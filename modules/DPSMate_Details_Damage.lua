-- Global Variables
DPSMate.Modules.DetailsDamage = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailsUser, DetailsSelected  = {}, 0, {}, "", 1
local DetailsArrComp, DetailsTotalComp, DmgArrComp, DetailsUserComp, DetailsSelectedComp  = {}, 0, {}, "", 1
local g, g2, g3, g4, g5, g6, g7
local curKey = 1
local db, cbt, db2 = {}, 0, {}
local _G = getglobal
local tinsert = table.insert
local strformat = string.format
local toggle, toggle2, toggle3 = false, false, false
local t1, t2, TTotal = {}, {}, 0
local t1Comp, t2Comp, TTotalComp = {}, {}, 0
local ecbt = {}
local PSelected = 1
local PSelected2 = 1

function DPSMate.Modules.DetailsDamage:UpdateDetails(obj, key)
	curKey = key
	db, cbt,ecbt = DPSMate:GetMode(key)
	db2 = DPSMate:GetModeByArr(DPSMateEDT, key, "EDTaken")
	DPSMate_Details.proc = "None"
	UIDropDownMenu_SetSelectedValue(DPSMate_Details_DiagramLegend_Procs, "None")
	DetailsUser = obj.user
	DetailsUserComp = nil
	DPSMate_Details_Title:SetText(DPSMate.L["dmgdoneby"]..obj.user)
	DPSMate_Details_SubTitle:SetText(DPSMate.L["activity"]..strformat("%.2f", (ecbt[obj.user] or 0)+1).."s "..DPSMate.L["of"].." "..strformat("%.2f", cbt).."s ("..strformat("%.2f", 100*((ecbt[obj.user] or 0)+1)/cbt).."%)")
	DPSMate_Details:Show()
	UIDropDownMenu_Initialize(DPSMate_Details_DiagramLegend_Procs, DPSMate.Modules.DetailsDamage.ProcsDropDown)
	DetailsArr, DetailsTotal, DmgArr = DPSMate.Modules.Damage:EvalTable(DPSMateUser[DetailsUser], curKey)
	t1, t2, TTotal = self:EvalToggleTable()
	
	if not g then
		g=DPSMate.Options.graph:CreateGraphPieChart("DMGPieChart", DPSMate_Details_Diagram, "CENTER", "CENTER", 0, 0, 200, 200)
		g2=DPSMate.Options.graph:CreateGraphLine("DMGLineGraph",DPSMate_Details_DiagramLine,"CENTER","CENTER",0,0,850,230)
		g3=DPSMate.Options.graph:CreateStackedGraph("DMGStackedGraph",DPSMate_Details_DiagramLine,"CENTER","CENTER",0,0,850,230)
		g3:SetGridColor({0.5,0.5,0.5,0.5})
		g3:SetAxisDrawing(true,true)
		g3:SetAxisColor({1.0,1.0,1.0,1.0})
		g3:SetAutoScale(true)
		g3:SetYLabels(true, false)
		g3:SetXLabels(true)
	end
	
	if toggle then
		self:Player_Update("")
		self:PlayerSpells_Update(1,"")
		self:SelectDetailsButton(1,"")
	else
		self:ScrollFrame_Update("")
		self:SelectDetailsButton(1,"")
	end
	self:UpdatePie(g)
	if toggle2 then
		self:UpdateStackedGraph(g3)
	else
		self:UpdateLineGraph(g2, "")
	end
	
	DPSMate_Details_CompareDamage:Hide()
	DPSMate_Details_CompareDamage_Graph:Hide()
	
	DPSMate_Details:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
	
end

function DPSMate.Modules.DetailsDamage:UpdateCompare(obj, key, comp)
	self:UpdateDetails(obj, key)
	
	DPSMate_Details_CompareDamage.proc = "None"
	UIDropDownMenu_SetSelectedValue(DPSMate_Details_CompareDamage_DiagramLegend_Procs, "None")
	DetailsUserComp = comp
	DPSMate_Details_CompareDamage_Title:SetText(DPSMate.L["dmgdoneby"]..comp)
	DPSMate_Details_CompareDamage_SubTitle:SetText(DPSMate.L["activity"]..strformat("%.2f", DPSMateCombatTime["effective"][key][comp] or 0).."s "..DPSMate.L["of"].." "..strformat("%.2f", DPSMateCombatTime[mode[key]]).."s ("..strformat("%.2f", 100*(DPSMateCombatTime["effective"][key][comp] or 0)/DPSMateCombatTime[mode[key]]).."%)")
	UIDropDownMenu_Initialize(DPSMate_Details_CompareDamage_DiagramLegend_Procs, DPSMate.Modules.DetailsDamage.ProcsDropDown_CompareDamage)
	DetailsArrComp, DetailsTotalComp, DmgArrComp = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[comp], curKey)
	t1Comp, t2Comp, TTotalComp = self:EvalToggleTable(comp)
	
	if not g4 then
		g4=DPSMate.Options.graph:CreateGraphPieChart("DMGPieChartComp", DPSMate_Details_CompareDamage_Diagram, "CENTER", "CENTER", 0, 0, 200, 200)
		g5=DPSMate.Options.graph:CreateGraphLine("DMGLineGraphComp",DPSMate_Details_CompareDamage_DiagramLine,"CENTER","CENTER",0,0,850,230)
		g6=DPSMate.Options.graph:CreateStackedGraph("DMGStackedGraphComp",DPSMate_Details_CompareDamage_DiagramLine,"CENTER","CENTER",0,0,850,230)
		g6:SetGridColor({0.5,0.5,0.5,0.5})
		g6:SetAxisDrawing(true,true)
		g6:SetAxisColor({1.0,1.0,1.0,1.0})
		g6:SetAutoScale(true)
		g6:SetYLabels(true, false)
		g6:SetXLabels(true)
		g7=DPSMate.Options.graph:CreateGraphLine("DMGLineGraphSum",DPSMate_Details_CompareDamage_Graph,"CENTER","CENTER",0,0,1750,230)
	end
	
	if toggle then
		self:Player_Update("_CompareDamage")
		self:PlayerSpells_Update(1, "_CompareDamage")
		self:SelectDetailsButton(1, "_CompareDamage")
		DPSMate_Details_CompareDamage_playerSpells:Show()
		DPSMate_Details_CompareDamage_player:Show()
		DPSMate_Details_CompareDamage_Diagram:Hide()
		DPSMate_Details_CompareDamage_Log:Hide()
	else
		self:ScrollFrame_Update("_CompareDamage")
		self:SelectDetailsButton(1,"_CompareDamage")
		DPSMate_Details_CompareDamage_playerSpells:Hide()
		DPSMate_Details_CompareDamage_player:Hide()
		DPSMate_Details_CompareDamage_Diagram:Show()
		DPSMate_Details_CompareDamage_Log:Show()
	end
	self:UpdatePie(g4, comp)
	if toggle2 then
		self:UpdateStackedGraph(g6, "_CompareDamage", comp)
	else
		self:UpdateLineGraph(g5, "_CompareDamage", comp)
	end
	self:UpdateSumGraph()
	
	DPSMate_Details_CompareDamage:Show()
	DPSMate_Details_CompareDamage_Graph:Show()
end

function DPSMate.Modules.DetailsDamage:UpdateSumGraph()
	-- Executing the sumGraph
	local sumTable, sumTableTwo
	if toggle3 then
		sumTable = self:GetSummarizedTable(db2, t1Comp[PSelected2], DetailsUserComp)
		sumTableTwo = self:GetSummarizedTable(db2, t1[PSelected])
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
		tinsert(ata, {val[1],val[2], self:CheckProcs(DPSMate_Details_CompareDamage.proc, val[1]+min+1, DetailsUserComp)})
	end
	
	local Data2={{0,0}}
	for cat, val in DPSMate:ScaleDown(sumTableTwo, minT) do
		tinsert(Data2, {val[1],val[2], self:CheckProcs(DPSMate_Details.proc, val[1]+minT+1)})
	end

	g7:AddDataSeries(ata,{{0.2,0.8,0.2,0.8}, {0.5,0.8,0.9,0.8}}, self:AddProcPoints(DPSMate_Details_CompareDamage.proc, ata, DetailsUserComp))
	g7:AddDataSeries(Data2,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, self:AddProcPoints(DPSMate_Details.proc, Data2))
	g7:Show()
end

function DPSMate.Modules.DetailsDamage:EvalToggleTable(comp)
	local a,b = {},{}
	local d = 0
	for cat, val in pairs(db2) do
		if val[DPSMateUser[comp or DetailsUser][1]] then
			local c = {[1] = 0,[2] = {},[3] = {}}
			for p, v in pairs(val[DPSMateUser[comp or DetailsUser][1]]) do
				if p ~= "i" then
					local i = 1
					while true do
						if (not c[2][i]) then
							tinsert(c[3], i, v)
							tinsert(c[2], i, p)
							break
						else
							if c[3][i][13] < v[13] then
								tinsert(c[3], i, v)
								tinsert(c[2], i, p)
								break
							end
						end
						i=i+1
					end
				end
			end
			c[1] = val[DPSMateUser[comp or DetailsUser][1]]["i"]
			-- pet
			if DPSMateUser[cname or DetailsUser][5] and DPSMateSettings["mergepets"] then
				if val[DPSMateUser[DPSMateUser[cname or DetailsUser][5]][1]] then
					for p, v in pairs(val[DPSMateUser[DPSMateUser[cname or DetailsUser][5]][1]]) do
						if p ~= "i" then
							local i = 1
							while true do
								if (not c[2][i]) then
									tinsert(c[3], i, v)
									tinsert(c[2], i, p)
									break
								else
									if c[3][i][13] < v[13] then
										tinsert(c[3], i, v)
										tinsert(c[2], i, p)
										break
									end
								end
								i=i+1
							end
						end
					end
					c[1] = c[1] + val[DPSMateUser[DPSMateUser[cname or DetailsUser][5]][1]]["i"]
				end
			end
			local i = 1
			while true do
				if (not a[i]) then
					tinsert(b, i, c)
					tinsert(a, i, cat)
					break
				else
					if b[i][1] < c[1] then
						tinsert(b, i, c)
						tinsert(a, i, cat)
						break
					end
				end
				i=i+1
			end
			d = d + c[1]
		end
	end
	return a,b,d
end

function DPSMate.Modules.DetailsDamage:ScrollFrame_Update(comp)
	if not comp then comp = DPSMate_Details.LastScroll or "" end
	local line, lineplusoffset
	local obj = _G("DPSMate_Details"..comp.."_Log_ScrollFrame")
	local path = "DPSMate_Details"..comp.."_Log"
	local uArr, dArr, dTot, dSel = DetailsArr, DmgArr, DetailsTotal, DetailsSelected
	if comp ~= "" and comp~=nil then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
		dSel = DetailsSelectedComp
	end
	local pet, len = "", DPSMate:TableLength(uArr)
	if comp ~= "" and comp~=nil then
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
	end
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,10 do
		lineplusoffset = line + (FauxScrollFrame_GetOffset(obj) or 0)
		if uArr[lineplusoffset] ~= nil then
			if dArr[lineplusoffset][2] then pet="(Pet)" else pet="" end
			local ability = DPSMate:GetAbilityById(uArr[lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(ability..pet)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(dArr[lineplusoffset][1].." ("..strformat("%.2f", (dArr[lineplusoffset][1]*100/dTot)).."%)")
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
end

function DPSMate.Modules.DetailsDamage:Player_Update(comp)
	if not comp then comp = DPSMate_Details.LastScroll or "" end
	local line, lineplusoffset
	local path = "DPSMate_Details"..comp.."_player"
	local obj = _G(path.."_ScrollFrame")
	local d1,d2,d3,d4 = t1,t2,TTotal,PSelected
	if comp ~= "" and comp~=nil then
		d1 = t1Comp
		d2 = t2Comp
		d3 = TTotalComp
		d4 = PSelected2
	end
	local len = DPSMate:TableLength(d1)
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
		if d1[lineplusoffset] ~= nil then
			local user = DPSMate:GetUserById(d1[lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(user)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(d2[lineplusoffset][1].." ("..strformat("%.2f", (d2[lineplusoffset][1]*100/d3)).."%)")
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
		if d4 == lineplusoffset then
			_G(path.."_ScrollButton"..line.."_selected"):Show()
		end
	end
end

function DPSMate.Modules.DetailsDamage:PlayerSpells_Update(i, comp)
	if not comp then comp = DPSMate_Details.LastScroll or "" end
	local line, lineplusoffset
	local path = "DPSMate_Details"..comp.."_playerSpells"
	local obj = _G(path.."_ScrollFrame")
	obj.id = (i + FauxScrollFrame_GetOffset(_G("DPSMate_Details"..comp.."_player_ScrollFrame"))) or obj.id
	local d1,d2,d3,d4 = t1,t2,TTotal,PSelected
	if comp ~= "" and comp~=nil then
		d2 = t2Comp
		d4 = PSelected2
	end
	local len = DPSMate:TableLength(d2[i][2])
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

	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if d2[obj.id][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(d2[obj.id][2][lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(d2[obj.id][3][lineplusoffset][13].." ("..strformat("%.2f", (d2[obj.id][3][lineplusoffset][13]*100/d2[obj.id][1])).."%)")
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
		if DetailsSelected == lineplusoffset then
			_G(path.."_ScrollButton"..line.."_selected"):Show()
		end
	end
	if comp ~= "" and comp~=nil then
		PSelected2 = obj.id
	else
		PSelected = obj.id
	end
	for p=1, 8 do
		_G("DPSMate_Details"..comp.."_player_ScrollButton"..p.."_selected"):Hide()
	end
	_G("DPSMate_Details"..comp.."_player_ScrollButton"..i.."_selected"):Show()
	if toggle3 then
		if toggle2 then
			if comp ~= "" and comp~=nil then
				self:UpdateStackedGraph(g6, comp, DetailsUserComp)
			else
				self:UpdateStackedGraph(g3)
			end
		else
			if comp ~= "" and comp~=nil then
				self:UpdateLineGraph(g5, comp, DetailsUserComp)
			else
				self:UpdateLineGraph(g2, "")
			end
		end
		if DetailsUserComp then
			self:UpdateSumGraph()
		end
	end
end

function DPSMate.Modules.DetailsDamage:SelectDetailsButton(i, comp, cname)
	if not comp then comp = DPSMate_Details.LastScroll or "" end
	local pathh = ""
	local path,obj,lineplusoffset
	local uArr, dSel, d2 = DetailsArr, DetailsSelected, t2
	if comp ~= "" and comp~=nil then
		uArr = DetailsArrComp
		dSel = DetailsSelectedComp
		if not cname then
			cname = DetailsUserComp
		end
		d2 = t2Comp
	end
	local user, pet = DPSMateUser[cname or DetailsUser][1], ""
	if toggle then
		pathh = "DPSMate_Details"..comp.."_playerSpells"
		obj = _G(pathh.."_ScrollFrame")
		lineplusoffset = i + (FauxScrollFrame_GetOffset(obj) or 0)
		path = d2[obj.id][3][lineplusoffset]
	else
		pathh = "DPSMate_Details"..comp.."_Log"
		obj = _G(pathh.."_ScrollFrame")
		lineplusoffset = i + (FauxScrollFrame_GetOffset(obj) or 0)
		local ability = tonumber(uArr[lineplusoffset])
		if (db[DPSMateUser[cname or DetailsUser][1]][ability]) then user=DPSMateUser[cname or DetailsUser][1]; pet=0; else if DPSMateUser[cname or DetailsUser][5] then user=DPSMateUser[DPSMateUser[cname or DetailsUser][5]][1]; pet=5; else user=DPSMateUser[cname or DetailsUser][1]; pet=0; end end
		path = db[user][tonumber(uArr[lineplusoffset])]
	end
	if comp ~= "" and comp~=nil then
		DetailsSelectedComp = lineplusoffset
	else
		DetailsSelected = lineplusoffset
	end
	for p=1, 10 do
		_G(pathh.."_ScrollButton"..p.."_selected"):Hide()
	end
	_G(pathh.."_ScrollButton"..i.."_selected"):Show()
	local hit, crit, miss, parry, dodge, resist, hitMin, hitMax, critMin, critMax, hitav, critav, glance, glanceMin, glanceMax, glanceav, block, blockMin, blockMax, blockav = path[1], path[5], path[9], path[10], path[11], path[12], path[2], path[3], path[6], path[7], path[4], path[8], path[14], path[15], path[16], path[17], path[18], path[19], path[20], path[21]
	local total, max = hit+crit+miss+parry+dodge+resist+glance+block, DPSMate:TMax({hit, crit, miss, parry, dodge, resist, glance, block})
	
	_G("DPSMate_Details"..comp.."_LogDetails_Casts"):SetText("C: "..path[22])
	-- Block
	_G("DPSMate_Details"..comp.."_LogDetails_Amount0_Amount"):SetText(block)
	_G("DPSMate_Details"..comp.."_LogDetails_Amount0_Percent"):SetText(strformat("%.1f", 100*block/total).."%")
	_G("DPSMate_Details"..comp.."_LogDetails_Amount0_StatusBar"):SetValue(ceil(100*block/max))
	_G("DPSMate_Details"..comp.."_LogDetails_Amount0_StatusBar"):SetStatusBarColor(0.3,0.7,1.0,1)
	_G("DPSMate_Details"..comp.."_LogDetails_Average0"):SetText(ceil(blockav))
	_G("DPSMate_Details"..comp.."_LogDetails_Min0"):SetText(blockMin)
	_G("DPSMate_Details"..comp.."_LogDetails_Max0"):SetText(blockMax)
	
	-- Glance
	_G("DPSMate_Details"..comp.."_LogDetails_Amount1_Amount"):SetText(glance)
	_G("DPSMate_Details"..comp.."_LogDetails_Amount1_Percent"):SetText(strformat("%.1f", 100*glance/total).."%")
	_G("DPSMate_Details"..comp.."_LogDetails_Amount1_StatusBar"):SetValue(ceil(100*glance/max))
	_G("DPSMate_Details"..comp.."_LogDetails_Amount1_StatusBar"):SetStatusBarColor(1.0,0.7,0.3,1)
	_G("DPSMate_Details"..comp.."_LogDetails_Average1"):SetText(ceil(glanceav))
	_G("DPSMate_Details"..comp.."_LogDetails_Min1"):SetText(glanceMin)
	_G("DPSMate_Details"..comp.."_LogDetails_Max1"):SetText(glanceMax)
	
	-- Hit
	_G("DPSMate_Details"..comp.."_LogDetails_Amount2_Amount"):SetText(hit)
	_G("DPSMate_Details"..comp.."_LogDetails_Amount2_Percent"):SetText(strformat("%.1f", 100*hit/total).."%")
	_G("DPSMate_Details"..comp.."_LogDetails_Amount2_StatusBar"):SetValue(ceil(100*hit/max))
	_G("DPSMate_Details"..comp.."_LogDetails_Amount2_StatusBar"):SetStatusBarColor(0.9,0.0,0.0,1)
	_G("DPSMate_Details"..comp.."_LogDetails_Average2"):SetText(ceil(hitav))
	_G("DPSMate_Details"..comp.."_LogDetails_Min2"):SetText(hitMin)
	_G("DPSMate_Details"..comp.."_LogDetails_Max2"):SetText(hitMax)
	
	-- Crit
	_G("DPSMate_Details"..comp.."_LogDetails_Amount3_Amount"):SetText(crit)
	_G("DPSMate_Details"..comp.."_LogDetails_Amount3_Percent"):SetText(strformat("%.1f", 100*crit/total).."%")
	_G("DPSMate_Details"..comp.."_LogDetails_Amount3_StatusBar"):SetValue(ceil(100*crit/max))
	_G("DPSMate_Details"..comp.."_LogDetails_Amount3_StatusBar"):SetStatusBarColor(0.0,0.9,0.0,1)
	_G("DPSMate_Details"..comp.."_LogDetails_Average3"):SetText(ceil(critav))
	_G("DPSMate_Details"..comp.."_LogDetails_Min3"):SetText(critMin)
	_G("DPSMate_Details"..comp.."_LogDetails_Max3"):SetText(critMax)
	
	-- Miss
	_G("DPSMate_Details"..comp.."_LogDetails_Amount4_Amount"):SetText(miss)
	_G("DPSMate_Details"..comp.."_LogDetails_Amount4_Percent"):SetText(strformat("%.1f", 100*miss/total).."%")
	_G("DPSMate_Details"..comp.."_LogDetails_Amount4_StatusBar"):SetValue(ceil(100*miss/max))
	_G("DPSMate_Details"..comp.."_LogDetails_Amount4_StatusBar"):SetStatusBarColor(0.0,0.0,1.0,1)
	_G("DPSMate_Details"..comp.."_LogDetails_Average4"):SetText("-")
	_G("DPSMate_Details"..comp.."_LogDetails_Min4"):SetText("-")
	_G("DPSMate_Details"..comp.."_LogDetails_Max4"):SetText("-")
	
	-- Parry
	_G("DPSMate_Details"..comp.."_LogDetails_Amount5_Amount"):SetText(parry)
	_G("DPSMate_Details"..comp.."_LogDetails_Amount5_Percent"):SetText(strformat("%.1f", 100*parry/total).."%")
	_G("DPSMate_Details"..comp.."_LogDetails_Amount5_StatusBar"):SetValue(ceil(100*parry/max))
	_G("DPSMate_Details"..comp.."_LogDetails_Amount5_StatusBar"):SetStatusBarColor(1.0,1.0,0.0,1)
	_G("DPSMate_Details"..comp.."_LogDetails_Average5"):SetText("-")
	_G("DPSMate_Details"..comp.."_LogDetails_Min5"):SetText("-")
	_G("DPSMate_Details"..comp.."_LogDetails_Max5"):SetText("-")
	
	-- Dodge
	_G("DPSMate_Details"..comp.."_LogDetails_Amount6_Amount"):SetText(dodge)
	_G("DPSMate_Details"..comp.."_LogDetails_Amount6_Percent"):SetText(strformat("%.1f", 100*dodge/total).."%")
	_G("DPSMate_Details"..comp.."_LogDetails_Amount6_StatusBar"):SetValue(ceil(100*dodge/max))
	_G("DPSMate_Details"..comp.."_LogDetails_Amount6_StatusBar"):SetStatusBarColor(1.0,0.0,1.0,1)
	_G("DPSMate_Details"..comp.."_LogDetails_Average6"):SetText("-")
	_G("DPSMate_Details"..comp.."_LogDetails_Min6"):SetText("-")
	_G("DPSMate_Details"..comp.."_LogDetails_Max6"):SetText("-")
	
	-- Resist
	_G("DPSMate_Details"..comp.."_LogDetails_Amount7_Amount"):SetText(resist)
	_G("DPSMate_Details"..comp.."_LogDetails_Amount7_Percent"):SetText(strformat("%.1f", 100*resist/total).."%")
	_G("DPSMate_Details"..comp.."_LogDetails_Amount7_StatusBar"):SetValue(ceil(100*resist/max))
	_G("DPSMate_Details"..comp.."_LogDetails_Amount7_StatusBar"):SetStatusBarColor(0.0,1.0,1.0,1)
	_G("DPSMate_Details"..comp.."_LogDetails_Average7"):SetText("-")
	_G("DPSMate_Details"..comp.."_LogDetails_Min7"):SetText("-")
	_G("DPSMate_Details"..comp.."_LogDetails_Max7"):SetText("-")
end

function DPSMate.Modules.DetailsDamage:UpdatePie(gg, cname)
	local uArr, dArr, dTot = DetailsArr, DmgArr, DetailsTotal
	if cname then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
	end
	gg:ResetPie()
	for cat, val in uArr do
		if (dArr[cat][2]) then user=DPSMateUser[DPSMateUser[cname or DetailsUser][5]][1] else user=DPSMateUser[cname or DetailsUser][1] end
		local percent = (db[user][val][13]*100/dTot)
		gg:AddPie(percent, 0, DPSMate:GetAbilityById(val))
	end
end

function DPSMate.Modules.DetailsDamage:UpdateLineGraph(gg, comp, cname)
	if not comp then comp = DPSMate_Details.LastScroll or "" end
	if g3 then
		g3:Hide()
	end
	if g6 then
		g6:Hide()
	end	
	local sumTable
	if toggle3 then
		if comp ~= "" and comp~=nil then
			sumTable = self:GetSummarizedTable(db2, t1Comp[PSelected2], cname)
		else
			sumTable = self:GetSummarizedTable(db2, t1[PSelected])
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
		tinsert(Data1, {val[1],val[2], self:CheckProcs(_G("DPSMate_Details"..comp).proc, val[1]+(min-1), cname)})
	end
	local colorT = {{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}
	if cname then
		colorT = {{0.2,0.8,0.2,0.8}, {0.5,0.8,0.9,0.8}}
	end
	
	gg:AddDataSeries(Data1,colorT, self:AddProcPoints(_G("DPSMate_Details"..comp).proc, Data1, cname))
	gg:Show()
	toggle2 = false
end

function DPSMate.Modules.DetailsDamage:UpdateStackedGraph(gg, comp, cname)
	if not comp then comp = DPSMate_Details.LastScroll or "" end
	if g2 then
		g2:Hide()
	end
	if g5 then
		g5:Hide()
	end
	
	local d1,d2,d3,d4 = t1,t2,TTotal,PSelected
	if comp ~= "" and comp~=nil then
		d1 = t1Comp
		d2 = t2Comp
		d4 = PSelected2
	end
	
	local Data1 = {}
	local label = {}
	local b = {}
	local p = {}
	local maxY = 0
	local maxX = 0
	local temp = {}
	local temp2 = {}
	if toggle3 then
		for cat, val in pairs(db2[d1[d4]][DPSMateUser[cname or DetailsUser][1]]) do
			if cat~="i" and val["i"] then
				for c, v in pairs(val["i"]) do
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
					temp2[cat] = temp2[cat] + val[13]
					maxY = math.max(p[key], maxY)
					maxX = math.max(c, maxX)
				end
			end
		end
		
		-- pet
		if DPSMateUser[cname or DetailsUser][5] and DPSMateSettings["mergepets"] then
			if db2[d1[d4]][DPSMateUser[DPSMateUser[cname or DetailsUser][5]][1]] then
				for cat, val in pairs(db2[d1[d4]][DPSMateUser[DPSMateUser[cname or DetailsUser][5]][1]]) do
					if cat~="i" and val["i"] then
						for c, v in pairs(val["i"]) do
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
							temp2[cat] = temp2[cat] + val[13]
							maxY = math.max(p[key], maxY)
							maxX = math.max(c, maxX)
						end
					end
				end
			end
		end
		
		local min
		for cat, val in pairs(temp) do
			local pmin = DPSMate:GetMinValue(val, 1)
			if not min or pmin<min then
				min = pmin
			end
		end
		for cat, val in pairs(temp) do
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
		for cat, val in pairs(Data1) do
			Data1[cat] = DPSMate:ScaleDown(val, min)
		end
	
		gg:ResetData()
		gg:SetGridSpacing((maxX-min)/7,maxY/7)
	else
		for cat, val in pairs(db[DPSMateUser[cname or DetailsUser][1]]) do
			if cat~="i" and val["i"] then
				local temp = {}
				for c, v in pairs(val["i"]) do
					local key = tonumber(strformat("%.1f", c))
					if p[key] then
						p[key] = p[key] + v
					else
						p[key] = v
					end
					local i = 1
					while true do
						if not temp[i] then
							tinsert(temp, i, {c,v})
							break
						elseif c<temp[i][1] then
							tinsert(temp, i, {c,v})
							break
						end
						i = i + 1
					end
					maxY = math.max(p[key], maxY)
					maxX = math.max(c, maxX)
				end
				local i = 1
				while true do
					if not b[i] then
						tinsert(b, i, val[13])
						tinsert(label, i, DPSMate:GetAbilityById(cat))
						tinsert(Data1, i, temp)
						break
					elseif b[i]>=val[13] then
						tinsert(b, i, val[13])
						tinsert(label, i, DPSMate:GetAbilityById(cat))
						tinsert(Data1, i, temp)
						break
					end
					i = i + 1
				end
			end
		end
		-- Pet
		if DPSMateUser[cname or DetailsUser][5] and DPSMateSettings["mergepets"] then
			if db[DPSMateUser[DPSMateUser[cname or DetailsUser][5]][1]] then
				for cat, val in pairs(db[DPSMateUser[DPSMateUser[cname or DetailsUser][5]][1]]) do
					if cat~="i" and val["i"] then
						local temp = {}
						for c, v in pairs(val["i"]) do
							local key = tonumber(strformat("%.1f", c))
							if p[key] then
								p[key] = p[key] + v
							else
								p[key] = v
							end
							local i = 1
							while true do
								if not temp[i] then
									tinsert(temp, i, {c,v})
									break
								elseif c<temp[i][1] then
									tinsert(temp, i, {c,v})
									break
								end
								i = i + 1
							end
							maxY = math.max(p[key], maxY)
							maxX = math.max(c, maxX)
						end
						local i = 1
						while true do
							if not b[i] then
								tinsert(b, i, val[13])
								tinsert(label, i, DPSMate:GetAbilityById(cat))
								tinsert(Data1, i, temp)
								break
							elseif b[i]>=val[13] then
								tinsert(b, i, val[13])
								tinsert(label, i, DPSMate:GetAbilityById(cat))
								tinsert(Data1, i, temp)
								break
							end
							i = i + 1
						end
					end
				end
			end
		end
	
		gg:ResetData()
		gg:SetGridSpacing(maxX/7,maxY/7)
	end
	
	gg:AddDataSeries(Data1,{1.0,0.0,0.0,0.8}, {}, label)
	gg:Show()
	toggle2 = true
end

function DPSMate.Modules.DetailsDamage:CreateGraphTable(comp)
	local lines = {}
	for i=1, 8 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details"..comp.."_LogDetails"), 10, 270-i*30, 370, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[9] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details"..comp.."_LogDetails"), 57, 260, 57, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details"..comp.."_LogDetails"), 192, 260, 192, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details"..comp.."_LogDetails"), 252, 260, 252, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
	
	lines[12] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details"..comp.."_LogDetails"), 312, 260, 312, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
end

function DPSMate.Modules.DetailsDamage:ProcsDropDown()
	local arr = DPSMate.Modules.DetailsDamage:GetAuraGainedArr(curKey)
	DPSMate_Details.proc = "None"
	
    local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_Details_DiagramLegend_Procs, this.value)
		DPSMate_Details.proc = this.value
		if not toggle2 then
			DPSMate.Modules.DetailsDamage:UpdateLineGraph(g2, "")
		end
		if DetailsUserComp then
			DPSMate.Modules.DetailsDamage:UpdateSumGraph()
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
	
	if DPSMate_Details.LastUser~=DetailsUser then
		UIDropDownMenu_SetSelectedValue(DPSMate_Details_DiagramLegend_Procs, "None")
	end
	DPSMate_Details.LastUser = DetailsUser
end

function DPSMate.Modules.DetailsDamage:ProcsDropDown_CompareDamage()
	local arr = DPSMate.Modules.DetailsDamage:GetAuraGainedArr(curKey)
	DPSMate_Details_CompareDamage.proc = "None"
	
    local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_Details_CompareDamage_DiagramLegend_Procs, this.value)
		DPSMate_Details_CompareDamage.proc = this.value
		if not toggle2 then
			DPSMate.Modules.DetailsDamage:UpdateLineGraph(g5, "_CompareDamage", DetailsUserComp)
		end
		DPSMate.Modules.DetailsDamage:UpdateSumGraph()
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
	
	if DPSMate_Details_CompareDamage.LastUser~=DetailsUserComp then
		UIDropDownMenu_SetSelectedValue(DPSMate_Details_CompareDamage_DiagramLegend_Procs, "None")
	end
	DPSMate_Details_CompareDamage.LastUser = DetailsUserComp
end

function DPSMate.Modules.DetailsDamage:SortLineTable(t, b, cname)
	local newArr = {}
	if b then
		for cat, val in t[b][DPSMateUser[cname or DetailsUser][1]] do
			if cat~="i" and val["i"] then
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
		-- Pet
		if DPSMateUser[cname or DetailsUser][5] then
			if t[DPSMateUser[DPSMateUser[cname or DetailsUser][5]][1]] then
				for cat, val in t[b][DPSMateUser[DPSMateUser[cname or DetailsUser][5]][1]] do
					if cat~="i" and val["i"] then
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
			end
		end
	else
		for cat, val in t[DPSMateUser[cname or DetailsUser][1]] do
			if cat~="i" and val["i"] then
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
		-- Pet
		if DPSMateUser[cname or DetailsUser][5] then
			if t[DPSMateUser[DPSMateUser[cname or DetailsUser][5]][1]] then
				for cat, val in t[DPSMateUser[DPSMateUser[cname or DetailsUser][5]][1]] do
					if cat~="i" and val["i"] then
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
			end
		end
	end
	return newArr
end

function DPSMate.Modules.DetailsDamage:GetSummarizedTable(arr, b, cname)
	return DPSMate.Sync:GetSummarizedTable(self:SortLineTable(arr, b, cname))
end

function DPSMate.Modules.DetailsDamage:GetAuraGainedArr(k)
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

function DPSMate.Modules.DetailsDamage:CheckProcs(name, val, cname)
	local arr = DPSMate.Modules.DetailsDamage:GetAuraGainedArr(curKey)
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

function DPSMate.Modules.DetailsDamage:AddProcPoints(name, dat, cname)
	local bool, data, LastVal = false, {}, 0
	local arr = self:GetAuraGainedArr(curKey)
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

function DPSMate.Modules.DetailsDamage:ToggleMode(bool)
	if bool then
		if toggle2 then
			self:UpdateLineGraph(g2,"")
			if DetailsUserComp then
				self:UpdateLineGraph(g5,"_CompareDamage", DetailsUserComp)
			end
		else
			self:UpdateStackedGraph(g3)
			if DetailsUserComp then
				self:UpdateStackedGraph(g6,"_CompareDamage", DetailsUserComp)
			end
		end
	else
		if toggle then
			toggle = false
			self:ScrollFrame_Update("")
			self:SelectDetailsButton(1,"")
			DPSMate_Details_playerSpells:Hide()
			DPSMate_Details_player:Hide()
			DPSMate_Details_Diagram:Show()
			DPSMate_Details_Log:Show()
			
			if DetailsUserComp then
				self:ScrollFrame_Update("_CompareDamage")
				self:SelectDetailsButton(1,"_CompareDamage")
				DPSMate_Details_CompareDamage_playerSpells:Hide()
				DPSMate_Details_CompareDamage_player:Hide()
				DPSMate_Details_CompareDamage_Diagram:Show()
				DPSMate_Details_CompareDamage_Log:Show()
			end
		else
			toggle = true
			self:Player_Update("")
			self:PlayerSpells_Update(1,"")
			self:SelectDetailsButton(1,"")
			DPSMate_Details_playerSpells:Show()
			DPSMate_Details_player:Show()
			DPSMate_Details_Diagram:Hide()
			DPSMate_Details_Log:Hide()
			
			if DetailsUserComp then
				self:Player_Update("_CompareDamage")
				self:PlayerSpells_Update(1, "_CompareDamage")
				self:SelectDetailsButton(1, "_CompareDamage")
				DPSMate_Details_CompareDamage_playerSpells:Show()
				DPSMate_Details_CompareDamage_player:Show()
				DPSMate_Details_CompareDamage_Diagram:Hide()
				DPSMate_Details_CompareDamage_Log:Hide()
			end
		end
	end
end

function DPSMate.Modules.DetailsDamage:ToggleIndividual()
	if toggle3 then
		toggle3 = false
	else
		toggle3 = true
	end
	if toggle2 then
		self:UpdateStackedGraph(g3)
		if DetailsUserComp then 
			self:UpdateStackedGraph(g6,"_CompareDamage", DetailsUserComp)
		end
	else
		self:UpdateLineGraph(g2,"")
		if DetailsUserComp then
			self:UpdateLineGraph(g5,"_CompareDamage", DetailsUserComp)
		end
	end
	if DetailsUserComp then
		self:UpdateSumGraph()
	end
end

