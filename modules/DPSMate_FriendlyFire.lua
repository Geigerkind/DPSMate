-- Global Variables
DPSMate.Modules.FriendlyFire = {}
DPSMate.Modules.FriendlyFire.Hist = "EDTaken"
DPSMate.Options.Options[1]["args"]["friendlyfire"] = {
	order = 260,
	type = 'toggle',
	name = DPSMate.L["friendlyfire"],
	desc = DPSMate.L["show"].." "..DPSMate.L["friendlyfire"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["friendlyfire"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "friendlyfire", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("friendlyfire", DPSMate.Modules.FriendlyFire, DPSMate.L["friendlyfire"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.FriendlyFire:GetSortedTable(arr,k)
	local b, a, total, temp = {}, {}, 0, {}
	for c, v in pairs(arr) do
		local cName = DPSMate:GetUserById(c)
		for cat, val in pairs(v) do
			local catName = DPSMate:GetUserById(cat)
			if DPSMate:ApplyFilter(k, catName) and  DPSMateUser[catName] and  DPSMateUser[cName] then
				--DPSMate:SendMessage(catName.." and "..cName)
				--DPSMate:SendMessage((DPSMateUser[cName][3] or "").." and "..(DPSMateUser[catName][3] or ""))
				if DPSMateUser[cName][3] == DPSMateUser[catName][3] and DPSMateUser[catName][3] and DPSMateUser[cName][3] then
					if temp[cat] then temp[cat]=temp[cat]+val["i"] else temp[cat] = val["i"] end
				end
			end
		end
	end
	for cat, val in pairs(temp) do
		--DPSMate:SendMessage(val)
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
	return b, total, a
end

function DPSMate.Modules.FriendlyFire:EvalTable(user, k)
	local a, d, total, temp = {}, {}, 0, {}
	local arr = DPSMate:GetMode(k)
	for c, v in pairs(arr) do
		local cName = DPSMate:GetUserById(c)
		if v[user[1]] and DPSMateUser[cName][3] == user[3] and DPSMateUser[cName][3] then
			for cat, val in v[user[1]] do
				if cat~="i" then
					if temp[c] then 
						temp[c][1]=temp[c][1]+val[13]
						local i = 1
						while true do
							if (not temp[c][3][i]) then
								tinsert(temp[c][3], i, val[13])
								tinsert(temp[c][2], i, cat)
								break
							else
								if temp[c][3][i] < val[13] then
									tinsert(temp[c][3], i, val[13])
									tinsert(temp[c][2], i, cat)
									break
								end
							end
							i=i+1
						end
					else 
						temp[c] = {val[13], {[1]=cat}, {[1]=val[13]}}	
					end
				end
			end
		end
	end
	for cat, val in pairs(temp) do
		if val~=0 then
			local i = 1
			while true do
				if (not d[i]) then
					tinsert(d, i, val)
					tinsert(a, i, cat)
					break
				else
					if d[i][1] < val[1] then
						tinsert(d, i, val)
						tinsert(a, i, cat)
						break
					end
				end
				i=i+1
			end
			total = total + val[1]
		end
	end
	return a, total, d
end

function DPSMate.Modules.FriendlyFire:GetSettingValues(arr, cbt, k,ecbt)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 or DPSMateSettings["windows"][k]["numberformat"] == 4 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.FriendlyFire:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort, dmgr, totr, sortr = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmgr==0 then break end; if dmgr<=10000 then p = "" end
		local str = {[1]="",[2]="",[3]="",[4]=""}
		local pname = DPSMate:GetUserById(a[cat])
		if DPSMateSettings["columnsfriendlyfire"][1] then str[1] = " "..DPSMate:Commas(dmg, k)..p; strt[2] = DPSMate:Commas(tot, k)..p end
		if DPSMateSettings["columnsfriendlyfire"][3] then str[2] = " ("..strformat("%.1f", 100*dmgr/totr).."%)" end
		if DPSMateSettings["columnsfriendlyfire"][2] then str[3] = "("..strformat("%.1f", dmg/cbt)..")"; strt[1] = "("..strformat("%.1f", tot/cbt)..")" end
		if DPSMateSettings["columnsfriendlyfire"][4] then str[4] = " ("..strformat("%.1f", dmg/(ecbt[pname] or cbt))..p..")" end
		tinsert(name, pname)
		tinsert(value, str[3]..str[1]..str[4]..str[2])
		tinsert(perc, 100*(dmgr/sortr))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.FriendlyFire:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.FriendlyFire:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(a[i]),c[i][1].." ("..strformat("%.2f", 100*c[i][1]/b).."%)",1,1,1,1,1,1)
			for p=1, 3 do 
				if not c[i][2][p] or c[i][3][p]==0 then break end
				GameTooltip:AddDoubleLine("       "..p..". "..DPSMate:GetAbilityById(c[i][2][p]),c[i][3][p].." ("..strformat("%.2f", 100*c[i][3][p]/c[i][1]).."%)",0.5,0.5,0.5,0.5,0.5,0.5)
			end
		end
	end
end

function DPSMate.Modules.FriendlyFire:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsFF:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsFF:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.FriendlyFire:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsFFTotal:UpdateDetails(obj, key)
end

