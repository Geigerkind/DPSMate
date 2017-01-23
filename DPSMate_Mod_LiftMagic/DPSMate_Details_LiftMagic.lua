-- Global Variables
DPSMate.Modules.DetailsLiftMagic = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailUser, DetailsSelected  = {}, 0, {}, "", 1
local DetailsArrComp, DetailsTotalComp, DmgArrComp, DetailUserComp, DetailsSelectedComp  = {}, 0, {}, "", 1
local g, g2
local curKey = 1
local db, cbt = {}, 0
local tinsert = table.insert
local _G = getglobal
local strformat = string.format

function DPSMate.Modules.DetailsLiftMagic:UpdateDetails(obj, key)
	DPSMate_Details_CompareLiftMagic:Hide()
	
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DetailsUserComp = nil
	DPSMate_Details_LiftMagic_Title:SetText(DPSMate.L["magicliftby"]..obj.user)
	DetailsArr, DetailsTotal, DmgArr = self:EvalTable()
	DPSMate_Details_LiftMagic:Show()
	self:ScrollFrame_Update("")
	self:SelectCreatureButton(1,"")
	self:SelectCreatureAbilityButton(1,1,"")
	DPSMate_Details_LiftMagic:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsLiftMagic:UpdateCompare(obj, key, comp)
	self:UpdateDetails(obj, key)

	DetailsUserComp = comp
	DPSMate_Details_CompareLiftMagic_Title:SetText(DPSMate.L["magicliftby"]..comp)
	DetailsArrComp, DetailsTotalComp, DmgArrComp = self:EvalTable(comp)
	DPSMate_Details_CompareLiftMagic:Show()
	self:ScrollFrame_Update("Compare")
	self:SelectCreatureButton(1,"Compare")
	self:SelectCreatureAbilityButton(1,1,"Compare")
end

function DPSMate.Modules.DetailsLiftMagic:EvalTable(cname)
	local a, b, total = {}, {}, 0
	for cat, val in db[DPSMateUser[cname or DetailsUser][1]] do -- 41 Ability
		if cat~="i" then
			local CV, ta, tb = 0, {}, {}
			for ca, va in val do
				local taa, tbb, CVV = {}, {}, 0
				for c, v in va do
					if DPSMate.Modules.LiftMagic:IsValid(DPSMate:GetAbilityById(c), DPSMate:GetAbilityById(cat)) then
						CVV = CVV + v
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
				end
				local i = 1
				while true do
					if (not tb[i]) then
						tinsert(tb, i, {CVV, taa, tbb})
						tinsert(ta, i, ca)
						break
					else
						if tb[i][1] < CVV then
							tinsert(tb, i, {CVV, taa, tbb})
							tinsert(ta, i, ca)
							break
						end
					end
					i=i+1
				end
				CV = CV + CVV
			end
			if CV>0 then
				local i = 1
				while true do
					if (not b[i]) then
						tinsert(b, i, {CV, ta, tb})
						tinsert(a, i, cat)
						break
					else
						if b[i][1] < CV then
							tinsert(b, i, {CV, ta, tb})
							tinsert(a, i, cat)
							break
						end
					end
					i=i+1
				end
			end
			total = total + CV
		end
	end
	return a, total, b
end

function DPSMate.Modules.DetailsLiftMagic:ScrollFrame_Update(comp)
	comp = comp or DPSMate_Details_LiftMagic.LastScroll
	local line, lineplusoffset
	local obj = _G("DPSMate_Details_"..comp.."LiftMagic_Log_ScrollFrame")
	local path = "DPSMate_Details_"..comp.."LiftMagic_Log_ScrollButton"
	local uArr, dArr, dTot = DetailsArr, DmgArr, DetailsTotal
	if comp~="" and comp then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
	end
	local len = DPSMate:TableLength(uArr)
	FauxScrollFrame_Update(obj,len,14,24)
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if uArr[lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(uArr[lineplusoffset])
			_G(path..line.."_Name"):SetText(ability)
			_G(path..line.."_Value"):SetText(dArr[lineplusoffset][1].." ("..strformat("%.2f", 100*dArr[lineplusoffset][1]/dTot).."%)")
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
end

function DPSMate.Modules.DetailsLiftMagic:SelectCreatureButton(i, comp)
	comp = comp or DPSMate_Details_LiftMagic.LastScroll
	local line, lineplusoffset
	local obj = _G("DPSMate_Details_"..comp.."LiftMagic_LogTwo_ScrollFrame")
	i = i or obj.index
	obj.index = i
	local path = "DPSMate_Details_"..comp.."LiftMagic_LogTwo_ScrollButton"
	local uArr, dArr, dTot = DetailsArr, DmgArr, DetailsTotal
	if comp~="" and comp then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
	end
	local len = DPSMate:TableLength(dArr[i][2])
	FauxScrollFrame_Update(obj,len,14,24)
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if dArr[i][2][lineplusoffset] ~= nil then
			local user = DPSMate:GetUserById(dArr[i][2][lineplusoffset])
			local r,g,b,img = DPSMate:GetClassColor(DPSMateUser[user][2])
			_G(path..line.."_Name"):SetText(user)
			_G(path..line.."_Name"):SetTextColor(r,g,b)
			_G(path..line.."_Value"):SetText(dArr[i][3][lineplusoffset][1].." ("..strformat("%.2f", 100*dArr[i][3][lineplusoffset][1]/dArr[i][1]).."%)")
			_G(path..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\class\\"..img)
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
		_G("DPSMate_Details_"..comp.."LiftMagic_Log_ScrollButton"..p.."_selected"):Hide()
	end
	_G(path.."1_selected"):Show()
	DPSMate.Modules.DetailsLiftMagic:SelectCreatureAbilityButton(i, 1, comp)
	_G("DPSMate_Details_"..comp.."LiftMagic_Log_ScrollButton"..i.."_selected"):Show()
end

function DPSMate.Modules.DetailsLiftMagic:SelectCreatureAbilityButton(i, p, comp)
	comp = comp or DPSMate_Details_LiftMagic.LastScroll
	local line, lineplusoffset
	local obj = _G("DPSMate_Details_"..comp.."LiftMagic_LogThree_ScrollFrame")
	i = i or _G("DPSMate_Details_"..comp.."LiftMagic_LogTwo_ScrollFrame").index
	p = p or obj.index
	obj.index = p
	local path = "DPSMate_Details_"..comp.."LiftMagic_LogThree_ScrollButton"
	local uArr, dArr, dTot = DetailsArr, DmgArr, DetailsTotal
	if comp~="" and comp then
		uArr = DetailsArrComp
		dArr = DmgArrComp
		dTot = DetailsTotalComp
	end
	local len = DPSMate:TableLength(dArr[i][3][p][2])
	FauxScrollFrame_Update(obj,len,14,24)
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if dArr[i][3][p][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(dArr[i][3][p][2][lineplusoffset])
			_G(path..line.."_Name"):SetText(ability)
			_G(path..line.."_Value"):SetText(dArr[i][3][p][3][lineplusoffset].." ("..strformat("%.2f", 100*dArr[i][3][p][3][lineplusoffset]/dArr[i][3][p][1]).."%)")
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
		_G("DPSMate_Details_"..comp.."LiftMagic_LogTwo_ScrollButton"..i.."_selected"):Hide()
	end
	_G("DPSMate_Details_"..comp.."LiftMagic_LogTwo_ScrollButton"..p.."_selected"):Show()
end