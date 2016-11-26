-- Global Variables
DPSMate.Modules.Dispels = {}
DPSMate.Modules.Dispels.Hist = "Dispels"
DPSMate.Options.Options[1]["args"]["dispels"] = {
	order = 180,
	type = 'toggle',
	name = DPSMate.L["dispels"],
	desc = DPSMate.L["show"].." "..DPSMate.L["dispels"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["dispels"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "dispels", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("dispels", DPSMate.Modules.Dispels, DPSMate.L["dispels"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.Dispels:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do -- 3 Owner
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

function DPSMate.Modules.Dispels:EvalTable(user, k)
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

function DPSMate.Modules.Dispels:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	
	sortedTable, total, a = DPSMate.Modules.Dispels:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = val, total, sortedTable[1]
		if dmg==0 then break end;
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsdispels"][1] then str[1] = " "..DPSMate:Commas(dmg, k)..p; strt[2] = DPSMate:Commas(tot, k)..p end
		if DPSMateSettings["columnsdispels"][2] then str[3] = " ("..strformat("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, DPSMate:GetUserById(a[cat]))
		tinsert(value, str[2]..str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Dispels:ShowTooltip(user,k)
	local a,b,c = DPSMate.Modules.Dispels:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i].." ("..strformat("%.2f", 100*c[i]/b).."%)",1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.Dispels:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsDispels:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsDispels:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.Dispels:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsDispelsTotal:UpdateDetails(obj, key)
end

