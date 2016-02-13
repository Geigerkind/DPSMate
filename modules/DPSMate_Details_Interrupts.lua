-- Global Variables
DPSMate.Modules.DetailsInterrupts = {}

-- Local variables
local DetailsArr, DetailsTotal, DmgArr, DetailUser, DetailsSelected  = {}, 0, {}, "", 1
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

function DPSMate.Modules.DetailsInterrupts:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DPSMate_Details_Interrupts_Title:SetText("Interrupts by "..obj.user)
	DPSMate_Details_Interrupts:Show()
	DPSMate.Modules.DetailsInterrupts:ScrollFrame_Update()
	DPSMate.Modules.DetailsInterrupts:SelectCreatureButton(1)
	DPSMate.Modules.DetailsInterrupts:SelectCreatureAbilityButton(1,1)
end

function DPSMate.Modules.DetailsInterrupts:EvalTable()
	local a, b, total = {}, {}, 0
	for cat, val in pairs(db[DPSMateUser[DetailsUser][1]]) do -- 41 Ability
		if cat~="i" then
			local CV, ta, tb = 0, {}, {}
			for ca, va in pairs(val) do
				local taa, tbb = {}, {}
				for c, v in pairs(va) do
					CV = CV + v
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
				local i = 1
				while true do
					if (not tb[i]) then
						table.insert(tb, i, {CV, taa, tbb})
						table.insert(ta, i, ca)
						break
					else
						if tb[i][1] < CV then
							table.insert(tb, i, {CV, taa, tbb})
							table.insert(ta, i, ca)
							break
						end
					end
					i=i+1
				end
			end
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
			total = total + CV
		end
	end
	return a, total, b
end

function DPSMate.Modules.DetailsInterrupts:ScrollFrame_Update()
	local line, lineplusoffset
	local obj = getglobal("DPSMate_Details_Interrupts_Log_ScrollFrame")
	local path = "DPSMate_Details_Interrupts_Log_ScrollButton"
	DetailsArr, DetailsTotal, DmgArr = DPSMate.Modules.DetailsInterrupts:EvalTable()
	local len = DPSMate:TableLength(DetailsArr)
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			getglobal(path..line.."_Name"):SetText(DPSMate:GetAbilityById(DetailsArr[lineplusoffset]))
			getglobal(path..line.."_Value"):SetText(DmgArr[lineplusoffset][1].." ("..(100*DmgArr[lineplusoffset][1]/DetailsTotal).."%)")
			getglobal(path..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
			if len < 14 then
				getglobal(path..line):SetWidth(235)
				getglobal(path..line.."_Name"):SetWidth(125)
			else
				getglobal(path..line):SetWidth(220)
				getglobal(path..line.."_Name"):SetWidth(110)
			end
			getglobal(path..line):Show()
		else
			getglobal(path..line):Hide()
		end
		getglobal(path..line.."_selected"):Hide()
		if DetailsSelected == lineplusoffset then
			getglobal(path..line.."_selected"):Show()
		end
	end
end

function DPSMate.Modules.DetailsInterrupts:SelectCreatureButton(i)
	local line, lineplusoffset
	local obj = getglobal("DPSMate_Details_Interrupts_LogTwo_ScrollFrame")
	obj.index = i
	local path = "DPSMate_Details_Interrupts_LogTwo_ScrollButton"
	local len = DPSMate:TableLength(DmgArr[i][2])
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DmgArr[i][2][lineplusoffset] ~= nil then
			getglobal(path..line.."_Name"):SetText(DPSMate:GetUserById(DmgArr[i][2][lineplusoffset]))
			getglobal(path..line.."_Value"):SetText(DmgArr[i][3][lineplusoffset][1].." ("..(100*DmgArr[i][3][lineplusoffset][1]/DmgArr[i][1]).."%)")
			getglobal(path..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
			if len < 14 then
				getglobal(path..line):SetWidth(235)
				getglobal(path..line.."_Name"):SetWidth(125)
			else
				getglobal(path..line):SetWidth(220)
				getglobal(path..line.."_Name"):SetWidth(110)
			end
			getglobal(path..line):Show()
		else
			getglobal(path..line):Hide()
		end
		getglobal(path..line.."_selected"):Hide()
	end
	for p=1, 14 do
		getglobal("DPSMate_Details_Interrupts_Log_ScrollButton"..p.."_selected"):Hide()
	end
	getglobal(path.."1_selected"):Show()
	DPSMate.Modules.DetailsInterrupts:SelectCreatureAbilityButton(i, 1)
	getglobal("DPSMate_Details_Interrupts_Log_ScrollButton"..i.."_selected"):Show()
end

function DPSMate.Modules.DetailsInterrupts:SelectCreatureAbilityButton(i, p)
	local line, lineplusoffset
	local obj = getglobal("DPSMate_Details_Interrupts_LogThree_ScrollFrame")
	obj.index = i
	local path = "DPSMate_Details_Interrupts_LogThree_ScrollButton"
	local len = DPSMate:TableLength(DmgArr[i][3][p][2])
	FauxScrollFrame_Update(obj,len,10,24)
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DmgArr[i][3][p][2][lineplusoffset] ~= nil then
			getglobal(path..line.."_Name"):SetText(DPSMate:GetAbilityById(DmgArr[i][3][p][2][lineplusoffset]))
			getglobal(path..line.."_Value"):SetText(DmgArr[i][3][p][3][lineplusoffset].." ("..(100*DmgArr[i][3][p][3][lineplusoffset]/DmgArr[i][3][p][1]).."%)")
			getglobal(path..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
			if len < 14 then
				getglobal(path..line):SetWidth(235)
				getglobal(path..line.."_Name"):SetWidth(125)
			else
				getglobal(path..line):SetWidth(220)
				getglobal(path..line.."_Name"):SetWidth(110)
			end
			getglobal(path..line):Show()
		else
			getglobal(path..line):Hide()
		end
		getglobal(path..line.."_selected"):Hide()
	end
	for i=1, 14 do
		getglobal("DPSMate_Details_Interrupts_LogTwo_ScrollButton"..i.."_selected"):Hide()
	end
	getglobal("DPSMate_Details_Interrupts_LogTwo_ScrollButton"..p.."_selected"):Show()
end