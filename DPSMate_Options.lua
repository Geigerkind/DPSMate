-- Global Variables

-- Local Variables
local LastPopUp = GetTime()
local TimeToNextPopUp = 300
local PartyNum = GetNumPartyMembers()
local Dewdrop = AceLibrary("Dewdrop-2.0")
local graph = AceLibrary("Graph-1.0")
local Options = {
	[1] = {
		type = 'group',
		args = {
			dps = {
				order = 10,
				type = 'toggle',
				name = "DPS",
				desc = DPSMate.localization.desc.dps,
				get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][1]["dps"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "dps", Dewdrop:GetOpenedParent()) end,
			},
			damage = {
				order = 20,
				type = 'toggle',
				name = "Damage",
				desc = DPSMate.localization.desc.damage,
				get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][1]["damage"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "damage", Dewdrop:GetOpenedParent()) end,
			},
			damagetaken = {
				order = 30,
				type = 'toggle',
				name = "Damage taken",
				desc = DPSMate.localization.desc.damagetaken,
				get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][1]["damagetaken"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "damagetaken", Dewdrop:GetOpenedParent()) end,
			},
			enemydamagedone = {
				order = 40,
				type = 'toggle',
				name = "Enemy damage done",
				desc = DPSMate.localization.desc.enemydmgdone,
				get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][1]["enemydamagedone"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "enemydamagedone", Dewdrop:GetOpenedParent()) end,
			},
			enemydamagetaken = {
				order = 50,
				type = 'toggle',
				name = "Enemy damage taken",
				desc = DPSMate.localization.desc.enemydmgtaken,
				get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][1]["enemydamagetaken"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "enemydamagetaken", Dewdrop:GetOpenedParent()) end,
			},
			healing = {
				order = 60,
				type = 'toggle',
				name = "Healing",
				desc = DPSMate.localization.desc.healing,
				get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][1]["healing"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "healing", Dewdrop:GetOpenedParent()) end,
			},
			healingandabsorbs = {
				order = 70,
				type = 'toggle',
				name = "Healing and Absorbs",
				desc = DPSMate.localization.desc.healingandabsorbs,
				get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][1]["healingandabsorbs"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "healingandabsorbs", Dewdrop:GetOpenedParent()) end,
			},
			healingtaken = {
				order = 80,
				type = 'toggle',
				name = "Healing taken",
				desc = DPSMate.localization.desc.healingtaken,
				get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][1]["healingtaken"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "healingtaken", Dewdrop:GetOpenedParent()) end,
			},
			overhealing = {
				order = 90,
				type = 'toggle',
				name = "Overhealing",
				desc = DPSMate.localization.desc.overhealing,
				get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][1]["overhealing"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "overhealing", Dewdrop:GetOpenedParent()) end,
			},
			interrupts = {
				order = 100,
				type = 'toggle',
				name = "Interrupts",
				desc = DPSMate.localization.desc.interrupts,
				get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][1]["interrupts"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "interrupts", Dewdrop:GetOpenedParent()) end,
			},
			deaths = {
				order = 110,
				type = 'toggle',
				name = "Deaths",
				desc = DPSMate.localization.desc.deaths,
				get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][1]["deaths"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "deaths", Dewdrop:GetOpenedParent()) end,
			},
			dispels = {
				order = 120,
				type = 'toggle',
				name = "Dispels",
				desc = DPSMate.localization.desc.dispels,
				get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][1]["dispels"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "dispels", Dewdrop:GetOpenedParent()) end,
			},
		},
		handler = DPSMate.Options,
	},
	[2] = {
		type = 'group',
		args = {
			total = {
				order = 10,
				type = 'toggle',
				name = "Total",
				desc = DPSMate.localization.desc.total,
				get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][2]["total"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(2, "total", Dewdrop:GetOpenedParent()) end,
			},
			currentFight = {
				order = 20,
				type = 'toggle',
				name = "Current fight",
				desc = DPSMate.localization.desc.current,
				get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][2]["currentfight"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(2, "currentfight", Dewdrop:GetOpenedParent()) end,
			},
		},
		handler = DPSMate.Options,
	},
	[3] = {
		type = 'group',
		args = {
			report = {
				order = 10,
				type = 'execute',
				name = "Report",
				desc = DPSMate.localization.desc.report,
				func = function() DPSMate_Report:Show(); Dewdrop:Close() end,
			},
			reset = {
				order = 11,
				type = 'execute',
				name = "Reset",
				desc = DPSMate.localization.desc.reset,
				func = "PopUpAccept",
			},
			blank1 = {
				order = 20,
				type = 'header',
			},
			startnewsegment = {
				order = 25,
				type = 'execute',
				name = "Start new segment",
				desc = DPSMate.localization.desc.newsegment,
				func = function() DPSMate.Options:NewSegment(); Dewdrop:Close() end,
			},
			deletesegment = {
				order = 30,
				type = 'group',
				name = "Remove segment",
				desc = DPSMate.localization.desc.removesegment,
				args = {},
			},
			blank2 = {
				order = 35,
				type = 'header',
			},
			lock = {
				order = 40,
				type = 'toggle',
				name = "Lock window",
				desc = DPSMate.localization.desc.lock,
				get = function() return DPSMateSettings["lock"] end,
				set = function() DPSMate.Options:Lock(); Dewdrop:Close() end,
			},
			unlock = {
				order = 40,
				type = 'toggle',
				name = "Unlock window",
				desc = DPSMate.localization.desc.lock,
				get = function() return not DPSMateSettings["lock"] end,
				set = function() DPSMate.Options:Unlock(); Dewdrop:Close() end,
			},
			hide = {
				order = 50,
				type = 'execute',
				name = "Hide window",
				desc = DPSMate.localization.desc.hide,
				func = function() DPSMate.Options:Hide(Dewdrop:GetOpenedParent()); Dewdrop:Close() end,
			},
			configure = {
				order = 80,
				type = 'execute',
				name = "Configure",
				desc = DPSMate.localization.desc.config,
				func = function() DPSMate_ConfigMenu:Show(); Dewdrop:Close() end,
			},
			close = {
				order = 90,
				type = 'execute',
				name = "Close",
				desc = DPSMate.localization.desc.close,
				func = function() Dewdrop:Close() end,
			},
		},
		handler = DPSMate.Options,
	},
}
local DetailsUser = ""
local DetailsSelected = 1
local DetailsArr, DetailsTotal
local PieChart = true
local g, g2
local icons = {
	-- General
	["AutoAttack"] = "Interface\\ICONS\\inv_sword_39",
	["Lightning Strike"] = "Interface\\ICONS\\spell_holy_mindvision",
	["Fatal Wound"] = "Interface\\ICONS\\ability_backstab",
	["Falling"] = "Interface\\ICONS\\spell_magic_featherfall",
	
	-- Rogues
	["Sinister Strike"] = "Interface\\ICONS\\spell_shadow_ritualofsacrifice",
	["Blade Flurry"] = "Interface\\ICONS\\ability_warrior_punishingblow",
	["Eviscerate"] = "Interface\\ICONS\\ability_rogue_eviscerate",
	["Garrote(Periodic)"] = "Interface\\ICONS\\ability_rogue_garrote",
	["Rupture(Periodic)"] = "Interface\\ICONS\\ability_rogue_rupture",
}

