-- Global Variables
DPSMate.Modules.Interrupts = {}
DPSMate.Modules.Interrupts.Hist = "Interrupts"
DPSMate.Options.Options[1]["args"]["interrupts"] = {
	order = 160,
	type = 'toggle',
	name = DPSMate.L["interrupts"],
	desc = DPSMate.L["show"].." "..DPSMate.L["interrupts"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["interrupts"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "interrupts", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("interrupts", DPSMate.Modules.Interrupts, DPSMate.L["interrupts"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.Interrupts:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do -- 1 Owner
		local name = DPSMate:GetUserById(cat)
		if (not DPSMateUser[name][4] or (DPSMateUser[name][4] and not DPSMateSettings["mergepets"])) then
			if DPSMate:ApplyFilter(k, name) then
				local CV = val["i"][1]
				if DPSMate:PlayerExist(DPSMateUser, DPSMateUser[name][5]) and arr[DPSMateUser[DPSMateUser[name][5]][1]] then
					CV=CV+arr[DPSMateUser[DPSMateUser[name][5]][1]]["i"][1]
				end
				local i = 1
				while true do
					if (not b[i]) then
						tinsert(b, i, val["i"][1])
						tinsert(a, i, cat)
						break
					else
						if b[i] < val["i"][1] then
							tinsert(b, i, val["i"][1])
							tinsert(a, i, cat)
							break
						end
					end
					i=i+1
				end
				total = total + val["i"][1]
			end
		end
	end
	return b, total, a
end

function DPSMate.Modules.Interrupts:EvalTable(user, k)
	local a, b, total, pet, u = {}, {}, 0, false, {}
	local arr = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	if (user[5] and user[5] ~= DPSMate.L["unknown"] and arr[DPSMateUser[user[5]][1]]) and DPSMateSettings["mergepets"] then u={user[1],DPSMateUser[user[5]][1]} else u={user[1]} end
	for _, vvv in pairs(u) do
		for cat, val in pairs(arr[vvv]) do -- 41 Ability
			if cat~="i" then
				local CV = 0
				local d,e = {}, {}
				if (DPSMateUser[DPSMate:GetUserById(vvv)][4]) then pet=true; else pet=false; end
				for ca, va in pairs(val) do
					local CVV = 0
					for c, v in pairs(va) do
						CV = CV + v
						CVV = CVV + v
					end
					local i = 1
					while true do
						if (not d[i]) then
							tinsert(d, i, CVV)
							tinsert(e, i, ca)
							break
						else
							if d[i] < CVV then
								tinsert(d, i, CVV)
								tinsert(e, i, ca)
								break
							end
						end
						i=i+1
					end
				end
				if CV>0 then
					local i = 1
					while true do
						if (not b[i]) then
							tinsert(b, i, {CV, e, d})
							tinsert(a, i, {cat, pet})
							break
						else
							if b[i][1] < CV then
								tinsert(b, i, {CV, e, d})
								tinsert(a, i, {cat, pet})
								break
							end
						end
						i=i+1
					end
				end
			end
		end
		total = total + arr[vvv]["i"][1]
	end
	return a, total, b
end

function DPSMate.Modules.Interrupts:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	
	sortedTable, total, a = DPSMate.Modules.Interrupts:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = val, total, sortedTable[1]
		if dmg==0 then break end;
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsinterrupts"][1] then str[1] = " "..DPSMate:Commas(dmg, k)..p; strt[2] = DPSMate:Commas(tot, k)..p end
		if DPSMateSettings["columnsinterrupts"][2] then str[3] = " ("..strformat("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, DPSMate:GetUserById(a[cat]))
		tinsert(value, str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Interrupts:ShowTooltip(user,k)
	local a,b,c = DPSMate.Modules.Interrupts:EvalTable(DPSMateUser[user], k)
	local pet = ""
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			if a[i][2] then pet="(Pet)" else pet="" end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i][1])..pet,c[i][1].." ("..strformat("%.2f", 100*c[i][1]/b).."%)",1,1,1,1,1,1)
			for p=1, 3 do
				if not c[i][2][p] or c[i][3][p]==0 then break end
				GameTooltip:AddDoubleLine("       "..p..". "..DPSMate:GetUserById(c[i][2][p]),c[i][3][p].." ("..strformat("%.2f", 100*c[i][3][p]/c[i][1]).."%)",0.5,0.5,0.5,0.5,0.5,0.5)
			end
		end
	end
end

function DPSMate.Modules.Interrupts:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsInterrupts:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsInterrupts:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.Interrupts:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsInterruptsTotal:UpdateDetails(obj, key)
end

