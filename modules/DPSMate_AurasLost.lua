-- Global Variables
DPSMate.Modules.AurasLost = {}
DPSMate.Modules.AurasLost.Hist = "Auras"
DPSMate.Options.Options[1]["args"]["auraslost"] = {
	order = 240,
	type = 'toggle',
	name = DPSMate.L["auraslost"],
	desc = DPSMate.L["show"].." "..DPSMate.L["auraslost"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["auraslost"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "auraslost", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("auraslost", DPSMate.Modules.AurasLost, DPSMate.L["auraslost"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.AurasLost:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do -- 2 Target
		if DPSMate:ApplyFilter(k, DPSMate:GetUserById(cat)) then
			local CV = 0
			for ca, va in pairs(val) do -- 3 ability
				for c, v in pairs(va) do -- 1 Ability
					if c==2 then
						for ce, ve in pairs(v) do
							CV=CV+1
						end
					end
				end
			end
			local i = 1
			while true do
				if (not b[i]) then
					tinsert(b, i, CV)
					tinsert(a, i, cat)
					break
				else
					if b[i] < CV then
						tinsert(b, i, CV)
						tinsert(a, i, cat)
						break
					end
				end
				i=i+1
			end
			total = total + CV
		end
	end
	return b, total, a
end

function DPSMate.Modules.AurasLost:EvalTable(user, k)
	local a, b, temp, total = {}, {}, {}, 0
	local arr = DPSMate:GetMode(k)
	for cat, val in pairs(arr[user[1]]) do -- 3 Ability
		local CV = 0
		for ca, va in pairs(val) do -- each one
			if ca==2 then
				for ce, ve in pairs(va) do
					CV=CV+1
				end
			end
		end
		if temp[cat] then temp[cat]=temp[cat]+CV else temp[cat]=CV end
	end
	for cat, val in pairs(temp) do
		local i = 1
		while true do
			if (not b[i]) then
				tinsert(b, i, val)
				tinsert(a, i, cat)
				break
			else
				if b[i] < val then
					tinsert(b, i, val)
					tinsert(a, i, cat)
					break
				end
			end
			i=i+1
		end
		total = total + val
	end
	return a, total, b
end

function DPSMate.Modules.AurasLost:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	
	sortedTable, total, a = DPSMate.Modules.AurasLost:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = val, total, sortedTable[1]
		if dmg==0 then break end;
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsauraslost"][1] then str[1] = " "..(DPSMate:Commas(dmg, k) or dmg); strt[2] = DPSMate:Commas(tot, k) or tot end
		if DPSMateSettings["columnsauraslost"][2] then str[3] = " ("..strformat("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, DPSMate:GetUserById(a[cat]))
		tinsert(value, str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.AurasLost:ShowTooltip(user,k)
	local a,b,c = DPSMate.Modules.AurasLost:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i].." ("..strformat("%.2f", 100*c[i]/b).."%)",1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.AurasLost:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.Auras:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.Auras:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.AurasLost:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsAurasTotal:UpdateDetails(obj, key)
end

