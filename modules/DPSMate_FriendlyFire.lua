-- Global Variables
DPSMate.Modules.FriendlyFire = {}
DPSMate.Modules.FriendlyFire.Hist = "EDTaken"
DPSMate.Options.Options[1]["args"]["friendlyfire"] = {
	order = 260,
	type = 'toggle',
	name = 'Friendly fire',
	desc = 'TO BE ADDED!',
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["friendlyfire"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "friendlyfire", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("friendlyfire", DPSMate.Modules.FriendlyFire)


function DPSMate.Modules.FriendlyFire:GetSortedTable(arr)
	local b, a, total, temp = {}, {}, 0, {}
	for c, v in pairs(arr) do
		local cName = DPSMate:GetUserById(c)
		for cat, val in pairs(v) do
			local catName = DPSMate:GetUserById(cat)
			--DPSMate:SendMessage(catName.." and "..cName)
			--DPSMate:SendMessage((DPSMateUser[cName][3] or "").." and "..(DPSMateUser[catName][3] or ""))
			if DPSMateUser[cName][3] == DPSMateUser[catName][3] and DPSMateUser[catName][3] and DPSMateUser[cName][3] then
				if temp[cat] then temp[cat]=temp[cat]+val["i"][2] else temp[cat] = val["i"][2] end
			end
		end
	end
	for cat, val in pairs(temp) do
		--DPSMate:SendMessage(val)
		local i = 1
		while true do
			if (not b[i]) then
				table.insert(b, i, val)
				table.insert(a, i, cat)
				break
			else
				if b[i] < val then
					table.insert(b, i, val)
					table.insert(a, i, cat)
					break
				end
			end
			i=i+1
		end
		total = total + val
	end
	return b, total, a
end

function DPSMate.Modules.FriendlyFire:EvalTable(user, k)
	local a, d, total, temp = {}, {}, 0, {}
	local arr = DPSMate:GetMode(k)
	for c, v in pairs(arr) do
		local cName = DPSMate:GetUserById(c)
		if v[user[1]] and DPSMateUser[cName][3] == user[3] and DPSMateUser[cName][3] then
			for cat, val in v[user[1]] do
				if cat~="i" then
					if temp[c] then 
						temp[c][1]=temp[c][1]+val[13]
						local i = 1
						while true do
							if (not temp[c][3][i]) then
								table.insert(temp[c][3], i, val[13])
								table.insert(temp[c][2], i, cat)
								break
							else
								if temp[c][3][i] < val[13] then
									table.insert(temp[c][3], i, val[13])
									table.insert(temp[c][2], i, cat)
									break
								end
							end
							i=i+1
						end
					else 
						temp[c] = {val[13], {[1]=cat}, {[1]=val[13]}}	
					end
				end
			end
		end
	end
	for cat, val in pairs(temp) do
		if val~=0 then
			local i = 1
			while true do
				if (not d[i]) then
					table.insert(d, i, val)
					table.insert(a, i, cat)
					break
				else
					if d[i][1] < val[1] then
						table.insert(d, i, val)
						table.insert(a, i, cat)
						break
					end
				end
				i=i+1
			end
			total = total + val[1]
		end
	end
	return a, total, d
end

function DPSMate.Modules.FriendlyFire:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.FriendlyFire:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsfriendlyfire"][1] then str[1] = " "..dmg..p; strt[2] = " "..tot..p end
		if DPSMateSettings["columnsfriendlyfire"][3] then str[2] = " ("..string.format("%.1f", 100*dmg/tot).."%)" end
		if DPSMateSettings["columnsfriendlyfire"][2] then str[3] = "("..string.format("%.1f", dmg/cbt)..")"; strt[1] = "("..string.format("%.1f", tot/cbt)..")" end
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[3]..str[1]..str[2])
		table.insert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.FriendlyFire:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.FriendlyFire:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(a[i]),c[i][1],1,1,1,1,1,1)
			for p=1, 4 do 
				if not c[i][2][p] or c[i][3][p]==0 then break end
				GameTooltip:AddDoubleLine("       "..p..". "..DPSMate:GetAbilityById(c[i][2][p]),c[i][3][p],0.5,0.5,0.5,0.5,0.5,0.5)
			end
		end
	end
end

function DPSMate.Modules.FriendlyFire:OpenDetails(obj, key)
	DPSMate.Modules.DetailsFF:UpdateDetails(obj, key)
end

function DPSMate.Modules.Damage:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsDamageTotal:UpdateDetails(obj, key)
end