-- Begin Functions

function DPSMate.Options:OnEvent(event)
	if event == "PARTY_MEMBERS_CHANGED" and DPSMate.Options:IsInParty() and DPSMate.Options:PartyMemberAmountChanged() then
		if (GetTime()-LastPopUp) > TimeToNextPopUp and (DPSMateUser ~= {} and DPSMateUserCurrent ~= {}) then -- To prevent spam
			LastPopUp = GetTime()
			DPSMate_PopUp:Show()
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		if (DPSMateUser ~= {} and DPSMateUserCurrent ~= {}) then
			DPSMate_PopUp:Show()
		end
	end
end

function DPSMate.Options:IsInParty()
	if GetNumPartyMembers() > 0 or UnitInRaid("player") then
		return true
	else
		PartyNum = GetNumPartyMembers()
		return false
	end
end

function DPSMate.Options:PartyMemberAmountChanged()
	if GetNumPartyMembers() ~= PartyNum then
		PartyNum = GetNumPartyMembers()
		return true
	else
		return false
	end
end

function DPSMate.Options:PopUpAccept()
	DPSMate_PopUp:Hide()
	DPSMateUser = {}
	DPSMateUserCurrent = {}
	DPSMateHistory = {}
	DPSMateCombatTime = {
		total = 1,
		current = 1,
		segments = {},
	}
	DPSMate:HideStatusBars()
