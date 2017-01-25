-- Global Variables
DPSMate.Modules.DetailsFails = {}

-- Local variables
local DetailsUser, DetailsUserComp = "", ""
local curKey = 1
local db, cbt = {}, 0
local Buffpos, BuffposComp = 0, 0
local _G = getglobal
local tinsert = table.insert

function DPSMate.Modules.DetailsFails:UpdateDetails(obj, key)
	DPSMate_Details_CompareFails:Hide()
	
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DetailsUserComp = nil
	DPSMate_Details_Fails_Title:SetText(DPSMate.L["failsof"]..obj.user)
	Buffpos = 0
	self:CleanTables("")
	self:UpdateBuffs(0, "")
	DPSMate_Details_Fails:Show()
	DPSMate_Details_Fails:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsFails:UpdateCompare(obj, key, comp)
	self:UpdateDetails(obj, key)

	DetailsUserComp = comp
	DPSMate_Details_CompareFails_Title:SetText(DPSMate.L["failsof"]..comp)
	BuffposComp = 0
	self:CleanTables("Compare")
	self:UpdateBuffs(0, "Compare")
	DPSMate_Details_CompareFails:Show()
end

function DPSMate.Modules.DetailsFails:CreateGraphTable(obj)
	local lines = {}
	for i=1, 6 do
		-- Horizontal
		DPSMate.Options.graph:DrawLine(obj, 5, 223-i*30, 670, 223-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	end
	-- Vertical
	DPSMate.Options.graph:DrawLine(obj, 235, 215, 235, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 480, 215, 480, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 570, 215, 570, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
end

function DPSMate.Modules.DetailsFails:CleanTables(comp)
	local path = "DPSMate_Details_"..comp.."Fails_Buffs_Row"
	for i=1, 6 do
		_G(path..i.."_Icon"):SetTexture()
		_G(path..i.."_Ability"):SetText()
		_G(path..i.."_Victim"):SetText()
		_G(path..i.."_Type"):SetText()
		_G(path..i.."_Amount"):SetText()
	end
end

function DPSMate.Modules.DetailsFails:Replace(text)
	local a,b = strfind(text, "%(")
	if a and b then
		return strsub(text, 1, a-1)
	end
	return text
end

function DPSMate.Modules.DetailsFails:Type(id)
	if id == 1 then
		return DPSMate.L["friendlyfire"]
	elseif id == 2 then
		return DPSMate.L["damagetaken"]
	else
		return DPSMate.L["debufftaken"]
	end
end

function DPSMate.Modules.DetailsFails:UpdateBuffs(arg1, comp, cname)
	if comp~="" and comp then
		cname = DetailsUserComp
	end
	local a = db[DPSMateUser[cname or DetailsUser][1]]
	local t1TL = DPSMate:TableLength(a)-6
	local path = "DPSMate_Details_"..comp.."Fails_Buffs_Row"
	if comp~="" and comp then
		BuffposComp=BuffposComp-(arg1 or 0)
		if BuffposComp<0 then BuffposComp = 0 end
		if BuffposComp>t1TL then BuffposComp = t1TL end
		if t1TL<0 then BuffposComp = 0 end
		for i=1, 6 do
			local pos = BuffposComp + i
			if not a[pos] then break end
			local ab = DPSMate:GetAbilityById(a[pos][3])
			_G(path..i).id = a[pos][3]
			_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(self:Replace(ab)))
			_G(path..i.."_Ability"):SetText(ab)
			_G(path..i.."_Victim"):SetText(DPSMate:GetUserById(a[pos][2]))
			_G(path..i.."_Type"):SetText(self:Type(a[pos][1]))
			_G(path..i.."_Amount"):SetText(a[pos][4])
		end
	else
		Buffpos=Buffpos-(arg1 or 0)
		if Buffpos<0 then Buffpos = 0 end
		if Buffpos>t1TL then Buffpos = t1TL end
		if t1TL<0 then Buffpos = 0 end
		for i=1, 6 do
			local pos = Buffpos + i
			if not a[pos] then break end
			local ab = DPSMate:GetAbilityById(a[pos][3])
			_G(path..i).id = a[pos][3]
			_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(self:Replace(ab)))
			_G(path..i.."_Ability"):SetText(ab)
			_G(path..i.."_Victim"):SetText(DPSMate:GetUserById(a[pos][2]))
			_G(path..i.."_Type"):SetText(self:Type(a[pos][1]))
			_G(path..i.."_Amount"):SetText(a[pos][4])
		end
	end
end
