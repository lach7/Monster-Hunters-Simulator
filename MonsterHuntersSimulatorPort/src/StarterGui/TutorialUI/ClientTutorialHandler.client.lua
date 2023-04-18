local RS = game:GetService("ReplicatedStorage")
local tutorialFolder = RS:WaitForChild("Tutorial")
local startTutorialRE = tutorialFolder:WaitForChild("StartTutorialRE")
local stagesRE = tutorialFolder:WaitForChild("StagesRE")
local tutorialInfo = require(tutorialFolder:WaitForChild("tutorialInfo"))
local tutorialFrame = script.Parent:WaitForChild("Frame")
local player = game.Players.LocalPlayer
local skipTutorialRE = RS:WaitForChild('Tutorial'):WaitForChild("skipTutorialRE")

local function beam(stage)
	tutorialFrame.Visible = true
	tutorialFrame.TutorialText.Text = tutorialInfo["Stage"..tostring(stage)]["Text"]
	local pos = tutorialInfo["Stage"..tostring(stage)]["Pos"]
	if pos then
		local beam = RS:WaitForChild("BeamSample"):Clone()
		beam.Parent = workspace
		local character = player.Character or player.CharacterAdded:Wait()
		beam.Attachment1 = character:WaitForChild("HumanoidRootPart").RootRigAttachment
		beam.Attachment0 = workspace.TutorialPositions[pos].Attachment
	end
end

local RequestTutorialFrame = script.Parent.RequestTutorial
local tutorialCompleteFrame = script.Parent.TutorialComplete

startTutorialRE.OnClientEvent:Connect(function(stage)
	if stage == 1 then
		local pos = RequestTutorialFrame.Position
		RequestTutorialFrame.Visible = true

		RequestTutorialFrame.Position = pos - UDim2.new(0,0,1,0)
		local position1 = {
			Position = pos
		}
		local position2 = {
			Position = pos - UDim2.new(0,0,1,0)
		}
		local TI = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)
		local TS = game:GetService("TweenService")
		local tween1 = TS:Create(RequestTutorialFrame, TI, position1)
		local tween2 = TS:Create(RequestTutorialFrame, TI, position2)

		tween1:Play()
		local debounce = false
		RequestTutorialFrame.Yes.MouseButton1Up:Connect(function()
			if debounce == false then
				debounce = true
				tutorialFrame.Visible = true
				beam(stage)
				tween2:Play()
				wait(1)
				debounce = false
			end
		end)
		RequestTutorialFrame.No.MouseButton1Up:Connect(function()
			if debounce == false then
				debounce = true
				skipTutorialRE:FireServer()
				tutorialFrame.Visible = false
				tween2:Play()
				wait(1)
				debounce = false
			end
		end)
	else
		beam(stage)
	end
end)

stagesRE.OnClientEvent:Connect(function(stage, hasCompleted)
	if hasCompleted == nil then
		if workspace:FindFirstChild("BeamSample") then
			workspace:FindFirstChild("BeamSample"):Destroy()
		end
		tutorialFrame.TutorialText.Text = tutorialInfo["Stage"..tostring(stage)]["Text"]
		local pos = tutorialInfo["Stage"..tostring(stage)]["Pos"]
		if pos then
			local beam = RS:WaitForChild("BeamSample"):Clone()
			beam.Parent = workspace
			local character = player.Character or player.CharacterAdded:Wait()
			beam.Attachment1 = character:WaitForChild("HumanoidRootPart").RootRigAttachment
			beam.Attachment0 = workspace.TutorialPositions[pos].Attachment
		end
	else
		tutorialFrame.Visible = false
		local pos = tutorialCompleteFrame.Position
		tutorialCompleteFrame.Visible = true
		tutorialCompleteFrame.Position = pos - UDim2.new(0,0,1,0)
		local position1 = {
			Position = pos
		}
		local position2 = {
			Position = pos - UDim2.new(0,0,1,0)
		}
		local TI = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)
		local TS = game:GetService("TweenService")
		local tween1 = TS:Create(tutorialCompleteFrame, TI, position1)
		local tween2 = TS:Create(tutorialCompleteFrame, TI, position2)

		tween1:Play()
		wait(2.5)
		tween2:Play()
		
	end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function()
	local character = player.Character or player.CharacterAdded:Wait()
	if workspace:FindFirstChild("BeamSample") then
		workspace:FindFirstChild("BeamSample").Attachment1 = character:WaitForChild("HumanoidRootPart").RootRigAttachment
	end
end)

script.Parent.Frame.SkipTutorial.MouseButton1Up:Connect(function()
	script.Parent.Frame.Visible = false
	if workspace:FindFirstChild("BeamSample") then
		workspace:FindFirstChild("BeamSample"):Destroy()
	end
	skipTutorialRE:FireServer()
end)

