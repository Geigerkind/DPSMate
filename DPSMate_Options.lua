-- Global Variables
DPSMate.Options.fonts = {
	["FRIZQT"] = "Fonts\\FRIZQT__.TTF",
	["ARIALN"] = "Fonts\\ARIALN.TTF",
	["MORPHEUS"] = "Fonts\\MORPHEUS.TTF",
	["ABF"] = "Interface\\AddOns\\DPSMate\\fonts\\ABF.TTF",
	["Accidental Presidency"] = "Interface\\AddOns\\DPSMate\\fonts\\Accidental Presidency.TTF",
	["Adventure"] = "Interface\\AddOns\\DPSMate\\fonts\\Adventure.TTF",
	["Avqest"] = "Interface\\AddOns\\DPSMate\\fonts\\Avqest.TTF",
	["Bazooka"] = "Interface\\AddOns\\DPSMate\\fonts\\Bazooka.TTF",
	["BigNoodleTitling"] = "Interface\\AddOns\\DPSMate\\fonts\\BigNoodleTitling.TTF",
	["BigNoodleTitling-Oblique"] = "Interface\\AddOns\\DPSMate\\fonts\\BigNoodleTitling-Oblique.TTF",
	["BlackChancery"] = "Interface\\AddOns\\DPSMate\\fonts\\BlackChancery.TTF",
	["Emblem"] = "Interface\\AddOns\\DPSMate\\fonts\\Emblem.TTF",
	["Enigma__2"] = "Interface\\AddOns\\DPSMate\\fonts\\Enigma__2.TTF",
	["Movie_Poster-Bold"] = "Interface\\AddOns\\DPSMate\\fonts\\Movie_Poster-Bold.TTF",
	["Porky"] = "Interface\\AddOns\\DPSMate\\fonts\\Porky.TTF",
	["rm_midse"] = "Interface\\AddOns\\DPSMate\\fonts\\rm_midse.TTF",
	["Tangerin"] = "Interface\\AddOns\\DPSMate\\fonts\\Tangerin.TTF",
	["Tw_Cen_MT_Bold"] = "Interface\\AddOns\\DPSMate\\fonts\\Tw_Cen_MT_Bold.TTF",
	["Ultima_Campagnoli"] = "Interface\\AddOns\\DPSMate\\fonts\\Ultima_Campagnoli.TTF",
	["VeraSe"] = "Interface\\AddOns\\DPSMate\\fonts\\VeraSe.TTF",
	["Yellowjacket"] = "Interface\\AddOns\\DPSMate\\fonts\\Yellowjacket.TTF",
}
DPSMate.Options.fontflags = {
	["None"] = "NONE",
	["Outline"] = "OUTLINE",
	["Monochrome"] = "MONOCHROME",
	["Outlined monochrome"] = "OUTLINE, MONOCHROME",
	["Tick outlined"] = "THICKOUTLINE",
}
DPSMate.Options.statusbars = {
	["Aluminium"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Aluminium", 
	["Armory"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Armory", 
	["BantoBar"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\BantoBar", 
	["Glaze2"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Glaze2", 
	["Gloss"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Gloss", 
	["Graphite"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Graphite", 
	["Grid"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Grid", 
	["Healbot"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Healbot", 
	["LiteStep"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\LiteStep", 
	["Minimalist"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Minimalist", 
	["normTex"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\normTex", 
	["Otravi"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Otravi", 
	["Outline"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Outline", 
	["Perl"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Perl", 
	["Round"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Round", 
	["Smooth"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Smooth", 
}
DPSMate.Options.bgtexture = {
	["Solid Background"] = "Interface\\CHATFRAME\\CHATFRAMEBACKGROUND",
	["UI-Tooltip-Background"] = "Interface\\Tooltips\\UI-Tooltip-Background",
}
DPSMate.Options.Dewdrop = AceLibrary("Dewdrop-2.0")


-- Local Variables
local LastPopUp = 0
local TimeToNextPopUp = 1
local PartyNum, LastPartyNum = 0, 0
local graph = AceLibrary("Graph-1.0")
local Options = {
	[1] = {
		type = 'group',
		args = {
			dps = {
				order = 10,
				type = 'toggle',
				name = DPSMate.localization.config.dps,
				desc = DPSMate.localization.desc.dps,
				get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["dps"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "dps", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
			},
			damage = {
				order = 20,
				type = 'toggle',
				name = DPSMate.localization.config.damage,
				desc = DPSMate.localization.desc.damage,
				get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["damage"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "damage", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
			},
			damagetaken = {
				order = 30,
				type = 'toggle',
				name = DPSMate.localization.config.damagetaken,
				desc = DPSMate.localization.desc.damagetaken,
				get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["damagetaken"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "damagetaken", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
			},
			enemydamagedone = {
				order = 40,
				type = 'toggle',
				name = DPSMate.localization.config.enemydamagedone,
				desc = DPSMate.localization.desc.enemydmgdone,
				get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["enemydamagedone"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "enemydamagedone", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
			},
			enemydamagetaken = {
				order = 50,
				type = 'toggle',
				name = DPSMate.localization.config.enemydamagetaken,
				desc = DPSMate.localization.desc.enemydmgtaken,
				get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["enemydamagetaken"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "enemydamagetaken", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
			},
			healing = {
				order = 60,
				type = 'toggle',
				name = DPSMate.localization.config.healing,
				desc = DPSMate.localization.desc.healing,
				get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["healing"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "healing", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
			},
			healingandabsorbs = {
				order = 70,
				type = 'toggle',
				name = DPSMate.localization.config.healingandabsorbs,
				desc = DPSMate.localization.desc.healingandabsorbs,
				get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["healingandabsorbs"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "healingandabsorbs", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
			},
			healingtaken = {
				order = 80,
				type = 'toggle',
				name = DPSMate.localization.config.healingtaken,
				desc = DPSMate.localization.desc.healingtaken,
				get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["healingtaken"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "healingtaken", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
			},
			overhealing = {
				order = 90,
				type = 'toggle',
				name = DPSMate.localization.config.overhealing,
				desc = DPSMate.localization.desc.overhealing,
				get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["overhealing"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "overhealing", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
			},
			interrupts = {
				order = 100,
				type = 'toggle',
				name = DPSMate.localization.config.interrupts,
				desc = DPSMate.localization.desc.interrupts,
				get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["interrupts"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "interrupts", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
			},
			deaths = {
				order = 110,
				type = 'toggle',
				name = DPSMate.localization.config.deaths,
				desc = DPSMate.localization.desc.deaths,
				get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["deaths"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "deaths", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
			},
			dispels = {
				order = 120,
				type = 'toggle',
				name = DPSMate.localization.config.dispels,
				desc = DPSMate.localization.desc.dispels,
				get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["dispels"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "dispels", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
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
				name = DPSMate.localization.config.total,
				desc = DPSMate.localization.desc.total,
				get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][2]["total"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(2, "total", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
			},
			currentFight = {
				order = 20,
				type = 'toggle',
				name = DPSMate.localization.config.current,
				desc = DPSMate.localization.desc.current,
				get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][2]["currentfight"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(2, "currentfight", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
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
				name = DPSMate.localization.config.report,
				desc = DPSMate.localization.desc.report,
				func = function() DPSMate_Report:Show(); DPSMate.Options.Dewdrop:Close() end,
			},
			reset = {
				order = 11,
				type = 'execute',
				name = DPSMate.localization.config.reset,
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
				name = DPSMate.localization.config.newsegment,
				desc = DPSMate.localization.desc.newsegment,
				func = function() DPSMate.Options:NewSegment(); DPSMate.Options.Dewdrop:Close() end,
			},
			deletesegment = {
				order = 30,
				type = 'group',
				name = DPSMate.localization.config.removesegment,
				desc = DPSMate.localization.desc.removesegment,
				args = {},
			},
			blank2 = {
				order = 35,
				type = 'header',
			},
			showwindow = {
				order = 36,
				type = 'group',
				name = DPSMate.localization.config.showwindow,
				desc = DPSMate.localization.desc.showwindow,
				args = {},
			},
			hidewindow = {
				order = 37,
				type = 'group',
				name = DPSMate.localization.config.hidewindow,
				desc = DPSMate.localization.desc.hidewindow,
				args = {},
			},
			blank3 = {
				order = 38,
				type = 'header',
			},
			lock = {
				order = 40,
				type = 'toggle',
				name = DPSMate.localization.config.lock,
				desc = DPSMate.localization.desc.lock,
				get = function() return DPSMateSettings["lock"] end,
				set = function() DPSMate.Options:Lock(); DPSMate.Options.Dewdrop:Close() end,
			},
			unlock = {
				order = 50,
				type = 'toggle',
				name = DPSMate.localization.config.unlock,
				desc = DPSMate.localization.desc.lock,
				get = function() return not DPSMateSettings["lock"] end,
				set = function() DPSMate.Options:Unlock(); DPSMate.Options.Dewdrop:Close() end,
			},
			configure = {
				order = 80,
				type = 'execute',
				name = DPSMate.localization.config.config,
				desc = DPSMate.localization.desc.config,
				func = function() DPSMate_ConfigMenu:Show(); DPSMate.Options.Dewdrop:Close() end,
			},
			close = {
				order = 90,
				type = 'execute',
				name = DPSMate.localization.close,
				desc = DPSMate.localization.desc.close,
				func = function() DPSMate.Options.Dewdrop:Close() end,
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

function DPSMate.Options:InitializeConfigMenu()
	-- Inialize Extra Buttons
	for cat, val in pairs(DPSMateSettings["windows"]) do
		local f = CreateFrame("Button", "DPSMate_ConfigMenu_Menu_Button"..(6+cat), DPSMate_ConfigMenu_Menu, "DPSMate_Template_WindowButton")
		f.Key = cat
		getglobal("DPSMate_ConfigMenu_Menu_Button"..(6+cat).."Text"):SetText(val["name"])
		if cat>1 then
			f:SetPoint("TOP", getglobal("DPSMate_ConfigMenu_Menu_Button"..(5+cat)), "BOTTOM")
			getglobal("DPSMate_ConfigMenu_Menu_Button"..(5+cat)).after = f
		else
			f:SetPoint("TOP", DPSMate_ConfigMenu_Menu_Button1, "BOTTOM")
		end
		f.after = DPSMate_ConfigMenu_Menu_Button2
		DPSMate_ConfigMenu.num = 6+cat
		f.func = function()
			getglobal(this:GetParent():GetParent():GetName()..this:GetParent().selected):Hide()
			getglobal(this:GetParent():GetParent():GetName().."_Tab_Window"):Show()
			this:GetParent().selected = "_Tab_Window"
		end
	end
	local TL = DPSMate:TableLength(DPSMateSettings["windows"])
	if TL>=1 then
		DPSMate_ConfigMenu_Menu_Button2:ClearAllPoints()
		DPSMate_ConfigMenu_Menu_Button2:SetPoint("TOP", getglobal("DPSMate_ConfigMenu_Menu_Button"..(6+TL)), "BOTTOM")
	end
		
	-- Tab Window
	DPSMate_ConfigMenu_Tab_Window_Lock:SetChecked(DPSMateSettings["lock"])
	
	-- Tab Bars
	if not DPSMate_ConfigMenu_Tab_Bars_BarTexture.tex then
		DPSMate_ConfigMenu_Tab_Bars_BarTexture.tex = DPSMate_ConfigMenu_Tab_Bars_BarTexture:CreateTexture("BG", "ARTWORK")
		DPSMate_ConfigMenu_Tab_Bars_BarTexture.tex:SetWidth(110)
		DPSMate_ConfigMenu_Tab_Bars_BarTexture.tex:SetHeight(15)
		DPSMate_ConfigMenu_Tab_Bars_BarTexture.tex:SetPoint("TOPLEFT", DPSMate_ConfigMenu_Tab_Bars_BarTexture, "TOPLEFT", 23, -7)
	end
	
	-- Tab Title bar
	if not DPSMate_ConfigMenu_Tab_TitleBar_BarTexture.tex then
		DPSMate_ConfigMenu_Tab_TitleBar_BarTexture.tex = DPSMate_ConfigMenu_Tab_TitleBar_BarTexture:CreateTexture("BG", "ARTWORK")
		DPSMate_ConfigMenu_Tab_TitleBar_BarTexture.tex:SetWidth(110)
		DPSMate_ConfigMenu_Tab_TitleBar_BarTexture.tex:SetHeight(15)
		DPSMate_ConfigMenu_Tab_TitleBar_BarTexture.tex:SetPoint("TOPLEFT", DPSMate_ConfigMenu_Tab_TitleBar_BarTexture, "TOPLEFT", 23, -7)
	end
	
	-- Tab General Options
	DPSMate_ConfigMenu_Tab_GeneralOptions_Minimap:SetChecked(DPSMateSettings["showminimapbutton"])
	if not DPSMateSettings["showminimapbutton"] then
		DPSMate_MiniMap:Hide()
	end
	DPSMate_ConfigMenu_Tab_GeneralOptions_Total:SetChecked(DPSMateSettings["showtotals"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_Solo:SetChecked(DPSMateSettings["hidewhensolo"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_Combat:SetChecked(DPSMateSettings["hideincombat"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_PVP:SetChecked(DPSMateSettings["hideinpvp"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_Disable:SetChecked(DPSMateSettings["disablewhilehidden"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_Segments:SetValue(DPSMateSettings["datasegments"])
	
	-- Tab Columns
	DPSMate_ConfigMenu_Tab_Columns_Container_DPS_Check1:SetChecked(DPSMateSettings["columnsdps"][1])
	DPSMate_ConfigMenu_Tab_Columns_Container_DPS_Check2:SetChecked(DPSMateSettings["columnsdps"][2])
	DPSMate_ConfigMenu_Tab_Columns_Container_DPS_Check3:SetChecked(DPSMateSettings["columnsdps"][3])
	DPSMate_ConfigMenu_Tab_Columns_Container_Damage_Check1:SetChecked(DPSMateSettings["columnsdmg"][1])
	DPSMate_ConfigMenu_Tab_Columns_Container_Damage_Check2:SetChecked(DPSMateSettings["columnsdmg"][2])
	DPSMate_ConfigMenu_Tab_Columns_Container_Damage_Check3:SetChecked(DPSMateSettings["columnsdmg"][3])
	
	-- Tab Tooltips
	DPSMate_ConfigMenu_Tab_Tooltips_Tooltips:SetChecked(DPSMateSettings["showtooltips"])
	DPSMate_ConfigMenu_Tab_Tooltips_InformativeTooltips:SetChecked(DPSMateSettings["informativetooltips"])
	DPSMate_ConfigMenu_Tab_Tooltips_Rows:SetValue(DPSMateSettings["subviewrows"])
end

function DPSMate.Options:OnEvent(event)
	if event == "PARTY_MEMBERS_CHANGED" then
		DPSMate.Options:HideWhenSolo()
		if DPSMate.Options:IsInParty() then
			if LastPartyNum == 0 then
				if DPSMateSettings["dataresetsjoinparty"] == 3 then
					if (GetTime()-LastPopUp) > TimeToNextPopUp and (DPSMate:TableLength(DPSMateUser) ~= 0 or DPSMate:TableLength(DPSMateUserCurrent) ~= 0) then
						DPSMate_PopUp:Show()
						LastPopUp = GetTime()
					end
				elseif DPSMateSettings["dataresetsjoinparty"] == 1 then
					DPSMate.Options:PopUpAccept()
				end
			elseif LastPartyNum ~= PartyNum	then
				if DPSMateSettings["dataresetspartyamount"] == 3 then
					if (GetTime()-LastPopUp) > TimeToNextPopUp and (DPSMate:TableLength(DPSMateUser) ~= 0 or DPSMate:TableLength(DPSMateUserCurrent) ~= 0) then
						DPSMate_PopUp:Show()
						LastPopUp = GetTime()
					end
				elseif DPSMateSettings["dataresetspartyamount"] == 1 then
					DPSMate.Options:PopUpAccept()
				end
				DPSMate.DB:AssignPet()
				DPSMate.DB:AssignClass()
			end
		elseif LastPartyNum > PartyNum then
			if DPSMateSettings["dataresetsleaveparty"] == 3 then
				if (GetTime()-LastPopUp) > TimeToNextPopUp and (DPSMate:TableLength(DPSMateUser) ~= 0 or DPSMate:TableLength(DPSMateUserCurrent) ~= 0) then
					DPSMate_PopUp:Show()
					LastPopUp = GetTime()
				end
			elseif DPSMateSettings["dataresetsleaveparty"] == 1 then
				DPSMate.Options:PopUpAccept()
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		if DPSMateSettings["dataresetsworld"] == 3 then
			if (GetTime()-LastPopUp) > TimeToNextPopUp and (DPSMate:TableLength(DPSMateUser) ~= 0 or DPSMate:TableLength(DPSMateUserCurrent) ~= 0) then
				DPSMate_PopUp:Show()
				LastPopUp = GetTime()
			end
		elseif DPSMateSettings["dataresetsworld"] == 1 then
			DPSMate.Options:PopUpAccept()
		end
		DPSMate.Options:HideInPvP()
	end
end

function DPSMate.Options:IsInBattleground()
	for i=1, 4 do
		local status, mapName, instanceID, lowestlevel, highestlevel, teamSize, registeredMatch = GetBattlefieldStatus(i)
		if status == "active" and DPSMateSettings["hideinpvp"] then
			return true
		end
	end
	return false
end

function DPSMate.Options:HideInPvP()
	for _, val in pairs(DPSMateSettings["windows"]) do
		local frame = getglobal("DPSMate_"..val["name"])
		if DPSMate.Options:IsInBattleground() then
			DPSMate.Options:Hide(frame)
			if DPSMateSettings["disablewhilehidden"] then
				DPSMate:Disable()
			end
		else
			DPSMate.Options:Show(frame)
			DPSMate:Enable()
		end
	end
end

function DPSMate.Options:HideWhenSolo()
	for _, val in pairs(DPSMateSettings["windows"]) do
		local frame = getglobal("DPSMate_"..val["name"])
		if DPSMateSettings["hidewhensolo"] and not DPSMate.Options:IsInBattleground() then
			if GetNumPartyMembers() == 0 then
				DPSMate.Options:Hide(frame)
				if DPSMateSettings["disablewhilehidden"] then
					DPSMate:Disable()
				end
			else
				DPSMate.Options:Show(frame)
				DPSMate:Enable()
			end
		else
			DPSMate.Options:Show(frame)
			DPSMate:Enable()
		end
	end
end

function DPSMate.Options:IsInParty()
	LastPartyNum = PartyNum
	PartyNum = GetNumPartyMembers()
	if GetNumPartyMembers() > 0 or UnitInRaid("player") then
		return true
	else
		return false
	end
end

function DPSMate.Options:PopUpAccept()
	DPSMate_PopUp:Hide()
	DPSMateDamageDone = {
		[1] = {},
		[2] = {},
	}
	DPSMateDamageTaken = {
		[1] = {},
		[2] = {},
	}
	DPSMateHistory = {
		DMGDone = {},
	}
	DPSMateCombatTime = {
		total = 1,
		current = 1,
		segments = {},
	}
	for _, val in pairs(DPSMateSettings["windows"]) do
		if not val["options"][2]["total"] and not val["options"][2]["currentfight"] then
			val["options"][2]["total"] = true
		end
	end
	DPSMate.Options:InitializeSegments()
	DPSMate:SetStatusBarValue()
end

function DPSMate.Options:OpenMenu(b, obj)
	for _, val in pairs(DPSMateSettings.windows) do
		if DPSMate.Options.Dewdrop:IsOpen(getglobal("DPSMate_"..val["name"])) then
			DPSMate.Options.Dewdrop:Close()
			return
		end
		if DPSMate.Options.Dewdrop:IsRegistered(getglobal("DPSMate_"..val["name"])) then DPSMate.Options.Dewdrop:Unregister(getglobal("DPSMate_"..val["name"])) end
	end
	DPSMate.Options.Dewdrop:Register(obj,
		'children', function() 
			DPSMate.Options.Dewdrop:FeedAceOptionsTable(Options[b]) 
		end,
		'cursorX', true,
		'cursorY', true,
		'dontHook', true
	)
	DPSMate.Options.Dewdrop:Open(obj)
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
	end
	DPSMate.Options.Dewdrop:Close()
	if DPSMate.DB.loaded then DPSMate:SetStatusBarValue() end
	return true
end

function DPSMate.Options:ScrollFrame_Update()
	local line, lineplusoffset
	local obj = getglobal("DPSMate_Details_Log_ScrollFrame")
	local arr = DPSMate:GetMode(DPSMate_Details.PaKey)
	local user, pet, len = "", 0, DPSMate:TableLength(arr[DPSMateUser[DetailsUser]["id"]])-5
	DetailsArr, DetailsTotal, DmgArr = DPSMate.Options:EvalTable(DPSMateUser[DetailsUser]["id"], DPSMate_Details.PaKey)
	FauxScrollFrame_Update(obj,DPSMate:TableLength(arr),10,24)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Name"):SetText(DetailsArr[lineplusoffset])
			getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Value"):SetText(DmgArr[lineplusoffset].." ("..string.format("%.2f", (DmgArr[lineplusoffset]*100/DetailsTotal)).."%)")
			if icons[DetailsArr[lineplusoffset]] then
				getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Icon"):SetTexture(icons[DetailsArr[lineplusoffset]])
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

function DPSMate.Options:EvalDamageDone(t)
	local a, u, p, d = {}, {}, {}, {}
	local total, pet = 0, ""
	local arr = DPSMate:GetMode(DPSMate_Details.PaKey)
	local user = DPSMateUser[DPSMate:GetUserById(t)]
	if not arr[t] then return end
	if (user["pet"] and user["pet"] ~= "Unknown" and arr[DPSMateUser[user["pet"]]["id"]]) then u={t,DPSMateUser[user["pet"]]["id"]} else u={t} end
	for _, v in pairs(u) do
		for cat, val in pairs(arr[v]) do
			if (type(val) == "table" and cat~="info") then
				if (DPSMateUser[DPSMate:GetUserById(v)]["isPet"]) then pet="(Pet)"; else pet=""; end
				local i = 1
				while true do
					if (not d[i]) then
						table.insert(a, i, cat..pet)
						table.insert(d, i, val["amount"])
						break
					else
						if (d[i] < val["amount"]) then
							table.insert(a, i, cat..pet)
							table.insert(d, i, val["amount"])
							break
						end
					end
					i = i + 1
				end
			end
		end
		total=total+arr[v]["info"][3]
	end
	return a, total, d
end

-- double abilities need to be added together
function DPSMate.Options:EvalDamageTaken(t)
	local a, u, e, d = {}, {}, {}, {}
	local total, pet = 0, ""
	local arr = DPSMate:GetMode(DPSMate_Details.PaKey)
	local user = DPSMateUser[DPSMate:GetUserById(t)]
	if not arr[t] then return end
	if (user["pet"] and user["pet"] ~= "Unknown" and arr[DPSMateUser[user["pet"]]["id"]]) then u={t,DPSMateUser[user["pet"]]["id"]} else u={t} end
	for _, v in pairs(u) do
		for cat, val in pairs(arr[v]) do
			local CV = 0
			for ca, va in pairs(val) do
				if (type(va) == "table" and ca~="info") then
					if (DPSMateUser[DPSMate:GetUserById(v)]["isPet"]) then pet="(Pet)"; else pet=""; end
					CV = CV+va["amount"]
				end
			end
			local i = 1
			while true do
				if (not d[i]) then
					table.insert(a, i, cat)
					table.insert(d, i, CV)
					break
				else
					if (d[i] < CV) then
						table.insert(a, i, cat)
						table.insert(d, i, CV)
						break
					end
				end
				i = i + 1
			end
			total=total+arr[v][cat]["info"][3]
		end
	end
	return a, total, d
end

function DPSMate.Options:EvalTable(t, k)
	if DPSMateSettings["windows"][k]["CurMode"] == "dps" or DPSMateSettings["windows"][k]["CurMode"] == "damage" then
		return DPSMate.Options:EvalDamageDone(t)
	elseif DPSMateSettings["windows"][k]["CurMode"] == "damagetaken" then
		return DPSMate.Options:EvalDamageTaken(t)
	end
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
	if (arr[DPSMateUser[DetailsUser]["id"]][DetailsArr[lineplusoffset]]) then user=DPSMateUser[DetailsUser]["id"]; pet=0; else if DPSMateUser[DetailsUser]["pet"] then user=DPSMateUser[DPSMateUser[DetailsUser]["pet"]]["id"]; pet=5; else user=DPSMateUser[DetailsUser]["id"]; pet=0; end; end
	getglobal("DPSMate_Details_Log_ScrollButton"..i.."_selected"):Show()
	
	local ability = strsub(DetailsArr[lineplusoffset], 1, strlen(DetailsArr[lineplusoffset])-pet)
	local hit, crit, miss, parry, dodge, resist, hitMin, hitMax, critMin, critMax, hitav, critav = arr[user][ability].hit, arr[user][ability].crit, arr[user][ability].miss, arr[user][ability].parry, arr[user][ability].dodge, arr[user][ability].resist, arr[user][ability].hitlow, arr[user][ability].hithigh, arr[user][ability].critlow, arr[user][ability].crithigh,  arr[user][ability].hitaverage,  arr[user][ability].critaverage
	local total, max = hit+crit+miss+parry+dodge+resist, DPSMate:TMax({hit, crit, miss, parry, dodge, resist})
	
	-- Hit
	getglobal("DPSMate_Details_LogDetails_Amount1_Amount"):SetText(hit)
	getglobal("DPSMate_Details_LogDetails_Amount1_Percent"):SetText(ceil(100*hit/total).."%")
	getglobal("DPSMate_Details_LogDetails_Amount1_StatusBar"):SetValue(ceil(100*hit/max))
	getglobal("DPSMate_Details_LogDetails_Amount1_StatusBar"):SetStatusBarColor(0.9,0.0,0.0,1)
	getglobal("DPSMate_Details_LogDetails_Average1"):SetText(ceil(hitav))
	getglobal("DPSMate_Details_LogDetails_Min1"):SetText(hitMin)
	getglobal("DPSMate_Details_LogDetails_Max1"):SetText(hitMax)
	
	-- Crit
	getglobal("DPSMate_Details_LogDetails_Amount2_Amount"):SetText(crit)
	getglobal("DPSMate_Details_LogDetails_Amount2_Percent"):SetText(ceil(100*crit/total).."%")
	getglobal("DPSMate_Details_LogDetails_Amount2_StatusBar"):SetValue(ceil(100*crit/max))
	getglobal("DPSMate_Details_LogDetails_Amount2_StatusBar"):SetStatusBarColor(0.0,0.9,0.0,1)
	getglobal("DPSMate_Details_LogDetails_Average2"):SetText(ceil(critav))
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
		if (arr[DPSMateUser[DetailsUser]["id"]][DetailsArr[i]]) then user=DPSMateUser[DetailsUser]["id"];pet=0; else user=DPSMateUser[DPSMateUser[DetailsUser]["pet"]]["id"];pet=5; end
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
	local sumTable = DPSMate.Options:GetSummarizedTable(arr, cbt)
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
	for cat, val in pairs(sumTable) do
		table.insert(Data1, {val[1],val[2], DPSMate.Options:CheckProcs(DPSMate_Details.proc, arr, val[1])})
	end

	g2:AddDataSeries(Data1,{{1.0,0.0,0.0,0.8}, {1.0,1.0,0.0,0.8}}, DPSMate.Options:AddProcPoints(DPSMate_Details.proc, arr))
end

function DPSMate.Options:CheckProcs(name, arr, val)
	if DPSMate.DB:DataExistProcs(DetailsUser, name, arr) then
		for i=1, DPSMate:TableLength(arr[DPSMateUser[DetailsUser]["id"]]["info"][1][name]["start"]) do
			if not arr[DPSMateUser[DetailsUser]["id"]]["info"][1][name]["start"][i] or not arr[DPSMateUser[DetailsUser]["id"]]["info"][1][name]["ending"][i] then return false end
			if val >  arr[DPSMateUser[DetailsUser]["id"]]["info"][1][name]["start"][i] and val < arr[DPSMateUser[DetailsUser]["id"]]["info"][1][name]["ending"][i] and not arr[DPSMateUser[DetailsUser]["id"]]["info"][1][name]["point"] then
				return true
			end
		end
	end
	return false
end

function DPSMate.Options:AddProcPoints(name, arr)
	local bool, data = false, {}
	if DPSMate.DB:DataExistProcs(DetailsUser, name, arr) and arr[DPSMateUser[DetailsUser]["id"]]["info"][1][name]["point"] then
		for i=1, DPSMate:TableLength(arr[DPSMateUser[DetailsUser]["id"]]["info"][1][name]["start"]) do
			bool = true
			table.insert(data, arr[DPSMateUser[DetailsUser]["id"]]["info"][1][name]["start"][i])
		end
	end
	return {bool, data}
end

function DPSMate.Options:GetSummarizedTable(arr, cbt)
	arr = DPSMate.Options:SortLineTable(arr)
	local newArr, lastCBT, i = {}, 0, 1
	
	for cat, val in pairs(arr) do
		if lastCBT+cbt*0.0008>val[1] then -- to prevent heavy load values are summerized
			if (newArr[i-1]) then
				newArr[i-1][2] = (newArr[i-1][2] + val[2])/2
			else
				table.insert(newArr, i, {val[1], val[2]})
				lastCBT = val[1]
				i=i+1
			end
		else
			table.insert(newArr, i, {val[1], val[2]})
			lastCBT = val[1]
			i=i+1
		end
	end
	
	return newArr
end

function DPSMate.Options:SortLineTable(t)
	local newArr = {}
	for cat, val in pairs(t[DPSMateUser[DetailsUser]["id"]]["info"][2]) do
		local i=1
		while true do
			if (not newArr[i]) then 
				table.insert(newArr, i, {cat, val})
				break
			end
			if cat<newArr[i][1] then
				table.insert(newArr, i, {cat, val})
				break
			end
			i=i+1
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

function DPSMate.Options:DropDownStyleReset()
	for i=1, 20 do
		local button = getglobal("DropDownList1Button"..i)
		getglobal("DropDownList1Button"..i.."NormalText"):SetFont(DPSMate.Options.fonts["FRIZQT"], 12)
		getglobal("DropDownList1Button"..i):SetScript("OnEnter", function()
			getglobal(this:GetName().."Highlight"):Show()
		end)
		getglobal("DropDownList1Backdrop"):SetBackdrop({ 
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32, 
			insets = { left = 11, right = 12, top = 12, bottom = 11 }
		})
		if button.tex then
			button.tex:Hide()
		end
	end
end

DPSMate.Options.ShowMenu = UnitPopup_ShowMenu
function UnitPopup_ShowMenu(dropdownMenu, which, unit, name, userData)
	DPSMate.Options:DropDownStyleReset()
	DPSMate.Options.ShowMenu(dropdownMenu, which, unit, name, userData)
end

DPSMate.Options.UIDDI = UIDropDownMenu_Initialize
function UIDropDownMenu_Initialize(frame, initFunction, displayMode, level)
	DPSMate.Options:DropDownStyleReset()
	DPSMate.Options.UIDDI(frame, initFunction, displayMode, level)
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
	for cat,_ in pairs(arr[DPSMateUser[DetailsUser]["id"]]["info"][1]) do
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

function DPSMate.Options:WindowDropDown()
	DPSMate_ConfigMenu.Selected = "None"
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(getglobal(UIDROPDOWNMENU_OPEN_MENU), this.value)
		if UIDROPDOWNMENU_OPEN_MENU == "DPSMate_ConfigMenu_Tab_Window_Remove" then
			DPSMate_ConfigMenu.Selected = this.value
		end
    end
	
	UIDropDownMenu_AddButton{
		text = "None",
		value = "None",
		func = on_click,
	}

	for _, val in pairs(DPSMateSettings["windows"]) do
		UIDropDownMenu_AddButton{
			text = val["name"],
			value = val["name"],
			func = on_click,
		}
	end
	
	if not DPSMate_ConfigMenu.vis then
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Window_Remove, "None")
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Window_ConfigFrom, "None")
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Window_ConfigTo, "None")
	end
	DPSMate_ConfigMenu.vis = true
end

function DPSMate.Options:BarFontDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Bars_BarFont, this.value)
		DPSMate_ConfigMenu_Tab_Bars_BarFontText:SetFont(DPSMate.Options.fonts[this.value], 12)
		DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"] = this.value
		getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total_Name"):SetFont(DPSMate.Options.fonts[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total_Value"):SetFont(DPSMate.Options.fonts[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		for i=1, 30 do
			getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i.."_Name"):SetFont(DPSMate.Options.fonts[this.value], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
			getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i.."_Value"):SetFont(DPSMate.Options.fonts[this.value], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		end
    end
	
	for name, path in pairs(DPSMate.Options.fonts) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		getglobal("DropDownList1Button"..i.."NormalText"):SetFont(path, 16)
		i=i+1
	end
end

function DPSMate.Options:BarFontFlagsDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Bars_BarFontFlag, this.value)
		DPSMate_ConfigMenu_Tab_Bars_BarFontFlagText:SetFont(DPSMate.Options.fonts["FRIZQT"], 12, DPSMate.Options.fontflags[this.value])
		DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"] = this.value
		getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total_Name"):SetFont(DPSMate.Options.fonts[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total_Value"):SetFont(DPSMate.Options.fonts[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		for i=1, 30 do
			getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i.."_Name"):SetFont(DPSMate.Options.fonts[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
			getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i.."_Value"):SetFont(DPSMate.Options.fonts[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		end
    end
	
	for name, flag in pairs(DPSMate.Options.fontflags) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		getglobal("DropDownList1Button"..i.."NormalText"):SetFont(DPSMate.Options.fonts["FRIZQT"], 12, flag)
		i=i+1
	end
end

function DPSMate.Options:BarTextureDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Bars_BarTexture, this.value)
		DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["bartexture"] = this.value
		DPSMate_ConfigMenu_Tab_Bars_BarTexture.tex:SetTexture(DPSMate.Options.statusbars[this.value])
		DPSMate_ConfigMenu_Tab_Bars_BarTexture.tex:Show()
		getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total"):SetStatusBarTexture(DPSMate.Options.statusbars[this.value])
		getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total_BG"):SetTexture(DPSMate.Options.statusbars[this.value])
		for i=1, 30 do
			getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i):SetStatusBarTexture(DPSMate.Options.statusbars[this.value])
			getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i.."_BG"):SetTexture(DPSMate.Options.statusbars[this.value])
		end
	end
	
	for name, path in pairs(DPSMate.Options.statusbars) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		local button = getglobal("DropDownList1Button"..i)
		if not button.tex then
			button.tex = button:CreateTexture("BG", "BACKGROUND")
			button.tex:SetTexture(path)
			button.tex:SetWidth(100)
			button.tex:SetHeight(20)
			button.tex:SetPoint("TOPLEFT", button, "TOPLEFT")
		end
		button.tex:Show()
		i=i+1
	end
end

function DPSMate.Options:TitleBarTextureDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_TitleBar_BarTexture, this.value)
		DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["titlebartexture"] = this.value
		DPSMate_ConfigMenu_Tab_TitleBar_BarTexture.tex:SetTexture(DPSMate.Options.statusbars[this.value])
		DPSMate_ConfigMenu_Tab_TitleBar_BarTexture.tex:Show()
		getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_Head_Background"):SetTexture(DPSMate.Options.statusbars[this.value])
    end
	
	for name, path in pairs(DPSMate.Options.statusbars) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		local button = getglobal("DropDownList1Button"..i)
		if not button.tex then
			button.tex = button:CreateTexture("BG", "BACKGROUND")
			button.tex:SetTexture(path)
			button.tex:SetWidth(100)
			button.tex:SetHeight(20)
			button.tex:SetPoint("TOPLEFT", button, "TOPLEFT")
		end
		button.tex:Show()
		i=i+1
	end
end

function DPSMate.Options:TitleBarFontDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_TitleBar_BarFont, this.value)
		DPSMate_ConfigMenu_Tab_TitleBar_BarFontText:SetFont(DPSMate.Options.fonts[this.value], 12)
		DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["titlebarfont"] = this.value
		getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_Head_Font"):SetFont(DPSMate.Options.fonts[this.value], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["titlebarfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["titlebarfontflag"]])
    end
	
	for name, path in pairs(DPSMate.Options.fonts) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		getglobal("DropDownList1Button"..i.."NormalText"):SetFont(path, 16)
		i=i+1
	end
end

function DPSMate.Options:TitleBarFontFlagsDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_TitleBar_BarFontFlag, this.value)
		DPSMate_ConfigMenu_Tab_TitleBar_BarFontFlagText:SetFont(DPSMate.Options.fonts["FRIZQT"], 12, DPSMate.Options.fontflags[this.value])
		DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["titlebarfontflag"] = this.value
		getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_Head_Font"):SetFont(DPSMate.Options.fonts["FRIZQT"], 12, DPSMate.Options.fontflags[this.value])
    end
	
	for name, flag in pairs(DPSMate.Options.fontflags) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		getglobal("DropDownList1Button"..i.."NormalText"):SetFont(DPSMate.Options.fonts["FRIZQT"], 12, flag)
		i=i+1
	end
end

function DPSMate.Options:ContentBGTextureDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Content_BGDropDown, this.value)
		DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbgtexture"] = this.value
		getglobal("DPSMate_ConfigMenu_Tab_Content_BGDropDown_Texture"):SetBackdrop({ 
			bgFile = DPSMate.Options.bgtexture[this.value], 
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 12, edgeSize = 12, 
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
		})
		getglobal("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Background"):SetTexture(DPSMate.Options.bgtexture[this.value])
    end
	
	for name, path in pairs(DPSMate.Options.bgtexture) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		local button = getglobal("DropDownList1Button"..i)
		button.path = path
		button.i = i
		button:SetScript("OnEnter", function()
			getglobal(this:GetName().."Highlight"):Show()
			getglobal("DropDownList1Backdrop"):SetBackdrop({ 
				bgFile = this.path, 
				edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32, 
				insets = { left = 11, right = 12, top = 12, bottom = 11 }
			})
			getglobal("DropDownList1Backdrop"):SetBackdropColor(DPSMateSettings["contentbgcolor"][1], DPSMateSettings["contentbgcolor"][2], DPSMateSettings["contentbgcolor"][3])
		end)
		i=i+1
	end
end

function DPSMate.Options:SelectDataResets(obj, case)
	local vars = {["DPSMate_ConfigMenu_Tab_DataResets_EnteringWorld"] = "dataresetsworld", ["DPSMate_ConfigMenu_Tab_DataResets_PartyMemberChanged"] = "dataresetspartyamount", ["DPSMate_ConfigMenu_Tab_DataResets_JoinParty"] = "dataresetsjoinparty", ["DPSMate_ConfigMenu_Tab_DataResets_LeaveParty"] = "dataresetsleaveparty"}
	DPSMateSettings[vars[obj:GetName()]] = case
	UIDropDownMenu_SetSelectedValue(obj, case)
end

function DPSMate.Options:DataResetsDropDown()
	local btns = {"Yes", "No", "Ask"}
	
	local function on_click()
		DPSMate.Options:SelectDataResets(getglobal(UIDROPDOWNMENU_OPEN_MENU), this.value)
	end
	
	for val, name in pairs(btns) do
		UIDropDownMenu_AddButton{
			text = name,
			value = val,
			func = on_click,
		}
	end
	
	if not DPSMate_ConfigMenu.visBars8 then
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_DataResets_EnteringWorld, DPSMateSettings["dataresetsworld"])
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_DataResets_JoinParty, DPSMateSettings["dataresetsjoinparty"])
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_DataResets_PartyMemberChanged, DPSMateSettings["dataresetspartyamount"])
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_DataResets_LeaveParty, DPSMateSettings["dataresetsleaveparty"])
	end
	DPSMate_ConfigMenu.visBars8 = true
end

function DPSMate.Options:NumberFormatDropDown()
	local btns = {"Normal", "Condensed"}
	
	local function on_click()
		DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["numberformat"] = this.value
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Content_NumberFormat, DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["numberformat"])
		DPSMate:SetStatusBarValue()
	end
	
	for val, name in pairs(btns) do
		UIDropDownMenu_AddButton{
			text = name,
			value = val,
			func = on_click,
		}
	end
end

function DPSMate.Options:TooltipPositionDropDown()
	local btns = {"Default", "Top Right", "Top Left", "Left", "Top"}
	
	local function on_click()
		DPSMateSettings["tooltipanchor"] = this.value
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Tooltips_Position, DPSMateSettings["tooltipanchor"])
	end
	
	for val, name in pairs(btns) do
		UIDropDownMenu_AddButton{
			text = name,
			value = val,
			func = on_click,
		}
	end
	
	if not DPSMate_ConfigMenu.visBars10 then
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Tooltips_Position, DPSMateSettings["tooltipanchor"])
	end
	DPSMate_ConfigMenu.visBars10 = true
end

function DPSMate.Options:Report()
	local channel = UIDropDownMenu_GetSelectedValue(DPSMate_Report_Channel)
	local chn, index, sortedTable, total, a = nil, nil, DPSMate:GetSortedTable(DPSMate:GetMode(DPSMate_Report.PaKey))
	if (channel == "Whisper") then
		chn = "WHISPER"; index = DPSMate_Report_Editbox:GetText();
	elseif DPSMate:TContains({"Raid","Party","Say","Officer","Guild"}, channel) then
		chn = channel
	else
		chn = "CHANNEL"; index = GetChannelName(channel)
	end
	SendChatMessage("DPSMate - "..DPSMate.localization.reportfor..DPSMate:GetModeName(DPSMate_Report.PaKey), chn, nil, index)
	for i=1, DPSMate_Report_Lines:GetValue() do
		if (not sortedTable[i] or sortedTable[i] == 0) then break end
		SendChatMessage(i..". "..a[sortedTable[i]].." - "..sortedTable[i].." ("..string.format("%.1f", 100*sortedTable[i]/total).."%)", chn, nil, index)
	end
	DPSMate_Report:Hide()
end

function DPSMate.Options:NewSegment()
	a,b,c = DPSMate:GetSortedTable(DPSMateDamageDone[2])
	if b ~= 0 then
		if not DPSMateHistory["DMGDone"] then DPSMateHistory["DMGDone"] = {} end
		table.insert(DPSMateHistory["DMGDone"], 1, DPSMate:CopyTable(DPSMateDamageDone[2]))
		table.insert(DPSMateCombatTime["segments"], 1, DPSMateCombatTime["current"])
		if DPSMate:TableLength(DPSMateHistory["DMGDone"])>DPSMateSettings["datasegments"] then
			for i=DPSMateSettings["datasegments"]+1, DPSMate:TableLength(DPSMateHistory["DMGDone"]) do
				table.remove(DPSMateHistory["DMGDone"], i)
			end
			table.remove(DPSMateHistory["DMGDone"], DPSMateSettings["datasegments"]+1)
		end
		if DPSMate:TableLength(DPSMateCombatTime["segments"])>DPSMateSettings["datasegments"] then
			for i=DPSMateSettings["datasegments"]+1, DPSMate:TableLength(DPSMateCombatTime["segments"]) do
				table.remove(DPSMateCombatTime["segments"], i)
			end
		end
		DPSMateDamageDone[2] = {}
		DPSMateDamageTaken[2] = {}
		DPSMateCombatTime["current"] = 1
		DPSMate:SetStatusBarValue()
	end
	DPSMate.Options:InitializeSegments()
	DPSMate.Options.Dewdrop:Close()
end

function DPSMate.Options:InitializeSegments()
	local i=1
	Options[2]["args"] = {
		total = {
			order = 10,
			type = 'toggle',
			name = DPSMate.localization.config.total,
			desc = DPSMate.localization.desc.total,
			get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][2]["total"] end,
			set = function() DPSMate.Options:ToggleDrewDrop(2, "total", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
		},
		currentFight = {
			order = 20,
			type = 'toggle',
			name = DPSMate.localization.config.current,
			desc = DPSMate.localization.desc.current,
			get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][2]["currentfight"] end,
			set = function() DPSMate.Options:ToggleDrewDrop(2, "currentfight", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
		},
	}
	Options[3]["args"]["deletesegment"]["args"] = {}
	for cat, val in pairs(DPSMateHistory["DMGDone"]) do
		if not val then break end
		Options[2]["args"]["segment"..i] = {
			order = 20+i*10,
			type = 'toggle',
			name = "Segment "..i,
			desc = "Fight deatails for segment "..i,
			get = loadstring('return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][2]["segment'..i..'"];'),
			set = loadstring('DPSMate.Options:ToggleDrewDrop(2, "segment'..i..'", DPSMate.Options.Dewdrop:GetOpenedParent());'),
		}
		Options[3]["args"]["deletesegment"]["args"]["segment"..i] = {
			order = i*10,
			type = 'execute',
			name = "Segment "..i,
			desc = "Remove segment "..i,
			func = loadstring('DPSMate.Options:RemoveSegment('..i..');'),
		}
		i=i+1
	end
end

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
	if (na and not DPSMate:GetKeyByValInTT(DPSMateSettings["windows"], na, "name") and na~="") then
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
					dispels = false
				},
				[2] = {
					total = true,
					currentfight = false,
					segment1 = false,
					segment2 = false,
					segment3 = false,
					segment4 = false,
					segment5 = false,
					segment6 = false,
					segment7 = false,
					segment8 = false,
					segment9 = false,
					segment10 = false,
					segment11 = false,
					segment12 = false,
					segment13 = false
				}
			},
			CurMode = "damage",
			scale = 1,
			barfont = "ARIALN",
			barfontsize = 14,
			barfontflag = "Outline",
			bartexture = "Healbot",
			barspacing = 1,
			barheight = 19,
			classicons = true,
			ranks = true,
			titlebar = true,
			titlebarfont = "FRIZQT",
			titlebarfontflag = "None",
			titlebarfontsize = 12,
			titlebarheight = 18,
			titlebarreport = true,
			titlebarreset = true,
			titlebarsegments = true,
			titlebarconfig = true,
			titlebarsync = true,
			titlebartexture = "Healbot",
			titlebarbgcolor = {1,1,1},
			contentbgtexture = "UI-Tooltip-Background",
			contentbgcolor = {1,1,1},
			numberformat = 1
		})
		local TL = DPSMate:TableLength(DPSMateSettings["windows"])
		if not getglobal("DPSMate_"..na) then
			local fr=CreateFrame("Frame", "DPSMate_"..na, UIParent, "DPSMate_Statusframe")
			fr.Key=TL
		end
		if not getglobal("DPSMate_ConfigMenu_Menu_Button"..(6+TL)) then
			local f = CreateFrame("Button", "DPSMate_ConfigMenu_Menu_Button"..(6+TL), DPSMate_ConfigMenu_Menu, "DPSMate_Template_WindowButton")
			f.Key = TL
		end
		local frame = getglobal("DPSMate_ConfigMenu_Menu_Button"..(6+TL))
		frame:Show()
		getglobal("DPSMate_ConfigMenu_Menu_Button"..(6+TL).."Text"):SetText(na)
		if TL>1 then
			frame:SetPoint("TOP", getglobal("DPSMate_ConfigMenu_Menu_Button"..(5+TL)), "BOTTOM")
			getglobal("DPSMate_ConfigMenu_Menu_Button"..(5+TL)).after = frame
		else
			frame:SetPoint("TOP", DPSMate_ConfigMenu_Menu_Button1, "BOTTOM")
		end
		frame.after = DPSMate_ConfigMenu_Menu_Button2
		DPSMate_ConfigMenu.num = 6+TL
		frame.func = function()
			getglobal(this:GetParent():GetParent():GetName()..this:GetParent().selected):Hide()
			getglobal(this:GetParent():GetParent():GetName().."_Tab_Window"):Show()
			this:GetParent().selected = "_Tab_Window"
		end
		DPSMate_ConfigMenu_Menu_Button2:ClearAllPoints()
		DPSMate_ConfigMenu_Menu_Button2:SetPoint("TOP", frame, "BOTTOM")
		DPSMate:InitializeFrames()
		getglobal("DPSMate_"..na.."_Head_Font"):SetText("Damage")
		getglobal("DPSMate_"..na.."_ScrollFrame_Child"):SetWidth(150)
		getglobal("DPSMate_"..na.."_ScrollFrame"):SetHeight(84)
		DPSMate:SetStatusBarValue()
	end
end

function DPSMate.Options:RemoveWindow()
	local frame = getglobal("DPSMate_"..DPSMate_ConfigMenu.Selected)
	if frame then
		frame:Hide()
		getglobal("DPSMate_ConfigMenu_Menu_Button"..(6+frame.Key)):Hide()
		table.remove(DPSMateSettings["windows"], frame.Key)
		local TL = DPSMate:TableLength(DPSMateSettings["windows"])
		getglobal("DPSMate_ConfigMenu_Menu_Button"..(6+TL)).after = DPSMate_ConfigMenu_Menu_Button2
		DPSMate_ConfigMenu_Menu_Button2:ClearAllPoints()
		DPSMate_ConfigMenu_Menu_Button2:SetPoint("TOP", getglobal("DPSMate_ConfigMenu_Menu_Button"..(6+TL)), "BOTTOM")
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Window_Remove, "None")
		DPSMate_ConfigMenu_Menu_Button1.selected = true
		getglobal("DPSMate_ConfigMenu_Menu_Button"..(6+frame.Key)).selected = false
		getglobal("DPSMate_ConfigMenu_Menu_Button"..(6+frame.Key).."Texture"):Hide()
		getglobal("DPSMate_ConfigMenu_Menu_Button"..(6+frame.Key).."Text"):SetTextColor(1,0.82,0,1)
		getglobal("DPSMate_ConfigMenu_Menu_Button"..(6+frame.Key).."_Button1"):Hide()
		getglobal("DPSMate_ConfigMenu_Menu_Button"..(6+frame.Key).."_Button2"):Hide()
		getglobal("DPSMate_ConfigMenu_Menu_Button"..(6+frame.Key).."_Button3"):Hide()
		DPSMate_ConfigMenu_Menu_Button1Texture:Show()
	end
end

function DPSMate.Options:CopyConfiguration()
	local fromName = getglobal("DPSMate_ConfigMenu_Tab_Window_ConfigFromText"):GetText()
	local toName = getglobal("DPSMate_ConfigMenu_Tab_Window_ConfigToText"):GetText()
	if fromName~="None" and toName~="None" then
		local fromKey = getglobal("DPSMate_"..fromName).Key
		local toKey = getglobal("DPSMate_"..toName).Key
		for cat, val in pairs(DPSMateSettings["windows"][fromKey]) do
			if cat~="name" and cat~="options" then
				DPSMateSettings["windows"][toKey][cat] = val
			end
		end
		DPSMate:InitializeFrames()
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
	DPSMate:SendMessage("Locked all windows.")
end

function DPSMate.Options:Unlock()
	DPSMateSettings.lock = false
	for _,val in pairs(DPSMateSettings["windows"]) do
		getglobal("DPSMate_"..val["name"].."_Resize"):Show()
	end
	DPSMate:SendMessage("Unlocked all windows.")
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
	DPSMate.Options.Dewdrop:Close()
end

function DPSMate.Options:ToggleTitleBarButtonState()
	local buttons = {"Config", "Reset", "Segments", "Report", "Sync"}
	for _, val in pairs(DPSMateSettings["windows"]) do
		local parent, i = getglobal("DPSMate_"..val["name"].."_Head"), 0
		for _, name in pairs(buttons) do
			local button = getglobal("DPSMate_"..val["name"].."_Head_"..name)
			if val["titlebar"..strlower(name)] then
				button:ClearAllPoints()
				button:SetPoint("RIGHT", parent, "RIGHT", -i*15-2, 0)
				button:Show()
				i=i+1
			else
				button:Hide()
			end
		end
	end
end

function DPSMate.Options:SetColor()
	local r,g,b = ColorPickerFrame:GetColorRGB()
	local swatch,frame
	swatch = getglobal(ColorPickerFrame.obj:GetName().."NormalTexture")
	frame = getglobal(ColorPickerFrame.obj:GetName().."_SwatchBg")
	swatch:SetVertexColor(r,g,b)
	frame.r = r
	frame.g = g
	frame.b = b

	DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key][ColorPickerFrame.var] = {r,g,b}
	
	ColorPickerFrame.rfunc()
end

function DPSMate.Options:CancelColor()
	local r = ColorPickerFrame.previousValues.r
	local g = ColorPickerFrame.previousValues.g
	local b = ColorPickerFrame.previousValues.b
	local swatch,frame
	swatch = getglobal(ColorPickerFrame.obj:GetName().."NormalTexture")
	frame = getglobal(ColorPickerFrame.obj:GetName().."_SwatchBg")
	swatch:SetVertexColor(r,g,b)
	frame.r = r
	frame.g = g
	frame.b = b
	
	DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key][ColorPickerFrame.var] = {r,g,b}
	
	ColorPickerFrame.rfunc()
end

function DPSMate.Options:OpenColorPicker(obj, var, func)
	CloseMenus()
	
	button = getglobal(obj:GetName().."_SwatchBg")
	
	ColorPickerFrame.obj = obj
	ColorPickerFrame.var = var
	ColorPickerFrame.rfunc = func
	
	ColorPickerFrame.func = DPSMate.Options.SetColor
	ColorPickerFrame:SetColorRGB(button.r, button.g, button.b)
	ColorPickerFrame.previousValues = {r = button.r, g = button.g, b = button.b, opacity = button.opacity}
	ColorPickerFrame.cancelFunc = DPSMate.Options.CancelColor

	ColorPickerFrame:SetPoint("TOPLEFT", obj, "TOPRIGHT", 0, 0)

	ColorPickerFrame:Show()
end

function DPSMate.Options:ShowTooltip()
	if not this.user then return end
	if DPSMateSettings["showtooltips"] then
		DPSMate_Details.PaKey = this:GetParent():GetParent():GetParent().Key
		local arr = DPSMate:GetMode(DPSMate_Details.PaKey)
		local user, pet = "", 0
		DetailsArr, DetailsTotal, DmgArr = DPSMate.Options:EvalTable(DPSMateUser[this.user]["id"], DPSMate_Details.PaKey)
		if DPSMateSettings["tooltipanchor"] == 1 then
			GameTooltip:SetOwner(UIParent, "BOTTOMRIGHT")
		elseif DPSMateSettings["tooltipanchor"] == 2 then
			GameTooltip:SetOwner(this:GetParent():GetParent():GetParent(), "RIGHT")
		elseif DPSMateSettings["tooltipanchor"] == 3 then
			GameTooltip:SetOwner(this:GetParent():GetParent():GetParent(), "LEFT")
		elseif DPSMateSettings["tooltipanchor"] == 4 then
			GameTooltip:SetOwner(this:GetParent():GetParent():GetParent(), "TOP")
		elseif DPSMateSettings["tooltipanchor"] == 5 then
			GameTooltip:SetOwner(this:GetParent():GetParent():GetParent(), "TOPRIGHT")
		end
		GameTooltip:AddLine(this.user.."'s "..getglobal(this:GetParent():GetParent():GetParent():GetName().."_Head_Font"):GetText(), 1,1,1)
		if DPSMateSettings["informativetooltips"] then
			for i=1, DPSMateSettings["subviewrows"] do
				if not DetailsArr[i] then break end
				GameTooltip:AddDoubleLine(i..". "..DetailsArr[i],DmgArr[i],1,1,1,1,1,1)
			end
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("LeftClick to open the details.")
		GameTooltip:Show()
	end
end

function DPSMate.Options:InitializeHideShowWindow()
	local i = 1
	Options[3]["args"]["hidewindow"]["args"] = {}
	Options[3]["args"]["showwindow"]["args"] = {}
	for _,val in pairs(DPSMateSettings["windows"]) do
		Options[3]["args"]["hidewindow"]["args"][val["name"]] = {
			order = i*10,
			type = 'execute',
			name = val["name"],
			desc = "Hide "..val["name"],
			func = loadstring('getglobal("DPSMate_'..val["name"]..'"):Hide(); DPSMate.Options.Dewdrop:Close();'),
		}
		Options[3]["args"]["showwindow"]["args"][val["name"]] = {
			order = i*10,
			type = 'execute',
			name = val["name"],
			desc = "Show "..val["name"],
			func = loadstring('getglobal("DPSMate_'..val["name"]..'"):Show(); DPSMate.Options.Dewdrop:Close();'),
		}
		i=i+1
	end
end



