-- Global Variables
DPSMate.Modules.DTPS = {}
DPSMate.Modules.DTPS.Hist = "DMGTaken"
DPSMate.Options.Options[1]["args"]["dtps"] = {
	order = 35,
	type = 'toggle',
	name = DPSMate.L["dtps"],
	desc = DPSMate.L["show"].." "..DPSMate.L["dtps"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["dtps"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "dtps", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("dtps", DPSMate.Modules.DTPS, DPSMate.L["dtps"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.DTPS:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	for c, v in pairs(arr) do
		if DPSMate:ApplyFilter(k, DPSMate:GetUserById(c)) then
			local i = 1
			while true do
				if (not b[i]) then
					tinsert(b, i, v["i"])
					tinsert(a, i, c)
					break
				else
					if b[i] < v["i"] then
						tinsert(b, i, v["i"])
						tinsert(a, i, c)
						break
					end
				end
				i=i+1
			end
			total = total + v["i"]
		end
	end
	return b, total, a
end

function DPSMate.Modules.DTPS:EvalTable(user, k, cbt)
	local a, d = {}, {}
	local arr, cbet = DPSMate:GetMode(k)
	cbt = cbt or cbet
	if not arr[user[1]] then return end
	for cat, val in pairs(arr[user[1]]) do
		if cat~="i" then
			local ta, tb, CV = {}, {}, 0
			for ca, va in pairs(val) do
				if ca~="i" then
					CV = CV + va[13]
					local i = 1
					while true do
						if (not tb[i]) then
							tinsert(ta, i, ca)
							tinsert(tb, i, va[13]/cbt)
							break
						else
							if (tb[i] < va[13]/cbt) then
								tinsert(ta, i, ca)
								tinsert(tb, i, va[13]/cbt)
								break
							end
						end
						i = i + 1
					end
				end
			end
			local i = 1
			while true do
				if (not d[i]) then
					tinsert(a, i, cat)
					tinsert(d, i, {CV/cbt, ta, tb})
					break
				else
					if (d[i][1] < CV/cbt) then
						tinsert(a, i, cat)
						tinsert(d, i, {CV/cbt, ta, tb})
						break
					end
				end
				i = i + 1
			end
		end
	end
	return a, arr[user[1]]["i"]/(cbt or 1), d
end

function DPSMate.Modules.DTPS:GetSettingValues(arr, cbt, k,ecbt)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 or DPSMateSettings["windows"][k]["numberformat"] == 4 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.DTPS:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort, dmgr, totr, sortr = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmgr==0 then break end; if dmgr<=10000 then p = "" end
		local str = {[1]="",[2]="",[3]="",[4]=""}
		local pname = DPSMate:GetUserById(a[cat])
		if DPSMateSettings["columnsdtps"][2] then str[1] = " "..strformat("%.1f", dmg/cbt)..p; strt[2] = " "..strformat("%.1f", tot/cbt)..p end 
		if DPSMateSettings["columnsdtps"][3] then str[2] = " ("..strformat("%.1f", 100*dmgr/totr).."%)" end
		if DPSMateSettings["columnsdtps"][1] then str[3] = "("..DPSMate:Commas(dmg, k)..p..")"; strt[1] = "("..DPSMate:Commas(tot, k)..p..")" end
		if DPSMateSettings["columnsdtps"][4] then str[4] = " ("..strformat("%.1f", dmg/(ecbt[pname] or cbt))..p..")" end
		tinsert(name, pname)
		tinsert(value, str[3]..str[1]..str[4]..str[2])
		tinsert(perc, 100*(dmgr/sortr))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.DTPS:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.DTPS:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(a[i]),strformat("%.2f", c[i][1]).." ("..strformat("%.2f", 100*c[i][1]/b).."%)",1,1,1,1,1,1)
			for p=1, 3 do 
				if not c[i][2][p] or c[i][3][p]==0 then break end
				GameTooltip:AddDoubleLine("       "..p..". "..DPSMate:GetAbilityById(c[i][2][p]),strformat("%.2f", c[i][3][p]).." ("..strformat("%.2f", 100*c[i][3][p]/c[i][1]).."%)",0.5,0.5,0.5,0.5,0.5,0.5)
			end
		end
	end
end

function DPSMate.Modules.DTPS:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsDamageTaken:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsDamageTaken:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.DTPS:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsDamageTakenTotal:UpdateDetails(obj, key)
end