end

function DPSMate.Options:OpenMenu(b, obj)
	for _, val in pairs(DPSMateSettings.windows) do
		if Dewdrop:IsOpen(getglobal("DPSMate_"..val["name"])) then
			Dewdrop:Close()
			return
		end
	if Dewdrop:IsRegistered(getglobal("DPSMate_"..val["name"])) then Dewdrop:Unregister(getglobal("DPSMate_"..val["name"])) end
	end
	Dewdrop:Register(obj,
		'children', function() 
			Dewdrop:FeedAceOptionsTable(Options[b]) 
		end,
		'cursorX', true,
		'cursorY', true,
		'dontHook', true
	)
	Dewdrop:Open(obj)
end

function DPSMate.Options:ToggleDrewDrop(i, obj, pa)
	if not DPSMate:WindowsExist() then return end
	for cat, _ in pairs(DPSMateSettings["windows"][pa.Key]["options"][i]) do
		DPSMateSettings["windows"][pa.Key]["options"][i][cat] = false
	end
	DPSMateSettings["windows"][pa.Key]["options"][i][obj] = true
	if i == 1 then
		getglobal(pa:GetName().."_Head_Font"):SetText(Options[i]["args"][obj].name)
		DPSMateSettings["windows"][pa.Key]["CurMode"] = obj
	elseif i == 2 then
	elseif i == 3 then end
	Dewdrop:Close()
	if DPSMate.DB.loaded then DPSMate:SetStatusBarValue() end
	return true
end

