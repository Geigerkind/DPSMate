-- Notes
-- Need to prevent scrolling if there is not enough statusbars

-- Global Variables
DPSMate = {}
DPSMate.VERSION = 11
DPSMate.Parser = {}
DPSMate.localization = {}
DPSMate.DB = {}
DPSMate.Options = {}
DPSMate.Sync = {}
DPSMate.Modules = {}
DPSMate.Events = {
	"CHAT_MSG_COMBAT_SELF_HITS",
	"CHAT_MSG_COMBAT_SELF_MISSES",
	"CHAT_MSG_SPELL_SELF_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", 
	"CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE", 
	"CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
	"CHAT_MSG_COMBAT_PARTY_HITS",
	"CHAT_MSG_SPELL_PARTY_DAMAGE",
	"CHAT_MSG_COMBAT_PARTY_MISSES",
	"CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS",
	"CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES",
	"CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE",
	
	--"COMBAT_TEXT_UPDATE",
	
	"CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS",
	"CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES",
	"CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
	"CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS",
	"CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES",
	"CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", 
	"CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", 
	"CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS", 
	"CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES",
	"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", 
	
	"CHAT_MSG_SPELL_SELF_BUFF",
	"CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
	"CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF",
	"CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS",
	"CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF",
	"CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS",
	"CHAT_MSG_SPELL_PARTY_BUFF",
	"CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS",
	
	"CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF", 
	"CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS", 
	"CHAT_MSG_SPELL_BREAK_AURA", 
	"CHAT_MSG_SPELL_AURA_GONE_SELF", 
	"CHAT_MSG_SPELL_AURA_GONE_OTHER", 
	"CHAT_MSG_SPELL_AURA_GONE_PARTY", 
	
	"CHAT_MSG_COMBAT_FRIENDLY_DEATH",
	"CHAT_MSG_COMBAT_HOSTILE_DEATH",
	
	--"SPELLCAST_CHANNEL_START", --
	--"SPELLCAST_STOP", --
	--"SPELLCAST_FAILED", --
	--"SPELLCAST_INTERRUPTED", --
	
	"PLAYER_AURAS_CHANGED",
}
DPSMate.Registered = true
DPSMate.RegistredModules = {}
DPSMate.ModuleNames = {}
DPSMate.BabbleSpell = AceLibrary("Babble-Spell-2.3")
DPSMate.BabbleBoss = AceLibrary("Babble-Boss-2.3")
DPSMate.UserId = nil
DPSMate.AbilityId = nil

-- Local Variables
local _G = getglobal
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
local t = {}
local tinsert = table.insert
local strgsub = string.gsub
local func = function(c) tinsert(t, c) end

-- Begin functions

function DPSMate:OnLoad()
	SLASH_DPSMate1 = "/dps"
	SlashCmdList["DPSMate"] = function(msg) DPSMate:SlashCMDHandler(msg) end

	DPSMate:InitializeFrames()
	DPSMate.Options:InitializeConfigMenu()
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
		elseif cmd == "showAll" then
			for _, val in DPSMateSettings["windows"] do DPSMate.Options:Show(getglobal("DPSMate_"..val["name"])) end
		elseif cmd == "hideAll" then
			for _, val in DPSMateSettings["windows"] do DPSMate.Options:Hide(getglobal("DPSMate_"..val["name"])) end
		elseif strsub(cmd, 1, 4) == "show" then
			local frame = _G("DPSMate_"..strsub(cmd, 6))
			if frame then
				DPSMate.Options:Show(frame)
			else
				DPSMate:SendMessage("Following frames are available. If there is none type /config.")
				for _, val in pairs(DPSMateSettings["windows"]) do
					DPSMate:SendMessage("|c3ffddd80- "..val["name"].."|r")
				end
			end
		elseif strsub(cmd, 1, 4) == "hide" then
			local frame = _G("DPSMate_"..strsub(cmd, 6))
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
			DPSMate:SendMessage("|c3ffddd80- showAll:|r Show all windows.")
			DPSMate:SendMessage("|c3ffddd80- hideAll:|r Hide all windows.")
			DPSMate:SendMessage("|c3ffddd80- show {name}:|r Show the window with the name {name}.")
			DPSMate:SendMessage("|c3ffddd80- hide {name}:|r Hide the window with the name {name}.")
			DPSMate:SendMessage("|c3ffddd80- config:|r Opens the config menu.")
		end
	end
end

