local t = {}
local strgfind = string.gfind
local DB = DPSMate.DB
local tnbr = tonumber
local strgsub = string.gsub
local npcdb = NPCDB
local GetTime = GetTime
local strfind = string.find
local strsub = strsub



if (GetLocale() == "koKR") then
	local function removeSuffix(a)
		return strsub(a, 1, strfind(a, "[를을으이가로]")-1)
	end

	DPSMate.Parser.SelfHits = function(self, msg)
		for b,a,c,d in strgfind(msg, "(.+) 공격하여 (%d+)의 피해를 입혔습니다 %((%d+) 흡수됨%).") do
			DB:SetUnregisterVariables(tnbr(d), "자동공격", self.player)
		end
		for a,b,c in strgfind(msg, "(.+) 공격하여 (%d+)의 피해를 입혔습니다%.%s?(.*)") do
			t = {false, false, false, false, tnbr(b)}
			a = removeSuffix(a)
			if c == "(gestreift)" then t[3]=1;t[1]=0 elseif c ~= "" then t[4]=1;t[1]=0; end
			DB:EnemyDamage(true, DPSMateEDT, self.player, "자동공격", t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageDone(self.player, "자동공격", t[1] or 1, 0, 0, 0, 0, 0, t[5], t[3] or 0, t[4] or 0)
			if self.TargetParty[a] then DB:BuildFail(1, a, self.player, "자동공격", t[5]);DB:DeathHistory(a, self.player, "자동공격", t[5], 1, 0, 0, 0) end
			return
		end
		for a,b,c in strgfind(msg, "(.+) 공격하여 (%d+)의 치명상을 입혔습니다%.%s?(.*)") do
			t = {false, false, false, false, tnbr(b)}
			a = removeSuffix(a)
			DB:EnemyDamage(true, DPSMateEDT, self.player, "자동공격", 0, 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageDone(self.player, "자동공격", 0, 1, 0, 0, 0, 0, t[5], t[3] or 0, t[4] or 0)
			if self.TargetParty[a] then DB:BuildFail(1, a, self.player, "자동공격", t[5]);DB:DeathHistory(a, self.player, "자동공격", t[5], 0, 1, 0, 0) end
			return
		end
		for a in strgfind(msg, "당신은 낙하할 때의 충격으로 (%d+)의 피해를 입었습니다%.") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "가을", 1, 0, 0, 0, 0, 0, t[1], "주위", 0, 0)
			DB:DeathHistory(self.player, "주위", "가을", t[1], 1, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "당신은 용암의 열기로 인해 (%d+)의 피해를 입었습니다%.") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "용암", 1, 0, 0, 0, 0, 0, t[1], "주위", 0, 0)
			DB:DeathHistory(self.player, "주위", "용암", t[1], 1, 0, 0, 0)
			DB:AddSpellSchool("용암","화재")
			return
		end
		for a in strgfind(msg, "당신은 (%d+)의 화염 피해를 입었습니다%.") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "화재", 1, 0, 0, 0, 0, 0, t[1], "주위", 0, 0)
			DB:DeathHistory(self.player, "주위", "화재", t[1], 1, 0, 0, 0)
			DB:AddSpellSchool("화재","화재")
			return
		end
		for a in strgfind(msg, "당신은 숨을 쉴 수 없어 (%d+)의 피해를 입었습니다%.") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "익사", 1, 0, 0, 0, 0, 0, t[1], "주위", 0, 0)
			DB:DeathHistory(self.player, "주위", "익사", t[1], 1, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "당신은 독성으로 인해 (%d+)의 피해를 입었습니다%.") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "점액", 1, 0, 0, 0, 0, 0, t[1], "주위", 0, 0)
			DB:DeathHistory(self.player, "주위", "점액", t[1], 1, 0, 0, 0)
			return
		end
	end
	
	DPSMate.Parser.SelfMisses = function(self, msg)
		for a in strgfind(msg, "(.+) 공격했지만 적중하지 않았습니다%.") do 
			a = removeSuffix(a)
			DB:EnemyDamage(true, DPSMateEDT, self.player, "자동공격", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageDone(self.player, "자동공격", 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "(.+) 공격했지만 교묘히 피했습니다%.") do 
			a = removeSuffix(a)
			DB:EnemyDamage(true, DPSMateEDT, self.player, "자동공격", 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageDone(self.player, "자동공격", 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "(.+) 공격했지만 받아쳤습니다%.") do 
			a = removeSuffix(a)
			DB:EnemyDamage(true, DPSMateEDT, self.player, "자동공격", 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageDone(self.player, "자동공격", 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "(.+) 공격했지만 막아냈습니다%.") do 
			a = removeSuffix(a)
			DB:EnemyDamage(true, DPSMateEDT, self.player, "자동공격", 0, 0, 0, 0, 0, 0, 0, a, 1, 0)
			DB:DamageDone(self.player, "자동공격", 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for ta in strgfind(msg, "(.+) 공격했지만 모든 피해를 흡수했습니다%.") do DB:Absorb("자동공격", removeSuffix(ta), self.player); return end
	end
	
	DPSMate.Parser.SelfSpellDMG = function(self, msg)
		for a,b,c,d,f in strgfind(msg, "(.+) von Euch trifft (.+) für (%d+)(.*)%. %((%d+) absorbiert%)") do -- To Test
			DB:SetUnregisterVariables(tnbr(f), a, self.player)
		end
		for a,b,c,e in strgfind(msg, "(.+) (^[에게]+)에게 (%d+)의 피해를 입혔습니다%.%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			a = removeSuffix(a)
			if strfind(e, "geblockt") then t[4]=1;t[2]=0;t[3]=0 end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(self.player, a, b, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(self.player, self.player, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, self.player, a,  t[2] or 1, 0, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(self.player, a, t[2] or 1, 0, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[c] then DB:BuildFail(1, c, self.player, a, t[1]);DB:DeathHistory(c, self.player, a, t[1], 1, 0, 0, 0) end
			--DB:AddSpellSchool(a,d)
			return
		end
		for a,b,c,d,e,f in strgfind(msg, "(.+) trifft (.+)%s?(.*)%. Schaden: (%d+)(.*)\.%s?(.*)") do 
			t = {tnbr(d), false, false}
			if c=="kritisch" then t[2] = 1;t[3]=0 end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(self.player, a, b, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(self.player, self.player, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, self.player, a,  t[3] or 1, t[2] or 0, 0, 0, 0, 0, t[1], b, 0, 0)
			DB:DamageDone(self.player, a, t[3] or 1, t[2] or 0, 0, 0, 0, 0, t[1], 0, 0)
			if self.TargetParty[b] then DB:BuildFail(1, b, self.player, a, t[1]);DB:DeathHistory(b, self.player, a, t[1], t[2] or 0, t[3] or 1, 0, 0) end
			DB:AddSpellSchool(a,e)
			return
		end
		for a,b,c,d,e in strgfind(msg, "(.+) trifft (.+) kritisch: (%d+)(.*)\.%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if strfind(e, "geblockt") then t[4]=1;t[2]=0;end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(self.player, a, b, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(self.player, self.player, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, self.player, a,  0, t[2] or 1, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(self.player, a, 0, t[2] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[b] then DB:BuildFail(1, b, self.player, a, t[1]);DB:DeathHistory(b, self.player, a, t[1], 0, 1, 0, 0) end
			DB:AddSpellSchool(a,d)
			return
		end
		for a,b in strgfind(msg, "(.+) ist (.+) ausgewichen%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageDone(self.player, b, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) wurde von (.+) pariert%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(self.player, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) hat (.+) verfehlt%.") do
			DB:EnemyDamage(true, DPSMateEDT, self.player, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(self.player, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "Ihr habt es mit (.+) versucht, aber (.+) hat widerstanden%.") do
			DB:EnemyDamage(true, DPSMateEDT, self.player, a, 0, 0, 0, 0, 0, 1, 0, b, 0, 0)
			DB:DamageDone(self.player, a, 0, 0, 0, 0, 0, 1, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) wurde von (.+) geblockt%.") do 
			DB:EnemyDamage(true, DPSMateEDT, self.player, a, 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(self.player, a, 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for what, whom in strgfind(msg, "Ihr unterbrecht (.+) von (.+)%.") do
			local causeAbility = "Gegenzauber"
			if DPSMateUser[self.player] then
				if DPSMateUser[self.player][2] == "priest" then
					causeAbility = "Stille"
				end
			end
			DB:Kick(self.player, whom, causeAbility, what)
		end
	end
	
	DPSMate.Parser.PeriodicDamage = function(self, msg)
		for a,b in strgfind(msg, "(.+) ist von (.+) betroffen%.") do if strfind(b, "%(") then b=strsub(b, 1, strfind(b, "%(")-2) end; DB:ConfirmAfflicted(a, b, GetTime()); if self.CC[b] then  DB:BuildActiveCC(a, b) end; return end
		for a,b,c,d,e,f in strgfind(msg, "(.+) erleidet (%d+) (.-) von (.+) %(durch (.+)%)%.(.*)") do
			t = {tnbr(b)}
			if f~="" then
				DB:SetUnregisterVariables(tnbr(strsub(f, strfind(f, "%d+"))), e.."(Periodisch)", d)
			end
			DB:EnemyDamage(true, DPSMateEDT, d, e.."(Periodisch)", 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageDone(d, e.."(Periodisch)", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
			if self.TargetParty[a] and self.TargetParty[d] then DB:BuildFail(1, a, d, e.."(Periodisch)", t[1]);DB:DeathHistory(a, d, e.."(Periodisch)", t[1], 1, 0, 0, 0) end
			DB:AddSpellSchool(e.."(Periodisch)",c)
			return
		end
		for a,b,c,d,f in strgfind(msg, "(.+) erleidet (%d+) (.-) %(durch (.+)%)%.(.*)") do
			t = {tnbr(b)}
			if f~="" then
				DB:SetUnregisterVariables(tnbr(strsub(f, strfind(f, "%d+"))), d.."(Periodisch)", self.player)
			end
			DB:EnemyDamage(true, DPSMateEDT, self.player, d.."(Periodisch)", 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageDone(self.player, d.."(Periodisch)", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
			if self.TargetParty[a] then DB:BuildFail(1, a, self.player, d.."(Periodisch)", t[1]);DB:DeathHistory(a, self.player, d.."(Periodisch)", t[1], 1, 0, 0, 0) end
			DB:AddSpellSchool(d.."(Periodisch)",c)
			return
		end
		for f,a,b in strgfind(msg, "(.-%s*)'?s (.+) wurde von (.+) absorbiert%.") do -- To Test
			f = self:ReplaceSwString(f)
			DB:Absorb(a.."(Periodisch)", b, f)
			return
		end
		for a,b in strgfind(msg, "Euer (.+) wurde von (.+) absorbiert%.") do -- To Test
			DB:Absorb(a.."(Periodisch)", b, self.player)
			return
		end
	end
	
	DPSMate.Parser.FriendlyPlayerDamage = function(self, msg)
		for k,a,b,c,d,f in strgfind(msg, "(.-%s*)'?s (.+) trifft (.+) für (%d+)(.*)%. %((%d+) absorbiert%)") do 
			k = self:ReplaceSwString(k)
			if b=="Euch" then b=self.player end
			DB:AddSpellSchool(a,d)
			DB:SetUnregisterVariables(tnbr(f), b, k)
		end
		for f,a,b,c,d,e in strgfind(msg, "(.-%s*)'?s (.+) trifft (.+) kritisch für (%d+)(.*)\.%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if b=="Euch" then b=self.player end
			f = self:ReplaceSwString(f)
			if strfind(e, "geblockt") then t[4]=1;t[2]=0;end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, c, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, f, a,  0, t[2] or 1, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(f, a, 0, t[2] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[b] and self.TargetParty[f] then DB:BuildFail(1, b, f, a, t[1]);DB:DeathHistory(b, f, a, t[1], 0, 1, 0, 0) end
			DB:AddSpellSchool(a,d)
			return
		end
		for f,a,b,c,d,e in strgfind(msg, "(.-%s*)'?s (.+) trifft (.+) für (%d+)(.*)\.%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if b=="Euch" then b=self.player end
			f = self:ReplaceSwString(f)
			if strfind(e, "geblockt") then t[4]=1;t[2]=0;t[3]=0 end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, b, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, f, a,  t[2] or 1, 0, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(f, a, t[2] or 1, 0, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[b] and self.TargetParty[f] then DB:BuildFail(1, b, f, a, t[1]);DB:DeathHistory(b, f, a, t[1], 1, 0, 0, 0) end
			DB:AddSpellSchool(a,d)
			return
		end
		for a,b,f in strgfind(msg, "(.+) ist (.+) von (.+) ausgewichen%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageDone(f, b, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for a,f,b in strgfind(msg, "(.+) von (.+) wurde von (.+) pariert%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a,f,b in strgfind(msg, "(.+) von (.+) verfehlt (.+)%.") do
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.-%s*)'?s (.+) wurde von (.+) widerstanden%.") do
			f = self:ReplaceSwString(f)
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 0, 1, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 1, 0, 0, 0)
			return
		end
		for a,f,b in strgfind(msg, "(.+) von (.+) wurde von (.+) geblockt%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for who, what, whom in strgfind(msg, "(.-) unterbricht (.+) von (.+)%.") do
			local causeAbility = "Gegenzauber"
			if DPSMateUser[who] then
				if DPSMateUser[who][2] == "priest" then
					causeAbility = "Stille"
				end
				-- Account for felhunter silence
				if DPSMateUser[who][4] and DPSMateUser[who][6] then
					local owner = DPSMate:GetUserById(DPSMateUser[who][6])
					if owner and DPSMateUser[owner] then
						causeAbility = "Zaubersperre"
						who = owner
					end
				end
			end
			DB:Kick(who, whom, causeAbility, what)
		end
	end
	
	DPSMate.Parser.FriendlyPlayerHits = function(self, msg)
		for a,b,c,e in strgfind(msg, "(.-) trifft (.+) für (%d+) Schaden%. %((%d+) absorbiert%)") do
			DB:SetUnregisterVariables(tnbr(e), "자동공격", a)
		end
		for a,b,c,d in strgfind(msg, "(.-) trifft (.+) kritisch für (%d+) Schaden\.%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(gestreift)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			DB:EnemyDamage(true, DPSMateEDT, a, "자동공격", 0, t[3] or 1, 0, 0, 0, 0, t[5], b, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, "자동공격", 0, t[3] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			if self.TargetParty[a] and self.TargetParty[b] then DB:BuildFail(1, b, a, "자동공격", t[5]);DB:DeathHistory(b, a, "자동공격", t[5], 0, 1, 0, 0) end
			return
		end
		for a,b,c,d in strgfind(msg, "(.-) trifft (.+) für (%d+) Schaden\.%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(gestreift)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			if b=="Euch" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "자동공격", t[3] or 1, 0, 0, 0, 0, 0, t[5], b, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, "자동공격", t[3] or 1, 0, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			if self.TargetParty[a] and self.TargetParty[b] then DB:BuildFail(1, b, a, "자동공격", t[5]);DB:DeathHistory(b, a, "자동공격", t[5], 1, 0, 0, 0) end
			return
		end
		for a,c,d in strgfind(msg, "(.-) trifft Euch kritisch: (%d+) Schaden\.%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(gestreift)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			DB:EnemyDamage(true, DPSMateEDT, a, "자동공격", 0, t[3] or 1, 0, 0, 0, 0, t[5], self.player, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, "자동공격", 0, t[3] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			if self.TargetParty[a] then DB:BuildFail(1, self.player, a, "자동공격", t[5]);DB:DeathHistory(self.player, a, "자동공격", t[5], 0, 1, 0, 0) end
			return
		end
		for a,b in strgfind(msg, "(.-) verliert (%d+) Gesundheit durch Berührung mit 용암%.") do
			t = {tnbr(b)}
			DB:DamageTaken(a, "용암", 1, 0, 0, 0, 0, 0, t[1], "주위", 0, 0)
			DB:DeathHistory(a, "주위", "용암", t[1], 1, 0, 0, 0)
			DB:AddSpellSchool("용암","화재")
			return
		end
		for a,b in strgfind(msg, "(.+) verliert (%d+) Punkte aufgrund von 화재schaden%.") do
			t = {tnbr(b)}
			DB:DamageTaken(a, "화재", 1, 0, 0, 0, 0, 0, t[1], "주위", 0, 0)
			DB:DeathHistory(a, "주위", "화재", t[1], 1, 0, 0, 0)
			DB:AddSpellSchool("화재","화재")
			return
		end
		for a,b in strgfind(msg, "(.-) fällt und verliert (%d+) Gesundheit%.") do
			t = {tnbr(b)}
			DB:DamageTaken(a, "가을", 1, 0, 0, 0, 0, 0, t[1], "주위", 0, 0)
			DB:DeathHistory(a, "주위", "가을", t[1], 1, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.-) ertrinkt und verliert (%d+) Gesundheit%.") do
			t = {tnbr(b)}
			DB:DamageTaken(a, "익사", 1, 0, 0, 0, 0, 0, t[1], "주위", 0, 0)
			DB:DeathHistory(a, "주위", "익사", t[1], 1, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) verliert (%d+) Gesundheit wegen Schwimmens in 점액%.") do
			t = {tnbr(b)}
			DB:DamageTaken(a, "점액", 1, 0, 0, 0, 0, 0, t[1], "주위", 0, 0)
			DB:DeathHistory(a, "주위", "점액", t[1], 1, 0, 0, 0)
			return
		end
	end
	
	DPSMate.Parser.FriendlyPlayerMisses = function(self, msg)
		for a,b in strgfind(msg, "(.-) verfehlt (.+)%.") do 
			if b=="Euch" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "자동공격", 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(a, "자동공격", 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.-) greift an%. (.+) weicht aus%.") do 
			if b=="Ihr" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "자동공격", 0, 0, 0, 0, 1, 0, 0, b, 0, 0)
			DB:DamageDone(a, "자동공격", 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.-) greift an%. (.+) pariert%.") do 
			if b=="Ihr" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "자동공격", 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(a, "자동공격", 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.-) greift an%. (.+) blockt%.") do 
			if b=="Ihr" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "자동공격", 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(a, "자동공격", 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for c,b in strgfind(msg, "(.+) greift an%. (.+) absorbiert allen Schaden%.") do DB:Absorb("자동공격", b, c); return end
	end
	
	DPSMate.Parser.SpellDamageShieldsOnSelf = function(self, msg)
		for a,b,c in strgfind(msg, "Ihr reflektiert (%d+) (%a-) auf (.+)%.") do 
			t = {tnbr(a)}
			if c == "Euch" then c=self.player end
			DB:EnemyDamage(true, DPSMateEDT, self.player, "Reflektieren", 1, 0, 0, 0, 0, 0, t[1], c, 0, 0)
			DB:DamageDone(self.player, "Reflektieren", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
		end
	end
	
	DPSMate.Parser.SpellDamageShieldsOnOthers = function(self, msg)
		for a,b,c,d in strgfind(msg, "(.+) reflektiert (%d+) (%a-) auf (.+)%.") do
			t = {tnbr(b)}
			if d == "Euch" then d=self.player end
			if npcdb:Contains(a) or strfind(a, "%s") then
				DB:EnemyDamage(false, DPSMateEDD, d, "Reflektieren", 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
				DB:DamageTaken(d, "Reflektieren", 1, 0, 0, 0, 0, 0, t[1], a, 0,0)
				DB:DeathHistory(d, a, "Reflektieren", t[1], 1, 0, 0, 0)
			else
				DB:EnemyDamage(true, DPSMateEDT, a, "Reflektieren", 1, 0, 0, 0, 0, 0, t[1], d, 0, 0)
				DB:DamageDone(a, "Reflektieren", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
			end
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                    Damage taken                      --------------                                  
	----------------------------------------------------------------------------------

	DPSMate.Parser.CreatureVsSelfHits = function(self, msg)
		for a,c,d in strgfind(msg, "(.+) trifft Euch für (%d+)(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if strfind(d, "schmetternd") then t[3]=1;t[1]=0; elseif strfind(d, "geblockt") then t[4]=1;t[1]=0; end
			DB:EnemyDamage(false, DPSMateEDD, self.player, "자동공격", t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(self.player, "자동공격", t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(self.player, a, "자동공격", t[5], t[1] or 1, 0, 0, t[3] or 0)
			return
		end
		for a,c,d in strgfind(msg, "(.+) trifft Euch kritisch: (%d+)(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if strfind(d, "schmetternd") then t[3]=1;t[2]=0 elseif strfind(d, "geblockt") then t[4]=1;t[2]=0 end
			DB:EnemyDamage(false, DPSMateEDD, self.player, "자동공격", 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(self.player, "자동공격", 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(self.player, a, "자동공격", t[5], 0, t[2] or 1, 0, t[3] or 0)
			return
		end
	end
	
	DPSMate.Parser.CreatureVsSelfMisses = function(self, msg)
		for c in strgfind(msg, "(.+) greift an%. Ihr absorbiert allen Schaden%.") do DB:Absorb("자동공격", self.player, c); return end
		for a in strgfind(msg, "(.+) verfehlt Euch%.") do 
			DB:EnemyDamage(false, DPSMateEDD, self.player, "자동공격", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, "자동공격", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) greift an. Ihr (.+)%.") do 
			t = {false, false, false}
			if b=="pariert" then t[1]=1 elseif b=="weicht aus" then t[2]=1 else t[3]=1 end 
			DB:EnemyDamage(false, DPSMateEDD, self.player, "자동공격", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, t[3] or 0, 0)
			DB:DamageTaken(self.player, "자동공격", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, 0, t[3] or 0)
			return
		end
	end 
	
	DPSMate.Parser.CreatureVsSelfSpellDamage = function(self, msg)
		for a,b,c,d,e in strgfind(msg, "(.+) trifft Euch(.*) %(mit (.+)%)%. Schaden: (%d+)(.*)") do
			t = {false, false, tnbr(d), false}
			if b=="" then t[1]=1;t[2]=0 end
			if strfind(e, "geblockt") then t[4]=1;t[1]=0;t[2]=0 end
			DB:UnregisterPotentialKick(self.player, b, GetTime())
			DB:EnemyDamage(false, DPSMateEDD, self.player, c, t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[3], a, t[4] or 0, 0)
			DB:DamageTaken(self.player, c, t[1] or 0, t[2] or 1, 0, 0, 0, 0, t[3], a, 0, t[4] or 0)
			DB:DeathHistory(self.player, a, c, t[3], t[1] or 0, t[2] or 1, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, self.player, c, t[3]) end
			DB:AddSpellSchool(c,e)
			return
		end
		for a,b,c,d in strgfind(msg, "(.+) trifft Euch mit %'(.+)%' für (%d+)(.*)") do
			t = {tnbr(c)}
			DB:UnregisterPotentialKick(self.player, b, GetTime())
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageTaken(self.player, b, 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DeathHistory(self.player, a, b, t[1], 1, 0, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, self.player, b, t[1]) end
			DB:AddSpellSchool(b,d)
			return
		end
		for a,b,c,d in strgfind(msg, "(.-%s*)'?s (.+) trifft Euch kritisch für (%d+)(.*)") do
			t = {tnbr(c)}
			a = self:ReplaceSwString(a)
			DB:UnregisterPotentialKick(self.player, b, GetTime())
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 1, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 1, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DeathHistory(self.player, a, b, t[1], 0, 1, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, self.player, b, t[1]) end
			DB:AddSpellSchool(b,d)
			return
		end
		for a,b in strgfind(msg, "(.+) greift an %(mit (.+)%) und verfehlt Euch%.") do
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.-%s*)'?s (.+) wurde pariert%.") do
			a = self:ReplaceSwString(a)
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.-%s*)'?s (.+) wurde ausgewichen%.") do
			a = self:ReplaceSwString(a)
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+) versucht es mit (.+)%.%.%. widerstanden%.") do
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.-%s*)'?s (.+) wurde geblockt%.") do
			a = self:ReplaceSwString(a)
			DB:EnemyDamage(false, DPSMateEDD, self.player, b, 0, 0, 0, 0, 0, 0, 0, a, 1, 0)
			DB:DamageTaken(self.player, b, 0, 0, 0, 0, 0, 0, 0, a, 0, 1)
			return
		end
		for a,b in strgfind(msg, "Ihr absorbiert (.-%s*)'?s (.+)%.") do
			a = self:ReplaceSwString(a)
			DB:Absorb(b, self.player, a)
			return
		end
	end
	
	DPSMate.Parser.PeriodicSelfDamage = function(self, msg)
		for a,b,c,d,e in strgfind(msg, "Ihr erleidet (%d+) (%a+) von (.+) %(durch (.+)%)%.(.*)") do
			t = {tnbr(a)}
			DB:EnemyDamage(false, DPSMateEDD, self.player, d.."(Periodisch)", 1, 0, 0, 0, 0, 0, t[1], c, 0, 0)
			DB:DamageTaken(self.player, d.."(Periodisch)", 1, 0, 0, 0, 0, 0, t[1], c, 0, 0)
			DB:DeathHistory(self.player, c, d.."(Periodisch)", t[1], 1, 0, 0, 0)
			if self.FailDT[d] then DB:BuildFail(2, c, self.player, d, t[1]) end
			DB:AddSpellSchool(d.."(Periodisch)",b)
			return
		end
		for a in strgfind(msg, "Ihr seid von (.+) betroffen%.") do
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end;
			DB:BuildBuffs("Unbekannt", self.player, a, false)
			if self.CC[a] then DB:BuildActiveCC(self.player, a) end
			return
		end
		for a,b,d,e in strgfind(msg, "Ihr erleidet (%d+) Punkte (%a+) %(durch (.+)%)%.(.*)") do -- Potential to track school and resisted damage
			t = {tnbr(a)}
			DB:EnemyDamage(false, DPSMateEDD, self.player, d.."(Periodisch)", 1, 0, 0, 0, 0, 0, t[1], self.player, 0, 0)
			DB:DamageTaken(self.player, d.."(Periodisch)", 1, 0, 0, 0, 0, 0, t[1], self.player, 0, 0)
			DB:DeathHistory(self.player, self.player, d.."(Periodisch)", t[1], 1, 0, 0, 0)
			DB:AddSpellSchool(d.."(Periodisch)",b)
			return
		end
		for a,b in strgfind(msg, "Ihr absorbiert (.-%s*)'?s (.+)%.") do
			a = self:ReplaceSwString(a)
			DB:Absorb(b.."(Periodisch)", self.player, a)
			return
		end
	end
	
	DPSMate.Parser.CreatureVsCreatureHits = function(self, msg) 
		for a,c,d,e in strgfind(msg, "(.+) trifft (.+) kritisch für (%d+)(.*)") do
			t = {false, false, false, false, tnbr(d)}
			if strfind(e, "schmetternd") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(e, "geblockt") then t[4]=1;t[1]=0;t[2]=0 end
			DB:EnemyDamage(false, DPSMateEDD, c, "자동공격", 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(c, "자동공격", 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(c, a, "자동공격", t[5], 0, t[2] or 1, 0, t[3] or 0)
			return
		end
		for a,c,d,e in strgfind(msg, "(.+) trifft (.+) für (%d+)(.*)") do
			t = {false, false, false, false, tnbr(d)}
			if strfind(e, "schmetternd") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(e, "geblockt") then t[4]=1;t[1]=0;t[2]=0 end
			DB:EnemyDamage(false, DPSMateEDD, c, "자동공격", t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(c, "자동공격", t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(c, a, "자동공격", t[5], t[1] or 1, 0, 0, t[3] or 0)
			return
		end
	end
	
	DPSMate.Parser.CreatureVsCreatureMisses = function(self, msg)
		for c, ta in strgfind(msg, "(.+) greift an%. (.+) absorbiert allen Schaden%.") do DB:Absorb("자동공격", ta, c); return end
		for a,b,c in strgfind(msg, "(.+) greift an%. (.-) (.+)%.") do 
			t = {false, false, false}
			if c=="pariert" then t[1]=1 elseif c=="weicht aus" then t[2]=1 else t[3]=1 end 
			DB:EnemyDamage(false, DPSMateEDD, b, "자동공격", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, t[3] or 0, 0)
			DB:DamageTaken(b, "자동공격", 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, 0, t[3] or 0)
			return
		end
		for a,b in strgfind(msg, "(.+) verfehlt (.+)%.") do 
			DB:EnemyDamage(false, DPSMateEDD, b, "자동공격", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(b, "자동공격", 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return 
		end
	end
	
	DPSMate.Parser.SpellPeriodicDamageTaken = function(self, msg)
		for a,b,c,d,e,f in strgfind(msg, "(.+) erleidet (%d+) (%a+) von (.+) %(durch (.+)%)%.(.*)") do -- Potential to track resisted damage and school
			t = {tnbr(b)}
			DB:EnemyDamage(false, DPSMateEDD, a, e.."(Periodisch)", 1, 0, 0, 0, 0, 0, t[1], d, 0, 0)
			DB:DamageTaken(a, e.."(Periodisch)", 1, 0, 0, 0, 0, 0, t[1], d, 0, 0)
			DB:DeathHistory(a, d, e.."(Periodisch)", t[1], 1, 0, 0, 0)
			if self.FailDT[e] then DB:BuildFail(2, d, a, e, t[1]) end
			DB:AddSpellSchool(e.."(Periodisch)",c)
			return
		end
		for a, b in strgfind(msg, "(.+) ist von (.+) betroffen%.") do
			if strfind(b, "%(") then b=strsub(b, 1, strfind(b, "%(")-2) end;
			DB:BuildBuffs("Unbekannt", a, b, false)
			if self.CC[b] then DB:BuildActiveCC(a, b) end
			return
		end
		for f,a,b in strgfind(msg, "(.-%s*)'?s (.+) wurde von (.+) absorbiert%.") do -- To Test
			f = self:ReplaceSwString(f)
			DB:Absorb(a.."(Periodisch)", f, b)
			return
		end
	end
	
	DPSMate.Parser.CreatureVsCreatureSpellDamage = function(self, msg)
		for a,b,d,e,f in strgfind(msg, "(.-%s*)'?s (.+) trifft (.+) kritisch für (%d+)(.*)") do
			t = {false, false, tnbr(e), false}
			if strfind(f, "geblockt") then t[4]=1;t[2]=0 end
			a = self:ReplaceSwString(a)
			DB:UnregisterPotentialKick(d, b, GetTime())
			DB:EnemyDamage(false, DPSMateEDD, d, b, 0, t[2] or 1, 0, 0, 0, 0, t[3], a, t[4] or 0, 0)
			DB:DamageTaken(d, b, 0, t[2] or 1, 0, 0, 0, 0, t[3], a, 0, t[4] or 0)
			DB:DeathHistory(d, a, b, t[3], 0, t[2] or 1, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, d, b, t[3]) end
			DB:AddSpellSchool(b,f)
			return
		end
		for a,b,d,e,f in strgfind(msg, "(.-%s*)'?s (.+) trifft (.+) für (%d+)(.*)") do
			t = {false, false, tnbr(e), false}
			if strfind(f, "geblockt") then t[4]=1;t[1]=0 end
			a = self:ReplaceSwString(a)
			DB:UnregisterPotentialKick(d, b, GetTime())
			DB:EnemyDamage(false, DPSMateEDD, d, b, t[1] or 1, 0, 0, 0, 0, 0, t[3], a, t[4] or 0, 0)
			DB:DamageTaken(d, b, t[1] or 1, 0, 0, 0, 0, 0, t[3], a, 0, t[4] or 0)
			DB:DeathHistory(d, a, b, t[3], t[1] or 1, 0, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, d, b, t[3]) end
			DB:AddSpellSchool(b,f)
			return
		end
		for c,b,a in strgfind(msg, "(.+) ist (.+) von (.+) ausgewichen%.") do
			DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			return
		end
		for b,a,c in strgfind(msg, "(.+) von (.+) wurde von (.+) pariert%.") do
			DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			return
		end
		for b,a,c in strgfind(msg, "(.+) von (.+) verfehlt (.+)%.") do
			DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return
		end
		for a,b,c in strgfind(msg, "(.-%s*)'?s (.+) wurde von (.+) widerstanden%.") do
			a = self:ReplaceSwString(a)
			DB:EnemyDamage(false, DPSMateEDD, c, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.-%s*)'?s (.+) wurde von (.+) absorbiert%.") do
			f = self:ReplaceSwString(f)
			DB:Absorb(a, f, b)
			return
		end
	end

	----------------------------------------------------------------------------------
	--------------                       Healing                        --------------                                  
	----------------------------------------------------------------------------------
	
	local HealingStream = "Heilender Fluss"
	DPSMate.Parser.SpellSelfBuff = function(self, msg)
		for a,b,c in strgfind(msg, "Kritische Heilung: (.+) heilt (.+) um (%d+) Punkte.") do 
			t = {false, tnbr(c)}
			if b=="Euch" then t[1]=self.player end
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
		for a,b,c in strgfind(msg, "(.+) heilt (.+) um (%d+) Punkte%.") do 
			t = {false, tnbr(c)}
			if b=="Euch" then t[1]=self.player end
			overheal = self:GetOverhealByName(t[2], t[1] or b)
			DB:HealingTaken(0, DPSMateHealingTaken, t[1] or b, a, 1, 0, t[2], self.player)
			DB:HealingTaken(1, DPSMateEHealingTaken, t[1] or b, a, 1, 0, t[2]-overheal, self.player)
			DB:Healing(0, DPSMateEHealing, self.player, a, 1, 0, t[2]-overheal, t[1] or b)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, self.player, a, 1, 0, overheal, t[1] or b)
				DB:HealingTaken(2, DPSMateOverhealingTaken, t[1] or b, a, 1, 0, overheal, self.player)
			end
			DB:Healing(1, DPSMateTHealing, self.player, a, 1, 0, t[2], t[1] or b)
			DB:DeathHistory(t[1] or b, self.player, a, t[2], 1, 0, 1, 0)
			if self.procs[a] and not self.OtherExceptions[a] then
				DB:BuildBuffs(self.player, self.player, a, true)
			end
			return
		end
		for a,b in strgfind(msg, "Ihr bekommt (%d+) Energie durch (.+)%.") do
			DB:BuildBuffs(self.player, self.player, b, true)
			DB:DestroyBuffs(self.player, b)
			return
		end
		for b,a in strgfind(msg, "Ihr bekommt durch (.+) (%d) Extra-Angriff\e?%.") do
			DB:RegisterNextSwing(self.player, tnbr(a), b)
			DB:BuildBuffs(self.player, self.player, b, true)
			DB:DestroyBuffs(self.player, b)
			return
		end	
		for a,b in strgfind(msg, "Ihr bekommt (%d+) Wut durch (.+)%.") do
			if self.procs[b] and not self.OtherExceptions[b] then
				DB:BuildBuffs(self.player, self.player, b, true)
				DB:DestroyBuffs(self.player, b)
			end
			return
		end
		for a,b in strgfind(msg, "Ihr bekommt (%d+) Mana durch (.+)%.") do
			if self.procs[b] then
				DB:BuildBuffs(self.player, self.player, b, true)
				DB:DestroyBuffs(self.player, b)
			end
			return
		end
	end
	
	DPSMate.Parser.SpellPeriodicSelfBuff = function(self, msg)
		for a,b,c in strgfind(msg, "Ihr erhaltet (%d+) Gesundheit von (.+) %(durch (.+)%)%.") do
			t = {tnbr(a)}
			if c==HealingStream then
				b = self:AssociateShaman(self.player, b, false)
			end
			overheal = self:GetOverhealByName(t[1], self.player)
			DB:HealingTaken(0, DPSMateHealingTaken, self.player, c.."(Periodisch)", 1, 0, t[1], b)
			DB:HealingTaken(1, DPSMateEHealingTaken, self.player, c.."(Periodisch)", 1, 0, t[1]-overheal, b)
			DB:Healing(0, DPSMateEHealing, b, c.."(Periodisch)", 1, 0, t[1]-overheal, self.player)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, b, c.."(Periodisch)", 1, 0, overheal, self.player)
				DB:HealingTaken(2, DPSMateOverhealingTaken, self.player, c.."(Periodisch)", 1, 0, overheal, b)
			end
			DB:Healing(1, DPSMateTHealing, b, c.."(Periodisch)", 1, 0, t[1], self.player)
			DB:DeathHistory(self.player, b, c.."(Periodisch)", t[1], 1, 0, 1, 0)
			return
		end
		for a,b in strgfind(msg, "Ihr erhaltet (%d+) Gesundheit von (.+)%.") do 
			t = {tnbr(a)}
			overheal = self:GetOverhealByName(t[1], self.player)
			DB:HealingTaken(0, DPSMateHealingTaken, self.player, b.."(Periodisch)", 1, 0, t[1], self.player)
			DB:HealingTaken(1, DPSMateEHealingTaken, self.player, b.."(Periodisch)", 1, 0, t[1]-overheal, self.player)
			DB:Healing(0, DPSMateEHealing, self.player, b.."(Periodisch)", 1, 0, t[1]-overheal, self.player)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, self.player, b.."(Periodisch)", 1, 0, overheal, self.player)
				DB:HealingTaken(2, DPSMateOverhealingTaken, self.player, b.."(Periodisch)", 1, 0, overheal, self.player)
			end
			DB:Healing(1, DPSMateTHealing, self.player, b.."(Periodisch)", 1, 0, t[1], self.player)
			DB:DeathHistory(self.player, self.player, b.."(Periodisch)", t[1], 1, 0, 1, 0)
			return
		end
		for a in strgfind(msg, "Ihr bekommt %'(.+)%'%.") do
			if strfind(a, "von") then return end
			if self.BuffExceptions[a] then return end
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end 
			DB:ConfirmBuff(self.player, a, GetTime())
			if self.Dispels[a] then 
				DB:RegisterHotDispel(self.player, a)
			end
			if self.RCD[a] then DPSMate:Broadcast(1, self.player, a) end
			if self.FailDB[a] then DB:BuildFail(3, "주위", self.player, a, 0) end
			return 
		end
	end
	
	DPSMate.Parser.SpellPeriodicFriendlyPlayerBuffs = function(self, msg)
		for f,a,b,c in strgfind(msg, "(.+) erhält (%d+) Gesundheit von (.-%s*)'?s (.+)%.") do
			t = {tnbr(a)}
			b = self:ReplaceSwString(b)
			if c==HealingStream then
				b = self:AssociateShaman(a, b, false)
			end
			overheal = self:GetOverhealByName(t[1], f)
			DB:HealingTaken(0, DPSMateHealingTaken, f, c.."(Periodisch)", 1, 0, t[1], b)
			DB:HealingTaken(1, DPSMateEHealingTaken, f, c.."(Periodisch)", 1, 0, t[1]-overheal, b)
			DB:Healing(0, DPSMateEHealing, b, c.."(Periodisch)", 1, 0, t[1]-overheal, f)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, b, c.."(Periodisch)", 1, 0, overheal, f)
				DB:HealingTaken(2, DPSMateOverhealingTaken, f, c.."(Periodisch)", 1, 0, overheal, b)
			end
			DB:Healing(1, DPSMateTHealing, b, c.."(Periodisch)", 1, 0, t[1], f)
			DB:DeathHistory(f, b, c.."(Periodisch)", t[1], 1, 0, 1, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.+) erhält (%d+) Gesundheit durch (.+)%.") do 
			t = {tnbr(a)}
			overheal = self:GetOverhealByName(t[1], f)
			DB:HealingTaken(0, DPSMateHealingTaken, f, b.."(Periodisch)", 1, 0, t[1], self.player)
			DB:HealingTaken(1, DPSMateEHealingTaken, f, b.."(Periodisch)", 1, 0, t[1]-overheal, self.player)
			DB:Healing(0, DPSMateEHealing, self.player, b.."(Periodisch)", 1, 0, t[1]-overheal)
			if overheal>0 then 
				DB:Healing(2, DPSMateOverhealing, self.player, b.."(Periodisch)", 1, 0, overheal)
				DB:HealingTaken(2, DPSMateOverhealingTaken, f, b.."(Periodisch)", 1, 0, overheal, self.player)
			end
			DB:Healing(1, DPSMateTHealing, self.player, b.."(Periodisch)", 1, 0, t[1])
			DB:DeathHistory(f, self.player, b.."(Periodisch)", t[1], 1, 0, 1, 0)
			return
		end
		for f,a in strgfind(msg, "(.-) bekommt %'(.+)%'%.") do
			if strfind(a, "von") then return end
			if self.BuffExceptions[a] then return end
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end
			DB:ConfirmBuff(f, a, GetTime())
			if self.Dispels[a] then
				DB:RegisterHotDispel(f, a)
			end
			if self.RCD[a] then DPSMate:Broadcast(1, f, a) end
			if self.FailDB[a] then DB:BuildFail(3, "주위", f, a, 0) end
			return 
		end
	end
	
	DPSMate.Parser.SpellHostilePlayerBuff = function(self, msg)
		for a,b,c,d in strgfind(msg, "Kritische Heilung: (.-%s*)'?s (.+) heilt (.+) um (%d+) Punkte%.") do 
			t = {tnbr(d), false}
			a = self:ReplaceSwString(a)
			if c=="Euch" then t[2]=self.player end
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
		for a,b,c,d in strgfind(msg, "(.-%s*)'?s (.+) heilt (.+) um (%d+) Punkte%.") do 
			t = {tnbr(d), false}
			a = self:ReplaceSwString(a)
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
		for a,b,d in strgfind(msg, "(.+) benutzt (.+) und heilt Euch um (%d+) Punkte%.") do 
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
		for a,b in strgfind(msg, "(.+) beginnt (.+) zu wirken%.")  do
			DB:RegisterPotentialKick(a, b, GetTime())
			return
		end
		for a,b,c,d in strgfind(msg, "(.+) bekommt (%d+) Energie durch (.-%s*)'?s (.+)%.") do
			c = self:ReplaceSwString(c)
			DB:BuildBuffs(c, a, d, true)
			DB:DestroyBuffs(c, d)
			return 
		end
		for a,c,b in strgfind(msg, "(.+) bekommt durch (.+) (%d+) Extra-Angriff\e?%.") do
			DB:RegisterNextSwing(a, tnbr(b), c)
			DB:BuildBuffs(a, a, c, true)
			DB:DestroyBuffs(a, c)
			return 
		end
		for a,b,c,d in strgfind(msg, "(.+) bekommt (%d+) Wut durch (.-%s*)'?s (.+)%.") do
			if self.procs[d] and not self.OtherExceptions[d] then
				c = self:ReplaceSwString(c)
				DB:BuildBuffs(c, a, d, true)
				DB:DestroyBuffs(c, d)
			end
			return 
		end
		for a,b,c,d in strgfind(msg, "(.+) bekommt (%d+) Mana durch (.-%s*)'?s (.+)%.") do
			if self.procs[d] then
				c = self:ReplaceSwString(c)
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
		for c, b, d, absorbed in strgfind(msg, "(.+) trifft Euch für (%d+) Schaden%.(.*)%((%d+) absorbiert%)") do DB:SetUnregisterVariables(tnbr(absorbed), "자동공격", c); return end
		for c, b, d, absorbed in strgfind(msg, "(.+) trifft Euch kritisch für (%d+) Schaden%.(.*)%((%d+) absorbiert%)") do DB:SetUnregisterVariables(tnbr(absorbed), "자동공격", c); return end
	end
	
	DPSMate.Parser.CreatureVsCreatureHitsAbsorb = function(self, msg)
		for c, b, a, d, absorbed in strgfind(msg, "(.+) trifft (.+) kritisch für (%d+) Schaden%.(.*)%((%d+) absorbiert%)") do DB:SetUnregisterVariables(tnbr(absorbed), "자동공격", c); return end
		for c, b, a, d, absorbed in strgfind(msg, "(.+) trifft (.+) für (%d+) Schaden%.(.*)%((%d+) absorbiert%)") do DB:SetUnregisterVariables(tnbr(absorbed), "자동공격", c); return end
	end
	
	DPSMate.Parser.CreatureVsSelfSpellDamageAbsorb = function(self, msg)
		for c, q, ab, b, a, d, absorbed in strgfind(msg, "(.+) trifft Euch(.*) mit %'(.+)%' für (.+)%.(.*)%((%d+) absorbiert%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, c); return end
		for c, q, ab, b, a, d, absorbed in strgfind(msg, "(.+) trifft Euch(.*) %(mit (.+)%)%. Schaden: (%d+)(.*)%((%d+) absorbiert%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, c); return end
		for c, ab, b, a, d, absorbed in strgfind(msg, "(.-%s*)'?s (.+) trifft Euch kritisch für (%d+)(.*)%((%d+) absorbiert%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, c); return end
	end
	
	DPSMate.Parser.CreatureVsCreatureSpellDamageAbsorb = function(self, msg)
		for c, ab, b, a, d, absorbed in strgfind(msg, "(.-%s*)'?s (.+) trifft (.+) kritisch für (.*)%((%d+) absorbiert%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, self:ReplaceSwString(c)); return end
		for c, ab, b, a, d, absorbed in strgfind(msg, "(.-%s*)'?s (.+) trifft (.+) für (.+)%.(.*)%((%d+) absorbiert%)") do DB:SetUnregisterVariables(tnbr(absorbed), ab, self:ReplaceSwString(c)); return end
	end
	
	DPSMate.Parser.SpellPeriodicSelfBuffAbsorb = function(self, msg)
		for ab in strgfind(msg, "Ihr bekommt %'(.+)%'%.") do if DB.ShieldFlags[ab] then DB:ConfirmAbsorbApplication(ab, self.player, GetTime()) end end
	end

	DPSMate.Parser.SpellPeriodicFriendlyPlayerBuffsAbsorb = function(self, msg)
		for ta, ab in strgfind(msg, "(.-) bekommt %'(.+)%'%.") do if DB.ShieldFlags[ab] then DB:ConfirmAbsorbApplication(ab, ta, GetTime()) end end
	end
	
	DPSMate.Parser.SpellAuraGoneSelf = function(self, msg)
		for ab in strgfind(msg, "%'(.+)%' schwindet von Euch%.") do if self.BuffExceptions[ab] then return end; if strfind(ab, "%(") then ab=strsub(ab, 1, strfind(ab, "%(")-2) end;if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, self.player) end; if self.RCD[ab] then DPSMate:Broadcast(6, self.player, ab) end; DB:DestroyBuffs(self.player, ab); DB:UnregisterHotDispel(self.player, ab); DB:RemoveActiveCC(self.player, ab) end
	end
	
	DPSMate.Parser.SpellAuraGoneParty = function(self, msg)
		for ab, ta in strgfind(msg, "%'(.+)%' schwindet von (.-)%.") do if self.BuffExceptions[ab] then return end; if strfind(ab, "%(") then ab=strsub(ab, 1, strfind(ab, "%(")-2) end;if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, ta) end; if self.RCD[ab] then DPSMate:Broadcast(6, ta, ab) end; DB:DestroyBuffs(ta, ab); DB:UnregisterHotDispel(ta, ab); DB:RemoveActiveCC(ta, ab) end
	end
	
	DPSMate.Parser.SpellAuraGoneOther = function(self, msg)
		for ab, ta in strgfind(msg, "%'(.+)%' schwindet von (.-)%.") do if self.BuffExceptions[ab] then return end; if strfind(ab, "%(") then ab=strsub(ab, 1, strfind(ab, "%(")-2) end;if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, ta) end; if self.RCD[ab] then DPSMate:Broadcast(6, ta, ab) end; DB:DestroyBuffs(ta, ab); DB:UnregisterHotDispel(ta, ab); DB:RemoveActiveCC(ta, ab) end
	end
	
	----------------------------------------------------------------------------------
	--------------                       Dispels                        --------------                                  
	----------------------------------------------------------------------------------
	
	DPSMate.Parser.SpellSelfBuffDispels = function(self, msg)
		for ab, tar in strgfind(msg, "Ihr wirkt (.+) auf (.-)%.") do if self.Dispels[ab] then DB:AwaitDispel(ab, tar, self.player, GetTime()) end; if self.RCD[ab] then DPSMate:Broadcast(2, self.player, tar, ab) end; return end
		for ab in strgfind(msg, "Ihr wirkt (.+)%.") do if self.Dispels[ab] then DB:AwaitDispel(ab, self.player, self.player, GetTime()) end; return end
	end
	
	DPSMate.Parser.SpellHostilePlayerBuffDispels = function(self, msg)
		for c, ab, ta in strgfind(msg, "(.+) wirkt (.+) auf (.-)%.") do if ta=="Euch" then ta = self.player end; if self.Dispels[ab] then DB:AwaitDispel(ab, ta, c, GetTime()) end; if self.RCD[ab] then DPSMate:Broadcast(2, c, ta, ab) end; return end
		for c, ab in strgfind(msg, "(.+) wirkt (.+)%.") do if self.Dispels[ab] then DB:AwaitDispel(ab, "Unbekannt", c, GetTime()) end; return end
	end
	
	DPSMate.Parser.SpellBreakAura = function(self, msg) 
		for ab, ta in strgfind(msg, "%'(.+)%' von (.+) wurde entfernt%.") do DB:ConfirmRealDispel(ab, ta, GetTime()); return end
		for ab in strgfind(msg, "(.+) wurde entfernt%.") do DB:ConfirmRealDispel(ab, self.player, GetTime()); return end
	end
	
	----------------------------------------------------------------------------------
	--------------                       Deaths                         --------------                                  
	----------------------------------------------------------------------------------

	DPSMate.Parser.CombatFriendlyDeath = function(self, msg)
		for ta,kind in strgfind(msg, "(.-) (.-)%.") do if ta=="Ihr" then DB:UnregisterDeath(self.player) else DB:UnregisterDeath(ta) end end
	end

	DPSMate.Parser.CombatHostileDeaths = function(self, msg)
		for ta in strgfind(msg, "(.+) stirbt%.") do 
			DB:UnregisterDeath(ta)
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                     Interrupts                       --------------                                  
	----------------------------------------------------------------------------------

	DPSMate.Parser.CreatureVsCreatureSpellDamageInterrupts = function(self, msg)
		for c, ab in strgfind(msg, "(.+) beginnt (.+) zu wirken%.") do DB:RegisterPotentialKick(c, ab, GetTime()); return end
	end
	DPSMate.Parser.HostilePlayerSpellDamageInterrupts = function(self, msg)
		for c, ab in strgfind(msg, "(.-) beginnt (.+) zu wirken%.") do DB:RegisterPotentialKick(c, ab, GetTime()); return end
	end
	
	-- Pet section

	DPSMate.Parser.PetHits = function(self, msg)
		for a,b,c,d in strgfind(msg, "(.-) trifft (.+) kritisch für (%d+) Schaden\.%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(gestreift)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			DB:EnemyDamage(true, DPSMateEDT, a, "자동공격", 0, t[3] or 1, 0, 0, 0, 0, t[5], b, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, "자동공격", 0, t[3] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			if self.TargetParty[a] and self.TargetParty[b] then DB:BuildFail(1, b, a, "자동공격", t[5]) end
			return
		end
		for a,b,c,d in strgfind(msg, "(.-) trifft (.+) für (%d+) Schaden\.%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(gestreift)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			if b=="Euch" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "자동공격", t[3] or 1, 0, 0, 0, 0, 0, t[5], b, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, "자동공격", t[3] or 1, 0, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			if self.TargetParty[a] and self.TargetParty[b] then DB:BuildFail(1, b, a, "자동공격", t[5]) end
			return
		end
		for a,c,d in strgfind(msg, "(.-) trifft Euch kritisch: (%d+) Schaden\.%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(gestreift)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			DB:EnemyDamage(true, DPSMateEDT, a, "자동공격", 0, t[3] or 1, 0, 0, 0, 0, t[5], self.player, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, "자동공격", 0, t[3] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0)
			if self.TargetParty[a] then DB:BuildFail(1, self.player, a, "자동공격", t[5]) end
			return
		end
	end

	DPSMate.Parser.PetMisses = function(self, msg)
		for a,b in strgfind(msg, "(.-) verfehlt (.+)%.") do 
			if b=="Euch" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "자동공격", 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(a, "자동공격", 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.-) greift an%. (.+) weicht aus%.") do 
			if b=="Ihr" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "자동공격", 0, 0, 0, 0, 1, 0, 0, b, 0, 0)
			DB:DamageDone(a, "자동공격", 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.-) greift an%. (.+) pariert%.") do 
			if b=="Ihr" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "자동공격", 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(a, "자동공격", 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.-) greift an%. (.+) blockt%.") do 
			if b=="Ihr" then b=self.player end
			DB:EnemyDamage(true, DPSMateEDT, a, "자동공격", 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(a, "자동공격", 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
	end

	DPSMate.Parser.PetSpellDamage = function(self, msg)
		for f,a,b,c,d,e in strgfind(msg, "(.-%s*)'?s (.+) trifft (.+) kritisch für (%d+)(.*)\.%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			f = self:ReplaceSwString(f)
			if strfind(e, "geblockt") then t[4]=1;t[2]=0;end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, c, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, f, a,  0, t[2] or 1, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(f, a, 0, t[2] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[b] and self.TargetParty[f] then DB:BuildFail(1, b, f, a, t[1]) end
			return
		end
		for f,a,b,c,d,e in strgfind(msg, "(.-%s*)'?s (.+) trifft (.+) für (%d+)(.*)\.%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			f = self:ReplaceSwString(f)
			if strfind(e, "geblockt") then t[4]=1;t[2]=0;t[3]=0 end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, b, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
			DB:EnemyDamage(true, DPSMateEDT, f, a,  1, 0, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(f, a, 1, 0, 0, 0, 0, 0, t[1], 0, t[4] or 0)
			if self.TargetParty[b] and self.TargetParty[f] then DB:BuildFail(1, b, f, a, t[1]) end
			return
		end
		for a,b,f in strgfind(msg, "(.+) ist (.+) von (.+) ausgewichen%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageDone(f, b, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for a,f,b in strgfind(msg, "(.+) von (.+) wurde von (.+) pariert%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a,f,b in strgfind(msg, "(.+) von (.+) verfehlt (.+)%.") do
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.-%s*)'?s (.+) wurde von (.+) widerstanden%.") do
			f = self:ReplaceSwString(f)
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 0, 1, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 1, 0, 0, 0)
			return
		end
		for a,f,b in strgfind(msg, "(.+) von (.+) wurde von (.+) geblockt%.") do 
			DB:EnemyDamage(true, DPSMateEDT, f, a, 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
	end
end
