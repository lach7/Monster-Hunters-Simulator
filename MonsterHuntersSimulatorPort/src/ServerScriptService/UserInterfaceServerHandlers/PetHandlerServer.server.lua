local Players = game:GetService('Players')

local PetsFolder = workspace:WaitForChild("Player_Pets")

Players.PlayerAdded:Connect(function(plr)
	local folder = Instance.new('Folder')
	folder.Name = plr.Name
	folder.Parent = PetsFolder
end)

Players.PlayerRemoving:Connect(function(plr)
	if PetsFolder:FindFirstChild(plr.Name) then
		PetsFolder:FindFirstChild(plr.Name):Destroy()
	end
end)
