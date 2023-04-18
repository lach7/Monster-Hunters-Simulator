local PS = game:GetService("PhysicsService")

local enemiesFolders = {}

for _, v in ipairs(workspace.Bays:GetChildren()) do
	if v:IsA("Folder") then
		for _, section in ipairs(v:GetChildren()) do
			if section.Name ~= "FakeSection" then
				table.insert(enemiesFolders, section.Enemies)
			end
		end
	end
end

enemiesCollisionGroup = PS:RegisterCollisionGroup("Enemies")
playersCollisionGroup = PS:RegisterCollisionGroup("Players")

PS:CollisionGroupSetCollidable("Enemies", "Players", false)
PS:CollisionGroupSetCollidable("Players", "Players", false)
PS:CollisionGroupSetCollidable("Enemies", "Enemies", false)

for _, v in ipairs(enemiesFolders) do
	v.ChildAdded:Connect(function(child)
		for _, enemyPart in pairs(v:GetDescendants()) do
			if enemyPart:IsA("BasePart") then
				enemyPart.CollisionGroup = "Enemies"
			end
		end
	end)
end

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		local character = player.Character
		for _, v in ipairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CollisionGroup = "Players"
			end
		end
	end)
end)


