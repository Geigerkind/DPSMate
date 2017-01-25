-- Global Variables
DPSMate.Modules.DetailsCasts = {}

-- Local variables
local DetailsUser, DetailsUserComp = "", ""
local curKey = 1
local db, cbt = {}, 0
local Buffpos, BuffposComp = 0, 0
local _G = getglobal
local tinsert = table.insert

function DPSMate.Modules.DetailsCasts:UpdateDetails(obj, key)
	DPSMate_Details_CompareCasts:Hide()
	
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DetailsUserComp = nil
	DPSMate_Details_Casts_Title:SetText(DPSMate.L["castsof"]..obj.user)
	Buffpos = 0
	self:CleanTables("")
	self:UpdateBuffs(0, "")
	DPSMate_Details_Casts:Show()
	
	DPSMate_Details_Casts:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsCasts:UpdateCompare(obj, key, comp)
	self:UpdateDetails(obj, key)

	DetailsUserComp = comp
	DPSMate_Details_CompareCasts_Title:SetText(DPSMate.L["castsof"]..comp)
	BuffposComp = 0
	self:CleanTables("Compare")
	self:UpdateBuffs(0, "Compare")
	DPSMate_Details_CompareCasts:Show()
end

function DPSMate.Modules.DetailsCasts:CreateGraphTable(obj)
	local lines = {}
	for i=1, 6 do
		-- Horizontal
		DPSMate.Options.graph:DrawLine(obj, 5, 223-i*30, 345, 223-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	end
	-- Vertical
	DPSMate.Options.graph:DrawLine(obj, 235, 215, 235, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
end

function DPSMate.Modules.DetailsCasts:CleanTables(comp)
	local path = "DPSMate_Details_"..comp.."Casts_Buffs_Row"
	for i=1, 6 do
		_G(path..i.."_Icon"):SetTexture()
		_G(path..i.."_Name"):SetText()
		_G(path..i.."_Count"):SetText()
	end
end

function DPSMate.Modules.DetailsCasts:Replace(text)
	local a,b = strfind(text, "%(")
	if a and b then
		return strsub(text, 1, a-1)
	end
	return text
end

function DPSMate.Modules.DetailsCasts:UpdateBuffs(arg1, comp, cname)
	if comp~="" and comp then
		cname = DetailsUserComp
	end
	local a,b,c = DPSMate.Modules.Casts:EvalTable(DPSMateUser[cname or DetailsUser], curKey)
	local t1TL = DPSMate:TableLength(a)-6
	local path = "DPSMate_Details_"..comp.."Casts_Buffs_Row"
	if comp~="" and comp then
		BuffposComp=BuffposComp-(arg1 or 0)
		if BuffposComp<0 then BuffposComp = 0 end
		if BuffposComp>t1TL then BuffposComp = t1TL end
		if t1TL<0 then BuffposComp = 0 end
		for i=1, 6 do
			local pos = BuffposComp + i
			if not a[pos] then break end
			local ab = DPSMate:GetAbilityById(c[pos])
			_G(path..i).id = c[pos]
			_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(self:Replace(ab)))
			_G(path..i.."_Name"):SetText(ab)
			_G(path..i.."_Count"):SetText(a[pos])
		end
	else
		Buffpos=Buffpos-(arg1 or 0)
		if Buffpos<0 then Buffpos = 0 end
		if Buffpos>t1TL then Buffpos = t1TL end
		if t1TL<0 then Buffpos = 0 end
		for i=1, 6 do
			local pos = Buffpos + i
			if not a[pos] then break end
			local ab = DPSMate:GetAbilityById(c[pos])
			_G(path..i).id = c[pos]
			_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(self:Replace(ab)))
			_G(path..i.."_Name"):SetText(ab)
			_G(path..i.."_Count"):SetText(a[pos])
		end
	end
end