function DPSMate.Options:ScrollFrame_Update()
	local line, lineplusoffset
	local obj = getglobal("DPSMate_Details_Log_ScrollFrame")
	local arr = DPSMate:GetMode(DPSMate_Details.PaKey)
	local user, pet, len = "", 0, DPSMate:TableLength(arr[DetailsUser])-5
	DetailsArr, DetailsTotal = DPSMate.Options:EvalTable(DetailsUser)
	FauxScrollFrame_Update(obj,DPSMate:TableLength(arr),10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			if (arr[DetailsUser][DetailsArr[lineplusoffset]]) then user=DetailsUser;pet=0; else user=arr[DetailsUser].pet;pet=5; end
			local ability = strsub(DetailsArr[lineplusoffset], 1, strlen(DetailsArr[lineplusoffset])-pet)
			getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Name"):SetText(DetailsArr[lineplusoffset])
			getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Value"):SetText(arr[user][ability].amount.." ("..string.format("%.2f", (arr[user][ability].amount*100/DetailsTotal)).."%)")
			if icons[ability] then
				getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Icon"):SetTexture(icons[ability])
			else
				getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\dummy")
			end
			if len < 10 then
				getglobal("DPSMate_Details_Log_ScrollButton"..line):SetWidth(235)
				getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Name"):SetWidth(125)
			else
				getglobal("DPSMate_Details_Log_ScrollButton"..line):SetWidth(220)
				getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Name"):SetWidth(110)
			end
			getglobal("DPSMate_Details_Log_ScrollButton"..line):Show()
		else
			getglobal("DPSMate_Details_Log_ScrollButton"..line):Hide()
		end
		getglobal("DPSMate_Details_Log_ScrollButton"..line.."_selected"):Hide()
		if DetailsSelected == lineplusoffset then
			getglobal("DPSMate_Details_Log_ScrollButton"..line.."_selected"):Show()
		end
	end
end

function DPSMate.Options:EvalTable(t)
	local a, u, p = {}, {}, {}
	local total, pet = 0, ""
	local arr = DPSMate:GetMode(DPSMate_Details.PaKey)
	if (arr[t].pet and arr[t].pet ~= "Unknown") then u={a=t, b=arr[t].pet} else u={a=t} end
	for c, v in pairs(u) do
		for cat, val in pairs(arr[v]) do
			if (type(val) == "table" and cat~="dmgTime" and cat~="procs") then
				if (arr[v].isPet) then pet="(Pet)"; else pet=""; end
				local i = 1
				while true do
					if (not a[i]) then
						table.insert(a, i, cat..pet)
						p[cat..pet] = arr[v][cat].amount
						break
					else
						if (p[a[i]] < val.amount) then
							table.insert(a, i, cat..pet)
							p[cat..pet] = arr[v][cat].amount
							break
						end
					end
					i = i + 1
				end
			end
		end
		total=total+arr[v].damage
	end
	return a, total
end

function DPSMate.Options:SelectDetailsButton(i)
	local obj = getglobal("DPSMate_Details_Log_ScrollFrame")
	local lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
	local arr = DPSMate:GetMode(DPSMate_Details.PaKey)
	local user, pet = "", 0
	
	DetailsSelected = lineplusoffset
	for p=1, 10 do
		getglobal("DPSMate_Details_Log_ScrollButton"..p.."_selected"):Hide()
	end
	if (arr[DetailsUser][DetailsArr[lineplusoffset]]) then user=DetailsUser; pet=0; else user=arr[DetailsUser].pet; pet=5; end
	getglobal("DPSMate_Details_Log_ScrollButton"..i.."_selected"):Show()
	
	local ability = strsub(DetailsArr[lineplusoffset], 1, strlen(DetailsArr[lineplusoffset])-pet)
	local hit, crit, miss, parry, dodge, resist, hitMin, hitMax, critMin, critMax = arr[user][ability].hit, arr[user][ability].crit, arr[user][ability].miss, arr[user][ability].parry, arr[user][ability].dodge, arr[user][ability].resist, arr[user][ability].hitlow, arr[user][ability].hithigh, arr[user][ability].critlow, arr[user][ability].crithigh
	local total, max = hit+crit+miss+parry+dodge+resist, DPSMate:TMax({hit, crit, miss, parry, dodge, resist})
	
	-- Hit
	getglobal("DPSMate_Details_LogDetails_Amount1_Amount"):SetText(hit)
	getglobal("DPSMate_Details_LogDetails_Amount1_Percent"):SetText(ceil(100*hit/total).."%")
	getglobal("DPSMate_Details_LogDetails_Amount1_StatusBar"):SetValue(ceil(100*hit/max))
	getglobal("DPSMate_Details_LogDetails_Amount1_StatusBar"):SetStatusBarColor(0.9,0.0,0.0,1)
	getglobal("DPSMate_Details_LogDetails_Average1"):SetText((hitMin+hitMax)/2)
	getglobal("DPSMate_Details_LogDetails_Min1"):SetText(hitMin)
	getglobal("DPSMate_Details_LogDetails_Max1"):SetText(hitMax)
	
	-- Crit
	getglobal("DPSMate_Details_LogDetails_Amount2_Amount"):SetText(crit)
	getglobal("DPSMate_Details_LogDetails_Amount2_Percent"):SetText(ceil(100*crit/total).."%")
	getglobal("DPSMate_Details_LogDetails_Amount2_StatusBar"):SetValue(ceil(100*crit/max))
	getglobal("DPSMate_Details_LogDetails_Amount2_StatusBar"):SetStatusBarColor(0.0,0.9,0.0,1)
	getglobal("DPSMate_Details_LogDetails_Average2"):SetText((critMin+critMax)/2)
	getglobal("DPSMate_Details_LogDetails_Min2"):SetText(critMin)
	getglobal("DPSMate_Details_LogDetails_Max2"):SetText(critMax)
	
	-- Miss
	getglobal("DPSMate_Details_LogDetails_Amount3_Amount"):SetText(miss)
	getglobal("DPSMate_Details_LogDetails_Amount3_Percent"):SetText(ceil(100*miss/total).."%")
	getglobal("DPSMate_Details_LogDetails_Amount3_StatusBar"):SetValue(ceil(100*miss/max))
	getglobal("DPSMate_Details_LogDetails_Amount3_StatusBar"):SetStatusBarColor(0.0,0.0,1.0,1)
	getglobal("DPSMate_Details_LogDetails_Average3"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Min3"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Max3"):SetText("-")
	
	-- Parry
	getglobal("DPSMate_Details_LogDetails_Amount4_Amount"):SetText(parry)
	getglobal("DPSMate_Details_LogDetails_Amount4_Percent"):SetText(ceil(100*parry/total).."%")
	getglobal("DPSMate_Details_LogDetails_Amount4_StatusBar"):SetValue(ceil(100*parry/max))
	getglobal("DPSMate_Details_LogDetails_Amount4_StatusBar"):SetStatusBarColor(1.0,1.0,0.0,1)
	getglobal("DPSMate_Details_LogDetails_Average4"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Min4"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Max4"):SetText("-")
	
	-- Dodge
	getglobal("DPSMate_Details_LogDetails_Amount5_Amount"):SetText(dodge)
	getglobal("DPSMate_Details_LogDetails_Amount5_Percent"):SetText(ceil(100*dodge/total).."%")
	getglobal("DPSMate_Details_LogDetails_Amount5_StatusBar"):SetValue(ceil(100*dodge/max))
	getglobal("DPSMate_Details_LogDetails_Amount5_StatusBar"):SetStatusBarColor(1.0,0.0,1.0,1)
	getglobal("DPSMate_Details_LogDetails_Average5"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Min5"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Max5"):SetText("-")
	
	-- Resist
	getglobal("DPSMate_Details_LogDetails_Amount6_Amount"):SetText(resist)
	getglobal("DPSMate_Details_LogDetails_Amount6_Percent"):SetText(ceil(100*resist/total).."%")
	getglobal("DPSMate_Details_LogDetails_Amount6_StatusBar"):SetValue(ceil(100*resist/max))
	getglobal("DPSMate_Details_LogDetails_Amount6_StatusBar"):SetStatusBarColor(0.0,1.0,1.0,1)
	getglobal("DPSMate_Details_LogDetails_Average6"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Min6"):SetText("-")
	getglobal("DPSMate_Details_LogDetails_Max6"):SetText("-")
end

function DPSMate.Options:UpdatePie()
	local i = 1
	local arr = DPSMate:GetMode(DPSMate_Details.PaKey)
	local user,pet = "",0
	g:ResetPie()
	for cat, val in pairs(DetailsArr) do
		if (arr[DetailsUser][DetailsArr[i]]) then user=DetailsUser;pet=0; else user=arr[DetailsUser].pet;pet=5; end
		local percent = (arr[user][strsub(DetailsArr[i], 1, strlen(DetailsArr[i])-pet)].amount*100/DetailsTotal)
		g:AddPie(percent, 0)
		i = i + 1
	end
end

function DPSMate.Options:UpdateDetails(obj)
	DPSMate_Details.PaKey = obj:GetParent():GetParent():GetParent().Key
	DetailsUser = obj.user
	DPSMate_Details.LastUser = ""
	if (PieChart) then
		g=graph:CreateGraphPieChart("PieChart", DPSMate_Details_Diagram, "CENTER", "CENTER", 0, 0, 200, 200)
		g2=graph:CreateGraphLine("LineGraph",DPSMate_Details_DiagramLine,"CENTER","CENTER",0,0,850,230)
		PieChart = false
	end
	DPSMate_Details_Title:SetText("Combat details of "..obj.user)
	DPSMate_Details:Show()
	UIDropDownMenu_Initialize(DPSMate_Details_DiagramLegend_Procs, DPSMate.Options.ProcsDropDown)
	DPSMate.Options:ScrollFrame_Update()
	DPSMate.Options:SelectDetailsButton(1)
	DPSMate.Options:UpdatePie()
	DPSMate.Options:UpdateLineGraph()
end

function DPSMate.Options:UpdateLineGraph()
	local arr, cbt = DPSMate:GetMode(DPSMate_Details.PaKey)
	local sumTable = DPSMate.Options:GetSummarizedTable(DPSMate_Details.PaKey)
	local max = DPSMate.Options:GetMaxLineVal(sumTable)
	
	g2:ResetData()
	g2:SetXAxis(0,cbt)
	g2:SetYAxis(0,max+200)
	g2:SetGridSpacing(cbt/10,max/7)
	g2:SetGridColor({0.5,0.5,0.5,0.5})
	g2:SetAxisDrawing(true,true)
	g2:SetAxisColor({1.0,1.0,1.0,1.0})
	g2:SetAutoScale(true)
	g2:SetYLabels(true, false)
	g2:SetXLabels(true)

	local Data1={{0,0}}
	for cat, val in pairs(DPSMate.Options:SortLineTable(sumTable)) do
		
		if DPSMate.Options:CheckProcs(DPSMate_Details.proc, arr, val[1]) then
			table.insert(Data1, {val[1],val[2], true})
		else
			table.insert(Data1, {val[1],val[2], false})
		end
	end

	g2:AddDataSeries(Data1,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}})
