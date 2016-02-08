-- Global Variables
DPSMate.Modules.DTPS = {}
DPSMate.Modules.DTPS.Hist = "DMGTaken"
DPSMate.Options.Options[1]["args"]["dtps"] = {
	order = 35,
	type = 'toggle',
	name = 'DTPS',
	desc = 'TO BE ADDED',
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["dtps"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "dtps", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("dtps", DPSMate.Modules.DTPS)


function DPSMate.Modules.DTPS:GetSortedTable(arr)
	local b, a, total = {}, {}, 0
	for c, v in pairs(arr) do
		local i = 1
		while true do
			if (not b[i]) then
				table.insert(b, i, v["i"][2])
				table.insert(a, i, c)
				break
			else
				if b[i] < v["i"][2] then
					table.insert(b, i, v["i"][2])
					table.insert(a, i, c)
					break
				end
			end
			i=i+1
		end
		total = total + v["i"][2]
	end
	return b, total, a
end

function DPSMate.Modules.DTPS:EvalTable(user, k)
	local a, d = {}, {}
	local arr = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	for cat, val in pairs(arr[user[1]]) do
		if cat~="i" then
			local ta, tb, CV = {}, {}, 0
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
		end
	end
	return a, arr[user[1]]["i"][2], d
end

function DPSMate.Modules.DTPS:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.DTPS:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsdtps"][2] then str[1] = " "..string.format("%.1f", dmg/cbt)..p; strt[2] = " "..string.format("%.1f", tot/cbt)..p end 
		if DPSMateSettings["columnsdtps"][3] then str[2] = " ("..string.format("%.1f", 100*dmg/tot).."%)" end
		if DPSMateSettings["columnsdtps"][1] then str[3] = "("..dmg..p..")"; strt[1] = "("..tot..p..")" end
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[3]..str[1]..str[2])
		table.insert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.DTPS:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.DTPS:EvalTable(DPSMateUser[user], k)
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

function DPSMate.Modules.DTPS:OpenDetails(obj, key)
	DPSMate.Modules.DetailsDamageTaken:UpdateDetails(obj, key)
end

function DPSMate.Modules.DTPS:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsDamageTakenTotal:UpdateDetails(obj, key)
end
