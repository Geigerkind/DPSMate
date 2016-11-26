-- Global Variables
DPSMate.Modules.CCBreaker = {}
DPSMate.Modules.CCBreaker.Hist = "CCBreaker"
DPSMate.Options.Options[1]["args"]["ccbreaker"] = {
	order = 310,
	type = 'toggle',
	name = DPSMate.L["ccbreaker"],
	desc = DPSMate.L["show"].." "..DPSMate.L["ccbreaker"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["ccbreaker"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "ccbreaker", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("ccbreaker", DPSMate.Modules.CCBreaker, DPSMate.L["ccbreaker"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.CCBreaker:GetSortedTable(arr, k)
	local b, a, total = {}, {}, 0
	for cat, val in arr do
		local name = DPSMate:GetUserById(cat)
		local amount = DPSMate:TableLength(val)
		local i = 1
		while true do
			if (not b[i]) then
				tinsert(b, i, amount)
				tinsert(a, i, name)
				break
			else
				if b[i] < amount then
					tinsert(b, i, amount)
					tinsert(a, i, name)
					break
				end
			end
			i=i+1
		end
		total = total + amount
	end
	return b, total, a
end

function DPSMate.Modules.CCBreaker:EvalTable(user, k)
	local a, b, total = {}, {}, 0
	local temp = {}
	local arr = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	for _, v in arr[user[1]] do
		if temp[v[1]] then temp[v[1]] = temp[v[1]] + 1 else temp[v[1]] = 1 end
		total=total+1
	end
	for cat, val in temp do
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
	end
	return a, total, b
end

function DPSMate.Modules.CCBreaker:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	
	sortedTable, total, a = DPSMate.Modules.CCBreaker:GetSortedTable(arr, k)
	for cat, val in sortedTable do
		local dmg, tot, sort = val, total, sortedTable[1]
		if dmg==0 then break end;
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsccbreaker"][1] then str[1] = " "..DPSMate:Commas(dmg, k)..p; strt[2] = DPSMate:Commas(tot, k)..p end
		if DPSMateSettings["columnsccbreaker"][2] then str[3] = " ("..strformat("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, a[cat])
		tinsert(value, str[2]..str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.CCBreaker:ShowTooltip(user,k)
	local a,b,c = self:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i].." ("..strformat("%.2f", 100*c[i]/b).."%)",1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.CCBreaker:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsCCBreaker:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsCCBreaker:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.CCBreaker:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsCCBreakerTotal:UpdateDetails(obj, key)
end
