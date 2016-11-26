-- Global Variables
DPSMate.Modules.AurasUptimers = {}
DPSMate.Modules.AurasUptimers.Hist = "Auras"
DPSMate.Options.Options[1]["args"]["aurasuptime"] = {
	order = 250,
	type = 'toggle',
	name = DPSMate.L["aurauptime"],
	desc = DPSMate.L["show"].." "..DPSMate.L["aurauptime"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["aurasuptime"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "aurasuptime", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("aurasuptime", DPSMate.Modules.AurasUptimers, DPSMate.L["aurauptime"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.AurasUptimers:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do -- 2 Target
		if DPSMate:ApplyFilter(k, DPSMate:GetUserById(cat)) then
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

function DPSMate.Modules.AurasUptimers:EvalTable(user, k)
	local a, b, c, total = {}, {}, {}, 0
	local arr, cbt = DPSMate:GetMode(k)
	if cbt>1 then
		cbt = cbt - 1;
	end
	for cat, val in pairs(arr[user[1]]) do -- 3 Ability
		local CV, CVV = 0, 0
		for ca, va in pairs(val[1]) do -- each one
			if arr[user[1]][cat][2][ca] then
				CV=CV+(arr[user[1]][cat][2][ca]-va)
			end
			CVV=CVV+1
		end
		local i = 1
		CV = tonumber(strformat("%.2f", (100*CV)/cbt))
		while true do
			if (not b[i]) then
				tinsert(c, i, CVV)
				tinsert(b, i, CV)
				tinsert(a, i, cat)
				break
			else
				if b[i] < CV then
					tinsert(c, i, CVV)
					tinsert(b, i, CV)
					tinsert(a, i, cat)
					break
				end
			end
			i=i+1
		end
	end
	return a, total, b, c
end

function DPSMate.Modules.AurasUptimers:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	
	sortedTable, total, a = DPSMate.Modules.AurasUptimers:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = val, total, sortedTable[1]
		if dmg==0 then break end;
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsaurauptime"][1] then str[1] = " "..(DPSMate:Commas(dmg, k) or dmg); strt[2] = DPSMate:Commas(tot, k) or tot end
		if DPSMateSettings["columnsaurauptime"][2] then str[3] = " ("..strformat("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, DPSMate:GetUserById(a[cat]))
		tinsert(value, str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
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

function DPSMate.Modules.AurasUptimers:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.Auras:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.Auras:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.AurasUptimers:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsAurasTotal:UpdateDetails(obj, key)
end

