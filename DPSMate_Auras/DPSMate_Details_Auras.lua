-- Global Variables
DPSMate.Modules.Auras = {}

-- Local variables
local DetailsUser = ""
local g, g2
local curKey = 1
local db, cbt = {}, 0
local Buffpos, Debuffpos = 0, 0
local BuffposComp, DebuffposComp = 0, 0
local t1, t2, t3, t4
local t1TL, t2TL, t3TL, t4TL = 0, 0
local _G = getglobal
local tinsert = table.insert
local strformat = string.format

-- Remember to update the processing list before starting to put on the localization
DPSMate.Modules.Auras.Debuffs = {
	["Rend"] = true,
	["Net"] = true,
	["Poison"] = true,
	["Blizzard"] = true,
	["Winter's Chill"] = true,
	["Chilled"] = true,
	["Frostbolt"] = true,
	["Frostbite"] = true,
	["Cone of Cold"] = true,
	["Frost Nova"] = true,
	["Dazed"] = true,
	["Volatile Infection"] = true,
	["Disarm"] = true,
	["Psychic Scream"] = true,
	["Corrosive Acid Spit"] = true,
	["Poison Mind"] = true,
	["Knockdown"] = true,
	["Smite"] = true,
	["Mind Flay"] = true,
	["Withering Heat"] = true,
	["Ancient Dread"] = true,
	["Ignite Mana"] = true,
	["Ground Stomp"] = true,
	["Blast Wave"] = true,
	["Lucifron's Curse"] = true,
	["Hand of Ragnaros"] = true,
	["Demoralizing Shout"] = true,
	["Incite Flames"] = true,
	["Magma Shackles"] = true,
	["Sunder Armor"] = true,
	["Melt Armor"] = true,
	["Rain of Fire"] = true,
	["Serrated Bite"] = true,
	["Ancient Hysteria"] = true,
	["Shazzrah's Curse"] = true,
	["Fist of Ragnaros"] = true,
	["Magma Spit"] = true,
	["Pyroclast Barrage"] = true,
	["Gehennas' Curse"] = true,
	["Impending Doom"] = true,
	["Conflagration"] = true,
	["Living Bomb"] = true,
	["Mangle"] = true,
	["Panic"] = true,
	["Immolate"] = true,
	["Magma Splash"] = true,
	["Weakened Soul"] = true,
	["Elemental Fire"] = true,
	["Shadow Word: Pain"] = true,
	["Soul Burn"] = true,
	["Consecration"] = true,
	["Judgement of the Crusader"] = true,
	["Curse of Agony"] = true,
	["Judgement of Wisdom"] = true,
	["Hunter's Mark"] = true,
	["Siphon Life"] = true,
	["Challenging Shout"] = true,
	["Vampiric Embrace"] = true,
	["Mocking Blow"] = true,
	["Scorpid Sting"] = true,
	["Deep Wounds"] = true,
	["Drain Life"] = true,
	["Expose Weakness"] = true,
	["Serpent Sting"] = true,
	["Faerie Fire (Feral)"] = true,
	["Rupture"] = true,
	["Rake"] = true,
	["Taunt"] = true,
	["Thunderfury"] = true,
	["Rip"] = true,
	["Corruption"] = true,
	["Moonfire"] = true,
	["Judgement of Light"] = true,
	["Shadow Vulnerability"] = true,
	["Forbearance"] = true,
	["Flamestrike"] = true,
	["Intercept Stun"] = true,
	["Volley"] = true,
	["Pyroclasm"] = true,
	["Curse of Recklessness"] = true,
	["Hellfire"] = true,
	["Essence of the Red"] = true,
	["Growing Flames"] = true,
	["Brood Affliction: Blue"] = true,
	["Brood Affliction: Green"] = true,
	["Brood Affliction: Red"] = true,
	["Brood Affliction: Black"] = true,
	["Brood Affliction: Bronze"] = true,
	["Brood Power: Green"] = true,
	["Brood Power: Red"] = true,
	["Brood Power: Blue"] = true,
	["War Stomp"] = true,
	["Thunderclap"] = true,
	["Veil of Shadow"] = true,
	["Flame Buffet"] = true,
	["Flame Shock"] = true,
	["Suppression Aura"] = true,
	["Burning Adrenaline"] = true,
	["Flame Breath"] = true,
	["Bottle of Poison"] = true,
	["Shadow of Ebonroc"] = true,
	["Tail Lash"] = true,
	["Dropped Weapon"] = true,
	["Bellowing Roar"] = true,
	["Greater Polymorph"] = true,
	["Ignite Flesh"] = true,
	["Mortal Strike"] = true,
	["Corrupted Healing"] = true,
	["Inferno Effect"] = true,
	["Time Lapse"] = true,
	["Frost Trap Aura"] = true,
	["Thorium Grenade"] = true,
	["Kreeg's Stout Beatdown"] = true,
	["Mark of Detonation"] = true,
	["Shadow Command"] = true,
	["Curse of Tongues"] = true,
	["Fear"] = true,
	["Siphon Blessing"] = true,
	["Recently Bandaged"] = true,
	["Blind"] = true,
	["Involuntary Transformation"] = true,
	["Polymorph: Pig"] = true,
	["Stunning Blow"] = true,
	["Silence"] = true,
	["Touch of Weakness"] = true,
	["Shadow Flame"] = true,
	["Demoralizing Roar"] = true,
	["Pyroblast"] = true,
	["Cauterizing Flames"] = true,
	["Poisonous Blood"] = true,
	["Poison Bolt Volley"] = true,
	["Venom Spit"] = true,
	["Delusions of Jin'do"] = true,
	["Intimidating Roar"] = true,
	["Poison Cloud"] = true,
	["Hex"] = true,
	["Enveloping Webs"] = true,
	["Will of Hakkar"] = true,
	["Polymorph"] = true,
	["Brain Wash"] = true,
	["Whirling Trip"] = true,
	["Gouge"] = true,
	["Threatening Gaze"] = true,
	["Corrupted Blood"] = true,
	["Cause Insanity"] = true,
	["Curse of Weakness"] = true,
	["Death Coil"] = true,
	["Entangling Roots"] = true,
	["Curse of Shadow"] = true,
	["Mark of Arlokk"] = true,
	["Corrosive Poison"] = true,
	["Charge"] = true,
	["Scatter Shot"] = true,
	["Blood Siphon"] = true,
	["Axe Flurry"] = true,
	["Fixate"] = true,
	["Sonic Burst"] = true,
	["Fall down"] = true,
	["Curse of Blood"] = true,
	["Shrink"] = true,
	["Parasitic Serpent"] = true,
	["Shield Slam"] = true,
	["Fireball"] = true,
	["Soul Tap"] = true,
	["Pierce Armor"] = true,
	["Holy Fire"] = true,
	["Slowing Poison"] = true,
	["Web Spin"] = true,
	["Infected Bite"] = true,
	["Tranquilizing Poison"] = true,
	["Intoxicating Venom"] = true,
	["Concussion Blow"] = true,
	["Faerie Fire"] = true,
	["Explosive Trap Effect"] = true,
	["Mind Control"] = true,
	["Ancient Despair"] = true,
	["Detect Magic"] = true,
	["Curse of the Elements"] = true,
	["Sand Trap"] = true,
	["Hive'Zara Catalyst"] = true,
	["Intimidating Shout"] = true,
	["Creeping Plague"] = true,
	["Sundering Cleave"] = true,
	["Poison Bolt"] = true,
	["Curse of Doom"] = true,
	["Consume"] = true,
	["Shadowburn"] = true,
	["Ignite"] = true,
	["Deadly Poison V"] = true,
	["Dreamless Sleep"] = true,
	["Corrosive Acid"] = true,
	["Chromatic Mutation"] = true,
	["Insect Swarm"] = true,
	["Greater Polymorph"] = true,
	["Brood Power: Bronze"] = true,
	["Sacrifice"] = true,
	["Toxic Volley"] = true,
	["Mortal Wound"] = true,
	["Impale"] = true,
	["Noxious Poison"] = true,
	["Unbalancing Strike"] = true,
	["True Fulfillment"] = true,
	["Acid Spit"] = true,
	["Debilitating Charge"] = true,
	["Plague"] = true,
	["Crippling Poison"] = true,
	["Entangle"] = true,
	["Mind-numbing Poison"] = true,
	["Toxic Vapors"] = true,
	["Frost Burn"] = true,
	["Wild Magic"] = true,
	["Paralyze"] = true,
	["Hammer of Justice"] = true,
	["Flame Lash"] = true,
	["Blinding Light"] = true,
	["Wild Polymorph"] = true,
	["Mind Vision"] = true,
	["Berserk"] = true,
	["Summon Infernals"] = true,
	["Spell Vulnerability"] = true,
	["Wyvern Sting"] = true,
	["Hurricane"] = true,
	["Ravage"] = true,
	["Greater Dreamless Sleep"] = true,
	["Speed Slash"] = true,
	["Deafening Screech"] = true,
	["Mother's Milk"] = true,
	["Acid Splash"] = true,
	["Snap Kick"] = true,
	["Disease Cloud"] = true,
	["Blood Craze"] = true,
	["Charge Stun"] = true,
	["Swoop"] = true,
	["Deadly Poison IV"] = true,
	["Unholy Frenzy"] = true,
	["Mortal Cleave"] = true,
	["Freezing Trap Effect"] = true,
	["Garrote"] = true,
	["Hamstring"] = true,
	["Cheap Shot"] = true,
	["Kidney Shot"] = true,
	["Shield Bash - Silenced"] = true,
	["Improved Concussive Shot"] = true,
	["Sleep"] = true,
	["Consuming Shadows"] = true,
	["Frost Breath"] = true,
	["Spell Blasting"] = true,
	["Tendon Rip"] = true,
	["Soul Siphon"] = true,
	["Evil Twin"] = true,
	["Counterspell - Silenced"] = true,
	["Toxin"] = true,
	["Mana Burn"] = true,
	["Dust Cloud"] = true,
	["Digestive Acid"] = true,
	["Sand Blast"] = true,
	["Wing Clip"] = true,
	["Fire Vulnerability"] = true,
	["Fel Energy"] = true,
	["Hemorrhage"] = true,
	["Harvest Soul"] = true,
	["Whirlwind"] = true,
	["Mark of Korth'azz"] = true,
	["Shadow Mark"] = true,
	["Chilling Touch"] = true,
	["Stomp"] = true,
	["Flesh Rot"] = true,
	["Infected Wound"] = true,
	["Terrifying Roar"] = true,
	["Slime"] = true,
	["Shockwave"] = true,
	["Itch"] = true,
	["Enveloping Winds"] = true,
	["Test Sunder Armor"] = true,
	["Dismember"] = true,
	["Harsh Winds"] = true,
	["Daze"] = true,
	["Diminish Soul"] = true,
	["Attack Order"] = true,
	["Lightning Cloud"] = true,
	["Devouring Plague"] = true,
}

