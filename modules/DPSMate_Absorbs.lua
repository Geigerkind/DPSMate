-- Global Variables
DPSMate.Modules.Absorbs = {}
DPSMate.Modules.Absorbs.Hist = "Absorbs"
DPSMate.Options.Options[1]["args"]["absorbs"] = {
	order = 110,
	type = 'toggle',
	name = 'Absorbs',
	desc = "Show Absorbs.",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["absorbs"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "absorbs", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("absorbs", DPSMate.Modules.Absorbs, "Absorbs")


function DPSMate.Modules.Absorbs:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	local temp = {}
	for cat, val in pairs(arr) do -- 28 Target
		local PerPlayerAbsorb = 0
		for ca, va in pairs(val) do -- 28 Owner
			if DPSMate:ApplyFilter(k, DPSMate:GetUserById(ca)) then
				local PerOwnerAbsorb = 0
				for c, v in pairs(va) do -- Power Word: Shield
					if c~="i" then
						local PerAbilityAbsorb = 0
						for ce, ve in pairs(v) do -- 1
							local PerShieldAbsorb = 0
							for cet, vel in pairs(ve) do
								if cet~="i" then
									local p = 5
									if DPSMateDamageTaken[1][cat] then
										if DPSMateDamageTaken[1][cat][cet] then
											if DPSMateDamageTaken[1][cat][cet][vel[1]][14]~=0 then
												p=ceil(DPSMateDamageTaken[1][cat][cet][vel[1]][14])
											end
										end
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
				if not temp[ca] then temp[ca] = PerOwnerAbsorb else temp[ca]=temp[ca]+PerOwnerAbsorb end
				PerPlayerAbsorb = PerPlayerAbsorb+PerOwnerAbsorb
			end
		end
		total = total+PerPlayerAbsorb
	end
	for cat, val in pairs(temp) do
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
	end
	return b, total, a
end

function DPSMate.Modules.Absorbs:EvalTable(user, k)
	local arr = DPSMate:GetMode(k)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do -- 28 Target
		local ta, td, CV = {}, {}, 0
		for ca, va in pairs(val) do -- 28 Owner
			if ca==user[1] then
				for c, v in pairs(va) do -- Power Word: Shield
					if c~="i" then
						local PerAbilityAbsorb, temp, taa, tdd = 0, {}, {}, {}
						for ce, ve in pairs(v) do -- 1
							local PerShieldAbsorb = 0
							for cet, vel in pairs(ve) do
								if cet~="i" then
									local p = 5
									if DPSMateDamageTaken[1][cat][cet][vel[1]][14]~=0 then
										p=ceil(DPSMateDamageTaken[1][cat][cet][vel[1]][14])
									end
									PerShieldAbsorb=PerShieldAbsorb+vel[2]*p
									if not temp[cet] then temp[cet] = {} end
									if not temp[cet][vel[1]] then temp[cet][vel[1]] = vel[2]*p else temp[cet][vel[1]] =temp[cet][vel[1]]+vel[2]*p end
								end
							end
							if ve["i"][1]==1 then
								PerShieldAbsorb=PerShieldAbsorb+ve["i"][2]
								if not temp[ve["i"][4]] then temp[ve["i"][4]] = {} end
								if not temp[ve["i"][4]][ve["i"][3]] then temp[ve["i"][4]][ve["i"][3]] = ve["i"][2] else temp[ve["i"][4]][ve["i"][3]] = temp[ve["i"][4]][ve["i"][3]] + ve["i"][2] end
							end
							PerAbilityAbsorb = PerAbilityAbsorb+PerShieldAbsorb
						end
						for ut, utt in temp do
							local CVV, qa, qd = 0, {}, {}
							for qt, qtt in utt do
								CVV = CVV + qtt
								local i = 1
								while true do
									if (not qd[i]) then
										table.insert(qd, i, qtt)
										table.insert(qa, i, qt)
										break
									else
										if qd[i] < qtt then
											table.insert(qd, i, qtt)
											table.insert(qa, i, qt)
											break
										end
									end
									i=i+1
								end
							end
							local i = 1
							while true do
								if (not tdd[i]) then
									table.insert(tdd, i, {CVV, qa, qd})
									table.insert(taa, i, ut)
									break
								else
									if tdd[i][1] < CVV then
										table.insert(tdd, i, {CVV, qa, qd})
										table.insert(taa, i, ut)
										break
									end
								end
								i=i+1
							end
						end
						local i = 1
						while true do
							if (not td[i]) then
								table.insert(td, i, {PerAbilityAbsorb, taa, tdd})
								table.insert(ta, i, c)
								break
							else
								if td[i][1] < PerAbilityAbsorb then
									table.insert(td, i, {PerAbilityAbsorb, taa, tdd})
									table.insert(ta, i, c)
									break
								end
							end
							i=i+1
						end
						CV = CV + PerAbilityAbsorb
					end
				end
				break
			end
		end
		if CV>0 then
			local i = 1
			while true do
				if (not b[i]) then
					table.insert(b, i, {CV,ta,td})
					table.insert(a, i, cat)
					break
				else
					if b[i][1] < CV then
						table.insert(b, i, {CV,ta,td})
						table.insert(a, i, cat)
						break
					end
				end
				i=i+1
			end
			total = total + CV
		end
	end
	return a, total, b
end

function DPSMate.Modules.Absorbs:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.Absorbs:GetSortedTable(arr, k)
	for cat, val in pairs(sortedTable) do
		local va, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if va==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsabsorbs"][1] then str[1] = " "..va..p; strt[2] = " "..tot..p end
		if DPSMateSettings["columnsabsorbs"][2] then str[2] = " ("..string.format("%.1f", 100*va/tot).."%)" end
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
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(a[i]),c[i][1].." ("..string.format("%2.f", 100*c[i][1]/b).."%)",1,1,1,1,1,1)
			for p=1, 3 do
				if not c[i][2][p] then break end
				GameTooltip:AddDoubleLine("      "..p..". "..DPSMate:GetAbilityById(c[i][2][p]),c[i][3][p][1].." ("..string.format("%.2f", 100*c[i][3][p][1]/c[i][1]).."%)",0.5,0.5,0.5,0.5,0.5,0.5)
			end
		end
	end
end

function DPSMate.Modules.Absorbs:OpenDetails(obj, key)
	DPSMate.Modules.DetailsAbsorbs:UpdateDetails(obj, key)
end

function DPSMate.Modules.Absorbs:OpenTotalDetails(obj, key)
	--DPSMate.Modules.DetailsDamageTotal:UpdateDetails(obj, key)
	DPSMate:SendMessage("This feature will be added soon!")
end


