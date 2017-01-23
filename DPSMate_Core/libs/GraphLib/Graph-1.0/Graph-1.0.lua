--[[
Name: GraphLib-1.0
Revision: $Rev: 36224 $
Author(s): Cryect (cryect@gmail.com)
Website: http://www.wowace.com/
Documentation: http://www.wowace.com/wiki/GraphLib
SVN: http://svn.wowace.com/root/trunk/GraphLib/
Description: Allows for easy creation of graphs
]]

--Thanks to Nelson Minar for catching several errors where width was being used instead of height (damn copy and paste >_>)

local major, minor = "DPSGraph-1.0", "$Revision: 36224 $"

if not AceLibrary then error(major .. " requires AceLibrary.") end
if not AceLibrary:IsNewVersion(major, minor) then return end

local lib={}
local GraphFunctions={}

local gsub = gsub
local ipairs = ipairs
local pairs = pairs
local sqrt = sqrt
local table = table
local tinsert = tinsert
local tremove = tremove
local type = type
local math_max = math.max
local math_min = math.min
local math_ceil = math.ceil
local math_pi = math.pi
local math_floor = math.floor
local math_pow = math.pow
local math_random = math.random
local math_cos = math.cos
local math_sin = math.sin
local math_deg = math.deg
local math_atan = math.atan
local math_abs = math.abs
local math_fmod = math.fmod
local math_huge = math.huge
local table_remove = table.remove
local table_insert = table.insert
local string_format = string.format

local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local GetTime = GetTime
local MouseIsOver = MouseIsOver
local UnitHealth = UnitHealth

local UIParent = UIParent

local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME

--Search for just Addon\\ at the front since the interface part often gets trimmed
local TextureDirectory="Interface\\AddOns\\DPSMate\\libs\\GraphLib\\GraphTextures\\"



--------------------------------------------------------------------------------
--Graph Creation Functions
--------------------------------------------------------------------------------

--Realtime Graph
function lib:CreateGraphRealtime(name,parent,relative,relativeTo,offsetX,offsetY,Width,Height)
	local graph
	local i
	graph = CreateFrame("Frame",name,parent)

	Width = math_floor(Width)
	
	graph:SetPoint(relative,parent,relativeTo,offsetX,offsetY)
	graph:SetWidth(Width)
	graph:SetHeight(Height)
	graph:Show()

	--Create the bars
	graph.Bars={}
	graph.BarsUsing = {}
	graph.BarNum = Width
	graph.Height = Height
	for i=1,Width do
		local bar
		bar = CreateFrame("StatusBar",name.."Bar"..i,graph)--graph:CreateTexture(nil,"ARTWORK")
		bar:SetPoint("BOTTOMLEFT",graph,"BOTTOMLEFT",i-1,0)
		bar:SetHeight(Height)
		bar:SetWidth(1)
		bar:SetOrientation("VERTICAL")
		bar:SetMinMaxValues(0,1)
		bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8.blp")

		local t=bar:GetStatusBarTexture()		
		t:SetGradientAlpha("VERTICAL",0.2,0.0,0.0,0.5,1.0,0.0,0.0,1.0)
		
		bar:Show()
		table_insert(graph.Bars,bar)
		table_insert(graph.BarsUsing, bar)
	end

	
	
	--Set the various functions
	graph.SetXAxis=GraphFunctions.SetXAxis
	graph.SetYMax=GraphFunctions.SetYMax
	graph.AddTimeData=GraphFunctions.AddTimeData
	graph.OnUpdate=GraphFunctions.OnUpdateGraphRealtime
	graph.CreateGridlines=GraphFunctions.CreateGridlines
	graph.RefreshGraph=GraphFunctions.RefreshRealtimeGraph
	graph.SetAxisDrawing=GraphFunctions.SetAxisDrawing
	graph.SetGridSpacing=GraphFunctions.SetGridSpacing
	graph.SetAxisColor=GraphFunctions.SetAxisColor
	graph.SetGridColor=GraphFunctions.SetGridColor
	graph.SetGridColorSecondary = GraphFunctions.SetGridColorSecondary
	graph.SetGridSecondaryMultiple = GraphFunctions.SetGridSecondaryMultiple
	graph.SetFilterRadius=GraphFunctions.SetFilterRadius
	--graph.SetAutoscaleYAxis=GraphFunctions.SetAutoscaleYAxis
	graph.SetBarColors=GraphFunctions.SetBarColors
	graph.SetMode=GraphFunctions.SetMode
	graph.SetAutoScale=GraphFunctions.SetAutoScale

	graph.SetWidth = GraphFunctions.RealtimeSetWidth
	graph.SetHeight = GraphFunctions.RealtimeSetHeight
	graph.SetBarColors = GraphFunctions.RealtimeSetColors
	graph.GetMaxValue = GraphFunctions.GetMaxValue
	graph.GetValue = GraphFunctions.RealtimeGetValue
	graph.SetUpdateLimit = GraphFunctions.SetUpdateLimit
	graph.SetDecay = GraphFunctions.SetDecay
	graph.SetMinMaxY = GraphFunctions.SetMinMaxY
	graph.AddBar = GraphFunctions.AddBar
	graph.SetYLabels = GraphFunctions.SetYLabels
	
	graph.DrawLine=self.DrawLine
	graph.HideLines=self.HideLines
	graph.HideFontStrings=GraphFunctions.HideFontStrings
	graph.FindFontString=GraphFunctions.FindFontString
	graph.ShowFontStrings=GraphFunctions.ShowFontStrings
	graph.SetBars = GraphFunctions.SetBars

	--Set the update function

	--Initialize Data
	graph.GraphType="REALTIME"
	graph.YMax=60
	graph.YMin=0
	graph.XMax=-0.75
	graph.XMin=-10
	graph.TimeRadius=0.5
	graph.XGridInterval=0.25
	graph.YGridInterval=0.25
	graph.YLabelsLeft = true
	graph.Mode="FAST"
	graph.Filter="RECT"
	graph.AxisColor={1.0,1.0,1.0,1.0}
	graph.GridColor={0.5,0.5,0.5,0.5}
	graph.BarColorTop = {1.0, 0.0, 0.0, 1.0}
	graph.BarColorBot = {0.2, 0.0, 0.0, 0.5}
	graph.AutoScale=false
	graph.Data={}
	graph.MinMaxY = 0
	graph.CurVal = 0
	graph.LastDataTime = GetTime()
	
	graph.LimitUpdates = 0
	graph.NextUpdate = 0
	
	graph.BarHeight = {}
	graph.LastShift = GetTime()
	graph.BarWidth = (graph.XMax - graph.XMin) / graph.BarNum
	graph.DecaySet = 0.8
	graph.Decay = math_pow(graph.DecaySet, graph.BarWidth)
	graph.ExpNorm = 1 / (1 - graph.Decay)

	graph.FilterOverlap = math_max(math_ceil((graph.TimeRadius + graph.XMax) / graph.BarWidth), 0)
	for i=1,graph.BarNum do
		graph.BarHeight[i]=0
	end
	
	return graph
end

--Line Graph
--TODO: Clip lines with the bounds
function lib:CreateGraphLine(name,parent,relative,relativeTo,offsetX,offsetY,Width,Height)
	local graph
	local i
	graph = CreateFrame("Frame",name,parent)

	
	graph:SetPoint(relative,parent,relativeTo,offsetX,offsetY)
	graph:SetWidth(Width)
	graph:SetHeight(Height)
	graph:Show()


	
	
	--Set the various functions
	graph.SetXAxis=GraphFunctions.SetXAxis
	graph.SetYAxis=GraphFunctions.SetYAxis
	graph.AddDataSeries=GraphFunctions.AddDataSeries
	graph.ResetData=GraphFunctions.ResetData
	graph.RefreshGraph=GraphFunctions.RefreshLineGraph
	graph.CreateGridlines=GraphFunctions.CreateGridlines
	graph.SetAxisDrawing=GraphFunctions.SetAxisDrawing
	graph.SetGridSpacing=GraphFunctions.SetGridSpacing
	graph.SetAxisColor=GraphFunctions.SetAxisColor
	graph.SetGridColor=GraphFunctions.SetGridColor	
	graph.SetAutoScale=GraphFunctions.SetAutoScale
	graph.SetYLabels=GraphFunctions.SetYLabels
	graph.SetXLabels=GraphFunctions.SetXLabels
	graph.OnUpdate=GraphFunctions.OnUpdateGraph

	graph.LockXMin=GraphFunctions.LockXMin
	graph.LockXMax=GraphFunctions.LockXMax
	graph.LockYMin=GraphFunctions.LockYMin
	graph.LockYMax=GraphFunctions.LockYMax
	


	graph.DrawLine=self.DrawLine
	graph.HideLines=self.HideLines
	graph.HideFontStrings=GraphFunctions.HideFontStrings
	graph.FindFontString=GraphFunctions.FindFontString
	graph.ShowFontStrings=GraphFunctions.ShowFontStrings

	--Set the update function
	graph:SetScript("OnUpdate", graph.OnUpdate)
	
	graph.NeedsUpdate=false


	--Initialize Data
	graph.GraphType="LINE"
	graph.YMax=1
	graph.YMin=-1
	graph.XMax=1
	graph.XMin=-1
	graph.AxisColor={1.0,1.0,1.0,1.0}
	graph.GridColor={0.5,0.5,0.5,0.5}
	graph.XGridInterval=0.25
	graph.YGridInterval=0.25
	graph.XAxisDrawn=true
	graph.YAxisDrawn=true
	
	graph.LockOnXMin=false
	graph.LockOnXMax=false
	graph.LockOnYMin=false
	graph.LockOnYMax=false
	graph.Data={}
	graph.DataPoints={}

	
	
	return graph
end


