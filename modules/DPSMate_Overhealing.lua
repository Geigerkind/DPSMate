-- Global Variables
DPSMate.Modules.Overhealing = {}
DPSMate.Modules.Overhealing.Hist = "OHealing"
DPSMate.Options.Options[1]["args"]["overhealing"] = {
	order = 80,
	type = 'toggle',
	name = DPSMate.localization.config.overhealing,
	desc = DPSMate.localization.desc.overhealing,
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["overhealing"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "overhealing", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("overhealing", DPSMate.Modules.Overhealing)


function DPSMate.Modules.Overhealing:GetSortedTable(arr)
	local b, a, total = {}, {}, 0
	for c, v in pairs(arr) do
		local i = 1
		while true do
			if (not b[i]) then
				table.insert(b, i, v["info"][1])
				table.insert(a, i, c)
				break
			else
				if b[i] < v["info"][1] then
					table.insert(b, i, v["info"][1])
					table.insert(a, i, c)
					break
				end
			end
			i=i+1
		end
		total = total + v["info"][1]
	end
	return b, total, a
end

function DPSMate.Modules.Overhealing:EvalTable(user, k)
	local a, u, p, d, total = {}, {}, {}, {}, 0
	local arr = DPSMate:GetMode(k)
	if not arr[user["id"]] then return end
	for cat, val in pairs(arr[user["id"]]) do
		if cat~="info" then
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
	total=total+arr[user["id"]]["info"][1]
	end
	return a, total, d
end

function DPSMate.Modules.Overhealing:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.Overhealing:GetSortedTable(arr)
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

function DPSMate.Modules.Overhealing:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.Overhealing:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i],1,1,1,1,1,1)
		end
	end
end


