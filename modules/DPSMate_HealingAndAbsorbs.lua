-- Global Variables
DPSMate.Modules.HealingAndAbsorbs = {}
DPSMate.Modules.HealingAndAbsorbs.Hist = "Absorbs"
DPSMate.Options.Options[1]["args"]["healingandabsorbs"] = {
	order = 130,
	type = 'toggle',
	name = 'Healing and Absorbs',
	desc = 'TO BE ADDED!',
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["healingandabsorbs"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "healingandabsorbs", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("healingandabsorbs", DPSMate.Modules.HealingAndAbsorbs)


function DPSMate.Modules.HealingAndAbsorbs:GetSortedTable(arr, k)
	local b, a, total = {}, {}, 0
	local f, g, h = {}, {}, {}
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
							if cet~="info" then
								local p = 5
								if DPSMateDamageTaken[1][cat][cet][vel[1]]["hitaverage"]~=0 then
									p=ceil(DPSMateDamageTaken[1][cat][cet][vel[1]]["hitaverage"])
								end
								PerShieldAbsorb=PerShieldAbsorb+vel[2]*p
							end
						end
						if ve["info"][1]==1 then
							PerShieldAbsorb=PerShieldAbsorb+ve["info"][2]
						end
						PerAbilityAbsorb = PerAbilityAbsorb+PerShieldAbsorb
					end
					PerOwnerAbsorb = PerOwnerAbsorb+PerAbilityAbsorb
				end
				PerPlayerAbsorb = PerPlayerAbsorb+PerOwnerAbsorb
				b[ca] = PerOwnerAbsorb
			end
			total = total+PerPlayerAbsorb
		end
		
		-- Evaluate E Healing table
		local d, total2 = {}, 0
		local arr = DPSMate:GetModeByArr(DPSMateEHealing, k)
		for c, v in pairs(arr) do
			d[c] = v["info"][1]
			total2 = total2 + v["info"][1]
		end
		
		-- Merge tables
		total=total+total2
		for cat, val in pairs(b) do
			g[cat] = val
			if d[cat] then g[cat] = g[cat] + d[cat] end
		end
		for cat, val in pairs(d) do
			g[cat] = val
			if b[cat] then g[cat] = g[cat] + b[cat] end
		end
		for cat, val in pairs(g) do
			local i = 1
			while true do
				if (not f[i]) then
					table.insert(f, i, val)
					table.insert(h, i, cat)
					break
				else
					if f[i] < val then
						table.insert(f, i, val)
						table.insert(h, i, cat)
						break
					end
				end
				i=i+1
			end
		end
	end
	return f, total, h
end

function DPSMate.Modules.HealingAndAbsorbs:EvalTable(user, k)
	local b, total = {}, 0
	local temp = {}
	local arr = DPSMate:GetModeByArr(DPSMateAbsorbs, k)
	for cat, val in pairs(arr) do -- 28 Target
		for ca, va in pairs(val) do -- 28 Owner
			if ca==user["id"] then
				for c, v in pairs(va) do -- Power Word: Shield
					for ce, ve in pairs(v) do -- 1
						local PerShieldAbsorb = 0
						for cet, vel in pairs(ve) do
							if cet~="info" then
								local p = 5
								if DPSMateDamageTaken[1][cat][cet][vel[1]]["hitaverage"]~=0 then
									p=ceil(DPSMateDamageTaken[1][cat][cet][vel[1]]["hitaverage"])
								end
								PerShieldAbsorb=PerShieldAbsorb+vel[2]*p
							end
						end
						if ve["info"][1]==1 then
							PerShieldAbsorb=PerShieldAbsorb+ve["info"][2]
						end
						if b[c] then b[c]=b[c]+PerShieldAbsorb else b[c]=PerShieldAbsorb end
					end
				end
				break
			end
		end
	end
	
	-- Evaluate E Healing table
	local d = {}
	local arr = DPSMate:GetModeByArr(DPSMateEHealing, k)
	if arr[user["id"]] then
		for c, v in pairs(arr[user["id"]]) do
			if c~="info" then
				for ca, va in pairs(v) do
					if d[c] then d[c]=d[c]+va[1] else d[c]=va[1] end
				end
			end
		end
	end
	
	-- Merge tables
	local f, h = {}, {}
	for cat, val in pairs(d) do
		local i = 1
		while true do
			if (not f[i]) then
				table.insert(f, i, val)
				table.insert(h, i, cat)
				break
			else
				if f[i] < val then
					table.insert(f, i, val)
					table.insert(h, i, cat)
					break
				end
			end
			i=i+1
		end
	end

	for cat, val in pairs(b) do
		local i = 1
		while true do
			if (not f[i]) then
				table.insert(f, i, val)
				table.insert(h, i, cat)
				break
			else
				if f[i] < val then
					table.insert(f, i, val)
					table.insert(h, i, cat)
					break
				end
			end
			i=i+1
		end
	end
	
	return f, total, h
end

function DPSMate.Modules.HealingAndAbsorbs:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.HealingAndAbsorbs:GetSortedTable(arr, k)
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

function DPSMate.Modules.HealingAndAbsorbs:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.HealingAndAbsorbs:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..c[i],a[i],1,1,1,1,1,1)
		end
	end
end


