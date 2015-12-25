-- Global Variables
DPSMate.Modules.EDT = {}
DPSMate.Modules.EDT.Hist = "EDTaken"
DPSMate.Options.Options[1]["args"]["enemydamagetaken"] = {
	order = 50,
	type = 'toggle',
	name = DPSMate.localization.config.enemydamagetaken,
	desc = DPSMate.localization.desc.enemydmgtaken,
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["enemydamagetaken"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "enemydamagetaken", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("enemydamagetaken", DPSMate.Modules.EDT)


function DPSMate.Modules.EDT:GetSortedTable(arr)
	local b, a, total = {}, {}, 0
	for c, v in pairs(arr) do
		local CV = 0
		for cat, val in pairs(v) do
			CV = CV+val["i"][3]
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

function DPSMate.Modules.EDT:EvalTable(user, k)
	local a, u, p, d, total = {}, {}, {}, {}, 0
	local arr = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	for cat, val in pairs(arr[user[1]]) do
		local CV = 0
		for ca, va in pairs(val) do
			if ca~="i" then
				CV = CV + va[13]
			end
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
	total=total+val["i"][3]
	end
	return a, total, d
end

function DPSMate.Modules.EDT:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.EDT:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		str[1] = " "..dmg..p; strt[2] = tot..p
		str[2] = " ("..string.format("%.1f", 100*dmg/tot).."%)"
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[1]..str[2])
		table.insert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.EDT:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.EDT:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(a[i]),c[i],1,1,1,1,1,1)
		end
	end
end


