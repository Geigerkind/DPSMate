-- Global Variables
DPSMate.Modules.AurasGained = {}
DPSMate.Modules.AurasGained.Hist = "Dispels"
DPSMate.Options.Options[1]["args"]["aurasgained"] = {
	order = 230,
	type = 'toggle',
	name = 'Auras gained',
	desc = 'TO BE ADDED!',
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["aurasgained"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "aurasgained", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("aurasgained", DPSMate.Modules.AurasGained)


function DPSMate.Modules.AurasGained:GetSortedTable(arr)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do -- 2 Target
		local CV = 0
		for ca, va in pairs(val) do -- 3 Owner
			for c, v in pairs(va) do -- 1 Ability
				for ce, ve in pairs(v) do 
					if ce==1 then
						for c, v in pairs(ve) do
							CV=CV+1
						end
					end
				end
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
		total = total + CV
	end
	return b, total, a
end

function DPSMate.Modules.AurasGained:EvalTable(user, k)
	local a, b, temp, total = {}, {}, {}, 0
	local arr = DPSMate:GetMode(k)
	for cat, val in pairs(arr[user[1]]) do -- 3 Owner
		for ca, va in pairs(val) do -- 1 Ability
			local CV = 0
			for c, v in pairs(va) do -- each one
				if c==1 then
					for ce, ve in pairs(v) do
						CV=CV+1
					end
				end
			end
			if temp[ca] then temp[ca]=temp[ca]+CV else temp[ca]=CV end
		end
	end
	for cat, val in pairs(temp) do
		local i = 1
		while true do
			if (not b[i]) then
				table.insert(b, i, val)
				table.insert(a, i, cat)
				break
			else
				if b[i] < val then
					table.insert(b, i, val)
					table.insert(a, i, cat)
					break
				end
			end
			i=i+1
		end
	end
	return a, total, b
end

function DPSMate.Modules.AurasGained:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.AurasGained:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsdmg"][1] then str[1] = " "..dmg..p; strt[2] = tot..p end
		if DPSMateSettings["columnsdmg"][2] then str[2] = "("..string.format("%.1f", (dmg/cbt))..p..")"; strt[1] = "("..string.format("%.1f", (tot/cbt))..p..") " end
		if DPSMateSettings["columnsdmg"][3] then str[3] = " ("..string.format("%.1f", 100*dmg/tot).."%)" end
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[2]..str[1]..str[3])
		table.insert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.AurasGained:ShowTooltip(user,k)
	local a,b,c = DPSMate.Modules.AurasGained:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i],1,1,1,1,1,1)
		end
	end
end


