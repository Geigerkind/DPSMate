-- Global Variables
DPSMate.Modules.Activity = {}
DPSMate.Modules.Activity.Hist = "names"
DPSMate.Options.Options[1]["args"]["activity"] = {
	order = 510,
	type = 'toggle',
	name = DPSMate.L["activity"],
	desc = DPSMate.L["show"].." "..DPSMate.L["activity"]..".",
	get = function() return DPSMateSettings["windows"][(DPSMate.Options.Dewdrop:GetOpenedParent() or DPSMate).Key or 1]["options"][1]["activity"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "activity", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("activity", DPSMate.Modules.Activity, DPSMate.L["activity"])

local tinsert = table.insert
local strformat = string.format
local typeByName = {
	["Total"] = 1,
	["Current fight"] = 2
}
local NameById = {
	[1] = "total",
	[2] = "current"
}

function DPSMate.Modules.Activity:GetSortedTable(arr, k)
	local b, a = {}, {}
	local curmode, num = DPSMate:GetModeName(k)
	local db, total = {}, 0
	if typeByName[curmode] then
		db = DPSMateCombatTime["effective"][typeByName[curmode]]
		total = DPSMateCombatTime[NameById[typeByName[curmode]]]
	else
		db = DPSMateCombatTime["segments"][num][2]
		total = DPSMateCombatTime["segments"][num][1]
	end
	for cat, val in pairs(db) do -- owner // Does not work for segments
		local name = cat
		if DPSMate:ApplyFilter(k, name) then
			local CV = val
			local i = 1
			while true do
				if (not b[i]) then
					tinsert(b, i, CV)
					tinsert(a, i, name)
					break
				else
					if b[i] < CV then
						tinsert(b, i, CV)
						tinsert(a, i, name)
						break
					end
				end
				i=i+1
			end
		end
	end
	return b, a, total
end

function DPSMate.Modules.Activity:EvalTable(user, k)
	
end

function DPSMate.Modules.Activity:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	
	sortedTable, a, total = DPSMate.Modules.Activity:GetSortedTable(arr, k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = val, total, sortedTable[1]
		if dmg==0 then break end;
		local str = {[1]="",[2]="",[3]=""}
		str[1] = strformat("%.2f", val).."s"; strt[2] = strformat("%.2f", total).."s"
		tinsert(name, a[cat])
		tinsert(value, str[2]..str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Activity:ShowTooltip(user,k)
	GameTooltip:Hide()
end

function DPSMate.Modules.Activity:OpenDetails(obj, key, bool)
end

function DPSMate.Modules.Activity:OpenTotalDetails(obj, key)
end
