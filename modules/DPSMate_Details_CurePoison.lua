-- Global Variables
DPSMate.Modules.DetailsCurePoison = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailsUser, DetailsSelected  = {}, 0, {}, "", 1
local g, g2
local curKey = 1
local db, cbt = {}, 0
local _G = getglobal

function DPSMate.Modules.DetailsCurePoison:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DPSMate_Details_CurePoison_Title:SetText("Poison cured by "..obj.user)
	DPSMate_Details_CurePoison:Show()
	self:ScrollFrame_Update()
	self:SelectCreatureButton(1)
	self:SelectCreatureAbilityButton(1,1)
end

function DPSMate.Modules.DetailsCurePoison:EvalTable()
	local a, b, total = {}, {}, 0
	for cat, val in pairs(db[DPSMateUser[DetailsUser][1]]) do -- 41 Ability
		if cat~="i" then
			local CV, ta, tb = 0, {}, {}
			for ca, va in pairs(val) do
				local taa, tbb, CVV = {}, {}, 0
				for c, v in pairs(va) do
					if DPSMateAbility[DPSMate:GetAbilityById(c)][2]=="Poison" then -- Performance can be increased here
						CVV = CVV + v
						local i = 1
						while true do
							if (not tbb[i]) then
								table.insert(tbb, i, v)
								table.insert(taa, i, c)
								break
							else
								if tbb[i] < v then
									table.insert(tbb, i, v)
									table.insert(taa, i, c)
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
						table.insert(tb, i, {CVV, taa, tbb})
						table.insert(ta, i, ca)
						break
					else
						if tb[i][1] < CVV then
							table.insert(tb, i, {CVV, taa, tbb})
							table.insert(ta, i, ca)
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
						table.insert(b, i, {CV, ta, tb})
						table.insert(a, i, cat)
						break
					else
						if b[i][1] < CV then
							table.insert(b, i, {CV, ta, tb})
							table.insert(a, i, cat)
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

function DPSMate.Modules.DetailsCurePoison:ScrollFrame_Update()
	local line, lineplusoffset
	local obj = _G("DPSMate_Details_CurePoison_Log_ScrollFrame")
	local path = "DPSMate_Details_CurePoison_Log_ScrollButton"
	DetailsArr, DetailsTotal, DmgArr = DPSMate.Modules.DetailsCurePoison:EvalTable()
	local len = DPSMate:TableLength(DetailsArr)
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DetailsArr[lineplusoffset])
			_G(path..line.."_Name"):SetText(ability)
			_G(path..line.."_Value"):SetText(DmgArr[lineplusoffset][1].." ("..string.format("%.2f", 100*DmgArr[lineplusoffset][1]/DetailsTotal).."%)")
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

function DPSMate.Modules.DetailsCurePoison:SelectCreatureButton(i)
	local line, lineplusoffset
	local obj = _G("DPSMate_Details_CurePoison_LogTwo_ScrollFrame")
	obj.index = i
	local path = "DPSMate_Details_CurePoison_LogTwo_ScrollButton"
	local len = DPSMate:TableLength(DmgArr[i][2])
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DmgArr[i][2][lineplusoffset] ~= nil then
			_G(path..line.."_Name"):SetText(DPSMate:GetUserById(DmgArr[i][2][lineplusoffset]))
			_G(path..line.."_Value"):SetText(DmgArr[i][3][lineplusoffset][1].." ("..string.format("%.2f", 100*DmgArr[i][3][lineplusoffset][1]/DmgArr[i][1]).."%)")
			_G(path..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
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
		_G("DPSMate_Details_CurePoison_Log_ScrollButton"..p.."_selected"):Hide()
	end
	_G(path.."1_selected"):Show()
	self:SelectCreatureAbilityButton(i, 1)
	_G("DPSMate_Details_CurePoison_Log_ScrollButton"..i.."_selected"):Show()
end

function DPSMate.Modules.DetailsCurePoison:SelectCreatureAbilityButton(i, p)
	local line, lineplusoffset
	local obj = _G("DPSMate_Details_CurePoison_LogThree_ScrollFrame")
	obj.index = i
	local path = "DPSMate_Details_CurePoison_LogThree_ScrollButton"
	local len = DPSMate:TableLength(DmgArr[i][3][p][2])
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DmgArr[i][3][p][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DmgArr[i][3][p][2][lineplusoffset])
			_G(path..line.."_Name"):SetText(ability)
			_G(path..line.."_Value"):SetText(DmgArr[i][3][p][3][lineplusoffset].." ("..string.format("%.2f", 100*DmgArr[i][3][p][3][lineplusoffset]/DmgArr[i][3][p][1]).."%)")
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
		_G("DPSMate_Details_CurePoison_LogTwo_ScrollButton"..i.."_selected"):Hide()
	end
	_G("DPSMate_Details_CurePoison_LogTwo_ScrollButton"..p.."_selected"):Show()
end