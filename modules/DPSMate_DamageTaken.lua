-- Global Variables
DPSMate.Modules.DamageTaken = {}
DPSMate.Modules.DamageTaken.Hist = "DMGTaken"
DPSMate.Options.Options[1]["args"]["damagetaken"] = {
	order = 30,
	type = 'toggle',
	name = DPSMate.localization.config.damagetaken,
	desc = DPSMate.localization.desc.damagetaken,
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["damagetaken"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "damagetaken", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("damagetaken", DPSMate.Modules.DamageTaken)


function DPSMate.Modules.DamageTaken:GetSortedTable(arr)
	local b, a, total = {}, {}, 0
	for c, v in pairs(arr) do
		local CV = 0
		for cat, val in pairs(v) do
			if cat~="i" then
			CV = CV+val["i"]
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
	return b, total, a
end

function DPSMate.Modules.DamageTaken:EvalTable(user, k)
	local a, u, p, d, total = {}, {}, {}, {}, 0
	local arr = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	for cat, val in pairs(arr[user[1]]) do
		if cat~="i" then
		local CV = 0
		local ta, tb = {}, {}
		for ca, va in pairs(val) do
			if ca~="i" then
				CV = CV + va[13]
				local i = 1
				while true do
					if (not tb[i]) then
						table.insert(ta, i, ca)
						table.insert(tb, i, va[13])
						break
					else
						if (tb[i] < va[13]) then
							table.insert(ta, i, ca)
							table.insert(tb, i, va[13])
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
				table.insert(d, i, {CV, ta, tb})
				break
			else
				if (d[i][1] < CV) then
					table.insert(a, i, cat)
					table.insert(d, i, {CV, ta, tb})
					break
				end
			end
			i = i + 1
		end
		total=total+val["i"]
		end
	end
	return a, total, d
end

function DPSMate.Modules.DamageTaken:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.DamageTaken:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsdmgtaken"][1] then str[1] = " "..dmg..p; strt[2] = " "..tot..p end
		if DPSMateSettings["columnsdmgtaken"][2] then str[3] = "("..string.format("%.1f", dmg/cbt)..")"; strt[1] = "("..string.format("%.1f", tot/cbt)..")" end
		if DPSMateSettings["columnsdmgtaken"][3] then str[2] = " ("..string.format("%.1f", 100*dmg/tot).."%)" end 
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[3]..str[1]..str[2])
		table.insert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.DamageTaken:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.DamageTaken:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(a[i]),c[i][1],1,1,1,1,1,1)
			for p=1, 3 do 
				if not c[i][2][p] or c[i][3][p]==0 then break end
				GameTooltip:AddDoubleLine("       "..p..". "..DPSMate:GetAbilityById(c[i][2][p]),c[i][3][p],0.5,0.5,0.5,0.5,0.5,0.5)
			end
		end
	end
end

function DPSMate.Modules.DamageTaken:OpenDetails(obj, key)
	DPSMate.Modules.DetailsDamageTaken:UpdateDetails(obj, key)
end

function DPSMate.Modules.DamageTaken:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsDamageTakenTotal:UpdateDetails(obj, key)
end