--Scatter Plot
function lib:CreateGraphScatterPlot(name,parent,relative,relativeTo,offsetX,offsetY,Width,Height)
	local graph
	local i
	graph = CreateFrame("Frame",name,parent)

	
	graph:SetPoint(relative,parent,relativeTo,offsetX,offsetY)
	graph:SetWidth(Width)
	graph:SetHeight(Height)
	graph:Show()


	
	
	--Set the various functions
	graph.SetXAxis=GraphFunctions.SetXAxis
	graph.SetYAxis=GraphFunctions.SetYAxis
	graph.AddDataSeries=GraphFunctions.AddDataSeries
	graph.ResetData=GraphFunctions.ResetData
	graph.RefreshGraph=GraphFunctions.RefreshScatterPlot
	graph.CreateGridlines=GraphFunctions.CreateGridlines
	--graph.OnUpdate=GraphFunctions.OnUpdateGraph
	
	graph.LinearRegression=GraphFunctions.LinearRegression
	graph.SetAxisDrawing=GraphFunctions.SetAxisDrawing
	graph.SetGridSpacing=GraphFunctions.SetGridSpacing
	graph.SetAxisColor=GraphFunctions.SetAxisColor
	graph.SetGridColor=GraphFunctions.SetGridColor
	graph.SetLinearFit=GraphFunctions.SetLinearFit
	graph.SetAutoScale=GraphFunctions.SetAutoScale
	graph.SetYLabels=GraphFunctions.SetYLabels

	graph.LockXMin=GraphFunctions.LockXMin
	graph.LockXMax=GraphFunctions.LockXMax
	graph.LockYMin=GraphFunctions.LockYMin
	graph.LockYMax=GraphFunctions.LockYMax

	graph.DrawLine=self.DrawLine
	graph.HideLines=self.HideLines
	graph.HideTextures=GraphFunctions.HideTextures
	graph.FindTexture=GraphFunctions.FindTexture
	graph.HideFontStrings=GraphFunctions.HideFontStrings
	graph.FindFontString=GraphFunctions.FindFontString

	--Set the update function
	--graph:SetScript("OnUpdate", graph.OnUpdate)
	--graph.NeedsUpdate=false

	--Initialize Data
	graph.GraphType="SCATTER"
	graph.YMax=1
	graph.YMin=-1
	graph.XMax=1
	graph.XMin=-1
	graph.AxisColor={1.0,1.0,1.0,1.0}
	graph.GridColor={0.5,0.5,0.5,0.5}
	graph.XGridInterval=0.25
	graph.YGridInterval=0.25
	graph.XAxisDrawn=true
	graph.YAxisDrawn=true
	graph.AutoScale=false
	graph.LinearFit=false
	graph.LockOnXMin=false
	graph.LockOnXMax=false
	graph.LockOnYMin=false
	graph.LockOnYMax=false
	graph.Data={}
	
	return graph
end

--Pie Chart
function lib:CreateGraphPieChart(name,parent,relative,relativeTo,offsetX,offsetY,Width,Height)
	local graph
	local i
	graph = CreateFrame("Frame",name,parent)
	graph.name = name

	
	graph:SetPoint(relative,parent,relativeTo,offsetX,offsetY)
	graph:SetWidth(Width)
	graph:SetHeight(Height)
	graph:Show()


	
	
	--Set the various functions
	graph.AddPie=GraphFunctions.AddPie
	graph.CompletePie=GraphFunctions.CompletePie
	graph.ResetPie=GraphFunctions.ResetPie

	graph.DrawLine=self.DrawLine
	graph.DrawLinePie=GraphFunctions.DrawLinePie
	graph.HideLines=self.HideLines
	graph.HideTextures=GraphFunctions.HideTextures
	graph.FindTexture=GraphFunctions.FindTexture
	graph.OnUpdate=GraphFunctions.PieChart_OnUpdate
	graph.SetSelectionFunc=GraphFunctions.SetSelectionFunc

	graph:SetScript("OnUpdate", graph.OnUpdate)
	

	--Initialize Data
	graph.GraphType="PIE"
	graph.PieUsed=0
	graph.PercentOn=0
	graph.Remaining=0
	graph.Textures={}
	graph.Ratio=Width/Height
	graph.Radius=0.88*(Width/2)
	graph.Radius=graph.Radius*graph.Radius
	graph.Sections={}
	graph.LastSection=nil
	graph.onColor=1

	return graph
end

-- Stacked Graphs
-- By Shino <Kronos>
-- Aka Geigerkind 
-- Tom D. 
-- http://legacy-logs.com
-- <shino@legacy-logs.com>
function lib:CreateStackedGraphOLD(name,parent,relative,relativeTo,offsetX,offsetY,Width,Height)
	local graph
	local i
	graph = CreateFrame("Frame",name,parent)

	
	graph:SetPoint(relative,parent,relativeTo,offsetX,offsetY)
	graph:SetWidth(Width)
	graph:SetHeight(Height)
	graph:Show()


	
	
	--Set the various functions
	graph.SetXAxis=GraphFunctions.SetXAxis
	graph.SetYAxis=GraphFunctions.SetYAxis
	graph.AddDataSeries=GraphFunctions.AddDataSeries
	graph.ResetData=GraphFunctions.ResetData
	graph.RefreshGraph=GraphFunctions.RefreshStackedGraph
	graph.CreateGridlines=GraphFunctions.CreateGridlines
	graph.SetAxisDrawing=GraphFunctions.SetAxisDrawing
	graph.SetGridSpacing=GraphFunctions.SetGridSpacing
	graph.SetAxisColor=GraphFunctions.SetAxisColor
	graph.SetGridColor=GraphFunctions.SetGridColor	
	graph.SetAutoScale=GraphFunctions.SetAutoScale
	graph.SetYLabels=GraphFunctions.SetYLabels
	graph.SetXLabels=GraphFunctions.SetXLabels
	graph.OnUpdate=GraphFunctions.OnUpdateGraph

	graph.LockXMin=GraphFunctions.LockXMin
	graph.LockXMax=GraphFunctions.LockXMax
	graph.LockYMin=GraphFunctions.LockYMin
	graph.LockYMax=GraphFunctions.LockYMax
	
	graph.FindNearValue=GraphFunctions.FindNearValue

	graph.DrawLine=self.DrawLine
	graph.DrawBar=self.DrawBar
	graph.HideLines=self.HideLines
	graph.HideBars=self.HideBars
	graph.HideFontStrings=GraphFunctions.HideFontStrings
	graph.FindFontString=GraphFunctions.FindFontString
	graph.ShowFontStrings=GraphFunctions.ShowFontStrings

	--Set the update function
	graph:SetScript("OnUpdate", graph.OnUpdate)
	
	graph.NeedsUpdate=false


	--Initialize Data
	graph.GraphType="STACKED"
	graph.YMax=1
	graph.YMin=-1
	graph.XMax=1
	graph.XMin=-1
	graph.AxisColor={1.0,1.0,1.0,1.0}
	graph.GridColor={0.5,0.5,0.5,0.5}
	graph.XGridInterval=0.25
	graph.YGridInterval=0.25
	graph.XAxisDrawn=true
	graph.YAxisDrawn=true
	
	graph.LockOnXMin=false
	graph.LockOnXMax=false
	graph.LockOnYMin=false
	graph.LockOnYMax=false
	graph.Data={}
	graph.DataPoints={}

	
	
	return graph
end








-------------------------------------------------------------------------------
--Functions for Realtime Graphs
-------------------------------------------------------------------------------

--AddTimeData - Adds a data value to the realtime graph at this moment in time
function GraphFunctions:AddTimeData(value)
	local t={}
	t.Time=GetTime()
	t.Value=value
	table_insert(self.Data,t)
end

--RefreshRealtimeGraph - Refreshes the gridlines for the realtime graph
function GraphFunctions:RefreshRealtimeGraph()
	self:HideLines(self)
	self:CreateGridlines()
end

--SetFilterRadius - controls the radius of the filter
function GraphFunctions:SetFilterRadius(radius)
	self.TimeRadius=radius
end

--SetAutoscaleYAxis - If enabled the maximum y axis is adjusted to be 25% more than the max value
function GraphFunctions:SetAutoscaleYAxis(scale)
	self.AutoScale=scale
end

--SetBarColors - 
function GraphFunctions:SetBarColors(BotColor,TopColor)
	for i=1,self.BarNum do
		local t=self.Bars[i]:GetStatusBarTexture()
		t:SetGradientAlpha("VERTICAL",BotColor[1],BotColor[2],BotColor[3],BotColor[4],TopColor[1],TopColor[2],TopColor[3],TopColor[4])
	end
end

function GraphFunctions:SetMode(mode)
	self.Mode=mode

	if mode=="FAST" then
		self.LastShift=GetTime()+xmin
	end
end


-------------------------------------------------------------------------------
--Functions for Line Graph Data
-------------------------------------------------------------------------------

function GraphFunctions:AddDataSeries(points,color,Dp,label)
	--Make sure there is data points
	if not points then
		return
	end
	
	table_insert(self.Data,{Points=points;Color=color;Label=label})
	table_insert(self.DataPoints, Dp)
	
	self.NeedsUpdate=true
end

function GraphFunctions:ResetData()
	self.Data={}
	self.DataPoints={}
	
	self.NeedsUpdate=true
end

function GraphFunctions:SetLinearFit(fit)
	self.LinearFit=fit
	
	self.NeedsUpdate=true
end

function GraphFunctions:HideTextures()
	if not self.Textures then
		self.Textures={}
	end
	for k, t in pairs(self.Textures) do
		t:Hide()
	end
end

--Make sure to show a texture after you grab it or its free for anyone else to grab
function GraphFunctions:FindTexture()
	for k, t in pairs(self.Textures) do
		if not t:IsShown() then
			return t
		end
	end
	local g=self:CreateTexture(nil,"BACKGROUND")
	table_insert(self.Textures,g)
	return g
end

function GraphFunctions:HideFontStrings()
	if not self.FontStrings then
		self.FontStrings={}
	end
	for k, t in pairs(self.FontStrings) do
		t:Hide()
	end
end

function GraphFunctions:ShowFontStrings()
	if not self.FontStrings then
		self.FontStrings={}
	end
	for k, t in pairs(self.FontStrings) do
		t:Show()
	end
end

--Make sure to show a fontstring after you grab it or its free for anyone else to grab
function GraphFunctions:FindFontString()
	for k, t in pairs(self.FontStrings) do
		if not t:IsShown() then
			return t
		end
	end
	local g=self:CreateFontString(nil,"OVERLAY")
	table_insert(self.FontStrings,g)
	return g
end

--Linear Regression via Least Squares
function GraphFunctions:LinearRegression(data)
	local alpha, beta
	local n, SX,SY,SXX, SXY = 0,0,0,0,0

	for k,v in pairs(data) do
		n=n+1

		SX=SX+v[1]
		SXX=SXX+v[1]*v[1]
		SY=SY+v[2]
		SXY=SXY+v[1]*v[2]
	end
	
	beta=(n*SXY-SX*SY)/(n*SXX-SX*SX)
	alpha=(SY-beta*SX)/n

	return alpha, beta
end




-------------------------------------------------------------------------------
--Functions for Pie Chart
-------------------------------------------------------------------------------
local PiePieces={"Pie\\1-2";
		 "Pie\\1-4";
 		 "Pie\\1-8";
		 "Pie\\1-16";
		 "Pie\\1-32";
		 "Pie\\1-64";
		 "Pie\\1-128"}

