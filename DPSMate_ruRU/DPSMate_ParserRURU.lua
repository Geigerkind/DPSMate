-- Version : Russian ( by Maus - vk.com/wowruru)

local t = {}
local strgfind = string.gfind
local DB = DPSMate.DB
local tnbr = tonumber
local npcdb = DPSMate.NPCDB
local GT = GetTime
local strsub = string.sub
	
----------------------------------------------------------------------------------
--------------                    Нанесенный урон                   --------------                                  
----------------------------------------------------------------------------------
if (GetLocale() == "ruRU") then	
	-- You hit Blazing Elemental for 187.
	-- You crit Blazing Elemental for 400.
	function DPSMate.Parser:SelfHits(msg)
		t = {}
		for a,b,c,d in strgfind(msg, "Вы наносите (.+) (%d+) ед%. урона(.*)%. %(поглощено: (%d+)%)") do
			DB:SetUnregisterVariables(tnbr(d), "АвтоАтака", self.player)
		end
		for b,c,a,d in strgfind(msg, "Вы наносите (.+) (%d+) ед%. урона(.*)%.(.*)") do
			if a~=": критический удар" then t[1]=1;t[2]=0 end
			if d == "(пришелся вскользь)" then t[3]=1;t[1]=0;t[2]=0 elseif d ~= "" then t[4]=1;t[1]=0;t[2]=0 end
			DB:EnemyDamage(true, DPSMateEDT, self.player, "АвтоАтака", t[1] or 0, t[2] or 1, 0, 0, 0, 0, tnbr(c), b, t[4] or 0, t[3] or 0)
			DB:DamageDone(self.player, "АвтоАтака", t[1] or 0, t[2] or 1, 0, 0, 0, 0, tnbr(c), t[3] or 0, t[4] or 0)
			if self.TargetParty[b] then DB:BuildFail(1, b, self.player, "АвтоАтака", tnbr(c));DB:DeathHistory(b, self.player, "АвтоАтака", tnbr(c), t[1] or 0, t[2] or 1, 0, 0) end
			return
		end
		for a in strgfind(msg, "Вы падаете и теряете (%d+) ед%. здоровья%.") do
			DB:DamageTaken(self.player, "Падение", 1, 0, 0, 0, 0, 0, tnbr(a), "Окружение", 0, 0)
			DB:DeathHistory(self.player, "Окружение", "Падение", tnbr(a), 1, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "Вы погружаетесь в лаву и теряете (%d+) ед%. здоровья%.") do
			DB:DamageTaken(self.player, "Лава", 1, 0, 0, 0, 0, 0, tnbr(a), "Окружение", 0, 0)
			DB:DeathHistory(self.player, "Окружение", "Лава", tnbr(a), 1, 0, 0, 0)
			DB:AddSpellSchool("Лава","огонь")
			return
		end
		for a in strgfind(msg, "Вы тонете и теряете (%d+) ед%. здоровья%.") do
			DB:DamageTaken(self.player, "Утопление", 1, 0, 0, 0, 0, 0, tnbr(a), "Окружение", 0, 0)
			DB:DeathHistory(self.player, "Окружение", "Утопление", tnbr(a), 1, 0, 0, 0)
			return
		end
	end
	
	function DPSMate.Parser:SelfMisses(msg)
		-- Filter out immune message --> using them?
		t = {}
		for a in strgfind(msg, "Вы не попадаете по (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, "АвтоАтака", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageDone(self.player, "АвтоАтака", 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
	for ta in strgfind(msg, "(.+) поглощает вашу атаку%.") do DB:Absorb("АвтоАтака", ta, self.player); return end
	for a in strgfind(msg, "(.+) парирует вашу атаку%.") do 
		DB:EnemyDamage(true, DPSMateEDT, self.player, "АвтоАтака", 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
		DB:DamageDone(self.player, "АвтоАтака", 0, 0, 0, 1, 0, 0, 0, 0, 0)
		return
	end
	for a in strgfind(msg, "(.+) уклоняется от вашей атаки%.") do 
		DB:EnemyDamage(true, DPSMateEDT, self.player, "АвтоАтака", 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
		DB:DamageDone(self.player, "АвтоАтака", 0, 0, 0, 0, 1, 0, 0, 0, 0)
		return
	end
	for a in strgfind(msg, "(.+) блокирует вашу атаку%.") do 
		DB:EnemyDamage(true, DPSMateEDT, self.player, "АвтоАтака", 0, 0, 0, 0, 0, 0, 0, a, 1, 0)
		DB:DamageDone(self.player, "АвтоАтака", 0, 0, 0, 0, 0, 0, 0, 0, 1)
		return
	end
end

-- /script for a,b,c,d in string.gfind("Your Fireball hits Firetail Scorpid for 140. (445 blocked)", "You (%a%a?)\it (.+) for (%d+)\.%s?(%a?)") do DPSMate:SendMessage(d) end
-- /script for a,b,c,d,e in string.gfind("Your Fireball hits Firetail Scorpid for 140. (47 resisted)", "Your (.+) (%a%a?)\its (.+) for (%d+)(.*)\.%s?(.*)") do DPSMate:SendMessage(e) end
-- (...) 149 (Fire damage). (50 resisted) -> Some potential?
function DPSMate.Parser:SelfSpellDMG(msg)
	-- Filter out immune message -> using them?
	t = {}
	for a,c,d,b,e,f in strgfind(msg, "Ваше заклинание \"(.+)\" наносит (.+) (%d+) ед%. урона([^:]*)(.*)%.%s%(поглощено%: (%d+)%)") do 
		DB:AddSpellSchool(a,e)
		DB:SetUnregisterVariables(tnbr(f), a, self.player)
	end
	for a,c,d,e,b,f in strgfind(msg, "Ваше заклинание \"(.+)\" наносит (.+) (%d+) ед%. урона([^:]*)(.*)%.%s?(.*)") do 
		t[1] = tnbr(d)
		if b~=": критический эффект" then t[2]=1;t[3]=0 end
		if strfind(e, "заблокировано") then t[4]=1;t[2]=0;t[3]=0 end
		if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(self.player, a, c, GetTime()) end
		if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(self.player, self.player, a, true) end
		DB:EnemyDamage(true, DPSMateEDT, self.player, a,  t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], c, t[4] or 0, 0)
		DB:DamageDone(self.player, a, t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0)
		if self.TargetParty[c] then DB:BuildFail(1, c, self.player, a, t[1]);DB:DeathHistory(c, self.player, a, t[1], t[2] or 0, t[3] or 1, 0, 0) end
		DB:AddSpellSchool(a,e)
		return
	end
	for c,a in strgfind(msg, "(.+) уклоняется от вашего заклинания \"(.+)\"%.") do 
		DB:EnemyDamage(true, DPSMateEDT, self.player, c, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
		DB:DamageDone(self.player, c, 0, 0, 0, 0, 1, 0, 0, 0, 0)
		return
	end
	for c,a in strgfind(msg, "(.+) блокирует ваше заклинание \"(.+)\"%.") do 
		DB:EnemyDamage(true, DPSMateEDT, self.player, c, 0, 0, 0, 0, 0, 0, 0, a, 1, 0)
		DB:DamageDone(self.player, c, 0, 0, 0, 0, 0, 0, 0, 0, 1)
		return
	end
	for c,a in strgfind(msg, "(.+) сопротивляется вашему заклинанию \"(.+)\"%.") do 
		DB:EnemyDamage(true, DPSMateEDT, self.player, c, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
		DB:DamageDone(self.player, c, 0, 0, 0, 0, 0, 1, 0, 0, 0)
		return
	end
	for b,a in strgfind(msg, "(.+) парирует вашу способность \"(.+)\"%.") do 
		DB:EnemyDamage(true, DPSMateEDT, self.player, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
		DB:DamageDone(self.player, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
		return
	end
	for a,b in strgfind(msg, "Ваше заклинание \"(.+)\" не попадает по (.+)%.") do 
		DB:EnemyDamage(true, DPSMateEDT, self.player, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
		DB:DamageDone(self.player, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
		return
	end
	for b,a in strgfind(msg, "(.+) поглощает ваше заклинание \"(.+)\"%.") do
		DB:Absorb(a, b, self.player)
		return
	end
end
	
	-- /script for a,b,c,d,e,f in string.gfind("IanUnderhill suffers 6 Nature damage from your Venom Sting. (6 resisted)", "(.+) suffers (%d+) (%a-) damage from (.+)(%'s?) (.+)%.") do DPSMate:SendMessage(d) end
	function DPSMate.Parser:PeriodicDamage(msg)
		t = {}
		-- (NAME) is afflicted by (ABILITY). => Filtered out for now.
		for a,b in strgfind(msg, "(.+) находится под воздействием эффекта \"(.+)\"%.") do if strfind(b, "%(") then b=strsub(b, 1, strfind(b, "%(")-2) end; DB:ConfirmAfflicted(a, b, GetTime()); if self.CC[b] then  DB:BuildActiveCC(a, b) end; return end
		-- School can be used now but how and when?
		for a,b,c,e,d,f in strgfind(msg, "(.+) получает (%d+) ед%. урона %((.+)%) от заклинания \"(.+)\" (.+)%.(.*)") do
			t[1] = tnbr(b)
			if f~="" then
				DB:SetUnregisterVariables(tnbr(strsub(f, strfind(f, "%d+"))), e.."(Периодический)", d)
			end
			DB:EnemyDamage(true, DPSMateEDT, d, e.."(Периодический)", 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageDone(d, e.."(Периодический)", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
			if self.TargetParty[a] and self.TargetParty[d] then DB:BuildFail(1, a, d, e.."(Периодический)", t[1]);DB:DeathHistory(a, d, e.."(Периодический)", t[1], 1, 0, 0, 0) end
			DB:AddSpellSchool(e.."(Периодический)",c)
			return
		end
		for a,b,c,d,e in strgfind(msg, "(.+) получает (%d+) ед%. урона %((.+)%) от вашего заклинания \"(.+)\"%.(.*)") do
			t[1] = tnbr(b)
			if e~="" then
				DB:SetUnregisterVariables(tnbr(strsub(e, strfind(e, "%d+"))), d.."(Периодический)", self.player)
			end
			DB:EnemyDamage(true, DPSMateEDT, self.player, d.."(Периодический)", 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageDone(self.player, d.."(Периодический)", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
			if self.TargetParty[a] then DB:BuildFail(1, a, self.player, d.."(Периодический)", t[1]);DB:DeathHistory(a, self.player, d.."(Периодический)", t[1], 1, 0, 0, 0) end
			DB:AddSpellSchool(d.."(Периодический)",c)
			return
		end
		for b,a,f in strgfind(msg, "(.+) поглощает заклинание \"(.+)\" (.+)%.") do
			DB:Absorb(a.."(Периодический)", b, f)
			return
		end
		for b,a in strgfind(msg, "(.+) поглощает ваше заклинание \"(.+)\"%.") do
			DB:Absorb(a.."(Периодический)", b, self.player)
			return
		end
	end
	
	-- immune and begins
	function DPSMate.Parser:FriendlyPlayerDamage(msg)
		t = {}
		for a,k,c,d,e,b,f in strgfind(msg, "\"(.+)\" (.+) наносит (.+) (%d+) ед%. урона([^:]*)(.*)%.%s%(поглощено%: (%d+)%)") do 
			DB:AddSpellSchool(a,e)
			DB:SetUnregisterVariables(tnbr(f), a, k)
		end
		for a,f,c,d,e,b in strgfind(msg, "\"(.+)\" (.+) наносит (.+) (%d+) ед%. урона([^:]*)(.*)%.%s?(.*)") do 
			t[1] = tnbr(d)
			if b~=": критический эффект" then t[2]=1;t[3]=0 end
			if strfind(e, "заблокировано") then t[4]=1;t[2]=0;t[3]=0 end
			if c=="вам" then c=self.player end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, c, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, f, a,  t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], c, t[4] or 0, 0)
			DB:DamageDone(f, a, t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[f] and self.TargetParty[c] then DB:BuildFail(1, c, f, a, t[1]);DB:DeathHistory(c, f, a, t[1], t[2] or 0, t[3] or 1, 0, 0) end
			DB:AddSpellSchool(a,e)
			return
		end
		for c,a,f in strgfind(msg, "(.+) уклоняется от заклинания \"(.+)\" (.+)%.") do 
			t[1]=1
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 1, 0, 0, c, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for c,a,f in strgfind(msg, "(.+) блокирует заклинание \"(.+)\" (.+)%.") do 
			t[2]=1
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 0, 0, 0, c, 1, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for c,a,f in strgfind(msg, "(.+) сопротивляется заклинанию \"(.+)\" (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 0, 1, 0, c, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 1, 0, 0, 0)
			return
		end
		for b,a,f in strgfind(msg, "(.+) парирует способность \"(.+)\" (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a,f,b in strgfind(msg, "\"(.+)\" (.+) не попадает по (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for who, what, whom in strgfind(msg, "(.-) прерывает заклинание \"(.+)\" (.+)%.") do
			local causeAbility = "Антимагия"
			if DPSMateUser[who] then
				if DPSMateUser[who][2] == "жрец" then
					causeAbility = "Безмолвие"
				end
			-- Account for felhunter silence
			if DPSMateUser[who][4] and DPSMateUser[who][6] then
				local owner = DPSMate:GetUserById(DPSMateUser[who][6])
				if owner and DPSMateUser[owner] then
					causeAbility = "Запрет чар"
					who = owner
				end
			end
		end
		DPSMate.DB:Kick(who, whom, causeAbility, what)
	end
		for b,a in strgfind(msg, "Вы поглощаете заклинание \"(.+)\" (.+)%.") do
			DB:Absorb(b, self.player, a)
			return
		end
	end
	
	function DPSMate.Parser:FriendlyPlayerHits(msg)
		t = {}
		for a,c,d,b,e in strgfind(msg, "(.+) наносит (.+) (%d+) ед%. урона(.*)%. %(поглощено: (%d+)%)") do
			DB:SetUnregisterVariables(tnbr(e), "АвтоАтака", a)
		end
		for a,c,d,b,e in strgfind(msg, "(.+) наносит (.+) (%d+) ед%. урона(.*)%.(.*)") do
			if b~=": критический удар" then t[3]=1;t[4]=0 end
			if e=="(пришелся вскользь)" then t[1]=1;t[3]=0;t[4]=0 elseif e~="" then t[2]=1;t[3]=0;t[4]=0 end
			if c=="вам" then c=self.player end
			t[5] = tnbr(d)
			DB:EnemyDamage(true, DPSMateEDT, a, "АвтоАтака", t[3] or 0, t[4] or 1, 0, 0, 0, 0, t[5], c, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, "АвтоАтака", t[3] or 0, t[4] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			if self.TargetParty[a] and self.TargetParty[c] then DB:BuildFail(1, c, a, "АвтоАтака", t[5]);DB:DeathHistory(c, a, "АвтоАтака", t[5], t[3] or 0, t[4] or 1, 0, 0) end
			return
		end
		-- (...). (608 absorbed/resisted) -> Therefore here some loss
		for a,b in strgfind(msg, "(.+) погружается в лаву и теряет (%d+) ед%. здоровья%.") do
			DB:DamageTaken(a, "Лава", 1, 0, 0, 0, 0, 0, tnbr(b), "Окружение", 0, 0)
			DB:DeathHistory(a, "Окружение", "Лава", tnbr(b), 1, 0, 0, 0)
			DB:AddSpellSchool("Лава","огонь")
			return
		end
		for a,b in strgfind(msg, "(.+) падает и теряет (%d+) ед%. здоровья%.") do
			DB:DamageTaken(a, "Падение", 1, 0, 0, 0, 0, 0, tnbr(b), "Окружение", 0, 0)
			DB:DeathHistory(a, "Окружение", "Падение", tnbr(b), 1, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) тонет и теряет (%d+) ед%. здоровья%.") do
			DB:DamageTaken(a, "Утопление", 1, 0, 0, 0, 0, 0, tnbr(b), "Окружение", 0, 0)
			DB:DeathHistory(a, "Окружение", "Утопление", tnbr(b), 1, 0, 0, 0)
			return
		end
	end
	
	function DPSMate.Parser:FriendlyPlayerMisses(msg)
		t = {}
		for a,b in strgfind(msg, "(.-) не попадает по (.+)%.") do 
			if b=="вам" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "АвтоАтака", 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(a, "АвтоАтака", 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for ta,c in strgfind(msg, "(.+) поглощает атаку (.+)%.") do  
			DB:Absorb("АвтоАтака", ta, c); 
			return 
		end
		for c in strgfind(msg, "Вы поглощаете атаку (.+)%.") do 
			ta=self.player
			DB:Absorb("АвтоАтака", ta, c); 
			return 
		end
		for b,c,a in strgfind(msg, "(.+) (.-) атаку (.+)%.") do 
			if c=="парирует" or c=="парируете" then t[1]=1 end 
			if b=="Вы" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "АвтоАтака", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, b, t[3] or 0, 0)
			DB:DamageDone(a, "АвтоАтака", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, 0, t[3] or 0)
			return
		end
		for b,c,a in strgfind(msg, "(.+) (.-) от атаки (.+)%.") do 
			if c=="уклоняется" or c=="уклоняетесь" then t[2]=1 end 
			if b=="Вы" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "АвтоАтака", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, b, t[3] or 0, 0)
			DB:DamageDone(a, "АвтоАтака", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, 0, t[3] or 0)
			return
		end
		for b,c,a in strgfind(msg, "(.+) (.-) атаку (.+)%.") do 
			if c=="блокирует" or c=="блокируете" then t[3]=1 end 
			if b=="Вы" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "АвтоАтака", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, b, t[3] or 0, 0)
			DB:DamageDone(a, "АвтоАтака", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, 0, t[3] or 0)
			return
		end
	end
	
	-- You reflect 20 Holy damage to Razzashi Serpent.
	function DPSMate.Parser:SpellDamageShieldsOnSelf(msg)
		t = {}
		for a,b,c in strgfind(msg, "Вы отражаете (%d+) ед%. урона %((.+)%) на (.+)%.") do 
			local am = tnbr(a)
			if c == "вас" then c=self.player end
			DB:EnemyDamage(true, DPSMateEDT, self.player, "Отражение", 1, 0, 0, 0, 0, 0, am, c, 0, 0)
			DB:DamageDone(self.player, "Отражение", 1, 0, 0, 0, 0, 0, am, 0, 0)
		end
		
		-- The rebirth support
		for ta in strgfind(msg, "(.+) поглощает вашу атаку%.") do 
			DB:Absorb("АвтоАтака", ta, self.player); 
			return 
		end
		for c,a in strgfind(msg, "(.+) уклоняется от вашего заклинания \"(.+)\"%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, c, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageDone(self.player, c, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for c,a in strgfind(msg, "(.+) блокирует ваше заклинание \"(.+)\"%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, c, 0, 0, 0, 0, 0, 0, 0, a, 1, 0)
			DB:DamageDone(self.player, c, 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for c,a in strgfind(msg, "(.+) сопротивляется вашему заклинанию \"(.+)\"%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, c, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			DB:DamageDone(self.player, c, 0, 0, 0, 0, 0, 1, 0, 0, 0)
			return
		end
		for b,a in strgfind(msg, "(.+) парирует вашу способность \"(.+)\"%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(self.player, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "Ваше заклинание \"(.+)\" не попадает по (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(self.player, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
	end
	
	-- Helboar reflects 4 Fire damage to you.
	function DPSMate.Parser:SpellDamageShieldsOnOthers(msg)
		t = {}
		for a,b,c,d in strgfind(msg, "(.+) отражает (%d+) ед%. урона %((.+)%) на (.+)%.") do
			local am = tnbr(b)
			if d == "вас" then d=self.player end
			if npcdb:Contains(a) or strfind(a, "%s") then
				DB:EnemyDamage(false, DPSMateEDD, d, "Отражение", 1, 0, 0, 0, 0, 0, am, a, 0, 0)
				DB:DamageTaken(d, "Отражение", 1, 0, 0, 0, 0, 0, am, a, 0, 0)
				DB:DeathHistory(d, a, "Отражение", am, 1, 0, 0, 0)
			else
				DB:EnemyDamage(true, DPSMateEDT, a, "Отражение", 1, 0, 0, 0, 0, 0, am, d, 0, 0)
				DB:DamageDone(a, "Отражение", 1, 0, 0, 0, 0, 0, am, 0, 0)
			end
		end
		
		-- The rebirth support
		for ta,c in strgfind(msg, "(.+) поглощает атаку (.+)%.") do  
			DB:Absorb("АвтоАтака", ta, c); 
			return 
		end
		for c in strgfind(msg, "Вы поглощаете атаку (.+)%.") do 
			ta=self.player
			DB:Absorb("АвтоАтака", ta, c); 
			return 
		end
		for c,a,f in strgfind(msg, "(.+) уклоняется от заклинания \"(.+)\" (.+)%.") do 
			t[1]=1
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 1, 0, 0, c, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for c,a,f in strgfind(msg, "(.+) блокирует заклинание \"(.+)\" (.+)%.") do 
			t[2]=1
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 0, 0, 0, c, 1, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for c,a,f in strgfind(msg, "(.+) сопротивляется заклинанию \"(.+)\" (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 0, 1, 0, c, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 1, 0, 0, 0)
			return
		end
		for b,a,f in strgfind(msg, "(.+) парирует способность \"(.+)\" (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a,f,b in strgfind(msg, "\"(.+)\" (.+) не попадает по (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                    Полученный урон                   --------------                                  
	----------------------------------------------------------------------------------
	
	-- War Reaver hits/crits you for 66 (Fire damage). (45 resisted)
	function DPSMate.Parser:CreatureVsSelfHits(msg)
		t = {}
		for a,c,b,d in strgfind(msg, "(.+) наносит вам (%d+) ед%. урона(.*)%.(.*)") do
			if b~=": критический удар" then t[1]=1;t[2]=0 end
			if strfind(d, "сокрушительный") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(d, "заблокировано") then t[4]=1;t[1]=0;t[2]=0 end
			t[5] = tnbr(c)
			DB:EnemyDamage(false, DPSMateEDD, self.player, "АвтоАтака", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(self.player, "АвтоАтака", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(self.player, a, "АвтоАтака", t[5], t[1] or 0, t[2] or 1, 0, t[3] or 0)
			return
		end
	end
	
	-- Firetail Scorpid attacks. You parry.
	-- Firetail Scorpid attacks. You dodge.
	-- Firetail Scorpid misses you.
	function DPSMate.Parser:CreatureVsSelfMisses(msg)
		t = {}
		for ta in strgfind(msg, "Вы поглощаете атаку (.+)%.") do DB:Absorb("АвтоАтака", self.player, ta); return end
		for a in strgfind(msg, "(.+) не попадает по вам%.") do 
			DB:EnemyDamage(false, DPSMateEDD, self.player, "АвтоАтака", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, "АвтоАтака", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return
		end
		for a in strgfind(msg, "Вы парируете атаку (.+)%.") do 
			DB:EnemyDamage(false, DPSMateEDD, self.player, "АвтоАтака", 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, "АвтоАтака", 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			return
		end
		for a in strgfind(msg, "Вы уклоняетесь от атаки (.+)%.") do 
			DB:EnemyDamage(false, DPSMateEDD, self.player, "АвтоАтака", 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, "АвтоАтака", 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "Вы блокируете атаку (.+)%.") do 
			DB:EnemyDamage(false, DPSMateEDD, self.player, "АвтоАтака", 0, 0, 0, 0, 0, 0, 0, a, 1, 0)
			DB:DamageTaken(self.player, "АвтоАтака", 0, 0, 0, 0, 0, 0, 0, a, 0, 1)
			return
		end
	end 
	
	-- Thaurissan Spy performs Dazed on you. (Implementing it later) !!!!!
	-- Thaurissan Spy's Poison was resisted.
	-- Thaurissan Spy's Backstab hits/crits you for 116.
	-- Flamekin Torcher's Fireball hits/crits you for 86 Fire damage. (School?)
	function DPSMate.Parser:CreatureVsSelfSpellDamage(msg)
		t = {}
		for b,a,d,e,c in strgfind(msg, "\"(.+)\" (.+) наносит вам (%d+) ед%. урона ([^:]*)(.*)%.") do -- Potential here to track school and resisted damage
			if c~=": критический эффект" then t[1]=1;t[2]=0 end
			if strfind(e, "заблокировано") then t[4]=1 end
			t[3] = tnbr(d)
			DB:UnregisterPotentialKick(self.player, b, GetTime())
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[3], a, t[4] or 0, 0)
			DB:DamageTaken(self.player, b, t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[3], a, 0, t[4] or 0)
			DB:DeathHistory(self.player, a, b, t[3], t[1] or 0, t[2] or 1, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, self.player, b, t[3]) end
			DB:AddSpellSchool(b,e)
			return
		end
		for b,a in strgfind(msg, "\"(.+)\" (.+) не попадает по вам%.") do
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return
		end
		for b,a in strgfind(msg, "Вы парируете способность \"(.+)\" (.+)%.") do
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			return
		end
		for b,a in strgfind(msg, "Вы уклоняетесь от заклинания \"(.+)\" (.+)%.") do
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			return
		end
		for b,a in strgfind(msg, "Вы сопротивляетесь заклинанию \"(.+)\" (.+)%.") do
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			return
		end
		for what, whom in strgfind(msg, "Вы прервали заклинание \"(.+)\" (.+)%.") do
			local causeAbility = "Антимагия"
			if DPSMateUser[self.player] then
				if DPSMateUser[self.player][2] == "жрец" then
					causeAbility = "Безмолвие"
				end
			end
			DPSMate.DB:Kick(self.player, whom, causeAbility, what)
		end
		for b,a in strgfind(msg, "Вы поглощаете заклинание \"(.+)\" (.+)%.") do
			DB:Absorb(b, self.player, a)
			return
		end
	end
	
	-- You are afflicted by Dazed. (Implementing it later maybe) !!!!!!
	-- You are afflicted by Infected Bite.
	-- You suffer 8 Nature damage from Ember Worg's Infected Bite. (3 resisted) (School? + resist?)
	function DPSMate.Parser:PeriodicSelfDamage(msg)
		t = {}
		for a,b,d,c,e in strgfind(msg, "Вы получаете (%d+) ед%. урона %((.+)%) от заклинания \"(.+)\" (.+)%.(.*)") do -- Potential to track school and resisted damage
			t[1] = tnbr(a)
			DB:EnemyDamage(false, DPSMateEDD, self.player, d.."(Периодический)", 1, 0, 0, 0, 0, 0, t[1], c, 0, 0)
			DB:DamageTaken(self.player, d.."(Периодический)", 1, 0, 0, 0, 0, 0, t[1], c, 0, 0)
			DB:DeathHistory(self.player, c, d.."(Периодический)", t[1], 1, 0, 0, 0)
			if self.FailDT[d] then DB:BuildFail(2, c, self.player, d, t[1]) end
			DB:AddSpellSchool(d.."(Периодический)",b)
			return
		end
		for a in strgfind(msg, "Вы находитесь под воздействием эффекта \"(.+)\"%.") do
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end
			DB:BuildBuffs("Неизвестно", self.player, a, false)
			if self.CC[a] then DB:BuildActiveCC(self.player, a) end
			return
		end
		for a,b,d,e in strgfind(msg, "Вы получаете (%d+) ед%. урона %((.+)%) от собственного заклинания \"(.+)\"%.(.*)") do -- Potential to track school and resisted damage
			t[1] = tnbr(a)
			DB:EnemyDamage(false, DPSMateEDD, self.player, d.."(Периодический)", 1, 0, 0, 0, 0, 0, t[1], self.player, 0, 0)
			DB:DamageTaken(self.player, d.."(Периодический)", 1, 0, 0, 0, 0, 0, t[1], self.player, 0, 0)
			DB:DeathHistory(self.player, self.player, d.."(Периодический)", t[1], 1, 0, 0, 0)
			DB:AddSpellSchool(d.."(Периодический)",b)
			return
		end
		for b,a in strgfind(msg, "Вы поглощаете заклинание \"(.+)\" (.+)%.") do
			DB:Absorb(b.."(Периодический)", self.player, a)
			return
		end
	end
	
	-- Ember Worg hits/crits Ikaa for 58 (Fire damage). (41 resisted/blocked)
	function DPSMate.Parser:CreatureVsCreatureHits(msg) 
		t = {}
		for a,c,d,b,e in strgfind(msg, "(.+) наносит (.+) (%d+) ед%. урона(.*)%.(.*)") do
			if b~=": критический удар" then t[1]=1;t[2]=0 end
			if strfind(e, "сокрушительный") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(e, "заблокировано") then t[4]=1;t[1]=0;t[2]=0 end
			t[5] = tnbr(d)
			DB:EnemyDamage(false, DPSMateEDD, c, "АвтоАтака", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(c, "АвтоАтака", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(c, a, "АвтоАтака", t[5], t[1] or 0, t[2] or 1, 0, t[3] or 0)
			return
		end
	end
	
	-- Ember Worg attacks. Ikaa parries.
	-- Ember Worg attacks. Ikaa dodges.
	-- Ember Worg misses Ikaa.
	-- Young Wolf attacks. Senpie absorbs all the damage.
	function DPSMate.Parser:CreatureVsCreatureMisses(msg)
		t = {}
		for ta,c in strgfind(msg, "(.+) поглощает атаку (.+)%.") do DB:Absorb("АвтоАтака", ta, c); return end
		for b,a in strgfind(msg, "(.+) парирует атаку (.+)%.") do 
			DB:EnemyDamage(false, DPSMateEDD, b, "АвтоАтака", 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(b, "АвтоАтака", 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			return
		end
		for b,a in strgfind(msg, "(.+) уклоняется от атаки (.+)%.") do 
			DB:EnemyDamage(false, DPSMateEDD, b, "АвтоАтака", 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageTaken(b, "АвтоАтака", 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			return
		end
		for b,a in strgfind(msg, "(.+) блокирует атаку (.+)%.") do 
			t[3]=1
			DB:EnemyDamage(false, DPSMateEDD, b, "АвтоАтака", 0, 0, 0, 0, 0, 0, 0, a, 1, 0)
			DB:DamageTaken(b, "АвтоАтака", 0, 0, 0, 0, 0, 0, 0, a, 0, 1)
			return
		end
		for a,b in strgfind(msg, "(.+) не попадает по (.+)%.") do 
			DB:EnemyDamage(false, DPSMateEDD, b, "АвтоАтака", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(b, "АвтоАтака", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return 
		end
	end
	
	-- Ikaa is afflicted by Infected Bite.
	-- Ikaa suffers 15 Nature damage from Ember Worg's Infected Bite. (3 resisted)
	function DPSMate.Parser:SpellPeriodicDamageTaken(msg)
		t = {}
		for a,b,c,e,d,f in strgfind(msg, "(.+) получает (%d+) ед%. урона %((.+)%) от заклинания \"(.+)\" (.+)%.(.*)") do -- Potential to track resisted damage and school
			t[1] = tnbr(b)
			DB:EnemyDamage(false, DPSMateEDD, a, e.."(Периодический)", 1, 0, 0, 0, 0, 0, t[1], d, 0, 0)
			DB:DamageTaken(a, e.."(Периодический)", 1, 0, 0, 0, 0, 0, t[1], d, 0, 0)
			DB:DeathHistory(a, d, e.."(Периодический)", t[1], 1, 0, 0, 0)
			if self.FailDT[e] then DB:BuildFail(2, d, a, e, t[1]) end
			DB:AddSpellSchool(e.."(Периодический)",c)
			return
		end
		for a, b in strgfind(msg, "(.+) находится под воздействием эффекта \"(.+)\"%.") do
			if strfind(b, "%(") then b=strsub(b, 1, strfind(b, "%(")-2) end
			DB:BuildBuffs("Неизвестно", a,b, false)
			if self.CC[b] then DB:BuildActiveCC(a, b) end
			return
		end
		for b,a,f in strgfind(msg, "(.+) поглощает заклинание \"(.+)\" (.+)%.") do
			DB:Absorb(a.."(Периодический)", f, b)
			return
		end
	end
	
	-- Black Broodling's Fireball was resisted by Ikaa.
	-- Black Broodling's Fireball hits/crits Ikaa for 342 Fire damage. (100 resisted) (School + resist ?)
	function DPSMate.Parser:CreatureVsCreatureSpellDamage(msg)
		t = {}
		for b,a,d,e,f,c in strgfind(msg, "\"(.+)\" (.+) наносит (.+) (%d+) ед%. урона ([^:]*)(.*)%.") do
			if c~=": критический эффект" then t[1]=1;t[2]=0 end
			if strfind(f, "заблокировано") then t[4]=1 end
			t[3] = tnbr(e)
			DB:UnregisterPotentialKick(d, b, GetTime())
			DB:EnemyDamage(false, DPSMateEDD, d, b, t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[3], a, t[4] or 0, 0)
			DB:DamageTaken(d, b, t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[3], a, 0, t[4] or 0)
			DB:DeathHistory(d, a, b, t[3], t[1] or 0, t[2] or 1, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, d, b, t[3]) end
			DB:AddSpellSchool(b,f)
			return
		end
		for c,b,a in strgfind(msg, "(.+) уклоняется от заклинания \"(.+)\" (.+)%.") do
			DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			return
		end
		for c,b,a in strgfind(msg, "(.+) парирует способность \"(.+)\" (.+)%.") do
			DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			return
		end
		for b,a,c in strgfind(msg, "\"(.+)\" (.+) не попадает по (.+)%.") do
			DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return
		end
		for c,b,a in strgfind(msg, "(.+) сопротивляется заклинанию \"(.+)\" (.+)%.") do
			DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			return
		end
		for b,a,f in strgfind(msg, "(.+) поглощает заклинание \"(.+)\" (.+)%.") do
			DB:Absorb(a, f, b)
			return
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                       Исцеление                      --------------                                  
	----------------------------------------------------------------------------------
	
	-- Your Flash of Light heals you for 194.
	-- Your Flash of Light critically heals you for 130.
	-- You cast Purify on Minihunden.
	-- Your Healing Potion heals you for 507.
	-- You gain 25 Energy from Relentless Strikes Effect.
	function DPSMate.Parser:SpellSelfBuff(msg)
		t = {}
		for a,b,c in strgfind(msg, "Ваше заклинание \"(.+)\" исцеляет (.+) на (%d+) ед%. здоровья: критический эффект%.") do 
			if b=="вас" then t[1]=self.player end
			t[2] = tnbr(c)
			overheal = self:GetOverhealByName(t[2], t[1] or b)
			DB:HealingTaken(0, DPSMateHealingTaken, t[1] or b, a, 0, 1, t[2], self.player)
			DB:HealingTaken(1, DPSMateEHealingTaken, t[1] or b, a, 0, 1, t[2]-overheal, self.player)
			DB:Healing(0, DPSMateEHealing, self.player, a, 0, 1, t[2]-overheal, t[1] or b)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, self.player, a, 0, 1, overheal, t[1] or b)
				DB:HealingTaken(2, DPSMateOverhealingTaken, t[1] or b, a, 0, 1, overheal, self.player)
			end
			DB:Healing(1, DPSMateTHealing, self.player, a, 0, 1, t[2], t[1] or b)
			DB:DeathHistory(t[1] or b, self.player, a, t[2], 0, 1, 1, 0)
			return
		end
		for a,b,c in strgfind(msg, "Ваше заклинание \"(.+)\" исцеляет (.+) на (%d+) ед%. здоровья%.") do
			t[3] = 0
			t[4] = 1
			if b=="вас" then t[1]=self.player end
			t[2] = tnbr(c)
			overheal = self:GetOverhealByName(t[2], t[1] or b)
			DB:HealingTaken(0, DPSMateHealingTaken, t[1] or b, a, t[4], t[3], t[2], self.player)
			DB:HealingTaken(1, DPSMateEHealingTaken, t[1] or b, a, t[4], t[3], t[2]-overheal, self.player)
			DB:Healing(0, DPSMateEHealing, self.player, a, t[4], t[3], t[2]-overheal, t[1] or b)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, self.player, a, t[4], t[3], overheal, t[1] or b) 
				DB:HealingTaken(2, DPSMateOverhealingTaken, t[1] or b, a, t[4], t[3], overheal, self.player)
			end
			DB:Healing(1, DPSMateTHealing, self.player, a, t[4], t[3], t[2], t[1] or b)
			DB:DeathHistory(t[1] or b, self.player, a, t[2], t[4], t[3], 1, 0)
			if self.procs[a] and not self.OtherExceptions[a] then
				DB:BuildBuffs(self.player, self.player, a, true)
			end
			return
		end
		for a,b in strgfind(msg, "Вы получаете (%d+) ед%. %(Энергия%) от заклинания \"(.+)\"%.") do -- Potential to gain energy values for class evaluation
			DB:BuildBuffs(self.player, self.player, b, true)
			DB:DestroyBuffs(self.player, b)
			return
		end
		for b,a in strgfind(msg, "\"(.+)\" дает вам (%d) дополнительную атаку%.") do -- Potential for more evaluation
			DB.NextSwing[self.player] = {
				[1] = tnbr(a),
				[2] = b
			}
			DB.NextSwingEDD[self.player] = {
				[1] = tnbr(a),
				[2] = b
			}
			DB:BuildBuffs(self.player, self.player, b, true)
			DB:DestroyBuffs(self.player, b)
			return
		end
		for b,a in strgfind(msg, "\"(.+)\" дает вам (%d) дополнительных атаки%.") do -- Potential for more evaluation
			DB.NextSwing[self.player] = {
				[1] = tnbr(a),
				[2] = b
			}
			DB.NextSwingEDD[self.player] = {
				[1] = tnbr(a),
				[2] = b
			}
			DB:BuildBuffs(self.player, self.player, b, true)
			DB:DestroyBuffs(self.player, b)
			return
		end
		for a,b in strgfind(msg, "Вы получаете (%d+) ед%. %(Ярость%) от заклинания \"(.+)\"%.") do
			if self.procs[b] and not self.OtherExceptions[b] then
				DB:BuildBuffs(self.player, self.player, b, true)
				DB:DestroyBuffs(self.player, b)
			end
			return
		end	
		for a,b in strgfind(msg, "Вы получаете (%d+) ед%. %(Мана%) от заклинания \"(.+)\"%.") do
			if self.procs[b] then
				DB:BuildBuffs(self.player, self.player, b, true)
				DB:DestroyBuffs(self.player, b)
			end
			return
		end	
	end
	
	-- You gain First Aid.
	-- You gain Mark of the Wild.
	-- You gain Thorns.
	-- You gain 11 health from First Aid.
	-- You gain 61 health from Nenea's Rejuvenation.
	function DPSMate.Parser:SpellPeriodicSelfBuff(msg) -- Maybe some loss here?
		t = {}
		for a,c,b in strgfind(msg, "Вы получаете (%d+) ед%. здоровья от заклинания \"(.+)\" (.+)%.") do
			t[1]=tnbr(a)
			overheal = self:GetOverhealByName(t[1], self.player)
			DB:HealingTaken(0, DPSMateHealingTaken, self.player, c.."(Периодический)", 1, 0, t[1], b)
			DB:HealingTaken(1, DPSMateEHealingTaken, self.player, c.."(Периодический)", 1, 0, t[1]-overheal, b)
			DB:Healing(0, DPSMateEHealing, b, c.."(Периодический)", 1, 0, t[1]-overheal, self.player)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, b, c.."(Периодический)", 1, 0, overheal, self.player)
				DB:HealingTaken(2, DPSMateOverhealingTaken, self.player, c.."(Периодический)", 1, 0, overheal, b)
			end
			DB:Healing(1, DPSMateTHealing, b, c.."(Периодический)", 1, 0, t[1], self.player)
			DB:DeathHistory(self.player, b, c.."(Периодический)", t[1], 1, 0, 1, 0)
			return
		end
		for a,b in strgfind(msg, "Вы получаете (%d+) ед%. здоровья от заклинания \"(.+)\"%.") do 
			t[1] = tnbr(a)
			overheal = self:GetOverhealByName(t[1], self.player)
			DB:HealingTaken(0, DPSMateHealingTaken, self.player, b.."(Периодический)", 1, 0, t[1], self.player)
			DB:HealingTaken(1, DPSMateEHealingTaken, self.player, b.."(Периодический)", 1, 0, t[1]-overheal, self.player)
			DB:Healing(0, DPSMateEHealing, self.player, b.."(Периодический)", 1, 0, t[1]-overheal, self.player)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, self.player, b.."(Периодический)", 1, 0, overheal, self.player)
				DB:HealingTaken(2, DPSMateOverhealingTaken, self.player, b.."(Периодический)", 1, 0, overheal, self.player)
			end
			DB:Healing(1, DPSMateTHealing, self.player, b.."(Периодический)", 1, 0, t[1], self.player)
			DB:DeathHistory(self.player, self.player, b.."(Периодический)", t[1], 1, 0, 1, 0)
			return
		end
		for a in strgfind(msg, "Вы получаете эффект \"(.+)\"%.") do
			if strfind(a, "от") then return end
			if self.BuffExceptions[a] then return end;
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end -- Unstable Power (12)
			DB:ConfirmBuff(self.player, a, GetTime())
			if DPSMate.Parser.Dispels[a] then 
				DB:RegisterHotDispel(self.player, a)
				--DB:AwaitDispel(a, self.player, "Неизвестно", GetTime());
			end
			if self.RCD[a] then DPSMate:Broadcast(1, self.player, a) end
			if self.FailDB[a] then DB:BuildFail(3, "Окружение", self.player, a, 0) end
			return 
		end
	end
	
	-- Catrala gains Last Stand.
	-- Raptor gains 35 Happiness from Giggity's Feed Pet Effect. --> Causes error
	-- Sivir gains 11 health from your First Aid.
	-- Sivir gains 11 health from Albea's First Aid.
	-- Soulstoke gains 25 Energy from Soulstoke's Relentless Strikes Effect.
	function DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(msg)
		t = {}
		for f,a,c,b in strgfind(msg, "(.+) получает (%d+) ед%. здоровья от заклинания \"(.+)\" (.+)%.") do
			t[1]=tnbr(a)
			overheal = self:GetOverhealByName(t[1], f)
			DB:HealingTaken(0, DPSMateHealingTaken, f, c.."(Периодический)", 1, 0, t[1], b)
			DB:HealingTaken(1, DPSMateEHealingTaken, f, c.."(Периодический)", 1, 0, t[1]-overheal, b)
			DB:Healing(0, DPSMateEHealing, b, c.."(Периодический)", 1, 0, t[1]-overheal, f)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, b, c.."(Периодический)", 1, 0, overheal, f)
				DB:HealingTaken(2, DPSMateOverhealingTaken, f, c.."(Периодический)", 1, 0, overheal, b)
			end
			DB:Healing(1, DPSMateTHealing, b, c.."(Периодический)", 1, 0, t[1], f)
			DB:DeathHistory(f, b, c.."(Периодический)", t[1], 1, 0, 1, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.+) получает (%d+) ед%. здоровья от вашего заклинания \"(.+)\".") do 
			t[1] = tnbr(a)
			overheal = self:GetOverhealByName(t[1], f)
			DB:HealingTaken(0, DPSMateHealingTaken, f, b.."(Периодический)", 1, 0, t[1], self.player)
			DB:HealingTaken(1, DPSMateEHealingTaken, f, b.."(Периодический)", 1, 0, t[1]-overheal, self.player)
			DB:Healing(0, DPSMateEHealing, self.player, b.."(Периодический)", 1, 0, t[1]-overheal)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, self.player, b.."(Периодический)", 1, 0, overheal)
				DB:HealingTaken(2, DPSMateOverhealingTaken, f, b.."(Периодический)", 1, 0, overheal, self.player)
			end
			DB:Healing(1, DPSMateTHealing, self.player, b.."(Периодический)", 1, 0, t[1])
			DB:DeathHistory(f, self.player, b.."(Периодический)", t[1], 1, 0, 1, 0)
			return
		end
		for f,a in strgfind(msg, "(.-) получает эффект \"(.+)\"%.") do
			if strfind(a, "от") then return end
			if self.BuffExceptions[a] then return end;
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end -- Unstable Power (12)
			DB:ConfirmBuff(f, a, GetTime())
			if DPSMate.Parser.Dispels[a] then
				DB:RegisterHotDispel(f, a)
				--DB:AwaitDispel(a, f, "Неизвестно", GetTime());
			end
			if self.RCD[a] then DPSMate:Broadcast(1, f, a) end
			if self.FailDB[a] then DB:BuildFail(3, "Окружение", f, a, 0) end
			return 
		end
	end
	
	-- A1bea's Flash of Light heals you/Baz for 90.
	-- Albea's Flash of Light critically heals you/Baz for 135.
	-- if strfind(msg, "begins to") or strfind(msg, "Rage") then return end
	function DPSMate.Parser:SpellHostilePlayerBuff(msg)
		t = {}
		for a,b,c,d in strgfind(msg, "(.-) применяет заклинание \"(.+)\" и исцеляет (.+) на (%d+) ед%. здоровья: критический эффект%.") do 
			t[1] = tnbr(d)
			if c=="вас" then t[2]=self.player end
			overheal = self:GetOverhealByName(t[1], t[2] or c)
			DB:HealingTaken(0, DPSMateHealingTaken, t[2] or c, b, 0, 1, t[1], a)
			DB:HealingTaken(1, DPSMateEHealingTaken, t[2] or c, b, 0, 1, t[1]-overheal, a)
			DB:Healing(0, DPSMateEHealing, a, b, 0, 1, t[1]-overheal, t[2] or c)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, a, b, 0, 1, overheal, t[2] or c)
				DB:HealingTaken(2, DPSMateOverhealingTaken, t[2] or c, b, 0, 1, overheal, a)
			end
			DB:Healing(1, DPSMateTHealing, a, b, 0, 1, t[1], t[2] or c)
			DB:DeathHistory(t[2] or c, a, b, t[1], 0, 1, 1, 0)
			return
		end
		for a,b,c,d in strgfind(msg, "(.-) применяет заклинание \"(.+)\" и исцеляет (.+) на (%d+) ед%. здоровья%.") do 
			t[1] = tnbr(d)
			t[4] = 1
			t[3] = 0
			if c=="вас" then t[2]=self.player end
			overheal = self:GetOverhealByName(t[1], t[2] or c)
			DB:HealingTaken(0, DPSMateHealingTaken, t[2] or c, b, t[4], t[3], t[1], a)
			DB:HealingTaken(1, DPSMateEHealingTaken, t[2] or c, b, t[4], t[3], t[1]-overheal, a)
			DB:Healing(0, DPSMateEHealing, a, b, t[4], t[3], t[1]-overheal, t[2] or c)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, a, b, t[4], t[3], overheal, t[2] or c)
				DB:HealingTaken(2, DPSMateOverhealingTaken, t[2] or c, b, t[4], t[3], overheal, a)
			end
			DB:Healing(1, DPSMateTHealing, a, b, t[4], t[3], t[1], t[2] or c)
			DB:DeathHistory(t[2] or c, a, b, t[1], t[4], t[3], 1, 0)
			if self.procs[b] and not self.OtherExceptions[b] then
				DB:BuildBuffs(a, c, b, true)
			end
			return
		end
		for a,b in strgfind(msg, "(.+) начинает использовать \"(.+)\"%.")  do
			DB:RegisterPotentialKick(a, b, GetTime())
			return
		end
		for a,b,d,c in strgfind(msg, "(.+) получает (%d+) ед%. %(Энергия%) от заклинания \"(.+)\" (.+)%.") do
			DB:BuildBuffs(c, a, d, true)
			DB:DestroyBuffs(c, d)
			return 
		end
		for c,a,b in strgfind(msg, "\"(.+)\" дает (.+) (%d+) дополнительную атаку%.") do
			DB.NextSwing[a] = {
				[1] = tnbr(b),
				[2] = c
			}
			DB.NextSwingEDD[a] = {
				[1] = tnbr(b),
				[2] = c
			}
			DB:BuildBuffs(a, a, c, true)
			DB:DestroyBuffs(a, c)
			return 
		end
		for c,a,b in strgfind(msg, "\"(.+)\" дает (.+) (%d+) дополнительных атаки%.") do
			DB.NextSwing[a] = {
				[1] = tnbr(b),
				[2] = c
			}
			DB.NextSwingEDD[a] = {
				[1] = tnbr(b),
				[2] = c
			}
			DB:BuildBuffs(a, a, c, true)
			DB:DestroyBuffs(a, c)
			return 
		end
		for a,b,d,c in strgfind(msg, "(.+) получает (%d+) ед%. %(Ярость%) от заклинания \"(.+)\" (.+)%.") do
			if self.procs[d] and not self.OtherExceptions[d] then
				DB:BuildBuffs(c, a, d, true)
				DB:DestroyBuffs(c, d)
			end
			return 
		end
		for a,b,d,c in strgfind(msg, "(.+) получает (%d+) ед%. %(Мана%) от заклинания \"(.+)\" (.+)%.") do
			if self.procs[d] then
				DB:BuildBuffs(c, a, d, true)
				DB:DestroyBuffs(c, d)
			end
			return 
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                       Поглощение                     --------------                                  
	----------------------------------------------------------------------------------
	
	-- Heavy War Golem hits/crits you for 8. (111 resisted) (59 absorbed)
	function DPSMate.Parser:CreatureVsSelfHitsAbsorb(msg)
		for c, a, b, ka, absorbed in strgfind(msg, "Вы наносите (.+) (%d+) ед%. урона(.*)%.(.*)%(поглощено: (%d+)%)") do DB:SetUnregisterVariables(tnbr(absorbed), "АвтоАтака", c) end
	end
	
	function DPSMate.Parser:CreatureVsCreatureHitsAbsorb(msg)
		for c, a, d, b, ka, absorbed in strgfind(msg, "(.+) наносит (.+) (%d+) ед%. урона(.*)%.(.*)%(поглощено: (%d+)%)") do DB:SetUnregisterVariables(tnbr(absorbed), "АвтоАтака", c) end
	end
	
	-- Heavy War Golem's Trample hits/crits you for 51 (Fire damage). (48 absorbed)
	function DPSMate.Parser:CreatureVsSelfSpellDamageAbsorb(msg)
		for ab, c, a,ka, b, absorbed in strgfind(msg, "\"(.+)\" (.+) наносит вам (%d+) ед%. урона ([^:]*)(.*)%.%(поглощено: (%d+)%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, c) end
	end
	
	function DPSMate.Parser:CreatureVsCreatureSpellDamageAbsorb(msg)
		for ab, c, a, x, ka, b, absorbed in strgfind(msg, "\"(.+)\" (.+) наносит (.+) (.+) ед%. урона ([^:]*)(.*)%.%(поглощено: (%d+)%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, c) end
	end
	
	function DPSMate.Parser:SpellPeriodicSelfBuffAbsorb(msg)
		for ab in strgfind(msg, "Вы получаете эффект \"(.+)\"%.") do if DB.ShieldFlags[ab] then DB:ConfirmAbsorbApplication(ab, self.player, GetTime()) end end
	end
	
	function DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffsAbsorb(msg)
		for ta, ab in strgfind(msg, "(.-) получает эффект \"(.+)\"%.") do if DB.ShieldFlags[ab] then DB:ConfirmAbsorbApplication(ab, ta, GetTime()) end end
	end
	
	-- Power Word: Shield fades from you.
	function DPSMate.Parser:SpellAuraGoneSelf(msg)
		for ab in strgfind(msg, "Действие эффекта \"(.+)\", наложенного на вас, заканчивается%.") do if self.BuffExceptions[ab] then return end; if strfind(ab, "%(") then ab=strsub(ab, 1, strfind(ab, "%(")-2) end; if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, self.player) end; if self.RCD[ab] then DPSMate:Broadcast(6, self.player, ab) end; DB:DestroyBuffs(self.player, ab); DB:UnregisterHotDispel(self.player, ab); DB:RemoveActiveCC(self.player, ab) end
	end
	
	-- Power Word: Shield fades from Senpie.
	function DPSMate.Parser:SpellAuraGoneParty(msg)
		--DPSMate:SendMessage(msg)
		for ab, ta in strgfind(msg, "Действие эффекта \"(.+)\", наложенного на (.-), заканчивается%.") do if self.BuffExceptions[ab] then return end; if strfind(ab, "%(") then ab=strsub(ab, 1, strfind(ab, "%(")-2) end;if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, ta) end; if self.RCD[ab] then DPSMate:Broadcast(6, ta, ab) end; DB:DestroyBuffs(ta, ab); DB:UnregisterHotDispel(ta, ab); DB:RemoveActiveCC(ta, ab) end
	end
	
	function DPSMate.Parser:SpellAuraGoneOther(msg)
		for ab, ta in strgfind(msg, "Действие эффекта \"(.+)\", наложенного на (.-), заканчивается%.") do if self.BuffExceptions[ab] then return end; if strfind(ab, "%(") then ab=strsub(ab, 1, strfind(ab, "%(")-2) end;if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, ta) end; if self.RCD[ab] then DPSMate:Broadcast(6, ta, ab) end; DB:DestroyBuffs(ta, ab); DB:UnregisterHotDispel(ta, ab); DB:RemoveActiveCC(ta, ab) end
	end
	
	----------------------------------------------------------------------------------
	--------------                       Рассеивание                    --------------                                  
	----------------------------------------------------------------------------------
	
	-- You gain Abolish Poison.
	-- Abolish Poison fades from you.
	-- Your Poison is removed.
	
	-- Is it really "yourself"?
	function DPSMate.Parser:SpellSelfBuffDispels(msg)
		for ab, tar in strgfind(msg, "Вы применяете заклинание \"(.+)\" на (.-)%.") do if DPSMate.Parser.Dispels[ab] then DB:AwaitDispel(ab, tar, self.player, GetTime()) end; if self.RCD[ab] then DPSMate:Broadcast(2, self.player, tar, ab) end; return end
		for ab in strgfind(msg, "Вы применяете заклинание \"(.+)\"%.") do if DPSMate.Parser.Dispels[ab] then DB:AwaitDispel(ab, self.player, self.player, GetTime()) end; return end
	end
	
	-- Avrora casts Remove Curse on you.
	-- Avrora casts Remove Curse on Avrora.
	function DPSMate.Parser:SpellHostilePlayerBuffDispels(msg)
		for c, ab, ta in strgfind(msg, "(.+) применяет заклинание \"(.+)\" на (.-)%.") do 
			if DPSMate.Parser.Dispels[ab] then DB:AwaitDispel(ab, ta, c, GetTime()) end; 
			if self.RCD[ab] then DPSMate:Broadcast(2, c, ta, ab) end; 
			return 
		end
		for c, ab in strgfind(msg, "(.+) применяет на вас заклинание \"(.+)\"%.") do 
			ta = self.player
			if DPSMate.Parser.Dispels[ab] then DB:AwaitDispel(ab, ta, c, GetTime()) end; 
			if self.RCD[ab] then DPSMate:Broadcast(2, c, ta, ab) end; 
			return 
		end
		for c, ab in strgfind(msg, "(.+) применяет заклинание \"(.+)\"%.") do if DPSMate.Parser.Dispels[ab] then DB:AwaitDispel(ab, "Неизвестно", c, GetTime()) end; return end
	end
	
	-- Avrora's Curse of Agony is removed.
	-- Your Curse of Agony is removed.
	function DPSMate.Parser:SpellBreakAura(msg) 
		for ta, ab in strgfind(msg, "(.-) теряет \"(.+)\"%.") do DB:ConfirmRealDispel(ab, ta, GetTime()); return end
		for ab in strgfind(msg, "Вы теряете \"(.+)\"%.") do DB:ConfirmRealDispel(ab, self.player, GetTime()); return end
	end
	
	----------------------------------------------------------------------------------
	--------------                       Смерти                         --------------                                  
	----------------------------------------------------------------------------------
	
	-- You die.
	-- Senpie dies.
	function DPSMate.Parser:CombatFriendlyDeath(msg)
		for ta in strgfind(msg, "(.-) (.-)%.") do if ta=="Вы" then DB:UnregisterDeath(self.player) else DB:UnregisterDeath(ta) end end
	end
	
	function DPSMate.Parser:CombatHostileDeaths(msg)
		for ta in strgfind(msg, "(.+) погибает%.") do 
			DB:UnregisterDeath(ta)
			DB:Attempt(false, true, ta)
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                     Прерывания                       --------------                                  
	----------------------------------------------------------------------------------
	
	-- Scalding Broodling begins to cast Fireball.
	function DPSMate.Parser:CreatureVsCreatureSpellDamageInterrupts(msg)
		for c, ab in strgfind(msg, "(.+) начинает использовать \"(.+)\"%.") do DB:RegisterPotentialKick(c, ab, GetTime()); return end
		for c, ab in strgfind(msg, "(.+) начинает выполнять действие \"(.+)\"%.") do DB:RegisterPotentialKick(c, ab, GetTime()) end
	end
	function DPSMate.Parser:HostilePlayerSpellDamageInterrupts(msg)
		for c, ab in strgfind(msg, "(.-) начинает использовать \"(.+)\"%.") do DB:RegisterPotentialKick(c, ab, GetTime()); return end
		for c, ab in strgfind(msg, "(.-) начинает выполнять действие \"(.+)\"%.") do DB:RegisterPotentialKick(c, ab, GetTime()) end
	end
	
	-- Legacy Logs support
	-- You receive loot: [White Spider Meat] (Itemlink)
	-- Shino receives loot: [White Spider Meat] (Itemlink)
	-- Itemlink: \124cffffffff\124Hitem:8956:0:0:0:0:0:0:0:0\124h[Oil of Immolation]\124h\124r (White)
	-- Itemlink: \124cffa335ee\124Hitem:19352:0:0:0:0:0:0:0:0\124h[Chromatically Tempered Sword]\124h\124r (Epic)
	local linkQuality = {
		["9d9d9d"] = 0,
		["ffffff"] = 1,
		["1eff00"] = 2,
		["0070dd"] = 3,
		["a335ee"] = 4,
		["ff8000"] = 5
	}
	function DPSMate.Parser:Loot(msg)
		for a,b,c,d,e in strgfind(msg, "(.-) получает добычу: |cff(.-)|Hitem:(%d+)(.+)%[(.+)%]|h|r") do
			DB:Loot(a, linkQuality[b], tnbr(c), e)
			return
		end
		for a,b,c,d in strgfind(msg, "Ваша добыча: |cff(.-)|Hitem:(%d+)(.+)%[(.+)%]|h|r") do
			DB:Loot(self.player, linkQuality[a], tnbr(b), d)
			return
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                     Питомец                          --------------                                  
	----------------------------------------------------------------------------------
	
	function DPSMate.Parser:PetHits(msg)
		t = {}
		for a,c,d,b,e in strgfind(msg, "(.-) наносит (.-) (%d+) ед%. урона(.*)%.(.*)") do
			if b~=": критический удар" then t[3]=1;t[4]=0 end
			if e=="(пришелся вскользь)" then t[1]=1;t[3]=0;t[4]=0 elseif e~="" then t[2]=1;t[3]=0;t[4]=0 end
			if c=="вам" then c=self.player end
			t[5] = tnbr(d)
			DB:EnemyDamage(true, DPSMateEDT, a, "АвтоАтака", t[3] or 0, t[4] or 1, 0, 0, 0, 0, t[5], c, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, "АвтоАтака", t[3] or 0, t[4] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			return
		end
	end
	
	function DPSMate.Parser:PetMisses(msg)
		t = {}
		for a,b in strgfind(msg, "(.-) не попадает по (.+)%.") do 
			if b=="вам" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "АвтоАтака", 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(a, "АвтоАтака", 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for b,c,a in strgfind(msg, "(.+) (.-) атаку (.+)%.") do 
			if c=="парирует" or c=="парируете" then t[1]=1 end 
			if b=="Вы" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "АвтоАтака", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, b, t[3] or 0, 0)
			DB:DamageDone(a, "АвтоАтака", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, 0, t[3] or 0)
			return
		end
		for b,c,a in strgfind(msg, "(.+) (.-) от атаки (.+)%.") do 
			if c=="dodges" or c=="dodge" then t[2]=1 end 
			if b=="Вы" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "АвтоАтака", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, b, t[3] or 0, 0)
			DB:DamageDone(a, "АвтоАтака", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, 0, t[3] or 0)
			return
		end
		for b,c,a in strgfind(msg, "(.+) (.-) атаку (.+)%.") do 
			if c=="блокирует" or c=="блокируете" then t[3]=1 end 
			if b=="Вы" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "АвтоАтака", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, b, t[3] or 0, 0)
			DB:DamageDone(a, "АвтоАтака", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, 0, t[3] or 0)
			return
		end
	end
	
	-- Marktast casts bla on bla.
	function DPSMate.Parser:PetSpellDamage(msg)
		t = {}
		for a,f,c,d,e,b in strgfind(msg, "\"(.+)\" (.-) наносит (.+) (%d+) ед%. урона([^:]*)(.*)%.%s?(.*)") do 
			t[1] = tnbr(d)
			if b~=": критический эффект" then t[2]=1;t[3]=0 end
			if strfind(e, "заблокировано") then t[4]=1;t[2]=0;t[3]=0 end
			if c=="вам" then c=self.player end
			DB:EnemyDamage(true, DPSMateEDT, f, a,  t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], c, t[4] or 0, 0)
			DB:DamageDone(f, a, t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			return
		end
		for c,b,a in strgfind(msg, "(.+) сопротивляется заклинанию \"(.+)\" (.-)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, a, b,  0, 0, 0, 0, 0, 1, 0, c, t[4] or 0, 0)
			DB:DamageDone(a, c, 0, 0, 0, 0, 0, 1, 0, 0, 0)
			return
		end
		for b,a in strgfind(msg, "Вы сопротивляетесь заклинанию \"(.+)\" (.-)%.") do 
			c=self.player
			DB:EnemyDamage(true, DPSMateEDT, a, b,  0, 0, 0, 0, 0, 1, 0, c, t[4] or 0, 0)
			DB:DamageDone(a, c, 0, 0, 0, 0, 0, 1, 0, 0, 0)
			return
		end
		for c,a,f in strgfind(msg, "(.+) уклоняется от заклинания \"(.+)\" (.-)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 1, 0, 0, c, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for c,a,f in strgfind(msg, "(.+) блокирует заклинание \"(.+)\" (.-)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 0, 0, 0, c, 1, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for c,a,f in strgfind(msg, "(.+) сопротивляется заклинанию \"(.+)\" (.-)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 0, 1, 0, c, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 1, 0, 0, 0)
			return
		end
		for b,a,f in strgfind(msg, "(.+) парирует способность \"(.+)\" (.-)%.") do
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a,f,b in strgfind(msg, "\"(.+)\" (.-) не попадает по (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
	end
end