-- Global Variables
DPSMate.Modules.Decurses = {}
DPSMate.Modules.Decurses.Hist = "Dispels"
DPSMate.Options.Options[1]["args"]["decurses"] = {
	order = 195,
	type = 'toggle',
	name = DPSMate.L["decurses"],
	desc = DPSMate.L["show"].." "..DPSMate.L["decurses"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["decurses"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "decurses", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("decurses", DPSMate.Modules.Decurses, DPSMate.L["decurses"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.Decurses:IsValid(ab, cast, user)
	if DPSMateAbility[ab][2]==DPSMate.L["curse"] or user[2] == "mage" or (DPSMate.Parser.DeCurse[cast] and not DPSMateAbility[ab][2]) or (DPSMate.Parser.DeCurse[cast] and DPSMateAbility[ab][2] and DPSMateAbility[ab][2]==DPSMate.L["curse"]) then
		return true
	end
	return false
end

function DPSMate.Modules.Decurses:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do -- 3 Owner
		local user = DPSMate:GetUserById(cat)
		if DPSMate:ApplyFilter(k, user) then
			local CV = 0
			for ca, va in pairs(val) do -- 42 Ability
				if ca~="i" then
					for c, v in pairs(va) do -- 3 Target
						for ce, ve in pairs(v) do -- 10 Cured Ability
							if self:IsValid(DPSMate:GetAbilityById(ce), DPSMate:GetAbilityById(ca), DPSMateUser[user]) then
								CV=CV+ve
							end
						end
					end
				end
			end
			local i = 1
			while true do
				if (not b[i]) then
					tinsert(b, i, CV)
					tinsert(a, i, cat)
					break
				else
					if b[i] < CV then
						tinsert(b, i, CV)
						tinsert(a, i, cat)
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

function DPSMate.Modules.Decurses:EvalTable(user, k)
	local a, b, total, temp = {}, {}, 0, {}
	local arr = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	for cat, val in pairs(arr[user[1]]) do -- 41 Ability
		if cat~="i" then
			for ca, va in pairs(val) do -- 3 Target
				for c, v in pairs(va) do -- 10 Cured Ability
					if self:IsValid(DPSMate:GetAbilityById(c), DPSMate:GetAbilityById(cat), user) then
						if temp[c] then temp[c]=temp[c]+v else temp[c]=v end
					end
				end
			end
		end
	end
	for cat, val in pairs(temp) do
		local i = 1
		while true do
			if (not b[i]) then
				tinsert(b, i, val)
				tinsert(a, i, cat)
				break
			else
				if b[i] < val then
					tinsert(b, i, val)
					tinsert(a, i, cat)
					break
				end
			end
			i=i+1
		end
		total=total+val
	end
	return a, total, b
end

function DPSMate.Modules.Decurses:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	
	sortedTable, total, a = DPSMate.Modules.Decurses:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = val, total, sortedTable[1]
		if dmg==0 then break end;
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsdecurses"][1] then str[1] = " "..DPSMate:Commas(dmg, k)..p; strt[2] = DPSMate:Commas(tot, k)..p end
		if DPSMateSettings["columnsdecurses"][2] then str[3] = " ("..strformat("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, DPSMate:GetUserById(a[cat]))
		tinsert(value, str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Decurses:ShowTooltip(user,k)
	local a,b,c = DPSMate.Modules.Decurses:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i].." ("..strformat("%.2f", 100*c[i]/b).."%)",1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.Decurses:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsDecurses:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsDecurses:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.Decurses:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsDecursesTotal:UpdateDetails(obj, key)
end

