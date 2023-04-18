local RS = game:GetService("ReplicatedStorage")
local eggInfoRF = RS:WaitForChild("EggRemotes"):WaitForChild("getEggInfo")
local RS = game:GetService("ReplicatedStorage")
local openValidationRF = RS:WaitForChild("EggRemotes"):WaitForChild("openValidation")
local TS = game:GetService("TweenService")
local eggHatchingSystemUI = script.Parent:WaitForChild("EggHatchingSystem")
local Module3d = require(RS:WaitForChild("Module3D"))
local cameraEggHatchingPos = workspace.EggHatchingPos
local player = game.Players.LocalPlayer
local errorMsgFrame = script.Parent:WaitForChild("ErrorUI").ErrorFrame

local runService = game:GetService("RunService")

local camera = workspace.CurrentCamera

local eggInfo

local isHatching = false

local hatchOneConnection = nil

local function addCamera(child, petName, egg)
	if child then
		if child:IsA("ViewportFrame") then
			repeat wait() until child.Name ~= "Sample"
			local pets = RS:WaitForChild("Pets")
			local item = pets:FindFirstChild(egg):FindFirstChild(petName)

			if item then
				local newItem = item:Clone()
				local viewPortCamera = Instance.new("Camera", child)
				viewPortCamera.CameraType = Enum.CameraType.Scriptable

				local YInteger = .15
				local xInteger = 2



				local viewPortPoint = Vector3.new(0,0,0)

				local viewPortFrame = child

				viewPortFrame.LightDirection = Vector3.new(0,1,0)

				viewPortFrame.Ambient = Color3.fromRGB(255,255,255)

				viewPortFrame.CurrentCamera = viewPortCamera

				newItem:SetPrimaryPartCFrame(CFrame.new(viewPortPoint))

				newItem.Parent = viewPortCamera

				local cfrane, size = newItem:GetBoundingBox()
				local max = math.max(size.x, size.y, size.z)
				local distance = (max/math.tan(math.rad(viewPortCamera.FieldOfView))) * xInteger
				local currentDistance = (max/2) + distance

				viewPortCamera.CFrame = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(viewPortPoint + Vector3.new(0, (currentDistance*YInteger), currentDistance, viewPortPoint))
			end
		end
	end
end

local function loadEggUI()
	for _, v in ipairs(script.Parent.BillboardUI:GetChildren()) do	
		if v:IsA("BillboardGui") and v.Name:match("Egg") then
			local eggName = v.Name
			local eggsInfo, isLuckGamepassOwned = eggInfoRF:InvokeServer()
			repeat wait() until eggsInfo ~= nil
			eggInfo = eggsInfo[eggName]
			for i, viewPort in ipairs(v.Frame.Frame:GetChildren()) do
				if viewPort:IsA("ViewportFrame") then

					local petName = eggInfo[viewPort.Name]["Name"]
					addCamera(viewPort, petName, eggName)
					if isLuckGamepassOwned == true then
						local x5GamepassRarity = eggInfo[viewPort.Name]["x5GamepassRarity"]
						viewPort.Rarity.Text = tostring(x5GamepassRarity).."%"
					else
						local baseRarity = eggInfo[viewPort.Name]["BaseRarity"]
						viewPort.Rarity.Text = tostring(baseRarity).."%"
					end
				end
			end
		end
	end
end



local luckGamePassBoughtRE = RS:WaitForChild("InventoryRemotes"):WaitForChild("luckGamePassBoughtRE")
luckGamePassBoughtRE.OnClientEvent:Connect(function()
	loadEggUI()
end)

--------------------

