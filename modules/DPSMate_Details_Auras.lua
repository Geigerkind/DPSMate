-- Global Variables
DPSMate.Modules.Auras = {}

-- Local variables
local DetailsUser = ""
local curKey = 1
local db, cbt = {}, 0
local Buffpos, Debuffpos = 0, 0
local t1, t2
local t1TL, t2TL = 0, 0

local Debuffs = {
	"Rend",
	"Net",
	"Poison",
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
	DPSMate.Modules.Auras:CleanTables()
	DPSMate.Modules.Auras:UpdateBuffs()
	DPSMate.Modules.Auras:UpdateDebuffs()
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
	local a,_,b	= DPSMate.Modules.AurasUptimers:EvalTable(DPSMateUser[DetailsUser], curKey)
	local _,_,c = DPSMate.Modules.AurasGained:EvalTable(DPSMateUser[DetailsUser], curKey)
	local p1,p2 = 1, 1
	for cat, val in a do
		local name = DPSMate:GetAbilityById(val)
		local obj = {name, b[cat], c[cat]}
		if DPSMate:TContains(Debuffs, name) then
			table.insert(t, p1, obj)
			p1 = p1 + 1
		else
			table.insert(u, p2, obj)
			p2 = p2 + 1
		end
	end	
	return t, u
end

function DPSMate.Modules.Auras:CleanTables()
	for _, val in {"Buffs", "Debuffs"} do
		local path = "DPSMate_Details_Auras_"..val.."_Row"
		for i=1, 6 do
			getglobal(path..i.."_Icon"):SetTexture()
			getglobal(path..i.."_Name"):SetText()
			getglobal(path..i.."_Count"):SetText()
			getglobal(path..i.."_CBT"):SetText()
			getglobal(path..i.."_CBTPerc"):SetText()
			getglobal(path..i.."_StatusBar"):SetValue(0)
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
		getglobal(path..i).id = t1[pos][1]
		getglobal(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(t1[pos][1]))
		getglobal(path..i.."_Name"):SetText(t1[pos][1])
		getglobal(path..i.."_Count"):SetText(t1[pos][3])
		getglobal(path..i.."_CBT"):SetText(string.format("%.2f", t1[pos][2]*DPSMateCombatTime["total"]/100).."s")
		getglobal(path..i.."_CBTPerc"):SetText(t1[pos][2].."%")
		getglobal(path..i.."_StatusBar"):SetValue(t1[pos][2])
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
		getglobal(path..i).id = t2[pos][1]
		getglobal(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(t2[pos][1]))
		getglobal(path..i.."_Name"):SetText(t2[pos][1])
		getglobal(path..i.."_Count"):SetText(t2[pos][3])
		getglobal(path..i.."_CBT"):SetText(string.format("%.2f", t2[pos][2]*DPSMateCombatTime["total"]/100).."s")
		getglobal(path..i.."_CBTPerc"):SetText(t2[pos][2].."%")
		getglobal(path..i.."_StatusBar"):SetValue(t2[pos][2])
	end
end

function DPSMate.Modules.Auras:ShowTooltip(obj)
	if obj.id then
		GameTooltip:SetOwner(obj)
		GameTooltip:AddLine(obj.id)
		for cat, val in db[DPSMateUser[DetailsUser][1]][DPSMateAbility[obj.id][1]][3] do
			GameTooltip:AddDoubleLine(DPSMate:GetUserById(cat),val,1,1,1,1,1,1)
		end
		GameTooltip:Show()
	end
end
