-- Global Variables
DPSMate.Modules.Healing = {}
DPSMate.Modules.Healing.Hist = "THealing"
DPSMate.Options.Options[1]["args"]["healing"] = {
	order = 60,
	type = 'toggle',
	name = DPSMate.L["healing"],
	desc = DPSMate.L["show"].." "..DPSMate.L["healing"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["healing"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "healing", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("healing", DPSMate.Modules.Healing, DPSMate.L["healing"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.Healing:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	for c, v in pairs(arr) do
		if DPSMate:ApplyFilter(k, DPSMate:GetUserById(c)) then
			local i = 1
			while true do
				if (not b[i]) then
					tinsert(b, i, v["i"])
					tinsert(a, i, c)
					break
				else
					if b[i] < v["i"] then
						tinsert(b, i, v["i"])
						tinsert(a, i, c)
						break
					end
				end
				i=i+1
			end
			total = total + v["i"]
		end
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
					tinsert(a, i, cat)
					tinsert(d, i, val[1])
					break
				else
					if (d[i] < val[1]) then
						tinsert(a, i, cat)
						tinsert(d, i, val[1])
						break
					end
				end
				i = i + 1
			end
		end
	end
	return a, arr[user[1]]["i"], d
end

function DPSMate.Modules.Healing:GetSettingValues(arr, cbt, k,ecbt)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 or DPSMateSettings["windows"][k]["numberformat"] == 4 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.Healing:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local va, tot, sort, varea, totr, sortr = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if varea==0 then break end; if varea<=10000 then p = "" end
		local str = {[1]="",[2]="",[3]="",[4]=""}
		local pname = DPSMate:GetUserById(a[cat])
		if DPSMateSettings["columnshealing"][1] then str[1] = " "..DPSMate:Commas(va, k)..p; strt[2] = DPSMate:Commas(tot, k)..p end
		if DPSMateSettings["columnshealing"][3] then str[2] = " ("..strformat("%.1f", 100*varea/totr).."%)" end
		if DPSMateSettings["columnshealing"][2] then str[3] = "("..strformat("%.1f", va/cbt)..p..")"; strt[1] = "("..strformat("%.1f", tot/cbt)..p..")" end
		if DPSMateSettings["columnshealing"][4] then str[4] = " ("..strformat("%.1f", va/(ecbt[pname] or cbt))..p..")" end
		tinsert(name, pname)
		tinsert(value, str[3]..str[1]..str[4]..str[2])
		tinsert(perc, 100*(varea/sortr))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Healing:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.Healing:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i].." ("..strformat("%.2f", 100*c[i]/b).."%)",1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.Healing:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsHealing:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsHealing:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.Healing:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsHealingTotal:UpdateDetails(obj, key)
end

