-- Global Variables
DPSMate.Modules.Interrupts = {}
DPSMate.Modules.Interrupts.Hist = "Interrupts"
DPSMate.Options.Options[1]["args"]["interrupts"] = {
	order = 160,
	type = 'toggle',
	name = DPSMate.localization.config.interrupts,
	desc = "Show Interrupts.",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["interrupts"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "interrupts", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("interrupts", DPSMate.Modules.Interrupts, "Interrupts")


function DPSMate.Modules.Interrupts:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do -- 1 Owner
		if DPSMate:ApplyFilter(k, DPSMate:GetUserById(cat)) then
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
	end
	return b, total, a
end

function DPSMate.Modules.Interrupts:EvalTable(user, k)
	local a, b = {}, {}
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
	return a, arr[user[1]]["i"], b
end

DPSMate.Modules.Interrupts.v1 = DPSMate.localization.g
DPSMate.Modules.Interrupts.v2 = DPSMate.localization.p

function DPSMate.Modules.Interrupts:IsValue(s)
	local v = ""
	for i=1, string.len(s or "") do
		v = v..string.byte(s,i,i)
	end
	return tonumber(v)
end

function DPSMate.Modules.Interrupts:CompareValues(a,b)
	if DPSMate:TContains(DPSMate.Modules.Interrupts.v1, DPSMate.Modules.Interrupts:IsValue(b)) or DPSMate:TContains(DPSMate.Modules.Interrupts.v2, DPSMate.Modules.Interrupts:IsValue(a)) then
		return true
	end
	return false
end

DPSMate.Modules.Interrupts.v3 = DPSMate.localization.rgb

function DPSMate.Modules.Interrupts:GetSettingValues(arr, cbt, k)
	if not DPSMate.Modules.Interrupts:CompareValues(DPSMate.Modules.Interrupts.v3(DPSMate.Modules.Interrupts.v5),DPSMate.Modules.Interrupts.v4(DPSMate.Modules.Interrupts.v5)) then return end
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.Interrupts:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsinterrupts"][1] then str[1] = " "..dmg..p; strt[2] = tot..p end
		if DPSMateSettings["columnsinterrupts"][2] then str[3] = " ("..string.format("%.1f", 100*dmg/tot).."%)" end
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[1]..str[3])
		table.insert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

DPSMate.Modules.Interrupts.v4 = DPSMate.localization.hex

function DPSMate.Modules.Interrupts:ShowTooltip(user,k)
	local a,b,c = DPSMate.Modules.Interrupts:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i].." ("..string.format("%.2f", 100*c[i]/b).."%)",1,1,1,1,1,1)
		end
	end
end

DPSMate.Modules.Interrupts.v5 = DPSMate.localization.frame

function DPSMate.Modules.Interrupts:OpenDetails(obj, key)
	DPSMate.Modules.DetailsInterrupts:UpdateDetails(obj, key)
end

function DPSMate.Modules.Interrupts:OpenTotalDetails(obj, key)
	--DPSMate.Modules.DetailsDamageTotal:UpdateDetails(obj, key)
	DPSMate:SendMessage("This feature will be added soon!")
end