--26 Colors
local colorByAbility = {}
local AbilityByColor = {}
local ColorTable={
	{0.0,0.9,0.0},
	{0.9,0.0,0.0},
	{0.0,0.0,1.0},
	{1.0,1.0,0.0},
	{1.0,0.0,1.0},
	{0.0,1.0,1.0},
	{1.0,1.0,1.0},
	{0.5,0.0,0.0},
	{0.0,0.5,0.0},
	{0.0,0.0,0.5},
	{0.5,0.5,0.0},
	{0.5,0.0,0.5},
	{0.0,0.5,0.5},
	{0.5,0.5,0.5},
	{0.75,0.25,0.25},
	{0.25,0.75,0.25},
	{0.25,0.25,0.75},
	{0.75,0.75,0.25},
	{0.75,0.25,0.75},
	{0.25,0.75,0.75},
	{1.0,0.5,0.0},	
	{0.0,0.5,1.0},
	{1.0,0.0,0.5},
	{0.5,1.0,0.0},
	{0.5,0.0,1.0},
	{0.0,1.0,0.5},
	{0.1,0.1,0.1},
	{0.2,0.2,0.2},
	{0.3,0.3,0.3},
	{0.4,0.4,0.4},
	{0.5,0.5,0.5},
	{0.6,0.6,0.6},
	{0.7,0.7,0.7},
	{0.8,0.8,0.8},
	{0.9,0.9,0.9},
	{1.0,1.0,1.0},
	{0.15,0.15,0.15},
	{0.25,0.25,0.25},
	{0.35,0.35,0.35},
	{0.45,0.45,0.45},
	{0.55,0.55,0.55},
	{0.65,0.65,0.65},
	{0.75,0.75,0.75},
	{0.85,0.85,0.85},
	{0.95,0.95,0.95},
}
function GraphFunctions:AddPie(Percent, Color, label)
	local k,v
	local PiePercent=self.PercentOn

	local CurPiece=50
	local Angle=180
	local CurAngle=PiePercent*360/100
	local Section={}
	Section.Textures={}
	
	if colorByAbility[label] then
		Color = colorByAbility[label]
	end
	
	if type(Color) ~= "table" and ColorTable[self.onColor] then
		while true do
			if ColorTable[self.onColor] then
				if not AbilityByColor[ColorTable[self.onColor]] then
					Color = ColorTable[self.onColor]
					break
				end
			else
				break
			end
			self.onColor=self.onColor+1
		end
	end
	
	if not ColorTable[self.onColor] and type(Color) ~= "table" then
		ColorTable[self.onColor] = {0.01*math_random(0,100),0.01*math_random(0,100),0.01*math_random(0,100),1}
		Color = ColorTable[self.onColor]
		self.onColor=self.onColor+1
	end
	
	colorByAbility[label] = Color
	AbilityByColor[Color] = label

	if PiePercent==0 then
		self:DrawLinePie(0)
	end
	
	Percent=Percent+self.Remaining
	local LastPiece=0
	for k,v in pairs(PiePieces) do		
		if (Percent+0.1)>CurPiece then
			local t=self:FindTexture()
			
			t:SetTexture(TextureDirectory..v)
			t:ClearAllPoints()
			t:SetPoint("CENTER",self,"CENTER",0,0)
			t:SetHeight(self:GetHeight())
			t:SetWidth(self:GetWidth())
			t.name = self.name
			t.label = label
			t.percent = string_format("%.2f", Percent).."%"
			
			GraphFunctions:RotateTexture(t,CurAngle)
			t:Show()

			t:SetVertexColor(Color[1],Color[2],Color[3],1.0)
			Percent=Percent-CurPiece
			PiePercent=PiePercent+CurPiece
			CurAngle=CurAngle+Angle
			
			table_insert(Section.Textures,t)

			if k == 7 then
				LastPiece=0.09
			end
		end
		CurPiece=CurPiece/2
		Angle=Angle/2
	end

	--Finish adding section data
	Section.Color=Color
	Section.Angle=CurAngle
	table_insert(self.Sections,Section)
	
	self:DrawLinePie((PiePercent+LastPiece)*360/100)
	self.PercentOn=PiePercent
	self.Remaining=Percent

	return Color
end

function GraphFunctions:CompletePie(Color)
	local Percent=100-self.PercentOn
	local k,v
	local PiePercent=self.PercentOn

	local CurPiece=50
	local Angle=180
	local CurAngle=PiePercent*360/100

	local Section={}
	Section.Textures={}
	
	if type(Color)~="table" then
		if self.onColor<=26 then
			Color=ColorTable[self.onColor]
		else
			Color={math_random(),math_random(),math_random()}
		end
		self.onColor=self.onColor+1
	end
	
	
	Percent=Percent+self.Remaining
	if PiePercent~=0 then
		for k,v in pairs(PiePieces) do		
			if (Percent+0.1)>CurPiece then
				local t=self:FindTexture()
				t:SetTexture(TextureDirectory..v)
				t:ClearAllPoints()
				t:SetPoint("CENTER",self,"CENTER",0,0)
				t:SetHeight(self:GetHeight())
				t:SetWidth(self:GetWidth())
				GraphFunctions:RotateTexture(t,CurAngle)
				t:Show()

				t:SetVertexColor(Color[1],Color[2],Color[3],1.0)
				Percent=Percent-CurPiece
				PiePercent=PiePercent+CurPiece
				CurAngle=CurAngle+Angle

				table_insert(Section.Textures,t)
			end
			CurPiece=CurPiece/2
			Angle=Angle/2
		end
	else--Special case if its by itself
		local t=self:FindTexture()
		t:SetTexture(TextureDirectory.."Pie\\1-1")
		t:ClearAllPoints()
		t:SetPoint("CENTER",self,"CENTER",0,0)
		t:SetHeight(self:GetHeight())
		t:SetWidth(self:GetWidth())
		GraphFunctions:RotateTexture(t,CurAngle)
		t:Show()

		t:SetVertexColor(Color[1],Color[2],Color[3],1.0)
		table_insert(Section.Textures,t)
	end

	--Finish adding section data
	Section.Color=Color
	Section.Angle=360
	table_insert(self.Sections,Section)


	self.PercentOn=PiePercent
	self.Remaining=Percent

	return Color
end

function GraphFunctions:ResetPie()
	self:HideTextures()
	self:HideLines(self)

	self.PieUsed=0
	self.PercentOn=0
	self.Remaining=0
	self.onColor=1
	self.LastSection=nil
	self.Sections={}
end

function GraphFunctions:DrawLinePie(angle)
	local sx,sy,ex,ey
	local Radian=math_pi*(90-angle)/180
	local w,h
	w=self:GetWidth()/2
	h=self:GetHeight()/2


	sx=w
	sy=h
	
	ex=sx+0.88*w*math_cos(Radian)
	ey=sx+0.88*h*math_sin(Radian)
	
	self:DrawLine(self,sx,sy,ex,ey,34,{0.0,0.0,0.0,1.0},"OVERLAY")
end

--Used to rotate the pie slices
function GraphFunctions:RotateTexture(texture,angle)
	local Radian=math_pi*(45-angle)/180
	local Radian2=math_pi*(45+90-angle)/180
	local Radius=0.70710678118654752440084436210485

	local tx,ty,tx2,ty2
	tx=Radius*math_cos(Radian)
	ty=Radius*math_sin(Radian)
	tx2=-ty
	ty2=tx

	texture:SetTexCoord(0.5-tx,0.5-ty,0.5+tx2,0.5+ty2,0.5-tx2,0.5-ty2,0.5+tx,0.5+ty)
end

function GraphFunctions:SetSelectionFunc(f)
	self.SelectionFunc=f
end

--TODO: Pie chart pieces need to be clickable
function GraphFunctions:PieChart_OnUpdate()
	if (MouseIsOver(this)) then
		local sX,sY=this:GetCenter()
		local Scale=this:GetEffectiveScale()
		local mX,mY=GetCursorPosition()
		local dX,dY

		dX=mX/Scale-sX
		dY=mY/Scale-sY

		local Angle=90-math_deg(math_atan(dY/dX))
		dY=dY*this.Ratio
		local Dist=dX*dX+dY*dY

		if dX<0 then
			Angle=Angle+180
		end

		--Are we on the Pie Chart?
		if Dist<this.Radius then
			--What section are we on?
			for k, v in pairs(this.Sections) do
				if Angle<v.Angle then
					local Color
					local label = AbilityByColor[v.Color]
					if k~=this.LastSection then
						if this.LastSection then
							local Section=this.Sections[this.LastSection]
							for _, t in pairs(Section.Textures) do
								Color=Section.Color
								--label=t.label
								Percent = t.percent
								t:SetVertexColor(Color[1],Color[2],Color[3],1.0)
							end
						end
						
						if this.SelectionFunc then
							this:SelectionFunc(k)
						end
					end

					local ColorAdd=0.2
					
					Color={}
					Color[1]=v.Color[1]+ColorAdd
					Color[2]=v.Color[2]+ColorAdd
					Color[3]=v.Color[3]+ColorAdd
					
					if label then
						GameTooltip:SetOwner(this, "TOPLEFT")
						GameTooltip:AddLine(label..": "..(this.Sections[k].Textures[1].percent or ""))
						GameTooltip:Show()
					end
					
					for _, t in pairs(v.Textures) do
						t:SetVertexColor(Color[1],Color[2],Color[3],1.0)
					end

					this.LastSection = k

					return
				end
			end
		end
	else
		if this.LastSection then
			local Section=this.Sections[this.LastSection]
			for _, t in pairs(Section.Textures) do
				local Color=Section.Color
				t:SetVertexColor(Color[1],Color[2],Color[3],1.0)
			end
			this.LastSection=nil
		end
		if this.SelectionFunc then
			this:SelectionFunc(k)
		end
		if MouseIsOver(this:GetParent()) then
			GameTooltip:Hide()
		end
	end	
end



-------------------------------------------------------------------------------
--Axis Setting Functions
-------------------------------------------------------------------------------
function GraphFunctions:SetYMax(ymax)
	self.YMax=ymax

	self.NeedsUpdate=true
end

function GraphFunctions:SetYAxis(ymin,ymax)
	self.YMin=ymin
	self.YMax=ymax

	self.NeedsUpdate=true
end

function GraphFunctions:SetXAxis(xmin,xmax)
	self.XMin=xmin
	self.XMax=xmax

	self.NeedsUpdate=true
	
	if self.GraphType=="REALTIME" then
		self.BarWidth=(xmax-xmin)/self.BarNum
		self.FilterOverlap=math_max(math_ceil((self.TimeRadius+xmax)/self.BarWidth),0)
		self.LastShift=GetTime()+xmin
	end
end

function GraphFunctions:SetAutoScale(auto)
	self.AutoScale=auto

	self.NeedsUpdate=true
