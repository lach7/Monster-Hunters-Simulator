local runService = game:GetService("RunService")

local playerPets = workspace:WaitForChild("Player_Pets")

local circle = math.pi * 2

local function getPosition(angle, radius)
	local x = math.cos(angle) * radius
	local z = math.sin(angle) * radius
	return x, z
end

local function positionPets(character, folder)
	for i, pet in pairs(folder:GetChildren()) do
		local radius = 4+#folder:GetChildren()
		local angle = i * (circle / #folder:GetChildren())
		local x, z = getPosition(angle, radius)
		local _, characterSize = character:GetBoundingBox()
		local _, petSize = pet:GetBoundingBox()

		local offsetY = - characterSize.Y/2 + petSize.Y/2
		local sin = (math.sin(15 * time() + 1.6)/.5)+1
		local cos = math.cos(7 * time() + 1)/4
		
		if character.Humanoid then
			if character.Humanoid.MoveDirection.Magnitude > 0 then
				if pet:FindFirstChild("Walks") then
					pet:SetPrimaryPartCFrame(pet.PrimaryPart.CFrame:Lerp(character.PrimaryPart.CFrame * CFrame.new(x, offsetY+sin, z) * CFrame.fromEulerAnglesXYZ(0,0,cos),0.1))
				else
					pet:SetPrimaryPartCFrame(pet.PrimaryPart.CFrame:Lerp(character.PrimaryPart.CFrame * CFrame.new(x, offsetY/2+math.sin(time()*3)+1, z),0.1))
				end 
			else
				if pet:FindFirstChild("Walks") then 
					pet:SetPrimaryPartCFrame(pet.PrimaryPart.CFrame:Lerp(character.PrimaryPart.CFrame * CFrame.new(x, offsetY, z) ,0.1))
				else
					pet:SetPrimaryPartCFrame(pet.PrimaryPart.CFrame:Lerp(character.PrimaryPart.CFrame * CFrame.new(x, offsetY/2+math.sin(time()*3)+1, z) ,0.1))
				end
			end
		end
	end
end

runService.RenderStepped:Connect(function()
	for _, PlrFolder in pairs(playerPets:GetChildren()) do
		local Player = game.Players:FindFirstChild(PlrFolder.Name) or nil
		if Player ~= nil then
			local character = Player.Character or nil
			if character ~= nil then
				positionPets(character, PlrFolder)
			end
		end
 	end
end)