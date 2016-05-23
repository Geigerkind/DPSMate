-- Global Variables
DPSMate.Modules.DetailsHealing = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailsUser, DetailsSelected  = {}, 0, {}, "", 1
local PieChart = true
local g, g2
local curKey = 1
local db, cbt = {}, 0
local tinsert = table.insert
local _G = getglobal

function DPSMate.Modules.DetailsHealing:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DPSMate_Details_Healing.proc = "None"
	UIDropDownMenu_SetSelectedValue(DPSMate_Details_Healing_DiagramLegend_Procs, "None")
	if (PieChart) then
		g=DPSMate.Options.graph:CreateGraphPieChart("PieChart", DPSMate_Details_Healing_Diagram, "CENTER", "CENTER", 0, 0, 200, 200)
		g2=DPSMate.Options.graph:CreateGraphLine("LineGraph",DPSMate_Details_Healing_DiagramLine,"CENTER","CENTER",0,0,850,230)
		PieChart = false
	end
	DetailsUser = obj.user
	DPSMate_Details_Healing_Title:SetText("Healing done by "..obj.user)
	DPSMate_Details_Healing:Show()
	UIDropDownMenu_Initialize(DPSMate_Details_Healing_DiagramLegend_Procs, DPSMate.Modules.DetailsHealing.ProcsDropDown)
	self:ScrollFrame_Update()
	self:SelectDetails_HealingButton(1)
	self:UpdatePie()
	self:UpdateLineGraph()
end

function DPSMate.Modules.DetailsHealing:ScrollFrame_Update()
	local line, lineplusoffset
	local path = "DPSMate_Details_Healing_Log"
	local obj = _G(path.."_ScrollFrame")
	local path = path..""
	DetailsArr, DetailsTotal, DmgArr = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[DetailsUser], curKey)
	local len = DPSMate:TableLength(DetailsArr)
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DetailsArr[lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[lineplusoffset].." ("..string.format("%.2f", (DmgArr[lineplusoffset]*100/DetailsTotal)).."%)")
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
end

function DPSMate.Modules.DetailsHealing:SelectDetails_HealingButton(i)
	local pathh = "DPSMate_Details_Healing_Log"
	local obj = _G(pathh.."_ScrollFrame")
	local lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
	local user = DPSMateUser[DetailsUser][1]
	
	DetailsSelected = lineplusoffset
	for p=1, 10 do
		_G(pathh.."_ScrollButton"..p.."_selected"):Hide()
	end
	-- Performance?
	local ability = tonumber(DetailsArr[lineplusoffset])
	_G(pathh.."_ScrollButton"..i.."_selected"):Show()
	
	local path = db[user][ability]
	local hit, crit, hitav, critav, hitMin, hitMax, critMin, critMax = path[2], path[3], path[4], path[5], path[6], path[7], path[8], path[9]
	local total, max = hit+crit, DPSMate:TMax({hit, crit})
	
	-- Hit
	_G(pathh.."Details_Healing_Amount0_Amount"):SetText(hit)
	_G(pathh.."Details_Healing_Amount0_Percent"):SetText(ceil(100*hit/total).."%")
	_G(pathh.."Details_Healing_Amount0_StatusBar"):SetValue(ceil(100*hit/max))
	_G(pathh.."Details_Healing_Amount0_StatusBar"):SetStatusBarColor(0.3,0.7,1.0,1)
	_G(pathh.."Details_Healing_Average0"):SetText(ceil(hitav))
	_G(pathh.."Details_Healing_Min0"):SetText(hitMin)
	_G(pathh.."Details_Healing_Max0"):SetText(hitMax)
	
	-- Crit
	_G(pathh.."Details_Healing_Amount1_Amount"):SetText(crit)
	_G(pathh.."Details_Healing_Amount1_Percent"):SetText(ceil(100*crit/total).."%")
	_G(pathh.."Details_Healing_Amount1_StatusBar"):SetValue(ceil(100*crit/max))
	_G(pathh.."Details_Healing_Amount1_StatusBar"):SetStatusBarColor(1.0,0.7,0.3,1)
	_G(pathh.."Details_Healing_Average1"):SetText(ceil(critav))
	_G(pathh.."Details_Healing_Min1"):SetText(critMin)
	_G(pathh.."Details_Healing_Max1"):SetText(critMax)
