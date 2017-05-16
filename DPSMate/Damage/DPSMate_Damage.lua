-- Global Variables
DPSMate.Modules.Damage = {}
DPSMate.Modules.Damage.Hist = "DMGDone"
DPSMate.Options.Options[1]["args"]["damage"] = {
	order = 20,
	type = 'toggle',
	name = DPSMate.L["damage"],
	desc = DPSMate.L["show"].." "..DPSMate.L["damage"]..".",
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["damage"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "damage", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}
DPSMate.Modules.Damage.Events = {
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
}

-- Register the moodule
DPSMate:Register("damage", DPSMate.Modules.Damage, DPSMate.L["damage"])

local tinsert = table.insert
local strformat = string.format
local pairs = pairs

function DPSMate.Modules.Damage:GetSortedTable(arr, k)
	local b, a, total, CV, i, name = {}, {}, 0
	for cat, val in pairs(arr) do
		name = DPSMate:GetUserById(cat)
		if (not DPSMateUser[name][4] or (DPSMateUser[name][4] and not DPSMateSettings["mergepets"])) then
			if DPSMate:ApplyFilter(k, name) then
				CV = val["i"]
				if DPSMateSettings["mergepets"] and DPSMateUser[DPSMateUser[name][5]] and arr[DPSMateUser[DPSMateUser[name][5]][1]] and name~=DPSMateUser[name][5] then
					CV=CV+arr[DPSMateUser[DPSMateUser[name][5]][1]]["i"]
				end
				i = 1
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
		end
	end
	return b, total, a
end

function DPSMate.Modules.Damage:EvalTable(user, k)
	local a, u, p, d, total, pet = {}, {}, {}, {}, 0, false
	local arr = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	if (user and user[5] and user[5] ~= DPSMate.L["unknown"] and DPSMateUser[user[5]] and arr[DPSMateUser[user[5]][1]]) and DPSMateSettings["mergepets"] and DPSMateUser[user[5]][1]~=user[1] then u={user[1],DPSMateUser[user[5]][1]} else u={user[1]} end
	for _, v in pairs(u) do
		for cat, val in pairs(arr[v]) do
			if (type(val) == "table" and cat~="i") then
				if val[13]~=0 and cat~="" then
					if (DPSMateUser[DPSMate:GetUserById(v)][4]) then pet=true; else pet=false; end
					local i = 1
					while true do
						if (not d[i]) then
							tinsert(a, i, cat)
							tinsert(d, i, {val[13], pet})
							break
						else
							if (d[i][1] < val[13]) then
								tinsert(a, i, cat)
								tinsert(d, i, {val[13], pet})
								break
							end
						end
						i = i + 1
					end
				end
			end
		end
		total=total+arr[v]["i"]
	end
	return a, total, d
end

function DPSMate.Modules.Damage:GetSettingValues(arr, cbt, k,ecbt)
	local pt = ""
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 or DPSMateSettings["windows"][k]["numberformat"] == 4 then p = "K"; pt = "K" end
	sortedTable, total, a = DPSMate.Modules.Damage:GetSortedTable(arr, k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort, dmgr, totr, sortr = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmgr==0 then break end; if totr <= 10000 then pt = "" end; if dmgr<=10000 then p = "" end
		local str = {[1]="",[2]="",[3]="",[4]=""}
		local pname = a[cat]
		if DPSMateSettings["columnsdmg"][1] then str[1] = " "..DPSMate:Commas(dmg, k)..p; strt[2] = DPSMate:Commas(tot, k)..pt end
		if DPSMateSettings["columnsdmg"][2] then str[2] = "("..strformat("%.1f", (dmg/cbt))..p..")"; strt[1] = "("..strformat("%.1f", (tot/cbt))..pt..") " end
		if DPSMateSettings["columnsdmg"][3] then str[3] = " ("..strformat("%.1f", 100*dmgr/totr).."%)" end
		if DPSMateSettings["columnsdmg"][4] then str[4] = " ("..strformat("%.1f", dmg/(ecbt[pname] or cbt))..p..")" end
		tinsert(name, a[cat])
		tinsert(value, str[2]..str[1]..str[4]..str[3])
		tinsert(perc, 100*(dmgr/sortr))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Damage:ShowTooltip(user,k)
	if DPSMateSettings["informativetooltips"] then
		local a,b,c = DPSMate.Modules.Damage:EvalTable(DPSMateUser[user], k)
		local db = DPSMate:GetModeByArr(DPSMateEDT, k, "EDTaken")
		local i, p = 1, 0
		local pet = 0
		local edtaken, edtakenPet = {}, {}
		-- Getting the value of the pet
		while a[i] do
			if c[i][2] then
				pet = pet + c[i][1]
			end
			i = i + 1
		end
		
		-- Getting edt values
		for cat, val in pairs(db) do
			if val[DPSMateUser[user][1]] then
				if val[DPSMateUser[user][1]]["i"]>0 then
					i = 1
					while true do
						if (not edtaken[i]) then
							tinsert(edtaken, i, {cat, val[DPSMateUser[user][1]]["i"]})
							break
						else
							if (edtaken[i][2] < val[DPSMateUser[user][1]]["i"]) then
								tinsert(edtaken, i, {cat, val[DPSMateUser[user][1]]["i"]})
								break
							end
						end
						i = i + 1
					end
				end
			end
			if DPSMateUser[DPSMateUser[user][5]] and val[DPSMateUser[DPSMateUser[user][5]][1]] then
				if val[DPSMateUser[DPSMateUser[user][5]][1]]["i"]>0 then
					i = 1
					while true do
						if (not edtakenPet[i]) then
							tinsert(edtakenPet, i, {cat, val[DPSMateUser[DPSMateUser[user][5]][1]]["i"]})
							break
						else
							if (edtakenPet[i][2] < val[DPSMateUser[DPSMateUser[user][5]][1]]["i"]) then
								tinsert(edtakenPet, i, {cat, val[DPSMateUser[DPSMateUser[user][5]][1]]["i"]})
								break
							end
						end
						i = i + 1
					end
				end
			end
		end
	
		GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMateSettings["subviewrows"]..DPSMate.L["ttdamage"]..DPSMate.L["ttabilities"])
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			if not c[i][2] then 
				GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i][1].." ("..strformat("%.2f", 100*c[i][1]/(b-pet)).."%)",1,1,1,1,1,1)
			end
		end
		
		GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMateSettings["subviewrows"]..DPSMate.L["ttattacked"])
		for i=1, DPSMateSettings["subviewrows"] do
			if not edtaken[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(edtaken[i][1]), edtaken[i][2].." ("..strformat("%.2f", 100*edtaken[i][2]/(b-pet)).."%)", 1,1,1,1,1,1)
		end
		
		if pet~=0 and DPSMateUser[user][5] then
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine(DPSMate.L["ttpet2"],DPSMateUser[user][5].."<"..user.."> ("..strformat("%.2f", 100*pet/b).."%)",1,0.82,0,1,1,1)
			GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMateSettings["subviewrows"]..DPSMate.L["ttpet"]..DPSMate.L["ttdamage"]..DPSMate.L["ttabilities"])
			i, p = 1,1
			while DPSMateSettings["subviewrows"]>=p do
				if not a[i] then break end
				if c[i][2] then 
					GameTooltip:AddDoubleLine(p..". "..DPSMate:GetAbilityById(a[i]),c[i][1].." ("..strformat("%.2f", 100*c[i][1]/pet).."%)",1,1,1,1,1,1)
					p = p + 1
				end
				i = i + 1
			end
			GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMateSettings["subviewrows"]..DPSMate.L["ttpet"]..DPSMate.L["ttattacked"])
			for i=1, DPSMateSettings["subviewrows"] do
				if not edtakenPet[i] then break end
				GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(edtakenPet[i][1]), edtakenPet[i][2].." ("..strformat("%.2f", 100*edtakenPet[i][2]/pet).."%)", 1,1,1,1,1,1)
			end
		end
	end
end

function DPSMate.Modules.Damage:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsDamage:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsDamage:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.Damage:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsDamageTotal:UpdateDetails(obj, key)
end
