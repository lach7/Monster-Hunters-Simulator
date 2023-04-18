local icons = script.Parent.Parent.Parent:WaitForChild("DefaultIcons"):WaitForChild("Frame")
local openButton = icons.Captures
local capturesFr = script.Parent
local otherMenuInteractives = script.Parent.Parent:GetChildren()
local exitButton = capturesFr.Exit
local RS = game:GetService("ReplicatedStorage")
local getCapturesInfoRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("getCapturesInfoRF")
local player = game.Players.LocalPlayer
local sample = script.Parent.Background.Sample
local convertShortModule = require(RS:WaitForChild("Data"):WaitForChild("ConvertShortModule"))
local capturesFolder = RS:WaitForChild("BossModels")
local Module3d = require(RS:WaitForChild('Module3D'))
local errorMessageFrame = game.Players.LocalPlayer.PlayerGui:WaitForChild("ErrorUI").ErrorFrame
local equipCaptureRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("equipCaptureRF")
local runService = game:GetService("RunService")

local function loadCaptures()
	local capturesInfo, plrCapturesEquipped, plrCapturesUnequipped = getCapturesInfoRF:InvokeServer()
	local plrData = getCapturesInfoRF:InvokeServer(player)
	
	for _, v in ipairs(script.Parent.Background.ScrollingFrame:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end
	
	-- Create a table of gun names
	local captures_names = {}
	for name, gun in pairs(capturesInfo) do
		table.insert(captures_names, name)
	end

	-- Define a comparison function that sorts guns by their price
	local function compare_captures_by_wave(capture_name1, capture_name2)
		return capturesInfo[capture_name1]["WaveToBeat"] < capturesInfo[capture_name2]["WaveToBeat"]
	end

	-- Sort the gun names by price
	table.sort(captures_names, compare_captures_by_wave)
	
	for _, v in pairs(captures_names) do
		local newCaptureFrame = sample:Clone()
		newCaptureFrame.Name = capturesInfo[v]["Name"]
		newCaptureFrame.Frame.CaptureName.Text = capturesInfo[v]["DisplayName"]
		newCaptureFrame.Frame.AbilityDescription.Text = capturesInfo[v]["AbilityDescription"]
		newCaptureFrame.Frame.HowToObtainDescription.Text = capturesInfo[v]["HowToObtainDescription"]
		if table.find(plrCapturesEquipped, capturesInfo[v]["Name"]) then
			newCaptureFrame.Equipped.Visible = true
			newCaptureFrame.Equip.Visible = false
			newCaptureFrame.Locked.Visible = false
		elseif table.find(plrCapturesUnequipped, capturesInfo[v]["Name"]) then
			newCaptureFrame.Equip.Visible = true
			newCaptureFrame.Equipped.Visible = false
			newCaptureFrame.Locked.Visible = false
		else
			newCaptureFrame.Equipped.Visible = false
			newCaptureFrame.Equip.Visible = false
			newCaptureFrame.Locked.Visible = true
		end
		local gunToDisplay = capturesFolder:FindFirstChild(capturesInfo[v]["Name"]):Clone()
		local gunModel = Module3d:Attach3D(newCaptureFrame.Frame.Display, gunToDisplay)
		gunModel:SetDepthMultiplier(1.25)
		gunModel:SetCFrame(CFrame.Angles(0,0,0))
		
		runService.RenderStepped:Connect(function()
			gunModel:SetCFrame(CFrame.Angles(0, tick() * 2 % (math.pi * 2),0) * CFrame.Angles(math.rad(-10),0,0))
		end)

		newCaptureFrame.Visible = true
		gunModel.Visible = true
		newCaptureFrame.Parent = script.Parent.Background.ScrollingFrame
	end	

	for _, v in ipairs(script.Parent.Background.ScrollingFrame:GetChildren()) do
		if v:IsA("Frame") then
			v.Equip.MouseButton1Up:Connect(function()
				local gun = v.Name
				local equipResult, errorMessage = equipCaptureRF:InvokeServer(gun)
				if equipResult == true then
					loadCaptures()
				else
					errorMessageFrame.Visible = true
					errorMessageFrame.ErrorText.Text = errorMessage
					wait(1)
					errorMessageFrame.Visible = false
				end
			end)
		end
	end
end

openButton.MouseButton1Up:Connect(function()
	if capturesFr.Visible == true then
		capturesFr.Visible = false
		local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
		hpXpTrackers.Enabled = true
	else
		for _, v in ipairs(otherMenuInteractives) do
			if v.Name ~= "Captures" then
				v.Visible = false
			else
				capturesFr.Visible = true
				local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
				hpXpTrackers.Enabled = false
				game.Players.LocalPlayer.PlayerGui:WaitForChild("DefaultIcons").Frame.Captures.ExclamationMark.Visible = false
				loadCaptures()
			end 
		end
	end
end)

exitButton.MouseButton1Up:Connect(function()
	capturesFr.Visible = false
	local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
	hpXpTrackers.Enabled = true
end)

local captureNotificaitonRE = RS:WaitForChild("InventoryRemotes"):WaitForChild("captureNotificationRE")

captureNotificaitonRE.OnClientEvent:Connect(function()
	game.Players.LocalPlayer.PlayerGui:WaitForChild("DefaultIcons").Frame.Captures.ExclamationMark.Visible = true
end)
game.Players.LocalPlayer.CharacterAdded:Connect(function()
	loadCaptures()
end)

wait(1)
loadCaptures()