end

function DPSMate.Modules.DetailsHealing:UpdatePie()
	g:ResetPie()
	for cat, val in pairs(DetailsArr) do
		local ability = tonumber(DetailsArr[cat])
		local percent = (db[DPSMateUser[DetailsUser][1]][ability][1]*100/DetailsTotal)
		g:AddPie(percent, 0)
	end
end

function DPSMate.Modules.DetailsHealing:UpdateLineGraph()
	local sumTable = self:GetSummarizedTable(db[DPSMateUser[DetailsUser][1]]["i"][2])
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
		tinsert(Data1, {val[1],val[2], self:CheckProcs(DPSMate_Details_Healing.proc, val[1])})
	end

	g2:AddDataSeries(Data1,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, self:AddProcPoints(DPSMate_Details_Healing.proc, Data1))
end

function DPSMate.Modules.DetailsHealing:CreateGraphTable()
	local lines = {}
	for i=1, 8 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Healing_Log, 252, 270-i*30, 617, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[9] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Healing_Log, 302, 260, 302, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Healing_Log, 437, 260, 437, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Healing_Log, 497, 260, 497, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
	
	lines[12] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Healing_Log, 557, 260, 557, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
end

function DPSMate.Modules.DetailsHealing:ProcsDropDown()
	local arr = DPSMate.Modules.DetailsHealing:GetAuraGainedArr(curKey)
	DPSMate_Details_Healing.proc = "None"
	
    local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_Details_Healing_DiagramLegend_Procs, this.value)
		DPSMate_Details_Healing.proc = this.value
		DPSMate.Modules.DetailsHealing:UpdateLineGraph()
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
	
	if DPSMate_Details_Healing.LastUser~=DetailsUser then
		UIDropDownMenu_SetSelectedValue(DPSMate_Details_Healing_DiagramLegend_Procs, "None")
	end
	DPSMate_Details_Healing.LastUser = DetailsUser
end

function DPSMate.Modules.DetailsHealing:GetSummarizedTable(arr)
	return DPSMate.Sync:GetSummarizedTable(arr)
end

function DPSMate.Modules.DetailsHealing:GetAuraGainedArr(k)
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

function DPSMate.Modules.DetailsHealing:CheckProcs(name, val)
	local arr = DPSMate.Modules.DetailsHealing:GetAuraGainedArr(curKey)
	if arr[DPSMateUser[DetailsUser][1]] then
		if arr[DPSMateUser[DetailsUser][1]][name] then
			for i=1, DPSMate:TableLength(arr[DPSMateUser[DetailsUser][1]][name][1]) do
				if not arr[DPSMateUser[DetailsUser][1]][name][1][i] or not arr[DPSMateUser[DetailsUser][1]][name][2][i] or arr[DPSMateUser[DetailsUser][1]][name][4] then return false end
				if val > arr[DPSMateUser[DetailsUser][1]][name][1][i] and val < arr[DPSMateUser[DetailsUser][1]][name][2][i] then
					return true
				end
			end
		end
	end
	return false
end

function DPSMate.Modules.DetailsHealing:AddProcPoints(name, dat)
	local bool, data, LastVal = false, {}, 0
	local arr = self:GetAuraGainedArr(curKey)
	if arr[DPSMateUser[DetailsUser][1]] then
		if arr[DPSMateUser[DetailsUser][1]][name] then
			if arr[DPSMateUser[DetailsUser][1]][name][4] then
				for cat, val in pairs(dat) do
					for i=1, DPSMate:TableLength(arr[DPSMateUser[DetailsUser][1]][name][1]) do
						if arr[DPSMateUser[DetailsUser][1]][name][1][i]<=val[1] then
							local tempbool = true
							for _, va in pairs(data) do
								if va[1] == arr[DPSMateUser[DetailsUser][1]][name][1][i] then
									tempbool = false
									break
								end
							end
							if tempbool then	
								bool = true
								tinsert(data, {arr[DPSMateUser[DetailsUser][1]][name][1][i], LastVal, {val[1], val[2]}})
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