local function hatchOne(chosenPet, egg, autoOpen)
	for _, v in ipairs(script.Parent:GetChildren()) do
		if v.Name ~= "EggHatchingSystem" and v:IsA("ScreenGui") then
			v.Enabled = false
		end
	end
	
	local petToDisplay = RS:WaitForChild("Pets")[egg]:FindFirstChild(chosenPet):Clone()
	isHatching = true
	local cam = workspace.CurrentCamera
	cam.CameraType = "Scriptable"
	cam.CFrame = cameraEggHatchingPos.CFrame
	local eggModel = workspace.Eggs[egg].Egg:Clone()
	hatchOneConnection = runService.RenderStepped:Connect(function()
		local cf = CFrame.new(0,0,-eggModel.PrimaryPart.Size.Z * 2) * CFrame.Angles(0, 0, math.sin(time() * 22)/2.3)
		eggModel:SetPrimaryPartCFrame(camera.CFrame * cf)
	end)
	eggModel.Parent = camera
	wait(2)
	for _, v in ipairs(eggModel:GetChildren()) do
		if v:IsA("BasePart") then
			TS:Create(v, TweenInfo.new(.5), {Transparency = 1}):Play()
		end
	end
	wait(.5)
	hatchOneConnection:Disconnect()
	eggModel:Destroy()
	eggHatchingSystemUI.PetDisplay.Visible = true

	local petModel = Module3d:Attach3D(eggHatchingSystemUI.PetDisplay, petToDisplay)
	petModel:SetDepthMultiplier(1.7)
	petModel.Camera.FieldOfView = 5
	petModel.Visible = true
	
	runService.RenderStepped:Connect(function()
		petModel:SetCFrame(CFrame.Angles(0, tick() * 2 % (math.pi * 2),0) * CFrame.Angles(math.rad(-10),0,0))
	end)
	wait(3)
	TS:Create(eggHatchingSystemUI.PetDisplay:FindFirstChildOfClass("ViewportFrame"), TweenInfo.new(.5),{ImageTransparency = 1}):Play()
	wait(1)
	for _, v in ipairs(eggHatchingSystemUI.PetDisplay:GetDescendants()) do
		if v:IsA("ViewportFrame") then
			v:Destroy()
		end
	end
	eggHatchingSystemUI.PetDisplay.Visible = false
	if autoOpen == nil then
		cam.CameraType = "Custom"
		cam.CameraSubject = player.Character.Humanoid
		for _, v in ipairs(script.Parent:GetChildren()) do
			if v.Name ~= "EggHatchingSystem" and v:IsA("ScreenGui") then
				v.Enabled = true
			end
		end
		script.Parent:WaitForChild("HPandXPtrackers").Enabled = true
	end	
	isHatching = false
end

