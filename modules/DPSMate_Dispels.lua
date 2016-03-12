-- Global Variables
DPSMate.Modules.Dispels = {}
DPSMate.Modules.Dispels.Hist = "Dispels"
DPSMate.Options.Options[1]["args"]["dispels"] = {
	order = 180,
	type = 'toggle',
	name = DPSMate.localization.config.dispels,
	desc = "Show Dispels.",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["dispels"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "dispels", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("dispels", DPSMate.Modules.Dispels, "Dispels")


function DPSMate.Modules.Dispels:GetSortedTable(arr)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do -- 3 Owner
		local i = 1
		while true do
			if (not b[i]) then
				table.insert(b, i, val["i"])
				table.insert(a, i, cat)
				break
			else
				if b[i] < val["i"] then
					table.insert(b, i, val["i"])
					table.insert(a, i, cat)
					break
				end
			end
			i=i+1
		end
		total = total + val["i"]
	end
	return b, total, a
end

function DPSMate.Modules.Dispels:EvalTable(user, k)
	local a, b, total = {}, {}, 0
	local arr = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	for cat, val in pairs(arr[user[1]]) do -- 41 Ability
		if cat~="i" then
			local CV = 0
			for ca, va in pairs(val) do
				for c, v in pairs(va) do
					CV = CV + v
				end
			end
			local i = 1
			while true do
				if (not b[i]) then
					table.insert(b, i, CV)
					table.insert(a, i, cat)
					break
				else
					if b[i] < CV then
						table.insert(b, i, CV)
						table.insert(a, i, cat)
						break
					end
				end
				i=i+1
			end
		end
	end
	return a, total, b
end

function DPSMate.Modules.Dispels:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.Dispels:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsdispels"][1] then str[1] = " "..dmg..p; strt[2] = tot..p end
		if DPSMateSettings["columnsdispels"][2] then str[3] = " ("..string.format("%.1f", 100*dmg/tot).."%)" end
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[2]..str[1]..str[3])
		table.insert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Dispels:ShowTooltip(user,k)
	local a,b,c = DPSMate.Modules.Dispels:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i],1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.Dispels:OpenDetails(obj, key)
	DPSMate.Modules.DetailsDispels:UpdateDetails(obj, key)
end

function DPSMate.Modules.Damage:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsDamageTotal:UpdateDetails(obj, key)
end

