-- Global Variables
DPSMate.Modules.DetailsHealingAndAbsorbs = {}

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

function DPSMate.Modules.DetailsHealingAndAbsorbs:UpdateDetails(obj, key)
	curKey = key
	db, cbt,ecbt = DPSMate:GetMode(key)
	db2 = DPSMate:GetModeByArr(DPSMateEHealingTaken, key, "EHealingTaken")
	DPSMate_Details_HealingAndAbsorbs.proc = "None"
	UIDropDownMenu_SetSelectedValue(DPSMate_Details_HealingAndAbsorbs_DiagramLegend_Procs, "None")
	DetailsUser = obj.user
	DetailsUserComp = nil
	DPSMate_Details_HealingAndAbsorbs_Title:SetText(DPSMate.L["habby"]..obj.user)
	DPSMate_Details_HealingAndAbsorbs_SubTitle:SetText(DPSMate.L["activity"]..strformat("%.2f", (ecbt[obj.user] or 0)+1).."s "..DPSMate.L["of"].." "..strformat("%.2f", cbt).."s ("..strformat("%.2f", 100*((ecbt[obj.user] or 0)+1)/cbt).."%)")
	DPSMate_Details_HealingAndAbsorbs:Show()
	UIDropDownMenu_Initialize(DPSMate_Details_HealingAndAbsorbs_DiagramLegend_Procs, DPSMate.Modules.DetailsHealingAndAbsorbs.ProcsDropDown)
	DetailsArr, DetailsTotal, DmgArr = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[DetailsUser], curKey)
	t1, t2, TTotal = self:EvalToggleTable()
	
	if not g then
		g=DPSMate.Options.graph:CreateGraphPieChart("HABPieChart", DPSMate_Details_HealingAndAbsorbs_Diagram, "CENTER", "CENTER", 0, 0, 200, 200)
		g2=DPSMate.Options.graph:CreateGraphLine("HABLineGraph",DPSMate_Details_HealingAndAbsorbs_DiagramLine,"CENTER","CENTER",0,0,850,230)
		g3=DPSMate.Options.graph:CreateStackedGraph("HABStackedGraph",DPSMate_Details_HealingAndAbsorbs_DiagramLine,"CENTER","CENTER",0,0,850,230)
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
		self:SelectDetails_HealingAndAbsorbsButton(1,"")
	else
		self:ScrollFrame_Update("")
		self:SelectDetails_HealingAndAbsorbsButton(1,"")
	end
	self:UpdatePie(g)
	if toggle2 then
		self:UpdateStackedGraph(g3)
	else
		self:UpdateLineGraph(g2, "")
	end
	
	DPSMate_Details_CompareHealingAndAbsorbs:Hide()
	DPSMate_Details_CompareHealingAndAbsorbs_Graph:Hide()
	DPSMate_Details_HealingAndAbsorbs:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:UpdateCompare(obj, key, comp)
	self:UpdateDetails(obj, key)
	
	DPSMate_Details_CompareHealingAndAbsorbs.proc = "None"
	UIDropDownMenu_SetSelectedValue(DPSMate_Details_CompareHealingAndAbsorbs_DiagramLegend_Procs, "None")
	DetailsUserComp = comp
	DPSMate_Details_CompareHealingAndAbsorbs_Title:SetText(DPSMate.L["habby"]..comp)
	DPSMate_Details_CompareHealingAndAbsorbs_SubTitle:SetText(DPSMate.L["activity"]..strformat("%.2f", DPSMateCombatTime["effective"][key][comp] or 0).."s "..DPSMate.L["of"].." "..strformat("%.2f", DPSMateCombatTime[mode[key]]).."s ("..strformat("%.2f", 100*(DPSMateCombatTime["effective"][key][comp] or 0)/DPSMateCombatTime[mode[key]]).."%)")
	UIDropDownMenu_Initialize(DPSMate_Details_CompareHealingAndAbsorbs_DiagramLegend_Procs, DPSMate.Modules.DetailsHealingAndAbsorbs.ProcsDropDown_CompareHealingAndAbsorbs)
	DetailsArrComp, DetailsTotalComp, DmgArrComp = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[comp], curKey)
	t1Comp, t2Comp, TTotalComp = self:EvalToggleTable(comp)
	
	if not g4 then
		g4=DPSMate.Options.graph:CreateGraphPieChart("HABPieChartComp", DPSMate_Details_CompareHealingAndAbsorbs_Diagram, "CENTER", "CENTER", 0, 0, 200, 200)
		g5=DPSMate.Options.graph:CreateGraphLine("HABLineGraphComp",DPSMate_Details_CompareHealingAndAbsorbs_DiagramLine,"CENTER","CENTER",0,0,850,230)
		g6=DPSMate.Options.graph:CreateStackedGraph("HABStackedGraphComp",DPSMate_Details_CompareHealingAndAbsorbs_DiagramLine,"CENTER","CENTER",0,0,850,230)
		g6:SetGridColor({0.5,0.5,0.5,0.5})
		g6:SetAxisDrawing(true,true)
		g6:SetAxisColor({1.0,1.0,1.0,1.0})
		g6:SetAutoScale(true)
		g6:SetYLabels(true, false)
		g6:SetXLabels(true)
		g7=DPSMate.Options.graph:CreateGraphLine("HABLineGraphSum",DPSMate_Details_CompareHealingAndAbsorbs_Graph,"CENTER","CENTER",0,0,1750,230)
	end
	
	if toggle then
		self:Player_Update("Compare")
		self:PlayerSpells_Update(1, "Compare")
		self:SelectDetails_HealingAndAbsorbsButton(1, "Compare")
		DPSMate_Details_CompareHealingAndAbsorbs_playerSpells:Show()
		DPSMate_Details_CompareHealingAndAbsorbs_player:Show()
		DPSMate_Details_CompareHealingAndAbsorbs_Diagram:Hide()
		DPSMate_Details_CompareHealingAndAbsorbs_Log:Hide()
	else
		self:ScrollFrame_Update("Compare")
		self:SelectDetails_HealingAndAbsorbsButton(1, "Compare")
		DPSMate_Details_CompareHealingAndAbsorbs_playerSpells:Hide()
		DPSMate_Details_CompareHealingAndAbsorbs_player:Hide()
		DPSMate_Details_CompareHealingAndAbsorbs_Diagram:Show()
		DPSMate_Details_CompareHealingAndAbsorbs_Log:Show()
	end
	self:UpdatePie(g4, comp)
	if toggle2 then
		self:UpdateStackedGraph(g6, "Compare", comp)
	else
		self:UpdateLineGraph(g5, "Compare", comp)
	end
	self:UpdateSumGraph()
	
	DPSMate_Details_CompareHealingAndAbsorbs:Show()
	DPSMate_Details_CompareHealingAndAbsorbs_Graph:Show()
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:UpdateSumGraph()
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
		tinsert(ata, {val[1],val[2], self:CheckProcs(DPSMate_Details_CompareHealingAndAbsorbs.proc, val[1]+min+1, DetailsUserComp)})
	end
	
	local Data2={{0,0}}
	for cat, val in DPSMate:ScaleDown(sumTableTwo, minT) do
		tinsert(Data2, {val[1],val[2], self:CheckProcs(DPSMate_Details_HealingAndAbsorbs.proc, val[1]+minT+1)})
	end

	g7:AddDataSeries(ata,{{0.2,0.8,0.2,0.8}, {0.5,0.8,0.9,0.8}}, self:AddProcPoints(DPSMate_Details_CompareHealingAndAbsorbs.proc, ata, DetailsUserComp))
	g7:AddDataSeries(Data2,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, self:AddProcPoints(DPSMate_Details_HealingAndAbsorbs.proc, Data2))
	g7:Show()
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:EvalToggleTable(cname)
	local a,b = {},{}
	local d = 0
	local hackTemp = {}
	for cat, val in db2 do
		if val[DPSMateUser[cname or DetailsUser][1]] then
			local CV = 0
			local c = {[1] = 0,[2] = {},[3] = {}}
			for p, v in val[DPSMateUser[cname or DetailsUser][1]] do
				CV = CV + v[1]
				local i = 1
				while true do
					if (not c[2][i]) then
						tinsert(c[3], i, v)
						tinsert(c[2], i, p)
						break
					else
						if c[3][i][1] < v[1] then
							tinsert(c[3], i, v)
							tinsert(c[2], i, p)
							break
						end
					end
					i=i+1
				end
			end
			c[1] = CV
			hackTemp[cat] = {}
			tinsert(hackTemp[cat], c)
			d = d + CV
		end
	end
	
	-- Absorbs
	for cat, val in DPSMateAbsorbs[curKey] do
		if val[DPSMateUser[cname or DetailsUser][1]] then
			local CV = 0
			local c = {[1] = 0,[2] = {},[3] = {}}
			for ca, va in val[DPSMateUser[cname or DetailsUser][1]] do
				local dmg = 5
				local hit, hitav, hitmin, hitmax = 0, 0, 0, 0
				local shieldname = DPSMate:GetAbilityById(ca)
				if ca~="i" then
					for ce, ve in pairs(va) do -- 1
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
										p = ceil((1/totalHits)*((DPSMateUser[cname or DetailsUser][8] or 60)/60)*DPSMate.DB.FixedShieldAmounts[shieldname]*0.33)
									end
									PerShieldAbsorb=PerShieldAbsorb+ss*p
								end
							end
						end
						if ve["i"][1]==1 then
							PerShieldAbsorb=PerShieldAbsorb+ve["i"][2]
						end
						dmg = dmg+PerShieldAbsorb
						if PerShieldAbsorb>hitmax then hitmax = PerShieldAbsorb end
						if (PerShieldAbsorb<hitmin or hitmin == 0) and PerShieldAbsorb>0 then hitmin = PerShieldAbsorb end
						hitav = DPSMate.DB:WeightedAverage(hitav, PerShieldAbsorb, hit, 1)
						hit=hit+1
					end
				
					local temp ={
						[1] = dmg,
						[2] = hit,
						[3] = 0,
						[4] = hitav,
						[5] = 0,
						[6] = hitmin,
						[7] = hitmax,
						[8] = 0,
						[9] = 0
					}
					
					local i = 1
					while true do
						if (not c[2][i]) then
							tinsert(c[3], i, temp)
							tinsert(c[2], i, ca)
							break
						else
							if c[3][i][1] < dmg then
								tinsert(c[3], i, temp)
								tinsert(c[2], i, ca)
								break
							end
						end
						i=i+1
					end
					CV = CV + dmg
				end
			end
			if CV>0 then
				c[1] = CV
				if not hackTemp[cat] then
					hackTemp[cat] = {}
				end
				tinsert(hackTemp[cat], c)
				d = d + CV
			end
		end
	end
	-- Summing same player together
	for cat, val in pairs(hackTemp) do
		local totVal = 0;
		local newAbArr = {[1] = 0,[2] = {},[3] = {}}
		for ca, va in pairs(val) do
			for c, v in pairs(va[3]) do
				local p=1;
				while true do
					if (not newAbArr[2][p]) then
						tinsert(newAbArr[3], p, v)
						tinsert(newAbArr[2], p, va[2][c])
						break
					elseif newAbArr[3][p][1]<v[1] then
						tinsert(newAbArr[3], p, v)
						tinsert(newAbArr[2], p, va[2][c])
						break
					end
					p = p + 1
				end
			end
			newAbArr[1] = newAbArr[1] + va[1]
			totVal = totVal + va[1]
		end
		local i = 1
		while true do
			if (not a[i]) then
				tinsert(b, i, newAbArr)
				tinsert(a, i, cat)
				break
			else
				if b[i][1] < totVal then
					tinsert(b, i, newAbArr)
					tinsert(a, i, cat)
					break
				end
			end
			i=i+1
		end
	end
	return a,b,d
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:ScrollFrame_Update(comp)
	if not comp then comp = DPSMate_Details_HealingAndAbsorbs.LastScroll or "" end
	local line, lineplusoffset
	local obj = _G("DPSMate_Details_"..comp.."HealingAndAbsorbs_Log_ScrollFrame")
	local uArr, dArr, dTot, dSel = DetailsArr, DmgArr, DetailsTotal, DetailsSelected
	if comp ~= "" and comp~=nil then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
		dSel = DetailsSelectedComp
	end
	local len = DPSMate:TableLength(uArr)
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
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if uArr[lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(uArr[lineplusoffset])
			_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_Log_ScrollButton"..line.."_Name"):SetText(ability)
			_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_Log_ScrollButton"..line.."_Value"):SetText(dArr[lineplusoffset][1].." ("..strformat("%.2f", (dArr[lineplusoffset][1]*100/dTot)).."%)")
			_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_Log_ScrollButton"..line.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(strsub(ability, 1, (strfind(ability, "%(") or 0)-1) or ability))
			if len < 10 then
				_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_Log_ScrollButton"..line):SetWidth(235)
				_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_Log_ScrollButton"..line.."_Name"):SetWidth(125)
			else
				_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_Log_ScrollButton"..line):SetWidth(220)
				_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_Log_ScrollButton"..line.."_Name"):SetWidth(110)
			end
			_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_Log_ScrollButton"..line):Show()
		else
			_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_Log_ScrollButton"..line):Hide()
		end
		_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_Log_ScrollButton"..line.."_selected"):Hide()
		if dSel == lineplusoffset then
			_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_Log_ScrollButton"..line.."_selected"):Show()
		end
	end
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:SelectDetails_HealingAndAbsorbsButton(i, comp, cname)
	if not comp then comp = DPSMate_Details_HealingAndAbsorbs.LastScroll or "" end
	local pathh = ""
	local path,obj,lineplusoffset
	local uArr, dSel, d2, dArr = DetailsArr, DetailsSelected, t2, DmgArr
	local arr = DPSMateEHealing[curKey]
	if comp ~= "" and comp~=nil then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dSel = DetailsSelectedComp
		if not cname then
			cname = DetailsUserComp
		end
		d2 = t2Comp
	end
	local user, pet = DPSMateUser[cname or DetailsUser][1], ""
	if toggle then
		pathh = "DPSMate_Details_"..comp.."HealingAndAbsorbs_playerSpells"
		obj = _G(pathh.."_ScrollFrame")
		lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
		if d2[obj.id] then
			path = d2[obj.id][3][lineplusoffset]
		end
	else
		pathh = "DPSMate_Details_"..comp.."HealingAndAbsorbs_Log"
		obj = _G(pathh.."_ScrollFrame")
		lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
		if arr[user] then
			path = arr[user][tonumber(uArr[lineplusoffset])]
		end
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
	local hit, crit, hitav, critav, hitMin, hitMax, critMin, critMax, total, max = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	if dArr[lineplusoffset][2] and not toggle then -- IsAbsorb
		local abString = DPSMate:GetAbilityById(tonumber(uArr[lineplusoffset]))
		for cat, val in DPSMateAbsorbs[curKey] do 
			for ca, va in val do
				if ca == DPSMateUser[cname or DetailsUser][1] then -- Owner
					for c, v in va do -- Every Ability
						if c==tonumber(uArr[lineplusoffset]) then
							for ce, ve in v do -- Every individual shield
								local PerShieldAbsorb = 0
								for cet, vel in ve do
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
											if p>DPSMate.DB.FixedShieldAmounts[abString] then
												p = DPSMate.DB.FixedShieldAmounts[abString]
											end
											if p==5 or dmg==0 then
												p = ceil((1/totalHits)*((DPSMateUser[cname or DetailsUser][8] or 60)/60)*DPSMate.DB.FixedShieldAmounts[abString]*0.33)
											end
											PerShieldAbsorb=PerShieldAbsorb+ss*p
											
											if PerShieldAbsorb>hitMax then hitMax = PerShieldAbsorb end
											if (PerShieldAbsorb<hitMin or hitMin == 0) and PerShieldAbsorb>0 then hitMin = PerShieldAbsorb end
											hitav = DPSMate.DB:WeightedAverage(hitav, PerShieldAbsorb, hit, ss)
											hit=hit+ss
										end
									end
								end
								if ve["i"][1]==1 then
									PerShieldAbsorb=PerShieldAbsorb+ve["i"][2]
								end
							end
						end
					end
				end
			end
		end
		total, max = hit, hit
	else
		hit, crit, hitav, critav, hitMin, hitMax, critMin, critMax = path[2], path[3], path[4], path[5], path[6], path[7], path[8], path[9]
		total, max = hit+crit, DPSMate:TMax({hit, crit})
	end
	
	-- Hit
	_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount0_Amount"):SetText(hit)
	_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount0_Percent"):SetText(strformat("%.1f", 100*hit/total).."%")
	_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount0_StatusBar"):SetValue(ceil(100*hit/max))
	_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount0_StatusBar"):SetStatusBarColor(0.3,0.7,1.0,1)
	_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Average0"):SetText(ceil(hitav))
	_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Min0"):SetText(hitMin)
	_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Max0"):SetText(hitMax)
	
	-- Crit
	_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount1_Amount"):SetText(crit)
	_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount1_Percent"):SetText(strformat("%.1f", 100*crit/total).."%")
	_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount1_StatusBar"):SetValue(ceil(100*crit/max))
	_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Amount1_StatusBar"):SetStatusBarColor(1.0,0.7,0.3,1)
	_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Average1"):SetText(ceil(critav))
	_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Min1"):SetText(critMin)
	_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs_Max1"):SetText(critMax)
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:Player_Update(comp)
	if not comp then comp = DPSMate_Details_HealingAndAbsorbs.LastScroll or "" end
	local line, lineplusoffset
	local path = "DPSMate_Details_"..comp.."HealingAndAbsorbs_player"
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
			local r,g,b,img = DPSMate:GetClassColor(DPSMateUser[user][2])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(user)
			_G(path.."_ScrollButton"..line.."_Name"):SetTextColor(r,g,b)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(d2[lineplusoffset][1].." ("..strformat("%.2f", (d2[lineplusoffset][1]*100/d3)).."%)")
			_G(path.."_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\class\\"..img)
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

function DPSMate.Modules.DetailsHealingAndAbsorbs:PlayerSpells_Update(i, comp)
	if not comp then comp = DPSMate_Details_HealingAndAbsorbs.LastScroll or "" end
	local line, lineplusoffset
	local path = "DPSMate_Details_"..comp.."HealingAndAbsorbs_playerSpells"
	local obj = _G(path.."_ScrollFrame")
	obj.id = (i + FauxScrollFrame_GetOffset(_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_player_ScrollFrame"))) or obj.id
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
			local ability = DPSMate:GetAbilityById(d2[obj.id][2][lineplusoffset]) or "Sinister Strike"
			_G(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(d2[obj.id][3][lineplusoffset][1].." ("..strformat("%.2f", (d2[obj.id][3][lineplusoffset][1]*100/d2[obj.id][1])).."%)")
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
		if d4 == lineplusoffset then
			_G(path.."_ScrollButton"..line.."_selected"):Show()
		end
	end
	if comp ~= "" and comp~=nil then
		PSelected2 = obj.id
	else
		PSelected = obj.id
	end
	for p=1, 8 do
		_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_player_ScrollButton"..p.."_selected"):Hide()
	end
	_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_player_ScrollButton"..i.."_selected"):Show()
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

function DPSMate.Modules.DetailsHealingAndAbsorbs:UpdatePie(gg, cname)
	local dArr, dTot, uArr = DmgArr, DetailsTotal, DetailsArr
	if cname then
		dArr = DmgArrComp
		uArr = DetailsArrComp
		dTot = DetailsTotalComp
	end
	gg:ResetPie()
	for cat, val in dArr do
		gg:AddPie(val[1]*100/dTot, 0, DPSMate:GetAbilityById(uArr[cat]))
	end
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:UpdateLineGraph(gg, comp, cname)
	if not comp then comp = DPSMate_Details_HealingAndAbsorbs.LastScroll or "" end
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
		tinsert(Data1, {val[1],val[2], self:CheckProcs(_G("DPSMate_Details_"..comp.."HealingAndAbsorbs").proc, val[1]+min+1, cname)})
	end
	local colorT = {{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}
	if cname then
		colorT = {{0.2,0.8,0.2,0.8}, {0.5,0.8,0.9,0.8}}
	end

	gg:AddDataSeries(Data1,colorT, self:AddProcPoints(_G("DPSMate_Details_"..comp.."HealingAndAbsorbs").proc, Data1, cname))
	gg:Show()
	toggle2=false
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:UpdateStackedGraph(gg, comp, cname)
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
	if toggle3 then
		if db2[d1[d4]] then
			if db2[d1[d4]][DPSMateUser[cname or DetailsUser][1]] then
				for cat, val in db2[d1[d4]][DPSMateUser[cname or DetailsUser][1]] do
					if cat~="i" and val["i"] then
						local temp = {}
						for c, v in val["i"] do
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
								elseif c<=temp[i][1] then
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
								tinsert(b, i, val[1])
								tinsert(label, i, DPSMate:GetAbilityById(cat))
								tinsert(Data1, i, temp)
								break
							elseif b[i]>=val[1] then
								tinsert(b, i, val[1])
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
		-- Add absorbs points
		local temp = {}
		if DPSMateAbsorbs[curKey][d1[d4]] then
			if DPSMateAbsorbs[curKey][d1[d4]][DPSMateUser[cname or DetailsUser][1]] then
				for ca, va in DPSMateAbsorbs[curKey][d1[d4]][DPSMateUser[cname or DetailsUser][1]]["i"] do
					local i, dmg = 1, 5
					if DPSMateDamageTaken[1][d1[d4]] then
						if DPSMateDamageTaken[1][d1[d4]][va[2]] then
							if DPSMateDamageTaken[1][d1[d4]][va[2]][va[3]] then
								dmg = DPSMateDamageTaken[1][d1[d4]][va[2]][va[3]][14]
								if dmg>DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])] then
									dmg = DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])]
								end
							end
						end
					end
					if dmg==5 or dmg==0 then
						dmg = ceil((1/15)*((DPSMateUser[cname or DetailsUser][8] or 60)/60)*DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])]*0.33)
					end
					if va[4] then
						dmg = dmg + va[4]
					end
					if dmg>0 then
						if not temp[va[5]] then
							temp[va[5]] = {}
						end
						while true do
							if (not temp[va[5]][i]) then
								tinsert(temp[va[5]], i, {va[1], dmg})
								break
							elseif va[1]<=temp[va[5]][i][1] then
								tinsert(temp[va[5]], i, {va[1], dmg})
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
		gg:SetGridSpacing((maxX-(min or 0))/7,maxY/7)	
	else
		if DPSMateEHealing[curKey][DPSMateUser[cname or DetailsUser][1]] then
			for cat, val in DPSMateEHealing[curKey][DPSMateUser[cname or DetailsUser][1]] do
				if cat~="i" and val["i"] then
					local temp = {}
					for c, v in val["i"] do
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
							elseif c<=temp[i][1] then
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
							tinsert(b, i, val[1])
							tinsert(label, i, DPSMate:GetAbilityById(cat))
							tinsert(Data1, i, temp)
							break
						elseif b[i]>=val[1] then
							tinsert(b, i, val[1])
							tinsert(label, i, DPSMate:GetAbilityById(cat))
							tinsert(Data1, i, temp)
							break
						end
						i = i + 1
					end
				end
			end
		end
		-- Add absorbs points
		local temp = {}
		for cat, val in DPSMateAbsorbs[curKey] do
			if val[DPSMateUser[cname or DetailsUser][1]] then
				for ca, va in val[DPSMateUser[cname or DetailsUser][1]]["i"] do
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
						dmg = ceil((1/15)*((DPSMateUser[cname or DetailsUser][8] or 60)/60)*DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])]*0.33)
					end
					if va[4] then
						dmg = dmg + va[4]
					end
					if dmg>0 then
						if not temp[va[5]] then
							temp[va[5]] = {}
						end
						while true do
							if (not temp[va[5]][i]) then
								tinsert(temp[va[5]], i, {va[1], dmg})
								break
							elseif va[1]<=temp[va[5]][i][1] then
								tinsert(temp[va[5]], i, {va[1], dmg})
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
		
		gg:ResetData()
		gg:SetGridSpacing(maxX/7,maxY/7)
	end
	
	gg:AddDataSeries(Data1,{1.0,0.0,0.0,0.8}, {}, label)
	gg:Show()
	toggle2 = true
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:CreateGraphTable(comp)
	local lines = {}
	comp = comp or ""
	for i=1, 8 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs"), 10, 270-i*30, 370, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[9] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs"), 57, 260, 57, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs"), 192, 260, 192, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs"), 252, 260, 252, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
	
	lines[12] = DPSMate.Options.graph:DrawLine(_G("DPSMate_Details_"..comp.."HealingAndAbsorbs_LogDetails_HealingAndAbsorbs"), 312, 260, 312, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:ProcsDropDown()
	local arr = DPSMate.Modules.DetailsHealingAndAbsorbs:GetAuraGainedArr(curKey)
	DPSMate_Details_HealingAndAbsorbs.proc = "None"
	
    local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_Details_HealingAndAbsorbs_DiagramLegend_Procs, this.value)
		DPSMate_Details_HealingAndAbsorbs.proc = this.value
		if not toggle2 then
			DPSMate.Modules.DetailsHealingAndAbsorbs:UpdateLineGraph(g2, "")
		end
		if DetailsUserComp then
			DPSMate.Modules.DetailsHealingAndAbsorbs:UpdateSumGraph()
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
			if DPSMate:TContains(DPSMate.Parser.procs, ability) then
				UIDropDownMenu_AddButton{
					text = ability,
					value = cat,
					func = on_click,
				}
			end
		end
	end
	
	if DPSMate_Details_HealingAndAbsorbs.LastUser~=DetailsUser then
		UIDropDownMenu_SetSelectedValue(DPSMate_Details_HealingAndAbsorbs_DiagramLegend_Procs, "None")
	end
	DPSMate_Details_HealingAndAbsorbs.LastUser = DetailsUser
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:ProcsDropDown_CompareHealingAndAbsorbs()
	local arr = DPSMate.Modules.DetailsHealingAndAbsorbs:GetAuraGainedArr(curKey)
	DPSMate_Details_CompareHealingAndAbsorbs.proc = "None"
	
    local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_Details_CompareHealingAndAbsorbs_DiagramLegend_Procs, this.value)
		DPSMate_Details_CompareHealingAndAbsorbs.proc = this.value
		if not toggle2 then
			DPSMate.Modules.DetailsHealingAndAbsorbs:UpdateLineGraph(g5, "Compare", DetailsUserComp)
		end
		if DetailsUserComp then
			DPSMate.Modules.DetailsHealingAndAbsorbs:UpdateSumGraph()
		end
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
			if DPSMate:TContains(DPSMate.Parser.procs, ability) then
				UIDropDownMenu_AddButton{
					text = ability,
					value = cat,
					func = on_click,
				}
			end
		end
	end
	
	if DPSMate_Details_CompareHealingAndAbsorbs.LastUser~=DetailsUserComp then
		UIDropDownMenu_SetSelectedValue(DPSMate_Details_CompareHealingAndAbsorbs_DiagramLegend_Procs, "None")
	end
	DPSMate_Details_CompareHealingAndAbsorbs.LastUser = DetailsUserComp
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:SortLineTable(arr, b, cname)
	local newArr = {}
	if b then
		if DPSMateAbsorbs[curKey][b] then
			if DPSMateAbsorbs[curKey][b][DPSMateUser[cname or DetailsUser][1]] then
				for ca, va in DPSMateAbsorbs[curKey][b][DPSMateUser[cname or DetailsUser][1]]["i"] do
					local i, dmg = 1, 5
					if DPSMateDamageTaken[1][b] then
						if DPSMateDamageTaken[1][b][va[2]] then
							if DPSMateDamageTaken[1][b][va[2]][va[3]] then
								dmg = DPSMateDamageTaken[1][b][va[2]][va[3]][14]
								if dmg>DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])] then
									dmg = DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])]
								end
							end
						end
					end
					if dmg==5 or dmg==0 then
						dmg = ceil((1/15)*((DPSMateUser[cname or DetailsUser][8] or 60)/60)*DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])]*0.33)
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
		if arr[b] then
			if arr[b][DPSMateUser[cname or DetailsUser][1]] then
				for cat, val in arr[b][DPSMateUser[cname or DetailsUser][1]] do
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
		for cat, val in DPSMateAbsorbs[curKey] do
			if val[DPSMateUser[cname or DetailsUser][1]] then
				for ca, va in val[DPSMateUser[cname or DetailsUser][1]]["i"] do
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
						dmg = ceil((1/15)*((DPSMateUser[cname or DetailsUser][8] or 60)/60)*DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])]*0.33)
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
		if DPSMateEHealing[curKey][DPSMateUser[cname or DetailsUser][1]] then
			for cat, val in DPSMateEHealing[curKey][DPSMateUser[cname or DetailsUser][1]] do
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
	return newArr
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:GetSummarizedTable(arr, b, cname)
	return DPSMate.Sync:GetSummarizedTable(self:SortLineTable(arr, b, cname))
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:GetAuraGainedArr(k)
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

