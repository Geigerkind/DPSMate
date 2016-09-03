-- Global Variables
DPSMate.Modules.DetailsInterrupts = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailUser, DetailsSelected  = {}, 0, {}, "", 1
local DetailsArrComp, DetailsTotalComp, DmgArrComp, DetailUserComp, DetailsSelectedComp  = {}, 0, {}, "", 1
local g, g2
local curKey = 1
local db, cbt = {}, 0
local _G = getglobal
local tinsert = table.insert

function DPSMate.Modules.DetailsInterrupts:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DetailUserComp = nil
	DPSMate_Details_Interrupts_Title:SetText(DPSMate.L["interruptsby"]..obj.user)
	DetailsArr, DetailsTotal, DmgArr = self:EvalTable()
	DPSMate_Details_Interrupts:Show()
	self:ScrollFrame_Update("")
	self:SelectCreatureButton(1,"")
	self:SelectCreatureAbilityButton(1,1, "")
	
	DPSMate_Details_CompareInterrupts:Hide()
	DPSMate_Details_Interrupts:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsInterrupts:UpdateCompare(obj, key, comp)
	self:UpdateDetails(obj, key)

	DetailsUserComp	= comp
	DPSMate_Details_CompareInterrupts_Title:SetText(DPSMate.L["interruptsby"]..comp)
	DetailsArrComp, DetailsTotalComp, DmgArrComp = self:EvalTable(comp)
	DPSMate_Details_CompareInterrupts:Show()
	self:ScrollFrame_Update("Compare")
	self:SelectCreatureButton(1,"Compare")
	self:SelectCreatureAbilityButton(1,1, "Compare")
end

function DPSMate.Modules.DetailsInterrupts:EvalTable(cname)
	local a, b, total, u, pet = {}, {}, 0, {}, false
	if (DPSMateUser[cname or DetailsUser][5] and DPSMateUser[cname or DetailsUser][5] ~= DPSMate.L["unknown"] and arr[DPSMateUser[DPSMateUser[cname or DetailsUser][5]][1]]) and DPSMateSettings["mergepets"] then u={DPSMateUser[cname or DetailsUser][1],DPSMateUser[DPSMateUser[cname or DetailsUser][5]][1]} else u={DPSMateUser[cname or DetailsUser][1]} end
	for _, vvv in pairs(u) do
		for cat, val in db[vvv] do -- 41 Ability
			if cat~="i" then
				local CV, ta, tb = 0, {}, {}
				if (DPSMateUser[DPSMate:GetUserById(vvv)][4]) then pet=true; else pet=false; end
				for ca, va in val do
					local taa, tbb = {}, {}
					for c, v in va do
						CV = CV + v
						local i = 1
						while true do
							if (not tbb[i]) then
								tinsert(tbb, i, v)
								tinsert(taa, i, c)
								break
							else
								if tbb[i] < v then
									tinsert(tbb, i, v)
									tinsert(taa, i, c)
									break
								end
							end
							i=i+1
						end
					end
					local i = 1
					while true do
						if (not tb[i]) then
							tinsert(tb, i, {CV, taa, tbb})
							tinsert(ta, i, ca)
							break
						else
							if tb[i][1] < CV then
								tinsert(tb, i, {CV, taa, tbb})
								tinsert(ta, i, ca)
								break
							end
						end
						i=i+1
					end
				end
				if CV>0 then
					local i = 1
					while true do
						if (not b[i]) then
							tinsert(b, i, {CV, ta, tb})
							tinsert(a, i, {cat, pet})
							break
						else
							if b[i][1] < CV then
								tinsert(b, i, {CV, ta, tb})
								tinsert(a, i, {cat, pet})
								break
							end
						end
						i=i+1
					end
				end
				total = total + CV
			end
		end
	end
	return a, total, b
end

function DPSMate.Modules.DetailsInterrupts:ScrollFrame_Update(comp)
	comp = comp or DPSMate_Details_Interrupts.LastScroll
	local line, lineplusoffset
	local obj = _G("DPSMate_Details_"..comp.."Interrupts_Log_ScrollFrame")
	local path = "DPSMate_Details_"..comp.."Interrupts_Log_ScrollButton"
	local uArr, dArr, dTot, dSel = DetailsArr, DmgArr, DetailsTotal, DetailsSelected
	local pet = ""
	if comp~="" and comp then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
		dSel = DetailsSelectedComp
	end
	local len = DPSMate:TableLength(uArr)
	FauxScrollFrame_Update(obj,len,14,24)
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if uArr[lineplusoffset] ~= nil then
			if uArr[lineplusoffset][2] then pet = "(Pet)" else pet = "" end
			local ability = DPSMate:GetAbilityById(uArr[lineplusoffset][1])
			_G(path..line.."_Name"):SetText(ability..pet)
			_G(path..line.."_Value"):SetText(dArr[lineplusoffset][1].." ("..string.format("%.2f", 100*dArr[lineplusoffset][1]/dTot).."%)")
			_G(path..line.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(strsub(ability, 1, (strfind(ability, "%(") or 0)-1) or ability))
			if len < 14 then
				_G(path..line):SetWidth(235)
				_G(path..line.."_Name"):SetWidth(125)
			else
				_G(path..line):SetWidth(220)
				_G(path..line.."_Name"):SetWidth(110)
			end
			_G(path..line):Show()
		else
			_G(path..line):Hide()
		end
		_G(path..line.."_selected"):Hide()
		if dSel == lineplusoffset then
			_G(path..line.."_selected"):Show()
		end
	end
