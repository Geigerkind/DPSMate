-- Global Variables
DPSMate = {}
DPSMate.VERSION = "v0.1"
DPSMate.Parser = {}
DPSMate.localization = {}
DPSMate.DB = {}
DPSMate.Options = {}

-- Local Variables
local classcolor = {
	rogue = {r=1.0, g=0.96, b=0.41},
	priest = {r=1,g=1,b=1},
	druid = {r=1,g=0.49,b=0.04},
	warrior = {r=0.78,g=0.61,b=0.43},
	warlock = {r=0.58,g=0.51,b=0.79},
	mage = {r=0.41,g=0.8,b=0.94},
	hunter = {r=0.67,g=0.83,b=0.45},
	paladin = {r=0.96,g=0.55,b=0.73},
	shaman = {r=0,g=0.44,b=0.87},
}

-- Begin functions

function DPSMate:OnLoad()
	SLASH_DPSMate1 = "/dps"
	SlashCmdList["DPSMate"] = function(msg) DPSMate:SlashCMDHandler(msg) end

	DPSMate:InitializeFrames()
	DPSMate.Options:InitializeConfigMenu()
	DPSMate:SetStatusBarValue()
end

function DPSMate:SlashCMDHandler(msg)
	if (msg) then
		local cmd = msg
		if cmd == "lock" then
			DPSMate.Options:Lock()
		elseif cmd == "unlock" then
			DPSMate.Options:Unlock()
		elseif cmd == "config" then
			DPSMate_ConfigMenu:Show()
		elseif strsub(cmd, 1, 4) == "show" then
			local frame = getglobal("DPSMate_"..strsub(cmd, 6))
			if frame then
				DPSMate.Options:Show(frame)
			else
				DPSMate:SendMessage("Following frames are available. If there is none type /config.")
				for _, val in pairs(DPSMateSettings["windows"]) do
					DPSMate:SendMessage("|c3ffddd80- "..val["name"].."|r")
				end
			end
		elseif strsub(cmd, 1, 4) == "hide" then
			local frame = getglobal("DPSMate_"..strsub(cmd, 6))
			if frame then
				DPSMate.Options:Hide(frame)
			else
				DPSMate:SendMessage("Following frames are available. If there is none type /config.")
				for _, val in pairs(DPSMateSettings["windows"]) do
					DPSMate:SendMessage("|c3ffddd80- "..val["name"].."|r")
				end
			end
		else
			DPSMate:SendMessage("|c3ffddd80About:|r A damage meter.")
			DPSMate:SendMessage("|c3ffddd80Usage:|r /dps {lock|unlock|show|hide|config}")
			DPSMate:SendMessage("|c3ffddd80- lock:|r Lock your windows.")
			DPSMate:SendMessage("|c3ffddd80- unlock:|r Unlock your windows.")
			DPSMate:SendMessage("|c3ffddd80- show {name}:|r Show the window with the name {name}.")
			DPSMate:SendMessage("|c3ffddd80- hide {name}:|r Hide the window with the name {name}.")
			DPSMate:SendMessage("|c3ffddd80- config:|r Opens the config menu.")
		end
	end
end

