local RS = game:GetService("ReplicatedStorage")
local eggInfoRF = RS:WaitForChild("EggRemotes"):WaitForChild("getEggInfo")
local icons = script.Parent.Parent.Parent:WaitForChild("DefaultIcons"):WaitForChild("Frame")
local openButton = icons.Pets
local petFr = script.Parent
local otherMenuInteractives = script.Parent.Parent:GetChildren()
local exitButton = petFr.Exit
local getDataRF = RS:WaitForChild("Data"):WaitForChild("GetData")
local inventoryFrame = script.Parent.Inventory
local scrollingFrame = inventoryFrame.ScrollingFrame
local sample = inventoryFrame.Sample
local Module3d = require(RS:WaitForChild("Module3D"))
local runService = game:GetService("RunService")
local equipPetRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("equipPetRF")
local selectedFrame = script.Parent.Selected
local equipButton = selectedFrame.Equip
local unequipButton = selectedFrame.Unequip
local unequipPetRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("unequipPetRF")
local selectedBackground = script.Parent.SelectedBackground
local unequipAll = script.Parent.UnequipAll

local statsFrame = selectedFrame.StatsFrame
local coinsFrame = statsFrame.CoinsFrame
local attackFrame = statsFrame.AttackFrame
local equipPetsOnSpawnRE = RS:WaitForChild("InventoryRemotes"):WaitForChild("equipPetsOnSpawnRE")
local players = game:GetService("Players")
local deleteButton = selectedFrame.ImageFrame.DeleteBtn
local deletePetRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("deletePetRF")
local errorMsgFrame = script.Parent.Parent.Parent:WaitForChild("ErrorUI").ErrorFrame
local equipBestButton = script.Parent.EquipBest


local eggInfo = eggInfoRF:InvokeServer()
repeat wait() until eggInfo ~= nil

local rarityColors = {
	["Common"] = Color3.fromRGB(255, 255, 255),
	["Uncommon"] = Color3.fromRGB(0, 170, 0),
	["Rare"] = Color3.fromRGB(213, 213, 0),
	["Epic"] = Color3.fromRGB(170, 0, 0),
	["Mythical"] = Color3.fromRGB(170, 0, 255),
}

local function makeFrame(val, isEquipped)
	if isEquipped ~= nil then
		inventoryFrame.NoPetsOwnedLbl.Visible = false
		local petFrame = sample:Clone()
		petFrame.EquippedIcon.Visible = isEquipped
		petFrame.Equipped.Value = isEquipped
		local petToDisplay 
		for _, value in ipairs(RS:WaitForChild("Pets"):GetChildren()) do
			local petLookingFor = value:FindFirstChild(val)
			if petLookingFor then
				petToDisplay = petLookingFor:Clone()
			end
		end
		local petModel = Module3d:Attach3D(petFrame.Display, petToDisplay)
		petModel:SetDepthMultiplier(35)
		petModel:SetCFrame(CFrame.Angles(0,math.rad(-70),0))

		petModel.Camera.FieldOfView = 5
		petModel.Visible = true
		petFrame.Visible = true
		petFrame.Parent = scrollingFrame
		petFrame.Name = petToDisplay.Name
	else	
		local petFrame = selectedFrame.ImageFrame
		local petToDisplay 
		for _, value in ipairs(RS:WaitForChild("Pets"):GetChildren()) do
			local petLookingFor = value:FindFirstChild(val)
			if petLookingFor then
				petToDisplay = petLookingFor:Clone()
			end
		end
		local petModel = Module3d:Attach3D(petFrame.PetDisplay, petToDisplay)
		petModel:SetDepthMultiplier(1.7)
		petModel:SetCFrame(CFrame.Angles(0,math.rad(-70),0))
		
		runService.RenderStepped:Connect(function()
			petModel:SetCFrame(CFrame.Angles(0, tick() * 2 % (math.pi * 2),0) * CFrame.Angles(math.rad(-10),0,0))
		end)

		petModel.Camera.FieldOfView = 5
		petModel.Visible = true
		petFrame.Visible = true
	end
end

