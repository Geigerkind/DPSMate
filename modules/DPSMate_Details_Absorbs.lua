-- Global Variables
DPSMate.Modules.DetailsAbsorbs = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailUser, DetailsSelected  = {}, 0, {}, "", 1
local PieChart = true
local g, g2
local icons = {
	-- General
	["AutoAttack"] = "Interface\\ICONS\\inv_sword_39",
	["Lightning Strike"] = "Interface\\ICONS\\spell_holy_mindvision",
	["Fatal Wound"] = "Interface\\ICONS\\ability_backstab",
	["Falling"] = "Interface\\ICONS\\spell_magic_featherfall",
	["Thorium Grenade"] = "Interface\\ICONS\\inv_misc_bomb_08",
	["Crystal Charge"] = "Interface\\ICONS\\inv_misc_gem_opal_01",
	["Shoot Bow"] = "Interface\\ICONS\\ability_marksmanship",
	
	-- Rogues
	["Sinister Strike"] = "Interface\\ICONS\\spell_shadow_ritualofsacrifice",
	["Blade Flurry"] = "Interface\\ICONS\\ability_warrior_punishingblow",
	["Eviscerate"] = "Interface\\ICONS\\ability_rogue_eviscerate",
	["Garrote(Periodic)"] = "Interface\\ICONS\\ability_rogue_garrote",
	["Rupture(Periodic)"] = "Interface\\ICONS\\ability_rogue_rupture",
	["Instant Poison VI"] = "Interface\\ICONS\\ability_poisons", 
	["Instant Poison V"] = "Interface\\ICONS\\ability_poisons", 
	["Instant Poison IV"] = "Interface\\ICONS\\ability_poisons", 
	["Instant Poison III"] = "Interface\\ICONS\\ability_poisons", 
	["Instant Poison II"] = "Interface\\ICONS\\ability_poisons", 
	["Instant Poison I"] = "Interface\\ICONS\\ability_poisons", 
	["Kick"] = "Interface\\ICONS\\ability_kick", 
	
}
local curKey = 1
local db, cbt = {}, 0

function DPSMate.Modules.DetailsAbsorbs:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	if (PieChart) then
		g2=DPSMate.Options.graph:CreateGraphLine("LineGraph",DPSMate_Details_Absorbs_DiagramLine,"CENTER","CENTER",0,0,960,230)
		PieChart = false
	end
	DetailsUser = obj.user
	DPSMate_Details_Absorbs_Title:SetText("Absorbs by "..obj.user)
	DPSMate_Details_Absorbs:Show()
	DPSMate.Modules.DetailsAbsorbs:ScrollFrame_Update()
	DPSMate.Modules.DetailsAbsorbs:SelectCreatureButton(1)
	DPSMate.Modules.DetailsAbsorbs:SelectCauseButton(1,1)
	DPSMate.Modules.DetailsAbsorbs:SelectCauseABButton(1,1,1)
	DPSMate.Modules.DetailsAbsorbs:UpdateLineGraph()
end

