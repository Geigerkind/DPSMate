-- Global Variables
DPSMate.Modules.DetailsAbsorbs = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailsUser, DetailsSelected, DetailsSelectedTwo, DetailsSelectedThree  = {}, 0, {}, "", 1, 1, 1
local PieChart = true
local g3, g2
local curKey = 1
local db, cbt = {}, 0
local _G = getglobal
local tinsert = table.insert
local strformat = string.format
local toggle2, toggle3 = false, false

function DPSMate.Modules.DetailsAbsorbs:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	if (PieChart) then
		g2=DPSMate.Options.graph:CreateGraphLine("AbsorbLineGraph",DPSMate_Details_Absorbs_DiagramLine,"CENTER","CENTER",0,0,960,230)
		g3=DPSMate.Options.graph:CreateStackedGraph("AbsorbStackedGraph",DPSMate_Details_Absorbs_DiagramLine,"CENTER","CENTER",0,0,960,230)
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
	DPSMate_Details_Absorbs_Title:SetText(DPSMate.L["absorbsby"]..obj.user)
	DetailsArr, DetailsTotal, DmgArr = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[DetailsUser], curKey)
	DPSMate_Details_Absorbs:Show()
	self:ScrollFrame_Update()
	self:SelectCreatureButton(1)
	self:SelectCauseButton(1,1)
	self:SelectCauseABButton(1,1,1)
	self:UpdateLineGraph()
end

function DPSMate.Modules.DetailsAbsorbs:ScrollFrame_Update()
	local line, lineplusoffset
	local path = "DPSMate_Details_Absorbs_LogCreature"
	local obj = _G(path.."_ScrollFrame")
	local len = DPSMate:TableLength(DetailsArr)
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			local user = DPSMate:GetUserById(DetailsArr[lineplusoffset])
			local r,g,b,img = DPSMate:GetClassColor(DPSMateUser[user][2])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(user)
			_G(path.."_ScrollButton"..line.."_Name"):SetTextColor(r,g,b)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[lineplusoffset][1].." ("..strformat("%.2f", (DmgArr[lineplusoffset][1]*100/DetailsTotal)).."%)")
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
		if DetailsSelected == lineplusoffset then
			_G(path.."_ScrollButton"..line.."_selected"):Show()
		end
	end
end

function DPSMate.Modules.DetailsAbsorbs:SelectCreatureButton(i)
	local line, lineplusoffset
	local path = "DPSMate_Details_Absorbs_Log"
	local obj = _G(path.."_ScrollFrame")
	if i then
		obj.index = i + FauxScrollFrame_GetOffset(_G("DPSMate_Details_Absorbs_LogCreature_ScrollFrame"))
	end
	local len = DPSMate:TableLength(DmgArr[obj.index][2])
	FauxScrollFrame_Update(obj,len,10,24)
	DetailsSelected = obj.index
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DmgArr[obj.index][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DmgArr[obj.index][2][lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[obj.index][3][lineplusoffset][1].." ("..strformat("%.2f", (DmgArr[obj.index][3][lineplusoffset][1]*100/DetailsTotal)).."%)")
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
		if DetailsSelectedTwo == lineplusoffset then
			_G(path.."_ScrollButton"..line.."_selected"):Show()
		end
	end
	DPSMate.Modules.DetailsAbsorbs:SelectCauseButton(obj.index,1)
	for p=1, 10 do
		_G("DPSMate_Details_Absorbs_LogCreature_ScrollButton"..p.."_selected"):Hide()
	end
	_G("DPSMate_Details_Absorbs_LogCreature_ScrollButton"..(obj.index-FauxScrollFrame_GetOffset(_G("DPSMate_Details_Absorbs_LogCreature_ScrollFrame"))).."_selected"):Show()
	if toggle3 then
		if toggle2 then
			DPSMate.Modules.DetailsAbsorbs:UpdateStackedGraph(g3)
		else
			DPSMate.Modules.DetailsAbsorbs:UpdateLineGraph(g2)
		end
	end
end

function DPSMate.Modules.DetailsAbsorbs:SelectCauseButton(i,p)
	local line, lineplusoffset
	local path = "DPSMate_Details_Absorbs_LogTwo"
	local obj = _G(path.."_ScrollFrame")
	local obj2 = _G("DPSMate_Details_Absorbs_Log_ScrollFrame")
	if p then
		obj.index = p
	end
	i = obj2.index or i
	p = obj.index or p
	DetailsSelectedTwo = obj.index
	local len = DPSMate:TableLength(DmgArr[i][3][p][2])
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DmgArr[i][3][p][2][lineplusoffset] ~= nil then
			local user = DPSMate:GetUserById(DmgArr[i][3][p][2][lineplusoffset])
			local r,g,b,img = DPSMate:GetClassColor(DPSMateUser[user][2])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(user)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[i][3][p][3][lineplusoffset][1].." ("..strformat("%.2f", (DmgArr[i][3][p][3][lineplusoffset][1]*100/DmgArr[i][3][p][1])).."%)")
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
		if DetailsSelectedThree == lineplusoffset then
			_G(path.."_ScrollButton"..line.."_selected"):Show()
		end
	end
	DPSMate.Modules.DetailsAbsorbs:SelectCauseABButton(i,p,1)
	for qq=1, 10 do
		_G("DPSMate_Details_Absorbs_Log_ScrollButton"..qq.."_selected"):Hide()
	end
	if (p-FauxScrollFrame_GetOffset(obj2))>0 then
		_G("DPSMate_Details_Absorbs_Log_ScrollButton"..(p-FauxScrollFrame_GetOffset(obj2)).."_selected"):Show()
	end
