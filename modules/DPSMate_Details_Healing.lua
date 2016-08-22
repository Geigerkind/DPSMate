-- Global Variables
DPSMate.Modules.DetailsHealing = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailsUser, DetailsSelected  = {}, 0, {}, "", 1
local g, g2, g3
local curKey = 1
local db, cbt, db2 = {}, 0, {}
local tinsert = table.insert
local _G = getglobal
local strformat = string.format
local toggle, toggle2, toggle3 = false, false, false
local t1, t2, TTotal = {}, {}, 0
local mode = {[1]="total",[2]="current"}

function DPSMate.Modules.DetailsHealing:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	db2 = DPSMate:GetModeByArr(DPSMateHealingTaken, key, "THealingTaken")
	DPSMate_Details_Healing.proc = "None"
	UIDropDownMenu_SetSelectedValue(DPSMate_Details_Healing_DiagramLegend_Procs, "None")
	DetailsUser = obj.user
	DPSMate_Details_Healing_Title:SetText(DPSMate.L["healdoneby"]..obj.user)
	DPSMate_Details_Healing_SubTitle:SetText(DPSMate.L["activity"]..strformat("%.2f", DPSMateCombatTime["effective"][key][obj.user] or 0).."s "..DPSMate.L["of"].." "..strformat("%.2f", DPSMateCombatTime[mode[key]]).."s ("..strformat("%.2f", 100*(DPSMateCombatTime["effective"][key][obj.user] or 0)/DPSMateCombatTime[mode[key]]).."%)")
	DPSMate_Details_Healing:Show()
	UIDropDownMenu_Initialize(DPSMate_Details_Healing_DiagramLegend_Procs, DPSMate.Modules.DetailsHealing.ProcsDropDown)
	DetailsArr, DetailsTotal, DmgArr = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[DetailsUser], curKey)
	t1, t2, TTotal = self:EvalToggleTable()
	if toggle then
		self:Player_Update()
		self:PlayerSpells_Update(1)
		self:SelectDetails_HealingButton(1)
	else
		self:ScrollFrame_Update()
		self:SelectDetails_HealingButton(1)
	end
	self:UpdatePie()
	if toggle2 then
		self:UpdateStackedGraph()
	else
		self:UpdateLineGraph()
	end
end

function DPSMate.Modules.DetailsHealing:EvalToggleTable()
	local a,b = {},{}
	local d = 0
	for cat, val in db2 do
		if val[DPSMateUser[DetailsUser][1]] then
			local CV = 0
			local c = {[1] = 0,[2] = {},[3] = {}}
			for p, v in val[DPSMateUser[DetailsUser][1]] do
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
			local i = 1
			while true do
				if (not a[i]) then
					tinsert(b, i, c)
					tinsert(a, i, cat)
					break
				else
					if b[i][1] < CV then
						tinsert(b, i, c)
						tinsert(a, i, cat)
						break
					end
				end
				i=i+1
			end
			d = d + CV
		end
	end
	return a,b,d
end

function DPSMate.Modules.DetailsHealing:ScrollFrame_Update()
	local line, lineplusoffset
	local path = "DPSMate_Details_Healing_Log"
	local obj = _G(path.."_ScrollFrame")
	local len = DPSMate:TableLength(DetailsArr)
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DetailsArr[lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[lineplusoffset].." ("..strformat("%.2f", (DmgArr[lineplusoffset]*100/DetailsTotal)).."%)")
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

local PSelected = 1
function DPSMate.Modules.DetailsHealing:Player_Update()
	local line, lineplusoffset
	local path = "DPSMate_Details_Healing_player"
	local obj = _G(path.."_ScrollFrame")
	local len = DPSMate:TableLength(t1)
	FauxScrollFrame_Update(obj,len,8,24)
	for line=1,8 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if t1[lineplusoffset] ~= nil then
			local user = DPSMate:GetUserById(t1[lineplusoffset])
			local r,g,b,img = DPSMate:GetClassColor(DPSMateUser[user][2])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(user)
			_G(path.."_ScrollButton"..line.."_Name"):SetTextColor(r,g,b)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(t2[lineplusoffset][1].." ("..strformat("%.2f", (t2[lineplusoffset][1]*100/TTotal)).."%)")
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
		if PSelected == lineplusoffset then
			_G(path.."_ScrollButton"..line.."_selected"):Show()
		end
	end
end

