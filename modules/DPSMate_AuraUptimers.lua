-- Global Variables
DPSMate.Modules.AurasUptimers = {}
DPSMate.Modules.AurasUptimers.Hist = "Auras"
DPSMate.Options.Options[1]["args"]["aurasuptime"] = {
	order = 250,
	type = 'toggle',
	name = 'Aura uptime',
	desc = 'TO BE ADDED!',
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["aurasuptime"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "aurasuptime", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("aurasuptime", DPSMate.Modules.AurasUptimers)


function DPSMate.Modules.AurasUptimers:GetSortedTable(arr)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do -- 2 Target
		local CV = 0
		for ca, va in pairs(val) do -- 3 Ability
			for c, v in pairs(va) do -- each one
				if c==1 then
					for ce, ve in pairs(v) do
						CV=CV+1
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

function DPSMate.Modules.AurasUptimers:EvalTable(user, k)
	local a, b, total = {}, {}, 0
	local arr = DPSMate:GetMode(k)
	for cat, val in pairs(arr[user[1]]) do -- 3 Ability
		local CV = 0
		for ca, va in pairs(val[1]) do -- each one
			if arr[user[1]][cat][2][ca] then
				CV=CV+(arr[user[1]][cat][2][ca]-va)
				--DPSMate:SendMessage((arr[user[1]][cat][2][ca]-va))
			end
		end
		--DPSMate:SendMessage(DPSMate:GetAbilityById(cat).." - "..CV)
		--DPSMate:SendMessage(DPSMateCombatTime["total"])
		--DPSMate:SendMessage("---------------------------------------")
		local i = 1
		CV = string.format("%.2f", (100*CV)/DPSMateCombatTime["total"])
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
	return a, total, b
end

function DPSMate.Modules.AurasUptimers:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.AurasUptimers:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsaurauptime"][1] then str[1] = " "..dmg..p; strt[2] = " "..tot..p end
		if DPSMateSettings["columnsaurauptime"][2] then str[3] = " ("..string.format("%.1f", 100*dmg/tot).."%)" end
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[1]..str[3])
		table.insert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.AurasUptimers:ShowTooltip(user,k)
	local a,b,c = DPSMate.Modules.AurasUptimers:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i].."%",1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.AurasUptimers:OpenDetails(obj, key)
	DPSMate.Modules.Auras:UpdateDetails(obj, key)
end

function DPSMate.Modules.Damage:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsDamageTotal:UpdateDetails(obj, key)
end

