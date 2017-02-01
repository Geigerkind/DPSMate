-- Global Variables
DPSMate.Modules.DetailsAurasTotal = {}

-- Local variables
local g
local curKey = 1
local db, cbt = {}, 0
local Buffpos, Debuffpos = 0, 0
local t1, t2, t3, t4
local t1TL, t2TL = 0, 0
local _G = getglobal
local tinsert = table.insert
local strformat = string.format
local tnbr = tonumber

-- Remember to update the processing list before starting to put on the localization
DPSMate.Modules.DetailsAurasTotal.Debuffs = {
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

function DPSMate.Modules.DetailsAurasTotal:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DPSMate_Details_AurasTotal_Title:SetText(DPSMate.L["aurassum"])
	t2, t1 = self:SortTable()
	t1TL = DPSMate:TableLength(t1)-6
	t2TL = DPSMate:TableLength(t2)-6
	Buffpos, Debuffpos = 0, 0
	
	if not g then
		g = DPSMate.Options.graph:CreateStackedGraph("AurasTotalStackedGraph",DPSMate_Details_AurasTotal_DiagramLine,"CENTER","CENTER",0,0,660,170)
		g:SetGridColor({0.5,0.5,0.5,0.5})
		g:SetAxisDrawing(true,true)
		g:SetAxisColor({1.0,1.0,1.0,1.0})
		g:SetAutoScale(true)
		g:SetYLabels(true, false)
		g:SetXLabels(true)
		g:Show()
	end
	
	self:CleanTables()
	self:UpdateBuffs(0)
	self:UpdateDebuffs(0)
	self:UpdateStackedGraph(g)
	DPSMate_Details_AurasTotal:Show()
	DPSMate_Details_AurasTotal:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsAurasTotal:CreateGraphTable(obj)
	local lines = {}
	for i=1, 6 do
		-- Horizontal
		DPSMate.Options.graph:DrawLine(obj, 5, 223-i*30, 655, 223-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	end
	-- Vertical
	DPSMate.Options.graph:DrawLine(obj, 235, 215, 235, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 300, 215, 300, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
end

function DPSMate.Modules.DetailsAurasTotal:UpdateStackedGraph(gg, cname)
	local Data1 = {}
	local maxX, maxY = 0, 0
	local label = {}
	local temp = {}
	
	for cat, val in db do -- ability
		local user = DPSMate:GetUserById(cat)
		if DPSMate:ApplyFilter(curKey, user) then
			for ca,va in val do 
				local abname = DPSMate:GetAbilityById(ca)
				if not temp[abname] then temp[abname]={} end
				for c, v in va[1] do
					local time = floor(v) -- Performance
					if temp[abname][time] then 
						temp[abname][time]=temp[abname][time]+1
					else
						temp[abname][time]=0
					end
				end
			end
		end
	end
	for cat, val in temp do
		local arr = {}
		for ca, va in val do
			tinsert(arr, {ca,va})
		end
		tinsert(Data1, arr)
		tinsert(label, cat)
	end
	temp = nil
	
	gg:ResetData()
	gg:SetGridSpacing(800/7,10/7)
	
	gg:AddDataSeries(Data1,{1.0,0.0,0.0,0.8}, {}, label)
end

-- Making an average uptime
function DPSMate.Modules.DetailsAurasTotal:SortTable()
	local t, u = {}, {}
	for cat, _ in db do
		local user = DPSMate:GetUserById(cat)
		if DPSMate:ApplyFilter(curKey, user) then
			local a,_,b,c = DPSMate.Modules.AurasUptimers:EvalTable(DPSMateUser[user], curKey)
			for ca,va in a do
				local name = DPSMate:GetAbilityById(va)
				if self.Debuffs[name] then
					if t[name] then
						t[name][2] = DPSMate.DB:WeightedAverage(t[name][2], b[ca], t[name][3], c[ca])
						t[name][3] = t[name][3] + c[ca]
					else
						t[name] = {name, b[ca], c[ca]}
					end
				else
					if u[name] then
						u[name][2] = DPSMate.DB:WeightedAverage(u[name][2], b[ca], u[name][3], c[ca])
						u[name][3] = u[name][3] + c[ca]
					else
						u[name] = {name, b[ca], c[ca]}
					end
				end
			end
		end
	end
	-- Sorting it by amount
	local z,y = {}, {}
	for cat, val in t do
		local i=1
		while true do
			if not z[i] then
				tinsert(z, i, val)
				break
			elseif z[i][3]<val[3] then
				tinsert(z, i, val)
				break
			end
			i=i+1
		end
	end
	for cat, val in u do
		local i=1
		while true do
			if not y[i] then
				tinsert(y, i, val)
				break
			elseif y[i][3]<val[3] then
				tinsert(y, i, val)
				break
			end
			i=i+1
		end
	end
	t, u = nil, nil
	return z, y
end

function DPSMate.Modules.DetailsAurasTotal:CleanTables()
	for _, val in {"Buffs", "Debuffs"} do
		local path = "DPSMate_Details_AurasTotal_"..val.."_Row"
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

function DPSMate.Modules.DetailsAurasTotal:UpdateBuffs(arg1)
	local path = "DPSMate_Details_AurasTotal_Buffs_Row"
	Buffpos=Buffpos-(arg1 or 0)
	local arr = t1
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

function DPSMate.Modules.DetailsAurasTotal:UpdateDebuffs(arg1)
	local path = "DPSMate_Details_AurasTotal_Debuffs_Row"
	Debuffpos=Debuffpos-(arg1 or 0)
	local arr = t2
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
