-- Global Variables
DPSMate.Modules.DetailsCCBreaker = {}

-- Local variables
local DetailsUser, DetailsUserComp = "", ""
local curKey = 1
local db, cbt = {}, 0
local Buffpos, BuffposComp = 0, 0
local _G = getglobal
local tinsert = table.insert
local strformat = string.format

function DPSMate.Modules.DetailsCCBreaker:UpdateDetails(obj, key)
	DPSMate_Details_CompareCCBreaker:Hide()
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsUser = obj.user
	DetailsUserComp = nil
	DPSMate_Details_CCBreaker_Title:SetText(DPSMate.L["ccbreakerof"]..obj.user)
	Buffpos = 0
	self:CleanTables("")
	self:UpdateBuffs(0, "")
	DPSMate_Details_CCBreaker:Show()
	
	DPSMate_Details_CCBreaker:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsCCBreaker:UpdateCompare(obj, key, comp)
	self:UpdateDetails(obj, key)
	
	DetailsUserComp = comp
	DPSMate_Details_CompareCCBreaker_Title:SetText(DPSMate.L["ccbreakerof"]..comp)
	BuffposComp = 0
	self:CleanTables("Compare")
	self:UpdateBuffs(0, "Compare")
	DPSMate_Details_CompareCCBreaker:Show()
end

function DPSMate.Modules.DetailsCCBreaker:CreateGraphTable(obj)
	local lines = {}
	for i=1, 6 do
		-- Horizontal
		DPSMate.Options.graph:DrawLine(obj, 5, 223-i*30, 655, 223-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	end
	-- Vertical
	DPSMate.Options.graph:DrawLine(obj, 70, 215, 70, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 150, 215, 150, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	DPSMate.Options.graph:DrawLine(obj, 400, 215, 400, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
end

function DPSMate.Modules.DetailsCCBreaker:CleanTables(comp)
	local path = "DPSMate_Details_"..comp.."CCBreaker_Buffs_Row"
	for i=1, 6 do
		_G(path..i.."_Icon"):SetTexture()
		_G(path..i.."_Ability"):SetText()
		_G(path..i.."_Target"):SetText()
		_G(path..i.."_Time"):SetText()
		_G(path..i.."_CBT"):SetText()
	end
end

function DPSMate.Modules.DetailsCCBreaker:Replace(text)
	local a,b = strfind(text, "%(")
	if a and b then
		return strsub(text, 1, a-1)
	end
	return text
end

function DPSMate.Modules.DetailsCCBreaker:UpdateBuffs(arg1, comp, cname)
	if comp~="" and comp then
		cname = DetailsUserComp
	end
	local a = db[DPSMateUser[cname or DetailsUser][1]]
	local t1TL = DPSMate:TableLength(a)-6
	local path = "DPSMate_Details_"..comp.."CCBreaker_Buffs_Row"
	if comp~="" and comp then
		BuffposComp=BuffposComp-(arg1 or 0)
		if BuffposComp<0 then BuffposComp = 0 end
		if BuffposComp>t1TL then BuffposComp = t1TL end
		if t1TL<0 then BuffposComp = 0 end
		for i=1, 6 do
			local pos = BuffposComp + i
			if not a[pos] then break end
			local ab = DPSMate:GetAbilityById(a[pos][1])
			_G(path..i).id = a[pos][1]
			_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(self:Replace(ab)))
			_G(path..i.."_Ability"):SetText(ab)
			_G(path..i.."_Target"):SetText(DPSMate:GetUserById(a[pos][2]))
			_G(path..i.."_Time"):SetText(a[pos][4])
			_G(path..i.."_CBT"):SetText(strformat("%.2f", a[pos][3]).."s")
		end
	else
		Buffpos=Buffpos-(arg1 or 0)
		if Buffpos<0 then Buffpos = 0 end
		if Buffpos>t1TL then Buffpos = t1TL end
		if t1TL<0 then Buffpos = 0 end
		for i=1, 6 do
			local pos = Buffpos + i
			if not a[pos] then break end
			local ab = DPSMate:GetAbilityById(a[pos][1])
			_G(path..i).id = a[pos][1]
			_G(path..i.."_Icon"):SetTexture(DPSMate.BabbleSpell:GetSpellIcon(self:Replace(ab)))
			_G(path..i.."_Ability"):SetText(ab)
			_G(path..i.."_Target"):SetText(DPSMate:GetUserById(a[pos][2]))
			_G(path..i.."_Time"):SetText(a[pos][4])
			_G(path..i.."_CBT"):SetText(strformat("%.2f", a[pos][3]).."s")
		end
	end
end
