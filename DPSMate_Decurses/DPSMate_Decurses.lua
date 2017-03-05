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
DPSMate.Modules.Decurses.Events = {
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
	local pt = ""
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 or DPSMateSettings["windows"][k]["numberformat"] == 4 then p = "K"; pt = "K" end
	sortedTable, total, a = DPSMate.Modules.Decurses:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = val, total, sortedTable[1]
		if dmg==0 then break end; if tot <= 10000 then pt = "" end;
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsdecurses"][1] then str[1] = " "..DPSMate:Commas(dmg, k)..p; strt[2] = DPSMate:Commas(tot, k)..pt end
		if DPSMateSettings["columnsdecurses"][2] then str[3] = " ("..strformat("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, DPSMate:GetUserById(a[cat]))
		tinsert(value, str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Decurses:ShowTooltip(user,k)
	if DPSMateSettings["informativetooltips"] then
		local p, sum = 0, 0
		local a, b, abn, abnt = {}, {}, {}, {}
		local arr = DPSMate:GetMode(k)
		if arr[DPSMateUser[user][1]] then 
			for cat, val in pairs(arr[DPSMateUser[user][1]]) do -- 41 Ability
				if cat~="i" then
					for ca, va in pairs(val) do -- Cleansed guy
						for c, v in pairs(va) do -- Cleansed ability
							if self:IsValid(DPSMate:GetAbilityById(c), DPSMate:GetAbilityById(cat), DPSMateUser[user]) then
								if b[c] then b[c] = b[c] + v else b[c] = v end
								if a[ca] then a[ca] = a[ca] + v else a[ca] = v end
							end
						end
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

