-- Global Variables
DPSMate.Modules.DPS = {}
DPSMate.Modules.DPS.Hist = "DMGDone"
DPSMate.Options.Options[1]["args"]["dps"] = {
	order = 10,
	type = 'toggle',
	name = DPSMate.localization.config.dps,
	desc = DPSMate.localization.desc.dps,
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["dps"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "dps", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("dps", DPSMate.Modules.DPS)


function DPSMate.Modules.DPS:GetSortedTable(arr)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do
		local name = DPSMate:GetUserById(cat)
		if (not DPSMateUser[name]["isPet"]) then
			local CV = val["i"][3]
			if DPSMate:PlayerExist(DPSMateUser, DPSMateUser[name]["pet"]) and arr[DPSMateUser[DPSMateUser[name]["pet"]][1]] then
				CV=CV+arr[DPSMateUser[DPSMateUser[name]["pet"]][1]]["i"][3]
			end
			a[CV] = name
			local i = 1
			while true do
				if (not b[i]) then
					table.insert(b, i, CV)
					table.insert(a, i, name)
					break
				else
					if b[i] < CV then
						table.insert(b, i, CV)
						table.insert(a, i, name)
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

function DPSMate.Modules.DPS:EvalTable(user, k)
	local a, u, p, d, total, pet = {}, {}, {}, {}, 0, ""
	local arr = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	if (user["pet"] and user["pet"] ~= "Unknown" and arr[DPSMateUser[user["pet"]][1]]) then u={user[1],DPSMateUser[user["pet"]][1]} else u={user[1]} end
	for _, v in pairs(u) do
		for cat, val in pairs(arr[v]) do
			if (type(val) == "table" and cat~="i") then
				if val[13]~=0 and cat~="" then
					if (DPSMateUser[DPSMate:GetUserById(v)]["isPet"]) then pet="(Pet)"; else pet=""; end
					local i = 1
					while true do
						if (not d[i]) then
							table.insert(a, i, cat..pet)
							table.insert(d, i, val[13])
							break
						else
							if (d[i] < val[13]) then
								table.insert(a, i, cat..pet)
								table.insert(d, i, val[13])
								break
							end
						end
						i = i + 1
					end
				end
			end
		end
		total=total+arr[v]["i"][3]
	end
	return a, total, d
end

function DPSMate.Modules.DPS:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.DPS:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsdps"][1] then str[1] = "("..dmg..p..")"; strt[1] = "("..tot..p..")" end
		if DPSMateSettings["columnsdps"][2] then str[2] = " "..string.format("%.1f", (dmg/cbt))..p; strt[2] = " "..string.format("%.1f", (tot/cbt))..p end
		if DPSMateSettings["columnsdps"][3] then str[3] = " ("..string.format("%.1f", 100*dmg/tot).."%)" end
		table.insert(name, a[cat])
		table.insert(value, str[1]..str[2]..str[3])
		table.insert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.DPS:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.DPS:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i],1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.DPS:OpenDetails(obj, key)
	DPSMate.Modules.DetailsDamage:UpdateDetails(obj, key)
end
