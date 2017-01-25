-- Global Variables
DPSMate.Modules.DetailsInterruptsTotal = {}

-- Local variables
local curKey = 1
local db, cbt = {}, 0
local _G = getglobal
local tinsert = table.insert
local strformat = string.format
local tnbr = tonumber
local TL = 0
local Offset = 0
local DetailsArr = {}
local hexClassColor = {
	warrior = "C79C6E",
	rogue = "FFF569",
	priest = "FFFFFF",
	druid = "FF7D0A",
	warlock = "9482C9",
	mage = "69CCF0",
	hunter = "ABD473",
	paladin = "F58CBA",
	shaman = "0070DE",
}

function DPSMate.Modules.DetailsInterruptsTotal:UpdateDetails(obj, key)
	curKey = key
	db, cbt = DPSMate:GetMode(key)
	DetailsArr = self:EvalTable()
	Offset = 0
	TL = DPSMate:TableLength(DetailsArr)
	self:ScrollFrameUpdate(0)
	DPSMate_Details_Interrupts_Total_Title:SetText(DPSMate.L["intersum"])
	DPSMate_Details_Interrupts_Total:Show()
	DPSMate_Details_Interrupts_Total:SetScale((DPSMateSettings["targetscale"] or 0.58)/UIParent:GetScale())
end

function DPSMate.Modules.DetailsInterruptsTotal:UpdateRow(row, a, b, c, d, e)
	_G("DPSMate_Details_Interrupts_Total_LogDetails_Row"..row).user = c
	_G("DPSMate_Details_Interrupts_Total_LogDetails_Row"..row.."_Time"):SetText(a)
	if b~=0 then
		_G("DPSMate_Details_Interrupts_Total_LogDetails_Row"..row.."_CombatTime"):SetText(strformat("%.2f", b).."s")
	else
		_G("DPSMate_Details_Interrupts_Total_LogDetails_Row"..row.."_CombatTime"):SetText("")
	end
	_G("DPSMate_Details_Interrupts_Total_LogDetails_Row"..row.."_Cause"):SetText("|cFF"..hexClassColor[DPSMateUser[c][2] or "warrior"]..c.."|r")
	_G("DPSMate_Details_Interrupts_Total_LogDetails_Row"..row.."_Target"):SetText("|cFF"..hexClassColor[DPSMateUser[d][2] or "warrior"]..d.."|r")
	_G("DPSMate_Details_Interrupts_Total_LogDetails_Row"..row.."_Ability"):SetText(e)
end

function DPSMate.Modules.DetailsInterruptsTotal:EvalTable()
	local a = {}
	for cat, val in db do -- user
		local name = DPSMate:GetUserById(cat)
		if DPSMate:ApplyFilter(curKey, name) then
			for ca, va in val["i"][2] do
				local i=1
				while true do
					if not a[i] then
						tinsert(a, i, {va[2], va[1], DPSMate:GetUserById(cat), DPSMate:GetUserById(va[4]), DPSMate:GetAbilityById(va[3]), cat})
						break
					elseif a[i][2]<va[1] then
						tinsert(a, i, {va[2], va[1], DPSMate:GetUserById(cat), DPSMate:GetUserById(va[4]), DPSMate:GetAbilityById(va[3]), cat})
						break
					end
					i=i+1
				end
			end
		end
	end
	return a
end

function DPSMate.Modules.DetailsInterruptsTotal:ScrollFrameUpdate(direction)
	Offset = Offset - direction
	if (Offset+11)>TL then
		Offset = TL-11
	end
	if Offset<0 then
		Offset = 0
	end
	for i=1, 11 do
		self:UpdateRow(i, "", 0, "", "", "")
	end
	for i=1, 11 do
		local real = i + Offset
		if not DetailsArr[real] then break end
		self:UpdateRow(i, DetailsArr[real][1], DetailsArr[real][2], DetailsArr[real][3], DetailsArr[real][4], DetailsArr[real][5], DetailsArr[real][6])
	end
end

function DPSMate.Modules.DetailsInterruptsTotal:CreateGraphTable(obj)
	local lines = {}
	comp = comp or ""
	for i=1, 11 do
		-- Horizontal
		lines[i] = DPSMate.Options.graph:DrawLine(obj, 10, 375-i*30, 570, 375-i*30, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
		lines[i]:Show()
	end
	-- Vertical
	lines[12] = DPSMate.Options.graph:DrawLine(obj, 80, 370, 80, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[12]:Show()
	
	lines[13] = DPSMate.Options.graph:DrawLine(obj, 150, 370, 150, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[13]:Show()
	
	lines[14] = DPSMate.Options.graph:DrawLine(obj, 240, 370, 240, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[14]:Show()
	
	lines[15] = DPSMate.Options.graph:DrawLine(obj, 330, 370, 330, 15, 20, {0.5,0.5,0.5,0.5}, "BACKGROUND")
	lines[15]:Show()
end

function DPSMate.Modules.DetailsInterruptsTotal:ShowTooltip(user, obj, id)
	local a,b,c = DPSMate.Modules.Interrupts:EvalTable(DPSMateUser[user], curKey, id)
	GameTooltip:SetOwner(obj, "TOPLEFT")
	GameTooltip:AddLine(user.."'s "..strlower(DPSMate.L["interrupts"]), 1,1,1)
	for i=1, DPSMateSettings["subviewrows"] do
		if not a[i] then break end
		GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i][1].." ("..strformat("%.2f", 100*c[i][1]/b).."%)",1,1,1,1,1,1)
		for p=1, 3 do
			if not c[i][2][p] or c[i][3][p]==0 then break end
			GameTooltip:AddDoubleLine("       "..p..". "..DPSMate:GetUserById(c[i][2][p]),c[i][3][p].." ("..strformat("%.2f", 100*c[i][3][p]/a[i]).."%)",0.5,0.5,0.5,0.5,0.5,0.5)
		end
	end
	GameTooltip:Show()
end