end

--The various Lock Functions let you use Autoscale but holds the locked points in place
function GraphFunctions:LockXMin(state)
	if state==nil then
		self.LockOnXMin = not self.LockOnXMin
		return
	end
	self.LockOnXMin = state
end

function GraphFunctions:LockXMax(state)
	if state==nil then
		self.LockOnXMax = not self.LockOnXMax
		return
	end
	self.LockOnXMax = state
end

function GraphFunctions:LockYMin(state)
	if state==nil then
		self.LockOnYMin = not self.LockOnYMin
		return
	end
	self.LockOnYMin = state
end

function GraphFunctions:LockYMax(state)
	if state==nil then
		self.LockOnYMax = not self.LockOnYMax
		return
	end
	self.LockOnYMax = state
end


-------------------------------------------------------------------------------
--Functions for Realtime Graphs
-------------------------------------------------------------------------------

--AddTimeData - Adds a data value to the realtime graph at this moment in time
function GraphFunctions:AddTimeData(value)
	if type(value) ~= "number" then
		return
	end

	local t = {}
	t.Time = GetTime()
	self.LastDataTime = t.Time
	t.Value = value
	tinsert(self.Data, t)
end

--RefreshRealtimeGraph - Refreshes the gridlines for the realtime graph
function GraphFunctions:RefreshRealtimeGraph()
	self:HideLines(self)
	self:CreateGridlines()
end

--SetFilterRadius - controls the radius of the filter
function GraphFunctions:SetFilterRadius(radius)
	self.TimeRadius = radius
end

--SetAutoscaleYAxis - If enabled the maximum y axis is adjusted to be 25% more than the max value
function GraphFunctions:SetAutoscaleYAxis(scale)
	self.AutoScale = scale
end

--SetBarColors - 
function GraphFunctions:SetBarColors(BotColor, TopColor)
	local Temp
	if BotColor.r then
		Temp = BotColor
		BotColor = {Temp.r, Temp.g, Temp.b, Temp.a}
	end
	if TopColor.r then
		Temp = TopColor
		TopColor = {Temp.r, Temp.g, Temp.b, Temp.a}
	end
	for i = 1, self.BarNum do
		local t = self.Bars[i]:GetStatusBarTexture()
		t:SetGradientAlpha("VERTICAL", BotColor[1], BotColor[2], BotColor[3], BotColor[4], TopColor[1], TopColor[2], TopColor[3], TopColor[4])
	end
end

function GraphFunctions:SetMode(mode)
	self.Mode = mode

	if mode ~= "SLOW" then
		self.LastShift = GetTime() + self.XMin
	end
end

function GraphFunctions:RealtimeSetColors(BotColor, TopColor)
	local Temp
	if BotColor.r then
		Temp = BotColor
		BotColor = {Temp.r, Temp.g, Temp.b, Temp.a}
	end
	if TopColor.r then
		Temp = TopColor
		TopColor = {Temp.r, Temp.g, Temp.b, Temp.a}
	end
	self.BarColorBot = BotColor
	self.BarColorTop = TopColor
	for _, v in pairs(self.Bars) do
		v:GetStatusBarTexture():SetGradientAlpha("VERTICAL", self.BarColorBot[1], self.BarColorBot[2], self.BarColorBot[3], self.BarColorBot[4], self.BarColorTop[1], self.BarColorTop[2], self.BarColorTop[3], self.BarColorTop[4])
	end
end

function GraphFunctions:RealtimeSetWidth(Width)
	Width = math_floor(Width)

	if Width == self.BarNum then
		return
	end

	self.BarNum = Width
	for i = 1, Width do
		if type(self.Bars[i]) == "nil" then
			local bar
			bar = CreateFrame("StatusBar", self:GetName().."Bar"..i, self)
			bar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", i - 1, 0)
			bar:SetHeight(self.Height)
			bar:SetWidth(1)
			bar:SetOrientation("VERTICAL")
			bar:SetMinMaxValues(0, 1)
			bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
			bar:GetStatusBarTexture():SetHorizTile(false)
			bar:GetStatusBarTexture():SetVertTile(false)

			local t = bar:GetStatusBarTexture()
			t:SetGradientAlpha("VERTICAL", self.BarColorBot[1], self.BarColorBot[2], self.BarColorBot[3], self.BarColorBot[4], self.BarColorTop[1], self.BarColorTop[2], self.BarColorTop[3], self.BarColorTop[4])

			tinsert(self.Bars, bar)
		else
			self.Bars[i]:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", i - 1, 0)
		end
		self.BarHeight[i] = 0
	end

	local SizeOfBarsUsed = table.maxn(self.BarsUsing)

	if Width > SizeOfBarsUsed then
		for i = SizeOfBarsUsed + 1, Width do
			tinsert(self.BarsUsing, self.Bars[i])
			self.Bars[i]:Show()
		end
	elseif Width < SizeOfBarsUsed then
		for i = Width + 1, SizeOfBarsUsed do
			tremove(self.BarsUsing, Width + 1)
			self.Bars[i]:Hide()
		end
	end

	self.BarWidth = (self.XMax - self.XMin) / self.BarNum
	self.Decay = math_pow(self.DecaySet, self.BarWidth)
	self.ExpNorm = 1 / (1 - self.Decay) / 0.95 --Actually a finite geometric series


	self:OldSetWidth(Width)
	self:RefreshGraph()
end

function GraphFunctions:RealtimeSetHeight(Height)
	self.Height = Height

	for i = 1, self.BarNum do
		--self.Bars[i]:Hide()
		self.Bars[i]:SetValue(0)
		self.Bars[i]:SetHeight(self.Height)
	end

	self:OldSetHeight(Height)
	self:RefreshGraph()
end

function GraphFunctions:GetMaxValue()
	--Is there any data that could possibly be not zero?
	if self.LastDataTime < (self.LastShift + self.XMin - self.TimeRadius) then
		return 0
	end

	local MaxY = 0

	for i = 1, self.BarNum do
		MaxY = math_max(MaxY, self.BarHeight[i])
	end

	return MaxY
end



function GraphFunctions:RealtimeGetValue(Time)
	local Bar
	if Time < self.XMin or Time > self.XMax then
		return 0
	end

	Bar = math_min(math_max(math_floor(self.BarNum * (Time - self.XMin) / (self.XMax - self.XMin) + 0.5), 1), self.BarNum)

	return self.BarHeight[Bar]
end

function GraphFunctions:SetUpdateLimit(Time)
	self.LimitUpdates = Time
end

