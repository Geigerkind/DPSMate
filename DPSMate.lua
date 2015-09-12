-- Global Variables
DPSMate = {}
DPSMate.VERSION = "v0.1"
DPSMate.Parser = {}
DPSMate.localization = {}
DPSMate.DB = {}

-- Local Variables
local a = {}

-- Begin functions

function DPSMate:OnLoad()
	DPSMate:SetStatusBarValue()
end

function DPSMate:TableLength(t)
	local count = 0
	for _,_ in pairs(t) do
		count = count + 1
	end
	return count
end

function DPSMate:GetSortedTable()
	local b = {}
	local total = 0
	local CurMax = 0
	for cat,arr in pairs(DPSMateUser) do
		a[arr["damage"]] = cat
		local i = 1
		while true do
			if (not b[i]) then
				table.insert(b, i, arr["damage"])
				break
			else
				if b[i] < arr["damage"] then
					table.insert(b, i, arr["damage"])
					break
				end
			end
			i=i+1
		end
		
		total = total + arr["damage"]
	end
	return b, total
end

function DPSMate:SetStatusBarValue()
	local sortedTable, total = DPSMate:GetSortedTable()
	DPSMate:HideStatusBars()
	if (not sortedTable) then return end
	for i=1, DPSMate:TableLength(sortedTable) do
		local statusbar = getglobal("DPSMate_Statusframe_StatusBar"..i)
		local name = getglobal("DPSMate_Statusframe_StatusBar"..i.."_Name")
		local value = getglobal("DPSMate_Statusframe_StatusBar"..i.."_Value")
		statusbar:SetValue(ceil(100*(sortedTable[i]/sortedTable[1])))
		name:SetText(i..". "..a[sortedTable[i]])
		value:SetText(sortedTable[i].." ("..string.format("%.1f", 100*sortedTable[i]/total)..")%")
		statusbar:Show()
	end
end

function DPSMate:HideStatusBars()
	for i=1, 4 do
		getglobal("DPSMate_Statusframe_StatusBar"..i):Hide()
	end
end

function DPSMate:SendMessage(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFF8080"..DPSMate.localization.name.."|r: "..msg)
end