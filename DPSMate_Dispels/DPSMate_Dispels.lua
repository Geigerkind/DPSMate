-- Global Variables
DPSMate.Modules.Dispels = {}
DPSMate.Modules.Dispels.Hist = "Dispels"
DPSMate.Options.Options[1]["args"]["dispels"] = {
	order = 180,
	type = 'toggle',
	name = DPSMate.L["dispels"],
	desc = DPSMate.L["show"].." "..DPSMate.L["dispels"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["dispels"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "dispels", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}
DPSMate.Modules.Dispels.Events = {
	"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
	"CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE",
	"CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE",
	"CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_SELF_DAMAGE",
	-- Healing/Absorbs/Fail/DeathHistory/Dispels
	"CHAT_MSG_SPELL_SELF_BUFF",
	"CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
	"CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF",
	"CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS",
	"CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF",
	"CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS",
	"CHAT_MSG_SPELL_PARTY_BUFF",
	"CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS",

	-- Absorbs/Auras
	"CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF",
	"CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS",
	"CHAT_MSG_SPELL_BREAK_AURA",
	"CHAT_MSG_SPELL_AURA_GONE_SELF",
	"CHAT_MSG_SPELL_AURA_GONE_OTHER",
	"CHAT_MSG_SPELL_AURA_GONE_PARTY",
}

-- Register the moodule
DPSMate:Register("dispels", DPSMate.Modules.Dispels, DPSMate.L["dispels"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.Dispels:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do -- 3 Owner
		if DPSMate:ApplyFilter(k, DPSMate:GetUserById(cat)) then
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
	return b, total, a
end

function DPSMate.Modules.Dispels:EvalTable(user, k)
	local a, b = {}, {}
	local arr = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	for cat, val in pairs(arr[user[1]]) do -- 41 Ability
		if cat~="i" then
			local CV = 0
			for ca, va in pairs(val) do
				for c, v in pairs(va) do
					CV = CV + v
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
				i = i + 1
			end
		end
	end
	return a, arr[user[1]]["i"][1], b
end

function DPSMate.Modules.Dispels:GetSettingValues(arr, cbt, k)
	local pt = ""
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 or DPSMateSettings["windows"][k]["numberformat"] == 4 then p = "K"; pt = "K" end
	sortedTable, total, a = DPSMate.Modules.Dispels:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = val, total, sortedTable[1]
		if dmg==0 then break end; if tot <= 10000 then pt = "" end;
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsdispels"][1] then str[1] = " "..DPSMate:Commas(dmg, k)..p; strt[2] = DPSMate:Commas(tot, k)..pt end
		if DPSMateSettings["columnsdispels"][2] then str[3] = " ("..strformat("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, DPSMate:GetUserById(a[cat]))
		tinsert(value, str[2]..str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Dispels:ShowTooltip(user,k)
	if DPSMateSettings["informativetooltips"] then
		local p, sum = 0, 0
		local a, b, abn, abnt = {}, {}, {}, {}
		local arr = DPSMate:GetMode(k)
		if arr[DPSMateUser[user][1]] then
			for cat, val in pairs(arr[DPSMateUser[user][1]]) do -- 41 Ability
				if cat~="i" then
					for ca, va in pairs(val) do -- Cleansed guy
						p = 0
						for c, v in pairs(va) do -- Cleansed ability
							if b[c] then b[c] = b[c] + v else b[c] = v end
							p = p + v
						end
						if a[ca] then a[ca] = a[ca] + p else a[ca] = p end
					end
				end
			end
		end

		for cat, val in pairs(a) do
			i = 1
			while true do
				if not abn[i] then
					tinsert(abn, i, {cat, val})
					break
				else
					if abn[i][2]<val then
						tinsert(abn, i, {cat, val})
						break
					end
				end
				i = i + 1
			end
		end
		for cat, val in pairs(b) do
			i = 1
			while true do
				if not abnt[i] then
					tinsert(abnt, i, {cat, val})
					break
				else
					if abnt[i][2]<val then
						tinsert(abnt, i, {cat, val})
						break
					end
				end
				i = i + 1
			end
			sum = sum + val
		end
		a = nil
		b = nil

		GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMateSettings["subviewrows"]..DPSMate.L["ttdispelled"]..DPSMate.L["ttabilities"])
		for i=1, DPSMateSettings["subviewrows"] do
			if not abnt[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(abnt[i][1]),abnt[i][2].." ("..strformat("%.2f", 100*abnt[i][2]/sum).."%)",1,1,1,1,1,1)
		end

		GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMateSettings["subviewrows"]..DPSMate.L["ttdispelled"])
		for i=1, DPSMateSettings["subviewrows"] do
			if not abn[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(abn[i][1]), abn[i][2].." ("..strformat("%.2f", 100*abn[i][2]/sum).."%)", 1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.Dispels:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsDispels:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsDispels:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.Dispels:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsDispelsTotal:UpdateDetails(obj, key)
end
