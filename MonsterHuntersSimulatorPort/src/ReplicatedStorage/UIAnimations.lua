local TS = game:GetService("TweenService")

--//Settings
local mouseEnterSize = 1.1
local mouseEnterDuration = .2
local clickSize = 1.2
local mouseClickDuration = .2

local module = {}

local OriginalSizes = {}

local function OnMouseEnter(button, originalSize)
	local hoverSize = UDim2.new(
		originalSize.X.Scale*mouseEnterSize,
		0,
		originalSize.Y.Scale*mouseEnterSize,
		0
	)
	button:TweenSize(hoverSize, "Out", "Sine", mouseEnterDuration, true)
end

local function onMouseLeave(button, originalSize)
	
	button:TweenSize(originalSize, "Out", "Sine", mouseEnterDuration, true)
end

local function onMouseClick(button, originalSize)
	local click_Size = UDim2.new(
		originalSize.X.Scale/clickSize,
		0,
		originalSize.Y.Scale/clickSize,
		0
	)
	
	button:TweenSize(click_Size, "Out", "Sine", mouseClickDuration, true)
end

function module.SetUp(button)
	if not table.find(OriginalSizes, button) then
		OriginalSizes[button] = button.Size
	end
	
	local Main_Size = OriginalSizes[button]
	
	button.MouseEnter:Connect(function()
		OnMouseEnter(button, Main_Size)
	end)
	
	button.MouseLeave:Connect(function()
		onMouseLeave(button, Main_Size)
	end)
	
	button.MouseButton1Down:Connect(function()
		onMouseClick(button, Main_Size)
	end)
	
	button.MouseButton1Up:Connect(function()
		onMouseLeave(button, Main_Size)
	end)
end

return module
