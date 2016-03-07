-- Global Variables
DPSMate.Modules.DetailsDeaths = {}

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

function DPSMate.Modules.DetailsDeaths:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DPSMate_Details_Deaths_Title:SetText("Deaths of "..obj.user)
	DPSMate_Details_Deaths:Show()
	DPSMate.Modules.DetailsDeaths:ScrollFrame_Update()
	DPSMate.Modules.DetailsDeaths:SelectDetailsButton(1)
end

function DPSMate.Modules.DetailsDeaths:EvalTable()
	local arr = {}
	for cat, val in db[DPSMateUser[DetailsUser][1]] do -- user
		if val["i"][1] == 1 then
			table.insert(arr, {val[1][1], val["i"][2], val})
		end
	end
	return arr
end

function DPSMate.Modules.DetailsDeaths:ScrollFrame_Update()
	local line, lineplusoffset
	local obj = getglobal("DPSMate_Details_Deaths_Log_ScrollFrame")
	local arr = db
	DetailsArr = DPSMate.Modules.DetailsDeaths:EvalTable()
	local len = DPSMate:TableLength(DetailsArr)
	FauxScrollFrame_Update(obj,DPSMate:TableLength(arr),10,24)
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			getglobal("DPSMate_Details_Deaths_Log_ScrollButton"..line.."_Name"):SetText(DPSMate:GetUserById(DetailsArr[lineplusoffset][1]))
			getglobal("DPSMate_Details_Deaths_Log_ScrollButton"..line.."_Value"):SetText(DetailsArr[lineplusoffset][2])
			getglobal("DPSMate_Details_Deaths_Log_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
			if len < 14 then
				getglobal("DPSMate_Details_Deaths_Log_ScrollButton"..line):SetWidth(265)
				getglobal("DPSMate_Details_Deaths_Log_ScrollButton"..line.."_Name"):SetWidth(155)
			else
				getglobal("DPSMate_Details_Deaths_Log_ScrollButton"..line):SetWidth(250)
				getglobal("DPSMate_Details_Deaths_Log_ScrollButton"..line.."_Name"):SetWidth(140)
			end
			getglobal("DPSMate_Details_Deaths_Log_ScrollButton"..line):Show()
		else
			getglobal("DPSMate_Details_Deaths_Log_ScrollButton"..line):Hide()
		end
		getglobal("DPSMate_Details_Deaths_Log_ScrollButton"..line.."_selected"):Hide()
		if DetailsSelected == lineplusoffset then
			getglobal("DPSMate_Details_Deaths_Log_ScrollButton"..line.."_selected"):Show()
		end
	end
end

function DPSMate.Modules.DetailsDeaths:SelectDetailsButton(i)
	local obj = getglobal("DPSMate_Details_Deaths_Log_ScrollFrame")
	local lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
	local arr = db
	local user, pet = "", 0
	
	DetailsSelected = lineplusoffset
	for p=1, 14 do
		getglobal("DPSMate_Details_Deaths_Log_ScrollButton"..p.."_selected"):Hide()
	end
	getglobal("DPSMate_Details_Deaths_Log_ScrollButton"..i.."_selected"):Show()
	
	for cat, val in DetailsArr[i][3] do
		if cat~="i" then
			local name = DPSMate:GetUserById(val[1])
			local type,r,g,b = "HIT", DPSMate:GetClassColor(DPSMateUser[name][2])
			if val[4]==1 then type="CRIT" elseif val[4]==2 then type="CRUSH" end
			getglobal("DPSMate_Details_Deaths_LogDetails_Row"..cat.."_GameTime"):SetText(val[7])
			getglobal("DPSMate_Details_Deaths_LogDetails_Row"..cat.."_CombatTime"):SetText(ceil(val[6]).."s")
			getglobal("DPSMate_Details_Deaths_LogDetails_Row"..cat.."_Cause"):SetText(name)
			getglobal("DPSMate_Details_Deaths_LogDetails_Row"..cat.."_Cause"):SetTextColor(r,g,b,1)
			getglobal("DPSMate_Details_Deaths_LogDetails_Row"..cat.."_Ability"):SetText(DPSMate:GetAbilityById(val[2]))
			getglobal("DPSMate_Details_Deaths_LogDetails_Row"..cat.."_Type"):SetText(type)
			if val[5]==1 then
				getglobal("DPSMate_Details_Deaths_LogDetails_Row"..cat.."_HealIn"):SetText("+"..val[3])
				getglobal("DPSMate_Details_Deaths_LogDetails_Row"..cat.."_DamageIn"):SetText("")
			else
				getglobal("DPSMate_Details_Deaths_LogDetails_Row"..cat.."_HealIn"):SetText("")
				getglobal("DPSMate_Details_Deaths_LogDetails_Row"..cat.."_DamageIn"):SetText("-"..val[3])
			end
		end
	end
end

function DPSMate.Modules.DetailsDeaths:CreateGraphTable()
	local lines = {}
	for i=1, 11 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Deaths_LogDetails, 10, 375-i*30, 590, 375-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[12] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Deaths_LogDetails, 80, 370, 80, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
	
	lines[13] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Deaths_LogDetails, 160, 370, 160, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[13]:Show()
	
	lines[14] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Deaths_LogDetails, 260, 370, 260, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[14]:Show()
	
	lines[15] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Deaths_LogDetails, 360, 370, 360, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[15]:Show()
	
	lines[16] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Deaths_LogDetails, 410, 370, 410, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[16]:Show()
	
	lines[17] = DPSMate.Options.graph:DrawLine(DPSMate_Details_Deaths_LogDetails, 500, 370, 500, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[17]:Show()
end