end

function DPSMate.Modules.DetailsAbsorbs:SelectCauseABButton(i,p,q)
	local line, lineplusoffset
	local path = "DPSMate_Details_Absorbs_LogThree"
	local obj = _G(path.."_ScrollFrame")
	local obj2 = _G("DPSMate_Details_Absorbs_Log_ScrollFrame")
	local obj3 = _G("DPSMate_Details_Absorbs_LogTwo_ScrollFrame")
	local obj4 = _G("DPSMate_Details_Absorbs_LogCreature_ScrollFrame")
	if q then
		obj.index = q
	end
	q = obj.index or q
	p = obj3.index or p
	i = obj2.index or i
	DetailsSelectedThree = obj.index
	local len = DPSMate:TableLength(DmgArr[i][3][p][3][q][2])
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DmgArr[i][3][p][3][q][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DmgArr[i][3][p][3][q][2][lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[i][3][p][3][q][3][lineplusoffset].." ("..strformat("%.2f", (DmgArr[i][3][p][3][q][3][lineplusoffset]*100/DmgArr[i][3][p][3][q][1])).."%)")
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
		_G("DPSMate_Details_Absorbs_LogTwo_ScrollButton"..qq.."_selected"):Hide()
	end
	if (q-FauxScrollFrame_GetOffset(obj3))>0 then
		_G("DPSMate_Details_Absorbs_LogTwo_ScrollButton"..(q-FauxScrollFrame_GetOffset(obj3)).."_selected"):Show()
	end
end

function DPSMate.Modules.DetailsAbsorbs:UpdateLineGraph()
	if g3 then
		g3:Hide()
	end

	local sumTable
	if toggle3 then
		if comp ~= "" and comp~=nil then
			sumTable = self:GetSummarizedTable(db2, t1Comp[PSelected2], cname)
		else
			sumTable = self:GetSummarizedTable(db2, DetailsArr[DetailsSelected])
		end
	else
		sumTable = self:GetSummarizedTable(db, nil, cname)
	end
	local max = DPSMate:GetMaxValue(sumTable, 2)
	local time = DPSMate:GetMaxValue(sumTable, 1)
	
	g2:ResetData()
	g2:SetXAxis(0,time)
	g2:SetYAxis(0,max+200)
	g2:SetGridSpacing(time/10,max/7)
	g2:SetGridColor({0.5,0.5,0.5,0.5})
	g2:SetAxisDrawing(true,true)
	g2:SetAxisColor({1.0,1.0,1.0,1.0})
	g2:SetAutoScale(true)
	g2:SetYLabels(true, false)
	g2:SetXLabels(true)

	local Data1={{0,0}}
	for cat, val in sumTable do
		tinsert(Data1, {val[1],val[2], {}})
	end

	g2:AddDataSeries(Data1,{{1.0,0.0,0.0,0.8}, {1.0,0.0,0.0,0.8}}, {})
	g2:Show()
	toggle2=false
end

function DPSMate.Modules.DetailsAbsorbs:UpdateStackedGraph(gg, comp, cname)
	if g2 then
		g2:Hide()
	end
	if g5 then
		g5:Hide()
	end
	
	local Data1 = {}
	local label = {}
	local b = {}
	local p = {}
	local maxY = 0
	local maxX = 0
	if toggle3 then
		local temp = {}
		if db[DetailsArr[DetailsSelected]] then
			if db[DetailsArr[DetailsSelected]][DPSMateUser[cname or DetailsUser][1]] then
				for ca, va in db[DetailsArr[DetailsSelected]][DPSMateUser[cname or DetailsUser][1]]["i"] do
					local i, dmg = 1, 5
					if DPSMateDamageTaken[1][DetailsArr[DetailsSelected]] then
						if DPSMateDamageTaken[1][DetailsArr[DetailsSelected]][va[2]] then
							if DPSMateDamageTaken[1][DetailsArr[DetailsSelected]][va[2]][va[3]] then
								dmg = DPSMateDamageTaken[1][DetailsArr[DetailsSelected]][va[2]][va[3]][14]
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
		for cat, val in DPSMateAbsorbs[curKey] do
			if val[DPSMateUser[cname or DetailsUser][1]] then
				for ca, va in val[DPSMateUser[cname or DetailsUser][1]]["i"] do
					local i, dmg = 1, 5
					if DPSMateDamageTaken[1][cat] then
						if DPSMateDamageTaken[1][cat][va[2]] then
							if DPSMateDamageTaken[1][cat][va[2]][va[3]] then
								dmg = DPSMateDamageTaken[1][cat][va[2]][va[3]][14]
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
		
		gg:ResetData()
	end
	
	gg:AddDataSeries(Data1,{1.0,0.0,0.0,0.8}, {}, label)
	gg:Show()
	toggle2 = true
end


function DPSMate.Modules.DetailsAbsorbs:SortLineTable(arr, b, cname)
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
	else
		for cat, val in pairs(arr) do
			if val[DPSMateUser[DetailsUser][1]] then
				for ca, va in pairs(val[DPSMateUser[DetailsUser][1]]["i"]) do
					local i, dmg = 1, 5
					if DPSMateDamageTaken[1][cat] then
						if DPSMateDamageTaken[1][cat][va[2]] then
							if DPSMateDamageTaken[1][cat][va[2]][va[3]] then
								dmg = DPSMateDamageTaken[1][cat][va[2]][va[3]][14]
							end
						end
					end
					if dmg==5 or dmg==0 then
						dmg = ceil((1/15)*((DPSMateUser[DetailsUser][8] or 60)/60)*DPSMate.DB.FixedShieldAmounts[DPSMate:GetAbilityById(va[5])]*0.33)
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
	end
	return newArr
end

function DPSMate.Modules.DetailsAbsorbs:GetSummarizedTable(arr, b, cname)
	return DPSMate.Sync:GetSummarizedTable(DPSMate.Modules.DetailsAbsorbs:SortLineTable(arr, b, cname))
end

function DPSMate.Modules.DetailsAbsorbs:ToggleMode()
	if toggle2 then
		self:UpdateLineGraph(g2)
		toggle2 = false
	else
		self:UpdateStackedGraph(g3)
		toggle2 = true
	end
end

function DPSMate.Modules.DetailsAbsorbs:ToggleIndividual()
	if toggle3 then
		toggle3=false
	else
		toggle3=true
	end
	if toggle2 then
		self:UpdateStackedGraph(g3)
	else
		self:UpdateLineGraph(g2)
	end
end
