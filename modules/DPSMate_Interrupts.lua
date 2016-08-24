-- Global Variables
DPSMate.Modules.Interrupts = {}
DPSMate.Modules.Interrupts.Hist = "Interrupts"
DPSMate.Options.Options[1]["args"]["interrupts"] = {
	order = 160,
	type = 'toggle',
	name = DPSMate.L["interrupts"],
	desc = DPSMate.L["show"].." "..DPSMate.L["interrupts"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["interrupts"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "interrupts", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("interrupts", DPSMate.Modules.Interrupts, DPSMate.L["interrupts"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.Interrupts:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do -- 1 Owner
		if DPSMate:ApplyFilter(k, DPSMate:GetUserById(cat)) then
			local i = 1
			while true do
				if (not b[i]) then
					tinsert(b, i, val["i"][1])
					tinsert(a, i, cat)
					break
				else
					if b[i] < val["i"][1] then
						tinsert(b, i, val["i"][1])
						tinsert(a, i, cat)
						break
					end
				end
				i=i+1
			end
			total = total + val["i"][1]
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
		end
	end
	return a, arr[user[1]]["i"][1], b
end

function DPSMate.Modules.Interrupts:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.Interrupts:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsinterrupts"][1] then str[1] = " "..dmg..p; strt[2] = tot..p end
		if DPSMateSettings["columnsinterrupts"][2] then str[3] = " ("..strformat("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, DPSMate:GetUserById(a[cat]))
		tinsert(value, str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Interrupts:ShowTooltip(user,k)
	local a,b,c = DPSMate.Modules.Interrupts:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i].." ("..strformat("%.2f", 100*c[i]/b).."%)",1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.Interrupts:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsInterrupts:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsInterrupts:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.Interrupts:OpenTotalDetails(obj, key)
	--DPSMate.Modules.DetailsDamageTotal:UpdateDetails(obj, key)
	DPSMate:SendMessage("This feature will be added soon!")
end

