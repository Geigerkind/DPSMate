-- Global Variables
DPSMate.Modules.TPS = {}
DPSMate.Modules.TPS.Hist = "Threat"
DPSMate.Options.Options[1]["args"]["tps"] = {
	order = 290,
	type = 'toggle',
	name = DPSMate.L["tps"],
	desc = DPSMate.L["show"].." "..DPSMate.L["tps"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["tps"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "tps", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("tps", DPSMate.Modules.TPS, DPSMate.L["tps"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.TPS:GetSortedTable(arr, k, cbt)
	local b, a, total = {}, {}, 0
	for cat, val in arr do
		local CV = 0
		for ca, va in val do
			for c, v in va do
				CV = CV + v[1]
			end
		end
		local name = DPSMate:GetUserById(cat)
		local i = 1
		while true do
			if (not b[i]) then
				tinsert(b, i, CV)
				tinsert(a, i, name)
				break
			else
				if b[i] < CV then
					tinsert(b, i, CV)
					tinsert(a, i, name)
					break
				end
			end
			i=i+1
		end
		total = total + CV
	end
	return b, strformat("%.1f", total/(cbt or 1)), a
end

function DPSMate.Modules.TPS:EvalTable(user, k, cbt)
	local a,d, total = {}, {}, 0
	local arr, cbet = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	cbt = cbt or cbet
	for cat, val in arr[user[1]] do -- targets
		local CV, e, q = 0, {}, {}
		for ca, va in val do -- ability
			CV = CV + va[1]
			local t = 1
			while true do
				if not e[t] then
					tinsert(e, t, va[1]/cbt)
					tinsert(q, t, ca)
					break
				elseif e[t]<va[1]/cbt then
					tinsert(e, t, va[1]/cbt)
					tinsert(q, t, ca)
					break
				end
				t = t + 1
			end
		end
		local i = 1
		while true do
			if not a[i] then
				tinsert(a, i, cat)
				tinsert(d, i, {CV/cbt, q, e})
				break
			elseif d[i][1]<CV/cbt then
				tinsert(a, i, cat)
				tinsert(d, i, {CV/cbt, q, e})
				break
			end
			i = i + 1
		end
		total = total + CV
	end
	return a, total/cbt, d
end

function DPSMate.Modules.TPS:GetSettingValues(arr, cbt, k,ecbt)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 or DPSMateSettings["windows"][k]["numberformat"] == 4 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.TPS:GetSortedTable(arr, k)
	for cat, val in sortedTable do
		local dmg, tot, sort, dmgr, totr, sortr = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmgr==0 then break end; if dmgr<=10000 then p = "" end
		local str = {[1]="",[2]="",[3]="",[4]=""}
		if DPSMateSettings["columnstps"][1] then str[1] = "("..strformat("%.2f", dmg)..p..")"; strt[1] = "("..strformat("%.2f", tot)..p..")" end
		if DPSMateSettings["columnstps"][2] then str[2] = " "..strformat("%.1f", (dmg/cbt))..p; strt[2] = " "..strformat("%.1f", (tot/cbt))..p end
		if DPSMateSettings["columnstps"][3] then str[3] = " ("..strformat("%.1f", 100*dmgr/totr).."%)" end
		if DPSMateSettings["columnstps"][4] then str[4] = " ("..strformat("%.1f", dmg/(ecbt[a[cat]] or cbt))..p..")" end
		tinsert(name, a[cat])
		tinsert(value, str[2]..str[1]..str[4]..str[3])
		tinsert(perc, 100*(dmgr/sortr))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.TPS:ShowTooltip(user,k)
	local a,b,c = DPSMate.Modules.TPS:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(a[i]),strformat("%.2f", c[i][1]).." ("..strformat("%.2f", 100*c[i][1]/b).."%)",1,1,1,1,1,1)
			for p=1, 3 do
				if not c[i][2][p] or c[i][3][p]==0 then break end
				GameTooltip:AddDoubleLine("       "..p..". "..DPSMate:GetAbilityById(c[i][2][p]),strformat("%.2f", c[i][3][p]).." ("..strformat("%.2f", 100*c[i][3][p]/a[i]).."%)",0.5,0.5,0.5,0.5,0.5,0.5)
			end
		end
	end
end

function DPSMate.Modules.TPS:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsThreat:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsThreat:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.TPS:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsThreatTotal:UpdateDetails(obj, key)
end