function DPSMate.Modules.DetailsHealing:PlayerSpells_Update(i)
	local line, lineplusoffset
	local path = "DPSMate_Details_Healing_playerSpells"
	local obj = _G(path.."_ScrollFrame")
	obj.id = (i + FauxScrollFrame_GetOffset(DPSMate_Details_Healing_player_ScrollFrame)) or obj.id
	local len = DPSMate:TableLength(t2[i][2])
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if t2[obj.id][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(t2[obj.id][2][lineplusoffset])
			_G(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			_G(path.."_ScrollButton"..line.."_Value"):SetText(t2[obj.id][3][lineplusoffset][1].." ("..strformat("%.2f", (t2[obj.id][3][lineplusoffset][1]*100/t2[obj.id][1])).."%)")
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
	PSelected = obj.id
	for p=1, 8 do
		_G("DPSMate_Details_Healing_player_ScrollButton"..p.."_selected"):Hide()
	end
	_G("DPSMate_Details_Healing_player_ScrollButton"..i.."_selected"):Show()
	if toggle3 then
		if toggle2 then
			self:UpdateStackedGraph()
		else
			self:UpdateLineGraph()
		end
	end
end

function DPSMate.Modules.DetailsHealing:SelectDetails_HealingButton(i)
	local pathh = ""
	local path,obj,lineplusoffset
	local user = DPSMateUser[DetailsUser][1]
	if toggle then
		pathh = "DPSMate_Details_Healing_playerSpells"
		obj = _G(pathh.."_ScrollFrame")
		lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
		path = t2[obj.id][3][lineplusoffset]
	else
		pathh = "DPSMate_Details_Healing_Log"
		obj = _G(pathh.."_ScrollFrame")
		lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
		path = db[user][tonumber(DetailsArr[lineplusoffset])]
	end
	DetailsSelected = lineplusoffset
	for p=1, 10 do
		_G(pathh.."_ScrollButton"..p.."_selected"):Hide()
	end
	_G(pathh.."_ScrollButton"..i.."_selected"):Show()
	local hit, crit, hitav, critav, hitMin, hitMax, critMin, critMax = path[2], path[3], path[4], path[5], path[6], path[7], path[8], path[9]
	local total, max = hit+crit, DPSMate:TMax({hit, crit})
	
	-- Hit
	_G("DPSMate_Details_Healing_LogDetails_Healing_Amount0_Amount"):SetText(hit)
	_G("DPSMate_Details_Healing_LogDetails_Healing_Amount0_Percent"):SetText(strformat("%.1f", 100*hit/total).."%")
	_G("DPSMate_Details_Healing_LogDetails_Healing_Amount0_StatusBar"):SetValue(ceil(100*hit/max))
	_G("DPSMate_Details_Healing_LogDetails_Healing_Amount0_StatusBar"):SetStatusBarColor(0.3,0.7,1.0,1)
	_G("DPSMate_Details_Healing_LogDetails_Healing_Average0"):SetText(ceil(hitav))
	_G("DPSMate_Details_Healing_LogDetails_Healing_Min0"):SetText(hitMin)
	_G("DPSMate_Details_Healing_LogDetails_Healing_Max0"):SetText(hitMax)
	
	-- Crit
	_G("DPSMate_Details_Healing_LogDetails_Healing_Amount1_Amount"):SetText(crit)
	_G("DPSMate_Details_Healing_LogDetails_Healing_Amount1_Percent"):SetText(strformat("%.1f", 100*crit/total).."%")
	_G("DPSMate_Details_Healing_LogDetails_Healing_Amount1_StatusBar"):SetValue(ceil(100*crit/max))
	_G("DPSMate_Details_Healing_LogDetails_Healing_Amount1_StatusBar"):SetStatusBarColor(1.0,0.7,0.3,1)
	_G("DPSMate_Details_Healing_LogDetails_Healing_Average1"):SetText(ceil(critav))
	_G("DPSMate_Details_Healing_LogDetails_Healing_Min1"):SetText(critMin)
	_G("DPSMate_Details_Healing_LogDetails_Healing_Max1"):SetText(critMax)
end

function DPSMate.Modules.DetailsHealing:UpdatePie()
	if not g then
		g=DPSMate.Options.graph:CreateGraphPieChart("RHPieChart", DPSMate_Details_Healing_Diagram, "CENTER", "CENTER", 0, 0, 200, 200)
	end
	g:ResetPie()
	for cat, val in pairs(DetailsArr) do
		local ability = tonumber(DetailsArr[cat])
		local percent = (db[DPSMateUser[DetailsUser][1]][ability][1]*100/DetailsTotal)
		g:AddPie(percent, 0, DPSMate:GetAbilityById(ability))
	end
end

function DPSMate.Modules.DetailsHealing:SortLineTable(t, b)
	local newArr = {}
	if b then
		for cat, val in t[b][DPSMateUser[DetailsUser][1]] do
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
	else
		for cat, val in t[DPSMateUser[DetailsUser][1]] do
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
	return newArr
end

function DPSMate.Modules.DetailsHealing:UpdateLineGraph()
	if not g2 then
		g2=DPSMate.Options.graph:CreateGraphLine("RHLineGraph",DPSMate_Details_Healing_DiagramLine,"CENTER","CENTER",0,0,850,230)
	end
	if g3 then
		g3:Hide()
	end
	local sumTable
	if toggle3 then
		sumTable = self:GetSummarizedTable(db2, t1[PSelected])
	else
		sumTable = self:GetSummarizedTable(db, nil)
	end
	local max = DPSMate:GetMaxValue(sumTable, 2)
	local time = DPSMate:GetMaxValue(sumTable, 1)
	local min = DPSMate:GetMinValue(sumTable, 1)
	
	g2:ResetData()
	g2:SetXAxis(0,time-min)
	g2:SetYAxis(0,max+200)
	g2:SetGridSpacing((time-min)/10,max/7)
	g2:SetGridColor({0.5,0.5,0.5,0.5})
	g2:SetAxisDrawing(true,true)
	g2:SetAxisColor({1.0,1.0,1.0,1.0})
	g2:SetAutoScale(true)
	g2:SetYLabels(true, false)
	g2:SetXLabels(true)

	local Data1={{0,0}}
	for cat, val in DPSMate:ScaleDown(sumTable, min) do
		tinsert(Data1, {val[1],val[2], self:CheckProcs(DPSMate_Details_Healing.proc, val[1]+min)})
	end

	g2:AddDataSeries(Data1,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, self:AddProcPoints(DPSMate_Details_Healing.proc, Data1))
	g2:Show()
	toggle2=false
end

function DPSMate.Modules.DetailsHealing:UpdateStackedGraph()
	if not g3 then
		g3=DPSMate.Options.graph:CreateStackedGraph("RHStackedGraph",DPSMate_Details_Healing_DiagramLine,"CENTER","CENTER",0,0,850,230)
		g3:SetGridColor({0.5,0.5,0.5,0.5})
		g3:SetAxisDrawing(true,true)
		g3:SetAxisColor({1.0,1.0,1.0,1.0})
		g3:SetAutoScale(true)
		g3:SetYLabels(true, false)
		g3:SetXLabels(true)
	end
	if g2 then
		g2:Hide()
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
		for cat, val in db2[t1[PSelected]][DPSMateUser[DetailsUser][1]] do
			if cat~="i" and val["i"] then
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
	
		g3:ResetData()
		g3:SetGridSpacing((maxX-min)/7,maxY/7)
	else
		for cat, val in db[DPSMateUser[DetailsUser][1]] do
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
		
		g3:ResetData()
		g3:SetGridSpacing(maxX/7,maxY/7)
	end
	
	g3:AddDataSeries(Data1,{1.0,0.0,0.0,0.8}, {}, label)
	g3:Show()
	toggle2 = true
end

function DPSMate.Modules.DetailsHealing:CreateGraphTable()
	local lines = {}
	for i=1, 8 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Healing_LogDetails_Healing, 10, 270-i*30, 370, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[9] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Healing_LogDetails_Healing, 57, 260, 57, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Healing_LogDetails_Healing, 192, 260, 192, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Healing_LogDetails_Healing, 252, 260, 252, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
	
	lines[12] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Healing_LogDetails_Healing, 312, 260, 312, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
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

function DPSMate.Modules.DetailsHealing:GetSummarizedTable(arr,b)
	return DPSMate.Sync:GetSummarizedTable(self:SortLineTable(arr,b))
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

function DPSMate.Modules.DetailsHealing:ToggleMode(bool)
	if bool then
		if toggle2 then
			self:UpdateLineGraph()
		else
			self:UpdateStackedGraph()
		end
	else
		if toggle then
			toggle = false
			self:ScrollFrame_Update()
			self:SelectDetails_HealingButton(1)
			DPSMate_Details_Healing_playerSpells:Hide()
			DPSMate_Details_Healing_player:Hide()
			DPSMate_Details_Healing_Diagram:Show()
			DPSMate_Details_Healing_Log:Show()
		else
			toggle = true
			self:Player_Update()
			self:PlayerSpells_Update(1)
			self:SelectDetails_HealingButton(1)
			DPSMate_Details_Healing_playerSpells:Show()
			DPSMate_Details_Healing_player:Show()
			DPSMate_Details_Healing_Diagram:Hide()
			DPSMate_Details_Healing_Log:Hide()
		end
	end
end

function DPSMate.Modules.DetailsHealing:ToggleIndividual()
	if toggle3 then
		toggle3 = false
	else
		toggle3 = true
	end
	if toggle2 then
		self:UpdateStackedGraph()
	else
		self:UpdateLineGraph()
	end
end
