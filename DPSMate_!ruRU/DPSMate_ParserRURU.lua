-- Version : Russian ( by Maus - vk.com/wowruru)

local t = {}
local strgfind = string.gfind
local DB = DPSMate.DB
local tnbr = tonumber
local npcdb = NPCDB
local GT = GetTime
local strsub = string.sub
local strfind = string.find
	
----------------------------------------------------------------------------------
--------------                    Нанесенный урон                   --------------                                  
----------------------------------------------------------------------------------
if (GetLocale() == "ruRU") then	
	function DPSMate.Parser:SelfHits(msg)
		for a,b,c,d in strgfind(msg, "Вы наносите (.+) (%d+) ед%. урона(.*)%. %(поглощено: (%d+)%)") do
			DB:SetUnregisterVariables(tnbr(d), "АвтоАтака", self.player)
		end
		for b,c,a,d in strgfind(msg, "Вы наносите (.+) (%d+) ед%. урона(.*)%.(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if a~=": критический удар" then t[1]=1;t[2]=0 end
			if d == "(пришелся вскользь)" then t[3]=1;t[1]=0;t[2]=0 elseif d ~= "" then t[4]=1;t[1]=0;t[2]=0 end
			DB:EnemyDamage(true, DPSMateEDT, self.player, "АвтоАтака", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], b, t[4] or 0, t[3] or 0)
			DB:DamageDone(self.player, "АвтоАтака", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], t[3] or 0, t[4] or 0)
			if self.TargetParty[b] then DB:BuildFail(1, b, self.player, "АвтоАтака", t[5]);DB:DeathHistory(b, self.player, "АвтоАтака", t[5], t[1] or 0, t[2] or 1, 0, 0) end
			return
		end
		for a in strgfind(msg, "Вы падаете и теряете (%d+) ед%. здоровья%.") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "Падение", 1, 0, 0, 0, 0, 0, t[1], "Окружение", 0, 0)
			DB:DeathHistory(self.player, "Окружение", "Падение", t[1], 1, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "Вы погружаетесь в лаву и теряете (%d+) ед%. здоровья%.") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "Лава", 1, 0, 0, 0, 0, 0, t[1], "Окружение", 0, 0)
			DB:DeathHistory(self.player, "Окружение", "Лава", t[1], 1, 0, 0, 0)
			DB:AddSpellSchool("Лава","огонь")
			return
		end
		for a in strgfind(msg, "Вы тонете и теряете (%d+) ед%. здоровья%.") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "Утопление", 1, 0, 0, 0, 0, 0, t[1], "Окружение", 0, 0)
			DB:DeathHistory(self.player, "Окружение", "Утопление", t[1], 1, 0, 0, 0)
			return
		end
	end
	
	function DPSMate.Parser:SelfMisses(msg)
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

	function DPSMate.Parser:SelfSpellDMG(msg)
		for a,c,d,b,e,f in strgfind(msg, "Ваше заклинание \"(.+)\" наносит (.+) (%d+) ед%. урона([^:]*)(.*)%.%s%(поглощено%: (%d+)%)") do 
			DB:AddSpellSchool(a,e)
			DB:SetUnregisterVariables(tnbr(f), a, self.player)
		end
		for a,c,d,e,b,f in strgfind(msg, "Ваше заклинание \"(.+)\" наносит (.+) (%d+) ед%. урона([^:]*)(.*)%.%s?(.*)") do 
			t = {tnbr(d), false, false, false}
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
	
	function DPSMate.Parser:PeriodicDamage(msg)
		for a,b in strgfind(msg, "(.+) находится под воздействием эффекта \"(.+)\"%.") do if strfind(b, "%(") then b=strsub(b, 1, strfind(b, "%(")-2) end; DB:ConfirmAfflicted(a, b, GetTime()); if self.CC[b] then  DB:BuildActiveCC(a, b) end; return end
		for a,b,c,e,d,f in strgfind(msg, "(.+) получает (%d+) ед%. урона %((.+)%) от заклинания \"(.+)\" (.+)%.(.*)") do
			t = {tnbr(b)}
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
			t = {tnbr(b)}
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
	
	function DPSMate.Parser:FriendlyPlayerDamage(msg)
		for a,k,c,d,e,b,f in strgfind(msg, "\"(.+)\" (.+) наносит (.+) (%d+) ед%. урона([^:]*)(.*)%.%s%(поглощено%: (%d+)%)") do 
			DB:AddSpellSchool(a,e)
			DB:SetUnregisterVariables(tnbr(f), a, k)
		end
		for a,f,c,d,e,b in strgfind(msg, "\"(.+)\" (.+) наносит (.+) (%d+) ед%. урона([^:]*)(.*)%.%s?(.*)") do 
			t = {tnbr(d), false, false, false}
			if b~=": критический эффект" then t[2]=1;t[3]=0 end
			if strfind(e, "заблокировано") then t[4]=1;t[2]=0;t[3]=0 end
			if c=="вам" then c=self.player end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, c, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, f, a,  t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], c, t[4] or 0, 0)
			DB:DamageDone(f, a, t[2] or 0, t[3] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[c] then 
				if self.TargetParty[f] then
					DB:BuildFail(1, c, f, a, t[1]);
				end
				DB:DeathHistory(c, f, a, t[1], t[2] or 0, t[3] or 1, 0, 0) end
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
		DB:Kick(who, whom, causeAbility, what)
	end
		for b,a in strgfind(msg, "Вы поглощаете заклинание \"(.+)\" (.+)%.") do
			DB:Absorb(b, self.player, a)
			return
		end
	end
	
	function DPSMate.Parser:FriendlyPlayerHits(msg)
		for a,c,d,b,e in strgfind(msg, "(.+) наносит (.+) (%d+) ед%. урона(.*)%. %(поглощено: (%d+)%)") do
			DB:SetUnregisterVariables(tnbr(e), "АвтоАтака", a)
		end
		for a,c,d,b,e in strgfind(msg, "(.+) наносит (.+) (%d+) ед%. урона(.*)%.(.*)") do
			t = {false, false, false, false, tnbr(d)}
			if b~=": критический удар" then t[3]=1;t[4]=0 end
			if e=="(пришелся вскользь)" then t[1]=1;t[3]=0;t[4]=0 elseif e~="" then t[2]=1;t[3]=0;t[4]=0 end
			if c=="вам" then c=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "АвтоАтака", t[3] or 0, t[4] or 1, 0, 0, 0, 0, t[5], c, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, "АвтоАтака", t[3] or 0, t[4] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			if self.TargetParty[c] then 
				if self.TargetParty[a] then
					DB:BuildFail(1, c, a, "АвтоАтака", t[5]);
				end
				DB:DeathHistory(c, a, "АвтоАтака", t[5], t[3] or 0, t[4] or 1, 0, 0) end
			return
		end
		for a,b in strgfind(msg, "(.+) погружается в лаву и теряет (%d+) ед%. здоровья%.") do
			t = {tnbr(b)}
			DB:DamageTaken(a, "Лава", 1, 0, 0, 0, 0, 0, t[1], "Окружение", 0, 0)
			DB:DeathHistory(a, "Окружение", "Лава", t[1], 1, 0, 0, 0)
			DB:AddSpellSchool("Лава","огонь")
			return
		end
		for a,b in strgfind(msg, "(.+) падает и теряет (%d+) ед%. здоровья%.") do
			t = {tnbr(b)}
			DB:DamageTaken(a, "Падение", 1, 0, 0, 0, 0, 0, t[1], "Окружение", 0, 0)
			DB:DeathHistory(a, "Окружение", "Падение", t[1], 1, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) тонет и теряет (%d+) ед%. здоровья%.") do
			t = {tnbr(b)}
			DB:DamageTaken(a, "Утопление", 1, 0, 0, 0, 0, 0, t[1], "Окружение", 0, 0)
			DB:DeathHistory(a, "Окружение", "Утопление", t[1], 1, 0, 0, 0)
			return
		end
	end
	
	function DPSMate.Parser:FriendlyPlayerMisses(msg)
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
			DB:Absorb("АвтоАтака", self.player, c); 
			return 
		end
		for b,c,a in strgfind(msg, "(.+) (.-) атаку (.+)%.") do 
			--if c=="парирует" or c=="парируете" then t[1]=1 end 
			if b=="Вы" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "АвтоАтака", 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(a, "АвтоАтака", 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for b,c,a in strgfind(msg, "(.+) (.-) от атаки (.+)%.") do 
			--if c=="уклоняется" or c=="уклоняетесь" then t[2]=1 end 
			if b=="Вы" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "АвтоАтака", 0, 0, 0, 0, 1, 0, 0, b, 0, 0)
			DB:DamageDone(a, "АвтоАтака", 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for b,c,a in strgfind(msg, "(.+) (.-) атаку (.+)%.") do 
			--if c=="блокирует" or c=="блокируете" then t[3]=1 end 
			if b=="Вы" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "АвтоАтака", 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(a, "АвтоАтака", 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
	end
	
	function DPSMate.Parser:SpellDamageShieldsOnSelf(msg)
		for a,b,c in strgfind(msg, "Вы отражаете (%d+) ед%. урона %((.+)%) на (.+)%.") do 
			t = {tnbr(a)}
			if c == "вас" then c=self.player end
			DB:EnemyDamage(true, DPSMateEDT, self.player, "Отражение", 1, 0, 0, 0, 0, 0, t[1], c, 0, 0)
			DB:DamageDone(self.player, "Отражение", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
		end
	end
	
	function DPSMate.Parser:SpellDamageShieldsOnOthers(msg)
		for a,b,c,d in strgfind(msg, "(.+) отражает (%d+) ед%. урона %((.+)%) на (.+)%.") do
			t = {tnbr(b)}
			if d == "вас" then d=self.player end
			if npcdb:Contains(a) or strfind(a, "%s") then
				DB:EnemyDamage(false, DPSMateEDD, d, "Отражение", 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
				DB:DamageTaken(d, "Отражение", 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
				DB:DeathHistory(d, a, "Отражение", t[1], 1, 0, 0, 0)
			else
				DB:EnemyDamage(true, DPSMateEDT, a, "Отражение", 1, 0, 0, 0, 0, 0, t[1], d, 0, 0)
				DB:DamageDone(a, "Отражение", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
			end
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                    Полученный урон                   --------------                                  
	----------------------------------------------------------------------------------
	
	function DPSMate.Parser:CreatureVsSelfHits(msg)
		for a,c,b,d in strgfind(msg, "(.+) наносит вам (%d+) ед%. урона(.*)%.(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if b~=": критический удар" then t[1]=1;t[2]=0 end
			if strfind(d, "сокрушительный") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(d, "заблокировано") then t[4]=1;t[1]=0;t[2]=0 end
			DB:EnemyDamage(false, DPSMateEDD, self.player, "АвтоАтака", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(self.player, "АвтоАтака", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(self.player, a, "АвтоАтака", t[5], t[1] or 0, t[2] or 1, 0, t[3] or 0)
			return
		end
	end
	
	function DPSMate.Parser:CreatureVsSelfMisses(msg)
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
	
	function DPSMate.Parser:CreatureVsSelfSpellDamage(msg)
		for b,a,d,e,c in strgfind(msg, "\"(.+)\" (.+) наносит вам (%d+) ед%. урона ([^:]*)(.*)%.") do -- Potential here to track school and resisted damage
			t = {false, false, tnbr(d), false}
			if c~=": критический эффект" then t[1]=1;t[2]=0 end
			if strfind(e, "заблокировано") then t[4]=1 end
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
			DB:Kick(self.player, whom, causeAbility, what)
		end
		for b,a in strgfind(msg, "Вы поглощаете заклинание \"(.+)\" (.+)%.") do
			DB:Absorb(b, self.player, a)
			return
		end
	end
	
	function DPSMate.Parser:PeriodicSelfDamage(msg)
		for a,b,d,c,e in strgfind(msg, "Вы получаете (%d+) ед%. урона %((.+)%) от заклинания \"(.+)\" (.+)%.(.*)") do
			t = {tnbr(a)}
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
		for a,b,d,e in strgfind(msg, "Вы получаете (%d+) ед%. урона %((.+)%) от собственного заклинания \"(.+)\"%.(.*)") do
			t = {tnbr(a)}
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
	
	function DPSMate.Parser:CreatureVsCreatureHits(msg) 
		for a,c,d,b,e in strgfind(msg, "(.+) наносит (.+) (%d+) ед%. урона(.*)%.(.*)") do
			t = {false, false, false, false, tnbr(d)}
			if b~=": критический удар" then t[1]=1;t[2]=0 end
			if strfind(e, "сокрушительный") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(e, "заблокировано") then t[4]=1;t[1]=0;t[2]=0 end
			DB:EnemyDamage(false, DPSMateEDD, c, "АвтоАтака", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(c, "АвтоАтака", t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(c, a, "АвтоАтака", t[5], t[1] or 0, t[2] or 1, 0, t[3] or 0)
			return
		end
	end
	
	function DPSMate.Parser:CreatureVsCreatureMisses(msg)
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
	
	function DPSMate.Parser:SpellPeriodicDamageTaken(msg)
		for a,b,c,e,d,f in strgfind(msg, "(.+) получает (%d+) ед%. урона %((.+)%) от заклинания \"(.+)\" (.+)%.(.*)") do
			t = {tnbr(b)}
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
	
	function DPSMate.Parser:CreatureVsCreatureSpellDamage(msg)
		for b,a,d,e,f,c in strgfind(msg, "\"(.+)\" (.+) наносит (.+) (%d+) ед%. урона ([^:]*)(.*)%.") do
			t = {false, false, tnbr(e), false}
			if c~=": критический эффект" then t[1]=1;t[2]=0 end
			if strfind(f, "заблокировано") then t[4]=1 end
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
	
	local HealingStream = "Исцеляющий поток"
	function DPSMate.Parser:SpellSelfBuff(msg)
		for a,b,c in strgfind(msg, "Ваше заклинание \"(.+)\" исцеляет (.+) на (%d+) ед%. здоровья: критический эффект%.") do 
			t = {false, tnbr(c)}
			if b=="вас" then t[1]=self.player end
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
			t = {false, tnbr(c)}
			if b=="вас" then t[1]=self.player end
			t[2] = tnbr(c)
			overheal = self:GetOverhealByName(t[2], t[1] or b)
			DB:HealingTaken(0, DPSMateHealingTaken, t[1] or b, a, 1, 0, t[2], self.player)
			DB:HealingTaken(1, DPSMateEHealingTaken, t[1] or b, a, 1, 0, t[2]-overheal, self.player)
			DB:Healing(0, DPSMateEHealing, self.player, a, 1, 0, t[2]-overheal, t[1] or b)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, self.player, a, 1, 0, overheal, t[1] or b) 
				DB:HealingTaken(2, DPSMateOverhealingTaken, t[1] or b, a, t[4], 0, overheal, self.player)
			end
			DB:Healing(1, DPSMateTHealing, self.player, a, 1, 0, t[2], t[1] or b)
			DB:DeathHistory(t[1] or b, self.player, a, t[2], 1, 0, 1, 0)
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
			DB:RegisterNextSwing(self.player, tnbr(a), b)
			DB:BuildBuffs(self.player, self.player, b, true)
			DB:DestroyBuffs(self.player, b)
			return
		end
		for b,a in strgfind(msg, "\"(.+)\" дает вам (%d) дополнительных атаки%.") do -- Potential for more evaluation
			DB:RegisterNextSwing(a, tnbr(b), c)
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
	
	function DPSMate.Parser:SpellPeriodicSelfBuff(msg)
		for a,c,b in strgfind(msg, "Вы получаете (%d+) ед%. здоровья от заклинания \"(.+)\" (.+)%.") do
			t = {tnbr(a)}
			if c==HealingStream then
				b = self:AssociateShaman(self.player, b, false)
			end
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
			t = {tnbr(a)}
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
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end
			DB:ConfirmBuff(self.player, a, GetTime())
			if self.Dispels[a] then 
				DB:RegisterHotDispel(self.player, a)
			end
			if self.RCD[a] then DPSMate:Broadcast(1, self.player, a) end
			if self.FailDB[a] then DB:BuildFail(3, "Окружение", self.player, a, 0) end
			return 
		end
	end
	
	function DPSMate.Parser:SpellPeriodicFriendlyPlayerBuffs(msg)
		for f,a,c,b in strgfind(msg, "(.+) получает (%d+) ед%. здоровья от заклинания \"(.+)\" (.+)%.") do
			t = {tnbr(a)}
			if c==HealingStream then
				b = self:AssociateShaman(a, b, false)
			end
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
			t = {tnbr(a)}
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
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end
			DB:ConfirmBuff(f, a, GetTime())
			if self.Dispels[a] then
				DB:RegisterHotDispel(f, a)
			end
			if self.RCD[a] then DPSMate:Broadcast(1, f, a) end
			if self.FailDB[a] then DB:BuildFail(3, "Окружение", f, a, 0) end
			return 
		end
	end
	
	function DPSMate.Parser:SpellHostilePlayerBuff(msg)
		for a,b,c,d in strgfind(msg, "(.-) применяет заклинание \"(.+)\" и исцеляет (.+) на (%d+) ед%. здоровья: критический эффект%.") do 
			t = {tnbr(d), false}
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
			t = {tnbr(d), false}
			if c=="вас" then t[2]=self.player end
			overheal = self:GetOverhealByName(t[1], t[2] or c)
			DB:HealingTaken(0, DPSMateHealingTaken, t[2] or c, b, 1, 0, t[1], a)
			DB:HealingTaken(1, DPSMateEHealingTaken, t[2] or c, b, 1, 0, t[1]-overheal, a)
			DB:Healing(0, DPSMateEHealing, a, b, 1, 0, t[1]-overheal, t[2] or c)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, a, b, 1, 0, overheal, t[2] or c)
				DB:HealingTaken(2, DPSMateOverhealingTaken, t[2] or c, b, 1, 0, overheal, a)
			end
			DB:Healing(1, DPSMateTHealing, a, b, 1, 0, t[1], t[2] or c)
			DB:DeathHistory(t[2] or c, a, b, t[1], 1, 0, 1, 0)
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
			DB:RegisterNextSwing(a, tnbr(b), c)
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
	
	function DPSMate.Parser:CreatureVsSelfHitsAbsorb(msg)
		for c, a, b, ka, absorbed in strgfind(msg, "Вы наносите (.+) (%d+) ед%. урона(.*)%.(.*)%(поглощено: (%d+)%)") do DB:SetUnregisterVariables(tnbr(absorbed), "АвтоАтака", c) end
	end
	
	function DPSMate.Parser:CreatureVsCreatureHitsAbsorb(msg)
		for c, a, d, b, ka, absorbed in strgfind(msg, "(.+) наносит (.+) (%d+) ед%. урона(.*)%.(.*)%(поглощено: (%d+)%)") do DB:SetUnregisterVariables(tnbr(absorbed), "АвтоАтака", c) end
	end
	
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
	
	function DPSMate.Parser:SpellAuraGoneSelf(msg)
		for ab in strgfind(msg, "Действие эффекта \"(.+)\", наложенного на вас, заканчивается%.") do if self.BuffExceptions[ab] then return end; if strfind(ab, "%(") then ab=strsub(ab, 1, strfind(ab, "%(")-2) end; if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, self.player) end; if self.RCD[ab] then DPSMate:Broadcast(6, self.player, ab) end; DB:DestroyBuffs(self.player, ab); DB:UnregisterHotDispel(self.player, ab); DB:RemoveActiveCC(self.player, ab) end
	end
	
	function DPSMate.Parser:SpellAuraGoneParty(msg)
		for ab, ta in strgfind(msg, "Действие эффекта \"(.+)\", наложенного на (.-), заканчивается%.") do if self.BuffExceptions[ab] then return end; if strfind(ab, "%(") then ab=strsub(ab, 1, strfind(ab, "%(")-2) end;if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, ta) end; if self.RCD[ab] then DPSMate:Broadcast(6, ta, ab) end; DB:DestroyBuffs(ta, ab); DB:UnregisterHotDispel(ta, ab); DB:RemoveActiveCC(ta, ab) end
	end
	
	function DPSMate.Parser:SpellAuraGoneOther(msg)
		for ab, ta in strgfind(msg, "Действие эффекта \"(.+)\", наложенного на (.-), заканчивается%.") do if self.BuffExceptions[ab] then return end; if strfind(ab, "%(") then ab=strsub(ab, 1, strfind(ab, "%(")-2) end;if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, ta) end; if self.RCD[ab] then DPSMate:Broadcast(6, ta, ab) end; DB:DestroyBuffs(ta, ab); DB:UnregisterHotDispel(ta, ab); DB:RemoveActiveCC(ta, ab) end
	end
	
	----------------------------------------------------------------------------------
	--------------                       Рассеивание                    --------------                                  
	----------------------------------------------------------------------------------
	
	function DPSMate.Parser:SpellSelfBuffDispels(msg)
		for ab, tar in strgfind(msg, "Вы применяете заклинание \"(.+)\" на (.-)%.") do if self.Dispels[ab] then DB:AwaitDispel(ab, tar, self.player, GetTime()) end; if self.RCD[ab] then DPSMate:Broadcast(2, self.player, tar, ab) end; return end
		for ab in strgfind(msg, "Вы применяете заклинание \"(.+)\"%.") do if self.Dispels[ab] then DB:AwaitDispel(ab, self.player, self.player, GetTime()) end; return end
	end

	function DPSMate.Parser:SpellHostilePlayerBuffDispels(msg)
		for c, ab, ta in strgfind(msg, "(.+) применяет заклинание \"(.+)\" на (.-)%.") do 
			if self.Dispels[ab] then DB:AwaitDispel(ab, ta, c, GetTime()) end; 
			if self.RCD[ab] then DPSMate:Broadcast(2, c, ta, ab) end; 
			return 
		end
		for c, ab in strgfind(msg, "(.+) применяет на вас заклинание \"(.+)\"%.") do 
			if self.Dispels[ab] then DB:AwaitDispel(ab, self.player, c, GetTime()) end; 
			if self.RCD[ab] then DPSMate:Broadcast(2, c, self.player, ab) end; 
			return 
		end
		for c, ab in strgfind(msg, "(.+) применяет заклинание \"(.+)\"%.") do if self.Dispels[ab] then DB:AwaitDispel(ab, "Неизвестно", c, GetTime()) end; return end
	end
	
	function DPSMate.Parser:SpellBreakAura(msg) 
		for ta, ab in strgfind(msg, "(.-) теряет \"(.+)\"%.") do DB:ConfirmRealDispel(ab, ta, GetTime()); return end
		for ab in strgfind(msg, "Вы теряете \"(.+)\"%.") do DB:ConfirmRealDispel(ab, self.player, GetTime()); return end
	end
	
	----------------------------------------------------------------------------------
	--------------                       Смерти                         --------------                                  
	----------------------------------------------------------------------------------
	
	function DPSMate.Parser:CombatFriendlyDeath(msg)
		for ta in strgfind(msg, "(.-) (.-)%.") do if ta=="Вы" then DB:UnregisterDeath(self.player) else DB:UnregisterDeath(ta) end end
	end
	
	function DPSMate.Parser:CombatHostileDeaths(msg)
		for ta in strgfind(msg, "(.+) погибает%.") do 
			DB:UnregisterDeath(ta)
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                     Прерывания                       --------------                                  
	----------------------------------------------------------------------------------
	
	function DPSMate.Parser:CreatureVsCreatureSpellDamageInterrupts(msg)
		for c, ab in strgfind(msg, "(.+) начинает использовать \"(.+)\"%.") do DB:RegisterPotentialKick(c, ab, GetTime()); return end
		for c, ab in strgfind(msg, "(.+) начинает выполнять действие \"(.+)\"%.") do DB:RegisterPotentialKick(c, ab, GetTime()) end
	end
	function DPSMate.Parser:HostilePlayerSpellDamageInterrupts(msg)
		for c, ab in strgfind(msg, "(.-) начинает использовать \"(.+)\"%.") do DB:RegisterPotentialKick(c, ab, GetTime()); return end
		for c, ab in strgfind(msg, "(.-) начинает выполнять действие \"(.+)\"%.") do DB:RegisterPotentialKick(c, ab, GetTime()) end
	end
	
	----------------------------------------------------------------------------------
	--------------                     Питомец                          --------------                                  
	----------------------------------------------------------------------------------
	
	function DPSMate.Parser:PetHits(msg)
		for a,c,d,b,e in strgfind(msg, "(.-) наносит (.-) (%d+) ед%. урона(.*)%.(.*)") do
			t = {false, false, false, false, tnbr(d)}
			if b~=": критический удар" then t[3]=1;t[4]=0 end
			if e=="(пришелся вскользь)" then t[1]=1;t[3]=0;t[4]=0 elseif e~="" then t[2]=1;t[3]=0;t[4]=0 end
			if c=="вам" then c=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "АвтоАтака", t[3] or 0, t[4] or 1, 0, 0, 0, 0, t[5], c, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, "АвтоАтака", t[3] or 0, t[4] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			return
		end
	end
	
	function DPSMate.Parser:PetMisses(msg)
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
	
	function DPSMate.Parser:PetSpellDamage(msg)
		for a,f,c,d,e,b in strgfind(msg, "\"(.+)\" (.-) наносит (.+) (%d+) ед%. урона([^:]*)(.*)%.%s?(.*)") do 
			t = {tnbr(d), false, false, false}
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