function GraphFunctions:SetDecay(decay) 
	self.DecaySet = decay
	self.Decay = math_pow(self.DecaySet, self.BarWidth)
	self.ExpNorm = 1 / (1 - self.Decay) / 0.95 --Actually a finite geometric series (divide 0.96 instead of 1 since seems doesn't quite work right)
end

function GraphFunctions:AddBar(value)
	for i = 1, self.BarNum - 1 do
		self.BarHeight[i] = self.BarHeight[i + 1]
	end
	self.BarHeight[self.BarNum] = value
	self.AddedBar = true
end

function GraphFunctions:SetBars()
	local YHeight = self.YMax - self.YMin

	for i, bar in pairs(self.BarsUsing) do
		local h
		h = (self.BarHeight[i] - self.YMin) / YHeight

		bar:SetValue(h)
	end
end


-------------------------------------------------------------------------------
--Grid & Axis Drawing Functions 
-------------------------------------------------------------------------------
function GraphFunctions:SetAxisDrawing(xaxis, yaxis)
	self.XAxisDrawn=xaxis
	self.YAxisDrawn=yaxis

	self.NeedsUpdate=true
end

function GraphFunctions:SetGridSpacing(xspacing,yspacing)
	self.XGridInterval=xspacing
	self.YGridInterval=yspacing

	self.NeedsUpdate=true
end

function GraphFunctions:SetAxisColor(color)
	self.AxisColor=color

	self.NeedsUpdate=true
end

function GraphFunctions:SetGridColor(color)
	self.GridColor=color

	self.NeedsUpdate=true
end

function GraphFunctions:SetYLabels(Left,Right)
	self.YLabelsLeft=Left
	self.YLabelsRight=Right
end

function GraphFunctions:SetXLabels(bool)
	self.XLabels=bool
end

function GraphFunctions:CreateGridlines()
	local Width=self:GetWidth()
	local Height=self:GetHeight()
	self:HideLines(self)
	self:HideFontStrings()
	
	if self.YGridInterval then
		local LowerYGridLine,UpperYGridLine,TopSpace
		LowerYGridLine=self.YMin/self.YGridInterval
		LowerYGridLine=math_max(math_floor(LowerYGridLine),math_ceil(LowerYGridLine))
		UpperYGridLine=self.YMax/self.YGridInterval
		UpperYGridLine=math_min(math_floor(UpperYGridLine),math_ceil(UpperYGridLine))
		TopSpace=Height*(1-(UpperYGridLine*self.YGridInterval)/(self.YMax))
		
		local alpha = 0
		for i=LowerYGridLine,UpperYGridLine do
			if not self.YAxisDrawn or i~=0 then
				if alpha>1000 then break end
				local YPos,T,F
				YPos=Height*(i*self.YGridInterval+self.YBorder)/(self.YMax)
				if YPos<(Height-2) and YPos>24 then
					if self.GraphType~="REALTIME" then
						T=self:DrawLine(self,0,YPos,Width,YPos,24,self.GridColor,"BACKGROUND")
					end
					if (((i~=UpperYGridLine) or (TopSpace>12))) and alpha==ceil(((UpperYGridLine-LowerYGridLine)/6)) then
						if self.GraphType=="REALTIME" then
							T=self:DrawLine(self,0,YPos,Width,YPos,24,self.GridColor,"BACKGROUND")
						end
						if self.YLabelsLeft then
							F=self:FindFontString()
							F:SetFontObject("GameFontHighlightSmall")
							F:SetTextColor(1,1,1)
							F:ClearAllPoints()
							F:SetPoint("BOTTOMLEFT",T,"LEFT",2,2)
							F:SetText(floor(i*self.YGridInterval))
							F:Show()
						end

						if self.YLabelsRight then
							F=self:FindFontString()
							F:SetFontObject("GameFontHighlightSmall")
							F:SetTextColor(1,1,1)
							F:ClearAllPoints()
							F:SetPoint("BOTTOMRIGHT",T,"RIGHT",-2,2)
							F:SetText(i*self.YGridInterval)
							F:Show()
						end
						alpha = 0
					end
					alpha = alpha+1
				end
			end
		end
	end

	if self.XGridInterval then
		local LowerXGridLine,UpperXGridLine
		LowerXGridLine=self.XMin/self.XGridInterval
		LowerXGridLine=math_max(math_floor(LowerXGridLine),math_ceil(LowerXGridLine))
		UpperXGridLine=self.XMax/self.XGridInterval
		UpperXGridLine=math_min(math_floor(UpperXGridLine),math_ceil(UpperXGridLine))

		for i=LowerXGridLine,UpperXGridLine do
			if i~=0 or not self.XAxisDrawn then
				local XPos, T, F
				XPos=Width*(i*self.XGridInterval-self.XMin)/(self.XMax-self.XMin)
				T=self:DrawLine(self,XPos,0,XPos,Height,24,self.GridColor,"BACKGROUND")
				
				if self.XLabels then
					F=self:FindFontString()
					F:SetFontObject("GameFontHighlightSmall")
					F:SetTextColor(1,1,1)
					F:ClearAllPoints()
					F:SetPoint("BOTTOM",T,"BOTTOM",0,0)
					F:SetText(floor(i*self.XGridInterval))
					F:Show()
				end
			end
		end
	end

	if self.YAxisDrawn and self.YMax>=0 and self.YMin<=0 then
		local YPos,T

		YPos=Height*(-self.YMin)/(self.YMax-self.YMin)
		self.yAxis = self:DrawLine(self,0,YPos,Width,YPos,24,self.AxisColor,"BACKGROUND")

		if self.YLabelsLeft  then
			F=self:FindFontString()
			F:SetFontObject("GameFontHighlightSmall")
			F:SetTextColor(1,1,1)
			F:ClearAllPoints()
			F:SetPoint("BOTTOMLEFT",self.yAxis,"LEFT",2,2)
			F:SetText(0)
			F:Show()
		end
		if self.YLabelsRight  then
			F=self:FindFontString()
			F:SetFontObject("GameFontHighlightSmall")
			F:SetTextColor(1,1,1)
			F:ClearAllPoints()
			F:SetPoint("BOTTOMRIGHT",self.yAxis,"RIGHT",-2,2)
			F:SetText(0)
			F:Show()
		end
	end

	if self.XAxisDrawn and self.XMax>=0 and self.XMin<=0 then
		local XPos;

		XPos=Width*(-self.XMin)/(self.XMax-self.XMin)
		self.xAxis = self:DrawLine(self,XPos,0,XPos,Height,24,self.AxisColor,"BACKGROUND")
	end
end







--------------------------------------------------------------------------------
--Refresh functions
--------------------------------------------------------------------------------

function GraphFunctions:OnUpdateGraph()
	if this.NeedsUpdate and this.RefreshGraph then
		this:RefreshGraph()
		this.NeedsUpdate=false
	end
end

--Performs a convolution in realtime allowing to graph Framerate, DPS, or any other data you want graphed in realtime
function GraphFunctions:OnUpdateGraphRealtime(obj)
	local i,j
	local CurTime=GetTime()
	local MaxBarHeight=obj:GetHeight()
	local BarsChanged
	
	if self.NextUpdate > CurTime or (self.Mode == "RAW" and not (self.NeedsUpdate or self.AddedBar)) then
		return
	end

	self.NextUpdate = CurTime + self.LimitUpdates
	
	--Slow Mode performs an entire convolution every frame
	if self.Mode=="FAST" then
		local ShiftBars = math_floor((CurTime - self.LastShift) / self.BarWidth)

		if ShiftBars > 0 and not (self.LastDataTime < (self.LastShift + self.XMin - self.TimeRadius * 2)) then
			local RecalcBars = self.BarNum - (ShiftBars + self.FilterOverlap) + 1

			for i = 1, self.BarNum do
				if i < RecalcBars then
					self.BarHeight[i] = self.BarHeight[i + ShiftBars]
				else
					self.BarHeight[i] = 0
				end
			end

			local BarTimeRadius = (self.XMax - self.XMin) / self.BarNum
			local DataValue = 1 / (2 * self.TimeRadius)
			local TimeDiff = CurTime-self.LastShift

			CurTime = self.LastShift + ShiftBars * self.BarWidth
			self.LastShift = CurTime

			if self.Filter == "RECT" then
				--Take the convolution of the dataset on to the bars wtih a rectangular filter
				local DataValue = 1 / (2 * self.TimeRadius)
				for k, v in pairs(self.Data) do
					if v.Time < (CurTime + self.XMax - self.TimeRadius - TimeDiff) then
						tremove(self.Data, k)
					else
						local DataTime = v.Time - CurTime
						local LowestBar = math_max(math_max(math_floor((DataTime - self.XMin - self.TimeRadius) / BarTimeRadius), RecalcBars), 1)
						local HighestBar = math_min(math_ceil((DataTime - self.XMin + self.TimeRadius) / BarTimeRadius), self.BarNum)
						if LowestBar <= HighestBar then
							for i = LowestBar, HighestBar do
								self.BarHeight[i] = self.BarHeight[i] + v.Value * DataValue * 2
							end
						end
					end
				end
			end
			BarsChanged = true
		else
			CurTime = self.LastShift + ShiftBars * self.BarWidth
			self.LastShift = CurTime
		end
	end


	if BarsChanged then
		if self.AutoScale then
			local MaxY = 0

			for i = 1, self.BarNum do
				MaxY = math_max(MaxY, self.BarHeight[i])
			end
			MaxY = 1.25 * MaxY

			MaxY = math_max(MaxY, self.MinMaxY)

			self.XBorder = 10
			self.YBorder = 0
			if MaxY ~= 0 and math_abs(self.YMax - MaxY) > 0.01 then
				self.YMax = MaxY
				self.NeedsUpdate = true
			end
		end
		self:SetBars()
	end

	if self.NeedsUpdate then
		self.NeedsUpdate = false
		self:RefreshGraph()
	end
end

--Line Graph
function GraphFunctions:RefreshLineGraph()
	local k1, k2, series
	self:HideLines(self)
	
	local Width=self:GetWidth()
	local Height=self:GetHeight()
	
	if self.AutoScale and self.Data then -- math_huge not implemented
		local MinX, MaxX, MinY, MaxY = 1, -3, 200, -900
		for k1, series in pairs(self.Data) do
			for k2, point in pairs(series.Points) do
				if not MinX or point[1]<MinX then MinX = point[1] end
				if not MinY or point[2]<MinY then MinY = point[2] end
				if not MaxX or point[1]>MaxX then MaxX = point[1] end
				if not MaxY or point[2]>MaxY then MaxY = point[2] end
			end
		end

		local XBorder, YBorder

		XBorder=(60/Width)*MaxX
		YBorder=(24/Height)*MaxY
		self.XBorder=XBorder
		self.YBorder = YBorder
		self.YGridInterval = (MaxY+200)/7
		self.XGridInterval = MaxX/7
		
		if not self.LockOnXMin then
			self.XMin=MinX-XBorder
		end
		if not self.LockOnXMax then
			self.XMax=MaxX
		end
		if not self.LockOnYMin then
			self.YMin=MinY-YBorder
		end
		if not self.LockOnYMax then
			self.YMax=MaxY+YBorder
		end
	end

	self:CreateGridlines()

	for k1, series in pairs(self.Data) do
		local LastPoint
		LastPoint=nil
		for k2, point in pairs(series.Points) do
			if LastPoint then
				local TPoint={x=point[1];y=point[2]}

				TPoint.x=Width*(TPoint.x-self.XMin)/(self.XMax-self.XMin)
				TPoint.y=(Height-24)*(TPoint.y)/(self.YMax-self.YBorder)
				
				if point[3] then
					self:DrawLine(self,LastPoint.x,LastPoint.y,TPoint.x,TPoint.y,32,series.Color[2],nil,point, nil, 24)
				else
					self:DrawLine(self,LastPoint.x,LastPoint.y,TPoint.x,TPoint.y,32,series.Color[1],nil,point, nil, 24)
				end

				LastPoint=TPoint
			else
				LastPoint={x=point[1];y=point[2]}
				LastPoint.x=Width*(LastPoint.x-self.XMin)/(self.XMax-self.XMin)
				LastPoint.y=(Height-24)*(LastPoint.y)/(self.YMax-self.YBorder)
			end
		end
	end
	
	self.ppoints = {}
	if self.DataPoints then
		for uuu, zzz in self.DataPoints do
			if zzz[2] then
				for k3, p2 in pairs(zzz[2]) do
					-- Needs fine tuning
					local PPoint = self:CreateTexture()
					PPoint:SetTexture(TextureDirectory.."party") 
					PPoint:SetVertexColor(self.Data[uuu].Color[1][1], self.Data[uuu].Color[1][2], self.Data[uuu].Color[1][3], 1)
					local PPLastPointX = Width*(p2[2][1]-self.XMin)/(self.XMax-self.XMin)
					local PPLastPointY = (Height-24)*(p2[2][2])/(self.YMax-self.YBorder)
					local PPNextPointX = Width*(p2[3][1]-self.XMin)/(self.XMax-self.XMin)
					local PPNextPointY = (Height-24)*(p2[3][2])/(self.YMax-self.YBorder)
					local pointx = Width*(p2[1]-self.XMin)/(self.XMax-self.XMin)
					local pointy = PPLastPointY + (pointx-PPLastPointX)*((PPNextPointY-PPLastPointY)/(PPNextPointX-PPLastPointX))
					PPoint:SetPoint("LEFT", self.yAxis, "LEFT", pointx-(12-floor(self:GetWidth()/850)*6.5), pointy-20+24)
					PPoint:SetHeight(20)
					PPoint:SetWidth(20)
					table_insert(self.ppoints, PPoint)
				end
			end
		end
	end
	
	--self:ShowFontStrings()
	--self:ShowFontStrings()
end

--Scatter Plot Refresh
function GraphFunctions:RefreshScatterPlot()
	local k1, k2, series, point
	self:HideLines(self)

	if self.AutoScale and self.Data then
		local MinX, MaxX, MinY, MaxY = math_huge, -math_huge, math_huge, -math_huge
		for k1, series in pairs(self.Data) do
			for k2, point in pairs(series.Points) do
				MinX=math_min(point[1],MinX)
				MaxX=math_max(point[1],MaxX)
				MinY=math_min(point[2],MinY)
				MaxY=math_max(point[2],MaxY)
			end
		end

		local XBorder, YBorder

		XBorder=0.1*(MaxX-MinX)
		YBorder=0.1*(MaxY-MinY)

		if not self.LockOnXMin then
			self.XMin=MinX-XBorder
		end
		if not self.LockOnXMax then
			self.XMax=MaxX+XBorder
		end
		if not self.LockOnYMin then
			self.YMin=MinY-YBorder
		end
		if not self.LockOnYMax then
			self.YMax=MaxY+YBorder
		end
	end

	self:CreateGridlines()

	local Width=self:GetWidth()
	local Height=self:GetHeight()
	
	self:HideTextures()
	for k1, series in pairs(self.Data) do
		local MinX,MaxX = self.XMax, self.XMin
		for k2, point in pairs(series.Points) do
			local x,y
			MinX=math_min(point[1],MinX)
			MaxX=math_max(point[1],MaxX)
			x=Width*(point[1]-self.XMin)/(self.XMax-self.XMin)
			y=Height*(point[2]-self.YMin)/(self.YMax-self.YMin)

			local g=self:FindTexture()
			g:SetTexture("Spells\\GENERICGLOW2_64.blp")
			g:SetWidth(6)
			g:SetHeight(6)
			g:ClearAllPoints()
			g:SetPoint("CENTER",self,"BOTTOMLEFT",x,y)
			g:SetVertexColor(series.Color[1],series.Color[2],series.Color[3],series.Color[4]);
			g:Show()
		end

		if self.LinearFit then
			local alpha, beta = self:LinearRegression(series.Points)
			local sx,sy,ex,ey
			
			sx=MinX
			sy=beta*sx+alpha
			ex=MaxX
			ey=beta*ex+alpha

			sx=Width*(sx-self.XMin)/(self.XMax-self.XMin)
			sy=Height*(sy-self.YMin)/(self.YMax-self.YMin)
			ex=Width*(ex-self.XMin)/(self.XMax-self.XMin)
			ey=Height*(ey-self.YMin)/(self.YMax-self.YMin)

			self:DrawLine(self,sx,sy,ex,ey,32,series.Color)
		end
	end
end

function GraphFunctions:FindNearValue(arr, val)
	for cat, var in arr do
		if (val+0.5)>=cat and (val-0.5)<=cat then
			return cat
		end
	end
	return false
end

-- Stacked Graph
function GraphFunctions:RefreshStackedGraph()
	self:HideLines(self)
	self:HideBars(self)
	
	-- Format table
	for k1, series in pairs(self.Data) do
		local p = {}
		for c,v in pairs(series.Points) do
			for k2, point in pairs(v) do
				point[1] = math_floor(point[1])
				local near = self:FindNearValue(p, point[1])
				if near then
					p[near] = p[near] + point[2]
					point[2] = p[near]
				else
					p[point[1]] = point[2]
				end
			end
		end
	end
	
	if self.AutoScale and self.Data then -- math_huge not implemented
		local MinX, MaxX, MinY, MaxY = 1, -3, 200, -900
		for k1, series in pairs(self.Data) do
			for c,v in series.Points do
				for k2, point in v do
					MinX=math_min(point[1],MinX)
					MaxX=math_max(point[1],MaxX)
					MinY=math_min(point[2],MinY)
					MaxY=math_max(point[2],MaxY)
				end
			end
		end

		local XBorder, YBorder

		XBorder=0.05*(MaxX-MinX)
		YBorder=0.1*(MaxY-MinY)
		
		if not self.LockOnXMin then
			self.XMin=MinX-XBorder
		end
		if not self.LockOnXMax then
			self.XMax=MaxX
		end
		if not self.LockOnYMin then
			self.YMin=MinY-YBorder
		end
		if not self.LockOnYMax then
			self.YMax=MaxY+YBorder
		end
	end
	
	self:CreateGridlines()
	
	local Width=self:GetWidth()
	local Height=self:GetHeight()
	
	for k1, series in pairs(self.Data) do
		for c,v in series.Points do
			local LastPoint
			LastPoint=nil
			for k2, point in pairs(v) do
				if LastPoint then
					local TPoint={x=point[1];y=point[2]}
					
					--DPSMate:SendMessage((TPoint.x or 0).."/"..(TPoint.y or 0))

					TPoint.x=Width*(TPoint.x-self.XMin)/(self.XMax-self.XMin)
					TPoint.y=Height*(TPoint.y-self.YMin)/(self.YMax-self.YMin)
					
					if not ColorTable[c] then
						ColorTable[c] = {0.01*math_random(0,100),0.01*math_random(0,100),0.01*math_random(0,100),1}
					end
					self:DrawLine(self,LastPoint.x,LastPoint.y,TPoint.x,TPoint.y,32,ColorTable[c],nil,point,series.Label[c])
					self:DrawBar(self, LastPoint.x, LastPoint.y, TPoint.x, TPoint.y, ColorTable[c], c, series.Label[c])

					LastPoint=TPoint
				else
					LastPoint={x=point[1];y=point[2]}
					LastPoint.x=Width*(LastPoint.x-self.XMin)/(self.XMax-self.XMin)
					LastPoint.y=Height*(LastPoint.y-self.YMin)/(self.YMax-self.YMin)
				end
			end
		end
	end
end







--Copied from Blizzard's TaxiFrame code and modifed for IMBA then remodified for GraphLib

-- The following function is used with permission from Daniel Stephens <iriel@vigilance-committee.org>
local TAXIROUTE_LINEFACTOR = 128/126; -- Multiplying factor for texture coordinates
local TAXIROUTE_LINEFACTOR_2 = TAXIROUTE_LINEFACTOR / 2; -- Half o that

-- T        - Texture
-- C        - Canvas Frame (for anchoring)
-- sx,sy    - Coordinate of start of line
-- ex,ey    - Coordinate of end of line
-- w        - Width of line
-- relPoint - Relative point on canvas to interpret coords (Default BOTTOMLEFT)
function lib:DrawLine(C, sx, sy, ex, ey, w, color, layer, point, label, const)
	local T, lineNum, relPoint, P;
	if (not relPoint) then relPoint = "BOTTOMLEFT"; end
	const = const or 0

	if not C.GraphLib_Lines then
		C.GraphLib_Lines={}
	end

	T=nil;

	for k,v in pairs(C.GraphLib_Lines) do
		if not v[1]:IsShown() and not T then
			T=v[1];
			P=v[2];
			lineNum=k;
			P:Show();
			T:Show();		
		end
	end
	
	if point and T and not T.val then
		T.val = ceil(point[2])
	end
	if label and T and not T.label then
		T.label = label
	end

	if not T then
		P = CreateFrame("Frame", C:GetName().."_LineTT"..(getn(C.GraphLib_Lines)+1), C)
		P:SetHeight(15)
		P:SetWidth(15)
		P:EnableMouse(true)
		
		P:SetScript("OnEnter", function()
			if T.val then
				GameTooltip:SetOwner(P)
				GameTooltip:AddLine("Value: "..T.val)
				if T.label then
					GameTooltip:AddLine("Label: "..T.label)
				end
				GameTooltip:Show()
			end
		end)
		P:SetScript("OnLeave", function()
			if T.val then
				GameTooltip:Hide()
			end
		end)
		T=C:CreateTexture(C:GetName().."_Line"..(getn(C.GraphLib_Lines)+1), "ARTWORK");
		T:SetTexture(TextureDirectory.."line");
		if point then
			T.val = ceil(point[2])
		end
		if label and T then
			T.label = label
		end
		tinsert(C.GraphLib_Lines,{[1]=T,[2]=P});
	end
	
	if layer then
		T:SetDrawLayer(layer)
	end
	T:SetVertexColor(color[1],color[2],color[3],color[4]);
	-- Determine dimensions and center point of line
	local dx,dy = ex - sx, ey - sy;
	local cx,cy = (sx + ex) / 2, (sy + ey) / 2;

	-- Normalize direction if necessary
	if (dx < 0) then
		dx,dy = -dx,-dy;
	end

	-- Calculate actual length of line
	local l = sqrt((dx * dx) + (dy * dy));

	-- Quick escape if it's zero length
	if (l == 0) then
		T:Hide()
		return;
	end

	-- Sin and Cosine of rotation, and combination (for later)
	local s,c = -dy / l, dx / l;
	local sc = s * c;

	-- Calculate bounding box size and texture coordinates
	local Bwid, Bhgt, BLx, BLy, TLx, TLy, TRx, TRy, BRx, BRy;
	if (dy >= 0) then
		Bwid = ((l * c) - (w * s)) * TAXIROUTE_LINEFACTOR_2;
		Bhgt = ((w * c) - (l * s)) * TAXIROUTE_LINEFACTOR_2;
		BLx, BLy, BRy = (w / l) * sc, s * s, (l / w) * sc;
		BRx, TLx, TLy, TRx = 1 - BLy, BLy, 1 - BRy, 1 - BLx; 
		TRy = BRx;
	else
		Bwid = ((l * c) + (w * s)) * TAXIROUTE_LINEFACTOR_2;
		Bhgt = ((w * c) + (l * s)) * TAXIROUTE_LINEFACTOR_2;
		BLx, BLy, BRx = s * s, -(l / w) * sc, 1 + (w / l) * sc;
		BRy, TLx, TLy, TRy = BLx, 1 - BRx, 1 - BLx, 1 - BLy;
		TRx = TLy;
	end

	-- Set texture coordinates and anchors
	T:ClearAllPoints();
	T:SetTexCoord(TLx, TLy, BLx, BLy, TRx, TRy, BRx, BRy);
	T:SetPoint("BOTTOMLEFT", C, relPoint, cx - Bwid, cy - Bhgt + const);
	T:SetPoint("TOPRIGHT",	C, relPoint, cx + Bwid, cy + Bhgt + const);
	P:ClearAllPoints();
	P:SetParent(C);
	--P:SetPoint("BOTTOMLEFT", C, relPoint, cx - Bwid, cy - Bhgt);
	if (ey-sy)<0 then
		P:SetPoint("BOTTOMLEFT", C, relPoint, cx + Bwid -22.5, cy - Bhgt + 11.25 + const);
	else
		P:SetPoint("BOTTOMLEFT", C, relPoint, cx + Bwid -22.5, cy + Bhgt - 11.25 + const);
	end
	return T
end

--Thanks to Celandro
function lib:DrawVLine(C, x, sy, ey, w, color, layer)
	local relPoint = "BOTTOMLEFT"

	if not C.GraphLib_Lines then
		C.GraphLib_Lines = {}
		C.GraphLib_Lines_Used = {}
	end

	local T = tremove(C.GraphLib_Lines) or C:CreateTexture(nil, "ARTWORK")
	T:SetTexture(TextureDirectory.."sline")
	tinsert(C.GraphLib_Lines_Used, T)

	T:SetDrawLayer(layer or "ARTWORK")

	T:SetVertexColor(color[1], color[2], color[3], color[4])

	if sy > ey then
		sy, ey = ey, sy
	end

	-- Set texture coordinates and anchors
	T:ClearAllPoints()
	T:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1)
	T:SetPoint("BOTTOMLEFT", C, relPoint, x - w / 2, sy)
	T:SetPoint("TOPRIGHT", C, relPoint, x + w / 2, ey)
	T:Show()
	return T