function DPSMate.Modules.Auras:UpdateDetails(obj, key)
	DPSMate_Details_CompareAuras:Hide()
	
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DetailsUserComp = nil
	DPSMate_Details_Auras_Title:SetText(DPSMate.L["aurasof"]..obj.user)
	t2, t1 = DPSMate.Modules.Auras:SortTable()
	t1TL = DPSMate:TableLength(t1)-6
	t2TL = DPSMate:TableLength(t2)-6
	Buffpos, Debuffpos = 0, 0
	
	if not g then
		g = DPSMate.Options.graph:CreateStackedGraph("AurasStackedGraph",DPSMate_Details_Auras_DiagramLine,"CENTER","CENTER",0,0,660,170)
		g:SetGridColor({0.5,0.5,0.5,0.5})
		g:SetAxisDrawing(true,true)
		g:SetAxisColor({1.0,1.0,1.0,1.0})
		g:SetAutoScale(true)
		g:SetYLabels(true, false)
		g:SetXLabels(true)
		g:Show()
	end
	
	self:CleanTables("")
	self:UpdateBuffs(0, "")
	self:UpdateDebuffs(0, "")
	self:UpdateStackedGraph(g)
	DPSMate_Details_Auras:Show()
	DPSMate_Details_Auras:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.Auras:UpdateCompare(obj, key, comp)
	self:UpdateDetails(obj, key)
	
	DetailsUserComp = comp
	DPSMate_Details_CompareAuras_Title:SetText(DPSMate.L["aurasof"]..comp)
	t4, t3 = DPSMate.Modules.Auras:SortTable(comp)
	t3TL = DPSMate:TableLength(t3)-6
	t4TL = DPSMate:TableLength(t4)-6
	BuffposComp, DebuffposComp = 0, 0
	
	if not g2 then
		g2 = DPSMate.Options.graph:CreateStackedGraph("AurasStackedGraphComp",DPSMate_Details_CompareAuras_DiagramLine,"CENTER","CENTER",0,0,660,170)
		g2:SetGridColor({0.5,0.5,0.5,0.5})
		g2:SetAxisDrawing(true,true)
		g2:SetAxisColor({1.0,1.0,1.0,1.0})
		g2:SetAutoScale(true)
		g2:SetYLabels(true, false)
		g2:SetXLabels(true)
		g2:Show()
	end
	
	self:CleanTables("Compare")
	self:UpdateBuffs(0, "Compare")
	self:UpdateDebuffs(0, "Compare")
	self:UpdateStackedGraph(g2, comp)
	DPSMate_Details_CompareAuras:Show()