function DPSMate:InitializeFrames()
	if not DPSMate:WindowsExist() then return end
	for k, val in pairs(DPSMateSettings["windows"]) do
		if not _G("DPSMate_"..val["name"]) then
			local f=CreateFrame("Frame", "DPSMate_"..val["name"], UIParent, "DPSMate_Statusframe")
			f.Key=k
		end
		local frame = _G("DPSMate_"..val["name"])
			
		DPSMate.Options:ToggleDrewDrop(1, DPSMate.DB:GetOptionsTrue(1, k), frame)
		DPSMate.Options:ToggleDrewDrop(2, DPSMate.DB:GetOptionsTrue(2, k), frame)
		
		local head = _G("DPSMate_"..val["name"].."_Head")
		head.font = _G("DPSMate_"..val["name"].."_Head_Font")
		head.bg = _G("DPSMate_"..val["name"].."_Head_Background")
		head.sync = _G("DPSMate_"..val["name"].."_Head_Sync")
		
		if DPSMateSettings["sync"] then
			head.sync:GetNormalTexture():SetVertexColor(0.67,0.83,0.45,1)
		else
			head.sync:GetNormalTexture():SetVertexColor(1,0,0,1)
		end
		
		if DPSMateSettings["lock"] then
			_G("DPSMate_"..val["name"].."_Resize"):Hide()
		end
		if not val["titlebar"] then
			head:Hide()
		end
		frame:SetAlpha(val["opacity"])
		head.font:SetTextColor(val["titlebarfontcolor"][1],val["titlebarfontcolor"][2],val["titlebarfontcolor"][3])
		head.bg:SetTexture(DPSMate.Options.statusbars[val["titlebartexture"]])
		head.bg:SetVertexColor(val["titlebarbgcolor"][1], val["titlebarbgcolor"][2], val["titlebarbgcolor"][3])
		head.font:SetFont(DPSMate.Options.fonts[val["titlebarfont"]], val["titlebarfontsize"], DPSMate.Options.fontflags[val["titlebarfontflag"]])
		head:SetHeight(val["titlebarheight"])
		_G("DPSMate_"..val["name"].."_ScrollFrame_Background"):SetTexture(DPSMate.Options.bgtexture[val["contentbgtexture"]])
		_G("DPSMate_"..val["name"].."_ScrollFrame_Background"):SetVertexColor(val["contentbgcolor"][1], val["contentbgcolor"][2], val["contentbgcolor"][3])
		_G("DPSMate_"..val["name"].."_ScrollFrame_Background"):SetAlpha(val["bgopacity"] or 1)
		frame:SetScale(val["scale"])
		_G("DPSMate_"..val["name"].."_Head_Enable"):SetChecked(DPSMateSettings["enable"])
		
		-- Styles // Bars
		local child = _G("DPSMate_"..val["name"].."_ScrollFrame_Child")
		_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetPoint("TOPLEFT", child, "TOPLEFT")
		_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetPoint("TOPRIGHT", child, "TOPRIGHT")
		if DPSMateSettings["showtotals"] then
			_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetHeight(val["barheight"])
		else
			_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetHeight(0.00001)
		end
		_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetStatusBarTexture(DPSMate.Options.statusbars[val["bartexture"]])
		_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total_BG"):SetTexture(DPSMate.Options.statusbars[val["bartexture"]])
		_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total_Name"):SetFont(DPSMate.Options.fonts[val["barfont"]], val["barfontsize"], DPSMate.Options.fontflags[val["barfontflag"]])
		_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total_Value"):SetFont(DPSMate.Options.fonts[val["barfont"]], val["barfontsize"], DPSMate.Options.fontflags[val["barfontflag"]])
		for i=1, 30 do
			local bar = _G("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i)
			bar.name = _G("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i.."_Name")
			bar.value = _G("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i.."_Value")
			bar.icon = _G("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i.."_Icon")
			bar.bg = _G("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i.."_BG")
			
			-- Postition
			bar:SetPoint("TOPLEFT", child, "TOPLEFT")
			bar:SetPoint("TOPRIGHT", child, "TOPRIGHT")
			if i>1 then
				bar:SetPoint("TOPLEFT", _G("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..(i-1)), "BOTTOMLEFT", 0, -1*val["barspacing"])
			else
				if DPSMateSettings["showtotals"] then
					bar:SetPoint("TOPLEFT", _G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"), "BOTTOMLEFT", 0, -1*val["barspacing"])
				else
					bar:SetPoint("TOPLEFT", _G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"), "BOTTOMLEFT", 0, -1)
				end
			end
			if val["classicons"] then
				bar.name:ClearAllPoints()
				bar.name:SetPoint("TOPLEFT", bar, "TOPLEFT", val["barheight"], 0)
				bar.name:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT")
				bar.icon:SetWidth(val["barheight"])
				bar.icon:SetHeight(val["barheight"])
				bar.icon:Show()
			end
		
			-- Styles
			bar.name:SetFont(DPSMate.Options.fonts[val["barfont"]], val["barfontsize"], DPSMate.Options.fontflags[val["barfontflag"]])
			bar.name:SetTextColor(val["barfontcolor"][1],val["barfontcolor"][2],val["barfontcolor"][3])
			bar.value:SetFont(DPSMate.Options.fonts[val["barfont"]], val["barfontsize"], DPSMate.Options.fontflags[val["barfontflag"]])
			bar.value:SetTextColor(val["barfontcolor"][1],val["barfontcolor"][2],val["barfontcolor"][3])
			bar:SetStatusBarTexture(DPSMate.Options.statusbars[val["bartexture"]])
			bar.bg:SetTexture(DPSMate.Options.statusbars[val["bartexture"]])
			bar.bg:SetVertexColor(val["bgbarcolor"][1],val["bgbarcolor"][2],val["bgbarcolor"][3], 0.5)
			bar:SetHeight(val["barheight"])
		end
	end
	DPSMate.Options:ToggleTitleBarButtonState()
	DPSMate.Options:HideWhenSolo()
	if not DPSMateSettings["enable"] then
		self:Disable()
	end
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
			if val == value or cat==value then
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

function DPSMate:CopyTable(t)
	local s={}
	for cat, val in pairs(t) do
		s[cat] = val
	end
	return s
end

function DPSMate:GetUserById(id)
	if not self.UserId then
		self.UserId = {}
		for cat, val in DPSMateUser do
			self.UserId[val[1]] = cat
		end
	end
	return self.UserId[id]
end

function DPSMate:GetAbilityById(id)
	if not self.AbilityId then
		self.AbilityId = {}
		for cat, val in DPSMateAbility do
			self.AbilityId[val[1]] = cat
		end
	end
	return self.AbilityId[id]
end

function DPSMate:PlayerExist(arr, name)
	for cat, val in pairs(arr) do
		if (cat == name) then
			return true
		end
	end
	return false
end

function DPSMate:GetMaxValue(arr, key)
	local max = 0
	for _, val in arr do
		if val[key]>max then
			max=val[key]
		end
	end
	return max
end

function DPSMate:GetMinValue(arr, key)
	local min
	for _, val in arr do
		if not min or val[key]<min then
			min = val[key]
		end
	end
	return min or 0
end

function DPSMate:ScaleDown(arr, start)
	local t = {}
	for cat, val in arr do
		t[cat] = {(val[1]-start), val[2]}
	end
	return t
end

function DPSMate:SetStatusBarValue()
	if not DPSMate:WindowsExist() or DPSMate.Options.TestMode then return end
	DPSMate:HideStatusBars()
	--DPSMate:SendMessage("Hidden!")
	for k,c in DPSMateSettings.windows do
		local arr, cbt = DPSMate:GetMode(k)
		local user, val, perc, strt = DPSMate:GetSettingValues(arr,cbt,k)
		if DPSMateSettings["showtotals"] then
			_G("DPSMate_"..c["name"].."_ScrollFrame_Child_Total_Name"):SetText("Total")
			_G("DPSMate_"..c["name"].."_ScrollFrame_Child_Total_Value"):SetText(strt[1]..strt[2])
		end
		--DPSMate:SendMessage(c["name"])
		if (user[1]) then
			for i=1, 30 do
				--DPSMate:SendMessage("Test 1")
				if (not user[i]) then break end -- To prevent visual issues
				--DPSMate:SendMessage("Test 2")
				local statusbar, name, value, texture, p = _G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i), _G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Name"), _G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Value"), _G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Icon"), ""
				_G("DPSMate_"..c["name"].."_ScrollFrame_Child"):SetHeight((i+1)*(c["barheight"]+c["barspacing"]))
				
				local r,g,b,img = DPSMate:GetClassColor(user[i])
				statusbar:SetStatusBarColor(r,g,b, 1)
				
				if c["ranks"] then p=i..". " else p="" end
				name:SetText(p..user[i])
				value:SetText(val[i])
				texture:SetTexture("Interface\\AddOns\\DPSMate\\images\\class\\"..img)
				statusbar:SetValue(perc[i])
				
				statusbar.user = user[i]
				statusbar:Show()
			end
		end
	end
end

function DPSMate:FormatNumbers(dmg,total,sort,k)
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then
		dmg = string.format("%.1f", (dmg/1000))
		total = string.format("%.1f", (total/1000))
		sort = string.format("%.1f", (sort/1000))
	end
	return dmg, total, sort
end

function DPSMate:ApplyFilter(key, name)
	if not key then return true end
	local class = DPSMateUser[name][2] or "warrior"
	local path = DPSMateSettings["windows"][key]
	t = {}
	if path["grouponly"] then
		if not DPSMate.Parser.TargetParty[name] then
			return false
		end
	end
	-- Certain people
	strgsub(path["filterpeople"], "(.-),", func)
	for cat, val in t do
		if name == val then
			return true
		end
	end
	if path["filterpeople"] == "" then
		-- classes
		for cat, val in path["filterclasses"] do
			if val then
				if cat == class then
					return true
				end
			end
		end
	end
	return false
end

function DPSMate:GetSettingValues(arr, cbt, k)
	return DPSMate.RegistredModules[DPSMateSettings["windows"][k]["CurMode"]]:GetSettingValues(arr, cbt, k)
end

function DPSMate:EvalTable(k)
	return DPSMate.RegistredModules[DPSMateSettings["windows"][k]["CurMode"]]:EvalTable(DPSMateUser[UnitName("player")], k)
end

function DPSMate:GetClassColor(class)
	if (class) then
		if DPSMateUser[class] then class = DPSMateUser[class][2] end
		if classcolor[class] then
			return classcolor[class].r, classcolor[class].g, classcolor[class].b, class
		else
			return 0.78,0.61,0.43, "Warrior"
		end
	end
	return 0.78,0.61,0.43, "Warrior"
end

function DPSMate:GetMode(k)
	local Handler = DPSMate.RegistredModules[DPSMateSettings["windows"][k]["CurMode"]]
	local result = {total={Handler.DB[1], DPSMateCombatTime["total"]}, currentfight={Handler.DB[2], DPSMateCombatTime["current"]}}
	for cat, val in pairs(DPSMateSettings["windows"][k]["options"][2]) do
		if val then
			if strfind(cat, "segment") then
				local num = tonumber(strsub(cat, 8))
				return DPSMateHistory[Handler.Hist][num], DPSMateCombatTime["segments"][num]
			else
				return result[cat][1], result[cat][2]
			end
		end
	end
end

function DPSMate:GetModeByArr(arr, k)
	local result = {total={arr[1], DPSMateCombatTime["total"]}, currentfight={arr[2], DPSMateCombatTime["current"]}}
	for cat, val in pairs(DPSMateSettings["windows"][k]["options"][2]) do
		if val then
			if strfind(cat, "segment") then
				local num = tonumber(strsub(cat, 8))
				return DPSMateHistory[arr.Hist][num], DPSMateCombatTime["segments"][num]
			else
				return result[cat][1], result[cat][2]
			end
		end
	end
end

function DPSMate:GetModeName(k)
	local result = {total="Total", currentfight="Current fight"}
	for cat, val in pairs(DPSMateSettings["windows"][k]["options"][2]) do
		if val then 
			if strfind(cat, "segment") then
				local num = tonumber(strsub(cat, 8))
				return DPSMateHistory["names"][num]
			else
				return result[cat]
			end
		end
	end
end

function DPSMate:HideStatusBars()
	for _,val in pairs(DPSMateSettings.windows) do
		for i=1, 30 do
			_G("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i):Hide()
		end
	end
end

function DPSMate:Disable()
	if DPSMate.Registered then
		for _, event in pairs(DPSMate.Events) do
			DPSMate_Options:UnregisterEvent(event)
		end
		self.Registered = false
	end
end

function DPSMate:Enable()
	if not DPSMate.Registered then
		for _, event in pairs(DPSMate.Events) do
			DPSMate_Options:RegisterEvent(event)
		end
		DPSMate.Registered = true
	end
end

function DPSMate:SendMessage(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFF8080"..DPSMate.localization.name.."|r: "..msg)
end

function DPSMate:Register(prefix, table, name)
	DPSMate.ModuleNames[name] = prefix
	DPSMate.RegistredModules[prefix] = table
end