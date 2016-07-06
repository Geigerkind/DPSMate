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

local major, minor = "Graph-1.0", "$Revision: 36224 $"

if not AceLibrary then error(major .. " requires AceLibrary.") end
if not AceLibrary:IsNewVersion(major, minor) then return end

local lib={}
local GraphFunctions={}

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

	
	graph:SetPoint(relative,parent,relativeTo,offsetX,offsetY)
	graph:SetWidth(Width)
	graph:SetHeight(Height)
	graph:Show()

	--Create the bars
	graph.Bars={}
	graph.BarNum=Width
	for i=1,Width do
		local bar
		bar = CreateFrame("StatusBar",name.."Bar"..i,graph)--graph:CreateTexture(nil,"ARTWORK")
		bar:SetPoint("BOTTOMLEFT",graph,"BOTTOMLEFT",i-1,0)
		bar:SetHeight(Height)
		bar:SetWidth(1)
		bar:SetOrientation("VERTICAL")
		bar:SetMinMaxValues(0,Height)
		bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8.blp")

		local t=bar:GetStatusBarTexture()		
		t:SetGradientAlpha("VERTICAL",0.2,0.0,0.0,0.5,1.0,0.0,0.0,1.0)
		
		bar:Show()
		table.insert(graph.Bars,bar)
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
	graph.SetFilterRadius=GraphFunctions.SetFilterRadius
	graph.SetAutoscaleYAxis=GraphFunctions.SetAutoscaleYAxis
	graph.SetBarColors=GraphFunctions.SetBarColors
	graph.SetMode=GraphFunctions.SetMode
	graph.SetAutoScale=GraphFunctions.SetAutoScale

	graph.DrawLine=self.DrawLine
	graph.HideLines=self.HideLines
	graph.HideFontStrings=GraphFunctions.HideFontStrings
	graph.FindFontString=GraphFunctions.FindFontString
	graph.ShowFontStrings=GraphFunctions.ShowFontStrings

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
	graph.AutoScale=false
	graph.Data={}

	graph.BarHeight={}
	graph.LastShift=GetTime()
	graph.BarWidth=(graph.XMax-graph.XMin)/graph.BarNum
	graph.FilterOverlap=math.max(math.ceil((graph.TimeRadius+graph.XMax)/graph.BarWidth),0)
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
	--graph.OnUpdate=GraphFunctions.PieChart_OnUpdate
	graph.SetSelectionFunc=GraphFunctions.SetSelectionFunc

	--graph:SetScript("OnUpdate", graph.OnUpdate)
	

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
-- <mail@legacy-logs.com>
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
	table.insert(self.Data,t)
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
	
	table.insert(self.Data,{Points=points;Color=color;Label=label})
	self.DataPoints = Dp
	
	self.NeedsUpdate=true
end

