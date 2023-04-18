local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

while wait(.5) do
	local character = player.Character or player.CharacterAdded:Wait()

	character:WaitForChild("Humanoid").Died:Connect(function()
		UIS.MouseIconEnabled = true
		game.Players.LocalPlayer.PlayerGui:WaitForChild("AimGui").Aim.Visible = false
	end)
end

