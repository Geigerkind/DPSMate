-- Global Variables
DPSMate.Modules.Casts = {}
DPSMate.Modules.Casts.Hist = "EDTaken"
DPSMate.Options.Options[1]["args"]["casts"] = {
	order = 270,
	type = 'toggle',
	name = DPSMate.L["casts"],
	desc = DPSMate.L["show"].." "..DPSMate.L["casts"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["casts"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "casts", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("casts", DPSMate.Modules.Casts, DPSMate.L["casts"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.Casts:GetSortedTable(arr, k)
	local b, a, total = {}, {}, 0
	local temp = {}
	for cat, val in arr do
		for c, v in val do
			local CV = 0
			for ca, va in v do
				if ca~="i" then
					local abna = DPSMate:GetAbilityById(ca)
					if abna~=DPSMate.L["AutoAttack"] and abna~=DPSMate.L["AutoShot"] then
						CV = CV + va[1] + va[5] + va[9] + va[10] + va[11] + va[12] + va[14] + va[18]
					end
				end
			end
			if temp[c] then temp[c] = temp[c] + CV else temp[c] = CV end
		end
	end
	for cat, val in temp do
		if val > 0 then
			local name = DPSMate:GetUserById(cat)
			local i = 1
			while true do
				if (not b[i]) then
					tinsert(b, i, val)
					tinsert(a, i, name)
					break
				else
					if b[i] < val then
						tinsert(b, i, val)
						tinsert(a, i, name)
						break
					end
				end
				i=i+1
			end
			total = total + val
		end
	end
	return b, total, a
end

function DPSMate.Modules.Casts:EvalTable(user, k)
	local b, a, total = {}, {}, 0
	local temp = {}
	local arr = DPSMate:GetMode(k)
	for c, v in arr do
		if v[user[1]] then
			for ca, va in v[user[1]] do
				if ca~="i" then
					local CV = va[1] + va[5] + va[9] + va[10] + va[11] + va[12] + va[14] + va[18]
					if temp[ca] then temp[ca] = temp[ca] + CV else temp[ca] = CV end
				end
			end
		end
	end
	for cat, val in temp do
		if (not DPSMateAbility[DPSMate.L["AutoAttack"]] or cat~=DPSMateAbility[DPSMate.L["AutoAttack"]][1]) and (not DPSMateAbility[DPSMate.L["AutoShot"]] or cat~=DPSMateAbility[DPSMate.L["AutoShot"]][1]) then
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
			total = total + val
		end
	end
	return b, total, a
end

function DPSMate.Modules.Casts:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	
	sortedTable, total, a = DPSMate.Modules.Casts:GetSortedTable(arr, k)
	for cat, val in sortedTable do
		local dmg, tot, sort = val, total, sortedTable[1]
		if dmg==0 then break end;
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnscasts"][1] then str[1] = " "..DPSMate:Commas(dmg, k)..p; strt[2] = DPSMate:Commas(tot, k)..p end
		if DPSMateSettings["columnscasts"][2] then str[3] = " ("..strformat("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, a[cat])
		tinsert(value, str[2]..str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Casts:ShowTooltip(user,k)
	local a,b,c = DPSMate.Modules.Casts:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not c[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(c[i]),a[i].." ("..strformat("%.2f", 100*a[i]/b).."%)",1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.Casts:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsCasts:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsCasts:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.Casts:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsCastsTotal:UpdateDetails(obj, key)
end
