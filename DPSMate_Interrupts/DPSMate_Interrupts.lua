-- Global Variables
DPSMate.Modules.Interrupts = {}
DPSMate.Modules.Interrupts.Hist = "Interrupts"
DPSMate.Options.Options[1]["args"]["interrupts"] = {
	order = 160,
	type = 'toggle',
	name = DPSMate.L["interrupts"],
	desc = DPSMate.L["show"].." "..DPSMate.L["interrupts"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["interrupts"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "interrupts", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}
DPSMate.Modules.Interrupts.Events = {
	-- Damage
	"CHAT_MSG_COMBAT_SELF_HITS",
	"CHAT_MSG_COMBAT_SELF_MISSES",
	"CHAT_MSG_SPELL_SELF_DAMAGE",
	"CHAT_MSG_COMBAT_PARTY_HITS",
	"CHAT_MSG_SPELL_PARTY_DAMAGE",
	"CHAT_MSG_COMBAT_PARTY_MISSES",
	"CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS",
	"CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES",
	"CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE",
	-- Pet Damage
	"CHAT_MSG_COMBAT_PET_HITS",
	"CHAT_MSG_COMBAT_PET_MISSES",
	--"CHAT_MSG_SPELL_PET_BUFF",
	"CHAT_MSG_SPELL_PET_DAMAGE",
	
	-- EDD (Enemy player) / DeathHistory
	"CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS",
	"CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES",
	"CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE",

	-- Damage taken (Also EDD) / DeathHistory
	"CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS",
	"CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES",
	"CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE",
	"CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS",
	"CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES",
	"CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE",
	"CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS",
	"CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES",
	"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
}

-- Register the moodule
DPSMate:Register("interrupts", DPSMate.Modules.Interrupts, DPSMate.L["interrupts"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.Interrupts:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	for cat, val in pairs(arr) do -- 1 Owner
		local name = DPSMate:GetUserById(cat)
		if (not DPSMateUser[name][4] or (DPSMateUser[name][4] and not DPSMateSettings["mergepets"])) then
			if DPSMate:ApplyFilter(k, name) then
				local CV = val["i"][1]
				if DPSMateUser[name][5] and arr[DPSMateUser[DPSMateUser[name][5]][1]] and DPSMateSettings["mergepets"] and DPSMateUser[name][5]~=name then
					CV=CV+arr[DPSMateUser[DPSMateUser[name][5]][1]]["i"][1]
				end
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
	end
	return b, total, a
end

function DPSMate.Modules.Interrupts:EvalTable(user, k)
	local a, b, total, pet, u = {}, {}, 0, false, {}
	local arr = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	if (user[5] and user[5] ~= DPSMate.L["unknown"] and arr[DPSMateUser[user[5]][1]]) and DPSMateSettings["mergepets"] and DPSMateUser[name][5]~=name then u={user[1],DPSMateUser[user[5]][1]} else u={user[1]} end
	for _, vvv in pairs(u) do
		for cat, val in pairs(arr[vvv]) do -- 41 Ability
			if cat~="i" then
				local CV = 0
				local d,e = {}, {}
				if (DPSMateUser[DPSMate:GetUserById(vvv)][4]) then pet=true; else pet=false; end
				for ca, va in pairs(val) do
					local CVV = 0
					for c, v in pairs(va) do
						CV = CV + v
						CVV = CVV + v
					end
					local i = 1
					while true do
						if (not d[i]) then
							tinsert(d, i, CVV)
							tinsert(e, i, ca)
							break
						else
							if d[i] < CVV then
								tinsert(d, i, CVV)
								tinsert(e, i, ca)
								break
							end
						end
						i=i+1
					end
				end
				if CV>0 then
					local i = 1
					while true do
						if (not b[i]) then
							tinsert(b, i, {CV, e, d})
							tinsert(a, i, {cat, pet})
							break
						else
							if b[i][1] < CV then
								tinsert(b, i, {CV, e, d})
								tinsert(a, i, {cat, pet})
								break
							end
						end
						i=i+1
					end
				end
			end
		end
		total = total + arr[vvv]["i"][1]
	end
	return a, total, b
end

function DPSMate.Modules.Interrupts:GetSettingValues(arr, cbt, k)
	local pt = ""
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 or DPSMateSettings["windows"][k]["numberformat"] == 4 then p = "K"; pt = "K" end
	sortedTable, total, a = DPSMate.Modules.Interrupts:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = val, total, sortedTable[1]
		if dmg==0 then break end; if tot <= 10000 then pt = "" end;
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsinterrupts"][1] then str[1] = " "..DPSMate:Commas(dmg, k)..p; strt[2] = DPSMate:Commas(tot, k)..pt end
		if DPSMateSettings["columnsinterrupts"][2] then str[3] = " ("..strformat("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, DPSMate:GetUserById(a[cat]))
		tinsert(value, str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Interrupts:ShowTooltip(user,k)
	if DPSMateSettings["informativetooltips"] then
		local a,b,c = DPSMate.Modules.Interrupts:EvalTable(DPSMateUser[user], k)
		local i, p = 1, 0
		local pet = 0
		local ab, abn, abPet, abnPet = {}, {}, {}, {}
		
		while a[i] do
			if a[i][2] then
				p = 1
				while c[i][2][p] do
					if abPet[c[i][2][p]] then
						abPet[c[i][2][p]] = abPet[c[i][2][p]] + c[i][3][p]
					else
						abPet[c[i][2][p]] = c[i][3][p]
					end
					pet = pet + c[i][3][p]
					p = p + 1
				end
			else
				p = 1
				while c[i][2][p] do
					if ab[c[i][2][p]] then
						ab[c[i][2][p]] = ab[c[i][2][p]] + c[i][3][p]
					else
						ab[c[i][2][p]] = c[i][3][p]
					end
					p = p + 1
				end
			end
			i = i + 1
		end
		for cat, val in pairs(ab) do
			if val>0 then
				i = 1
				while true do
					if (not abn[i]) then
						tinsert(abn, i, {cat, val})
						break
					else
						if (abn[i][2] < val) then
							tinsert(abn, i, {cat, val})
							break
						end
					end
					i = i + 1
				end
			end
		end
		for cat, val in pairs(abPet) do
			if val>0 then
				i = 1
				while true do
					if (not abnPet[i]) then
						tinsert(abnPet, i, {cat, val})
						break
					else
						if (abnPet[i][2] < val) then
							tinsert(abnPet, i, {cat, val})
							break
						end
					end
					i = i + 1
				end
			end
		end
		ab = nil
		abPet = nil
	
		GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMateSettings["subviewrows"]..DPSMate.L["ttinterrupt"]..DPSMate.L["ttabilities"])
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			if not a[i][2] then 
				GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i][1]),c[i][1].." ("..strformat("%.2f", 100*c[i][1]/(b-pet)).."%)",1,1,1,1,1,1)
			end
		end
		
		GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMateSettings["subviewrows"]..DPSMate.L["ttinterrupted"])
		for i=1, DPSMateSettings["subviewrows"] do
			if not abn[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(abn[i][1]), abn[i][2].." ("..strformat("%.2f", 100*abn[i][2]/(b-pet)).."%)", 1,1,1,1,1,1)
		end
		
		if pet~=0 and DPSMateUser[user][5] then
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine(DPSMate.L["ttpet2"],DPSMateUser[user][5].."<"..user.."> ("..strformat("%.2f", 100*pet/b).."%)",1,0.82,0,1,1,1)
			GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMateSettings["subviewrows"]..DPSMate.L["ttpet"]..DPSMate.L["ttinterrupt"]..DPSMate.L["ttabilities"])
			i, p = 1,1
			while DPSMateSettings["subviewrows"]>=p do
				if not a[i] then break end
				if a[i][2] then 
					GameTooltip:AddDoubleLine(p..". "..DPSMate:GetAbilityById(a[i][1]),c[i][1].." ("..strformat("%.2f", 100*c[i][1]/pet).."%)",1,1,1,1,1,1)
					p = p + 1
				end
				i = i + 1
			end
			GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMateSettings["subviewrows"]..DPSMate.L["ttpet"]..DPSMate.L["ttinterrupted"])
			for i=1, DPSMateSettings["subviewrows"] do
				if not abnPet[i] then break end
				GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(abnPet[i][1]), abnPet[i][2].." ("..strformat("%.2f", 100*abnPet[i][2]/pet).."%)", 1,1,1,1,1,1)
			end
		end
	end
end

function DPSMate.Modules.Interrupts:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsInterrupts:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsInterrupts:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.Interrupts:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsInterruptsTotal:UpdateDetails(obj, key)
end

