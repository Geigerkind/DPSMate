-- Global Variables
DPSMate.Modules.DetailsEHealingTaken = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailsUser, DetailsSelected  = {}, 0, {}, "", 1
local PieChart = true
local g, g2
local curKey = 1
local db, cbt = {}, 0
local _G = getglobal
local tinsert = table.insert

function DPSMate.Modules.DetailsEHealingTaken:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	if (PieChart) then
		g2=DPSMate.Options.graph:CreateGraphLine("LineGraph",DPSMate_Details_EHealingTaken_DiagramLine,"CENTER","CENTER",0,0,850,230)
		PieChart = false
	end
	DetailsUser = obj.user
	DPSMate_Details_EHealingTaken_Title:SetText("Effective healing taken by "..obj.user)
	DPSMate_Details_EHealingTaken:Show()
	self:ScrollFrame_Update()
	self:SelectCreatureButton(1)
	self:SelectDetailsButton(1,1)
	self:UpdateLineGraph()
end

function DPSMate.Modules.DetailsEHealingTaken:ScrollFrame_Update()
	local line, lineplusoffset
	local path = "DPSMate_Details_EHealingTaken_LogCreature"
	local obj = _G(path.."_ScrollFrame")
	DetailsArr, DetailsTotal, DmgArr = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[DetailsUser], curKey)
	local len = DPSMate:TableLength(DetailsArr)
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			local user = DPSMate:GetUserById(DetailsArr[lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(user)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[lineplusoffset][1].." ("..string.format("%.2f", (DmgArr[lineplusoffset][1]*100/DetailsTotal)).."%)")
			_G(path.."_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
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

function DPSMate.Modules.DetailsEHealingTaken:SelectCreatureButton(i)
	local line, lineplusoffset
	local path = "DPSMate_Details_EHealingTaken_Log"
	local obj = _G(path.."_ScrollFrame")
	if i then obj.index = i else i=obj.index end
	local pet, len = "", DPSMate:TableLength(DmgArr[i][2])
	FauxScrollFrame_Update(obj,len,10,24)
	DetailsSelected = i
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DmgArr[i][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DmgArr[i][2][lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[i][3][lineplusoffset].." ("..string.format("%.2f", (DmgArr[i][3][lineplusoffset]*100/DmgArr[i][1])).."%)")
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
		_G("DPSMate_Details_EHealingTaken_LogCreature_ScrollButton"..p.."_selected"):Hide()
	end
	_G("DPSMate_Details_EHealingTaken_LogCreature_ScrollButton"..i.."_selected"):Show()
	DPSMate.Modules.DetailsEHealingTaken:SelectDetailsButton(i,1)
end

function DPSMate.Modules.DetailsEHealingTaken:SelectDetailsButton(p,i)
	local obj = _G("DPSMate_Details_EHealingTaken_Log_ScrollFrame")
	local lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
	
	for p=1, 10 do
		_G("DPSMate_Details_EHealingTaken_Log_ScrollButton"..p.."_selected"):Hide()
	end
	-- Performance?
	local ability = tonumber(DmgArr[p][2][lineplusoffset])
	local creature = tonumber(DetailsArr[p])
	_G("DPSMate_Details_EHealingTaken_Log_ScrollButton"..i.."_selected"):Show()
	
	local path = db[DPSMateUser[DetailsUser][1]][creature][ability]
	local hit, crit, hitav, critav, hitMin, hitMax, critMin, critMax = path[2], path[3], path[4], path[5], path[6], path[7], path[8], path[9]
	local total, max = hit+crit, DPSMate:TMax({hit, crit})
	
	-- Hit
	_G("DPSMate_Details_EHealingTaken_LogDetails_Amount1_Amount"):SetText(hit)
	_G("DPSMate_Details_EHealingTaken_LogDetails_Amount1_Percent"):SetText(ceil(100*hit/total).."%")
	_G("DPSMate_Details_EHealingTaken_LogDetails_Amount1_StatusBar"):SetValue(ceil(100*hit/max))
	_G("DPSMate_Details_EHealingTaken_LogDetails_Amount1_StatusBar"):SetStatusBarColor(1.0,0.7,0.3,1)
	_G("DPSMate_Details_EHealingTaken_LogDetails_Average1"):SetText(ceil(hitav))
	_G("DPSMate_Details_EHealingTaken_LogDetails_Min1"):SetText(hitMin)
	_G("DPSMate_Details_EHealingTaken_LogDetails_Max1"):SetText(hitMax)
	
	-- Crit
	_G("DPSMate_Details_EHealingTaken_LogDetails_Amount2_Amount"):SetText(crit)
	_G("DPSMate_Details_EHealingTaken_LogDetails_Amount2_Percent"):SetText(ceil(100*crit/total).."%")
	_G("DPSMate_Details_EHealingTaken_LogDetails_Amount2_StatusBar"):SetValue(ceil(100*crit/max))
	_G("DPSMate_Details_EHealingTaken_LogDetails_Amount2_StatusBar"):SetStatusBarColor(0.9,0.0,0.0,1)
	_G("DPSMate_Details_EHealingTaken_LogDetails_Average2"):SetText(ceil(critav))
	_G("DPSMate_Details_EHealingTaken_LogDetails_Min2"):SetText(critMin)
	_G("DPSMate_Details_EHealingTaken_LogDetails_Max2"):SetText(critMax)
end

function DPSMate.Modules.DetailsEHealingTaken:UpdateLineGraph()
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
	for cat, val in pairs(sumTable) do
		tinsert(Data1, {val[1],val[2], {}})
	end

	g2:AddDataSeries(Data1,{{1.0,0.0,0.0,0.8}, {1.0,0.0,0.0,0.8}}, {})
end

function DPSMate.Modules.DetailsEHealingTaken:CreateGraphTable()
	local lines = {}
	for i=1, 8 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(DPSMate_Details_EHealingTaken_Log, 252, 270-i*30, 617, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[9] = DPSMate.Options.graph:DrawLine(DPSMate_Details_EHealingTaken_Log, 302, 260, 302, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(DPSMate_Details_EHealingTaken_Log, 437, 260, 437, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(DPSMate_Details_EHealingTaken_Log, 497, 260, 497, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
	
	lines[12] = DPSMate.Options.graph:DrawLine(DPSMate_Details_EHealingTaken_Log, 557, 260, 557, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
end

function DPSMate.Modules.DetailsEHealingTaken:GetSummarizedTable(arr)
	return DPSMate.Sync:GetSummarizedTable(arr[DPSMateUser[DetailsUser][1]]["i"][2])
end

