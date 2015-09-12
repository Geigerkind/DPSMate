-- Global Variables
DPSMate = {}
DPSMate.VERSION = "v0.1"
DPSMate.Parser = {}
DPSMate.localization = {}
DPSMate.DB = {}

-- Begin functions

function DPSMate:OnLoad()
	
end

function DPSMate:SendMessage(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFF8080"..DPSMate.localization.name.."|r: "..msg)
end