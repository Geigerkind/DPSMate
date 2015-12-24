-- Global Variables
DPSMate.Modules.HealingTaken = {}
DPSMate.Modules.HealingTaken.Hist = "THealingTaken"
DPSMate.Options.Options[1]["args"]["healingtaken"] = {
	order = 65,
	type = 'toggle',
	name = DPSMate.localization.config.healingtaken,
	desc = DPSMate.localization.desc.healingtaken,
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["healingtaken"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "healingtaken", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("healingtaken", DPSMate.Modules.HealingTaken)


function DPSMate.Modules.HealingTaken:GetSortedTable(arr)
	local b, a, total = {}, {}, 0
	for c, v in pairs(arr) do
		local i = 1
		while true do
			if (not b[i]) then
				table.insert(b, i, v["i"][1])
				table.insert(a, i, c)
				break
			else
				if b[i] < v["i"][1] then
					table.insert(b, i, v["i"][1])
					table.insert(a, i, c)
					break
				end
			end
			i=i+1
		end
		total = total + v["i"][1]
	end
	return b, total, a
end

function DPSMate.Modules.HealingTaken:EvalTable(user, k)
	local a, u, p, d, total = {}, {}, {}, {}, 0
	local arr = DPSMate:GetMode(k)
	if not arr[user["id"]] then return end
	for cat, val in pairs(arr[user["id"]]) do
		if cat~="i" then
			local CV = 0
			for ca, va in pairs(val) do
				CV=CV+va[1]
			end
			local i = 1
			while true do
				if (not d[i]) then
					table.insert(a, i, cat)
					table.insert(d, i, CV)
					break
				else
					if (d[i] < CV) then
						table.insert(a, i, cat)
						table.insert(d, i, CV)
						break
					end
				end
				i = i + 1
			end
		end
	total=total+arr[user["id"]]["i"][1]
	end
	return a, total, d
end

function DPSMate.Modules.HealingTaken:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.HealingTaken:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local va, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if va==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		str[1] = " "..va..p; strt[2] = tot..p
		str[2] = " ("..string.format("%.1f", 100*va/tot).."%)"
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[1]..str[2])
		table.insert(perc, 100*(va/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.HealingTaken:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.HealingTaken:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(a[i]),c[i],1,1,1,1,1,1)
		end
	end
end


