-- Global Variables
DPSMate.Modules.Deaths = {}
DPSMate.Modules.Deaths.Hist = "Deaths"
DPSMate.Options.Options[1]["args"]["deaths"] = {
	order = 160,
	type = 'toggle',
	name = DPSMate.localization.config.deaths,
	desc = DPSMate.localization.desc.deaths,
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["deaths"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "deaths", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("deaths", DPSMate.Modules.Deaths)


function DPSMate.Modules.Deaths:GetSortedTable(arr)
	local b, a, total = {}, {}, 0
	if arr then
		for cat, val in pairs(arr) do -- 28
			local CV = 0
			for ca, va in pairs(val) do -- 1 (Death)
				if va["info"]==1 then
					CV=CV+1
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
	end
	return b, total, a
end

-- Needs improvement, but kinda all tooltips need that
function DPSMate.Modules.Deaths:EvalTable(user, k)
	local a, b, total = {}, {}, 0
	local arr = DPSMate:GetMode(k)
	if not arr[user["id"]] then return end
	for ca, va in pairs(arr[user["id"]][DPSMate:TableLength(arr[user["id"]])]) do -- 1 (Death)
		if ca~="info" then
			table.insert(b, ca, va[3])
			table.insert(a, ca, va[2])
		end
	end
	return a, total, b
end

function DPSMate.Modules.Deaths:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.Deaths:GetSortedTable(arr)
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

function DPSMate.Modules.Deaths:ShowTooltip(user,k)
	local a,b,c = DPSMate.Modules.Deaths:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..a[i],c[i],1,1,1,1,1,1)
		end
	end
end


