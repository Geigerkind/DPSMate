-- Global Variables
DPSMate.Modules.Absorbs = {}
DPSMate.Modules.Absorbs.Hist = "Absorbs"
DPSMate.Options.Options[1]["args"]["absorbs"] = {
	order = 110,
	type = 'toggle',
	name = 'Absorbs',
	desc = 'TO BE ADDED!',
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["absorbs"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "absorbs", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("absorbs", DPSMate.Modules.Absorbs)


function DPSMate.Modules.Absorbs:GetSortedTable(arr)
	local b, a, total = {}, {}, 0
	local temp = {}
	if arr then
		for cat, val in pairs(arr) do -- 28 Target
			local PerPlayerAbsorb = 0
			for ca, va in pairs(val) do -- 28 Owner
				local PerOwnerAbsorb = 0
				for c, v in pairs(va) do -- Power Word: Shield
					local PerAbilityAbsorb = 0
					for ce, ve in pairs(v) do -- 1
						local PerShieldAbsorb = 0
						for cet, vel in pairs(ve) do
							PerShieldAbsorb=PerShieldAbsorb+vel[2]*5
						end
						if ve["info"][1]==1 then
							PerShieldAbsorb=PerShieldAbsorb+ve["info"][2]
						end
						PerAbilityAbsorb = PerAbilityAbsorb+PerShieldAbsorb
					end
					PerOwnerAbsorb = PerOwnerAbsorb+PerAbilityAbsorb
				end
				if not temp[ca] then temp[ca] = PerOwnerAbsorb else temp[ca]=temp[ca]+PerOwnerAbsorb end
				PerPlayerAbsorb = PerPlayerAbsorb+PerOwnerAbsorb
			end
			total = total+PerPlayerAbsorb
		end
		for cat, val in pairs(temp) do
			a[val] = cat
			local i = 1
			while true do
				if (not b[i]) then
					table.insert(b, i, val)
					break
				else
					if b[i] < val then
						table.insert(b, i, val)
						break
					end
				end
				i=i+1
			end
		end
	end
	return b, total, a
end

function DPSMate.Modules.Absorbs:EvalTable(user, k)
	local a, u, p, d, total = {}, {}, {}, {}, 0
	local arr = DPSMate:GetMode(k)
	if not arr[user["id"]] then return end
	for cat, val in pairs(arr[user["id"]]) do
		if cat~="info" then
			local CV = 0
			for ca, va in pairs(val) do
				CV=CV+va[1]
			end
			local i = 1
			while true do
				if (not d[i]) then
					table.insert(a, i, cat)
					table.insert(d, i, CV)
					break
				else
					if (d[i] < CV) then
						table.insert(a, i, cat)
						table.insert(d, i, CV)
						break
					end
				end
				i = i + 1
			end
		end
	total=total+arr[user["id"]]["info"][1]
	end
	return a, total, d
end

function DPSMate.Modules.Absorbs:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.Absorbs:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local va, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if va==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		str[1] = " "..va..p; strt[2] = tot..p
		str[2] = " ("..string.format("%.1f", 100*va/tot).."%)"
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[1]..str[2])
		table.insert(perc, 100*(va/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Absorbs:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.Absorbs:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..a[i],c[i],1,1,1,1,1,1)
		end
	end
end


