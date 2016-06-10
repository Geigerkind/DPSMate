-- Global Variables
DPSMate.Modules.DetailsCureDiseaseReceived = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailsUser, DetailsSelected  = {}, 0, {}, "", 1
local g, g2
local curKey = 1
local db, cbt = {}, 0
local _G = getglobal

function DPSMate.Modules.DetailsCureDiseaseReceived:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DPSMate_Details_CureDiseaseReceived_Title:SetText("Disease cured of "..obj.user)
	DPSMate_Details_CureDiseaseReceived:Show()
	self:ScrollFrame_Update()
	self:SelectCreatureButton(1)
	self:SelectCreatureAbilityButton(1,1)
end

function DPSMate.Modules.DetailsCureDiseaseReceived:EvalTable()
	local b, a, temp, total = {}, {}, {}, 0
	for cat, val in pairs(db) do -- 3 Owner
		temp[cat] = {
			[1] = 0,
			[2] = {},
			[3] = {}
		}
		for ca, va in pairs(val) do -- 42 Ability
			if ca~="i" then
				local ta, tb, CV = {}, {}, 0
				for c, v in pairs(va) do -- 3 Target
					if c==DPSMateUser[DetailsUser][1] then
						for ce, ve in pairs(v) do
							if DPSMateAbility[DPSMate:GetAbilityById(ce)][2]=="Disease" then
								temp[cat][1]=temp[cat][1]+ve
								CV = CV + ve
								local i = 1
								while true do
									if (not tb[i]) then
										table.insert(tb, i, ve)
										table.insert(ta, i, ce)
										break
									else
										if tb[i] < ve then
											table.insert(tb, i, ve)
											table.insert(ta, i, ce)
											break
										end
									end
									i=i+1
								end
							end
						end
						break
					end
				end
				if CV>0 then
					local i = 1
					while true do
						if (not temp[cat][3][i]) then
							table.insert(temp[cat][3], i, {CV, ta, tb})
							table.insert(temp[cat][2], i, ca)
							break
						else
							if temp[cat][3][i][1] < CV then
								table.insert(temp[cat][3], i, {CV, ta, tb})
								table.insert(temp[cat][2], i, ca)
								break
							end
						end
						i=i+1
					end
				end
			end
		end
	end
	for cat, val in pairs(temp) do
		if val[1]>0 then
			local i = 1
			while true do
				if (not b[i]) then
					table.insert(b, i, val)
					table.insert(a, i, cat)
					break
				else
					if b[i][1] < val[1] then
						table.insert(b, i, val)
						table.insert(a, i, cat)
						break
					end
				end
				i=i+1
			end
			total = total + val[1]
		end
	end
	return a, total, b
end

function DPSMate.Modules.DetailsCureDiseaseReceived:ScrollFrame_Update()
	local line, lineplusoffset
	local obj = _G("DPSMate_Details_CureDiseaseReceived_Log_ScrollFrame")
	local path = "DPSMate_Details_CureDiseaseReceived_Log_ScrollButton"
	DetailsArr, DetailsTotal, DmgArr = DPSMate.Modules.DetailsCureDiseaseReceived:EvalTable()
	local len = DPSMate:TableLength(DetailsArr)
	FauxScrollFrame_Update(obj,len,14,24)
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			local user = DPSMate:GetUserById(DetailsArr[lineplusoffset])
			local r,g,b,img = DPSMate:GetClassColor(DPSMateUser[user][2])
			_G(path..line.."_Name"):SetText(user)
			_G(path..line.."_Name"):SetTextColor(r,g,b)
			_G(path..line.."_Value"):SetText(DmgArr[lineplusoffset][1].." ("..string.format("%.2f", 100*DmgArr[lineplusoffset][1]/DetailsTotal).."%)")
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
end

function DPSMate.Modules.DetailsCureDiseaseReceived:SelectCreatureButton(i)
	local line, lineplusoffset
	local obj = _G("DPSMate_Details_CureDiseaseReceived_LogTwo_ScrollFrame")
	obj.index = i
	local path = "DPSMate_Details_CureDiseaseReceived_LogTwo_ScrollButton"
	local len = DPSMate:TableLength(DmgArr[i][2])
	FauxScrollFrame_Update(obj,len,14,24)
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DmgArr[i][2][lineplusoffset] ~= nil then
			local ability = DPSMate:GetAbilityById(DmgArr[i][2][lineplusoffset])
			_G(path..line.."_Name"):SetText(ability)
			_G(path..line.."_Value"):SetText(DmgArr[i][3][lineplusoffset][1].." ("..string.format("%.2f", 100*DmgArr[i][3][lineplusoffset][1]/DmgArr[i][1]).."%)")
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
	for p=1, 14 do
		_G("DPSMate_Details_CureDiseaseReceived_Log_ScrollButton"..p.."_selected"):Hide()
	end
	_G(path.."1_selected"):Show()
	self:SelectCreatureAbilityButton(i, 1)
	_G("DPSMate_Details_CureDiseaseReceived_Log_ScrollButton"..i.."_selected"):Show()
end

function DPSMate.Modules.DetailsCureDiseaseReceived:SelectCreatureAbilityButton(i, p)
	local line, lineplusoffset
	local obj = _G("DPSMate_Details_CureDiseaseReceived_LogThree_ScrollFrame")
	obj.index = i
	local path = "DPSMate_Details_CureDiseaseReceived_LogThree_ScrollButton"
	local len = DPSMate:TableLength(DmgArr[i][3][p][2])
	FauxScrollFrame_Update(obj,len,14,24)
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
		_G("DPSMate_Details_CureDiseaseReceived_LogTwo_ScrollButton"..i.."_selected"):Hide()
	end
	_G("DPSMate_Details_CureDiseaseReceived_LogTwo_ScrollButton"..p.."_selected"):Show()
end