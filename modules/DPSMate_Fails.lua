-- Global Variables
DPSMate.Modules.Fails = {}
DPSMate.Modules.Fails.Hist = "Fails"
DPSMate.Options.Options[1]["args"]["fails"] = {
	order = 300,
	type = 'toggle',
	name = DPSMate.L["fails"],
	desc = DPSMate.L["show"].." "..DPSMate.L["fails"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["fails"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "fails", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("fails", DPSMate.Modules.Fails, DPSMate.L["fails"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.Fails:GetSortedTable(arr, k)
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

function DPSMate.Modules.Fails:EvalTable(user, k)
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

function DPSMate.Modules.Fails:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	
	sortedTable, total, a = DPSMate.Modules.Fails:GetSortedTable(arr, k)
	for cat, val in sortedTable do
		local dmg, tot, sort = val, total, sortedTable[1]
		if dmg==0 then break end;
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsfails"][1] then str[1] = " "..DPSMate:Commas(dmg, k)..p; strt[2] = DPSMate:Commas(tot, k)..p end
		if DPSMateSettings["columnsfails"][2] then str[3] = " ("..strformat("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, a[cat])
		tinsert(value, str[2]..str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Fails:Type(id)
	if id == 1 then
		return DPSMate.L["friendlyfire"]
	elseif id == 2 then
		return DPSMate.L["damagetaken"]
	end
	return DPSMate.L["debufftaken"]
end

function DPSMate.Modules.Fails:ShowTooltip(user,k)
	local a,b,c = self:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..self:Type(a[i]),c[i].." ("..strformat("%.2f", 100*c[i]/b).."%)",1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.Fails:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsFails:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsFails:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.Fails:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsFailsTotal:UpdateDetails(obj, key)
end
