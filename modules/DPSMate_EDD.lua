-- Global Variables
DPSMate.Modules.EDD = {}
DPSMate.Modules.EDD.Hist = "EDDone"
DPSMate.Options.Options[1]["args"]["enemydamagedone"] = {
	order = 40,
	type = 'toggle',
	name = DPSMate.localization.config.enemydamagedone,
	desc = "Show Enemy damage done.",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["enemydamagedone"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "enemydamagedone", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("enemydamagedone", DPSMate.Modules.EDD, "Enemy damage done")


function DPSMate.Modules.EDD:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	for c, v in pairs(arr) do
		if DPSMate:ApplyFilter(k, DPSMate:GetUserById(c)) then
			local CV = 0
			for cat, val in pairs(v) do
				if cat~="i" then
					CV = CV+val["i"][2]
				end
			end
			local i = 1
			while true do
				if (not b[i]) then
					table.insert(b, i, CV)
					table.insert(a, i, c)
					break
				else
					if b[i] < CV then
						table.insert(b, i, CV)
						table.insert(a, i, c)
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

function DPSMate.Modules.EDD:EvalTable(user, k)
	local a, temp, d, total = {}, {}, {}, 0
	local arr = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	for cat, val in pairs(arr[user[1]]) do
		local ta, td = {}, {}
		for ca, va in pairs(val) do
			if ca~="i" then
				local i = 1
				while true do
					if (not td[i]) then
						table.insert(ta, i, ca)
						table.insert(td, i, va[13])
						break
					else
						if (td[i] < va[13]) then
							table.insert(ta, i, ca)
							table.insert(td, i, va[13])
							break
						end
					end
					i = i + 1
				end
			end
		end
		local i = 1
		while true do
			if (not d[i]) then
				table.insert(a, i, cat)
				table.insert(d, i, {val["i"][2], ta, td})
				break
			else
				if (d[i][1] < val["i"][2]) then
					table.insert(a, i, cat)
					table.insert(d, i, {val["i"][2], ta, td})
					break
				end
			end
			i = i + 1
		end
		total=total+val["i"][2]
	end
	return a, total, d
end

function DPSMate.Modules.EDD:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.EDD:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsedd"][1] then str[1] = " "..dmg..p; strt[2] = " "..tot..p end
		if DPSMateSettings["columnsedd"][3] then str[2] = " ("..string.format("%.1f", 100*dmg/tot).."%)" end
		if DPSMateSettings["columnsedd"][2] then str[3] = "("..string.format("%.1f", dmg/cbt)..p..")" strt[1] = "("..string.format("%.1f", tot/cbt)..p..")" end
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[3]..str[1]..str[2])
		table.insert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.EDD:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.EDD:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(a[i]),c[i][1].." ("..string.format("%.2f", 100*c[i][1]/b).."%)",1,1,1,1,1,1)
			for p=1, 3 do 
				if not c[i][2][p] or c[i][3][p]==0 then break end
				GameTooltip:AddDoubleLine("       "..p..". "..DPSMate:GetAbilityById(c[i][2][p]),c[i][3][p].." ("..string.format("%.2f", 100*c[i][3][p]/c[i][1]).."%)",0.5,0.5,0.5,0.5,0.5,0.5)
			end
		end
	end
end


function DPSMate.Modules.EDD:OpenDetails(obj, key)
	DPSMate.Modules.DetailsEDD:UpdateDetails(obj, key)
end

function DPSMate.Modules.EDD:OpenTotalDetails(obj, key)
	--DPSMate.Modules.DetailsDamageTotal:UpdateDetails(obj, key)
	DPSMate:SendMessage("This feature will be added soon!")
end

