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
				if va["i"]==1 then
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
	local p = 1
	if not arr[user[1]] then return end
	if arr[user[1]][1] then 
		if arr[user[1]][1]["i"]~=1 then p=2 else p=1 end 
		if arr[user[1]][p] then 
			for ca, va in pairs(arr[user[1]][p]) do -- 1 (Death)
				if ca~="i" then
					table.insert(b, ca, {va[3], va[5]})
					table.insert(a, ca, va[2])
				end
			end
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
		if DPSMateSettings["columnsdeaths"][1] then str[1] = " "..dmg..p; strt[2] = tot..p end
		if DPSMateSettings["columnsdeaths"][2] then str[3] = " ("..string.format("%.1f", 100*dmg/tot).."%)" end
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[1]..str[3])
		table.insert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Deaths:ShowTooltip(user,k)
	local a,b,c = DPSMate.Modules.Deaths:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			if c[i][2]==1 then
				GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),"+"..c[i][1],0.67,0.83,0.45,0.67,0.83,0.45)
			else
				GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),"-"..c[i][1],0.77,0.12,0.23,0.77,0.12,0.23)
			end
		end
	end
end