end

function DPSMate.Options:CheckProcs(name, arr, val)
	if DPSMate.DB:DataExistProcs(DetailsUser, name, arr) then
		for i=1, DPSMate:TableLength(arr[DetailsUser]["procs"][name]["start"]) do
			if not DPSMateUser[DetailsUser]["procs"][name]["start"][i] or not DPSMateUser[DetailsUser]["procs"][name]["ending"][i] then return false end
			if val >  DPSMateUser[DetailsUser]["procs"][name]["start"][i] and val < DPSMateUser[DetailsUser]["procs"][name]["ending"][i] then
				return true
			end
		end
	end
	return false
end

function DPSMate.Options:GetSummarizedTable(k)
	local arr,_ = DPSMate:GetMode(k)
	local newArr, lastCBT, x, y, lastCBTVal = {}, 0, 0, 0, {}
	
	for cat, val in pairs(arr[DetailsUser]["dmgTime"]) do
		if (cat>=(lastCBT-0.05) and cat<=(lastCBT+0.05)) then
			local key = DPSMate:GetKeyByValInTT(newArr, x, 1)
			y = newArr[key][2]+val
			table.remove(newArr, key)
			table.insert(newArr, {lastCBT,y})
		else
			x=tonumber(string.format("%.1f", cat))
			y=val
			table.insert(newArr, {x, y})
			lastCBT=x
			lastCBTVal={x,y}
		end
	end
	
	return newArr
