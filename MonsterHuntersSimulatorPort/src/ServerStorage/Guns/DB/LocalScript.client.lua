local HoldingTool = false
local Cooldown = true

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
				game.ReplicatedStorage.Reload:FireServer()
				wait(1)
				Cooldown = true
			end
		end
	end
end)