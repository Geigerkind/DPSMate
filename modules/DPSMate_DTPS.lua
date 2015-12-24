-- Global Variables
DPSMate.Modules.DTPS = {}
DPSMate.Modules.DTPS.Hist = "DMGTaken"
DPSMate.Options.Options[1]["args"]["dtps"] = {
	order = 35,
	type = 'toggle',
	name = 'DTPS',
	desc = 'TO BE ADDED',
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["dtps"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "dtps", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("dtps", DPSMate.Modules.DTPS)


function DPSMate.Modules.DTPS:GetSortedTable(arr)
	local b, a, total = {}, {}, 0
	for c, v in pairs(arr) do
		local CV = 0
		for cat, val in pairs(v) do
			CV = CV+val["info"][3]
		end
		local i = 1
		while true do
			if (not b[i]) then
				table.insert(b, i, CV)
				table.insert(a, i, c)
				break
			else
				if b[i] < CV then
					table.insert(b, i, CV)
					table.insert(a, i, c)
					break
				end
			end
			i=i+1
		end
		total = total + CV
	end
	return b, total, a
end

function DPSMate.Modules.DTPS:EvalTable(user, k)
	local a, u, p, d, total = {}, {}, {}, {}, 0
	local arr = DPSMate:GetMode(k)
	if not arr[user["id"]] then return end
	for cat, val in pairs(arr[user["id"]]) do
		for ca, va in pairs(val) do
			if ca~="info" then
				local i = 1
				while true do
					if (not d[i]) then
						table.insert(a, i, cat)
						table.insert(d, i, va[13])
						break
					else
						if (d[i] < va[13]) then
							table.insert(a, i, cat)
							table.insert(d, i, va[13])
							break
						end
					end
					i = i + 1
				end
			end
		end
	total=total+val["info"][3]
	end
	return a, total, d
end

function DPSMate.Modules.DTPS:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.DTPS:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		str[1] = " "..ceil(dmg/cbt)..p; strt[2] = tot..p
		str[2] = " ("..string.format("%.1f", 100*dmg/tot).."%)"
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[1]..str[2])
		table.insert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.DTPS:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.DTPS:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(a[i]),c[i],1,1,1,1,1,1)
		end
	end
end