local function tripleHatch(petName1, petName2, petName3, egg, autoOpen)
	for _, v in ipairs(script.Parent:GetChildren()) do
		if v.Name ~= "EggHatchingSystem" and v:IsA("ScreenGui") then
			v.Enabled = false
		end
	end
	local pet1 = RS:WaitForChild("Pets")[egg]:FindFirstChild(petName1):Clone()
	local pet2 = RS:WaitForChild("Pets")[egg]:FindFirstChild(petName2):Clone()
	local pet3 = RS:WaitForChild("Pets")[egg]:FindFirstChild(petName3):Clone()
	isHatching = true
	local cam = workspace.CurrentCamera
	cam.CameraType = "Scriptable"
	cam.CFrame = cameraEggHatchingPos.CFrame
	local eggModel1 = workspace.Eggs[egg].Egg:Clone()
	local eggModel2 = workspace.Eggs[egg].Egg:Clone()
	local eggModel3 = workspace.Eggs[egg].Egg:Clone()
	hatchOneConnection = runService.RenderStepped:Connect(function()
		local cf1 = CFrame.new(0,0,-eggModel1.PrimaryPart.Size.Z * 2) * CFrame.Angles(0, 0, math.sin(time() * 22)/2.3)
		local cf2 = CFrame.new(6,0,-eggModel2.PrimaryPart.Size.Z * 2) * CFrame.Angles(0, 0, math.sin(time() * 22)/2.3)
		local cf3 = CFrame.new(-6,0,-eggModel3.PrimaryPart.Size.Z * 2) * CFrame.Angles(0, 0, math.sin(time() * 22)/2.3)
		eggModel1:SetPrimaryPartCFrame(camera.CFrame * cf1)
		eggModel2:SetPrimaryPartCFrame(camera.CFrame * cf2)
		eggModel3:SetPrimaryPartCFrame(camera.CFrame * cf3)
	end)
	eggModel1.Parent = camera
	eggModel2.Parent = camera
	eggModel3.Parent = camera
	wait(2)
	for _, v in ipairs(eggModel1:GetChildren()) do
		if v:IsA("BasePart") then
			TS:Create(v, TweenInfo.new(.5), {Transparency = 1}):Play()
		end
	end
	for _, v in ipairs(eggModel2:GetChildren()) do
		if v:IsA("BasePart") then
			TS:Create(v, TweenInfo.new(.5), {Transparency = 1}):Play()
		end
	end
	for _, v in ipairs(eggModel3:GetChildren()) do
		if v:IsA("BasePart") then
			TS:Create(v, TweenInfo.new(.5), {Transparency = 1}):Play()
		end
	end
	wait(.5)
	hatchOneConnection:Disconnect()
	eggModel1:Destroy()
	eggModel2:Destroy()
	eggModel3:Destroy()
	eggHatchingSystemUI.PetDisplay.Visible = true
	eggHatchingSystemUI.PetDisplay2.Visible = true
	eggHatchingSystemUI.PetDisplay3.Visible = true
	
	local petModel1 = Module3d:Attach3D(eggHatchingSystemUI.PetDisplay, pet1)
	petModel1:SetDepthMultiplier(1.7)
	petModel1.Camera.FieldOfView = 5
	petModel1.Visible = true
	
	local petModel2 = Module3d:Attach3D(eggHatchingSystemUI.PetDisplay2, pet2)
	petModel2:SetDepthMultiplier(1.7)
	petModel2.Camera.FieldOfView = 5
	petModel2.Visible = true
	
	local petModel3 = Module3d:Attach3D(eggHatchingSystemUI.PetDisplay3, pet3)
	petModel3:SetDepthMultiplier(1.7)
	petModel3.Camera.FieldOfView = 5
	petModel3.Visible = true

	runService.RenderStepped:Connect(function()
		petModel1:SetCFrame(CFrame.Angles(0, tick() * 2 % (math.pi * 2),0) * CFrame.Angles(math.rad(-10),0,0))
		petModel2:SetCFrame(CFrame.Angles(0, tick() * 2 % (math.pi * 2),0) * CFrame.Angles(math.rad(-10),0,0))
		petModel3:SetCFrame(CFrame.Angles(0, tick() * 2 % (math.pi * 2),0) * CFrame.Angles(math.rad(-10),0,0))
	end)
	wait(3)
	TS:Create(eggHatchingSystemUI.PetDisplay:FindFirstChildOfClass("ViewportFrame"), TweenInfo.new(.5),{ImageTransparency = 1}):Play()
	TS:Create(eggHatchingSystemUI.PetDisplay2:FindFirstChildOfClass("ViewportFrame"), TweenInfo.new(.5),{ImageTransparency = 1}):Play()
	TS:Create(eggHatchingSystemUI.PetDisplay3:FindFirstChildOfClass("ViewportFrame"), TweenInfo.new(.5),{ImageTransparency = 1}):Play()
	wait(1)
	for _, v in ipairs(eggHatchingSystemUI.PetDisplay:GetDescendants()) do
		if v:IsA("ViewportFrame") then
			v:Destroy()
		end
	end
	for _, v in ipairs(eggHatchingSystemUI.PetDisplay2:GetDescendants()) do
		if v:IsA("ViewportFrame") then
			v:Destroy()
		end
	end
	for _, v in ipairs(eggHatchingSystemUI.PetDisplay3:GetDescendants()) do
		if v:IsA("ViewportFrame") then
			v:Destroy()
		end
	end
	eggHatchingSystemUI.PetDisplay.Visible = false
	eggHatchingSystemUI.PetDisplay2.Visible = false
	eggHatchingSystemUI.PetDisplay3.Visible = false
	if autoOpen == nil then
		cam.CameraType = "Custom"
		cam.CameraSubject = player.Character.Humanoid
		for _, v in ipairs(script.Parent:GetChildren()) do
			if v.Name ~= "EggHatchingSystem" and v:IsA("ScreenGui") then
				v.Enabled = true
			end
		end
		script.Parent:WaitForChild("HPandXPtrackers").Enabled = true
	end
	isHatching = false
