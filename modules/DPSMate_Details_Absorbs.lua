-- Global Variables
DPSMate.Modules.DetailsAbsorbs = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailsUser, DetailsSelected  = {}, 0, {}, "", 1
local PieChart = true
local g, g2
local curKey = 1
local db, cbt = {}, 0
local _G = getglobal
local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.DetailsAbsorbs:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	if (PieChart) then
		g2=DPSMate.Options.graph:CreateGraphLine("LineGraph",DPSMate_Details_Absorbs_DiagramLine,"CENTER","CENTER",0,0,960,230)
		PieChart = false
	end
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
	obj.index = i
	local len = DPSMate:TableLength(DmgArr[i][2])
	FauxScrollFrame_Update(obj,len,10,24)
	DetailsSelected = i
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DmgArr[i][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DmgArr[i][2][lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[i][3][lineplusoffset][1].." ("..strformat("%.2f", (DmgArr[i][3][lineplusoffset][1]*100/DetailsTotal)).."%)")
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
		_G("DPSMate_Details_Absorbs_LogCreature_ScrollButton"..p.."_selected"):Hide()
	end
	_G("DPSMate_Details_Absorbs_LogCreature_ScrollButton"..i.."_selected"):Show()
end

function DPSMate.Modules.DetailsAbsorbs:SelectCauseButton(i,p)
	local line, lineplusoffset
	local path = "DPSMate_Details_Absorbs_LogTwo"
	local obj = _G(path.."_ScrollFrame")
	obj.index = i
	obj.indextwo = p
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
		_G(path.."_ScrollButton1_selected"):Show()
	end
	for p=1, 10 do
		_G("DPSMate_Details_Absorbs_Log_ScrollButton"..p.."_selected"):Hide()
	end
	_G("DPSMate_Details_Absorbs_Log_ScrollButton"..p.."_selected"):Show()
end

function DPSMate.Modules.DetailsAbsorbs:SelectCauseABButton(i,p,q)
	local line, lineplusoffset
	local path = "DPSMate_Details_Absorbs_LogThree"
	local obj = _G(path.."_ScrollFrame")
	obj.index = i
	obj.indextwo = p
	obj.indexthree = q
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
	for p=1, 10 do
		_G("DPSMate_Details_Absorbs_LogTwo_ScrollButton"..p.."_selected"):Hide()
	end
	_G("DPSMate_Details_Absorbs_LogTwo_ScrollButton"..q.."_selected"):Show()
end

function DPSMate.Modules.DetailsAbsorbs:UpdateLineGraph()
	local sumTable = self:GetSummarizedTable(db)
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
end

function DPSMate.Modules.DetailsAbsorbs:SortLineTable(arr)
	local newArr = {}
	for cat, val in pairs(arr) do
		if val[DPSMateUser[DetailsUser][1]] then
			for ca, va in pairs(val[DPSMateUser[DetailsUser][1]]["i"]) do
				local i, dmg = 1, 5
				if va[4] then
					dmg = va[4]
				end
				if DPSMateDamageTaken[1][DPSMateUser[DetailsUser][1]] then
					if DPSMateDamageTaken[1][DPSMateUser[DetailsUser][1]][va[2]] then
						if DPSMateDamageTaken[1][DPSMateUser[DetailsUser][1]][va[2]][va[3]] then
							dmg = DPSMateDamageTaken[1][DPSMateUser[DetailsUser][1]][va[2]][va[3]][14]
						end
					end
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

function DPSMate.Modules.DetailsAbsorbs:GetSummarizedTable(arr)
	return DPSMate.Sync:GetSummarizedTable(DPSMate.Modules.DetailsAbsorbs:SortLineTable(arr))
end