end

function lib:DrawHLine(C, sx, ex, y, w, color, layer)
	local relPoint = "BOTTOMLEFT"

	if not C.GraphLib_Lines then
		C.GraphLib_Lines = {}
		C.GraphLib_Lines_Used = {}
	end

	local T = tremove(C.GraphLib_Lines) or C:CreateTexture(nil, "ARTWORK")
	T:SetTexture(TextureDirectory.."sline")
	tinsert(C.GraphLib_Lines_Used, T)

	T:SetDrawLayer(layer or "ARTWORK")

	T:SetVertexColor(color[1], color[2], color[3], color[4])

	if sx > ex then
		sx, ex = ex, sx
	end

	-- Set texture coordinates and anchors
	T:ClearAllPoints()
	T:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	T:SetPoint("BOTTOMLEFT", C, relPoint, sx, y - w / 2)
	T:SetPoint("TOPRIGHT", C, relPoint, ex, y + w / 2)
	T:Show()
	return T
end

function lib:DrawBar(C, sx, sy, ex, ey, color, level, label)
	local Bar, Tri, barNum, MinY, MaxY, P

	--Want sx <= ex if not then flip them
	if sx > ex then
		sx, ex = ex, sx
		sy, ey = ey, sy
	end

	if not C.GraphLib_Bars then
		C.GraphLib_Bars = {}
		C.GraphLib_Tris = {}
		C.GraphLib_Bars_Used = {}
		C.GraphLib_Tris_Used = {}
		C.GraphLib_Frames = {}
	end
	
	local bars = getn(C.GraphLib_Bars)
	if bars > 0 then
		local tris = getn(C.GraphLib_Tris)
		Bar = C.GraphLib_Bars[bars][1]
		tremove(C.GraphLib_Bars, bars)
		Bar:Show()
		
		--P = C.GraphLib_Bars[bars][2]
		--P:Show()

		Tri = C.GraphLib_Tris[tris]
		tremove(C.GraphLib_Tris, tris)
		Tri:Show()
	end

	if not Bar then
		--P = CreateFrame("Frame", C:GetName().."_AreaTT"..(getn(C.GraphLib_Bars)+1), C)
		--P:SetHeight(10)
		--P:SetWidth(10)
		--P:EnableMouse(true)
		
		--P:SetScript("OnEnter", function()
			--if label then
			--	GameTooltip:SetOwner(P)
			--	GameTooltip:AddLine("Label: "..label)
			--	GameTooltip:Show()
			--end
		--end)
	--	P:SetScript("OnLeave", function()
		--	if label then
		--		GameTooltip:Hide()
		--	end
		--end)
		Bar = C:CreateTexture(nil, "ARTWORK")
		Bar:SetTexture(1, 1, 1, 1)

		Tri = C:CreateTexture(nil, "ARTWORK")
		Tri:SetTexture(TextureDirectory.."triangle")
	end

	tinsert(C.GraphLib_Bars_Used, {Bar})
	tinsert(C.GraphLib_Tris_Used, Tri)

	if level then
		if type(C.GraphLib_Frames[level]) == "nil" then
			local newLevel = 100 - level
			C.GraphLib_Frames[level] = CreateFrame("Frame", nil, C)
			C.GraphLib_Frames[level]:SetFrameLevel(newLevel)
			C.GraphLib_Frames[level]:SetAllPoints(C)

			if C.TextFrame and C.TextFrame:GetFrameLevel() <= newLevel then
				C.TextFrame:SetFrameLevel(newLevel + 1)
				self.NeedsUpdate = true
			end
		end

		Bar:SetParent(C.GraphLib_Frames[level])
		Tri:SetParent(C.GraphLib_Frames[level])
	end

	Bar:SetVertexColor(color[1], color[2], color[3], color[4])
	Tri:SetVertexColor(color[1], color[2], color[3], color[4])


	if sy < ey then
		Tri:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		MinY = sy
		MaxY = ey
	else
		Tri:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1)
		MinY = ey
		MaxY = sy
	end

	--Has to be at least 1 wide
	if MinY <= 1 then
		MinY = 1
	end
	if self.xAxis then
		local aa,bb,cc,dd,ee = self.xAxis:GetPoint()
		local xAxisAlpha = dd-self.xAxis:GetWidth()
	end
	Bar:ClearAllPoints()
	Bar:SetPoint("BOTTOMLEFT", C, "BOTTOMLEFT", sx, xAxisAlpha or 24)

	local Width = ex - sx
	if Width < 1 then
		Width = 1
	end
	Bar:SetWidth(Width)
	Bar:SetHeight(MinY-(xAxisAlpha or 24))


	if (MaxY-MinY) >= 1 then
		Tri:ClearAllPoints()
		Tri:SetPoint("BOTTOMLEFT", C, "BOTTOMLEFT", sx, MinY)
		Tri:SetWidth(Width)
		Tri:SetHeight(MaxY - MinY)
		--P:ClearAllPoints()
		--P:SetPoint("BOTTOMLEFT", C, "BOTTOMLEFT", sx, MinY)
		--P:SetWidth(Width)
		--P:SetHeight(MaxY - MinY)
	else
		Tri:Hide()
		--P:Hide()
	end
