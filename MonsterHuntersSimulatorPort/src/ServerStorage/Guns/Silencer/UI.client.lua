

game:GetService("RunService").Stepped:Connect(function()
	local Gui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Weapons").Silencer
end)

script.Parent.Equipped:Connect(function()
	local Gui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Weapons").Silencer
	Gui.MainFrame.Visible = true
end)

script.Parent.Unequipped:Connect(function()
	local Gui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Weapons").Silencer
	Gui.MainFrame.Visible = false
end)