end

function DPSMate.Options:SortLineTable(t)
	local newArr, minVal = {}, 10000000
	for cat, val in pairs(t) do
		if val[1]<minVal then
			table.insert(newArr, 1, val)
			minVal=val[1]
		else
			local i=1
			while true do
				if (not newArr[i]) then 
					table.insert(newArr, i, val)
					break
				end
				if val[1]<newArr[i][1] then
					table.insert(newArr, i, val)
					break
				end
				i=i+1
			end
		end
	end
	return newArr
end

function DPSMate.Options:GetMaxLineVal(t)
	local max = 0
	for cat, val in pairs(t) do
		if val[2]>max then
			max=val[2]
		end
	end
	return max
end

function DPSMate.Options:ChannelDropDown()
	local channel, i = {[1]="Whisper",[2]="Raid",[3]="Party",[4]="Say",[5]="Officer",[6]="Guild"}, 1
	
    local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_Report_Channel, this.value)
    end
	
	-- Adding dynamic channel
	while true do
		local id, name = GetChannelName(i);
		if (not name) then break end
		table.insert(channel, name)
		i=i+1
	end
	
	-- Initializing channel
	for cat, val in pairs(channel) do
		UIDropDownMenu_AddButton{
			text = val,
			value = val,
			func = on_click,
		}
	end
	
	UIDropDownMenu_SetSelectedValue(DPSMate_Report_Channel, "Raid")
end

function DPSMate.Options:ProcsDropDown()
	local arr, cbt = DPSMate:GetMode(DPSMate_Details.PaKey)
	DPSMate_Details.proc = "None"
	
    local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_Details_DiagramLegend_Procs, this.value)
		DPSMate_Details.proc = this.value
		DPSMate.Options:UpdateLineGraph()
    end
	
	UIDropDownMenu_AddButton{
		text = "None",
		value = "None",
		func = on_click,
	}
	
	-- Adding dynamic channel
	for cat,_ in pairs(arr[DetailsUser]["procs"]) do
		UIDropDownMenu_AddButton{
			text = cat,
			value = cat,
			func = on_click,
		}
	end
	
	if DPSMate_Details.LastUser~=DetailsUser then
		UIDropDownMenu_SetSelectedValue(DPSMate_Details_DiagramLegend_Procs, "None")
	end
	DPSMate_Details.LastUser = DetailsUser
end

