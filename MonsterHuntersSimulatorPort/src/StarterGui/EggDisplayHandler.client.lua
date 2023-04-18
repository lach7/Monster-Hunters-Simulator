local player = game.Players.LocalPlayer
local uiModule = require(game:GetService("ReplicatedStorage"):WaitForChild("UIAnimations"))
local RS = game:GetService("ReplicatedStorage")

while wait() do
	local character = player.Character or player.CharacterAdded:Wait()
	if character then
		for _, v in ipairs(workspace.Eggs:GetChildren()) do
			if (character.HumanoidRootPart.Position - v.DetectionPart.Position).Magnitude < 20 then
				local gui = script.Parent.BillboardUI:FindFirstChild(v.Name)
				for _, v in ipairs(gui:GetChildren()) do
					if v.Name ~= "CostFrame" then
						v.Visible = true
					end
				end
			else
				local gui = script.Parent.BillboardUI:FindFirstChild(v.Name)
				for _, v in ipairs(gui:GetChildren()) do
					if v.Name ~= "CostFrame" then
						v.Visible = false
					end
				end
			end
		end
	end
end
