local HoldingTool = false
local Cooldown = true
local Framework = nil
wait()
local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
Character:WaitForChild("Humanoid")
local Crouch = Character.Humanoid:LoadAnimation(game.ReplicatedStorage.ClientAnimations.Reload)

script.Parent.Equipped:Connect(function()
	HoldingTool = true
end)

script.Parent.Unequipped:Connect(function()
	HoldingTool = false
end)

local UserInputService = game:GetService("UserInputService")


UserInputService.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.R then
		if Cooldown == true then
			if HoldingTool == true then
				Cooldown = false
				game.ReplicatedStorage.ReloadWeapon:FireServer()
				local plrSpeed = game.Players.LocalPlayer.Character:FindFirstChild("SpeedValueForGuns").Value
				game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = plrSpeed
				Crouch:Play()
				wait(1)
				Cooldown = true
			end
		end
	end
end)