function DPSMate.Options:Report()
	local channel = UIDropDownMenu_GetSelectedValue(DPSMate_Report_Channel)
	local chn, index, sortedTable, total, a = nil, nil, DPSMate:GetSortedTable(DPSMate:GetMode(DPSMate_Report.Key))
	if (channel == "Whisper") then
		chn = "WHISPER"; index = DPSMate_Report_Editbox:GetText();
	elseif DPSMate:TContains({[1]="Raid",[2]="Party",[3]="Say",[4]="Officer",[5]="Guild"}, channel) then
		chn = channel
	else
		chn = "CHANNEL"; index = GetChannelName(channel)
	end
	SendChatMessage("DPSMate - "..DPSMate.localization.reportfor..DPSMate:GetModeName(DPSMate_Report.Key), chn, nil, index)
	for i=1, DPSMate_Report_Lines:GetValue() do
		if (not sortedTable[i]) then break end
		SendChatMessage(i..". "..a[sortedTable[i]].." ................... "..sortedTable[i].." ("..string.format("%.1f", 100*sortedTable[i]/total).."%)", chn, nil, index)
	end
	DPSMate_Report:Hide()
end

function DPSMate.Options:NewSegment()
	if DPSMateUserCurrent ~= {} then
		table.insert(DPSMateHistory, 1, DPSMateUserCurrent)
		table.insert(DPSMateCombatTime["segments"], 1, DPSMateCombatTime["current"])
		if DPSMate:TableLength(DPSMateHistory)>5 then
			table.remove(DPSMateHistory, 6)
		end
		if DPSMate:TableLength(DPSMateCombatTime["segments"])>5 then
			table.remove(DPSMateCombatTime["segments"], 6)
		end
		DPSMateUserCurrent = {}
		DPSMateCombatTime["current"] = 1
		DPSMate:SetStatusBarValue()
	end
	DPSMate.Options:InitializeSegments()
	Dewdrop:Close()
end

function DPSMate.Options:InitializeSegments()
	local i=1
	Options[2]["args"] = {
		total = {
			order = 10,
			type = 'toggle',
			name = "Total",
			desc = DPSMate.localization.desc.total,
			get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][2]["total"] end,
			set = function() DPSMate.Options:ToggleDrewDrop(2, "total", Dewdrop:GetOpenedParent()) end,
		},
		currentFight = {
			order = 20,
			type = 'toggle',
			name = "Current fight",
			desc = DPSMate.localization.desc.current,
			get = function() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][2]["currentfight"] end,
			set = function() DPSMate.Options:ToggleDrewDrop(2, "currentfight", Dewdrop:GetOpenedParent()) end,
		},
	}
	Options[3]["args"]["deletesegment"]["args"] = {}
	for cat, val in pairs(DPSMateHistory) do
		Options[2]["args"]["segment"..i] = {
			order = 20+i*10,
			type = 'toggle',
			name = "Segment "..i,
			desc = "Fight deatails for segment "..i,
			get = "DropDownGetSegment"..i,
			set = "DropDownSetSegment"..i,
		}
		Options[3]["args"]["deletesegment"]["args"]["segment"..i] = {
			order = i*10,
			type = 'execute',
			name = "Segment "..i,
			desc = "Remove segment "..i,
			func = "deletesegment"..i,
		}
		i=i+1
	end
end

function DPSMate.Options:DropDownGetSegment1() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][2]["segment1"] end
function DPSMate.Options:DropDownGetSegment2() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][2]["segment2"] end
function DPSMate.Options:DropDownGetSegment3() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][2]["segment3"] end
function DPSMate.Options:DropDownGetSegment4() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][2]["segment4"] end
function DPSMate.Options:DropDownGetSegment5() return DPSMateSettings["windows"][Dewdrop:GetOpenedParent().Key]["options"][2]["segment5"] end

function DPSMate.Options:DropDownSetSegment1() DPSMate.Options:ToggleDrewDrop(2, "segment1", Dewdrop:GetOpenedParent()) end
function DPSMate.Options:DropDownSetSegment2() DPSMate.Options:ToggleDrewDrop(2, "segment2", Dewdrop:GetOpenedParent()) end
function DPSMate.Options:DropDownSetSegment3() DPSMate.Options:ToggleDrewDrop(2, "segment3", Dewdrop:GetOpenedParent()) end
function DPSMate.Options:DropDownSetSegment4() DPSMate.Options:ToggleDrewDrop(2, "segment4", Dewdrop:GetOpenedParent()) end
function DPSMate.Options:DropDownSetSegment5() DPSMate.Options:ToggleDrewDrop(2, "segment5", Dewdrop:GetOpenedParent()) end

