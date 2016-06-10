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
DPSMate.Options.graph = AceLibrary("Graph-1.0")
DPSMate.Options.Options = {
	[1] = {
		type = 'group',
		args = {
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
			test = {
				order = 5,
				type = 'toggle',
				name = DPSMate.localization.config.testmode,
				desc = DPSMate.localization.desc.testmode,
				get = function() return DPSMate.Options.TestMode end,
				set = function() DPSMate.Options:ActivateTestMode(); DPSMate.Options.Dewdrop:Close() end,
			},
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
				order = 31,
				type = 'header',
			},
			showAll  = {
				order = 32,
				type = 'execute',
				name = 'Show all',
				desc = 'Click to show all frames',
				func = function() for _, val in DPSMateSettings["windows"] do DPSMate.Options:Show(getglobal("DPSMate_"..val["name"])) end; DPSMate.Options.Dewdrop:Close() end,
			},
			hideAll  = {
				order = 33,
				type = 'execute',
				name = 'Hide all',
				desc = 'Click to hide all frames',
				func = function() for _, val in DPSMateSettings["windows"] do DPSMate.Options:Hide(getglobal("DPSMate_"..val["name"])) end; DPSMate.Options.Dewdrop:Close() end,
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
	[4] = {
		type = 'group',
		args = {
			report = {
				order = 10,
				type = 'group',
				name = "Report details",
				desc = "TO BE ADDED!",
				args = {
					whisper = {
						order = 10,
						type = "text",
						name = "Whisper",
						desc = "TO BE ADDED!",
						get = function() return "" end,
						set = function(name) DPSMate.Options:ReportUserDetails(DPSMate.Options.Dewdrop:GetOpenedParent(), "Whisper", name); DPSMate.Options.Dewdrop:Close() end,
						usage = "<name>",
					},
				},
			},
		},
		handler = DPSMate.Options,
	},
	[5] = {
		type = 'group',
		args = {
			classes = {
				order = 10,
				type = 'group',
				name = 'Classes',
				desc = 'TO BE ADDED!',
				args = {
					warrior = {
						order = 10,
						type = 'toggle',
						name = 'Warrior',
						desc = 'Show warriors',
						get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["warrior"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "warrior");DPSMate.Options.Dewdrop:Close() end,
					},
					rogue = {
						order = 20,
						type = 'toggle',
						name = 'Rogue',
						desc = 'Show rogues',
						get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["rogue"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "rogue");DPSMate.Options.Dewdrop:Close() end,
					},
					priest = {
						order = 30,
						type = 'toggle',
						name = 'Priest',
						desc = 'Show priests',
						get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["priest"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "priest");DPSMate.Options.Dewdrop:Close() end,
					},
					hunter = {
						order = 40,
						type = 'toggle',
						name = 'Hunter',
						desc = 'Show hunters',
						get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["hunter"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "hunter");DPSMate.Options.Dewdrop:Close() end,
					},
					druid = {
						order = 50,
						type = 'toggle',
						name = 'Druid',
						desc = 'Show druids',
						get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["druid"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "druid");DPSMate.Options.Dewdrop:Close() end,
					},
					mage = {
						order = 60,
						type = 'toggle',
						name = 'Mage',
						desc = 'Show mages',
						get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["mage"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "mage");DPSMate.Options.Dewdrop:Close() end,
					},
					warlock = {
						order = 70,
						type = 'toggle',
						name = 'Warlock',
						desc = 'Show warlocks',
						get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["warlock"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "warlock");DPSMate.Options.Dewdrop:Close() end,
					},
					paladin = {
						order = 80,
						type = 'toggle',
						name = 'Paladin',
						desc = 'Show paladins',
						get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["paladin"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "paladin");DPSMate.Options.Dewdrop:Close() end,
					},
					shamen = {
						order = 90,
						type = 'toggle',
						name = 'Shaman',
						desc = 'Show shamens',
						get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["shaman"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "shaman");DPSMate.Options.Dewdrop:Close() end,
					},
				},
			},
			people = {
				order = 20,
				type = 'text',
				name = 'Certain names',
				desc = 'Split them by "," Ex: Shino,',
				get = function() if DPSMate.Options.Dewdrop:GetOpenedParent() then return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterpeople"] else return "" end end,
				set = function(names) DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterpeople"] = names;DPSMate:SetStatusBarValue();DPSMate.Options.Dewdrop:Close() end,
				usage = "<names>",
			},
			group = {
				order = 30,
				type = "toggle",
				name = "Group only",
				desc = "Only show your group",
				get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["grouponly"] end,
				set = function() DPSMate.DB:OnGroupUpdate();DPSMate.Options:SimpleToggle(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "grouponly");DPSMate.Options.Dewdrop:Close() end,
			}
		},
		handler = DPSMate.Options,
	},
}
DPSMate.Options.TestMode = false

-- Local Variables
local _G = getglobal
local LastPopUp = 0
local TimeToNextPopUp = 1
local PartyNum, LastPartyNum = 0, 0
local SelectedChannel = "Raid"

-- Begin Functions

function DPSMate.Options:InitializeConfigMenu()
	-- Inialize Extra Buttons
	for cat, val in pairs(DPSMateSettings["windows"]) do
		local f = CreateFrame("Button", "DPSMate_ConfigMenu_Menu_Button"..(8+cat), DPSMate_ConfigMenu_Menu, "DPSMate_Template_WindowButton")
		f.Key = cat
		_G("DPSMate_ConfigMenu_Menu_Button"..(8+cat).."Text"):SetText(val["name"])
		if cat>1 then
			f:SetPoint("TOP", _G("DPSMate_ConfigMenu_Menu_Button"..(7+cat)), "BOTTOM")
			_G("DPSMate_ConfigMenu_Menu_Button"..(7+cat)).after = f
		else
			f:SetPoint("TOP", DPSMate_ConfigMenu_Menu_Button1, "BOTTOM")
		end
		f.after = DPSMate_ConfigMenu_Menu_Button2
		DPSMate_ConfigMenu.num = 8+cat
		f.func = function()
			_G(this:GetParent():GetParent():GetName()..this:GetParent().selected):Hide()
			_G(this:GetParent():GetParent():GetName().."_Tab_Window"):Show()
			this:GetParent().selected = "_Tab_Window"
		end
	end
	local TL = DPSMate:TableLength(DPSMateSettings["windows"])
	if TL>=1 then
		DPSMate_ConfigMenu_Menu_Button2:ClearAllPoints()
		DPSMate_ConfigMenu_Menu_Button2:SetPoint("TOP", _G("DPSMate_ConfigMenu_Menu_Button"..(8+TL)), "BOTTOM")
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
	DPSMate_ConfigMenu_Tab_GeneralOptions_BossFights:SetChecked(DPSMateSettings["onlybossfights"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_Solo:SetChecked(DPSMateSettings["hidewhensolo"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_Combat:SetChecked(DPSMateSettings["hideincombat"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_PVP:SetChecked(DPSMateSettings["hideinpvp"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_Disable:SetChecked(DPSMateSettings["disablewhilehidden"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_Segments:SetValue(DPSMateSettings["datasegments"])
	
	-- Tab Columns
	for i=1, 3 do
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_DPS_Check"..i):SetChecked(DPSMateSettings["columnsdps"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Damage_Check"..i):SetChecked(DPSMateSettings["columnsdmg"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_DamageTaken_Check"..i):SetChecked(DPSMateSettings["columnsdmgtaken"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_DTPS_Check"..i):SetChecked(DPSMateSettings["columnsdtps"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_EDD_Check"..i):SetChecked(DPSMateSettings["columnsedd"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_EDT_Check"..i):SetChecked(DPSMateSettings["columnsedt"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Healing_Check"..i):SetChecked(DPSMateSettings["columnshealing"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_HealingTaken_Check"..i):SetChecked(DPSMateSettings["columnshealingtaken"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_HPS_Check"..i):SetChecked(DPSMateSettings["columnshps"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Overhealing_Check"..i):SetChecked(DPSMateSettings["columnsoverhealing"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_EffectiveHealing_Check"..i):SetChecked(DPSMateSettings["columnsehealing"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_EffectiveHealingTaken_Check"..i):SetChecked(DPSMateSettings["columnsehealingtaken"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_EffectiveHPS_Check"..i):SetChecked(DPSMateSettings["columnsehps"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_EffectiveHPS_Check"..i):SetChecked(DPSMateSettings["columnsehps"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_HAB_Check"..i):SetChecked(DPSMateSettings["columnshab"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_FriendlyFire_Check"..i):SetChecked(DPSMateSettings["columnsfriendlyfire"][i])
	end
	for i=1, 2 do
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Absorbs_Check"..i):SetChecked(DPSMateSettings["columnsabsorbs"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_AbsorbsTaken_Check"..i):SetChecked(DPSMateSettings["columnsabsorbstaken"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Deaths_Check"..i):SetChecked(DPSMateSettings["columnsdeaths"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Interrupts_Check"..i):SetChecked(DPSMateSettings["columnsinterrupts"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Dispels_Check"..i):SetChecked(DPSMateSettings["columnsdispels"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_DispelsReceived_Check"..i):SetChecked(DPSMateSettings["columnsdispelsreceived"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Decurses_Check"..i):SetChecked(DPSMateSettings["columnsdecurses"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_DecursesReceived_Check"..i):SetChecked(DPSMateSettings["columnsdecursesreceived"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Disease_Check"..i):SetChecked(DPSMateSettings["columnsdisease"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_DiseaseReceived_Check"..i):SetChecked(DPSMateSettings["columnsdiseasereceived"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Poison_Check"..i):SetChecked(DPSMateSettings["columnspoison"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_PoisonReceived_Check"..i):SetChecked(DPSMateSettings["columnspoisonreceived"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Magic_Check"..i):SetChecked(DPSMateSettings["columnsmagic"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_MagicReceived_Check"..i):SetChecked(DPSMateSettings["columnsmagicreceived"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_AurasGained_Check"..i):SetChecked(DPSMateSettings["columnsaurasgained"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_AurasLost_Check"..i):SetChecked(DPSMateSettings["columnsauraslost"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_AuraUptime_Check"..i):SetChecked(DPSMateSettings["columnsaurauptime"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Procs_Check"..i):SetChecked(DPSMateSettings["columnsprocs"][i])
	end
	
	-- Tab Tooltips
	DPSMate_ConfigMenu_Tab_Tooltips_Tooltips:SetChecked(DPSMateSettings["showtooltips"])
	DPSMate_ConfigMenu_Tab_Tooltips_InformativeTooltips:SetChecked(DPSMateSettings["informativetooltips"])
	DPSMate_ConfigMenu_Tab_Tooltips_Rows:SetValue(DPSMateSettings["subviewrows"])
	
	-- Mode menu
	for cat, _ in DPSMateSettings["hiddenmodes"] do
		DPSMate.Options.Options[1]["args"][cat] = nil
	end
end

DPSMate.Options.OldLogout = Logout
function DPSMate.Options:Logout()
	if DPSMateSettings["sync"] then
		if UnitInRaid("player") then
			DPSMate:SendMessage("DPSMate cant be reset while being in Sync-Mode in raids.")
		else
			DPSMate.Options:PopUpAccept(true, true)
		end
	else
		DPSMate.Options:PopUpAccept(true, true)
	end
	--self:SumGraphData()
	DPSMate.Options.OldLogout()
end
Logout = function() 
	if DPSMateSettings["dataresetslogout"] == 3 then
		DPSMate_Logout:Show() 
	elseif DPSMateSettings["dataresetslogout"] == 2 then
		--DPSMate.Options:SumGraphData()
		DPSMate.Options.OldLogout()
	else
		DPSMate.Options:Logout()
	end
end

function DPSMate.Options:SumGraphData()
	for i=1,2 do
		-- Damage done
		for k,v in DPSMateDamageDone[i] do
			DPSMateDamageDone[i][k]["i"][1] = DPSMate.Sync:GetSummarizedTable(v["i"][1])
		end
		
		-- EDT
		for k,v in DPSMateEDT[i] do
			for key, var in v do 
				DPSMateEDT[i][k][key]["i"][1] = DPSMate.Sync:GetSummarizedTable(var["i"][1])
			end
		end
		
		-- EDD
		for k,v in DPSMateEDD[i] do
			for key, var in v do 
				DPSMateEDD[i][k][key]["i"][1] = DPSMate.Sync:GetSummarizedTable(var["i"][1])
			end
		end
		
		-- Damage taken
		for k,v in DPSMateDamageTaken[i] do
			DPSMateDamageTaken[i][k]["i"][1] = DPSMate.Sync:GetSummarizedTable(v["i"][1])
		end
		
		-- Ehealing
		for k,v in DPSMateEHealing[i] do
			DPSMateEHealing[i][k]["i"][2] = DPSMate.Sync:GetSummarizedTable(v["i"][2])
		end
		
		-- Thealing
		for k,v in DPSMateTHealing[i] do
			DPSMateTHealing[i][k]["i"][2] = DPSMate.Sync:GetSummarizedTable(v["i"][2])
		end
		
		-- Overhealing
		for k,v in DPSMateOverhealing[i] do
			DPSMateOverhealing[i][k]["i"][2] = DPSMate.Sync:GetSummarizedTable(v["i"][2])
		end
		
		-- Ehealing taken
		for k,v in DPSMateEHealingTaken[i] do
			DPSMateEHealingTaken[i][k]["i"][2] = DPSMate.Sync:GetSummarizedTable(v["i"][2])
		end
		
		-- Thealing taken
		for k,v in DPSMateHealingTaken[i] do
			DPSMateHealingTaken[i][k]["i"][2] = DPSMate.Sync:GetSummarizedTable(v["i"][2])
		end
	end
end

function DPSMate.Options:ToggleVisibility()
	for _, val in DPSMateSettings["windows"] do
		if val["hidden"] then
			getglobal("DPSMate_"..val["name"]):Show()
			val["hidden"] = false
		else
			getglobal("DPSMate_"..val["name"]):Hide()
			val["hidden"] = true
		end
	end
end

function DPSMate.Options:ActivateTestMode()
	if self.TestMode then
		self.TestMode = false
		DPSMate:SetStatusBarValue()
	else
		self.TestMode = true
		for k,c in DPSMateSettings.windows do
			if DPSMateSettings["showtotals"] then
				_G("DPSMate_"..c["name"].."_ScrollFrame_Child_Total_Name"):SetText("Total")
				_G("DPSMate_"..c["name"].."_ScrollFrame_Child_Total_Value"):SetText("3000000")
			end
			for i=1, 40 do
				local statusbar, name, value, texture, p = _G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i), _G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Name"), _G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Value"), _G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Icon"), ""
				_G("DPSMate_"..c["name"].."_ScrollFrame_Child"):SetHeight((i+1)*(c["barheight"]+c["barspacing"]))
				
				statusbar:SetStatusBarColor(0.78,0.61,0.43, 1)
				
				if c["ranks"] then p=i..". " else p="" end
				name:SetText(p.."Test "..i)
				value:SetText("100000")
				texture:SetTexture("Interface\\AddOns\\DPSMate\\images\\class\\warrior")
				statusbar:SetValue(100)
				
				statusbar.user = nil
				statusbar:Show()
			end
		end
	end
end

function DPSMate.Options:ToggleFilterClass(key, class)
	if DPSMateSettings["windows"][key]["filterclasses"][class] then
		DPSMateSettings["windows"][key]["filterclasses"][class] = false
	else
		DPSMateSettings["windows"][key]["filterclasses"][class] = true
	end
	DPSMate:SetStatusBarValue()
end

function DPSMate.Options:SimpleToggle(key, opt)
	if DPSMateSettings["windows"][key][opt] then
		DPSMateSettings["windows"][key][opt] = false
	else
		DPSMateSettings["windows"][key][opt] = true
	end
	DPSMate:SetStatusBarValue()
end

function DPSMate.Options:OnEvent(event)
	if event == "PARTY_MEMBERS_CHANGED" or event == "RAID_ROSTER_UPDATE" then
		DPSMate.Options:HideWhenSolo()
		if DPSMate.Options:IsInParty() then
			if LastPartyNum == 0 then
				if DPSMateSettings["dataresetsjoinparty"] == 3 then
					if (GetTime()-LastPopUp) > TimeToNextPopUp and (DPSMate:TableLength(DPSMateUser) ~= 0 or DPSMate:TableLength(DPSMateUserCurrent) ~= 0) then
						DPSMate.Options:ShowResetPopUp()
						LastPopUp = GetTime()
					end
				elseif DPSMateSettings["dataresetsjoinparty"] == 1 then
					DPSMate.Options:PopUpAccept()
				end
				DPSMate.DB:OnGroupUpdate()
			elseif LastPartyNum ~= PartyNum	then
				if DPSMateSettings["dataresetspartyamount"] == 3 then
					if (GetTime()-LastPopUp) > TimeToNextPopUp and (DPSMate:TableLength(DPSMateUser) ~= 0 or DPSMate:TableLength(DPSMateUserCurrent) ~= 0) then
						DPSMate.Options:ShowResetPopUp()
						LastPopUp = GetTime()
					end
				elseif DPSMateSettings["dataresetspartyamount"] == 1 then
					DPSMate.Options:PopUpAccept()
				end
				DPSMate.DB:OnGroupUpdate()
			end
		else
			if LastPartyNum > PartyNum then
				if DPSMateSettings["dataresetsleaveparty"] == 3 then
					if (GetTime()-LastPopUp) > TimeToNextPopUp and (DPSMate:TableLength(DPSMateUser) ~= 0 or DPSMate:TableLength(DPSMateUserCurrent) ~= 0) then
						DPSMate.Options:ShowResetPopUp()
						LastPopUp = GetTime()
					end
				elseif DPSMateSettings["dataresetsleaveparty"] == 1 then
					DPSMate.Options:PopUpAccept()
				end
				DPSMate.DB:OnGroupUpdate()
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		if DPSMateSettings["dataresetsworld"] == 3 then
			if (GetTime()-LastPopUp) > TimeToNextPopUp and (DPSMate:TableLength(DPSMateUser) ~= 0 or DPSMate:TableLength(DPSMateUserCurrent) ~= 0) then
				self:ShowResetPopUp()
				LastPopUp = GetTime()
			end
		elseif DPSMateSettings["dataresetsworld"] == 1 then
			self:PopUpAccept()
		end
		self:HideInPvP()
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		DPSMate.DB:OnGroupUpdate()
	end
end

function DPSMate.Options:ShowResetPopUp()
	if DPSMateSettings["sync"] then
		if IsPartyLeader() or IsRaidOfficer() or IsRaidLeader() then
			DPSMate_PopUp:Show()
		end
	else
		DPSMate_PopUp:Show()
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
		local frame = _G("DPSMate_"..val["name"])
		if DPSMate.Options:IsInBattleground() then
			frame:Hide()
			if DPSMateSettings["disablewhilehidden"] then
				DPSMate:Disable()
			end
		end
	end
	DPSMate.Options:HideWhenSolo()
end

function DPSMate.Options:HideWhenSolo()
	for _, val in pairs(DPSMateSettings["windows"]) do
		local frame = _G("DPSMate_"..val["name"])
		if DPSMateSettings["hidewhensolo"] and not DPSMate.Options:IsInBattleground() then
			if GetNumPartyMembers() == 0 then
				frame:Hide()
				if DPSMateSettings["disablewhilehidden"] then
					DPSMate:Disable()
				end
			else
				if not val["hidden"] then
					frame:Show()
				end
				DPSMate:Enable()
			end
		end
	end
end

function DPSMate.Options:IsInParty()
	LastPartyNum = PartyNum
	if UnitInRaid("player") then
		PartyNum = GetNumRaidMembers()
		return true
	elseif GetNumPartyMembers() > 0 then
		PartyNum = GetNumPartyMembers()
		return true
	else
		PartyNum = 0
		return false
	end
end

function DPSMate.Options:PopUpAccept(bool, bypass)
	DPSMate_PopUp:Hide()
	if DPSMate.DB:InPartyOrRaid() and not bypass and DPSMateSettings["sync"] and bool then
		if IsPartyLeader() or IsRaidOfficer() or IsRaidLeader() then
			DPSMate.Sync:StartVote()
		else
			DPSMate:SendMessage("You are not the leader of the group or an assist!")
			return
		end
	else
		if bool then
			DPSMateDamageDone = {[1]={},[2]={}}
			DPSMateDamageTaken = {[1]={},[2]={}}
			DPSMateEDD = {[1]={},[2]={}}
			DPSMateEDT = {[1]={},[2]={}}
			DPSMateTHealing = {[1]={},[2]={}}
			DPSMateEHealing = {[1]={},[2]={}}
			DPSMateOverhealing = {[1]={},[2]={}}
			DPSMateHealingTaken = {[1]={},[2]={}}
			DPSMateEHealingTaken = {[1]={},[2]={}}
			DPSMateAbsorbs = {[1]={},[2]={}}
			DPSMateDispels = {[1]={},[2]={}}
			DPSMateDeaths = {[1]={},[2]={}}
			DPSMateInterrupts = {[1]={},[2]={}}
			DPSMateAurasGained = {[1]={},[2]={}}
			DPSMateHistory = {
				names = {},
				DMGDone = {},
				DMGTaken = {},
				EDDone = {},
				EDTaken = {},
				THealing = {},
				EHealing = {},
				OHealing = {},
				EHealingTaken = {},
				THealingTaken = {},
				Absorbs = {},
				Deaths = {},
				Interrupts = {},
				Dispels = {},
				Auras = {}
			}
			DPSMateCombatTime = {
				total = 1,
				current = 1,
				segments = {},
			}
			DPSMateAttempts = {}
			DPSMateLoot = {}
		else
			DPSMateDamageDone[2] = {}
			DPSMateDamageTaken[2] = {}
			DPSMateEDD[2] = {}
			DPSMateEDT[2] = {}
			DPSMateTHealing[2] = {}
			DPSMateEHealing[2] = {}
			DPSMateOverhealing[2] = {}
			DPSMateHealingTaken[2] = {}
			DPSMateEHealingTaken[2] = {}
			DPSMateAbsorbs[2] = {}
			DPSMateDispels[2] = {}
			DPSMateDeaths[2] = {}
			DPSMateInterrupts[2] = {}
			DPSMateAurasGained[2] = {}
			DPSMateCombatTime["current"] = 1
		end
		DPSMate.Modules.DPS.DB = DPSMateDamageDone
		DPSMate.Modules.Damage.DB = DPSMateDamageDone
		DPSMate.Modules.DamageTaken.DB = DPSMateDamageTaken
		DPSMate.Modules.FriendlyFire.DB = DPSMateEDT
		DPSMate.Modules.DTPS.DB = DPSMateDamageTaken
		DPSMate.Modules.EDD.DB = DPSMateEDD
		DPSMate.Modules.EDT.DB = DPSMateEDT
		DPSMate.Modules.Healing.DB = DPSMateTHealing
		DPSMate.Modules.HPS.DB = DPSMateTHealing
		DPSMate.Modules.Overhealing.DB = DPSMateOverhealing
		DPSMate.Modules.EffectiveHealing.DB = DPSMateEHealing
		DPSMate.Modules.EffectiveHPS.DB = DPSMateEHealing
		DPSMate.Modules.HealingTaken.DB = DPSMateHealingTaken
		DPSMate.Modules.EffectiveHealingTaken.DB = DPSMateEHealingTaken
		DPSMate.Modules.Absorbs.DB = DPSMateAbsorbs
		DPSMate.Modules.AbsorbsTaken.DB = DPSMateAbsorbs
		DPSMate.Modules.HealingAndAbsorbs.DB = DPSMateAbsorbs
		DPSMate.Modules.Deaths.DB = DPSMateDeaths
		DPSMate.Modules.Dispels.DB = DPSMateDispels
		DPSMate.Modules.DispelsReceived.DB = DPSMateDispels
		DPSMate.Modules.Decurses.DB = DPSMateDispels
		DPSMate.Modules.DecursesReceived.DB = DPSMateDispels
		DPSMate.Modules.CureDisease.DB = DPSMateDispels
		DPSMate.Modules.CureDiseaseReceived.DB = DPSMateDispels
		DPSMate.Modules.CurePoison.DB = DPSMateDispels
		DPSMate.Modules.CurePoisonReceived.DB = DPSMateDispels
		DPSMate.Modules.LiftMagic.DB = DPSMateDispels
		DPSMate.Modules.LiftMagicReceived.DB = DPSMateDispels
		DPSMate.Modules.Interrupts.DB = DPSMateInterrupts
		DPSMate.Modules.AurasGained.DB = DPSMateAurasGained
		DPSMate.Modules.AurasLost.DB = DPSMateAurasGained
		DPSMate.Modules.AurasUptimers.DB = DPSMateAurasGained
		DPSMate.Modules.Procs.DB = DPSMateAurasGained
		for _, val in pairs(DPSMateSettings["windows"]) do
			if not val["options"][2]["total"] and not val["options"][2]["currentfight"] then
				val["options"][2]["total"] = true
			end
		end
		DPSMate.Options:InitializeSegments()
		DPSMate:SetStatusBarValue()
	end
end

function DPSMate.Options:OpenMenu(b, obj)
	for _, val in pairs(DPSMateSettings.windows) do
		if DPSMate.Options.Dewdrop:IsOpen(_G("DPSMate_"..val["name"])) then
			DPSMate.Options.Dewdrop:Close()
			return
		end
		if DPSMate.Options.Dewdrop:IsRegistered(_G("DPSMate_"..val["name"])) then DPSMate.Options.Dewdrop:Unregister(_G("DPSMate_"..val["name"])) end
	end
	DPSMate.Options.Dewdrop:Register(obj,
		'children', function() 
			DPSMate.Options.Dewdrop:FeedAceOptionsTable(DPSMate.Options.Options[b]) 
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
		_G(pa:GetName().."_Head_Font"):SetText(DPSMate.Options.Options[i]["args"][obj].name)
		DPSMateSettings["windows"][pa.Key]["CurMode"] = obj
	end
	DPSMate.Options.Dewdrop:Close()
	if DPSMate.DB.loaded then DPSMate:SetStatusBarValue() end
	return true
end

function DPSMate.Options:UpdateDetails(obj)
	local key = obj:GetParent():GetParent():GetParent().Key
	if obj.user then
		DPSMate.RegistredModules[DPSMateSettings["windows"][key]["CurMode"]]:OpenDetails(obj, key)
	else
		DPSMate:SendMessage("Could not find this user!")
	end
end

function DPSMate.Options:UpdateTotalDetails(obj)
	local key = obj:GetParent():GetParent():GetParent().Key
	if obj.user then
		DPSMate.RegistredModules[DPSMateSettings["windows"][key]["CurMode"]]:OpenTotalDetails(obj, key)
	else
		DPSMate:SendMessage("Could not find this user!")
	end
end

function DPSMate.Options:DropDownStyleReset()
	for i=1, 20 do
		local button = _G("DropDownList1Button"..i)
		_G("DropDownList1Button"..i.."NormalText"):SetFont(DPSMate.Options.fonts["FRIZQT"], 12)
		_G("DropDownList1Button"..i):SetScript("OnEnter", function()
			_G(this:GetName().."Highlight"):Show()
		end)
		_G("DropDownList1Backdrop"):SetBackdrop({ 
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32, 
			insets = { left = 11, right = 12, top = 12, bottom = 11 }
		})
		if button.tex then
			button.tex:Hide()
		end
	end
end

function DPSMate.Options:UpdateConfigModes(obj, o, p) 
	local line, lineplusoffset
	local TL = DPSMate:TableLength(DPSMate.ModuleNames)
	local path, t = obj:GetName().."_Button", {}
	if p then
		for cat, val in DPSMate.ModuleNames do
			if not DPSMate:TContains(DPSMateSettings["hiddenmodes"], val) then
				table.insert(t, 1, cat)
			end
		end
	else
		for cat, val in DPSMate.ModuleNames do
			if DPSMate:TContains(DPSMateSettings["hiddenmodes"], val) then
				table.insert(t, 1, cat)
			end
		end
	end
	local TL = DPSMate:TableLength(t)
	obj.offset = (obj.offset or 0) - o 
	if obj.offset > (TL-15) then obj.offset = (TL-15) end
	if obj.offset < 0 then obj.offset = 0 end
	for line=1, 15 do
		lineplusoffset = line + obj.offset
		if t[lineplusoffset] then
			_G(path..line.."Text"):SetText(t[lineplusoffset])
			_G(path..line):Show()
		else
			_G(path..line):Hide()
		end
		_G(path..line.."Texture"):Hide()
		_G(path..line.."Text"):SetTextColor(1,1,1,1)
		_G(path..line).selected = false
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
	
	UIDropDownMenu_SetSelectedValue(DPSMate_Report_Channel, SelectedChannel)
end

function DPSMate.Options:WindowDropDown()
	DPSMate_ConfigMenu.Selected = "None"
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(_G(UIDROPDOWNMENU_OPEN_MENU), this.value)
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
		_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total_Name"):SetFont(DPSMate.Options.fonts[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total_Value"):SetFont(DPSMate.Options.fonts[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		for i=1, 40 do
			_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i.."_Name"):SetFont(DPSMate.Options.fonts[this.value], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
			_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i.."_Value"):SetFont(DPSMate.Options.fonts[this.value], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		end
    end
	
	for name, path in pairs(DPSMate.Options.fonts) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		_G("DropDownList1Button"..i.."NormalText"):SetFont(path, 16)
		i=i+1
	end
end

function DPSMate.Options:BarFontFlagsDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Bars_BarFontFlag, this.value)
		DPSMate_ConfigMenu_Tab_Bars_BarFontFlagText:SetFont(DPSMate.Options.fonts["FRIZQT"], 12, DPSMate.Options.fontflags[this.value])
		DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"] = this.value
		_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total_Name"):SetFont(DPSMate.Options.fonts[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total_Value"):SetFont(DPSMate.Options.fonts[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		for i=1, 40 do
			_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i.."_Name"):SetFont(DPSMate.Options.fonts[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
			_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i.."_Value"):SetFont(DPSMate.Options.fonts[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		end
    end
	
	for name, flag in pairs(DPSMate.Options.fontflags) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		_G("DropDownList1Button"..i.."NormalText"):SetFont(DPSMate.Options.fonts["FRIZQT"], 12, flag)
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
		_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total"):SetStatusBarTexture(DPSMate.Options.statusbars[this.value])
		_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total_BG"):SetTexture(DPSMate.Options.statusbars[this.value])
		for i=1, 40 do
			_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i):SetStatusBarTexture(DPSMate.Options.statusbars[this.value])
			_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i.."_BG"):SetTexture(DPSMate.Options.statusbars[this.value])
		end
	end
	
	for name, path in pairs(DPSMate.Options.statusbars) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		local button = _G("DropDownList1Button"..i)
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
		_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_Head_Background"):SetTexture(DPSMate.Options.statusbars[this.value])
    end
	
	for name, path in pairs(DPSMate.Options.statusbars) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		local button = _G("DropDownList1Button"..i)
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
		_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_Head_Font"):SetFont(DPSMate.Options.fonts[this.value], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["titlebarfontsize"], DPSMate.Options.fontflags[DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["titlebarfontflag"]])
    end
	
	for name, path in pairs(DPSMate.Options.fonts) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		_G("DropDownList1Button"..i.."NormalText"):SetFont(path, 16)
		i=i+1
	end
end

function DPSMate.Options:TitleBarFontFlagsDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_TitleBar_BarFontFlag, this.value)
		DPSMate_ConfigMenu_Tab_TitleBar_BarFontFlagText:SetFont(DPSMate.Options.fonts["FRIZQT"], 12, DPSMate.Options.fontflags[this.value])
		DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["titlebarfontflag"] = this.value
		_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_Head_Font"):SetFont(DPSMate.Options.fonts["FRIZQT"], 12, DPSMate.Options.fontflags[this.value])
    end
	
	for name, flag in pairs(DPSMate.Options.fontflags) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		_G("DropDownList1Button"..i.."NormalText"):SetFont(DPSMate.Options.fonts["FRIZQT"], 12, flag)
		i=i+1
	end
end

function DPSMate.Options:ContentBGTextureDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Content_BGDropDown, this.value)
		DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbgtexture"] = this.value
		_G("DPSMate_ConfigMenu_Tab_Content_BGDropDown_Texture"):SetBackdrop({ 
			bgFile = DPSMate.Options.bgtexture[this.value], 
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 12, edgeSize = 12, 
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
		})
		_G("DPSMate_ConfigMenu_Tab_Content_BGDropDown_Texture"):SetBackdropColor(DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbgcolor"][1], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbgcolor"][2], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbgcolor"][3])
		_G("DPSMate_"..DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Background"):SetTexture(DPSMate.Options.bgtexture[this.value])
    end
	
	for name, path in pairs(DPSMate.Options.bgtexture) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		local button = _G("DropDownList1Button"..i)
		button.path = path
		button.i = i
		button:SetScript("OnEnter", function()
			_G(this:GetName().."Highlight"):Show()
			_G("DropDownList1Backdrop"):SetBackdrop({ 
				bgFile = this.path, 
				edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32, 
				insets = { left = 11, right = 12, top = 12, bottom = 11 }
			})
			_G("DropDownList1Backdrop"):SetBackdropColor(DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbgcolor"][1], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbgcolor"][2], DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbgcolor"][3])
		end)
		i=i+1
	end
end

function DPSMate.Options:SelectDataResets(obj, case)
	local vars = {["DPSMate_ConfigMenu_Tab_DataResets_EnteringWorld"] = "dataresetsworld", ["DPSMate_ConfigMenu_Tab_DataResets_PartyMemberChanged"] = "dataresetspartyamount", ["DPSMate_ConfigMenu_Tab_DataResets_JoinParty"] = "dataresetsjoinparty", ["DPSMate_ConfigMenu_Tab_DataResets_LeaveParty"] = "dataresetsleaveparty", ["DPSMate_ConfigMenu_Tab_DataResets_Sync"] = "dataresetssync", ["DPSMate_ConfigMenu_Tab_DataResets_Logout"] = "dataresetslogout"}
	DPSMateSettings[vars[obj:GetName()]] = case
	UIDropDownMenu_SetSelectedValue(obj, case)
end

function DPSMate.Options:DataResetsDropDown()
	local btns = {"Yes", "No", "Ask"}
	
	local function on_click()
		DPSMate.Options:SelectDataResets(_G(UIDROPDOWNMENU_OPEN_MENU), this.value)
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
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_DataResets_Sync, DPSMateSettings["dataresetssync"])
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_DataResets_Logout, DPSMateSettings["dataresetslogout"])
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
	SelectedChannel = channel
	local arr, cbt = DPSMate:GetMode(DPSMate_Report.PaKey)
	local chn, index, name, value, perc = nil, nil, nil, nil, nil
	name, value, perc = DPSMate:GetSettingValues(arr, cbt, DPSMate_Report.PaKey)
	if (channel == "Whisper") then
		chn = "WHISPER"; index = DPSMate_Report_Editbox:GetText();
	elseif DPSMate:TContains({"Raid","Party","Say","Officer","Guild"}, channel) then
		chn = channel
	else
		chn = "CHANNEL"; index = GetChannelName(channel)
	end
	SendChatMessage("DPSMate - "..DPSMate.localization.reportfor..DPSMate:GetModeName(DPSMate_Report.PaKey or 1).." - ".._G("DPSMate_"..DPSMateSettings["windows"][DPSMate_Report.PaKey or 1]["name"].."_Head_Font"):GetText(), chn, nil, index)
	for i=1, DPSMate_Report_Lines:GetValue() do
		if (not value[i] or value[i] == 0) then break end
		SendChatMessage(i..". "..name[i].." -"..value[i], chn, nil, index)
	end
	DPSMate_Report:Hide()
end

local AbilityModes = {"damage", "dps", "healing", "hps", "overhealing", "effectivehealing", "effectivehps", "deaths", "interrupts", "dispels", "aurasgained", "auraslost", "aurasuptime"}
function DPSMate.Options:ReportUserDetails(obj, channel, name)
	local Key, user = obj:GetParent():GetParent():GetParent().Key, obj.user
	local a,b,c = DPSMate.RegistredModules[DPSMateSettings["windows"][Key]["CurMode"]]:EvalTable(DPSMateUser[user], Key)
	local chn, index
	if (channel == "Whisper") then
		chn = "WHISPER"; index = name;
	elseif DPSMate:TContains({"Raid","Party","Say","Officer","Guild"}, channel) then
		chn = channel
	else
		chn = "CHANNEL"; index = GetChannelName(channel)
	end
	SendChatMessage("DPSMate - Report of "..user.."'s ".._G("DPSMate_"..DPSMateSettings["windows"][Key]["name"].."_Head_Font"):GetText().." - "..DPSMate:GetModeName(Key), chn, nil, index)
	for i=1, 5 do
		if (not a[i]) then break end
		local p
		if type(c[i])=="table" then p = c[i][1] else p = c[i] end
		if DPSMate:TContains(AbilityModes, DPSMateSettings["windows"][Key]["CurMode"]) then
			SendChatMessage(i..". "..DPSMate:GetAbilityById(a[i]).." - "..p, chn, nil, index)
		else
			SendChatMessage(i..". "..DPSMate:GetUserById(a[i]).." - "..p, chn, nil, index)
		end
	end
end

function DPSMate.Options:InializePlayerDewDrop(obj)
	local channel, i = {[1]="Raid",[2]="Party",[3]="Say",[4]="Officer",[5]="Guild"}, 1
	local path = DPSMate.Options.Options[4]["args"]["report"]["args"]
	-- Name
	DPSMate.Options.Options[4]["args"]["player"] = {
		order = 1,
		type = "header",
		name = obj.user,
	}
	DPSMate.Options.Options[4]["args"]["details"] = {
		order = 2,
		type = "execute",
		name = "Open details",
		desc = "TO BE ADDED!",
		func = function() DPSMate.Options:UpdateDetails(obj); DPSMate.Options.Dewdrop:Close() end,
	}
	
	-- Report channel
	while true do
		local id, name = GetChannelName(i);
		if (not name) then break end
		table.insert(channel, name)
		i=i+1
	end
	
	for cat, val in channel do
		path["a"..cat] = {
			order = 10*cat+10,
			type = "execute",
			name = val,
			desc = "TO BE ADDED!",
			func = loadstring('DPSMate.Options:ReportUserDetails(DPSMate.Options.Dewdrop:GetOpenedParent(), "'..val..'"); DPSMate.Options.Dewdrop:Close()'),
		}
	end
end

function DPSMate.Options:NewSegment()
	-- Get name of this session
	local _,_,a = DPSMate.Modules.EDT:GetSortedTable(DPSMateEDT[2])
	local name = DPSMate:GetUserById(a[1]) or "Unknown"
	DPSMate.DB:Attempt(false)
	if DPSMateSettings["onlybossfights"] then
		if DPSMate.BabbleBoss:Contains(name) then
			DPSMate.Options:CreateSegment(name)
		end
	else
		DPSMate.Options:CreateSegment(name)
	end
	
	DPSMateDamageDone[2] = {}
	DPSMateDamageTaken[2] = {}
	DPSMateEDD[2] = {}
	DPSMateEDT[2] = {}
	DPSMateTHealing[2] = {}
	DPSMateEHealing[2] = {}
	DPSMateOverhealing[2] = {}
	DPSMateEHealingTaken[2] = {}
	DPSMateHealingTaken[2] = {}
	DPSMateAbsorbs[2] = {}
	DPSMateDeaths[2] = {}
	DPSMateInterrupts[2] = {}
	DPSMateDispels[2] = {}
	DPSMateAurasGained[2] = {}
	DPSMateCombatTime["current"] = 1
	DPSMate:SetStatusBarValue()
end

function DPSMate.Options:CreateSegment(name)
	-- Need to add a new check
	local modes = {["DMGDone"] = DPSMateDamageDone[2], ["DMGTaken"] = DPSMateDamageTaken[2], ["EDDone"] = DPSMateEDD[2], ["EDTaken"] = DPSMateEDT[2], ["THealing"] = DPSMateTHealing[2], ["EHealing"] = DPSMateEHealing[2], ["OHealing"] = DPSMateOverhealing[2], ["EHealingTaken"] = DPSMateEHealingTaken[2], ["THealingTaken"] = DPSMateHealingTaken[2], ["Absorbs"] = DPSMateAbsorbs[2], ["Deaths"] = DPSMateDeaths[2], ["Interrupts"] = DPSMateInterrupts[2], ["Dispels"] = DPSMateDispels[2], ["Auras"] = DPSMateAurasGained[2]}
	
	table.insert(DPSMateHistory["names"], 1, name.." - "..GameTime_GetTime())
	for cat, val in pairs(modes) do
		table.insert(DPSMateHistory[cat], 1, DPSMate:CopyTable(val))
		if DPSMate:TableLength(DPSMateHistory[cat])>DPSMateSettings["datasegments"] then
			for i=DPSMateSettings["datasegments"]+1, DPSMate:TableLength(DPSMateHistory[cat]) do
				table.remove(DPSMateHistory[cat], i)
			end
			table.remove(DPSMateHistory[cat], DPSMateSettings["datasegments"]+1)
		end
		if DPSMate:TableLength(DPSMateCombatTime["segments"])>DPSMateSettings["datasegments"] then
			for i=DPSMateSettings["datasegments"]+1, DPSMate:TableLength(DPSMateCombatTime["segments"]) do
				table.remove(DPSMateCombatTime["segments"], i)
			end
		end
	end
	table.insert(DPSMateCombatTime["segments"], 1, DPSMateCombatTime["current"])
	DPSMate.Options:InitializeSegments()
end

function DPSMate.Options:InitializeSegments()
	local i=1
	DPSMate.Options.Options[2]["args"] = {
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
	DPSMate.Options.Options[3]["args"]["deletesegment"]["args"] = {}
	for cat, val in pairs(DPSMateHistory["DMGDone"]) do
		if not val then break end
		DPSMate.Options.Options[2]["args"]["segment"..i] = {
			order = 20+i*10,
			type = 'toggle',
			name = i..". "..DPSMateHistory["names"][i],
			desc = "Fight deatails for segment "..i,
			get = loadstring('return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][2]["segment'..i..'"];'),
			set = loadstring('DPSMate.Options:ToggleDrewDrop(2, "segment'..i..'", DPSMate.Options.Dewdrop:GetOpenedParent());'),
		}
		DPSMate.Options.Options[3]["args"]["deletesegment"]["args"]["segment"..i] = {
			order = i*10,
			type = 'execute',
			name = i..". "..DPSMateHistory["names"][i],
			desc = "Remove segment "..i,
			func = loadstring('DPSMate.Options:RemoveSegment('..i..');'),
		}
		i=i+1
	end
end

function DPSMate.Options:OnVerticalScroll(obj, arg1, pre, spec)
	pre = pre or 20
	local maxScroll = _G(obj:GetName().."_Child"):GetHeight()-100
	if spec then maxScroll = maxScroll + 100 end
	local Scroll = obj:GetVerticalScroll()
	local toScroll = (Scroll - (pre*arg1))
	if toScroll < 0 then
		obj:SetVerticalScroll(0)
	elseif toScroll > maxScroll then
		obj:SetVerticalScroll(maxScroll)
	else
		obj:SetVerticalScroll(toScroll)
	end
end

function DPSMate.Options:CreateWindow()
	local na = string.gsub(DPSMate_ConfigMenu_Tab_Window_Editbox:GetText(), "%s", "")
	if (na and not DPSMate:GetKeyByValInTT(DPSMateSettings["windows"], na, "name") and na~="") then
		table.insert(DPSMateSettings["windows"], {
			name = na,
			options = {
				[1] = {
					damage = true
				},
				[2] = {
					total = true
				}
			},
			CurMode = "damage",
			hidden = false,
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
			titlebarenable = true,
			titlebarfilter = true,
			titlebarsync = DPSMateSettings["sync"],
			titlebarenable = DPSMateSettings["enable"],
			titlebartexture = "Healbot",
			titlebarbgcolor = {0.01568627450980392,0,1},
			titlebarfontcolor = {1.0,0.82,0.0},
			barfontcolor = {1.0,1.0,1.0},
			contentbgtexture = "UI-Tooltip-Background",
			contentbgcolor = {0.01568627450980392,0,1},
			bgbarcolor = {1,1,1},
			numberformat = 1,
			opacity = 1,
			bgopacity = 1,
			titlebaropacity = 1,
			filterclasses = {
				warrior = true,
				rogue = true,
				priest = true,
				hunter = true,
				mage = true,
				warlock = true,
				paladin = true,
				shaman = true,
				druid = true,
			},
			filterpeople = "",
			grouponly = false,
		})
		local TL = DPSMate:TableLength(DPSMateSettings["windows"])
		if not _G("DPSMate_"..na) then
			local fr=CreateFrame("Frame", "DPSMate_"..na, UIParent, "DPSMate_Statusframe")
			fr.Key=TL
		end
		if not _G("DPSMate_ConfigMenu_Menu_Button"..(8+TL)) then
			local f = CreateFrame("Button", "DPSMate_ConfigMenu_Menu_Button"..(8+TL), DPSMate_ConfigMenu_Menu, "DPSMate_Template_WindowButton")
			f.Key = TL
		end
		local frame = _G("DPSMate_ConfigMenu_Menu_Button"..(8+TL))
		frame:Show()
		_G("DPSMate_ConfigMenu_Menu_Button"..(8+TL).."Text"):SetText(na)
		if TL>1 then
			frame:SetPoint("TOP", _G("DPSMate_ConfigMenu_Menu_Button"..(7+TL)), "BOTTOM")
			_G("DPSMate_ConfigMenu_Menu_Button"..(7+TL)).after = frame
		else
			frame:SetPoint("TOP", DPSMate_ConfigMenu_Menu_Button1, "BOTTOM")
		end
		frame.after = DPSMate_ConfigMenu_Menu_Button2
		DPSMate_ConfigMenu.num = 8+TL
		frame.func = function()
			_G(this:GetParent():GetParent():GetName()..this:GetParent().selected):Hide()
			_G(this:GetParent():GetParent():GetName().."_Tab_Window"):Show()
			this:GetParent().selected = "_Tab_Window"
		end
		DPSMate_ConfigMenu_Menu_Button2:ClearAllPoints()
		DPSMate_ConfigMenu_Menu_Button2:SetPoint("TOP", frame, "BOTTOM")
		DPSMate:InitializeFrames()
		_G("DPSMate_"..na.."_Head_Font"):SetText("Damage")
		_G("DPSMate_"..na.."_ScrollFrame_Child"):SetWidth(150)
		_G("DPSMate_"..na.."_ScrollFrame"):SetHeight(84)
		DPSMate:SetStatusBarValue()
	end
end

function DPSMate.Options:RemoveWindow()
	local frame = _G("DPSMate_"..DPSMate_ConfigMenu.Selected)
	if frame then
		frame:Hide()
		_G("DPSMate_ConfigMenu_Menu_Button"..(8+frame.Key)):Hide()
		table.remove(DPSMateSettings["windows"], frame.Key)
		local TL = DPSMate:TableLength(DPSMateSettings["windows"])
		_G("DPSMate_ConfigMenu_Menu_Button"..(8+TL)).after = DPSMate_ConfigMenu_Menu_Button2
		DPSMate_ConfigMenu_Menu_Button2:ClearAllPoints()
		DPSMate_ConfigMenu_Menu_Button2:SetPoint("TOP", _G("DPSMate_ConfigMenu_Menu_Button"..(8+TL)), "BOTTOM")
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Window_Remove, "None")
		DPSMate_ConfigMenu_Menu_Button1.selected = true
		_G("DPSMate_ConfigMenu_Menu_Button"..(8+frame.Key)).selected = false
		_G("DPSMate_ConfigMenu_Menu_Button"..(8+frame.Key).."Texture"):Hide()
		_G("DPSMate_ConfigMenu_Menu_Button"..(8+frame.Key).."Text"):SetTextColor(1,0.82,0,1)
		_G("DPSMate_ConfigMenu_Menu_Button"..(8+frame.Key).."_Button1"):Hide()
		_G("DPSMate_ConfigMenu_Menu_Button"..(8+frame.Key).."_Button2"):Hide()
		_G("DPSMate_ConfigMenu_Menu_Button"..(8+frame.Key).."_Button3"):Hide()
		DPSMate_ConfigMenu_Menu_Button1Texture:Show()
	end
end

function DPSMate.Options:CopyConfiguration()
	local fromName = _G("DPSMate_ConfigMenu_Tab_Window_ConfigFromText"):GetText()
	local toName = _G("DPSMate_ConfigMenu_Tab_Window_ConfigToText"):GetText()
	if fromName~="None" and toName~="None" then
		local fromKey = _G("DPSMate_"..fromName).Key
		local toKey = _G("DPSMate_"..toName).Key
		for cat, val in pairs(DPSMateSettings["windows"][fromKey]) do
			if cat~="name" and cat~="options" then
				DPSMateSettings["windows"][toKey][cat] = val
			end
		end
		DPSMate:InitializeFrames()
	end
end

function DPSMate.Options:Lock()
	DPSMateSettings.lock = true
	for _,val in pairs(DPSMateSettings["windows"]) do
		_G("DPSMate_"..val["name"].."_Resize"):Hide()
	end
	DPSMate:SendMessage("Locked all windows.")
end

function DPSMate.Options:Unlock()
	DPSMateSettings.lock = false
	for _,val in pairs(DPSMateSettings["windows"]) do
		_G("DPSMate_"..val["name"].."_Resize"):Show()
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
	local buttons = {"Config", "Reset", "Segments", "Filter", "Report", "Sync", "Enable"}
	for _, val in pairs(DPSMateSettings["windows"]) do
		local parent, i = _G("DPSMate_"..val["name"].."_Head"), 0
		for _, name in pairs(buttons) do
			local button = _G("DPSMate_"..val["name"].."_Head_"..name)
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

function DPSMate.Options:ToggleState()
	if DPSMateSettings["enable"] then
		DPSMateSettings["sync"] = false
		DPSMateSettings["enable"] = false
		DPSMate:Disable()
		for cat, val in DPSMateSettings["windows"] do
			_G("DPSMate_"..val["name"].."_Head_Sync"):GetNormalTexture():SetVertexColor(1,0,0,1)
			_G("DPSMate_"..val["name"].."_Head_Enable"):SetChecked(false)
		end
	else
		DPSMateSettings["enable"] = true
		DPSMate:Enable()
		for cat, val in DPSMateSettings["windows"] do
			_G("DPSMate_"..val["name"].."_Head_Enable"):SetChecked(true)
		end
	end
end

function DPSMate.Options:SetColor()
	local r,g,b = ColorPickerFrame:GetColorRGB()
	local swatch,frame
	swatch = _G(ColorPickerFrame.obj:GetName().."NormalTexture")
	frame = _G(ColorPickerFrame.obj:GetName().."_SwatchBg")
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
	swatch = _G(ColorPickerFrame.obj:GetName().."NormalTexture")
	frame = _G(ColorPickerFrame.obj:GetName().."_SwatchBg")
	swatch:SetVertexColor(r,g,b)
	frame.r = r
	frame.g = g
	frame.b = b
	
	DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key][ColorPickerFrame.var] = {r,g,b}
	
	ColorPickerFrame.rfunc()
end

function DPSMate.Options:OpenColorPicker(obj, var, func)
	CloseMenus()
	
	button = _G(obj:GetName().."_SwatchBg")
	
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
		GameTooltip:AddLine(this.user.."'s ".._G(this:GetParent():GetParent():GetParent():GetName().."_Head_Font"):GetText(), 1,1,1)
		DPSMate.RegistredModules[DPSMateSettings["windows"][DPSMate_Details.PaKey]["CurMode"]]:ShowTooltip(this.user, DPSMate_Details.PaKey)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("LeftClick to open the details.")
		GameTooltip:AddLine("RightClick to open the menu.")
		GameTooltip:Show()
	end
end

function DPSMate.Options:InitializeHideShowWindow()
	local i = 1
	DPSMate.Options.Options[3]["args"]["hidewindow"]["args"] = {}
	DPSMate.Options.Options[3]["args"]["showwindow"]["args"] = {}
	for _,val in pairs(DPSMateSettings["windows"]) do
		DPSMate.Options.Options[3]["args"]["hidewindow"]["args"][val["name"]] = {
			order = i*10,
			type = 'execute',
			name = val["name"],
			desc = "Hide "..val["name"],
			func = loadstring('DPSMate.Options:Hide(getglobal("DPSMate_'..val["name"]..'")); DPSMate.Options.Dewdrop:Close();'),
		}
		DPSMate.Options.Options[3]["args"]["showwindow"]["args"][val["name"]] = {
			order = i*10,
			type = 'execute',
			name = val["name"],
			desc = "Show "..val["name"],
			func = loadstring('DPSMate.Options:Show(getglobal("DPSMate_'..val["name"]..'")); DPSMate.Options.Dewdrop:Close();'),
		}
		i=i+1
	end
end

function DPSMate.Options:CheckButton(name, id)
	if DPSMateSettings[name][id] then
		DPSMateSettings[name][id] = false
	else
		DPSMateSettings[name][id] = true
	end
	DPSMate:SetStatusBarValue()
end

function DPSMate.Options:ToggleSync()
	if DPSMateSettings["sync"] then
		DPSMateSettings["sync"] = false
		for _, val in pairs(DPSMateSettings["windows"]) do
			_G("DPSMate_"..val["name"].."_Head_Sync"):GetNormalTexture():SetVertexColor(1,0,0,1)
		end
	else
		DPSMateSettings["sync"] = true
		DPSMateSettings["enable"] = true
		for _, val in pairs(DPSMateSettings["windows"]) do
			_G("DPSMate_"..val["name"].."_Head_Enable"):SetChecked(true)
			_G("DPSMate_"..val["name"].."_Head_Sync"):GetNormalTexture():SetVertexColor(0.67,0.83,0.45,1)
		end
	end
end


