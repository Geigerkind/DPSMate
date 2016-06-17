-- Global Variables
DPSMate.Modules.TPS = {}
DPSMate.Modules.TPS.Hist = "Threat"
DPSMate.Options.Options[1]["args"]["tps"] = {
	order = 290,
	type = 'toggle',
	name = "TPS",
	desc = "Show tps.",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["tps"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "tps", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("tps", DPSMate.Modules.TPS, "TPS")

local tinsert = table.insert


function DPSMate.Modules.TPS:GetSortedTable(arr, k)
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

function DPSMate.Modules.TPS:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.TPS:GetSortedTable(arr, k)
	for cat, val in sortedTable do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnstps"][1] then str[1] = "("..dmg..p..")"; strt[1] = "("..tot..p..")" end
		if DPSMateSettings["columnstps"][2] then str[2] = " "..string.format("%.1f", (dmg/cbt))..p; strt[2] = " "..string.format("%.1f", (tot/cbt))..p end
		if DPSMateSettings["columnstps"][3] then str[3] = " ("..string.format("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, a[cat])
		tinsert(value, str[2]..str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.TPS:ShowTooltip(user,k)
	GameTooltip:Hide()
	return
end

function DPSMate.Modules.TPS:OpenDetails(obj, key)
	--DPSMate.Modules.DetailsTPS:UpdateDetails(obj, key)
	DPSMate:SendMessage("This feature will be added later.")
end

function DPSMate.Modules.TPS:OpenTotalDetails(obj, key)
	--DPSMate.Modules.DetailsTPSTotal:UpdateDetails(obj, key)
	DPSMate:SendMessage("This feature will be added later.")
end
