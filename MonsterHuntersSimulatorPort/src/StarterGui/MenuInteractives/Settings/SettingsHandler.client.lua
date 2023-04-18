local icons = script.Parent.Parent.Parent:WaitForChild("DefaultIcons"):WaitForChild("Frame")
local openButton = icons.Settings
local settingsFr = script.Parent
local otherMenuInteractives = script.Parent.Parent:GetChildren()
local exitButton = settingsFr.Exit

openButton.MouseButton1Up:Connect(function()
	if settingsFr.Visible == true then
		settingsFr.Visible = false
		local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
		hpXpTrackers.Enabled = true
	else
		for _, v in ipairs(otherMenuInteractives) do
			if v.Name ~= "Settings" then
				v.Visible = false
			else
				settingsFr.Visible = true
				local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
				hpXpTrackers.Enabled = false
			end 
		end
	end
end)

exitButton.MouseButton1Up:Connect(function()
	settingsFr.Visible = false
	local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
	hpXpTrackers.Enabled = true
end)

local plrPetsFolder = workspace:FindFirstChild("Player_Pets")
local player = game.Players.LocalPlayer
local onButton = script.Parent.DisableOtherPets.On
local offButton = script.Parent.DisableOtherPets.Off

local function MakePetsInvisible()
	--makes pets invisible for client only
	for _, v in ipairs(plrPetsFolder:GetChildren()) do
		if v.Name ~= player.Name then
			for index, pet in ipairs(v:GetChildren()) do
				for _, petPart in ipairs(pet:GetDescendants()) do
					if petPart:IsA("MeshPart") or petPart:IsA("Decal") then
						petPart.Transparency = 1
					end
				end
			end
		end
	end
end


onButton.MouseButton1Up:Connect(function()
	offButton.Visible = true
	onButton.Visible = false
	for _, v in ipairs(plrPetsFolder:GetChildren()) do
		if v.Name ~= player.Name then
			for index, pet in ipairs(v:GetChildren()) do
				for _, petPart in ipairs(pet:GetDescendants()) do
					if petPart:IsA("MeshPart") or petPart:IsA("Decal") then
						petPart.Transparency = 0
					end
				end
			end
		end
	end
end)

local petEquippedOnServerRE = game:GetService("ReplicatedStorage"):WaitForChild("InventoryRemotes"):WaitForChild("petEquippedOnServerRE")

petEquippedOnServerRE.OnClientEvent:Connect(function()
	if onButton.Visible == true then
		MakePetsInvisible()
	end
end)

offButton.MouseButton1Up:Connect(function()
	onButton.Visible = true
	offButton.Visible = false
	MakePetsInvisible()
end)