function DPSMate.Options:OnVerticalScroll(obj, arg1)
	local maxScroll = obj:GetVerticalScrollRange()
	local Scroll = obj:GetVerticalScroll()
	local toScroll = (Scroll - (20*arg1))
	if toScroll < 0 then
		obj:SetVerticalScroll(0)
	elseif toScroll > maxScroll then
		obj:SetVerticalScroll(maxScroll)
	else
		obj:SetVerticalScroll(toScroll)
	end
end

function DPSMate.Options:CreateWindow()
	local na = DPSMate_ConfigMenu_Tab_Window_Editbox:GetText()
	if (na and not DPSMate:GetKeyByValInTT(DPSMateSettings["windows"], na, "name") and na~="") then -- Contains fkn needs update
		local f=CreateFrame("Frame", "DPSMate_"..na, UIParent, "DPSMate_Statusframe")
		table.insert(DPSMateSettings["windows"], {
			name = na,
			options = {
				[1] = {
					dps = false,
					damage = true,
					damagetaken = false,
					enemydamagetaken = false,
					enemydamagedone = false,
					healing = false,
					healingandabsorbs = false,
					overhealing = false,
					interrupts = false,
					deaths = false,
					dispels = false,
				},
				[2] = {
					total = true,
					currentfight = false,
					segment1 = false,
					segment2 = false,
					segment3 = false,
					segment4 = false,
					segment5 = false,
				},
				[3] = {
					lock = false,
				},
			},
			CurMode = "damage",
		})
		f.Key=DPSMate:TableLength(DPSMateSettings["windows"])
		getglobal("DPSMate_"..na.."_Head_Font"):SetText("Damage")
		getglobal("DPSMate_"..na.."_ScrollFrame_Child"):SetWidth(150)
		getglobal("DPSMate_"..na.."_ScrollFrame"):SetHeight(84)
		DPSMate:SetStatusBarValue()
	end
end

function DPSMate.Options:CreateGraphTable()
	local lines = {}
	for i=1, 7 do
		-- Horizontal
		lines[i] = graph:DrawLine(DPSMate_Details_Log, 252, 270-i*30, 617, 270-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[8] = graph:DrawLine(DPSMate_Details_Log, 302, 260, 302, 45, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[8]:Show()
	
	lines[9] = graph:DrawLine(DPSMate_Details_Log, 437, 260, 437, 45, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[9]:Show()
	
	lines[10] = graph:DrawLine(DPSMate_Details_Log, 497, 260, 497, 45, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[10]:Show()
	
	lines[11] = graph:DrawLine(DPSMate_Details_Log, 557, 260, 557, 45, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[11]:Show()
end

function DPSMate.Options:Lock()
	DPSMateSettings.lock = true
	for _,val in pairs(DPSMateSettings["windows"]) do
		getglobal("DPSMate_"..val["name"].."_Resize"):Hide()
	end
end

function DPSMate.Options:Unlock()
	DPSMateSettings.lock = false
	for _,val in pairs(DPSMateSettings["windows"]) do
		getglobal("DPSMate_"..val["name"].."_Resize"):Show()
	end
end

function DPSMate.Options:Hide(frame)
	DPSMateSettings["windows"][frame.Key]["hidden"] = true
	frame:Hide()
end

function DPSMate.Options:Show(frame)
	DPSMateSettings["windows"][frame.Key]["hidden"] = false
	frame:Show()
end

function DPSMate.Options:RemoveSegment(i)
	table.remove(DPSMateHistory, i)
	DPSMate.Options:InitializeSegments()
	Dewdrop:Close()
end

function DPSMate.Options:deletesegment1() DPSMate.Options:RemoveSegment(1) end
function DPSMate.Options:deletesegment2() DPSMate.Options:RemoveSegment(2) end
function DPSMate.Options:deletesegment3() DPSMate.Options:RemoveSegment(3) end
function DPSMate.Options:deletesegment4() DPSMate.Options:RemoveSegment(4) end
function DPSMate.Options:deletesegment5() DPSMate.Options:RemoveSegment(5) end