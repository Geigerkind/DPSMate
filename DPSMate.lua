-- Global Variables
DPSMate = {}
DPSMate.VERSION = "v0.1"
DPSMate.Parser = {}
DPSMate.localization = {}
DPSMate.DB = {}
DPSMate.Options = {}

-- Local Variables
local a = {}
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
	DPSMate:SetStatusBarValue()
end

function DPSMate:TableLength(t)
	local count = 0
	for _,_ in pairs(t) do
		count = count + 1
	end
	return count
end

function DPSMate:GetSortedTable(arr)
	local b = {}
	local total = 0
	local CurMax = 0
	for cat,arr in pairs(arr) do
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
	local arr = DPSMate:GetMode()
	local sortedTable, total = DPSMate:GetSortedTable(arr)
	DPSMate:HideStatusBars()
	if (not sortedTable) then return end
	for i=1, DPSMate:TableLength(sortedTable) do
		if DPSMate_Statusframe:GetHeight() < (i*3) then return end
		local statusbar = getglobal("DPSMate_Statusframe_StatusBar"..i)
		if (not statusbar) then break end
		local name = getglobal("DPSMate_Statusframe_StatusBar"..i.."_Name")
		local value = getglobal("DPSMate_Statusframe_StatusBar"..i.."_Value")
		statusbar:SetValue(ceil(100*(sortedTable[i]/sortedTable[1])))
		statusbar:SetStatusBarColor(DPSMate:GetClassColor(arr[a[sortedTable[i]]].class), 1)
		name:SetText(i..". "..a[sortedTable[i]])
		value:SetText(sortedTable[i].." ("..string.format("%.1f", 100*sortedTable[i]/total)..")%")
		statusbar.user = a[sortedTable[i]]
		statusbar:Show()
	end
end

function DPSMate:GetClassColor(class)
	if (class) then
		return classcolor[class].r, classcolor[class].g, classcolor[class].b
	else
		return 0.1,0,0.1
	end
end

function DPSMate:GetMode()
	if DPSMateSettings["options"][2]["total"] then
		return DPSMateUser
	end
	return DPSMateUserCurrent
end

function DPSMate:HideStatusBars()
	for i=1, 30 do
		getglobal("DPSMate_Statusframe_StatusBar"..i):Hide()
	end
end

function DPSMate:SendMessage(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFF8080"..DPSMate.localization.name.."|r: "..msg)
end