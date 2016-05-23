-- Global Variables
DPSMate.Modules.Auras = {}

-- Local variables
local DetailsUser = ""
local curKey = 1
local db, cbt = {}, 0
local Buffpos, Debuffpos = 0, 0
local t1, t2
local t1TL, t2TL = 0, 0
local _G = getglobal
local tinsert = table.insert
local Debuffs = {
	"Rend",
	"Net",
	"Poison",
	"Blizzard",
	"Winter's Chill",
	"Chilled",
	"Frostbolt",
	"Frostbite",
	"Cone of Cold",
	"Frost Nova",
	"Dazed",
	"Volatile Infection",
	"Disarm",
	"Psychic Scream",
	"Corrosive Acid Spit",
	"Poison Mind",
	"Knockdown",
	"Smite",
	"Mind Flay",
	"Withering Heat",
	"Ancient Dread",
	"Ignite Mana",
	"Ground Stomp",
	"Blast Wave",
	"Lucifron's Curse",
	"Hand of Ragnaros",
	"Demoralizing Shout",
	"Incite Flames",
	"Magma Shackles",
	"Sunder Armor",
	"Melt Armor",
	"Rain of Fire",
	"Serrated Bite",
	"Ancient Hysteria",
	"Shazzrah's Curse",
	"Fist of Ragnaros",
	"Magma Spit",
	"Pyroclast Barrage",
	"Gehennas' Curse",
	"Impending Doom",
	"Conflagration",
	"Living Bomb",
	"Mangle",
	"Panic",
	"Immolate",
	"Magma Splash",
	"Weakened Soul",
	"Elemental Fire",
	"Shadow Word: Pain",
	"Soul Burn",
	"Consecration",
	"Judgement of the Crusader",
	"Curse of Agony",
	"Judgement of Wisdom",
	"Hunter's Mark",
	"Siphon Life",
	"Challenging Shout",
	"Vampiric Embrace",
	"Mocking Blow",
	"Scorpid Sting",
	"Deep Wound",
	"Drain Life",
	"Expose Weakness",
	"Serpent Sting",
	"Faerie Fire (Feral)",
	"Rupture",
	"Rake",
	"Taunt",
	"Thunderfury",
	"Rip",
	"Corruption",
	"Moonfire",
	"Judgement of Light",
	"Shadow Vulnerability",
	"Forbearance",
	"Flamestrike",
	"Intercept Stun",
	"Volley",
	"Pyroclasm",
	"Curse of Recklessness",
	"Hellfire",
	"Essence of the Red",
	"Growing Flames",
	"Brood Affliction: Blue",
	"Brood Affliction: Green",
	"Brood Affliction: Red",
	"Brood Affliction: Black",
	"Brood Affliction: Bronze",
	"Brood Power: Green",
	"Brood Power: Red",
	"Brood Power: Blue",
	"War Stomp",
	"Thunderclap",
	"Veil of Shadow",
	"Flame Buffet",
	"Flame Shock",
	"Suppression Aura",
	"Burning Adrenaline",
	"Flame Breath",
	"Bottle of Poison",
	"Shadow of Ebonroc",
	"Tail Lash",
	"Dropped Weapon",
	"Bellowing Roar",
	"Greater Polymorph",
	"Ignite Flesh",
	"Mortal Strike",
	"Corrupted Healing",
	"Inferno Effect",
	"Time Lapse",
	"Frost Trap Aura",
	"Thorium Grenade",
	"Kreeg's Stout Beatdown",
	"Mark of Detonation",
	"Shadow Command",
	"Curse of Tongues",
	"Fear",
	"Siphon Blessing",
}

function DPSMate.Modules.Auras:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DPSMate_Details_Auras_Title:SetText("Auras of "..obj.user)
	t2, t1 = DPSMate.Modules.Auras:SortTable()
	t1TL = DPSMate:TableLength(t1)-6
	t2TL = DPSMate:TableLength(t2)-6
	Buffpos, Debuffpos = 0, 0
	self:CleanTables()
	self:UpdateBuffs()
	self:UpdateDebuffs()
	DPSMate_Details_Auras:Show()
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

function DPSMate.Modules.Auras:SortTable()
	local t, u = {}, {}
	local a,_,b,c = DPSMate.Modules.AurasUptimers:EvalTable(DPSMateUser[DetailsUser], curKey)
	local p1,p2 = 1, 1
	for cat, val in a do
		local name = DPSMate:GetAbilityById(val)
		local obj = {name, b[cat], c[cat]}
		if DPSMate:TContains(Debuffs, name) then
			tinsert(t, p1, obj)
			p1 = p1 + 1
		else
			tinsert(u, p2, obj)
			p2 = p2 + 1
		end
	end	
	return t, u
end

function DPSMate.Modules.Auras:CleanTables()
	for _, val in {"Buffs", "Debuffs"} do
		local path = "DPSMate_Details_Auras_"..val.."_Row"
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

function DPSMate.Modules.Auras:UpdateBuffs(arg1)
	local path = "DPSMate_Details_Auras_Buffs_Row"
	Buffpos=Buffpos-(arg1 or 0)
	if Buffpos<0 then Buffpos = 0 end
	if Buffpos>t1TL then Buffpos = t1TL end
	if t1TL<0 then Buffpos = 0 end
	for i=1, 6 do
		local pos = Buffpos + i
		if not t1[pos] then break end
		_G(path..i).id = t1[pos][1]
		_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(t1[pos][1]))
		_G(path..i.."_Name"):SetText(t1[pos][1])
		_G(path..i.."_Count"):SetText(t1[pos][3])
		_G(path..i.."_CBT"):SetText(string.format("%.2f", t1[pos][2]*DPSMateCombatTime["total"]/100).."s")
		_G(path..i.."_CBTPerc"):SetText(t1[pos][2].."%")
		_G(path..i.."_StatusBar"):SetValue(t1[pos][2])
	end
end

function DPSMate.Modules.Auras:UpdateDebuffs(arg1)
	local path = "DPSMate_Details_Auras_Debuffs_Row"
	Debuffpos=Debuffpos-(arg1 or 0)
	if Debuffpos<0 then Debuffpos = 0 end
	if Debuffpos>t2TL then Debuffpos = t2TL end
	if t2TL<0 then Debuffpos = 0 end
	for i=1, 6 do
		local pos = Debuffpos + i
		if not t2[pos] then break end
		_G(path..i).id = t2[pos][1]
		_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(t2[pos][1]))
		_G(path..i.."_Name"):SetText(t2[pos][1])
		_G(path..i.."_Count"):SetText(t2[pos][3])
		_G(path..i.."_CBT"):SetText(string.format("%.2f", t2[pos][2]*DPSMateCombatTime["total"]/100).."s")
		_G(path..i.."_CBTPerc"):SetText(t2[pos][2].."%")
		_G(path..i.."_StatusBar"):SetValue(t2[pos][2])
	end
end

function DPSMate.Modules.Auras:ShowTooltip(obj)
	if obj.id and db[DPSMateUser[DetailsUser][1]][DPSMateAbility[obj.id][1]] then
		GameTooltip:SetOwner(obj)
		GameTooltip:AddLine(obj.id)
		for cat, val in db[DPSMateUser[DetailsUser][1]][DPSMateAbility[obj.id][1]][3] do
			GameTooltip:AddDoubleLine(DPSMate:GetUserById(cat),val,1,1,1,1,1,1)
		end
		GameTooltip:Show()
	end
end
