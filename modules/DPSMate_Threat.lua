-- Global Variables
DPSMate.Modules.Threat = {}
DPSMate.Modules.Threat.Hist = "Threat"
DPSMate.Options.Options[1]["args"]["threat"] = {
	order = 280,
	type = 'toggle',
	name = "Threat",
	desc = "Show threat.",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["threat"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "threat", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("threat", DPSMate.Modules.Threat, "Threat")

local tinsert = table.insert


function DPSMate.Modules.Threat:GetSortedTable(arr, k)
	local b, a, total = {}, {}, 0
	local temp = {}
	for cat, val in arr do
		local name = DPSMate:GetUserById(cat)
		local i = 1
		while true do
			if (not b[i]) then
				tinsert(b, i, val)
				tinsert(a, i, name)
				break
			else
				if b[i] < val then
					tinsert(b, i, val)
					tinsert(a, i, name)
					break
				end
			end
			i=i+1
		end
		total = total + val
	end
	return b, total, a
end

function DPSMate.Modules.Threat:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.Threat:GetSortedTable(arr, k)
	for cat, val in sortedTable do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsthreat"][1] then str[1] = " "..dmg..p; strt[2] = tot..p end
		if DPSMateSettings["columnsthreat"][2] then str[2] = "("..string.format("%.1f", (dmg/cbt))..p..")"; strt[1] = "("..string.format("%.1f", (tot/cbt))..p..") " end
		if DPSMateSettings["columnsthreat"][3] then str[3] = " ("..string.format("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, a[cat])
		tinsert(value, str[2]..str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Threat:ShowTooltip(user,k)
	GameTooltip:Hide()
	return
end

function DPSMate.Modules.Threat:OpenDetails(obj, key)
	--DPSMate.Modules.DetailsThreat:UpdateDetails(obj, key)
	DPSMate:SendMessage("This feature will be added later.")
end

function DPSMate.Modules.Threat:OpenTotalDetails(obj, key)
	--DPSMate.Modules.DetailsThreatTotal:UpdateDetails(obj, key)
	DPSMate:SendMessage("This feature will be added later.")
end