end

function lib:HideBars(C)
	if not C.GraphLib_Bars_Used then
		return
	end
	for cat, val in C.GraphLib_Bars_Used do
		val:Hide()
	end
end

function lib:HideLines(C)
	if C.GraphLib_Lines then
		for k,v in pairs(C.GraphLib_Lines) do
			v[1]:Hide()
			v[1].val = nil
			v[1].label = nil
			v[2]:Hide()
		end
	end
	
	if C.ppoints then
		for k,v in pairs(C.ppoints) do
			v:Hide()
		end
	end
end


-- Custom stacked graphs inspired by google graph stacked charts
-- Author: Tom Dymel (Shino/Geigerkind/Albea)
-- Mail: tomdymel@web.de
-- Bitbucket: bitbucket.com/tomdy
-- Credit: Old Stacked graph, whoever created it. I guess the originally author of this library
-- Recycled lots of code from him

function lib:DrawBarNew(C, sx, sy, ex, ey, color, level, label)
	local Bar, barNum, MinY, MaxY

	--Want sx <= ex if not then flip them


	if not C.GraphLib_Bars_Used then
		C.GraphLib_Bars_Used = {}
		C.GraphLib_Frames = {}
	end
	
	for k,v in pairs(C.GraphLib_Bars_Used) do
		if not v:IsShown() and not Bar then
			Bar=v;
			Bar:Show();		
		end
	end
	
	if Bar then
		Bar.label = label
	end

	if not Bar then
		-- Create Tooltip
		Bar = CreateFrame("Frame", C:GetName().."_BarTT"..(getn(C.GraphLib_Bars_Used)+1), C)
		Bar:EnableMouse(true)
		Bar.label = label
		
		Bar.Texture = Bar:CreateTexture(nil, "ARTWORK")
		Bar.Texture:SetTexture(1,1,1,1)
		
		tinsert(C.GraphLib_Bars_Used, Bar)
	end

	if level then
		if type(C.GraphLib_Frames[level]) == "nil" then
			local newLevel = 100-level
			if newLevel<0 then
				newLevel = 0
			end
			C.GraphLib_Frames[level] = CreateFrame("Frame", nil, C)
			C.GraphLib_Frames[level]:SetFrameLevel(newLevel)
			C.GraphLib_Frames[level]:SetAllPoints(C)

			if C.TextFrame and C.TextFrame:GetFrameLevel() >= newLevel then
				C.TextFrame:SetFrameLevel(newLevel - 1)
				self.NeedsUpdate = true
			end
		end

		Bar:SetParent(C.GraphLib_Frames[level])
	end

	Bar.Texture:SetVertexColor(color[1], color[2], color[3], color[4])
	
	
		MinY = ey
	
	--Has to be at least 1 wide
	if MinY <= 1 then
		MinY = 1
	end
	if self.xAxis then
		local aa,bb,cc,dd,ee = self.xAxis:GetPoint()
		local xAxisAlpha = dd-self.xAxis:GetWidth()
	end
	local Width = ex - sx
	local const = 24
	if Width < 10 then
		Width = 10
	end
	Bar:SetWidth(Width)
	Bar:SetHeight(MinY)
	
	Bar:ClearAllPoints()
	Bar:SetPoint("BOTTOMLEFT", C, "BOTTOMLEFT", sx, const)
	Bar.Texture:SetWidth(Width)
	Bar.Texture:SetHeight(MinY)
	Bar.Texture:ClearAllPoints()
	Bar.Texture:SetPoint("BOTTOMLEFT", C, "BOTTOMLEFT", sx, const)
	
	Bar:SetScript("OnEnter", function()
		if Bar.label then
			GameTooltip:SetOwner(Bar, "TOPLEFT")
			GameTooltip:AddLine(Bar.label)
			GameTooltip:Show()
		end
	end)
	Bar:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end

