-- Global Variables
DPSMate.Modules.HealingAndAbsorbs = {}
DPSMate.Modules.HealingAndAbsorbs.Hist = "Absorbs"
DPSMate.Options.Options[1]["args"]["healingandabsorbs"] = {
	order = 130,
	type = 'toggle',
	name = DPSMate.L["healingandabsorbs"],
	desc = DPSMate.L["show"].." "..DPSMate.L["healingandabsorbs"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["healingandabsorbs"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "healingandabsorbs", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("healingandabsorbs", DPSMate.Modules.HealingAndAbsorbs, DPSMate.L["healingandabsorbs"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.HealingAndAbsorbs:GetSortedTable(arr, k)
	local b, a, total = {}, {}, 0
	local f, g, h = {}, {}, {}
	local temp = {}
	if arr then
		for cat, val in pairs(arr) do -- 28 Target
			local PerPlayerAbsorb = 0
			for ca, va in pairs(val) do -- 28 Owner
				local ownername = DPSMate:GetUserById(ca)
				if DPSMate:ApplyFilter(k, ownername) then
					local PerOwnerAbsorb = 0
					for c, v in pairs(va) do -- Power Word: Shield
						if c~="i" then
							local shieldname = DPSMate:GetAbilityById(c)
							local PerAbilityAbsorb = 0
							for ce, ve in pairs(v) do -- 1
								local PerShieldAbsorb = 0
								for cet, vel in pairs(ve) do
									if cet~="i" then
										local totalHits = 0
										for qq,ss in vel do
											totalHits = totalHits + ss
										end
										for qq,ss in vel do
											local p = 5
											if DPSMateDamageTaken[1][cat] then
												if DPSMateDamageTaken[1][cat][cet] then
													if DPSMateDamageTaken[1][cat][cet][qq] then
														if DPSMateDamageTaken[1][cat][cet][qq][14]~=0 then
															p=ceil(DPSMateDamageTaken[1][cat][cet][qq][14])
														end
													end
												end
											elseif DPSMateEDT[1][cat] then
												if DPSMateEDT[1][cat][cet] then
													if DPSMateEDT[1][cat][cet][qq] then
														if DPSMateEDT[1][cat][cet][qq][4]~=0 then
															p=ceil((DPSMateEDT[1][cat][cet][qq][4]+DPSMateEDT[1][cat][cet][qq][8])/2)
														end
													end
												end
											end
											if p>DPSMate.DB.FixedShieldAmounts[shieldname] then
												p = DPSMate.DB.FixedShieldAmounts[shieldname]
											end
											if p==5 or p==0 then
												p = ceil((1/totalHits)*((DPSMateUser[ownername][8] or 60)/60)*DPSMate.DB.FixedShieldAmounts[shieldname]*0.33)
											end
											PerShieldAbsorb=PerShieldAbsorb+ss*p
										end
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
					if b[ca] then
						b[ca] = b[ca] + PerOwnerAbsorb
					else
						b[ca] = PerOwnerAbsorb
					end
				end
			end
			total = total+PerPlayerAbsorb
		end
		
		-- Evaluate E Healing table
		local d, total2 = {}, 0
		local arr = DPSMate:GetModeByArr(DPSMateEHealing, k)
		for c, v in pairs(arr) do
			if DPSMate:ApplyFilter(k, DPSMate:GetUserById(c)) then
				d[c] = v["i"]
				total2 = total2 + v["i"]
			end
		end
		
		-- Merge tables
		total=total+total2
		for cat, val in b do
			g[cat] = val
			--if d[cat] then g[cat] = g[cat] + d[cat] end
		end
		for cat, val in d do
			if g[cat] then
				g[cat] = g[cat] + val
			else
				g[cat] = val
			end
			--if b[cat] then g[cat] = g[cat] + b[cat] end
		end
		for cat, val in g do
			local i = 1
			while true do
				if (not f[i]) then
					tinsert(f, i, val)
					tinsert(h, i, cat)
					break
				else
					if f[i] < val then
						tinsert(f, i, val)
						tinsert(h, i, cat)
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
	local ownername = DPSMate:GetUserById(user[1])
	for cat, val in pairs(arr) do -- 28 Target
		for ca, va in pairs(val) do -- 28 Owner
			if ca==user[1] then
				for c, v in pairs(va) do -- Power Word: Shield
					if c~="i" then
						local shieldname = DPSMate:GetAbilityById(c)
						for ce, ve in pairs(v) do -- 1
							local PerShieldAbsorb = 0
							for cet, vel in pairs(ve) do
								if cet~="i" then
									local totalHits = 0
									for qq,ss in vel do
										totalHits = totalHits + ss
									end
									for qq,ss in vel do
										local p = 5
										if DPSMateDamageTaken[1][cat] then
											if DPSMateDamageTaken[1][cat][cet] then
												if DPSMateDamageTaken[1][cat][cet][qq] then
													if DPSMateDamageTaken[1][cat][cet][qq][14]~=0 then
														p=ceil(DPSMateDamageTaken[1][cat][cet][qq][14])
													end
												end
											end
										elseif DPSMateEDT[1][cat] then
											if DPSMateEDT[1][cat][cet] then
												if DPSMateEDT[1][cat][cet][qq] then
													if DPSMateEDT[1][cat][cet][qq][4]~=0 then
														p=ceil((DPSMateEDT[1][cat][cet][qq][4]+DPSMateEDT[1][cat][cet][qq][8])/2)
													end
												end
											end
										end
										if p>DPSMate.DB.FixedShieldAmounts[shieldname] then
											p = DPSMate.DB.FixedShieldAmounts[shieldname]
										end
										if p==5 or p==0 then
											p = ceil((1/totalHits)*((DPSMateUser[ownername][8] or 60)/60)*DPSMate.DB.FixedShieldAmounts[shieldname]*0.33)
										end
										PerShieldAbsorb=PerShieldAbsorb+ss*p
										if not temp[cet] then temp[cet] = {} end
										if not temp[cet][qq] then temp[cet][qq] = ss*p else temp[cet][qq] =temp[cet][qq]+ss*p end
									end
								end
							end
							if ve["i"][1]==1 then
								PerShieldAbsorb=PerShieldAbsorb+ve["i"][2]
							end
							if b[c] then b[c]=b[c]+PerShieldAbsorb else b[c]=PerShieldAbsorb end
						end
					end
				end
				break
			end
		end
	end
	
	-- Evaluate E Healing table
	local d = {}
	local arr = DPSMate:GetModeByArr(DPSMateEHealing, k)
	if arr[user[1]] then
		for c, v in pairs(arr[user[1]]) do
			if c~="i" then
				if d[c] then d[c]=d[c]+v[1] else d[c]=v[1] end
			end
		end
	end
	
	-- Merge tables
	local f, h = {}, {}
	for cat, val in pairs(d) do
		local i = 1
		while true do
			if (not f[i]) then
				tinsert(f, i, {val, false})
				tinsert(h, i, cat)
				break
			else
				if f[i][1] < val then
					tinsert(f, i, {val, false})
					tinsert(h, i, cat)
					break
				end
			end
			i=i+1
		end
		total=total+val
	end

	for cat, val in pairs(b) do
		local i = 1
		while true do
			if (not f[i]) then
				tinsert(f, i, {val, true})
				tinsert(h, i, cat)
				break
			else
				if f[i][1] < val then
					tinsert(f, i, {val, true})
					tinsert(h, i, cat)
					break
				end
			end
			i=i+1
		end
		total=total+val
	end
	return h, total, f
end

function DPSMate.Modules.HealingAndAbsorbs:GetSettingValues(arr, cbt, k,ecbt)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 or DPSMateSettings["windows"][k]["numberformat"] == 4 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.HealingAndAbsorbs:GetSortedTable(arr, k)
	for cat, val in pairs(sortedTable) do
		local va, tot, sort, varea, totr, sortr = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if varea==0 then break end; if varea<=10000 then p = "" end
		local str = {[1]="",[2]="",[3]="",[4]=""}
		local pname = DPSMate:GetUserById(a[cat])
		if DPSMateSettings["columnshab"][1] then str[1] = " "..DPSMate:Commas(va, k)..p; strt[2] = DPSMate:Commas(tot, k)..p end
		if DPSMateSettings["columnshab"][3] then str[2] = " ("..strformat("%.1f", 100*varea/totr).."%)" end
		if DPSMateSettings["columnshab"][2] then str[3] = "("..strformat("%.1f", va/cbt)..")"; strt[1] = "("..strformat("%.1f", tot/cbt)..")" end
		if DPSMateSettings["columnshab"][4] then str[4] = " ("..strformat("%.1f", va/(ecbt[pname] or cbt))..p..")" end
		tinsert(name, pname)
		tinsert(value, str[3]..str[1]..str[4]..str[2])
		tinsert(perc, 100*(varea/sortr))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.HealingAndAbsorbs:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.HealingAndAbsorbs:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i][1].." ("..strformat("%.2f", 100*c[i][1]/b).."%)",1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.HealingAndAbsorbs:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsHealingAndAbsorbs:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsHealingAndAbsorbs:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.HealingAndAbsorbs:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsHABTotal:UpdateDetails(obj, key)
end


