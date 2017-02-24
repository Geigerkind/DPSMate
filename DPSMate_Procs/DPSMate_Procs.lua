-- Global Variables
DPSMate.Modules.Procs = {}
DPSMate.Modules.Procs.Hist = "Auras"
DPSMate.Options.Options[1]["args"]["procs"] = {
	order = 234,
	type = 'toggle',
	name = DPSMate.L["procs"],
	desc = DPSMate.L["show"].." "..DPSMate.L["procs"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["procs"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "procs", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}
DPSMate.Modules.Procs.Events = {
	"CHAT_MSG_SPELL_SELF_BUFF",
	"CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
	"CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF",
	"CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS",
	"CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF",
	"CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS",
	"CHAT_MSG_SPELL_PARTY_BUFF",
	"CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS",
	"CHAT_MSG_SPELL_AURA_GONE_SELF",
	"CHAT_MSG_SPELL_AURA_GONE_OTHER",
	"CHAT_MSG_SPELL_AURA_GONE_PARTY",
}

-- Register the moodule
DPSMate:Register("procs", DPSMate.Modules.Procs, DPSMate.L["procs"])

local tinsert = table.insert
local strformat = string.format
DPSMate.Modules.Procs.nonProcProcs = {
	["Holy Strength"] = true,
	["Felstriker"] = true,
	["Sanctuary"] = true,
	["Fury of Forgewright"] = true,
	["Primal Blessing"] = true,
	["Spinal Reaper"] = true, -- To test
	["Netherwind Focus"] = true, -- To test
	["Parry"] = true, -- To test
	["Untamed Fury"] = true,
	["Aura of the Blue Dragon"] = true, -- Mana Darkmoon card
	["Invigorate"] = true,
	["Head Rush"] = true,
	["Enigma Resist Bonus"] = true,
	["Enigma Blizzard Bonus"] = true,
	["Not There"] = true,
	["Epiphany"] = true,
	["Inspiration"] = true,
	["Blessed Recovery"] = true,
	["Focused Casting"] = true,
	["Clearcasting"] = true,
	["Nature's Grace"] = true,
	["Battlegear of Eternal Justice"] = true,
	["Redoubt"] = true,
	["Vengeance"] = true,
	["Stormcaller's Wrath"] = true,
	["Ancestral Healing"] = true,
	["Vampirism"] = true,
	["Nightfall"] = true,
	["Cheat Death"] = true,
	["Flurry"] = true,
	["Enrage"] = true,
	["Quick Shots"] = true,
}

function DPSMate.Modules.Procs:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do -- 2 Target
		if DPSMate:ApplyFilter(k, DPSMate:GetUserById(cat)) then
			local CV = 0
			for ca, va in pairs(val) do -- 3 ability
				local name = DPSMate:GetAbilityById(ca)
				if (DPSMate.Parser.procs[name] and va[4]) or self.nonProcProcs[name] or DPSMate.Parser.DmgProcs[name] then
					for c, v in va[1] do -- 1 Ability
						CV=CV+1
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

function DPSMate.Modules.Procs:EvalTable(user, k)
	local a, b, temp, total = {}, {}, {}, 0
	local arr = DPSMate:GetMode(k)
	for cat, val in pairs(arr[user[1]]) do -- 3 Ability
		local name = DPSMate:GetAbilityById(cat)
		if (DPSMate.Parser.procs[name] and val[4]) or self.nonProcProcs[name] or DPSMate.Parser.DmgProcs[name] then
			local CV = 0
			for c, v in val[1] do -- 1 Ability
				CV=CV+1
			end
			if temp[cat] then temp[cat]=temp[cat]+CV else temp[cat]=CV end
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
		total = total + val
	end
	return a, total, b
end

function DPSMate.Modules.Procs:GetSettingValues(arr, cbt, k)
	local pt = ""
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 or DPSMateSettings["windows"][k]["numberformat"] == 4 then p = "K"; pt = "K" end
	sortedTable, total, a = DPSMate.Modules.Procs:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = val, total, sortedTable[1]
		if dmg==0 then break end; if tot <= 10000 then pt = "" end;
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsprocs"][1] then str[1] = " "..DPSMate:Commas(dmg, k)..p; strt[2] = DPSMate:Commas(tot, k)..pt end
		if DPSMateSettings["columnsprocs"][2] then str[3] = " ("..strformat("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, DPSMate:GetUserById(a[cat]))
		tinsert(value, str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Procs:ShowTooltip(user,k)
	if DPSMateSettings["informativetooltips"] then
		local a,b,c = DPSMate.Modules.Procs:EvalTable(DPSMateUser[user], k)
		GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMateSettings["subviewrows"]..DPSMate.L["ttabilities"])
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i].." ("..strformat("%.2f", 100*c[i]/b).."%)",1,1,1,1,1,1)
		end
	end
end

function DPSMate.Modules.Procs:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsProcs:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsProcs:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.Procs:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsProcsTotal:UpdateDetails(obj, key)
end


