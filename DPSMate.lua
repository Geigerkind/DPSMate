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
	DPSMate:SetStatusBarValue()
end

function DPSMate:TableLength(t)
	local count = 0
	for _,_ in pairs(t) do
		count = count + 1
	end
	return count
end

function DPSMate:TContains(t, value)
	for cat, val in pairs(t) do
		if val == value then
			return true
		end
	end
	return false
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
	local arr = DPSMate:GetMode()
	local sortedTable, total, a = DPSMate:GetSortedTable(arr)
	DPSMate:HideStatusBars()
	if (not sortedTable) then return end
	for i=1, 30 do
		if DPSMate_Statusframe:GetHeight() < (i*13+18) or (not sortedTable[i]) then break end -- To prevent visual issues
		local statusbar = getglobal("DPSMate_Statusframe_StatusBar"..i)
		local name = getglobal("DPSMate_Statusframe_StatusBar"..i.."_Name")
		local value = getglobal("DPSMate_Statusframe_StatusBar"..i.."_Value")
		
		local r,g,b = DPSMate:GetClassColor(arr[a[sortedTable[i]]].class)
		statusbar:SetStatusBarColor(r,g,b, 1)
		name:SetText(i..". "..a[sortedTable[i]])
		
		value:SetText(sortedTable[i].." ("..string.format("%.1f", 100*sortedTable[i]/total).."%)")
		statusbar:SetValue(ceil(100*(sortedTable[i]/sortedTable[1])))
		
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

function DPSMate:GetModeName()
	if DPSMateSettings["options"][2]["total"] then
		return "Total"
	end
	return "Current fight"
end

function DPSMate:HideStatusBars()
	for i=1, 30 do
		getglobal("DPSMate_Statusframe_StatusBar"..i):Hide()
	end
end

function DPSMate:SendMessage(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFF8080"..DPSMate.localization.name.."|r: "..msg)
end