function DPSMate.Modules.DetailsHealingAndAbsorbs:CheckProcs(name, val, cname)
	local arr = self:GetAuraGainedArr(curKey)
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

function DPSMate.Modules.DetailsHealingAndAbsorbs:AddProcPoints(name, dat, cname)
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

function DPSMate.Modules.DetailsHealingAndAbsorbs:ToggleMode(bool)
	if bool then
		if toggle2 then
			self:UpdateLineGraph(g2,"")
			if DetailsUserComp then
				self:UpdateLineGraph(g5,"Compare", DetailsUserComp)
			end
		else
			self:UpdateStackedGraph(g3)
			if DetailsUserComp then
				self:UpdateStackedGraph(g6,"Compare", DetailsUserComp)
			end
		end
	else
		if toggle then
			toggle = false
			self:ScrollFrame_Update("")
			self:SelectDetails_HealingAndAbsorbsButton(1,"")
			DPSMate_Details_HealingAndAbsorbs_playerSpells:Hide()
			DPSMate_Details_HealingAndAbsorbs_player:Hide()
			DPSMate_Details_HealingAndAbsorbs_Diagram:Show()
			DPSMate_Details_HealingAndAbsorbs_Log:Show()
			
			if DetailsUserComp then
				self:ScrollFrame_Update("Compare")
				self:SelectDetails_HealingAndAbsorbsButton(1, "Compare")
				DPSMate_Details_CompareHealingAndAbsorbs_playerSpells:Hide()
				DPSMate_Details_CompareHealingAndAbsorbs_player:Hide()
				DPSMate_Details_CompareHealingAndAbsorbs_Diagram:Show()
				DPSMate_Details_CompareHealingAndAbsorbs_Log:Show()
			end
		else
			toggle = true
			self:Player_Update("")
			self:PlayerSpells_Update(1,"")
			self:SelectDetails_HealingAndAbsorbsButton(1,"")
			DPSMate_Details_HealingAndAbsorbs_playerSpells:Show()
			DPSMate_Details_HealingAndAbsorbs_player:Show()
			DPSMate_Details_HealingAndAbsorbs_Diagram:Hide()
			DPSMate_Details_HealingAndAbsorbs_Log:Hide()
			
			if DetailsUserComp then
				self:Player_Update("Compare")
				self:PlayerSpells_Update(1, "Compare")
				self:SelectDetails_HealingAndAbsorbsButton(1, "Compare")
				DPSMate_Details_CompareHealingAndAbsorbs_playerSpells:Show()
				DPSMate_Details_CompareHealingAndAbsorbs_player:Show()
				DPSMate_Details_CompareHealingAndAbsorbs_Diagram:Hide()
				DPSMate_Details_CompareHealingAndAbsorbs_Log:Hide()
			end
		end
	end
end

function DPSMate.Modules.DetailsHealingAndAbsorbs:ToggleIndividual()
	if toggle3 then
		toggle3 = false
	else
		toggle3 = true
	end
	if toggle2 then
		self:UpdateStackedGraph(g3)
		if DetailsUserComp then 
			self:UpdateStackedGraph(g6,"Compare", DetailsUserComp)
		end
	else
		self:UpdateLineGraph(g2,"")
		if DetailsUserComp then
			self:UpdateLineGraph(g5,"Compare", DetailsUserComp)
		end
	end
	if DetailsUserComp then
		self:UpdateSumGraph()
	end
end