function GraphFunctions:RefreshStackedBarGraph()
	self:HideLines(self)
	self:HideBars(self)
	
	-- Format table
	-- Max it to 100 timestamps
	-- Issue if less than 100 => Dynamicly increase width
	local DataTable = {}
	local CAP = 100
	local space, mX, mN
	-- Step 1: Get Highest Number of Bars
	for k1, series in pairs(self.Data) do
		for c,v in series.Points do
			local num = 0
			for k2, point in pairs(v) do
				num = num + 1
				if not mX or point[1]>mX then
					mX = point[1]
				end
			end
			if not mN or num>mN then
				mN = num
			end
		end
	end
	-- Step 2: Compare with CAP and create dummy table
	if not mN then
		return
	end
	
	if mN>CAP then
		mN = CAP
	end
	space = (mX-1)/mN
	local taken = {}
	for k1, series in pairs(self.Data) do
		if not DataTable[k1] then
			DataTable[k1] = {}
			taken[k1] = {}
		end
		for c,v in series.Points do
			if not DataTable[k1][c] then
				DataTable[k1][c] = {}
				taken[k1][c] = {}
			end
			for i=1,mN do
				DataTable[k1][c][i] = {i*space+1,0}
			end
			for k2, point in pairs(v) do
				for i=1,mN do
					if point[1]>=((i-1)*space+1) and point[1]<(i*space+1) and not taken[k1][c][k2] then
						DataTable[k1][c][i] = {i*space+1, DataTable[k1][c][i][2] + point[2]}
						taken[k1][c][k2] = true
					end
				end
			end
			for k2, point in pairs(v) do
				if not taken[k1][c][k2] then
					DataTable[k1][c][mN] = {mN*space+1, DataTable[k1][c][mN][2] + point[2]}
					taken[k1][c][k2] = true
				end
			end
		end
	end
	taken = nil
	
	local Width=self:GetWidth()
	local Height=self:GetHeight()
	
	if self.AutoScale and self.Data then -- math_huge not implemented
		local MinX, MaxX, MinY, MaxY
		local temp = {}
		for k1, series in DataTable do
			for c,v in series do
				for k2, point in v do
					if temp[k2] then
						temp[k2] = temp[k2] + point[2]
					else
						temp[k2] = point[2]
					end
					if not MinX or point[1]<MinX then MinX = point[1] end
					if not MinY or temp[k2]<MinY then MinY = temp[k2] end
					if not MaxX or point[1]>MaxX then MaxX = point[1] end
					if not MaxY or temp[k2]>MaxY then MaxY = temp[k2] end
				end
			end
		end

		local XBorder, YBorder

		XBorder=(60/Width)*MaxX
		YBorder=(24/Height)*MaxY
		self.XBorder=XBorder
		self.YBorder = YBorder
		self.YGridInterval = MaxY/7
		self.XGridInterval = MaxX/7
		MinX=0+XBorder
		
		if not self.LockOnXMin then
			self.XMin=MinX-XBorder
		end
		if not self.LockOnXMax then
			self.XMax=MaxX
		end
		if not self.LockOnYMin then
			self.YMin=MinY-YBorder
		end
		if not self.LockOnYMax then
			self.YMax=MaxY+YBorder
		end
	end
	
	self:CreateGridlines()
	
	for k1, series in DataTable do
		for c,v in series do
			if v[1] then
				local LastPoint = {x=50,y=0}
				local num = getn(v)
				for i=1,num do
					local point = v[i]
					local TPoint={x=point[1];y=point[2]}
					TPoint.x=Width*(TPoint.x-self.XMin)/(self.XMax-self.XMin)
					
					if point[2]>0 then
						local label = 0
						for uu=1, (c-1) do
							if DataTable[k1][uu][i] then
								label = label + DataTable[k1][uu][i][2]
							end
						end

						TPoint.y=(Height-24)*(TPoint.y+label)/(self.YMax-self.YBorder)
						
						local CT
						if colorByAbility[self.Data[k1].Label[c]] then
							CT = colorByAbility[self.Data[k1].Label[c]]
						end
						
						if not CT and ColorTable[c] then
							CT = ColorTable[c]
						end
						
						if not ColorTable[c] and not CT then
							ColorTable[c] = {0.01*math_random(0,100),0.01*math_random(0,100),0.01*math_random(0,100),1}
							CT = ColorTable[c]
						end
						
						colorByAbility[self.Data[k1].Label[c]] = CT
						
						self:DrawBar(self, LastPoint.x, LastPoint.y, TPoint.x, TPoint.y, CT, c, self.Data[k1].Label[c]..": "..ceil(point[2] or 0))
					end
					LastPoint = {x=TPoint.x;y=TPoint.y}
				end
			end
		end
	end
end

function lib:CreateStackedGraph(name,parent,relative,relativeTo,offsetX,offsetY,Width,Height)
	local graph
	local i
	graph = CreateFrame("Frame",name,parent)

	
	graph:SetPoint(relative,parent,relativeTo,offsetX,offsetY)
	graph:SetWidth(Width)
	graph:SetHeight(Height)
	graph:Show()


	
	
	--Set the various functions
	graph.SetXAxis=GraphFunctions.SetXAxis
	graph.SetYAxis=GraphFunctions.SetYAxis
	graph.AddDataSeries=GraphFunctions.AddDataSeries
	graph.ResetData=GraphFunctions.ResetData
	graph.RefreshGraph=GraphFunctions.RefreshStackedBarGraph
	graph.CreateGridlines=GraphFunctions.CreateGridlines
	graph.SetAxisDrawing=GraphFunctions.SetAxisDrawing
	graph.SetGridSpacing=GraphFunctions.SetGridSpacing
	graph.SetAxisColor=GraphFunctions.SetAxisColor
	graph.SetGridColor=GraphFunctions.SetGridColor	
	graph.SetAutoScale=GraphFunctions.SetAutoScale
	graph.SetYLabels=GraphFunctions.SetYLabels
	graph.SetXLabels=GraphFunctions.SetXLabels
	graph.OnUpdate=GraphFunctions.OnUpdateGraph

	graph.LockXMin=GraphFunctions.LockXMin
	graph.LockXMax=GraphFunctions.LockXMax
	graph.LockYMin=GraphFunctions.LockYMin
	graph.LockYMax=GraphFunctions.LockYMax
	
	graph.FindNearValue=GraphFunctions.FindNearValue

	graph.DrawLine=self.DrawLine
	graph.DrawBar=self.DrawBarNew
	graph.HideLines=self.HideLines
	graph.HideBars=self.HideBars
	graph.HideFontStrings=GraphFunctions.HideFontStrings
	graph.FindFontString=GraphFunctions.FindFontString
	graph.ShowFontStrings=GraphFunctions.ShowFontStrings

	--Set the update function
	graph:SetScript("OnUpdate", graph.OnUpdate)
	
	graph.NeedsUpdate=false


	--Initialize Data
	graph.GraphType="STACKED_BAR"
	graph.YMax=1
	graph.YMin=0
	graph.XMax=1
	graph.XMin=0
	graph.AxisColor={1.0,1.0,1.0,1.0}
	graph.GridColor={0.5,0.5,0.5,0.5}
	graph.XGridInterval=0.25
	graph.YGridInterval=0.25
	graph.XAxisDrawn=true
	graph.YAxisDrawn=true
	
	graph.LockOnXMin=false
	graph.LockOnXMax=false
	graph.LockOnYMin=false
	graph.LockOnYMax=false
	graph.Data={}
	graph.DataPoints={}
	
	return graph
end




AceLibrary:Register(lib, major, minor)












function TestStackedGraph()
	local Graph=AceLibrary("Graph-1.0")
	local g=Graph:CreateStackedGraph("TestStackedGraph",UIParent,"CENTER","CENTER",90,90,800,350)
	
	local Data1={{{1,100},{1.2,110},{1.4,120},{1.6,130},{1.8,140},{2,150},{2.2,160},{2.4,170},{2.6,180},{2.8,190},{3,200},{3.2,190},{3.4,180},{3.6,170},{3.8,160},{4,150}},{{1,100},{1.2,110},{1.4,120},{1.6,130},{1.8,140},{2,150},{2.2,160},{2.4,170},{2.6,180},{2.8,190},{3,200},{3.2,190},{3.4,180},{3.6,170},{3.8,160},{4,150}}}
	local label = {"a", "b","c", "d","e", "f","g", "h","i", "j","k", "l","m", "n","o", "p","q", "r","s", "t","u", "v","w", "x","y", "z","", "","", "","", "","", "","", "","", "","", "","", "","", "","", "","", "","", "","", "","", "","", "","", "","", ""}
	g:SetXAxis(0,4)
	g:SetYAxis(0,500)
	g:SetGridSpacing(0.5,50)
	g:SetGridColor({0.5,0.5,0.5,0.5})
	g:SetAxisDrawing(true,true)
	g:SetAxisColor({1.0,1.0,1.0,1.0})
	g:SetAutoScale(true)
	g:SetYLabels(true, false)
	g:SetXLabels(true)
	
	g:AddDataSeries(Data1,{1.0,0.0,0.0,0.8}, {}, label)
end


--Test Functions
--To test the library do /script AceLibrary("Graph-1.0");TestGraphLib()
function TestRealtimeGraph()
	local Graph=AceLibrary("Graph-1.0")
	RealGraph=Graph:CreateGraphRealtime("TestRealtimeGraph",UIParent,"CENTER","CENTER",-90,90,150,150)
	local g=RealGraph
	g:SetAutoScale(true)
	g:SetGridSpacing(1.0,10.0)
	g:SetYMax(120)
	g:SetXAxis(-11,-1)
	g:SetFilterRadius(1)
	g:SetBarColors({0.2,0.0,0.0,0.4},{1.0,0.0,0.0,1.0})

	local f = CreateFrame("Frame",name,parent)
	f:SetScript("OnUpdate",function() g:AddTimeData(DPSMate.DB:GetAlpha()) end)
	f:Show()
end

function TestLineGraph()
	local Graph=AceLibrary("Graph-1.0")
	local g=Graph:CreateGraphLine("TestLineGraph",UIParent,"CENTER","CENTER",90,90,150,150)
	
	g:SetXAxis(-1,1)
	g:SetYAxis(-1,1)
	g:SetGridSpacing(0.25,0.25)
	g:SetGridColor({0.5,0.5,0.5,0.5})
	g:SetAxisDrawing(true,true)
	g:SetAxisColor({1.0,1.0,1.0,1.0})
	g:SetAutoScale(true)

	local Data1={{0.05,0.05},{0.2,0.3},{0.4,0.2},{0.9,0.6}}
	local Data2={{0.05,0.8},{0.3,0.1},{0.5,0.4},{0.95,0.05}}

	g:AddDataSeries(Data1,{1.0,0.0,0.0,0.8})
	g:AddDataSeries(Data2,{0.0,1.0,0.0,0.8})
end

function TestScatterPlot()
	local Graph=AceLibrary("Graph-1.0")
	local g=Graph:CreateGraphScatterPlot("TestScatterPlot",UIParent,"CENTER","CENTER",90,-90,150,150)

	g:SetXAxis(-1,1)
	g:SetYAxis(-1,1)
	g:SetGridSpacing(0.25,0.25)
	g:SetGridColor({0.5,0.5,0.5,0.5})
	g:SetAxisDrawing(true,true)
	g:SetAxisColor({1.0,1.0,1.0,1.0})
	g:SetLinearFit(true)
	g:SetAutoScale(true)

	local Data1={{0.05,0.05},{0.2,0.3},{0.4,0.2},{0.9,0.6}}
	local Data2={{0.05,0.8},{0.3,0.1},{0.5,0.4},{0.95,0.05}}

	g:AddDataSeries(Data1,{1.0,0.0,0.0,0.8})
	g:AddDataSeries(Data2,{0.0,1.0,0.0,0.8})
end

function TestPieChart()
	local Graph=AceLibrary("Graph-1.0")
	local g=Graph:CreateGraphPieChart("TestPieChart",UIParent,"CENTER","CENTER",-90,-90,150,150)

	g:AddPie(35,{1.0,0.0,0.0})
	g:AddPie(15,{0.0,1.0,0.0})	
	g:AddPie(50,{1.0,1.0,1.0})
end

function TestGraphLib()
	--TestRealtimeGraph()
	TestLineGraph()
	--TestScatterPlot()
	--TestPieChart()
end