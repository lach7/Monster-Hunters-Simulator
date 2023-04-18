local UserInputService = game:GetService("UserInputService")
local ToolOn = false

local Id = "rbxassetid://12892259906"
local AnimationNew = Instance.new("Animation")
AnimationNew.AnimationId = Id
local Humanoid = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(AnimationNew)

script.Parent.Equipped:Connect(function()

	Humanoid:Play()
	ToolOn = true
	game:GetService("RunService").Stepped:Connect(function()
		local pos = UserInputService:GetMouseLocation()
		game.Players.LocalPlayer.PlayerGui:WaitForChild("AimGui").Aim.Position = UDim2.new(0, pos.X, 0, pos.Y - 36)
	end)
end)

script.Parent.Unequipped:Connect(function()
	ToolOn = false
	Humanoid:Stop()
end)
