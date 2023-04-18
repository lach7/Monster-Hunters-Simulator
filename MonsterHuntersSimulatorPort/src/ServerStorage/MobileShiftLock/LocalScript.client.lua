local UIS = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = script.Parent
local mainFrame = screenGui:WaitForChild("Frame")
local controllerButton = mainFrame:WaitForChild("Controller"):WaitForChild("ImageButton")
local middleIconFrame = mainFrame:WaitForChild("MiddleIcon")

local active = false

if UIS.TouchEnabled == true then
	mainFrame.Visible = true
	
	controllerButton.MouseButton1Up:Connect(function()
		active = not active
		middleIconFrame.Visible = active
	end)
	
	local function mobileShiftLock()
		if active == true then
			local char = player.Character
			if char ~= nil then
				local head = char:FindFirstChild("Head")
				local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
				local humanoid = char:FindFirstChild("Humanoid")
				
				local camera = workspace.CurrentCamera
				if humanoidRootPart ~= nil and humanoid.Sit == false then
					local LookVector = camera.CFrame.LookVector
					humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position) * CFrame.Angles(0, math.atan2(-LookVector.X, -LookVector.Z), 0)
				end
				if head ~= nil then
					local InFirstPerson = (camera.Focus.p - camera.CoordinateFrame.p).Magnitude
					InFirstPerson = (InFirstPerson<2) and (1.0-(InFirstPerson-0.5)/1.5) or 0
					if InFirstPerson < 0.5 then
						camera.CFrame = camera.CFrame * CFrame.new(1.75,0,0)
					end
				end
			end
		end
	end
	runService:BindToRenderStep("mobileShiftLock", 201, mobileShiftLock)
end
