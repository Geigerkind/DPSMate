-- Global Variables
DPSMate.Modules.EDD = {}
DPSMate.Modules.EDD.Hist = "EDDone"
DPSMate.Options.Options[1]["args"]["enemydamagedone"] = {
	order = 40,
	type = 'toggle',
	name = DPSMate.localization.config.enemydamagedone,
	desc = DPSMate.localization.desc.enemydmgdone,
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["enemydamagedone"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "enemydamagedone", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("enemydamagedone", DPSMate.Modules.EDD)


function DPSMate.Modules.EDD:GetSortedTable(arr)
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

function DPSMate.Modules.EDD:EvalTable(user, k)
	local a, u, p, d, total = {}, {}, {}, {}, 0
	local arr = DPSMate:GetMode(k)
	if not arr[user["id"]] then return end
	for cat, val in pairs(arr[user["id"]]) do
		for ca, va in pairs(val) do
			if ca~="i" then
				local i = 1
				while true do
					if (not d[i]) then
						table.insert(a, i, ca)
						table.insert(d, i, va[13])
						break
					else
						if (d[i] < va[13]) then
							table.insert(a, i, ca)
							table.insert(d, i, va[13])
							break
						end
					end
					i = i + 1
				end
			end
		end
	total=total+val["i"][3]
	end
	return a, total, d
end

function DPSMate.Modules.EDD:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.EDD:GetSortedTable(arr)
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

function DPSMate.Modules.EDD:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.EDD:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i],1,1,1,1,1,1)
		end
	end
end


