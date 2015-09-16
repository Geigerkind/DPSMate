-- Global Variables

-- Local Variables
local LastPopUp = GetTime()
local TimeToNextPopUp = 60
local PartyNum = GetNumPartyMembers()
local Dewdrop = AceLibrary("Dewdrop-2.0")
local Options = {
	[1] = {
		type = 'group',
		args = {
			dps = {
				order = 10,
				type = 'toggle',
				name = "DPS",
				desc = "desc",
				get = function() return DPSMateSettings["options"][1]["dps"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "dps") end,
			},
			damage = {
				order = 20,
				type = 'toggle',
				name = "Damage",
				desc = "desc",
				get = function() return DPSMateSettings["options"][1]["damage"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "damage") end,
			},
			damagetaken = {
				order = 30,
				type = 'toggle',
				name = "Damage taken",
				desc = "desc",
				get = function() return DPSMateSettings["options"][1]["damagetaken"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "damagetaken") end,
			},
			enemydamagedone = {
				order = 40,
				type = 'toggle',
				name = "Enemy damage done",
				desc = "desc",
				get = function() return DPSMateSettings["options"][1]["enemydamagedone"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "enemydamagedone") end,
			},
			enemydamagetaken = {
				order = 50,
				type = 'toggle',
				name = "Enemy damage taken",
				desc = "desc",
				get = function() return DPSMateSettings["options"][1]["enemydamagetaken"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "enemydamagetaken") end,
			},
			healing = {
				order = 60,
				type = 'toggle',
				name = "Healing",
				desc = "desc",
				get = function() return DPSMateSettings["options"][1]["healing"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "healing") end,
			},
			healingandabsorbs = {
				order = 70,
				type = 'toggle',
				name = "Healing and Absorbs",
				desc = "desc",
				get = function() return DPSMateSettings["options"][1]["healingandabsorbs"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "healingandabsorbs") end,
			},
			healingtaken = {
				order = 80,
				type = 'toggle',
				name = "Healing taken",
				desc = "desc",
				get = function() return DPSMateSettings["options"][1]["healingtaken"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "healingtaken") end,
			},
			overhealing = {
				order = 90,
				type = 'toggle',
				name = "Overhealing",
				desc = "desc",
				get = function() return DPSMateSettings["options"][1]["overhealing"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "overhealing") end,
			},
			interrupts = {
				order = 100,
				type = 'toggle',
				name = "Interrupts",
				desc = "desc",
				get = function() return DPSMateSettings["options"][1]["interrupts"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "interrupts") end,
			},
			deaths = {
				order = 110,
				type = 'toggle',
				name = "Deaths",
				desc = "desc",
				get = function() return DPSMateSettings["options"][1]["deaths"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "deaths") end,
			},
			dispels = {
				order = 120,
				type = 'toggle',
				name = "Dispels",
				desc = "desc",
				get = function() return DPSMateSettings["options"][1]["dispels"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "dispels") end,
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
				desc = "desc",
				get = function() return DPSMateSettings["options"][2]["total"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(2, "total") end,
			},
			currentFight = {
				order = 20,
				type = 'toggle',
				name = "Current fight",
				desc = "desc",
				get = function() return DPSMateSettings["options"][2]["currentfight"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(2, "currentfight") end,
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
				desc = "Report desc",
				func = "PopUpAccept",
			},
			reset = {
				order = 11,
				type = 'execute',
				name = "Reset",
				desc = "Reset desc",
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
				desc = "Start new segment desc",
				func = "PopUpAccept",
			},
			deletesegment = {
				order = 30,
				type = 'group',
				name = "Delete segment",
				desc = "Delete segment desc",
				args = {
					sub1 = {
						type = "execute",
						name = "Test 1",
						desc = "Test 1 desc",
						func = "PopUpAccept",
					}, 
					sub2 = {
						type = "execute",
						name = "Test 2",
						desc = "Test 2 desc",
						func = "PopUpAccept",
					},
				},
			},
			blank2 = {
				order = 35,
				type = 'header',
			},
			lock = {
				order = 40,
				type = 'toggle',
				name = "Lock window",
				desc = "lock desc",
				get = function() return DPSMateSettings["options"][3]["lock"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(3, "lock") end,
			},
			hide = {
				order = 50,
				type = 'execute',
				name = "Hide window",
				desc = "Hide window desc",
				func = "PopUpAccept",
			},
			configure = {
				order = 80,
				type = 'execute',
				name = "Configure",
				desc = "Configure desc",
				func = "PopUpAccept",
			},
			close = {
				order = 90,
				type = 'execute',
				name = "Close",
				desc = "Close desc",
				func = "PopUpAccept",
			},
		},
		handler = DPSMate.Options,
	},
}
local CurMode = "damage"

-- Begin Functions

function DPSMate.Options:OnEvent(event)
	if event == "PARTY_MEMBERS_CHANGED" and DPSMate.Options:IsInParty() and DPSMate.Options:PartyMemberAmountChanged() then
		if (GetTime()-LastPopUp) > TimeToNextPopUp then -- To prevent spam
			LastPopUp = GetTime()
			DPSMate_PopUp:Show()
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		DPSMate_PopUp:Show()
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
	DPSMate:HideStatusBars()
end

function DPSMate.Options:OpenMenu(b)
	if Dewdrop:IsOpen(DPSMate_Statusframe) then
		Dewdrop:Close()
		return
	end
	if Dewdrop:IsRegistered(DPSMate_Statusframe) then Dewdrop:Unregister(DPSMate_Statusframe) end
	Dewdrop:Register(DPSMate_Statusframe,
		'children', function() 
			Dewdrop:FeedAceOptionsTable(Options[b]) 
		end,
		'cursorX', true,
		'cursorY', true,
		'dontHook', true
	)
	Dewdrop:Open(DPSMate_Statusframe)
end

function DPSMate.Options:ToggleDrewDrop(i, obj)
	for cat, _ in pairs(DPSMateSettings["options"][i]) do
		DPSMateSettings["options"][i][cat] = false
	end
	DPSMateSettings["options"][i][obj] = true
	if i == 1 then
		DPSMate_Statusframe_Head_Font:SetText(Options[i]["args"][obj].name)
		CurMode = obj
	elseif i == 2 then
	elseif i == 3 then end
	Dewdrop:Close()
	return true
end