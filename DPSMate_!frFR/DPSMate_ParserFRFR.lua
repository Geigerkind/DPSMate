local t = {}
local strgfind = string.gfind
local DB = DPSMate.DB
local tnbr = tonumber
local strgsub = string.gsub
local npcdb = NPCDB
local GetTime = GetTime
local strfind = string.find

if (GetLocale() == "frFR") then
	DPSMate.Parser.SelfHits = function(self, msg)
		for a,b,c,d in strgfind(msg, "Vous touchez (.+) et infligez (%d+) points de dégâts(.*)%. %((%d+) absorbé%)") do
			DB:SetUnregisterVariables(tnbr(d), DPSMate.L["AutoAttack"], self.player)
		end
		for a,b,e,d in strgfind(msg, "Vous infligez un coup critique à (.+) %((%d+) points de dégâts(.*)%)%. %((%d+) absorbé%)") do
			DB:SetUnregisterVariables(tnbr(d), DPSMate.L["AutoAttack"], self.player)
		end
		for a,b,e,c in strgfind(msg, "Vous touchez (.+) et infligez (%d+) points de dégâts(.*)%.%s?(.*)") do
			t = {false, false, false, false, tnbr(b)}
			if c == "(érafle)" then t[3]=1;t[1]=0 elseif c ~= "" then t[4]=1;t[1]=0; end
			DB:EnemyDamage(true, DPSMateEDT, self.player, DPSMate.L["AutoAttack"], t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageDone(self.player, DPSMate.L["AutoAttack"], t[1] or 1, 0, 0, 0, 0, 0, t[5], t[3] or 0, t[4] or 0)
			if self.TargetParty[a] then DB:BuildFail(1, a, self.player, DPSMate.L["AutoAttack"], t[5]);DB:DeathHistory(a, self.player, DPSMate.L["AutoAttack"], t[5], 1, 0, 0, 0) end
			return
		end
		for a,b,e in strgfind(msg, "Vous infligez un coup critique à (.+) %((%d+) points de dégâts(.*)%)%.") do
			t = {tnbr(b)}
			DB:EnemyDamage(true, DPSMateEDT, self.player, DPSMate.L["AutoAttack"], 0, 1, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageDone(self.player, DPSMate.L["AutoAttack"], 0, 1, 0, 0, 0, 0, t[1], 0, 0)
			if self.TargetParty[a] then DB:BuildFail(1, a, self.player, DPSMate.L["AutoAttack"], t[1]);DB:DeathHistory(a, self.player, DPSMate.L["AutoAttack"], t[1], 0, 1, 0, 0) end
			return
		end
		for a in strgfind(msg, "Vous faites une chute et perdez (%d+) points de vie%.") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "Chute", 1, 0, 0, 0, 0, 0, t[1], "Environnement", 0, 0)
			DB:DeathHistory(self.player, "Environnement", "Chute", t[1], 1, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "Vous perdez (%d+) PV pour avoir nagé dans la lave%.") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "Lave", 1, 0, 0, 0, 0, 0, t[1], "Environnement", 0, 0)
			DB:DeathHistory(self.player, "Environnement", "Lave", t[1], 1, 0, 0, 0)
			DB:AddSpellSchool("Lave","feu")
			return
		end
		for a in strgfind(msg, "Vous vous noyez et perdez (%d+) points de vie%.") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "Noyade", 1, 0, 0, 0, 0, 0, t[1], "Environnement", 0, 0)
			DB:DeathHistory(self.player, "Environnement", "Noyade", t[1], 1, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "Vous perdez (%d+) points de vie à cause du feu%.") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "Feu", 1, 0, 0, 0, 0, 0, t[1], "Environnement", 0, 0)
			DB:DeathHistory(self.player, "Environnement", "Feu", t[1], 1, 0, 0, 0)
			DB:AddSpellSchool("Feu","feu")
			return
		end
		for a in strgfind(msg, "Vous perdez (%d+) points de vie en nageant dans la vase%.") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "Slime", 1, 0, 0, 0, 0, 0, t[1], "Environnement", 0, 0)
			DB:DeathHistory(self.player, "Environnement", "Slime", t[1], 1, 0, 0, 0)
			return
		end
	end
	
	DPSMate.Parser.SelfMisses = function(self, msg)
		for a in strgfind(msg, "Vous ratez (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, DPSMate.L["AutoAttack"], 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageDone(self.player, DPSMate.L["AutoAttack"], 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "Vous attaquez, mais (.+) esquive%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageDone(self.player, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "Vous attaquez, mais (.+) pare l'attaque%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, DPSMate.L["AutoAttack"], 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageDone(self.player, DPSMate.L["AutoAttack"], 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "Vous attaquez, mais (.+) bloque l'attaque%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 0, 0, 0, a, 1, 0)
			DB:DamageDone(self.player, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for ta in strgfind(msg, "Vous attaquez%. (.+) absorbe tous les dégâts%.") do DB:Absorb("AutoAttack", ta, self.player); return end
	end
	
	DPSMate.Parser.SelfSpellDMG = function(self, msg)
		for a,b,c,d,f in strgfind(msg, "Votre (.+) touche (.+) et inflige (%d+) points de dégâts%. %((%d+) absorbé%)") do
			DB:SetUnregisterVariables(tnbr(f), a, self.player)
		end
		for a,b,c,e in strgfind(msg, "Votre (.+) touche (.+) et inflige (%d+) points de dégâts%.%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if strfind(e, "érafle") then t[4]=1;t[2]=0;t[3]=0 end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(self.player, a, b, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(self.player, self.player, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, self.player, a,  t[2] or 1, 0, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(self.player, a, t[2] or 1, 0, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[c] then DB:BuildFail(1, c, self.player, a, t[1]);DB:DeathHistory(c, self.player, a, t[1], 1, 0, 0, 0) end
			return
		end
		for a,b,c,d,e in strgfind(msg, "Votre (.+) touche (.+) et lui inflige (%d+) points de dégâts (.+)%.%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if strfind(e, "érafle") then t[4]=1;t[2]=0;t[3]=0 end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(self.player, a, b, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(self.player, self.player, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, self.player, a,  t[2] or 1, 0, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(self.player, a, t[2] or 1, 0, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[c] then DB:BuildFail(1, c, self.player, a, t[1]);DB:DeathHistory(c, self.player, a, t[1], 1, 0, 0, 0) end
			DB:AddSpellSchool(a,d)
			return
		end
		for a,b,c,d,e in strgfind(msg, "Votre (.+) inflige un coup critique à (.+) %((%d+) points de dégâts%s?(.*)%)%.%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if strfind(e, "érafle") then t[4]=1;t[2]=0;end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(self.player, a, b, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(self.player, self.player, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, self.player, a,  0, t[2] or 1, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(self.player, a, 0, t[2] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[b] then DB:BuildFail(1, b, self.player, a, t[1]);DB:DeathHistory(b, self.player, a, t[1], 0, 1, 0, 0) end
			DB:AddSpellSchool(a,d)
			return
		end
		for a,b in strgfind(msg, "(.+) esquive votre (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageDone(self.player, b, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for b,a in strgfind(msg, "(.+) pare votre (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(self.player, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "Votre (.+) a raté (.+)%.") do
			DB:EnemyDamage(true, DPSMateEDT, self.player, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(self.player, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "Vous utilisez (.+), mais (.+) résiste%.") do
			DB:EnemyDamage(true, DPSMateEDT, self.player, a, 0, 0, 0, 0, 0, 1, 0, b, 0, 0)
			DB:DamageDone(self.player, a, 0, 0, 0, 0, 0, 1, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "Votre (.+) a été bloqué par (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, a, 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(self.player, a, 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for whom, what in strgfind(msg, "(.+) lance un (.+) que vous interrompez%.") do
			local causeAbility = "Contresort"
			if DPSMateUser[self.player] then
				if DPSMateUser[self.player][2] == "priest" then
					causeAbility = "Silence"
				end
			end
			DPSMate.DB:Kick(self.player, whom, causeAbility, what)
		end
	end
	
	DPSMate.Parser.PeriodicDamage = function(self, msg)
		for a,b in strgfind(msg, "(.+) subit les effets de (.+)%.") do if strfind(b, "%(") then b=strsub(b, 1, strfind(b, "%(")-2) end; DB:ConfirmAfflicted(a, b, GetTime()); if self.CC[b] then  DB:BuildActiveCC(a, b) end; return end
		for e,d,a,b,c,f in strgfind(msg, "(.+) de (.+) inflige à (.+) (%d+) points de dégâts%s?(.*)%.(.*)") do
			t = {tnbr(b)}
			if f~="" then
				DB:SetUnregisterVariables(tnbr(strsub(f, strfind(f, "%d+"))), e..DPSMate.L["periodic"], d)
			end
			DB:EnemyDamage(true, DPSMateEDT, d, e..DPSMate.L["periodic"], 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageDone(d, e..DPSMate.L["periodic"], 1, 0, 0, 0, 0, 0, t[1], 0, 0)
			if self.TargetParty[a] and self.TargetParty[d] then DB:BuildFail(1, a, d, e..DPSMate.L["periodic"], t[1]);DB:DeathHistory(a, d, e..DPSMate.L["periodic"], t[1], 1, 0, 0, 0) end
			DB:AddSpellSchool(e..DPSMate.L["periodic"],c)
			return
		end
		for d,b,c,a,f in strgfind(msg, "Votre (.+) inflige (%d+) points de dégâts%s?(.*) à (.+)%.(.*)") do
			t = {tnbr(b)}
			if f~="" then
				DB:SetUnregisterVariables(tnbr(strsub(f, strfind(f, "%d+"))), d..DPSMate.L["periodic"], self.player)
			end
			DB:EnemyDamage(true, DPSMateEDT, self.player, d..DPSMate.L["periodic"], 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageDone(self.player, d..DPSMate.L["periodic"], 1, 0, 0, 0, 0, 0, t[1], 0, 0)
			if self.TargetParty[a] then DB:BuildFail(1, a, self.player, d..DPSMate.L["periodic"], t[1]);DB:DeathHistory(a, self.player, d..DPSMate.L["periodic"], t[1], 1, 0, 0, 0) end
			DB:AddSpellSchool(d..DPSMate.L["periodic"],c)
			return
		end
		for f,a,b in strgfind(msg, "(.+) utilise (.+), mais l'effet est absorbé par (.+)%.") do
			DB:Absorb(a..DPSMate.L["periodic"], b, f)
			return
		end
		for a,b in strgfind(msg, "L'effet de votre (.+) est absorbé par (.+)%.") do
			DB:Absorb(a..DPSMate.L["periodic"], b, self.player)
			return
		end
	end
	
	DPSMate.Parser.FriendlyPlayerDamage = function(self, msg)
		for a,b,c,d,f in strgfind(msg, "(.+) de (.+) touche (.+) pour (%d+) points de dégâts%. %((%d+) absorbé%)") do 
			DB:SetUnregisterVariables(tnbr(f), a, b)
		end
		for a,f,b,c,e in strgfind(msg, "(.+) de (.+) touche (.+) pour (%d+) points de dégâts%.%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if strfind(e, "érafle") then t[4]=1;t[2]=0;t[3]=0 end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, b, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, f, a,  t[2] or 1, 0, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(f, a, t[2] or 1, 0, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[b] and self.TargetParty[f] then DB:BuildFail(1, b, f, a, t[1]);DB:DeathHistory(b, f, a, t[1], 1, 0, 0, 0) end
			return
		end
		for a,b,c,d,e,f in strgfind(msg, "(.+) lance (.+) sur (.+) et lui inflige (%d+) points de dégâts (.*)%. %((%d+) absorbé%)") do 
			DB:AddSpellSchool(b,e)
			DB:SetUnregisterVariables(tnbr(f), b, a)
		end
		for f,a,b,c,d,e in strgfind(msg, "(.+) lance (.+) sur (.+) et lui inflige (%d+) points de dégâts (.*)%.%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if strfind(e, "érafle") then t[4]=1;t[2]=0;t[3]=0 end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, b, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, f, a,  t[2] or 1, 0, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(f, a, t[2] or 1, 0, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[b] and self.TargetParty[f] then DB:BuildFail(1, b, f, a, t[1]);DB:DeathHistory(b, f, a, t[1], 1, 0, 0, 0) end
			DB:AddSpellSchool(a,d)
			return
		end
		for f,a,b,c,d,e in strgfind(msg, "(.+) lance (.+) et inflige un coup critique à (.+) %((%d+) points de dégâts%s?(.*)%)%.%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if strfind(e, "érafle") then t[4]=1;t[2]=0;end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, c, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, f, a,  0, t[2] or 1, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(f, a, 0, t[2] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[b] and self.TargetParty[f] then DB:BuildFail(1, b, f, a, t[1]);DB:DeathHistory(b, f, a, t[1], 0, 1, 0, 0) end
			DB:AddSpellSchool(a,d)
			return
		end
		for a,b,f in strgfind(msg, "(.+) esquive (.+) de (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageDone(f, b, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for b,a,f in strgfind(msg, "(.+) pare (.+) de (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.+) voit son (.+) manquer (.+)%.") do
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.+) utilise (.+), mais (.+) résiste%.") do
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 0, 1, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 1, 0, 0, 0)
			return
		end
		for b,a,f in strgfind(msg, "(.+) bloque (.+) de (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for who, whom, what in strgfind(msg, "(.+) interrompt (.+) qui lance (.+)%.") do
			local causeAbility = "Contresort"
			if DPSMateUser[who] then
				if DPSMateUser[who][2] == "priest" then
					causeAbility = "Silence"
				end
				-- Account for felhunter silence
				if DPSMateUser[who][4] and DPSMateUser[who][6] then
					local owner = DPSMate:GetUserById(DPSMateUser[who][6])
					if owner and DPSMateUser[owner] then
						causeAbility = "Verrou magique"
						who = owner
					end
				end
			end
			DB:Kick(who, whom, causeAbility, what)
		end
	end
	
	DPSMate.Parser.FriendlyPlayerHits = function(self, msg)
		for a,b,c,e in strgfind(msg, "(.+) touche (.+) et inflige (%d+) points de dégâts%. %((%d+) absorbé%)") do
			DB:SetUnregisterVariables(tnbr(e), DPSMate.L["AutoAttack"], a)
		end
		for a,b,c,d in strgfind(msg, "(.+) inflige un coup critique à (.+) %((%d+) points de dégâts%)%.%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(érafle)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, t[3] or 1, 0, 0, 0, 0, t[5], b, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, t[3] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			if self.TargetParty[a] and self.TargetParty[b] then DB:BuildFail(1, b, a, DPSMate.L["AutoAttack"], t[5]);DB:DeathHistory(b, a, DPSMate.L["AutoAttack"], t[5], 0, 1, 0, 0) end
			return
		end
		for a,b,c,d in strgfind(msg, "(.+) touche (.+) et inflige (%d+) points de dégâts%.%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(érafle)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], t[3] or 1, 0, 0, 0, 0, 0, t[5], b, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], t[3] or 1, 0, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			if self.TargetParty[a] and self.TargetParty[b] then DB:BuildFail(1, b, a, DPSMate.L["AutoAttack"], t[5]);DB:DeathHistory(b, a, DPSMate.L["AutoAttack"], t[5], 1, 0, 0, 0) end
			return
		end

		for a,b in strgfind(msg, "(.+) perd (%d+) points de vie en nageant dans la lave%.") do
			t = {tnbr(b)}
			DB:DamageTaken(a, "Lave", 1, 0, 0, 0, 0, 0, t[1], "Environnement", 0, 0)
			DB:DeathHistory(a, "Environnement", "Lave", t[1], 1, 0, 0, 0)
			DB:AddSpellSchool("Lave","feu")
			return
		end
		for a,b in strgfind(msg, "(.+) tombe et perd (%d+) PV%.") do
			t = {tnbr(b)}
			DB:DamageTaken(a, "Chute", 1, 0, 0, 0, 0, 0, t[1], "Environnement", 0, 0)
			DB:DeathHistory(a, "Environnement", "Chute", t[1], 1, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) se noie et perd (%d+) points de vie%.") do
			t = {tnbr(b)}
			DB:DamageTaken(a, "Noyade", 1, 0, 0, 0, 0, 0, t[1], "Environnement", 0, 0)
			DB:DeathHistory(a, "Environnement", "Noyade", t[1], 1, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) perd (%d+) points de vie à cause du feu%.") do
			t = {tnbr(b)}
			DB:DamageTaken(a, "Feu", 1, 0, 0, 0, 0, 0, t[1], "Environnement", 0, 0)
			DB:DeathHistory(a, "Environnement", "Feu", t[1], 1, 0, 0, 0)
			DB:AddSpellSchool("Feu","feu")
			return
		end
		for a,b in strgfind(msg, "(.+) perd (%d+) points de vie en nageant dans la vase%.") do
			t = {tnbr(b)}
			DB:DamageTaken(a, "Slime", 1, 0, 0, 0, 0, 0, t[1], "Environnement", 0, 0)
			DB:DeathHistory(a, "Environnement", "Slime", t[1], 1, 0, 0, 0)
			return
		end

		-- PvP
		for a,c,d in strgfind(msg, "(.+) vous inflige (%d+) points de dégâts%.%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(érafle)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], t[3] or 1, 0, 0, 0, 0, 0, t[5], self.player, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], t[3] or 1, 0, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			if self.TargetParty[a] and self.TargetParty[self.player] then DB:BuildFail(1, self.player, a, DPSMate.L["AutoAttack"], t[5]);DB:DeathHistory(self.player, a, DPSMate.L["AutoAttack"], t[5], 1, 0, 0, 0) end
			return
		end
		for a,c,d in strgfind(msg, "(.+) vous inflige un coup critique pour (%d+) points de dégâts%.%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(érafle)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, t[3] or 1, 0, 0, 0, 0, t[5], self.player, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, t[3] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			if self.TargetParty[a] and self.TargetParty[self.player] then DB:BuildFail(1, self.player, a, DPSMate.L["AutoAttack"], t[5]);DB:DeathHistory(self.player, a, DPSMate.L["AutoAttack"], t[5], 0, 1, 0, 0) end
			return
		end
	end

	DPSMate.Parser.FriendlyPlayerMisses = function(self, msg)
		for a,b in strgfind(msg, "(.+) manque (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) attaque et (.+) esquive%.") do 
			if b=="vous" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 1, 0, 0, b, 0, 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) attaque et (.+) pare son attaque%.") do 
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) attaque et (.+) bloque l'attaque%.") do 
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for c,b in strgfind(msg, "(.+) attaque. (.+) absorbe tous les dégâts%.") do DB:Absorb(DPSMate.L["AutoAttack"], b, c); return end

		-- PvP
		for a in strgfind(msg, "(.+) vous rate%.") do 
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, 0, 1, 0, 0, 0, 0, self.player, 0, 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "(.+) attaque, mais vous parez le coup%.") do 
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, 0, 0, 1, 0, 0, 0, self.player, 0, 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "(.+) attaque, mais vous bloquez le coup%.") do 
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 0, 0, 0, self.player, 1, 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for c in strgfind(msg, "(.+) attaque. Vous absorbez tous les dégâts%.") do DB:Absorb(DPSMate.L["AutoAttack"], self.player, c); return end
	end
	
	DPSMate.Parser.SpellDamageShieldsOnSelf = function(self, msg)
		for a,b,c in strgfind(msg, "Vous renvoyez (%d+) points de dégâts (.*) à (.+)%.") do 
			t = {tnbr(a)}
			DB:EnemyDamage(true, DPSMateEDT, self.player, "Renvoyez", 1, 0, 0, 0, 0, 0, t[1], c, 0, 0)
			DB:DamageDone(self.player, "Renvoyez", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
		end
	end
	
	DPSMate.Parser.SpellDamageShieldsOnOthers = function(self, msg)
		for a,b,c,d in strgfind(msg, "(.+) renvoie (%d+) points de dégâts (.*) sur (.+)%.") do
			t = {tnbr(b)}
			if npcdb:Contains(a) or strfind(a, "%s") then
				DB:EnemyDamage(false, DPSMateEDD, d, "Renvoyez", 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
				DB:DamageTaken(d, "Renvoyez", 1, 0, 0, 0, 0, 0, t[1], a, 0,0)
				DB:DeathHistory(d, a, "Renvoyez", t[1], 1, 0, 0, 0)
			else
				DB:EnemyDamage(true, DPSMateEDT, a, "Renvoyez", 1, 0, 0, 0, 0, 0, t[1], d, 0, 0)
				DB:DamageDone(a, "Renvoyez", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
			end
		end
		for a,b,c in strgfind(msg, "(.+) réfléchit (%d+) (.*) points de dégâts sur vous.") do
			t = {tnbr(b)}
			if npcdb:Contains(a) or strfind(a, "%s") then
				DB:EnemyDamage(false, DPSMateEDD, self.player, "Renvoyez", 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
				DB:DamageTaken(self.player, "Renvoyez", 1, 0, 0, 0, 0, 0, t[1], a, 0,0)
				DB:DeathHistory(self.player, a, "Renvoyez", t[1], 1, 0, 0, 0)
			else
				DB:EnemyDamage(true, DPSMateEDT, a, "Renvoyez", 1, 0, 0, 0, 0, 0, t[1], self.player, 0, 0)
				DB:DamageDone(a, "Renvoyez", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
			end
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                    Damage taken                      --------------                                  
	----------------------------------------------------------------------------------

	DPSMate.Parser.CreatureVsSelfHits = function(self, msg)
		for a,c,d in strgfind(msg, "(.+) vous inflige (%d+) points de dégâts%.(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if strfind(d, "écrase") then t[3]=1;t[1]=0; elseif strfind(d, "érafle") then t[4]=1;t[1]=0; end
			DB:EnemyDamage(false, DPSMateEDD, self.player, DPSMate.L["AutoAttack"], t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(self.player, DPSMate.L["AutoAttack"], t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(self.player, a, DPSMate.L["AutoAttack"], t[5], t[1] or 1, 0, 0, t[3] or 0)
			return
		end
		for a,c,d in strgfind(msg, "(.+) vous inflige un coup critique pour (%d+) points de dégâts(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if strfind(d, "écrase") then t[3]=1;t[2]=0 elseif strfind(d, "érafle") then t[4]=1;t[2]=0 end
			DB:EnemyDamage(false, DPSMateEDD, self.player, DPSMate.L["AutoAttack"], 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(self.player, DPSMate.L["AutoAttack"], 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(self.player, a, DPSMate.L["AutoAttack"], t[5], 0, t[2] or 1, 0, t[3] or 0)
			return
		end
		for a,c,e,d in strgfind(msg, "(.+) vous touche et vous inflige (%d+) points de dégâts (.*)%.(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if strfind(d, "écrase") then t[3]=1;t[1]=0; elseif strfind(d, "érafle") then t[4]=1;t[1]=0; end
			DB:EnemyDamage(false, DPSMateEDD, self.player, DPSMate.L["AutoAttack"], t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(self.player, DPSMate.L["AutoAttack"], t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(self.player, a, DPSMate.L["AutoAttack"], t[5], t[1] or 1, 0, 0, t[3] or 0)
			return
		end
	end
	
	DPSMate.Parser.CreatureVsSelfMisses = function(self, msg)
		for c in strgfind(msg, "(.+) attaque%. Vous absorbez tous les dégâts%.") do DB:Absorb(DPSMate.L["AutoAttack"], self.player, c); return end
		for a in strgfind(msg, "(.+) vous rate%.") do 
			DB:EnemyDamage(false, DPSMateEDD, self.player, DPSMate.L["AutoAttack"], 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, DPSMate.L["AutoAttack"], 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return
		end
		for a in strgfind(msg, "(.+) attaque et vous esquivez%.") do 
			DB:EnemyDamage(false, DPSMateEDD, self.player, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			return
		end
		for a in strgfind(msg, "(.+) attaque, mais vous parez le coup%.") do 
			DB:EnemyDamage(false, DPSMateEDD, self.player, DPSMate.L["AutoAttack"], 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, DPSMate.L["AutoAttack"], 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			return
		end
		for a in strgfind(msg, "(.+) attaque, mais vous bloquez le coup%.") do 
			DB:EnemyDamage(false, DPSMateEDD, self.player, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 0, 0, 0, a, 1, 0)
			DB:DamageTaken(self.player, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 0, 0, 0, a, 0, 1)
			return
		end
	end 

	DPSMate.Parser.CreatureVsSelfSpellDamage = function(self, msg)
		for c,a,d,e in strgfind(msg, "(.+) de (.+) vous inflige (%d+) points de dégâts%.(.*)") do -- Potential here to track school and resisted damage
			t = {tnbr(d)}
			DB:UnregisterPotentialKick(self.player, c, GetTime())
			DB:EnemyDamage(false, DPSMateEDD, self.player, c, 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageTaken(self.player, c, 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DeathHistory(self.player, a, c, t[1], 1, 0, 0, 0)
			if self.FailDT[c] then DB:BuildFail(2, a, self.player, c, t[1]) end
			return
		end
		for a,b,c,d in strgfind(msg, "(.+) lance (.+) et vous inflige un coup critique %((%d+) points de dégâts%)%.(.*)") do -- Potential here to track school and resisted damage
			t = {tnbr(c)}
			DB:UnregisterPotentialKick(self.player, b, GetTime())
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 1, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 1, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DeathHistory(self.player, a, b, t[1], 0, 1, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, self.player, b, t[1]) end
			return
		end
		for a,b,c,d,e in strgfind(msg, "(.+) lance (.+) et vous inflige (%d+) points de dégâts (.*)%.(.*)") do -- Potential here to track school and resisted damage
			t = {tnbr(c)}
			DB:UnregisterPotentialKick(self.player, b, GetTime())
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageTaken(self.player, b, 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DeathHistory(self.player, a, b, t[1], 1, 0, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, self.player, b, t[1]) end
			DB:AddSpellSchool(b,d)
			return
		end
		for b,a,c,d,e in strgfind(msg, "(.+) de (.+) vous inflige un coup critique pour (%d+) points de dégâts (.*)%.(.*)") do -- Potential here to track school and resisted damage
			t = {tnbr(c)}
			DB:UnregisterPotentialKick(self.player, b, GetTime())
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 1, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 1, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DeathHistory(self.player, a, b, t[1], 0, 1, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, self.player, b, t[1]) end
			DB:AddSpellSchool(b,d)
			return
		end
		for b,a in strgfind(msg, "(.+) de (.+) vous rate%.") do
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return
		end
		for b,a in strgfind(msg, "(.+) de (.+) : paré%.") do
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) utilise (.+), mais son adversaire esquive%.") do
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) utilise (.+), mais cela n'a aucun effet%.") do
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) utilise (.+), mais son adversaire bloque%.") do
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 0, 0, 0, 0, 0, 0, a, 1, 0)
			DB:DamageTaken(self.player, b, 0, 0, 0, 0, 0, 0, 0, a, 0, 1)
			return
		end
		for a,b in strgfind(msg, "(.+) utilise (.+), mais vous absorbez l'effet%.") do
			DB:Absorb(b, self.player, a)
			return
		end
	end
	
	DPSMate.Parser.PeriodicSelfDamage = function(self, msg)
		for d,c,a,b,e in strgfind(msg, "(.+) de (.+) vous inflige (%d+) points de dégâts (.*)%.(.*)") do
			t = {tnbr(a)}
			DB:EnemyDamage(false, DPSMateEDD, self.player, d..DPSMate.L["periodic"], 1, 0, 0, 0, 0, 0, t[1], c, 0, 0)
			DB:DamageTaken(self.player, d..DPSMate.L["periodic"], 1, 0, 0, 0, 0, 0, t[1], c, 0, 0)
			DB:DeathHistory(self.player, c, d..DPSMate.L["periodic"], t[1], 1, 0, 0, 0)
			if self.FailDT[d] then DB:BuildFail(2, c, self.player, d, t[1]) end
			DB:AddSpellSchool(d..DPSMate.L["periodic"],b)
			return
		end
		for a in strgfind(msg, "Vous subissez les effets de (.+)%.") do
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end;
			DB:BuildBuffs(DPSMate.L["unknown"], self.player, a, false)
			if self.CC[a] then DB:BuildActiveCC(self.player, a) end
			return
		end
		for a,b,d,e in strgfind(msg, "Vous subissez (%d+) (.*) dégâts de votre (.+)%.(.*)") do
			t = {tnbr(a)}
			DB:EnemyDamage(false, DPSMateEDD, self.player, d..DPSMate.L["periodic"], 1, 0, 0, 0, 0, 0, t[1], self.player, 0, 0)
			DB:DamageTaken(self.player, d..DPSMate.L["periodic"], 1, 0, 0, 0, 0, 0, t[1], self.player, 0, 0)
			DB:DeathHistory(self.player, self.player, d..DPSMate.L["periodic"], t[1], 1, 0, 0, 0)
			DB:AddSpellSchool(d..DPSMate.L["periodic"],b)
			return
		end
		for a,b in strgfind(msg, "(.+) utilise (.+), mais vous absorbez l'effet%.") do
			DB:Absorb(b..DPSMate.L["periodic"], self.player, a)
			return
		end
	end
	
	DPSMate.Parser.CreatureVsCreatureHits = function(self, msg) 
		for a,c,d,e in strgfind(msg, "(.+) touche (.+) et inflige (%d+) points de dégâts%.(.*)") do
			t = {false, false, false, false, tnbr(d)}
			if strfind(e, "écrase") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(e, "érafle") then t[4]=1;t[1]=0;t[2]=0 end
			DB:EnemyDamage(false, DPSMateEDD, c, DPSMate.L["AutoAttack"], t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(c, DPSMate.L["AutoAttack"], t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(c, a, DPSMate.L["AutoAttack"], t[5], t[1] or 1, 0, 0, t[3] or 0)
			return
		end
		for a,c,d,e in strgfind(msg, "(.+) inflige un coup critique à (.+) %((%d+) points de dégâts%)%.(.*)") do
			t = {false, false, false, false, tnbr(d)}
			if strfind(e, "écrase") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(e, "érafle") then t[4]=1;t[1]=0;t[2]=0 end
			DB:EnemyDamage(false, DPSMateEDD, c, DPSMate.L["AutoAttack"], 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(c, DPSMate.L["AutoAttack"], 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(c, a, DPSMate.L["AutoAttack"], t[5], 0, t[2] or 1, 0, t[3] or 0)
			return
		end
		for a,c,d,f,e in strgfind(msg, "(.+) touche (.+) et lui inflige (%d+) points de dégâts (.*)%.(.*)") do
			t = {false, false, false, false, tnbr(d)}
			if strfind(e, "écrase") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(e, "érafle") then t[4]=1;t[1]=0;t[2]=0 end
			DB:EnemyDamage(false, DPSMateEDD, c, DPSMate.L["AutoAttack"], t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(c, DPSMate.L["AutoAttack"], t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(c, a, DPSMate.L["AutoAttack"], t[5], t[1] or 1, 0, 0, t[3] or 0)
			return
		end
		for a,c,d,f,e in strgfind(msg, "(.+) inflige un coup critique à (.+) %((%d+) points de dégâts (.*)%)%.(.*)") do
			t = {false, false, false, false, tnbr(d)}
			if strfind(e, "écrase") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(e, "érafle") then t[4]=1;t[1]=0;t[2]=0 end
			DB:EnemyDamage(false, DPSMateEDD, c, DPSMate.L["AutoAttack"], 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(c, DPSMate.L["AutoAttack"], 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(c, a, DPSMate.L["AutoAttack"], t[5], 0, t[2] or 1, 0, t[3] or 0)
			return
		end
	end
	
	DPSMate.Parser.CreatureVsCreatureMisses = function(self, msg)
		for c, ta in strgfind(msg, "(.+) attaque. (.+) absorbe tous les dégâts%.") do DB:Absorb(DPSMate.L["AutoAttack"], ta, c); return end
		for a,b,c in strgfind(msg, "(.+) attaque et (.+) pare son attaque%.") do 
			DB:EnemyDamage(false, DPSMateEDD, b, DPSMate.L["AutoAttack"], 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(b, DPSMate.L["AutoAttack"], 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) attaque et (.+) esquive%.") do 
			DB:EnemyDamage(false, DPSMateEDD, b, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageTaken(b, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) manque (.+)%.") do 
			DB:EnemyDamage(false, DPSMateEDD, b, DPSMate.L["AutoAttack"], 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(b, DPSMate.L["AutoAttack"], 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return 
		end
		for a,b in strgfind(msg, "(.+) attaque et (.+) bloque l'attaque%.") do 
			DB:EnemyDamage(false, DPSMateEDD, b, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 0, 0, 0, a, 1, 0)
			DB:DamageTaken(b, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 0, 0, 0, a, 0, 1)
			return
		end
	end
	
	DPSMate.Parser.SpellPeriodicDamageTaken = function(self, msg)
		for e,d,a,b,c,f in strgfind(msg, "(.+) de (.+) inflige à (.+) (%d+) points de dégâts (.*)%.(.*)") do -- Potential to track resisted damage and school
			t = {tnbr(b)}
			DB:EnemyDamage(false, DPSMateEDD, a, e..DPSMate.L["periodic"], 1, 0, 0, 0, 0, 0, t[1], d, 0, 0)
			DB:DamageTaken(a, e..DPSMate.L["periodic"], 1, 0, 0, 0, 0, 0, t[1], d, 0, 0)
			DB:DeathHistory(a, d, e..DPSMate.L["periodic"], t[1], 1, 0, 0, 0)
			if self.FailDT[e] then DB:BuildFail(2, d, a, e, t[1]) end
			DB:AddSpellSchool(e..DPSMate.L["periodic"],c)
			return
		end
		for a, b in strgfind(msg, "(.+) subit les effets de (.+)%.") do
			if strfind(b, "%(") then b=strsub(b, 1, strfind(b, "%(")-2) end;
			DB:BuildBuffs(DPSMate.L["unknown"], a, b, false)
			if self.CC[b] then DB:BuildActiveCC(a, b) end
			return
		end
		for f,a,b in strgfind(msg, "(.+) utilise (.+), mais l'effet est absorbé par (.+)%.") do -- To Test
			DB:Absorb(a..DPSMate.L["periodic"], f, b)
			return
		end
	end
	
	DPSMate.Parser.CreatureVsCreatureSpellDamage = function(self, msg)
		for b,a,d,e,f in strgfind(msg, "(.+) de (.+) touche (.+) pour (%d+) points de dégâts%.(.*)") do
			t = {false, false, tnbr(e), false}
			if strfind(f, "érafle") then t[4]=1;t[1]=0 end
			DB:UnregisterPotentialKick(d, b, GetTime())
			DB:EnemyDamage(false, DPSMateEDD, d, b, t[1] or 1, 0, 0, 0, 0, 0, t[3], a, t[4] or 0, 0)
			DB:DamageTaken(d, b, t[1] or 1, 0, 0, 0, 0, 0, t[3], a, 0, t[4] or 0)
			DB:DeathHistory(d, a, b, t[3], t[1] or 1, 0, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, d, b, t[3]) end
			return
		end
		for a,b,d,e,g,f in strgfind(msg, "(.+) lance (.+) sur (.+) et lui inflige (%d+) points de dégâts (.*)%.(.*)") do
			t = {false, false, tnbr(e), false}
			if strfind(f, "érafle") then t[4]=1;t[1]=0 end
			DB:UnregisterPotentialKick(d, b, GetTime())
			DB:EnemyDamage(false, DPSMateEDD, d, b, t[1] or 1, 0, 0, 0, 0, 0, t[3], a, t[4] or 0, 0)
			DB:DamageTaken(d, b, t[1] or 1, 0, 0, 0, 0, 0, t[3], a, 0, t[4] or 0)
			DB:DeathHistory(d, a, b, t[3], t[1] or 1, 0, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, d, b, t[3]) end
			DB:AddSpellSchool(b,g)
			return
		end
		for a,b,d,e,g,f in strgfind(msg, "(.+) lance (.+) et inflige un coup critique à (.+) %((%d+) points de dégâts%s?(.*)%)%.(.*)") do
			t = {false, false, tnbr(e), false}
			if strfind(f, "érafle") then t[4]=1;t[2]=0 end
			DB:UnregisterPotentialKick(d, b, GetTime())
			DB:EnemyDamage(false, DPSMateEDD, d, b, 0, t[2] or 1, 0, 0, 0, 0, t[3], a, t[4] or 0, 0)
			DB:DamageTaken(d, b, 0, t[2] or 1, 0, 0, 0, 0, t[3], a, 0, t[4] or 0)
			DB:DeathHistory(d, a, b, t[3], 0, t[2] or 1, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, d, b, t[3]) end
			DB:AddSpellSchool(b,g)
			return
		end
		for c,b,a in strgfind(msg, "(.+) esquive (.+) de (.+)%.") do
			DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			return
		end
		for a,b,c in strgfind(msg, "(.+) pare (.+) de (.+)%.") do
			DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			return
		end
		for b,a,c in strgfind(msg, "(.+) voit son (.+) manquer (.+)%.") do 
			DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return
		end
		for a,b,c in strgfind(msg, "(.+) utilise (.+), mais (.+) résiste%.") do
			DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.+) utilise (.+), mais l'effet est absorbé par (.+)%.") do
			DB:Absorb(a, f, b)
			return
		end
	end

	----------------------------------------------------------------------------------
	--------------                       Healing                        --------------                                  
	----------------------------------------------------------------------------------
	
	local HealingStream = "Guérisseur"
	DPSMate.Parser.SpellSelfBuff = function(self, msg)
		for a,c in strgfind(msg, "Votre (.+) vous soigne pour (%d+) points de vie%.") do 
			t = {tnbr(c)}
			overheal = self:GetOverhealByName(t[1], self.player)
			DB:HealingTaken(0, DPSMateHealingTaken, self.player, a, 1, 0, t[1], self.player)
			DB:HealingTaken(1, DPSMateEHealingTaken, self.player, a, 1, 0, t[1]-overheal, self.player)
			DB:Healing(0, DPSMateEHealing, self.player, a, 1, 0, t[1]-overheal, self.player)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, self.player, a, 1, 0, overheal, self.player)
				DB:HealingTaken(2, DPSMateOverhealingTaken, self.player, a, 1, 0, overheal, self.player)
			end
			DB:Healing(1, DPSMateTHealing, self.player, a, 1, 0, t[1], self.player)
			DB:DeathHistory(self.player, self.player, a, t[1], 1, 0, 1, 0)
			if self.procs[a] and not self.OtherExceptions[a] then
				DB:BuildBuffs(self.player, self.player, a, true)
			end
			return
		end
		for a,b,c in strgfind(msg, "Votre (.+) soigne (.+) pour (%d+) points de vie%.") do 
			t = {tnbr(c)}
			overheal = self:GetOverhealByName(t[1], b)
			DB:HealingTaken(0, DPSMateHealingTaken, b, a, 1, 0, t[1], self.player)
			DB:HealingTaken(1, DPSMateEHealingTaken, b, a, 1, 0, t[1]-overheal, self.player)
			DB:Healing(0, DPSMateEHealing, self.player, a, 1, 0, t[1]-overheal, b)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, self.player, a, 1, 0, overheal, b)
				DB:HealingTaken(2, DPSMateOverhealingTaken, b, a, 1, 0, overheal, self.player)
			end
			DB:Healing(1, DPSMateTHealing, self.player, a, 1, 0, t[1], b)
			DB:DeathHistory(b, self.player, a, t[1], 1, 0, 1, 0)
			if self.procs[a] and not self.OtherExceptions[a] then
				DB:BuildBuffs(self.player, self.player, a, true)
			end
			return
		end
		for a,c in strgfind(msg, "Votre (.+) a un effet critique et vous rend (%d+) points de vie%.") do 
			t = {tnbr(c)}
			overheal = self:GetOverhealByName(t[1], self.player)
			DB:HealingTaken(0, DPSMateHealingTaken, self.player, a, 0, 1, t[1], self.player)
			DB:HealingTaken(1, DPSMateEHealingTaken, self.player, a, 0, 1, t[1]-overheal, self.player)
			DB:Healing(0, DPSMateEHealing, self.player, a, 0, 1, t[1]-overheal, self.player)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, self.player, a, 0, 1, overheal, self.player)
				DB:HealingTaken(2, DPSMateOverhealingTaken, self.player, a, 0, 1, overheal, self.player)
			end
			DB:Healing(1, DPSMateTHealing, self.player, a, 0, 1, t[1], self.player)
			DB:DeathHistory(self.player, self.player, a, t[1], 0, 1, 1, 0)
			return
		end
		for a,b,c in strgfind(msg, "Votre (.+) soigne (.+) avec un effet critique et lui rend (%d+) points de vie%.") do 
			t = {tnbr(c)}
			overheal = self:GetOverhealByName(t[1], b)
			DB:HealingTaken(0, DPSMateHealingTaken, b, a, 0, 1, t[1], self.player)
			DB:HealingTaken(1, DPSMateEHealingTaken, b, a, 0, 1, t[1]-overheal, self.player)
			DB:Healing(0, DPSMateEHealing, self.player, a, 0, 1, t[1]-overheal, b)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, self.player, a, 0, 1, overheal, b)
				DB:HealingTaken(2, DPSMateOverhealingTaken, b, a, 0, 1, overheal, self.player)
			end
			DB:Healing(1, DPSMateTHealing, self.player, a, 0, 1, t[1], b)
			DB:DeathHistory(b, self.player, a, t[1], 0, 1, 1, 0)
			return
		end
		for b,a in strgfind(msg, "(.+) vous fait gagner (%d+) energie%.") do
			DB:BuildBuffs(self.player, self.player, b, true)
			DB:DestroyBuffs(self.player, b)
			return
		end
		for a,b in strgfind(msg, "Vous gagnez (%d+) attaques supplémentaires grâce à (.+)%.") do
			DB:RegisterNextSwing(self.player, tnbr(a), b)
			DB:BuildBuffs(self.player, self.player, b, true)
			DB:DestroyBuffs(self.player, b)
			return
		end	
		for b,a in strgfind(msg, "(.+) vous fait gagner (%d+) rage%.") do
			if self.procs[b] and not self.OtherExceptions[b] then
				DB:BuildBuffs(self.player, self.player, b, true)
				DB:DestroyBuffs(self.player, b)
			end
			return
		end
		for b,a in strgfind(msg, "(.+) vous fait gagner (%d+) mana%.") do
			if self.procs[b] then
				DB:BuildBuffs(self.player, self.player, b, true)
				DB:DestroyBuffs(self.player, b)
			end
			return
		end
	end
	
	DPSMate.Parser.SpellPeriodicSelfBuff = function(self, msg)
		for c,b,a in strgfind(msg, "Le (.+) de (.+) vous fait gagner (%d+) points de vie%.") do
			t = {tnbr(a)}
			if c==HealingStream then
				b = self:AssociateShaman(self.player, b, false)
			end
			overheal = self:GetOverhealByName(t[1], self.player)
			DB:HealingTaken(0, DPSMateHealingTaken, self.player, c..DPSMate.L["periodic"], 1, 0, t[1], b)
			DB:HealingTaken(1, DPSMateEHealingTaken, self.player, c..DPSMate.L["periodic"], 1, 0, t[1]-overheal, b)
			DB:Healing(0, DPSMateEHealing, b, c..DPSMate.L["periodic"], 1, 0, t[1]-overheal, self.player)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, b, c..DPSMate.L["periodic"], 1, 0, overheal, self.player)
				DB:HealingTaken(2, DPSMateOverhealingTaken, self.player, c..DPSMate.L["periodic"], 1, 0, overheal, b)
			end
			DB:Healing(1, DPSMateTHealing, b, c..DPSMate.L["periodic"], 1, 0, t[1], self.player)
			DB:DeathHistory(self.player, b, c..DPSMate.L["periodic"], t[1], 1, 0, 1, 0)
			return
		end
		for b,a in strgfind(msg, "(.+) vous rend (%d+) points de vie%.") do 
			t = {tnbr(a)}
			overheal = self:GetOverhealByName(t[1], self.player)
			DB:HealingTaken(0, DPSMateHealingTaken, self.player, b..DPSMate.L["periodic"], 1, 0, t[1], self.player)
			DB:HealingTaken(1, DPSMateEHealingTaken, self.player, b..DPSMate.L["periodic"], 1, 0, t[1]-overheal, self.player)
			DB:Healing(0, DPSMateEHealing, self.player, b..DPSMate.L["periodic"], 1, 0, t[1]-overheal, self.player)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, self.player, b..DPSMate.L["periodic"], 1, 0, overheal, self.player)
				DB:HealingTaken(2, DPSMateOverhealingTaken, self.player, b..DPSMate.L["periodic"], 1, 0, overheal, self.player)
			end
			DB:Healing(1, DPSMateTHealing, self.player, b..DPSMate.L["periodic"], 1, 0, t[1], self.player)
			DB:DeathHistory(self.player, self.player, b..DPSMate.L["periodic"], t[1], 1, 0, 1, 0)
			return
		end
		for a in strgfind(msg, "Vous gagnez (.+)%.") do
			if self.BuffExceptions[a] then return end
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end
			DB:ConfirmBuff(self.player, a, GetTime())
			if self.Dispels[a] then 
				DB:RegisterHotDispel(self.player, a)
			end
			if self.RCD[a] then DPSMate:Broadcast(1, self.player, a) end
			if self.FailDB[a] then DB:BuildFail(3, "Environnement", self.player, a, 0) end
			return 
		end
	end
	
	DPSMate.Parser.SpellPeriodicFriendlyPlayerBuffs = function(self, msg)
		for c,b,a,f in strgfind(msg, "(.+) de (.+) rend (%d+) points de vie à (.+)%.") do
			t = {tnbr(a)}
			if c==HealingStream then
				b = self:AssociateShaman(a, b, false)
			end
			overheal = self:GetOverhealByName(t[1], f)
			DB:HealingTaken(0, DPSMateHealingTaken, f, c..DPSMate.L["periodic"], 1, 0, t[1], b)
			DB:HealingTaken(1, DPSMateEHealingTaken, f, c..DPSMate.L["periodic"], 1, 0, t[1]-overheal, b)
			DB:Healing(0, DPSMateEHealing, b, c..DPSMate.L["periodic"], 1, 0, t[1]-overheal, f)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, b, c..DPSMate.L["periodic"], 1, 0, overheal, f)
				DB:HealingTaken(2, DPSMateOverhealingTaken, f, c..DPSMate.L["periodic"], 1, 0, overheal, b)
			end
			DB:Healing(1, DPSMateTHealing, b, c..DPSMate.L["periodic"], 1, 0, t[1], f)
			DB:DeathHistory(f, b, c..DPSMate.L["periodic"], t[1], 1, 0, 1, 0)
			return
		end
		for b,a,f in strgfind(msg, "Votre (.+) rend (%d+) points de vie à (.+)%.") do 
			t = {tnbr(a)}
			overheal = self:GetOverhealByName(t[1], f)
			DB:HealingTaken(0, DPSMateHealingTaken, f, b..DPSMate.L["periodic"], 1, 0, t[1], self.player)
			DB:HealingTaken(1, DPSMateEHealingTaken, f, b..DPSMate.L["periodic"], 1, 0, t[1]-overheal, self.player)
			DB:Healing(0, DPSMateEHealing, self.player, b..DPSMate.L["periodic"], 1, 0, t[1]-overheal)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, self.player, b..DPSMate.L["periodic"], 1, 0, overheal)
				DB:HealingTaken(2, DPSMateOverhealingTaken, f, b..DPSMate.L["periodic"], 1, 0, overheal, self.player)
			end
			DB:Healing(1, DPSMateTHealing, self.player, b..DPSMate.L["periodic"], 1, 0, t[1])
			DB:DeathHistory(f, self.player, b..DPSMate.L["periodic"], t[1], 1, 0, 1, 0)
			return
		end
		for f,a in strgfind(msg, "(.+) gagne (.+)%.") do
			if self.BuffExceptions[a] then return end
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end
			DB:ConfirmBuff(f, a, GetTime())
			if self.Dispels[a] then
				DB:RegisterHotDispel(f, a)
			end
			if self.RCD[a] then DPSMate:Broadcast(1, f, a) end
			if self.FailDB[a] then DB:BuildFail(3, "Environnement", f, a, 0) end
			return 
		end
	end
	
	DPSMate.Parser.SpellHostilePlayerBuff = function(self, msg)
		for b,a,c,d in strgfind(msg, "Le (.+) de (.+) soigne avec un effet critique (.+), pour (%d+) points de vie%.") do 
			t = {tnbr(d)}
			overheal = self:GetOverhealByName(t[1], c)
			DB:HealingTaken(0, DPSMateHealingTaken, c, b, 0, 1, t[1], a)
			DB:HealingTaken(1, DPSMateEHealingTaken, c, b, 0, 1, t[1]-overheal, a)
			DB:Healing(0, DPSMateEHealing, a, b, 0, 1, t[1]-overheal, c)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, a, b, 0, 1, overheal, c)
				DB:HealingTaken(2, DPSMateOverhealingTaken, c, b, 0, 1, overheal, a)
			end
			DB:Healing(1, DPSMateTHealing, a, b, 0, 1, t[1], c)
			DB:DeathHistory(c, a, b, t[1], 0, 1, 1, 0)
			return
		end
		for a,b,d in strgfind(msg, "(.+) vous soigne avec (.+) et vous rend (%d+) points de vie%.") do 
			t = {tnbr(d)}
			overheal = self:GetOverhealByName(t[1], self.player)
			DB:HealingTaken(0, DPSMateHealingTaken, self.player, b, 0, 1, t[1], a)
			DB:HealingTaken(1, DPSMateEHealingTaken, self.player, b, 0, 1, t[1]-overheal, a)
			DB:Healing(0, DPSMateEHealing, a, b, 0, 1, t[1]-overheal, self.player)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, a, b, 0, 1, overheal, self.player)
				DB:HealingTaken(2, DPSMateOverhealingTaken, self.player, b, 0, 1, overheal, a)
			end
			DB:Healing(1, DPSMateTHealing, a, b, 0, 1, t[1], self.player)
			DB:DeathHistory(self.player, a, b, t[1], 0, 1, 1, 0)
			return
		end
		for b,a,c,d in strgfind(msg, "(.+) de (.+) guérit (.+) de (%d+) points de vie%.") do 
			t = {tnbr(d)}
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
		for b,a,d in strgfind(msg, "(.+) de (.+) vous soigne pour (%d+) points de vie%.") do 
			t = {tnbr(d)}
			overheal = self:GetOverhealByName(t[1], self.player)
			DB:HealingTaken(0, DPSMateHealingTaken, self.player, b, 1, 0, t[1], a)
			DB:HealingTaken(1, DPSMateEHealingTaken, self.player, b, 1, 0, t[1]-overheal, a)
			DB:Healing(0, DPSMateEHealing, a, b, 1, 0, t[1]-overheal, self.player)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, a, b, 1, 0, overheal, self.player)
				DB:HealingTaken(2, DPSMateOverhealingTaken, self.player, b, 1, 0, overheal, a)
			end
			DB:Healing(1, DPSMateTHealing, a, b, 1, 0, t[1], self.player)
			DB:DeathHistory(self.player, a, b, t[1], 1, 0, 1, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) commence à lancer (.+)%.") do
			DB:RegisterPotentialKick(a, b, GetTime())
			return
		end
		for d,c,b,a in strgfind(msg, "(.+) de (.+) fait gagner (%d+) energie à (.+)%.") do
			DB:BuildBuffs(c, a, d, true)
			DB:DestroyBuffs(c, d)
			return 
		end
		for c,b,a in strgfind(msg, "(.+) gagne (%d+) attaques supplémentaires grâce à (.+)%.") do
			DB:RegisterNextSwing(a, tnbr(b), c)
			DB:BuildBuffs(a, a, c, true)
			DB:DestroyBuffs(a, c)
			return 
		end
		for d,c,b,a in strgfind(msg, "(.+) de (.+) fait gagner (%d+) rage à (.+)%.") do
			if self.procs[d] and not self.OtherExceptions[d] then
				DB:BuildBuffs(c, a, d, true)
				DB:DestroyBuffs(c, d)
			end
			return 
		end
		for d,c,b,a in strgfind(msg, "(.+) de (.+) fait gagner (%d+) mana à (.+)%.") do
			if self.procs[d] then
				DB:BuildBuffs(c, a, d, true)
				DB:DestroyBuffs(c, d)
			end
			return 
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                       Absorbs                        --------------                                  
	----------------------------------------------------------------------------------
	
	DPSMate.Parser.CreatureVsSelfHitsAbsorb = function(self, msg)
		for c, b, d, absorbed in strgfind(msg, "(.+) vous inflige (%d+) points de dégâts%.(.*)%((%d+) absorbé%)") do DB:SetUnregisterVariables(tnbr(absorbed), DPSMate.L["AutoAttack"], c); return end
		for c, b, d,e, absorbed in strgfind(msg, "(.+) vous inflige un coup critique pour (%d+) points de dégâts(.*)%.(.*)%((%d+) absorbé%)") do DB:SetUnregisterVariables(tnbr(absorbed), DPSMate.L["AutoAttack"], c); return end
		for c, b, d,e, absorbed in strgfind(msg, "(.+) vous touche et vous inflige (%d+) points de dégâts (.*)%.(.*)%((%d+) absorbé%)") do DB:SetUnregisterVariables(tnbr(absorbed), DPSMate.L["AutoAttack"], c); return end
	end
	
	DPSMate.Parser.CreatureVsCreatureHitsAbsorb = function(self, msg)
		for c, b, a, d, absorbed in strgfind(msg, "(.+) touche (.+) et inflige (%d+) points de dégâts%.(.*)%((%d+) absorbé%)") do DB:SetUnregisterVariables(tnbr(absorbed), DPSMate.L["AutoAttack"], c); return end
		for c, b, a,e, d, absorbed in strgfind(msg, "(.+) touche (.+) et lui inflige (%d+) points de dégâts (.*)%.(.*)%((%d+) absorbé%)") do DB:SetUnregisterVariables(tnbr(absorbed), DPSMate.L["AutoAttack"], c); return end
		for c, b, a,e, d, absorbed in strgfind(msg, "(.+) inflige un coup critique à (.+) %((%d+) points de dégâts (.*))%.(.*)%((%d+) absorbé%)") do DB:SetUnregisterVariables(tnbr(absorbed), DPSMate.L["AutoAttack"], c); return end
	end
	
	DPSMate.Parser.CreatureVsSelfSpellDamageAbsorb = function(self, msg)
		for ab, c, q, b, absorbed in strgfind(msg, "(.+) de (.+) vous inflige (%d+) points de dégâts%.(.*)%((%d+) absorbé%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, c); return end
		for c, ab, q, b, absorbed in strgfind(msg, "(.+) lance (.+) et vous inflige un coup critique %((%d+) points de dégâts%)%.(.*)%((%d+) absorbé%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, c); return end
		for c, ab, q, e, b, absorbed in strgfind(msg, "(.+) lance (.+) et vous inflige (%d+) points de dégâts (.*)%.(.*)%((%d+) absorbé%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, c); return end
		for ab, c, q, e, b, absorbed in strgfind(msg, "(.+) de (.+) vous inflige un coup critique pour (%d+) points de dégâts (.*)%.(.*)%((%d+) absorbé%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, c); return end
	end
	
	DPSMate.Parser.CreatureVsCreatureSpellDamageAbsorb = function(self, msg)
		for ab, c, b, a, d, absorbed in strgfind(msg, "(.+) de (.+) touche (.+) pour (%d+) points de dégâts%.(.*)%((%d+) absorbé%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, c); return end
		for c, ab, b, a, e, d, absorbed in strgfind(msg, "(.+) lance (.+) sur (.+) et lui inflige (%d+) points de dégâts (.*)%.(.*)%((%d+) absorbé%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, c); return end
		for ab, c, b, a, e, d, absorbed in strgfind(msg, "(.+) lance (.+) et inflige un coup critique à (.+) %((%d+) points de dégâts%s?(.*)%)%.(.*)%((%d+) absorbé%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, c); return end
	end
	
	DPSMate.Parser.SpellPeriodicSelfBuffAbsorb = function(self, msg)
		for ab in strgfind(msg, "Vous gagnez (.+)%.") do if DB.ShieldFlags[ab] then DB:ConfirmAbsorbApplication(ab, self.player, GetTime()) end end
	end

	DPSMate.Parser.SpellPeriodicFriendlyPlayerBuffsAbsorb = function(self, msg)
		for ta, ab in strgfind(msg, "(.+) gagne (.+)%.") do if DB.ShieldFlags[ab] then DB:ConfirmAbsorbApplication(ab, ta, GetTime()) end end
	end
	
	DPSMate.Parser.SpellAuraGoneSelf = function(self, msg)
		for ab in strgfind(msg, "(.+) vient de se dissiper%.") do if self.BuffExceptions[ab] then return end; if strfind(ab, "%(") then ab=strsub(ab, 1, strfind(ab, "%(")-2) end;if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, self.player) end; if self.RCD[ab] then DPSMate:Broadcast(6, self.player, ab) end; DB:DestroyBuffs(self.player, ab); DB:UnregisterHotDispel(self.player, ab); DB:RemoveActiveCC(self.player, ab) end
	end
	
	DPSMate.Parser.SpellAuraGoneParty = function(self, msg)
		for ab, ta in strgfind(msg, "(.+) sur (.+) vient de se dissiper%.") do if self.BuffExceptions[ab] then return end; if strfind(ab, "%(") then ab=strsub(ab, 1, strfind(ab, "%(")-2) end;if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, ta) end; if self.RCD[ab] then DPSMate:Broadcast(6, ta, ab) end; DB:DestroyBuffs(ta, ab); DB:UnregisterHotDispel(ta, ab); DB:RemoveActiveCC(ta, ab) end
	end
	
	DPSMate.Parser.SpellAuraGoneOther = function(self, msg)
		for ab, ta in strgfind(msg, "(.+) sur (.+) vient de se dissiper%.") do if self.BuffExceptions[ab] then return end; if strfind(ab, "%(") then ab=strsub(ab, 1, strfind(ab, "%(")-2) end;if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, ta) end; if self.RCD[ab] then DPSMate:Broadcast(6, ta, ab) end; DB:DestroyBuffs(ta, ab); DB:UnregisterHotDispel(ta, ab); DB:RemoveActiveCC(ta, ab) end
	end
	
	----------------------------------------------------------------------------------
	--------------                       Dispels                        --------------                                  
	----------------------------------------------------------------------------------
	
	DPSMate.Parser.SpellSelfBuffDispels = function(self, msg)
		for ab, tar in strgfind(msg, "Vous lancez (.+) sur (.+)%.") do if self.Dispels[ab] then DB:AwaitDispel(ab, tar, self.player, GetTime()) end; if self.RCD[ab] then DPSMate:Broadcast(2, self.player, tar, ab) end; return end
		for ab in strgfind(msg, "Vous lancez (.+)%.") do if self.Dispels[ab] then DB:AwaitDispel(ab, self.player, self.player, GetTime()) end; return end
	end
	
	DPSMate.Parser.SpellHostilePlayerBuffDispels = function(self, msg)
		for c, ab, ta in strgfind(msg, "(.+) lance (.+) sur (.+)%.") do if ta=="vous" then ta = self.player end; if self.Dispels[ab] then DB:AwaitDispel(ab, ta, c, GetTime()) end; if self.RCD[ab] then DPSMate:Broadcast(2, c, ta, ab) end; return end
		for c, ab in strgfind(msg, "(.+) lance (.+)%.") do if self.Dispels[ab] then DB:AwaitDispel(ab, DPSMate.L["unknown"], c, GetTime()) end; return end
	end
	
	DPSMate.Parser.SpellBreakAura = function(self, msg) 
		for ab, ta in strgfind(msg, "(.+) n'est plus sous l'influence de (.+)%.") do DB:ConfirmRealDispel(ab, ta, GetTime()); return end
		for ab in strgfind(msg, "Suppression de votre (.+)%.") do DB:ConfirmRealDispel(ab, self.player, GetTime()); return end
	end
	
	----------------------------------------------------------------------------------
	--------------                       Deaths                         --------------                                  
	----------------------------------------------------------------------------------

	DPSMate.Parser.CombatFriendlyDeath = function(self, msg)
		if msg == "Vous êtes mort." or msg == "Vous êtes morte." then
			DB:UnregisterDeath(self.player)
		end
		for ta in strgfind(msg, "(.+) meurt%.") do 
			DB:UnregisterDeath(ta)
		end
	end

	DPSMate.Parser.CombatHostileDeaths = function(self, msg)
		for ta in strgfind(msg, "(.+) meurt%.") do 
			DB:UnregisterDeath(ta)
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                     Interrupts                       --------------                                  
	----------------------------------------------------------------------------------

	DPSMate.Parser.CreatureVsCreatureSpellDamageInterrupts = function(self, msg)
		for c, ab in strgfind(msg, "(.+) commence à lancer (.+)%.") do DB:RegisterPotentialKick(c, ab, GetTime()); return end
	end
	DPSMate.Parser.HostilePlayerSpellDamageInterrupts = function(self, msg)
		for c, ab in strgfind(msg, "(.+) commence à lancer (.+)%.") do DB:RegisterPotentialKick(c, ab, GetTime()); return end
	end
	
	-- Pet section

	DPSMate.Parser.PetHits = function(self, msg)
		for a,b,c,d in strgfind(msg, "(.+) inflige un coup critique à (.+) %((%d+) points de dégâts%)%.%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(érafle)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, t[3] or 1, 0, 0, 0, 0, t[5], b, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, t[3] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			if self.TargetParty[a] and self.TargetParty[b] then DB:BuildFail(1, b, a, DPSMate.L["AutoAttack"], t[5]);DB:DeathHistory(b, a, DPSMate.L["AutoAttack"], t[5], 0, 1, 0, 0) end
			return
		end
		for a,b,c,d in strgfind(msg, "(.+) touche (.+) et inflige (%d+) points de dégâts%.%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(érafle)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], t[3] or 1, 0, 0, 0, 0, 0, t[5], b, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], t[3] or 1, 0, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			if self.TargetParty[a] and self.TargetParty[b] then DB:BuildFail(1, b, a, DPSMate.L["AutoAttack"], t[5]);DB:DeathHistory(b, a, DPSMate.L["AutoAttack"], t[5], 1, 0, 0, 0) end
			return
		end
	end

	DPSMate.Parser.PetMisses = function(self, msg)
		for a,b in strgfind(msg, "(.+) manque (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) attaque et (.+) esquive%.") do 
			if b=="vous" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 1, 0, 0, b, 0, 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) attaque et (.+) pare son attaque%.") do 
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) attaque et (.+) bloque l'attaque%.") do 
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for c,b in strgfind(msg, "(.+) attaque. (.+) absorbe tous les dégâts%.") do DB:Absorb(DPSMate.L["AutoAttack"], b, c); return end

		-- PvP
		for a in strgfind(msg, "(.+) vous rate%.") do 
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, 0, 1, 0, 0, 0, 0, self.player, 0, 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "(.+) attaque, mais vous parez le coup%.") do 
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, 0, 0, 1, 0, 0, 0, self.player, 0, 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "(.+) attaque, mais vous bloquez le coup%.") do 
			DB:EnemyDamage(true, DPSMateEDT, a, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 0, 0, 0, self.player, 1, 0)
			DB:DamageDone(a, DPSMate.L["AutoAttack"], 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for c in strgfind(msg, "(.+) attaque. Vous absorbez tous les dégâts%.") do DB:Absorb(DPSMate.L["AutoAttack"], self.player, c); return end
	end

	DPSMate.Parser.PetSpellDamage = function(self, msg)
		for a,b,c,d,f in strgfind(msg, "(.+) de (.+) touche (.+) pour (%d+) points de dégâts%. %((%d+) absorbé%)") do 
			DB:SetUnregisterVariables(tnbr(f), a, b)
		end
		for a,f,b,c,e in strgfind(msg, "(.+) de (.+) touche (.+) pour (%d+) points de dégâts%.%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if strfind(e, "érafle") then t[4]=1;t[2]=0;t[3]=0 end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, b, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, f, a,  t[2] or 1, 0, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(f, a, t[2] or 1, 0, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[b] and self.TargetParty[f] then DB:BuildFail(1, b, f, a, t[1]);DB:DeathHistory(b, f, a, t[1], 1, 0, 0, 0) end
			return
		end
		-- Schools
		for a,b,c,d,e,f in strgfind(msg, "(.+) lance (.+) sur (.+) et lui inflige (%d+) points de dégâts (.*)%. %((%d+) absorbé%)") do 
			DB:AddSpellSchool(b,e)
			DB:SetUnregisterVariables(tnbr(f), b, a)
		end
		for f,a,b,c,d,e in strgfind(msg, "(.+) lance (.+) sur (.+) et lui inflige (%d+) points de dégâts (.*)%.%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if strfind(e, "érafle") then t[4]=1;t[2]=0;t[3]=0 end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, b, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, f, a,  t[2] or 1, 0, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(f, a, t[2] or 1, 0, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[b] and self.TargetParty[f] then DB:BuildFail(1, b, f, a, t[1]);DB:DeathHistory(b, f, a, t[1], 1, 0, 0, 0) end
			DB:AddSpellSchool(a,d)
			return
		end

		-- Normal
		for f,a,b,c,d,e in strgfind(msg, "(.+) lance (.+) et inflige un coup critique à (.+) %((%d+) points de dégâts%s?(.*)%)%.%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if strfind(e, "érafle") then t[4]=1;t[2]=0;end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, c, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, f, a,  0, t[2] or 1, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(f, a, 0, t[2] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[b] and self.TargetParty[f] then DB:BuildFail(1, b, f, a, t[1]);DB:DeathHistory(b, f, a, t[1], 0, 1, 0, 0) end
			DB:AddSpellSchool(a,d)
			return
		end
		for a,b,f in strgfind(msg, "(.+) esquive (.+) de (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageDone(f, b, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for b,a,f in strgfind(msg, "(.+) pare (.+) de (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.+) voit son (.+) manquer (.+)%.") do
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.+) utilise (.+), mais (.+) résiste%.") do
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 0, 1, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 1, 0, 0, 0)
			return
		end
		for b,a,f in strgfind(msg, "(.+) bloque (.+) de (.+)%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
	end
	local gsub = string.gsub
	DPSMate.Parser:SetScript("OnEvent", function() if this[event] then this[event](gsub(arg1 or "", "DE", "de")) end end)
end