function DPSMate:InitializeFrames()
	if not DPSMate:WindowsExist() then return end
	for k, val in pairs(DPSMateSettings["windows"]) do
		local f=CreateFrame("Frame", "DPSMate_"..val["name"], UIParent, "DPSMate_Statusframe")
		f.Key=k
		DPSMate.Options:ToggleDrewDrop(1, DPSMate.DB:GetOptionsTrue(1, k), f)
		DPSMate.Options:ToggleDrewDrop(2, DPSMate.DB:GetOptionsTrue(2, k), f)
		
		local head = getglobal("DPSMate_"..val["name"].."_Head")
		head.font = getglobal("DPSMate_"..val["name"].."_Head_Font")
		head.bg = getglobal("DPSMate_"..val["name"].."_Head_Background")
		
		if DPSMateSettings["lock"] then
			getglobal("DPSMate_"..val["name"].."_Resize"):Hide()
		end
		if not DPSMateSettings["titlebar"] then
			head:Hide()
		end
		head.bg:SetTexture(DPSMate.Options.statusbars[DPSMateSettings["titlebartexture"]])
		head.bg:SetVertexColor(DPSMateSettings["titlebarbgcolor"][1], DPSMateSettings["titlebarbgcolor"][2], DPSMateSettings["titlebarbgcolor"][3])
		head.font:SetFont(DPSMate.Options.fonts[DPSMateSettings["titlebarfont"]], DPSMateSettings["titlebarfontsize"], DPSMate.Options.fontflags[DPSMateSettings["titlebarfontflag"]])
		head:SetHeight(DPSMateSettings["titlebarheight"])
		getglobal("DPSMate_"..val["name"].."_ScrollFrame_Background"):SetTexture(DPSMate.Options.bgtexture[DPSMateSettings["contentbgtexture"]])
		getglobal("DPSMate_"..val["name"].."_ScrollFrame_Background"):SetVertexColor(DPSMateSettings["contentbgcolor"][1], DPSMateSettings["contentbgcolor"][2], DPSMateSettings["contentbgcolor"][3])
		f:SetScale(DPSMateSettings["scale"])
		
		-- Styles // Bars
		local child = getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child")
		getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetPoint("TOPLEFT", child, "TOPLEFT")
		getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetPoint("TOPRIGHT", child, "TOPRIGHT")
		if DPSMateSettings["showtotals"] then
			getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetHeight(DPSMateSettings["barheight"])
		else
			getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetHeight(0.00001)
		end
		getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetStatusBarTexture(DPSMate.Options.statusbars[DPSMateSettings["bartexture"]])
		getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_Total_BG"):SetTexture(DPSMate.Options.statusbars[DPSMateSettings["bartexture"]])
		getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_Total_Name"):SetFont(DPSMate.Options.fonts[DPSMateSettings["barfont"]], DPSMateSettings["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["barfontflag"]])
		getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_Total_Value"):SetFont(DPSMate.Options.fonts[DPSMateSettings["barfont"]], DPSMateSettings["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["barfontflag"]])
		for i=1, 30 do
			local bar = getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i)
			bar.name = getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i.."_Name")
			bar.value = getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i.."_Value")
			bar.icon = getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i.."_Icon")
			bar.bg = getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i.."_BG")
			
			-- Postition
			bar:SetPoint("TOPLEFT", child, "TOPLEFT")
			bar:SetPoint("TOPRIGHT", child, "TOPRIGHT")
			if i>1 then
				bar:SetPoint("TOPLEFT", getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..(i-1)), "BOTTOMLEFT", 0, -1*DPSMateSettings["barspacing"])
			else
				if DPSMateSettings["showtotals"] then
					bar:SetPoint("TOPLEFT", getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"), "BOTTOMLEFT", 0, -1*DPSMateSettings["barspacing"])
				else
					bar:SetPoint("TOPLEFT", getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"), "BOTTOMLEFT", 0, -1)
				end
			end
			if DPSMateSettings["classicons"] then
				bar.name:ClearAllPoints()
				bar.name:SetPoint("TOPLEFT", bar, "TOPLEFT", DPSMateSettings["barheight"], 0)
				bar.name:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT")
				bar.icon:SetWidth(DPSMateSettings["barheight"])
				bar.icon:SetHeight(DPSMateSettings["barheight"])
				bar.icon:Show()
			end
		
			-- Styles
			bar.name:SetFont(DPSMate.Options.fonts[DPSMateSettings["barfont"]], DPSMateSettings["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["barfontflag"]])
			bar.value:SetFont(DPSMate.Options.fonts[DPSMateSettings["barfont"]], DPSMateSettings["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["barfontflag"]])
			bar:SetStatusBarTexture(DPSMate.Options.statusbars[DPSMateSettings["bartexture"]])
			bar.bg:SetTexture(DPSMate.Options.statusbars[DPSMateSettings["bartexture"]])
			bar:SetHeight(DPSMateSettings["barheight"])
		end
	end
	DPSMate.Options:ToggleTitleBarButtonState()
	DPSMate.Options:HideWhenSolo()
end

function DPSMate:WindowsExist()
	if (DPSMate:TableLength(DPSMateSettings.windows)==0) then
		return false
	end
	return true
end

function DPSMate:TMax(t)
	local max = 0
	for _,val in pairs(t) do
		if val>max then
			max=val
		end
	end
	return max
end

function DPSMate:TableLength(t)
	local count = 0
	if (t) then
		for _,_ in pairs(t) do
			count = count + 1
		end
	end
	return count
end

function DPSMate:TContains(t, value)
	if (t) then
		for cat, val in pairs(t) do
			if val == value then
				return true
			end
		end
	end
	return false
end

function DPSMate:GetKeyByVal(t, value)
	for cat, val in pairs(t) do
		if val == value then
			return cat
		end
	end
end

function DPSMate:GetKeyByValInTT(t, x, y)
	for cat, val in pairs(t) do
		if (type(val) == "table") then
			if (x==val[y]) then
				return cat
			end
		end
	end
end

function DPSMate:InvertTable(t)
	local s={}
	for cat, val in pairs(t) do
		s[val]=cat
	end
	return s
end

function DPSMate:GetSortedTable(arr)
	local b, a = {}, {}
	local total = 0
	for cat, val in pairs(arr) do
		if (not val.isPet) then
			local CV = val.damage
			if DPSMate:PlayerExist(arr, val.pet) then
				CV=CV+arr[val.pet].damage
			end
			a[CV] = cat
			local i = 1
			while true do
				if (not b[i]) then
					table.insert(b, i, CV)
					break
				else
					if b[i] < CV then
						table.insert(b, i, CV)
						break
					end
				end
				i=i+1
			end
			total = total + CV
		end
	end
	return b, total, a
end

function DPSMate:PlayerExist(arr, name)
	for cat, val in pairs(arr) do
		if (cat == name) then
			return true
		end
	end
	return false
end

function DPSMate:SetStatusBarValue()
	if not DPSMate:WindowsExist() then return end
	DPSMate:HideStatusBars()
	for k,c in pairs(DPSMateSettings.windows) do
		local arr, cbt = DPSMate:GetMode(k)
		local user, val, perc, total = DPSMate:GetSettingValues(arr,cbt,k)
		if DPSMateSettings["showtotals"] then
			getglobal("DPSMate_"..c["name"].."_ScrollFrame_Child_Total_Name"):SetText("Total")
			getglobal("DPSMate_"..c["name"].."_ScrollFrame_Child_Total_Value"):SetText("("..ceil(total/cbt).." DPS) "..total.." (100%)")
		end
		if (not user[1]) then return end
		for i=1, 30 do
			if (not user[i]) then break end -- To prevent visual issues
			local statusbar, name, value, texture, p = getglobal("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i), getglobal("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Name"), getglobal("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Value"), getglobal("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Icon"), ""
			
			local r,g,b, img = DPSMate:GetClassColor(arr[user[i]].class)
			statusbar:SetStatusBarColor(r,g,b, 1)
			
			if DPSMateSettings["ranks"] then p=i..". " else p="" end
			name:SetText(p..user[i])
			value:SetText(val[i])
			texture:SetTexture("Interface\\AddOns\\DPSMate\\images\\class\\"..img)
			statusbar:SetValue(perc[i])
			
			statusbar.user = user[i]
			statusbar:Show()
		end
	end
end

function DPSMate:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a = {}, {}, {}, {}, 0, 0
	if (DPSMateSettings["windows"][k]["CurMode"] == "dps") then
		sortedTable, total, a = DPSMate:GetSortedTable(arr)
		for cat, val in pairs(sortedTable) do
			table.insert(name, a[val])
			table.insert(value, ceil(val/cbt).." ("..string.format("%.1f", 100*val/total).."%)")
			table.insert(perc, ceil(100*(val/sortedTable[1])))
		end
	elseif (DPSMateSettings["windows"][k]["CurMode"] == "damage") then
		sortedTable, total, a = DPSMate:GetSortedTable(arr)
		for cat, val in pairs(sortedTable) do
			table.insert(name, a[val])
			table.insert(value, val.." ("..string.format("%.1f", 100*val/total).."%)")
			table.insert(perc, ceil(100*(val/sortedTable[1])))
		end
	end
	return name, value, perc, total
end

function DPSMate:GetClassColor(class)
	if (class) then
		return classcolor[class].r, classcolor[class].g, classcolor[class].b, class
	else
		return 0.1,0,0.1, "None"
	end
end

function DPSMate:GetMode(k)
	if DPSMateSettings["windows"][k]["options"][2]["total"] then
		return DPSMateUser, DPSMateCombatTime["total"]
	elseif DPSMateSettings["windows"][k]["options"][2]["segment1"] then
		return DPSMateHistory[1], DPSMateCombatTime["segments"][1]
	elseif DPSMateSettings["windows"][k]["options"][2]["segment2"] then
		return DPSMateHistory[2], DPSMateCombatTime["segments"][2]
	elseif DPSMateSettings["windows"][k]["options"][2]["segment3"] then
		return DPSMateHistory[3], DPSMateCombatTime["segments"][3]
	elseif DPSMateSettings["windows"][k]["options"][2]["segment4"] then
		return DPSMateHistory[4], DPSMateCombatTime["segments"][4]
	elseif DPSMateSettings["windows"][k]["options"][2]["segment5"] then
		return DPSMateHistory[5], DPSMateCombatTime["segments"][5]
	end
	return DPSMateUserCurrent, DPSMateCombatTime["current"]
end

function DPSMate:GetModeName(k)
	if DPSMateSettings["windows"][k]["options"][2]["total"] then
		return "Total"
	elseif DPSMateSettings["windows"][k]["options"][2]["segment1"] then
		return "Segment 1"
	elseif DPSMateSettings["windows"][k]["options"][2]["segment2"] then
		return "Segment 2"
	elseif DPSMateSettings["windows"][k]["options"][2]["segment3"] then
		return "Segment 3"
	elseif DPSMateSettings["windows"][k]["options"][2]["segment4"] then
		return "Segment 4"
	elseif DPSMateSettings["windows"][k]["options"][2]["segment5"] then
		return "Segment 5"
	end
	return "Current fight"
end

function DPSMate:HideStatusBars()
	for _,val in pairs(DPSMateSettings.windows) do
		for i=1, 30 do
			getglobal("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i):Hide()
		end
	end
end

function DPSMate:SendMessage(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFF8080"..DPSMate.localization.name.."|r: "..msg)
end