end

function DPSMate.Modules.Auras:CreateGraphTable(obj)
	local lines = {}
	for i=1, 6 do
		-- Horizontal
		DPSMate.Options.graph:DrawLine(obj, 5, 223-i*30, 655, 223-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	end
	-- Vertical
	DPSMate.Options.graph:DrawLine(obj, 235, 215, 235, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 300, 215, 300, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
end

function DPSMate.Modules.Auras:UpdateStackedGraph(gg, cname)
	local Data1 = {}
	local maxX, maxY = 0, 0
	local label = {}
	
	for cat, val in db[DPSMateUser[cname or DetailsUser][1]] do -- ability
		local temp = {}
		for ca, va in val[1] do
			tinsert(temp, {va, 1})
		end
		tinsert(Data1, temp)
		tinsert(label, DPSMate:GetAbilityById(cat))
	end
	
	gg:ResetData()
	gg:SetGridSpacing(800/7,10/7)
	
	gg:AddDataSeries(Data1,{1.0,0.0,0.0,0.8}, {}, label)
end

function DPSMate.Modules.Auras:SortTable(cname)
	local t, u = {}, {}
	local a,_,b,c = DPSMate.Modules.AurasUptimers:EvalTable(DPSMateUser[cname or DetailsUser], curKey)
	local p1,p2 = 1, 1
	for cat, val in a do
		local name = DPSMate:GetAbilityById(val)
		local obj = {name, b[cat], c[cat]}
		if self.Debuffs[name] then
			tinsert(t, p1, obj)
			p1 = p1 + 1
		else
			tinsert(u, p2, obj)
			p2 = p2 + 1
		end
	end	
	return t, u
end

function DPSMate.Modules.Auras:CleanTables(comp)
	for _, val in {"Buffs", "Debuffs"} do
		local path = "DPSMate_Details_"..comp.."Auras_"..val.."_Row"
		for i=1, 6 do
			_G(path..i.."_Icon"):SetTexture()
			_G(path..i.."_Name"):SetText()
			_G(path..i.."_Count"):SetText()
			_G(path..i.."_CBT"):SetText()
			_G(path..i.."_CBTPerc"):SetText()
			_G(path..i.."_StatusBar"):SetValue(0)
		end
	end
end

function DPSMate.Modules.Auras:UpdateBuffs(arg1, comp)
	comp = comp or DPSMate_Details_Auras.LastScroll
	local path = "DPSMate_Details_"..comp.."Auras_Buffs_Row"
	Buffpos=Buffpos-(arg1 or 0)
	local arr = t1
	if comp~="" and comp then
		if Buffpos<0 then Buffpos = 0 end
		if Buffpos>t3TL then Buffpos = t3TL end
		if t3TL<0 then Buffpos = 0 end
		arr = t3
		for i=1, 6 do
			local pos = BuffposComp + i
			if not arr[pos] then break end
			_G(path..i).id = arr[pos][1]
			_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(arr[pos][1]))
			_G(path..i.."_Name"):SetText(arr[pos][1])
			_G(path..i.."_Count"):SetText(arr[pos][3])
			_G(path..i.."_CBT"):SetText(strformat("%.2f", arr[pos][2]*cbt/100).."s")
			_G(path..i.."_CBTPerc"):SetText(strformat("%.2f", arr[pos][2]).."%")
			_G(path..i.."_StatusBar"):SetValue(arr[pos][2])
		end
	else
		if Buffpos<0 then Buffpos = 0 end
		if Buffpos>t1TL then Buffpos = t1TL end
		if t1TL<0 then Buffpos = 0 end
		for i=1, 6 do
			local pos = Buffpos + i
			if not arr[pos] then break end
			_G(path..i).id = arr[pos][1]
			_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(arr[pos][1]))
			_G(path..i.."_Name"):SetText(arr[pos][1])
			_G(path..i.."_Count"):SetText(arr[pos][3])
			_G(path..i.."_CBT"):SetText(strformat("%.2f", arr[pos][2]*cbt/100).."s")
			_G(path..i.."_CBTPerc"):SetText(strformat("%.2f", arr[pos][2]).."%")
			_G(path..i.."_StatusBar"):SetValue(arr[pos][2])
		end
	end
