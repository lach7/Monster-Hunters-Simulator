

game:GetService("RunService").Stepped:Connect(function()
	local Gui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Weapons").DB
end)

script.Parent.Equipped:Connect(function()
	local Gui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Weapons").DB
	Gui.MainFrame.Visible = true
end)

script.Parent.Unequipped:Connect(function()
	local Gui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Weapons").DB
	Gui.MainFrame.Visible = false
end)