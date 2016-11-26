-- Global Variables
DPSMate.Modules.OHPS = {}
DPSMate.Modules.OHPS.Hist = "OHealing"
DPSMate.Options.Options[1]["args"]["OHPS"] = {
	order = 79,
	type = 'toggle',
	name = DPSMate.L["OHPS"],
	desc = DPSMate.L["show"].." "..DPSMate.L["OHPS"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["OHPS"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "OHPS", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("OHPS", DPSMate.Modules.OHPS, DPSMate.L["OHPS"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.OHPS:GetSortedTable(arr,k)
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

function DPSMate.Modules.OHPS:EvalTable(user, k, cbt)
	local a, d = {}, {}
	local arr, cbet = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	cbt = cbt or cbet
	for cat, val in pairs(arr[user[1]]) do
		if cat~="i" then
			local i = 1
			while true do
				if (not d[i]) then
					tinsert(a, i, cat)
					tinsert(d, i, val[1]/cbt)
					break
				else
					if (d[i] < val[1]/cbt) then
						tinsert(a, i, cat)
						tinsert(d, i, val[1]/cbt)
						break
					end
				end
				i = i + 1
			end
		end
	end
	return a, arr[user[1]]["i"]/(cbt or 1), d
end

function DPSMate.Modules.OHPS:GetSettingValues(arr, cbt, k,ecbt)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 or DPSMateSettings["windows"][k]["numberformat"] == 4 then p = "K" end
	sortedTable, total, a = self:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local va, tot, sort, varea, totr, sortr = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if varea==0 then break end; if varea<=10000 then p = "" end
		local str = {[1]="",[2]="",[3]="",[4]=""}
		local pname = DPSMate:GetUserById(a[cat])
		if DPSMateSettings["columnsohps"][2] then str[1] = " "..strformat("%.1f", va/cbt)..p; strt[2] = " "..strformat("%.1f", tot/cbt)..p end
		if DPSMateSettings["columnsohps"][3] then str[2] = " ("..strformat("%.1f", 100*varea/totr).."%)" end
		if DPSMateSettings["columnsohps"][1] then str[3] = "("..DPSMate:Commas(va, k)..p..")"; strt[1] = "("..DPSMate:Commas(tot, k)..p..")" end
		if DPSMateSettings["columnsohps"][4] then str[4] = " ("..strformat("%.1f", va/(ecbt[pname] or cbt))..p..")" end
		tinsert(name, pname)
		tinsert(value, str[3]..str[1]..str[4]..str[2])
		tinsert(perc, 100*(varea/sortr))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.OHPS:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.OHPS:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),strformat("%.2f", c[i]).." ("..strformat("%.2f", 100*c[i]/b).."%)",1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.OHPS:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsOverhealing:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsOverhealing:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.OHPS:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsOverhealingTotal:UpdateDetails(obj, key)
end