end

function DPSMate.Modules.DetailsInterrupts:SelectCreatureButton(i,comp)
	comp = comp or DPSMate_Details_Interrupts.LastScroll
	local line, lineplusoffset
	local obj =_G("DPSMate_Details_"..comp.."Interrupts_LogTwo_ScrollFrame")
	obj.index = i
	local path = "DPSMate_Details_"..comp.."Interrupts_LogTwo_ScrollButton"
	local uArr, dArr, dTot, dSel = DetailsArr, DmgArr, DetailsTotal, DetailsSelected
	if comp~="" and comp then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
		dSel = DetailsSelectedComp
	end
	local len = DPSMate:TableLength(dArr[i][2])
	FauxScrollFrame_Update(obj,len,14,24)
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if dArr[i][2][lineplusoffset] ~= nil then
			_G(path..line.."_Name"):SetText(DPSMate:GetUserById(dArr[i][2][lineplusoffset]))
			_G(path..line.."_Value"):SetText(dArr[i][3][lineplusoffset][1].." ("..string.format("%.2f", 100*dArr[i][3][lineplusoffset][1]/dArr[i][1]).."%)")
			_G(path..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\npc")
			if len < 14 then
				_G(path..line):SetWidth(235)
				_G(path..line.."_Name"):SetWidth(125)
			else
				_G(path..line):SetWidth(220)
				_G(path..line.."_Name"):SetWidth(110)
			end
			_G(path..line):Show()
		else
			_G(path..line):Hide()
		end
		_G(path..line.."_selected"):Hide()
	end
	for p=1, 14 do
		_G("DPSMate_Details_"..comp.."Interrupts_Log_ScrollButton"..p.."_selected"):Hide()
	end
	_G(path.."1_selected"):Show()
	DPSMate.Modules.DetailsInterrupts:SelectCreatureAbilityButton(i, 1, comp)
	_G("DPSMate_Details_"..comp.."Interrupts_Log_ScrollButton"..i.."_selected"):Show()
end

function DPSMate.Modules.DetailsInterrupts:SelectCreatureAbilityButton(i, p, comp)
	comp = comp or DPSMate_Details_Interrupts.LastScroll
	local line, lineplusoffset
	local obj = _G("DPSMate_Details_"..comp.."Interrupts_LogThree_ScrollFrame")
	obj.index = i
	local path = "DPSMate_Details_"..comp.."Interrupts_LogThree_ScrollButton"
	local uArr, dArr, dTot, dSel = DetailsArr, DmgArr, DetailsTotal, DetailsSelected
	if comp~="" and comp then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
		dSel = DetailsSelectedComp
	end
	local len = DPSMate:TableLength(dArr[i][3][p][2])
	FauxScrollFrame_Update(obj,len,14,24)
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if dArr[i][3][p][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(dArr[i][3][p][2][lineplusoffset])
			_G(path..line.."_Name"):SetText(ability)
			_G(path..line.."_Value"):SetText(dArr[i][3][p][3][lineplusoffset].." ("..string.format("%.2f", 100*dArr[i][3][p][3][lineplusoffset]/dArr[i][3][p][1]).."%)")
			_G(path..line.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(strsub(ability, 1, (strfind(ability, "%(") or 0)-1) or ability))
			if len < 14 then
				_G(path..line):SetWidth(235)
				_G(path..line.."_Name"):SetWidth(125)
			else
				_G(path..line):SetWidth(220)
				_G(path..line.."_Name"):SetWidth(110)
			end
			_G(path..line):Show()
		else
			_G(path..line):Hide()
		end
		_G(path..line.."_selected"):Hide()
	end
	for i=1, 14 do
		_G("DPSMate_Details_"..comp.."Interrupts_LogTwo_ScrollButton"..i.."_selected"):Hide()
	end
	_G("DPSMate_Details_"..comp.."Interrupts_LogTwo_ScrollButton"..p.."_selected"):Show()
end