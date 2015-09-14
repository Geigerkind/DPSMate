-- Global Variables

-- Local Variables
local LastPopUp = GetTime()
local TimeToNextPopUp = 60
local PartyNum = GetNumPartyMembers()
local Dewdrop = AceLibrary("Dewdrop-2.0")
local DewDropListModes = {}
DewDropListModes[1] = "DPS"
DewDropListModes[2] = "Damage"
DewDropListModes[3] = "Damage taken"
DewDropListModes[4] = "Enemy damage done"
DewDropListModes[5] = "Enemy damage taken"
DewDropListModes[6] = "Healing"
DewDropListModes[7] = "Healing and Absorbs"
DewDropListModes[8] = "Healing taken"
DewDropListModes[9] = "Overhealing"
DewDropListModes[10] = "Interrupts"
DewDropListModes[11] = "Deaths"
DewDropListModes[12] = "Dispels"
local DewDropListSegments = {}
DewDropListSegments[1] = "Total"
DewDropListSegments[2] = "Current fight"

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
	local list
	if b then list = DewDropListModes else list = DewDropListSegments end
	if Dewdrop:IsRegistered(DPSMate_Statusframe) then Dewdrop:Unregister(DPSMate_Statusframe) end
	Dewdrop:Register(DPSMate_Statusframe,
		'children', function()
			for _, text in pairs(list) do
				Dewdrop:AddLine('text', text)
			end
		end,
		'point', 'BOTTOMLEFT',
		'relativeTo', DPSMate_Statusframe,
		'relativePoint', 'TOPLEFT'
	)
	Dewdrop:Open(DPSMate_Statusframe)
end

function DPSMate.Options:OpenConfigMenu()
	if Dewdrop:IsOpen(DPSMate_Statusframe) then
		Dewdrop:Close()
		return
	end
	if Dewdrop:IsRegistered(DPSMate_Statusframe) then Dewdrop:Unregister(DPSMate_Statusframe) end
	Dewdrop:Register(DPSMate_Statusframe,
		'children', function() 
			Dewdrop:FeedAceOptionsTable({
				type = 'group',
				args = {
					report = {
						type = 'execute',
						name = "Report",
						desc = "Report desc",
						func = "PopUpAccept",
					},
					deletesegment = {
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
					lock = {
						type = 'toggle',
						name = "Lock window",
						desc = "lock desc",
						get = "PopUpAccept",
						set = function() return true end,
					},
					hide = {
						type = 'execute',
						name = "Hide window",
						desc = "Hide window desc",
						func = "PopUpAccept",
					},
					reset = {
						type = 'execute',
						name = "Reset",
						desc = "Reset desc",
						func = "PopUpAccept",
					},
					startnewsegment = {
						type = 'execute',
						name = "Start new segment",
						desc = "Start new segment desc",
						func = "PopUpAccept",
					},
					configure = {
						type = 'execute',
						name = "Configure",
						desc = "Configure desc",
						func = "PopUpAccept",
					},
					close = {
						type = 'execute',
						name = "Close",
						desc = "Close desc",
						func = "PopUpAccept",
					},
				},
				handler = DPSMate.Options,
			}) 
		end,
		'point', 'BOTTOMLEFT',
		'relativeTo', DPSMate_Statusframe,
		'relativePoint', 'TOPLEFT'
	)
	Dewdrop:Open(DPSMate_Statusframe)
end