end

function DPSMate.Modules.Auras:UpdateDebuffs(arg1, comp)
	comp = comp or DPSMate_Details_Auras.LastScroll
	local path = "DPSMate_Details_"..comp.."Auras_Debuffs_Row"
	Debuffpos=Debuffpos-(arg1 or 0)
	local arr = t2
	if comp~="" and comp then
		if Debuffpos<0 then Debuffpos = 0 end
		if Debuffpos>t4TL then Debuffpos = t4TL end
		if t4TL<0 then Debuffpos = 0 end
		arr = t4
		for i=1, 6 do
			local pos = DebuffposComp + i
			if not arr[pos] then break end
			_G(path..i).id = arr[pos][1]
			_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(arr[pos][1]))
			_G(path..i.."_Name"):SetText(arr[pos][1])
			_G(path..i.."_Count"):SetText(arr[pos][3])
			_G(path..i.."_CBT"):SetText(strformat("%.2f", arr[pos][2]*cbt/100).."s")
			_G(path..i.."_CBTPerc"):SetText(strformat("%.2f", arr[pos][2]).."%")
			_G(path..i.."_StatusBar"):SetValue(arr[pos][2])
		end
	else
		if Debuffpos<0 then Debuffpos = 0 end
		if Debuffpos>t2TL then Debuffpos = t2TL end
		if t2TL<0 then Debuffpos = 0 end
		for i=1, 6 do
			local pos = Debuffpos + i
			if not arr[pos] then break end
			_G(path..i).id = arr[pos][1]
			_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(arr[pos][1]))
			_G(path..i.."_Name"):SetText(arr[pos][1])
			_G(path..i.."_Count"):SetText(arr[pos][3])
			_G(path..i.."_CBT"):SetText(strformat("%.2f", arr[pos][2]*cbt/100).."s")
			_G(path..i.."_CBTPerc"):SetText(strformat("%.2f", arr[pos][2]).."%")
			_G(path..i.."_StatusBar"):SetValue(arr[pos][2])
		end
	end
end

function DPSMate.Modules.Auras:ShowTooltip(obj)
	local user = DetailsUser
	if obj and string.find(obj:GetName(), "Compare") then
		user = DetailsUserComp
	end
	if obj.id and db[DPSMateUser[user][1]][DPSMateAbility[obj.id][1]] then
		GameTooltip:SetOwner(obj)
		GameTooltip:AddLine(obj.id)
		for cat, val in db[DPSMateUser[user][1]][DPSMateAbility[obj.id][1]][3] do
			GameTooltip:AddDoubleLine(DPSMate:GetUserById(cat),val,1,1,1,1,1,1)
		end
		GameTooltip:Show()
	end
end
