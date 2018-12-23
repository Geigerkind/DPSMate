DPSMate.Modules.Debug = {}
DPSMate:Register("debug", DPSMate.Modules.Debug, "debug")

DPSMate.Modules.Debug.Cache = setmetatable({},
  {__mode = "k", __index = function(t,k)
    local timestamp = date("%b/%d %H:%M:%S")
    rawset(t,k,timestamp)
    return timestamp
  end})
DPSMate.Modules.Debug.FRAMES = {}

function DPSMate.Modules.Debug:Store(msg)
  return self.Cache[msg]
end

function DPSMate.Modules.Debug:Out()
  local sorted = {}
  for k,v in pairs(self.Cache) do
    table.insert(sorted,{msg=k, ts=v})
  end
  table.sort(sorted, function(a,b)
      return a.ts < b.ts
    end)
  local out = string.format("`DPSMate build: %s`\r\n",DPSMate.VERSION)
  for i, data in ipairs(sorted) do
    out = string.format("%s\r\n%s - %s",out, data.ts, data.msg)
  end
  return out
end

function DPSMate.Modules.Debug:Clear()
  for k,v in pairs(self.Cache) do
    self.Cache[k] = nil
  end
end

function DPSMate.Modules.Debug:tableCount(tab)
  local count = 0
  for k,v in pairs(tab) do
    count = count + 1
  end
  return count
end

local previousLogout = Logout
Logout = function()
  if DPSMate.Modules.Debug:tableCount(DPSMate.Modules.Debug.Cache) > 0 then
    DPSMate.Modules.Debug:ShowExport()
    local warnings = DPSMate.Modules.Debug:Out()
    DPSMate.Modules.Debug.FRAMES["export"].AddSelectText(warnings)
  else
    previousLogout()
  end
end

function DPSMate.Modules.Debug:ShowExport()
  if not self.FRAMES["export"] then
    self.FRAMES["export"] = CreateFrame("Frame", "DPSMate_Debug_Export", UIParent)
    self.FRAMES["export"]:SetWidth(450)
    self.FRAMES["export"]:SetHeight(250)
    self.FRAMES["export"]:SetPoint('TOP', UIParent, 'TOP', 0,-80)
    self.FRAMES["export"]:SetFrameStrata('DIALOG')
    self.FRAMES["export"]:Hide()
    self.FRAMES["export"]:SetBackdrop({
      bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
      edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
      tile = true,
      tileSize = 16,
      edgeSize = 16,
      insets = {left = 5, right = 5, top = 5, bottom = 5}
      })
    self.FRAMES["export"]:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
    self.FRAMES["export"]:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
    self.FRAMES["export"].title = self.FRAMES["export"]:CreateFontString(nil,"OVERLAY")
    self.FRAMES["export"].title:SetPoint("TOP",0,40)
    self.FRAMES["export"].title:SetFont("Fonts\\ARIALN.TTF", 14)
    self.FRAMES["export"].title:SetWidth(350)
    self.FRAMES["export"].title:SetHeight(45)
    self.FRAMES["export"].title:SetJustifyH("CENTER")
    self.FRAMES["export"].title:SetJustifyV("TOP")
    self.FRAMES["export"].title:SetShadowOffset(1, -1)
    self.FRAMES["export"].edit = CreateFrame("EditBox", "DPSMate_Debug_Export_Edit", self.FRAMES["export"])
    self.FRAMES["export"].edit:SetMultiLine(true)
    self.FRAMES["export"].edit:SetAutoFocus(true)
    self.FRAMES["export"].edit:EnableMouse(true)
    self.FRAMES["export"].edit:SetMaxLetters(0)
    self.FRAMES["export"].edit:SetHistoryLines(1)
    self.FRAMES["export"].edit:SetFont('Fonts\\ARIALN.ttf', 12, 'THINOUTLINE')
    self.FRAMES["export"].edit:SetWidth(490)
    self.FRAMES["export"].edit:SetHeight(290)
    self.FRAMES["export"].edit:SetScript("OnEscapePressed", function() 
        self.FRAMES["export"].edit:SetText("")
        self.FRAMES["export"]:Hide() 
      end)
    self.FRAMES["export"].edit:SetScript("OnEditFocusGained", function()
      self.FRAMES["export"].edit:HighlightText()
    end)
    self.FRAMES["export"].edit:SetScript("OnCursorChanged", function() 
      self.FRAMES["export"].edit:HighlightText()
    end)
    self.FRAMES["export"].AddSelectText = function(txt)
      self.FRAMES["export"].edit:SetText(txt)
      self.FRAMES["export"].edit:HighlightText()
    end
    self.FRAMES["export"].scroll = CreateFrame("ScrollFrame", "DPSMate_Debug_Export_Scroll", self.FRAMES["export"], 'UIPanelScrollFrameTemplate')
    self.FRAMES["export"].scroll:SetPoint('TOPLEFT', self.FRAMES["export"], 'TOPLEFT', 8, -30)
    self.FRAMES["export"].scroll:SetPoint('BOTTOMRIGHT', self.FRAMES["export"], 'BOTTOMRIGHT', -30, 8)
    self.FRAMES["export"].scroll:SetScrollChild(self.FRAMES["export"].edit)
    self.FRAMES["export"]:SetScript("OnHide", function() 
      DPSMate.Modules.Debug:Clear()
      previousLogout()
    end)
    table.insert(UISpecialFrames,"DPSMate_Debug_Export")
  end
  self.FRAMES["export"].title:SetText(LIGHTYELLOW_FONT_COLOR_CODE.."DPSMate build "..DPSMate.VERSION..FONT_COLOR_CODE_CLOSE.." Copy paste to:\nhttps://github.com/Geigerkind/DPSMate/issues\nHit Esc to close.")
  self.FRAMES["export"]:Show()
end