local function loadInventory()
	local plrData = getDataRF:InvokeServer()
	local petData = plrData["Pets"]
	
	
	for _, v in ipairs(scrollingFrame:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end	
	end
	if next(petData["Equipped"]) == nil and next(petData["Unequipped"]) == nil then
		inventoryFrame.NoPetsOwnedLbl.Visible = true
	else
		if petData["Equipped"] then
			for _, val in ipairs(petData["Equipped"]) do
				makeFrame(val, true)
			end	
		end
		if petData["Unequipped"] then
			for _, val in ipairs(petData["Unequipped"]) do
				makeFrame(val, false)
			end	
		end
	end
	
	local maxEquipped = plrData["Pets"]["MaxEquipped"]
	local currentEquipped = plrData["Pets"]["CurrentEquipped"]
	local equippedNumDisplay = script.Parent.PetsInfo.Number
	equippedNumDisplay.Text = tostring(currentEquipped).."/"..tostring(maxEquipped)
	
	local maxStorage = plrData["Pets"]["MaxStorage"]
	local currentStorageUse = plrData["Pets"]["CurrentStorageUse"]
	local storageInfoDisplay = script.Parent.StorageInfo.Number
	storageInfoDisplay.Text = tostring(currentStorageUse).."/"..tostring(maxStorage)
	
	for _, v in ipairs(scrollingFrame:GetChildren()) do
		if v:IsA("TextButton") then
			v.MouseButton1Up:Connect(function()
				selectedFrame.PetSelected.Value = v
				selectedFrame.Visible = true
				local petDisplayName = eggInfo["Pets"][v.Name]["DisplayName"]
				local petRarity = eggInfo["Pets"][v.Name]["Rarity"]
				selectedFrame.PetName.Text = petDisplayName
				selectedFrame.Rarity.Text = petRarity
				selectedFrame.Rarity.TextColor3 = rarityColors[petRarity]
				equipButton.Visible = not v.Equipped.Value
				unequipButton.Visible = v.Equipped.Value
				for _, v in ipairs(selectedFrame.ImageFrame.PetDisplay:GetChildren()) do
					v:Destroy()
				end
				
				local petAttackMultiplier = eggInfo["Pets"][v.Name]["Stats"]["Attack"]
				local petCoinsMultiplier = eggInfo["Pets"][v.Name]["Stats"]["Coins"]
				
				if petAttackMultiplier then
					attackFrame.AttackVal.Text = "x"..tostring(petAttackMultiplier)
					attackFrame.Visible = true
				end
				if petCoinsMultiplier then
					coinsFrame.CoinsVal.Text = "x"..tostring(petCoinsMultiplier)
					coinsFrame.Visible = true
				end
				makeFrame(v.Name)
				
			end)
		end
	end
end

local function equipPets(petsToEquip)
	
	local equipRequest = equipPetRF:InvokeServer("PetsEquip",petsToEquip)

	if equipRequest == true then
		for _, v in ipairs(petsToEquip) do
			scrollingFrame:FindFirstChild(v).Equipped.Value = true
		end
	end
	loadInventory()
end

equipButton.MouseButton1Up:Connect(function()
	local petToEquip = selectedFrame.PetSelected.Value.Name
	equipButton.Visible = false
	unequipButton.Visible = true
	equipPets({petToEquip})
end)

unequipButton.MouseButton1Up:Connect(function()
	local petToUnequip = selectedFrame.PetSelected.Value.Name
	local unequipRequest = unequipPetRF:InvokeServer("PetsUnequip",{petToUnequip})
	if unequipRequest == true then
		unequipButton.Visible = false
		equipButton.Visible = true
		selectedFrame.PetName.Text = "Pet Name"
		selectedFrame.Rarity.Text = "Common"
		selectedFrame.Rarity.TextColor3 = rarityColors["Common"]
		scrollingFrame:FindFirstChild(petToUnequip).Equipped.Value = false
		selectedFrame.Visible = false
		for _, v in ipairs(selectedFrame.ImageFrame.PetDisplay:GetChildren()) do
			v:Destroy()
		end
		loadInventory()
 	end
end)



openButton.MouseButton1Up:Connect(function()
	if petFr.Visible == true then
		petFr.Visible = false
		local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
		hpXpTrackers.Enabled = true
	else
		for _, v in ipairs(otherMenuInteractives) do
			if v.Name ~= "Pets" then
				v.Visible = false
			else
				petFr.Visible = true
				local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
				hpXpTrackers.Enabled = false
				loadInventory()
			end 
		end
	end
end)

exitButton.MouseButton1Up:Connect(function()
	petFr.Visible = false
	local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
	hpXpTrackers.Enabled = true
end)

local unequipDebounce = false

local function unequipAllPets()
	if unequipDebounce == false then
		unequipDebounce = true
		local petsToUnequip = {}
		for _, v in ipairs(scrollingFrame:GetChildren()) do
			if v:IsA("TextButton") and v.Equipped.Value == true then
				local petToUnequip = v.Name
				table.insert(petsToUnequip, petToUnequip)
			end
		end

		local unequipRequest = unequipPetRF:InvokeServer("PetsUnequip",petsToUnequip)
		selectedFrame.Visible = false
		loadInventory()
		unequipDebounce = false
	end
end
unequipAll.MouseButton1Up:Connect(function()
	unequipAllPets()
end)

deleteButton.MouseButton1Up:Connect(function()
	local deletedPet = selectedFrame.PetSelected.Value
	if deletedPet.Equipped.Value == false then
		local hasDeleted = deletePetRF:InvokeServer(deletedPet.Name)
		if hasDeleted == true then
			selectedFrame.PetSelected.Value = nil
			selectedFrame.Visible = false
			loadInventory()
		else
			errorMsgFrame.Visible = true
			errorMsgFrame.ErrorMessage.Text = "Error"
			wait(1)
			errorMsgFrame.Visible = false
		end
	else
		errorMsgFrame.Visible = true
		errorMsgFrame.ErrorMessage.Text = "Cannot delete an equipped pet. Please unequip it."
		wait(1)
		errorMsgFrame.Visible = false
	end
end)
local debounce = false
equipBestButton.MouseButton1Up:Connect(function()
	if debounce == false then
		debounce = true
		unequipAllPets()
		local plrData = getDataRF:InvokeServer()
		local pets = plrData["Pets"]["Unequipped"]
		local maxPets = plrData["Pets"]["MaxEquipped"]
		local petsTotalMultipliers = {}
		for _, pet in ipairs(pets) do
			local petAttack = eggInfo["Pets"][pet]["Stats"]["Attack"]
			local petCoins = eggInfo["Pets"][pet]["Stats"]["Coins"]
			local totalValue = petAttack + petCoins
			table.insert(petsTotalMultipliers, {
				["totalMultiplier"] = totalValue,
				["petName"] = pet,
			})
		end

		-- sort the table in descending order based on the totalMultiplier value
		table.sort(petsTotalMultipliers, function(a, b)
			return a.totalMultiplier > b.totalMultiplier
		end)

		-- print the highest 4 values of each pet's totalMultiplier
		local finalResults = {}
		for _, pet in ipairs(petsTotalMultipliers) do
			for i = 1, maxPets do
				if petsTotalMultipliers[i] and petsTotalMultipliers[i].petName == pet.petName then
					finalResults[i] = petsTotalMultipliers[i].petName
				end
			end
		end
		equipPets(finalResults)
		debounce = false
	end
	
end)

local gamePassIds = {
	["+100PetStorage"] = 154154230, 
	["+2PetEquip"] = 154152603, 
	["+40PetStorage"] = 154153868, 
	["+4PetEquip"] = 154152858, 
	["Open3"] = 154151056, 
	["x2Coins"] = 154150375, 
	["x2Diamonds"] = 154150842, 
	["x2EXP"] = 154150668, 
	["x5Luck"] = 154153570,
}

local MarketplaceService = game:GetService("MarketplaceService")

script.Parent.PetsInfo.BuyButton.MouseButton1Up:Connect(function()
	local productId = gamePassIds["+4PetEquip"]
	MarketplaceService:PromptGamePassPurchase(game.Players.LocalPlayer, productId)
end)

script.Parent.StorageInfo.BuyButton.MouseButton1Up:Connect(function()
	local productId = gamePassIds["+100PetStorage"]
	MarketplaceService:PromptGamePassPurchase(game.Players.LocalPlayer, productId)
end)