end

local function onMouseClick(button)
	if isHatching == false then
		local buttonName = button.Name
		local eggName = button.Parent.Name
		if buttonName ~= "AutoOpen" then
			local canPlrOpen, chosenPet, errorMessage = openValidationRF:InvokeServer(buttonName, eggName)
			if canPlrOpen == true then
				if chosenPet ~= nil then
					if buttonName == "Open1" then
						hatchOne(chosenPet[1], eggName)
					elseif buttonName == "Open3" then
						tripleHatch(chosenPet[1], chosenPet[2], chosenPet[3], eggName)	
					end
				end
			else
				errorMsgFrame.ErrorText.Text = errorMessage
				errorMsgFrame.Visible = true
				wait(1)
				errorMsgFrame.Visible = false
			end
		else
			local stopButtonPressed = false
			local stopButton = eggHatchingSystemUI.StopButton
			while stopButtonPressed == false do
				if isHatching == false then
					
					local canPlrOpen, chosenPet, errorMessage, ownsOpen3Gamepass = openValidationRF:InvokeServer(buttonName, eggName)
					if canPlrOpen == true then
						if chosenPet ~= nil then
							isHatching = true
							stopButton.Visible = true

							stopButton.MouseButton1Up:Connect(function()
								stopButtonPressed = true
								stopButton.Visible = false
								if isHatching == true then
									repeat wait() until isHatching == false
									local cam = workspace.CurrentCamera
									cam.CameraType = "Scriptable"
									cam.CameraType = "Custom"
									cam.CameraSubject = player.Character.Humanoid
									for _, v in ipairs(script.Parent:GetChildren()) do
										if v.Name ~= "EggHatchingSystem" and v:IsA("ScreenGui") then
											v.Enabled = true
										end
									end
									script.Parent:WaitForChild("HPandXPtrackers").Enabled = true
								end												
							end)
							if ownsOpen3Gamepass == false then
								hatchOne(chosenPet[1], eggName, true)
							else
								tripleHatch(chosenPet[1], chosenPet[2], chosenPet[3], eggName, true)
							end

							wait()
						end
					else
						stopButtonPressed = true
						stopButton.Visible = false
							local cam = workspace.CurrentCamera
							cam.CameraType = "Scriptable"
							cam.CameraType = "Custom"
							cam.CameraSubject = player.Character.Humanoid
							for _, v in ipairs(script.Parent:GetChildren()) do
								if v.Name ~= "EggHatchingSystem" and v:IsA("ScreenGui") then
									v.Enabled = true
								end
							end
							script.Parent:WaitForChild("HPandXPtrackers").Enabled = true
						
						errorMsgFrame.ErrorText.Text = errorMessage
						errorMsgFrame.Visible = true
						wait(1)
						errorMsgFrame.Visible = false
					end
				end
			end
			stopButtonPressed = false
		end
	end
end


for _, v in ipairs(script.Parent:WaitForChild("BillboardUI"):GetDescendants()) do
	if v:IsA("TextButton") then
		if v.Parent.Name ~= "DonationBillboardGui" then
			v.MouseButton1Up:Connect(function()
				onMouseClick(v)
			end)
		end		
	end
end

repeat wait() until game:GetService("ContentProvider").RequestQueueSize == 0
loadEggUI()

