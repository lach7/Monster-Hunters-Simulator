local Player = game:GetService("Players").LocalPlayer

game:GetService("RunService").RenderStepped:Connect(function()
	if not workspace:FindFirstChild(Player.Name) then
		return
	end
	if workspace[Player.Name]:FindFirstChild("Health") then
		workspace[Player.Name]:FindFirstChild("Health"):Destroy()
	end
end)