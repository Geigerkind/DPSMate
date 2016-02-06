-- Global Variables
DPSMate.Modules.Healing = {}
DPSMate.Modules.Healing.Hist = "THealing"
DPSMate.Options.Options[1]["args"]["healing"] = {
	order = 60,
	type = 'toggle',
	name = DPSMate.localization.config.healing,
	desc = DPSMate.localization.desc.healing,
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["healing"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "healing", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("healing", DPSMate.Modules.Healing)


function DPSMate.Modules.Healing:GetSortedTable(arr)
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

function DPSMate.Modules.Healing:EvalTable(user, k)
	local a, d = {}, {}
	local arr = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	for cat, val in pairs(arr[user[1]]) do
		if cat~="i" then
			local i = 1
			while true do
				if (not d[i]) then
					table.insert(a, i, cat)
					table.insert(d, i, val[1])
					break
				else
					if (d[i] < val[1]) then
						table.insert(a, i, cat)
						table.insert(d, i, val[1])
						break
					end
				end
				i = i + 1
			end
		end
	end
	return a, arr[user[1]]["i"][1], d
end

function DPSMate.Modules.Healing:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.Healing:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local va, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if va==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnshealing"][1] then str[1] = " "..va..p; strt[2] = " "..tot..p end
		if DPSMateSettings["columnshealing"][3] then str[2] = " ("..string.format("%.1f", 100*va/tot).."%)" end
		if DPSMateSettings["columnshealing"][2] then str[3] = "("..string.format("%.1f", va/cbt)..p..")"; strt[1] = "("..string.format("%.1f", tot/cbt)..p..")" end
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[3]..str[1]..str[2])
		table.insert(perc, 100*(va/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Healing:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.Healing:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i],1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.Healing:OpenDetails(obj, key)
	DPSMate.Modules.DetailsHealing:UpdateDetails(obj, key)
end

function DPSMate.Modules.Damage:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsDamageTotal:UpdateDetails(obj, key)
end