function GraphFunctions:ResetData()
	self.Data={}
	
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
	table.insert(self.Textures,g)
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
	table.insert(self.FontStrings,g)
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
local ColorTable={
	{0.9,0.0,0.0},
	{0.0,0.9,0.0},
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
function GraphFunctions:AddPie(Percent, Color)
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
			Color={math.random(),math.random(),math.random()}
		end
		self.onColor=self.onColor+1
	end

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
			GraphFunctions:RotateTexture(t,CurAngle)
			t:Show()

			t:SetVertexColor(Color[1],Color[2],Color[3],1.0)
			Percent=Percent-CurPiece
			PiePercent=PiePercent+CurPiece
			CurAngle=CurAngle+Angle

			table.insert(Section.Textures,t)

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
	table.insert(self.Sections,Section)
	
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
			Color={math.random(),math.random(),math.random()}
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

				table.insert(Section.Textures,t)
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
		table.insert(Section.Textures,t)
	end

	--Finish adding section data
	Section.Color=Color
	Section.Angle=360
	table.insert(self.Sections,Section)


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
	local Radian=math.pi*(90-angle)/180
	local w,h
	w=self:GetWidth()/2
	h=self:GetHeight()/2


	sx=w
	sy=h
	
	ex=sx+0.88*w*math.cos(Radian)
	ey=sx+0.88*h*math.sin(Radian)
	
	self:DrawLine(self,sx,sy,ex,ey,34,{0.0,0.0,0.0,1.0},"OVERLAY")
end

--Used to rotate the pie slices
function GraphFunctions:RotateTexture(texture,angle)
	local Radian=math.pi*(45-angle)/180
	local Radian2=math.pi*(45+90-angle)/180
	local Radius=0.70710678118654752440084436210485

	local tx,ty,tx2,ty2
	tx=Radius*math.cos(Radian)
	ty=Radius*math.sin(Radian)
	tx2=-ty
	ty2=tx

	texture:SetTexCoord(0.5-tx,0.5-ty,0.5+tx2,0.5+ty2,0.5-tx2,0.5-ty2,0.5+tx,0.5+ty)
end

function GraphFunctions:SetSelectionFunc(f)
	self.SelectionFunc=f
end

--TODO: Pie chart pieces need to be clickable
function GraphFunctions:PieChart_OnUpdate()
	if (MouseIsOver(self)) then
		local sX,sY=self:GetCenter()
		local Scale=self:GetEffectiveScale()
		local mX,mY=GetCursorPosition()
		local dX,dY

		dX=mX/Scale-sX
		dY=mY/Scale-sY

		local Angle=90-math.deg(math.atan(dY/dX))
		dY=dY*self.Ratio
		local Dist=dX*dX+dY*dY

		if dX<0 then
			Angle=Angle+180
		end

		--Are we on the Pie Chart?
		if Dist<self.Radius then
			--What section are we on?
			for k, v in pairs(self.Sections) do
				if Angle<v.Angle then
					local Color
					if k~=self.LastSection then
						if self.LastSection then
							local Section=self.Sections[self.LastSection]
							for _, t in pairs(Section.Textures) do
								Color=Section.Color
								t:SetVertexColor(Color[1],Color[2],Color[3],1.0)
							end
						end

						if self.SelectionFunc then
							self:SelectionFunc(k)
						end
					end

					local ColorAdd=0.15*math.abs(math.fmod(GetTime(),3)-1.5)-0.1125
					
					Color={}
					Color[1]=v.Color[1]+ColorAdd
					Color[2]=v.Color[2]+ColorAdd
					Color[3]=v.Color[3]+ColorAdd

					for _, t in pairs(v.Textures) do
						t:SetVertexColor(Color[1],Color[2],Color[3],1.0)
					end

					self.LastSection = k

					return
				end
			end
		end
	else
		if self.LastSection then
			local Section=self.Sections[self.LastSection]
			for _, t in pairs(Section.Textures) do
				local Color=Section.Color
				t:SetVertexColor(Color[1],Color[2],Color[3],1.0)
			end
			self.LastSection=nil
		end
		if self.SelectionFunc then
			self:SelectionFunc(k)
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
		self.FilterOverlap=math.max(math.ceil((self.TimeRadius+xmax)/self.BarWidth),0)
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
		LowerYGridLine=math.max(math.floor(LowerYGridLine),math.ceil(LowerYGridLine))
		UpperYGridLine=self.YMax/self.YGridInterval
		UpperYGridLine=math.min(math.floor(UpperYGridLine),math.ceil(UpperYGridLine))
		TopSpace=Height*(1-(UpperYGridLine*self.YGridInterval-self.YMin)/(self.YMax-self.YMin))
		
		local alpha = 0
		for i=LowerYGridLine,UpperYGridLine do
			if i~=0 or not self.YAxisDrawn then
				local YPos,T,F
				YPos=Height*(i*self.YGridInterval-self.YMin)/(self.YMax-self.YMin)
				T=self:DrawLine(self,0,YPos,Width,YPos,24,self.GridColor,"BACKGROUND")
				if (((i~=UpperYGridLine) or (TopSpace>12))) and alpha==ceil(((UpperYGridLine-LowerYGridLine)/5)) then
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

	if self.XGridInterval then
		local LowerXGridLine,UpperXGridLine
		LowerXGridLine=self.XMin/self.XGridInterval
		LowerXGridLine=math.max(math.floor(LowerXGridLine),math.ceil(LowerXGridLine))
		UpperXGridLine=self.XMax/self.XGridInterval
		UpperXGridLine=math.min(math.floor(UpperXGridLine),math.ceil(UpperXGridLine))

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
	
	--Slow Mode performs an entire convolution every frame
	if self.Mode=="SLOW" then
		--Initialize Bar Data
		self.BarHeight={}
		for i=1,self.BarNum do
			self.BarHeight[i]=0
		end
		local k,v
		local BarTimeRadius=(self.XMax-self.XMin)/self.BarNum
		local DataValue=1/(2*self.TimeRadius)

		if self.Filter=="RECT" then
			--Take the convolution of the dataset on to the bars wtih a rectangular filter
			local DataValue=1/(2*self.TimeRadius)
			for k,v in pairs(self.Data) do
				if v.Time<(CurTime+self.XMin-self.TimeRadius) then
					table.remove(self.Data,k)	
				else	
					local DataTime=v.Time-CurTime
					local LowestBar=math.max(math.floor((DataTime-self.XMin-self.TimeRadius)/BarTimeRadius),1)
					local HighestBar=math.min(math.ceil((DataTime-self.XMin+self.TimeRadius)/BarTimeRadius),self.BarNum)
					for i=LowestBar,HighestBar do
						self.BarHeight[i]=self.BarHeight[i]+v.Value*DataValue
					end
				end
			end
		elseif self.Filter=="TRI" then
			--Needs optimization badly
			--Take the convolution of the dataset on to the bars wtih a triangular filter
			local DataValue=1/(self.TimeRadius)
			for k,v in pairs(self.Data) do
				local Temp
				if v.Time<(CurTime+self.XMin-self.TimeRadius) then
					table.remove(self.Data,k)	
				else	
					local DataTime=v.Time-CurTime
					local LowestBar=math.max(math.floor((DataTime-self.XMin-self.TimeRadius)/BarTimeRadius),1)
					local HighestBar=math.min(math.ceil((DataTime-self.XMin+self.TimeRadius)/BarTimeRadius),self.BarNum)


					for i=LowestBar,HighestBar do
						self.BarHeight[i]=self.BarHeight[i]+v.Value*DataValue*math.abs(BarTimeRadius*i+self.XMin-DataTime)
					end
				end
			end
		end
	elseif self.Mode=="FAST" then
		local ShiftBars=math.floor((CurTime-self.LastShift)/self.BarWidth)
		local RecalcBars=self.BarNum-(ShiftBars+self.FilterOverlap)+1

		for i=1,self.BarNum do
			if i<RecalcBars then
				self.BarHeight[i]=self.BarHeight[i+ShiftBars]
			else
				self.BarHeight[i]=0
			end
		end

		local k,v
		local BarTimeRadius=(self.XMax-self.XMin)/self.BarNum
		local DataValue=1/(2*self.TimeRadius)

		CurTime=self.LastShift+ShiftBars*self.BarWidth
		self.LastShift=CurTime

		if self.Filter=="RECT" then
			--Take the convolution of the dataset on to the bars wtih a rectangular filter
			local DataValue=1/(2*self.TimeRadius)
			for k,v in pairs(self.Data) do
				if v.Time<(CurTime+self.XMin-self.TimeRadius) then
					table.remove(self.Data,k)	
				else	
					local DataTime=v.Time-CurTime
					local LowestBar=math.max(math.max(math.floor((DataTime-self.XMin-self.TimeRadius)/BarTimeRadius),RecalcBars),1)
					local HighestBar=math.min(math.ceil((DataTime-self.XMin+self.TimeRadius)/BarTimeRadius),self.BarNum)
					if LowestBar<=HighestBar then
						for i=LowestBar,HighestBar do
							self.BarHeight[i]=self.BarHeight[i]+v.Value*DataValue
						end
					end
				end
			end
		end
	end

	if self.AutoScale then
		local MaxY=0

		for i=1,self.BarNum do
			MaxY=math.max(MaxY,self.BarHeight[i])
		end
		MaxY=1.25*MaxY
		
		if MaxY~=0 and math.abs((self.YMax-MaxY)/(2*(self.YMax+MaxY)))>0.01 then
			self.YMax=MaxY
			if self.RefreshGraph then
				self:RefreshGraph()
			end
		end
	end
	for i,bar in pairs(self.Bars) do
		local h
		h=math.max(math.min(MaxBarHeight*(self.BarHeight[i]-self.YMin)/(self.YMax-self.YMin),MaxBarHeight),0)
		
		if h~=0 then
			bar:SetValue(h)
			bar:Show()
		else
			bar:Hide()
		end
	end
end

--Line Graph
function GraphFunctions:RefreshLineGraph()
	local k1, k2, series
	self:HideLines(self)
	
	if self.AutoScale and self.Data then -- math.huge not implemented
		local MinX, MaxX, MinY, MaxY = 1, -3, 200, -900
		for k1, series in pairs(self.Data) do
			for k2, point in pairs(series.Points) do
				MinX=math.min(point[1],MinX)
				MaxX=math.max(point[1],MaxX)
				MinY=math.min(point[2],MinY)
				MaxY=math.max(point[2],MaxY)
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
		local LastPoint
		LastPoint=nil

		for k2, point in pairs(series.Points) do
			if LastPoint then
				local TPoint={x=point[1];y=point[2]}

				TPoint.x=Width*(TPoint.x-self.XMin)/(self.XMax-self.XMin)
				TPoint.y=Height*(TPoint.y-self.YMin)/(self.YMax-self.YMin)
				
				if point[3] then
					self:DrawLine(self,LastPoint.x,LastPoint.y,TPoint.x,TPoint.y,32,series.Color[2],nil,point)
				else
					self:DrawLine(self,LastPoint.x,LastPoint.y,TPoint.x,TPoint.y,32,series.Color[1],nil,point)
				end

				LastPoint=TPoint
			else
				LastPoint={x=point[1];y=point[2]}
				LastPoint.x=Width*(LastPoint.x-self.XMin)/(self.XMax-self.XMin)
				LastPoint.y=Height*(LastPoint.y-self.YMin)/(self.YMax-self.YMin)
			end
		end
	end
	
	self.ppoints = {}
	if self.DataPoints[1] then
		for k3, p2 in pairs(self.DataPoints[2]) do
			-- Needs fine tuning
			local PPoint = self:CreateTexture()
			PPoint:SetTexture("Interface\\AddOns\\!ShinoUI\\modules\\modmaps\\blips\\party") -- Adjust path later
			local PPLastPointX = Width*(p2[2][1]-self.XMin)/(self.XMax-self.XMin)
			local PPLastPointY = Height*(p2[2][2]-self.YMin)/(self.YMax-self.YMin)
			local PPNextPointX = Width*(p2[3][1]-self.XMin)/(self.XMax-self.XMin)
			local PPNextPointY = Height*(p2[3][2]-self.YMin)/(self.YMax-self.YMin)
			local pointx = Width*(p2[1]-self.XMin)/(self.XMax-self.XMin)
			local pointy = PPLastPointY + (pointx-PPLastPointX)*((PPNextPointY-PPLastPointY)/(PPNextPointX-PPLastPointX))
			PPoint:SetPoint("LEFT", self.yAxis, "LEFT", pointx-5, pointy-22)
			PPoint:SetHeight(20)
			PPoint:SetWidth(20)
			table.insert(self.ppoints, PPoint)
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
		local MinX, MaxX, MinY, MaxY = math.huge, -math.huge, math.huge, -math.huge
		for k1, series in pairs(self.Data) do
			for k2, point in pairs(series.Points) do
				MinX=math.min(point[1],MinX)
				MaxX=math.max(point[1],MaxX)
				MinY=math.min(point[2],MinY)
				MaxY=math.max(point[2],MaxY)
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
			MinX=math.min(point[1],MinX)
			MaxX=math.max(point[1],MaxX)
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

-- Stacked Graph
function GraphFunctions:RefreshStackedGraph()
	self:HideLines(self)
	self:HideBars(self)
	
	-- Format table
	for k1, series in pairs(self.Data) do
		local p = {}
		for c,v in pairs(series.Points) do
			for k2, point in pairs(v) do
				point[1] = tonumber(string.format("%.1f",point[1]))
				if p[point[1]] then
					p[point[1]] = p[point[1]] + point[2]
					point[2] = p[point[1]]
				else
					p[point[1]] = point[2]
				end
			end
		end
	end
	
	if self.AutoScale and self.Data then -- math.huge not implemented
		local MinX, MaxX, MinY, MaxY = 1, -3, 200, -900
		for k1, series in pairs(self.Data) do
			for c,v in series.Points do
				for k2, point in v do
					MinX=math.min(point[1],MinX)
					MaxX=math.max(point[1],MaxX)
					MinY=math.min(point[2],MinY)
					MaxY=math.max(point[2],MaxY)
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
					
					self:DrawLine(self,LastPoint.x,LastPoint.y,TPoint.x,TPoint.y,32,ColorTable[c],nil,point,series.Label[c])
					local alphaX = (TPoint.x-LastPoint.x)/1
					local alphaY = (TPoint.y-LastPoint.y)/1
					local alphaLastX, alphaLastY
					for i=1, 1 do
						self:DrawBar(self, alphaLastX or LastPoint.x, alphaLastY or LastPoint.y, LastPoint.x+alphaX*i, LastPoint.y+alphaY*i, ColorTable[c], c, series.Label[c])
						alphaLastX = LastPoint.x+alphaX*i
						alphaLastY = LastPoint.y+alphaY*i
					end

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
function lib:DrawLine(C, sx, sy, ex, ey, w, color, layer, point, label)
	local T, lineNum, relPoint, P;
	if (not relPoint) then relPoint = "BOTTOMLEFT"; end


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
	
	if point and T then
		T.val = ceil(point[2])
	end
	if label and T then
		T.label = label
	end

	if not T then
		P = CreateFrame("Frame", C:GetName().."_LineTT"..(getn(C.GraphLib_Lines)+1), C)
		P:SetHeight(10)
		P:SetWidth(10)
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
	T:SetPoint("BOTTOMLEFT", C, relPoint, cx - Bwid, cy - Bhgt);
	T:SetPoint("TOPRIGHT",	C, relPoint, cx + Bwid, cy + Bhgt);
	P:ClearAllPoints();
	--P:SetPoint("BOTTOMLEFT", C, relPoint, cx - Bwid, cy - Bhgt);
	P:SetPoint("TOPRIGHT",	C, relPoint, cx + Bwid -10, cy + Bhgt);

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
	if not C.GraphLib_Bars then
		return
	end
	for cat, val in C.GraphLib_Bars do
		val:Hide()
		
		C.GraphLib_Tris[cat]:Hide()
	end
	for cat, val in C.GraphLib_Bars_Used do
		val[1]:Hide()
	end
	for cat, val in C.GraphLib_Tris_Used do
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
	
	if not C.ppoints then
		return
	end

	for k,v in pairs(C.ppoints) do
		v:Hide()
	end
end











AceLibrary:Register(lib, major, minor)












function TestStackedGraph()
	local Graph=AceLibrary("Graph-1.0")
	local g=Graph:CreateStackedGraph("TestStackedGraph",UIParent,"CENTER","CENTER",90,90,800,350)
	
	--local Data1={{{1,100},{1.2,110},{1.4,120},{1.6,130},{1.8,140},{2,150},{2.2,160},{2.4,170},{2.6,180},{2.8,190},{3,200},{3.2,190},{3.4,180},{3.6,170},{3.8,160},{4,150}},{{1,100},{1.2,110},{1.4,120},{1.6,130},{1.8,140},{2,150},{2.2,160},{2.4,170},{2.6,180},{2.8,190},{3,200},{3.2,190},{3.4,180},{3.6,170},{3.8,160},{4,150}}}
	local Data1 = {}
	local label = {}
	local b = {}
	for cat, val in DPSMateDamageDone[1][DPSMateUser["Shino"][1]] do
		if cat~="i" and val["i"] then
			local temp = {}
			for c, v in val["i"] do
				local i = 1
				while true do
					if not temp[i] then
						table.insert(temp, i, {c,v})
						break
					elseif c<=temp[i][1] then
						table.insert(temp, i, {c,v})
						break
					end
					i = i + 1
				end
			end
			local i = 1
			while true do
				if not b[i] then
					table.insert(b, i, val[13])
					table.insert(label, i, DPSMate:GetAbilityById(cat))
					table.insert(Data1, i, temp)
					break
				elseif b[i]>=val[13] then
					table.insert(b, i, val[13])
					table.insert(label, i, DPSMate:GetAbilityById(cat))
					table.insert(Data1, i, temp)
					break
				end
				i = i + 1
			end
		end
	end
	-- Fill zero numbers
	for cat, val in Data1 do
		local alpha = 0
		for ca, va in pairs(val) do
			if alpha == 0 then
				alpha = va[1]
			else
				if (va[1]-alpha)>5 then
					table.insert(Data1[cat], ca, {alpha+3, 0})
					table.insert(Data1[cat], ca+1, {va[1]-1, 0})
				end
				alpha = va[1]
			end
		end
	end
	
	g:SetXAxis(0,300)
	g:SetYAxis(0,4500)
	g:SetGridSpacing(100,100)
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