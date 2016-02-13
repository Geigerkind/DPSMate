-- Global Variables
DPSMate.Modules.AbsorbsTaken = {}
DPSMate.Modules.AbsorbsTaken.Hist = "Absorbs"
DPSMate.Options.Options[1]["args"]["absorbstaken"] = {
	order = 120,
	type = 'toggle',
	name = 'Absorbs taken',
	desc = 'TO BE ADDED!',
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["absorbstaken"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "absorbstaken", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("absorbstaken", DPSMate.Modules.AbsorbsTaken)


function DPSMate.Modules.AbsorbsTaken:GetSortedTable(arr)
	local b, a, total = {}, {}, 0
	local temp = {}
	for cat, val in pairs(arr) do -- 28 Target
		local PerPlayerAbsorb = 0
		for ca, va in pairs(val) do -- 28 Owner
			local PerOwnerAbsorb = 0
			for c, v in pairs(va) do -- Power Word: Shield
				if c~="i" then
					local PerAbilityAbsorb = 0
					for ce, ve in pairs(v) do -- 1
						local PerShieldAbsorb = 0
						for cet, vel in pairs(ve) do
							if cet~="i" then
								local p = 5
								if DPSMateDamageTaken[1][cat][cet][vel[1]][14]~=0 then
									p=ceil(DPSMateDamageTaken[1][cat][cet][vel[1]][14])
								end
								PerShieldAbsorb=PerShieldAbsorb+vel[2]*p
							end
						end
						if ve["i"][1]==1 then
							PerShieldAbsorb=PerShieldAbsorb+ve["i"][2]
						end
						PerAbilityAbsorb = PerAbilityAbsorb+PerShieldAbsorb
					end
					PerOwnerAbsorb = PerOwnerAbsorb+PerAbilityAbsorb
				end
			end
			PerPlayerAbsorb = PerPlayerAbsorb+PerOwnerAbsorb
		end
		total = total+PerPlayerAbsorb
		local i = 1
		while true do
			if (not b[i]) then
				table.insert(b, i, PerPlayerAbsorb)
				table.insert(a, i, cat)
				break
			else
				if b[i] < PerPlayerAbsorb then
					table.insert(b, i, PerPlayerAbsorb)
					table.insert(a, i, cat)
					break
				end
			end
			i=i+1
		end
	end
	return b, total, a
end

function DPSMate.Modules.AbsorbsTaken:EvalTable(user, k)
	local arr = DPSMate:GetMode(k)
	local b, a, total = {}, {}, 0
	if not arr[user[1]] then return end
	for cat, val in pairs(arr[user[1]]) do -- 28 Target
		for ca, va in pairs(val) do -- Power Word Shield
			if ca~="i" then
				local PerAbilityAbsorb = 0
				for c, v in pairs(va) do -- 1
					local PerShieldAbsorb = 0
					for ce, ve in pairs(v) do
						if ce~="i" then
							local p = 5
							if DPSMateDamageTaken[1][user[1]][ce][ve[1]][14]~=0 then
								p=ceil(DPSMateDamageTaken[1][user[1]][ce][ve[1]][14])
							end
							PerShieldAbsorb=PerShieldAbsorb+ve[2]*p
						end
					end
					PerAbilityAbsorb=PerAbilityAbsorb+PerShieldAbsorb
				end
				local i = 1
				while true do
					if (not b[i]) then
						table.insert(b, i, PerAbilityAbsorb)
						table.insert(a, i, cat)
						break
					else
						if b[i] < PerAbilityAbsorb then
							table.insert(b, i, PerAbilityAbsorb)
							table.insert(a, i, cat)
							break
						end
					end
					i=i+1
				end
			end
		end
	end
	return b, total, a
end

function DPSMate.Modules.AbsorbsTaken:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.AbsorbsTaken:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local va, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if va==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsabsorbstaken"][1] then str[1] = " "..va..p; strt[2] = " "..tot..p end
		if DPSMateSettings["columnsabsorbstaken"][1] then str[2] = " ("..string.format("%.1f", 100*va/tot).."%)" end
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[1]..str[2])
		table.insert(perc, 100*(va/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.AbsorbsTaken:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.AbsorbsTaken:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(c[i]),a[i],1,1,1,1,1,1)
		end
	end
end


