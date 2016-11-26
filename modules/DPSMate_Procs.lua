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

-- Register the moodule
DPSMate:Register("procs", DPSMate.Modules.Procs, DPSMate.L["procs"])

local tinsert = table.insert
local strformat = string.format
local nonProcProcs = {
	[DPSMate.BabbleSpell:GetTranslation("Holy Strength")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Felstriker")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Sanctuary")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Fury of Forgewright")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Primal Blessing")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Spinal Reaper")] = true, -- To test
	[DPSMate.BabbleSpell:GetTranslation("Netherwind Focus")] = true, -- To test
	[DPSMate.BabbleSpell:GetTranslation("Parry")] = true, -- To test
	[DPSMate.BabbleSpell:GetTranslation("Untamed Fury")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Aura of the Blue Dragon")] = true, -- Mana Darkmoon card
	[DPSMate.BabbleSpell:GetTranslation("Invigorate")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Head Rush")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Enigma Resist Bonus")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Enigma Blizzard Bonus")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Not There")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Epiphany")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Inspiration")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Blessed Recovery")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Focused Casting")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Clearcasting")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Nature's Grace")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Battlegear of Eternal Justice")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Redoubt")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Vengeance")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Stormcaller's Wrath")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Ancestral Healing")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Vampirism")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Nightfall")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Cheat Death")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Flurry")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Enrage")] = true,
	[DPSMate.BabbleSpell:GetTranslation("Quick Shots")] = true,
}

function DPSMate.Modules.Procs:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do -- 2 Target
		if DPSMate:ApplyFilter(k, DPSMate:GetUserById(cat)) then
			local CV = 0
			for ca, va in pairs(val) do -- 3 ability
				local name = DPSMate:GetAbilityById(ca)
				if (DPSMate.Parser.procs[name] and va[4]) or nonProcProcs[name] or DPSMate.Parser.DmgProcs[name] then
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
		if (DPSMate.Parser.procs[name] and val[4]) or nonProcProcs[name] or DPSMate.Parser.DmgProcs[name] then
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
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	
	sortedTable, total, a = DPSMate.Modules.Procs:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = val, total, sortedTable[1]
		if dmg==0 then break end;
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsprocs"][1] then str[1] = " "..DPSMate:Commas(dmg, k)..p; strt[2] = DPSMate:Commas(tot, k)..p end
		if DPSMateSettings["columnsprocs"][2] then str[3] = " ("..strformat("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, DPSMate:GetUserById(a[cat]))
		tinsert(value, str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Procs:ShowTooltip(user,k)
	local a,b,c = DPSMate.Modules.Procs:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
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


