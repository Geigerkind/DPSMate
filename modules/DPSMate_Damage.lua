-- Global Variables
DPSMate.Modules.Damage = {}
DPSMate.Modules.DB = DPSMateDamageDone

-- Register the moodule
DPSMate:Register("damage", DPSMate.Modules.Damage)


function DPSMate.Modules.Damage:GetSortedTable(arr)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do
		local name = DPSMate:GetUserById(cat)
		if (not DPSMateUser[name]["isPet"]) then
			local CV = val["info"][3]
			if DPSMate:PlayerExist(DPSMateUser, DPSMateUser[name]["pet"]) and arr[DPSMateUser[DPSMateUser[name]["pet"]]["id"]] then
				CV=CV+arr[DPSMateUser[DPSMateUser[name]["pet"]]["id"]]["info"][3]
			end
			a[CV] = name
			local i = 1
			while true do
				if (not b[i]) then
					table.insert(b, i, CV)
					break
				else
					if b[i] < CV then
						table.insert(b, i, CV)
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

function DPSMate.Modules.Damage:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.Damage:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsdmg"][1] then str[1] = " "..dmg..p; strt[2] = tot..p end
		if DPSMateSettings["columnsdmg"][2] then str[2] = "("..string.format("%.1f", (dmg/cbt))..p..")"; strt[1] = "("..string.format("%.1f", (tot/cbt))..p..") " end
		if DPSMateSettings["columnsdmg"][3] then str[3] = " ("..string.format("%.1f", 100*dmg/tot).."%)" end
		table.insert(name, a[val])
		table.insert(value, str[2]..str[1]..str[3])
		table.insert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Damage:ShowTooltip()
	
end


