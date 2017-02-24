-- Global Variables
DPSMate.Modules.Deaths = {}
DPSMate.Modules.Deaths.Hist = "Deaths"
DPSMate.Options.Options[1]["args"]["deaths"] = {
	order = 160,
	type = 'toggle',
	name = DPSMate.L["deaths"],
	desc = DPSMate.L["show"].." "..DPSMate.L["deaths"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["deaths"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "deaths", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}
DPSMate.Modules.Deaths.Events = {
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
	
	-- Death/DeathHistory
	"CHAT_MSG_COMBAT_FRIENDLY_DEATH",
	"CHAT_MSG_COMBAT_HOSTILE_DEATH",
}

-- Register the moodule
DPSMate:Register("deaths", DPSMate.Modules.Deaths, DPSMate.L["deaths"])

local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.Deaths:GetSortedTable(arr,k)
	local b, a, total = {}, {}, 0
	if arr then
		for cat, val in pairs(arr) do -- 28
			if DPSMate:ApplyFilter(k, DPSMate:GetUserById(cat)) then
				local CV = 0
				for ca, va in pairs(val) do -- 1 (Death)
					if va["i"][1]==1 then
						CV=CV+1
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
	end
	return b, total, a
end

-- Needs improvement, but kinda all tooltips need that
function DPSMate.Modules.Deaths:EvalTable(user, k, id)
	local a, b, total = {}, {}, 0
	local arr = DPSMate:GetMode(k)
	local p = 1
	if not arr[user[1]] then return end
	if arr[user[1]][1] then 
		if arr[user[1]][1]["i"][1]~=1 then p=2 else p=1 end 
		if arr[user[1]][id or p] then 
			for ca, va in pairs(arr[user[1]][id or p]) do -- 1 (Death)
				if ca~="i" then
					tinsert(b, ca, {va[3], va[5], va[4]})
					tinsert(a, ca, va[2])
				end
			end
		end
	end
	return a, total, b
end

function DPSMate.Modules.Deaths:GetSettingValues(arr, cbt, k)
	local pt = ""
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 or DPSMateSettings["windows"][k]["numberformat"] == 4 then p = "K"; pt = "K" end
	sortedTable, total, a = DPSMate.Modules.Deaths:GetSortedTable(arr,k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = val, total, sortedTable[1]
		if dmg==0 then break end; if tot <= 10000 then pt = "" end;
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsdeaths"][1] then str[1] = " "..DPSMate:Commas(dmg, k)..p; strt[2] = DPSMate:Commas(tot, k)..pt end
		if DPSMateSettings["columnsdeaths"][2] then str[3] = " ("..strformat("%.1f", 100*dmg/tot).."%)" end
		tinsert(name, DPSMate:GetUserById(a[cat]))
		tinsert(value, str[1]..str[3])
		tinsert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Deaths:ShowTooltip(user,k)
	if DPSMateSettings["informativetooltips"] then
		local a,b,c = DPSMate.Modules.Deaths:EvalTable(DPSMateUser[user], k)
		GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMateSettings["subviewrows"]..DPSMate.L["ttabilities"])
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			local type = " (HIT)"
			if c[i][3]==1 then type=" (CRIT)" elseif c[i][3]==2 then type=" (CRUSH)" end
			if c[i][2]==1 then
				GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),"+"..c[i][1]..type,0.67,0.83,0.45,0.67,0.83,0.45)
			else
				GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),"-"..c[i][1]..type,0.77,0.12,0.23,0.77,0.12,0.23)
			end
		end
	end
end

function DPSMate.Modules.Deaths:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsDeaths:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsDeaths:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.Deaths:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsDeathsTotal:UpdateDetails(obj, key)
end