function DPSMate.Modules.DetailsAbsorbs:ScrollFrame_Update()
	local line, lineplusoffset
	local path = "DPSMate_Details_Absorbs_LogCreature"
	local obj = getglobal(path.."_ScrollFrame")
	local arr = db
	local pet, len = "", DPSMate:TableLength(arr[DPSMateUser[DetailsUser][1]])-5
	DetailsArr, DetailsTotal, DmgArr = DPSMate.RegistredModules[DPSMateSettings["windows"][curKey]["CurMode"]]:EvalTable(DPSMateUser[DetailsUser], curKey)
	FauxScrollFrame_Update(obj,DPSMate:TableLength(arr),10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			local user = DPSMate:GetUserById(DetailsArr[lineplusoffset])
			getglobal(path.."_ScrollButton"..line.."_Name"):SetText(user)
			getglobal(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[lineplusoffset][1].." ("..string.format("%.2f", (DmgArr[lineplusoffset][1]*100/DetailsTotal)).."%)")
			getglobal(path.."_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
			if len < 10 then
				getglobal(path.."_ScrollButton"..line):SetWidth(235)
				getglobal(path.."_ScrollButton"..line.."_Name"):SetWidth(125)
			else
				getglobal(path.."_ScrollButton"..line):SetWidth(220)
				getglobal(path.."_ScrollButton"..line.."_Name"):SetWidth(110)
			end
			getglobal(path.."_ScrollButton"..line):Show()
		else
			getglobal(path.."_ScrollButton"..line):Hide()
		end
		getglobal(path.."_ScrollButton"..line.."_selected"):Hide()
		if DetailsSelected == lineplusoffset then
			getglobal(path.."_ScrollButton"..line.."_selected"):Show()
		end
	end
end

function DPSMate.Modules.DetailsAbsorbs:SelectCreatureButton(i)
	local line, lineplusoffset
	local path = "DPSMate_Details_Absorbs_Log"
	local obj = getglobal(path.."_ScrollFrame")
	obj.index = i
	local arr = db
	local pet, len = "", DPSMate:TableLength(arr[DPSMateUser[DetailsUser][1]])-5
	FauxScrollFrame_Update(obj,DPSMate:TableLength(arr),10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DmgArr[i][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DmgArr[i][2][lineplusoffset])
			getglobal(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			getglobal(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[i][3][lineplusoffset][1].." ("..string.format("%.2f", (DmgArr[i][3][lineplusoffset][1]*100/DetailsTotal)).."%)")
			if icons[ability] then
				getglobal(path.."_ScrollButton"..line.."_Icon"):SetTexture(icons[ability])
			else
				getglobal(path.."_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
			end
			if len < 10 then
				getglobal(path.."_ScrollButton"..line):SetWidth(235)
				getglobal(path.."_ScrollButton"..line.."_Name"):SetWidth(125)
			else
				getglobal(path.."_ScrollButton"..line):SetWidth(220)
				getglobal(path.."_ScrollButton"..line.."_Name"):SetWidth(110)
			end
			getglobal(path.."_ScrollButton"..line):Show()
		else
			getglobal(path.."_ScrollButton"..line):Hide()
		end
		getglobal(path.."_ScrollButton"..line.."_selected"):Hide()
		getglobal(path.."_ScrollButton1_selected"):Show()
	end
	for p=1, 10 do
		getglobal("DPSMate_Details_Absorbs_LogCreature_ScrollButton"..p.."_selected"):Hide()
	end
	getglobal("DPSMate_Details_Absorbs_LogCreature_ScrollButton"..i.."_selected"):Show()
end

function DPSMate.Modules.DetailsAbsorbs:SelectCauseButton(i,p)
	local line, lineplusoffset
	local path = "DPSMate_Details_Absorbs_LogTwo"
	local obj = getglobal(path.."_ScrollFrame")
	obj.index = i
	obj.indextwo = p
	local arr = db
	local pet, len = "", DPSMate:TableLength(arr[DPSMateUser[DetailsUser][1]])-5
	FauxScrollFrame_Update(obj,DPSMate:TableLength(arr),10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DmgArr[i][3][p][2][lineplusoffset] ~= nil then
			local user = DPSMate:GetUserById(DmgArr[i][3][p][2][lineplusoffset])
			getglobal(path.."_ScrollButton"..line.."_Name"):SetText(user)
			getglobal(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[i][3][p][3][lineplusoffset][1].." ("..string.format("%.2f", (DmgArr[i][3][p][3][lineplusoffset][1]*100/DmgArr[i][3][p][1])).."%)")
			if icons[user] then
				getglobal(path.."_ScrollButton"..line.."_Icon"):SetTexture(icons[user])
			else
				getglobal(path.."_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
			end
			if len < 10 then
				getglobal(path.."_ScrollButton"..line):SetWidth(235)
				getglobal(path.."_ScrollButton"..line.."_Name"):SetWidth(125)
			else
				getglobal(path.."_ScrollButton"..line):SetWidth(220)
				getglobal(path.."_ScrollButton"..line.."_Name"):SetWidth(110)
			end
			getglobal(path.."_ScrollButton"..line):Show()
		else
			getglobal(path.."_ScrollButton"..line):Hide()
		end
		getglobal(path.."_ScrollButton"..line.."_selected"):Hide()
		getglobal(path.."_ScrollButton1_selected"):Show()
	end
	for p=1, 10 do
		getglobal("DPSMate_Details_Absorbs_Log_ScrollButton"..p.."_selected"):Hide()
	end
	getglobal("DPSMate_Details_Absorbs_Log_ScrollButton"..p.."_selected"):Show()
end

function DPSMate.Modules.DetailsAbsorbs:SelectCauseABButton(i,p,q)
	local line, lineplusoffset
	local path = "DPSMate_Details_Absorbs_LogThree"
	local obj = getglobal(path.."_ScrollFrame")
	obj.index = i
	obj.indextwo = p
	obj.indexthree = q
	local arr = db
	local pet, len = "", DPSMate:TableLength(arr[DPSMateUser[DetailsUser][1]])-5
	FauxScrollFrame_Update(obj,DPSMate:TableLength(arr),10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DmgArr[i][3][p][3][q][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DmgArr[i][3][p][3][q][2][lineplusoffset])
			getglobal(path.."_ScrollButton"..line.."_Name"):SetText(ability)
			getglobal(path.."_ScrollButton"..line.."_Value"):SetText(DmgArr[i][3][p][3][q][3][lineplusoffset].." ("..string.format("%.2f", (DmgArr[i][3][p][3][q][3][lineplusoffset]*100/DmgArr[i][3][p][3][q][1])).."%)")
			if icons[ability] then
				getglobal(path.."_ScrollButton"..line.."_Icon"):SetTexture(icons[ability])
			else
				getglobal(path.."_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
			end
			if len < 10 then
				getglobal(path.."_ScrollButton"..line):SetWidth(235)
				getglobal(path.."_ScrollButton"..line.."_Name"):SetWidth(125)
			else
				getglobal(path.."_ScrollButton"..line):SetWidth(220)
				getglobal(path.."_ScrollButton"..line.."_Name"):SetWidth(110)
			end
			getglobal(path.."_ScrollButton"..line):Show()
		else
			getglobal(path.."_ScrollButton"..line):Hide()
		end
		getglobal(path.."_ScrollButton"..line.."_selected"):Hide()
	end
	for p=1, 10 do
		getglobal("DPSMate_Details_Absorbs_LogTwo_ScrollButton"..p.."_selected"):Hide()
	end
	getglobal("DPSMate_Details_Absorbs_LogTwo_ScrollButton"..q.."_selected"):Show()
end

function DPSMate.Modules.DetailsAbsorbs:UpdateLineGraph()
	local arr = db
	local sumTable = DPSMate.Modules.DetailsAbsorbs:GetSummarizedTable(arr)
	local max = DPSMate.Modules.DetailsAbsorbs:GetMaxLineVal(sumTable, 2)
	local time = DPSMate.Modules.DetailsAbsorbs:GetMaxLineVal(sumTable, 1)
	
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
		table.insert(Data1, {val[1],val[2], {}})
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
				elseif DPSMateDamageTaken[1][DPSMateUser[DetailsUser][1]][va[2]][va[3]][14] then
					dmg = DPSMateDamageTaken[1][DPSMateUser[DetailsUser][1]][va[2]][va[3]][14]
				end
				if dmg>0 then
					while true do
						if (not newArr[i]) then
							table.insert(newArr, i, {va[1], dmg})
							break
						else
							if newArr[i][1] > va[1] then
								table.insert(newArr, i, {va[1], dmg})
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

function DPSMate.Modules.DetailsAbsorbs:GetMaxLineVal(t, p)
	local max = 0
	for cat, val in pairs(t) do
		if val[p]>max then
			max=val[p]
		end
	end
	return max
end

