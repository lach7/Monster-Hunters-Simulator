local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local getPetInfoRF = RS:WaitForChild("EggRemotes"):WaitForChild("getEggInfo")
local openValidationRF = RS:WaitForChild("EggRemotes"):WaitForChild("openValidation")
local equipPetRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("equipPetRF")
local petEggInfo = require(SSS:WaitForChild("Modules"):WaitForChild("PetEggInfo"))
local dataModule = require(SSS:WaitForChild("Data"):WaitForChild("DataModule"))
local unequipPetRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("unequipPetRF")
local petsFolder = RS:WaitForChild("Pets")
local equipPetsOnSpawnRE = RS:WaitForChild("InventoryRemotes"):WaitForChild("equipPetsOnSpawnRE")
local deletePetRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("deletePetRF")
local petEquippedOnServerRE = game:GetService("ReplicatedStorage"):WaitForChild("InventoryRemotes"):WaitForChild("petEquippedOnServerRE")

getPetInfoRF.OnServerInvoke = function(player)
	local info = petEggInfo
	local plrData = dataModule.ReturnData(player)
	if plrData then
		if plrData["Gamepasses"]["x5Luck"] == true then
			return info, true
		else
			return info
		end
	end
end

local function addPetsToInv(player, pets)
	--petEquippedOnServerRE:FireAllClients()
	dataModule.EditData(player, "Pets", pets)
end

local function choosePet(eggName, numberToChoose, player)
	local function giveRandomPet()
		local number = math.random(100)
		local commonChance
		local uncommonChance
		local rareChance 
		local epicChance 
		local mythicalChance 
		local plrData = dataModule.ReturnData(player)
		if plrData then
			local isLuckGamepassOwned = plrData["Gamepasses"]["x5Luck"]
			if isLuckGamepassOwned == true then
				commonChance = petEggInfo[eggName]["CommonPet"]["x5GamepassRarity"]
				uncommonChance = petEggInfo[eggName]["UncommonPet"]["x5GamepassRarity"]
				rareChance = petEggInfo[eggName]["RarePet"]["x5GamepassRarity"]
				epicChance = petEggInfo[eggName]["EpicPet"]["x5GamepassRarity"]
				mythicalChance = petEggInfo[eggName]["MythicalPet"]["x5GamepassRarity"]
			else
				commonChance = petEggInfo[eggName]["CommonPet"]["BaseRarity"]
				uncommonChance = petEggInfo[eggName]["UncommonPet"]["BaseRarity"]
				rareChance = petEggInfo[eggName]["RarePet"]["BaseRarity"]
				epicChance = petEggInfo[eggName]["EpicPet"]["BaseRarity"]
				mythicalChance = petEggInfo[eggName]["MythicalPet"]["BaseRarity"]
			end

			local petChosen
			if number <= commonChance then
				petChosen = petEggInfo[eggName]["CommonPet"]["Name"]
			elseif number <= commonChance + uncommonChance then
				petChosen = petEggInfo[eggName]["UncommonPet"]["Name"]
			elseif number <= commonChance + uncommonChance + rareChance then
				petChosen = petEggInfo[eggName]["RarePet"]["Name"]
			elseif number <= commonChance + uncommonChance + rareChance + epicChance then
				petChosen = petEggInfo[eggName]["EpicPet"]["Name"]
			elseif number <= commonChance + uncommonChance + rareChance + epicChance + mythicalChance then
				petChosen = petEggInfo[eggName]["MythicalPet"]["Name"]
			end
			return petChosen
		end
	end
	local petsChosen = {}
	for i = 1, numberToChoose, 1 do
		local petToInsert = giveRandomPet()
		table.insert(petsChosen, petToInsert)
	end
	return petsChosen
end

openValidationRF.OnServerInvoke = function(player, buttonClicked, eggName)
	local plrData = dataModule.ReturnData(player)
	local plrCoins = plrData["Coins"]
	local eggCost = petEggInfo[eggName]["Cost"]
	if buttonClicked == "Open1" then
		if plrCoins >= eggCost then
			local currentStorageUse = plrData["Pets"]["CurrentStorageUse"]
			local maxStorage = plrData["Pets"]["MaxStorage"]
			if maxStorage - currentStorageUse >= 1 then
				dataModule.EditData(player, "Coins", eggCost, "subtraction")
				local petChosen = choosePet(eggName, 1, player)
				dataModule.EditData(player, "CurrentStorageUse", 1)
				addPetsToInv(player, petChosen)
				return true, petChosen
			else
				return false, nil, "Max Storage"
			end
		else
			return false, nil, "Insufficient Coins"
		end
	elseif buttonClicked == "Open3" then
		if plrData["Gamepasses"]["Open3"] == true then
			if plrCoins >= eggCost*3 then
				local currentStorageUse = plrData["Pets"]["CurrentStorageUse"]
				local maxStorage = plrData["Pets"]["MaxStorage"]
				if maxStorage - currentStorageUse >= 3 then
					dataModule.EditData(player, "Coins", eggCost*3, "subtraction")
					local petsChosen = choosePet(eggName, 3, player)
					dataModule.EditData(player, "CurrentStorageUse", 3)
					addPetsToInv(player, petsChosen)
					return true, petsChosen
				else
					return false, nil, "Max Storage"
				end
			else
				return false, nil, "Insufficient Coins"
			end
		else
			--prompt gamepass purchase (later)
			return false, nil,"Does not own gamepass"
		end
	elseif buttonClicked == "AutoOpen" then
		if player:IsInGroup(17136910) then
			if plrData["Gamepasses"]["Open3"] == true then
				if plrCoins >= eggCost*3 then
					local currentStorageUse = plrData["Pets"]["CurrentStorageUse"]
					local maxStorage = plrData["Pets"]["MaxStorage"]
					if maxStorage - currentStorageUse >= 3 then
						print("C")
						dataModule.EditData(player, "Coins", eggCost*3, "subtraction")
						local petsChosen = choosePet(eggName, 3, player)
						dataModule.EditData(player, "CurrentStorageUse", 3)
						addPetsToInv(player, petsChosen)
						return true, petsChosen, nil, true
					else
						return false, nil, "Max Storage"
					end
				else
					return false, nil, "Insufficient Coins"
				end
			else
				if plrCoins >= eggCost then
					local currentStorageUse = plrData["Pets"]["CurrentStorageUse"]
					local maxStorage = plrData["Pets"]["MaxStorage"]
					if maxStorage - currentStorageUse >= 1 then
						dataModule.EditData(player, "Coins", eggCost, "subtraction")
						local petChosen = choosePet(eggName, 1, player)
						dataModule.EditData(player, "CurrentStorageUse", 1)
						addPetsToInv(player, petChosen)
						return true, petChosen, nil, false
					else
						return false, nil, "Max Storage"
					end
				else
					return false, nil, "Insufficient Coins"
				end
			end
		else
			return false, nil, "Join the Highflyers Studios roblox group to use Auto Open!"
		end
	end
end

local function updateMultipliers(player)
	local plrData = dataModule.ReturnData(player)
	local plrEquippedPets = plrData["Pets"]["Equipped"]

	local baseCoinsMult = plrData["Multipliers"]["BaseCoins"]
	local baseAttackMult = plrData["Multipliers"]["BaseAttack"]
	local pointsCoins = plrData["Multipliers"]["PointsCoins"]
	local pointsAttack = plrData["Multipliers"]["PointsAttack"]
	local coinsMultToAdd = 0
	local attackMultToAdd = 0
	if #plrEquippedPets ~= 0 then
		for _, v in ipairs(plrEquippedPets) do
			coinsMultToAdd  += petEggInfo["Pets"][v]["Stats"]["Coins"] -1
			attackMultToAdd  += petEggInfo["Pets"][v]["Stats"]["Attack"]-1	
		end
		plrData["Multipliers"]["Coins"] = baseCoinsMult + pointsCoins + coinsMultToAdd
		plrData["Multipliers"]["Attack"] = baseAttackMult + pointsAttack + attackMultToAdd
	else
		--no pets equipped
		plrData["Multipliers"]["Coins"] = baseCoinsMult + pointsCoins
		plrData["Multipliers"]["Attack"] = baseAttackMult + pointsAttack
	end
end

equipPetRF.OnServerInvoke = function(player, key, petsEquipped)
	local plrData = dataModule.ReturnData(player)
	local plrPetInfo = plrData["Pets"]
	local maxEquipped = plrPetInfo["MaxEquipped"]
	local currentEquipped = plrPetInfo["CurrentEquipped"]
	if currentEquipped < maxEquipped then
		dataModule.EditData(player, key, petsEquipped)
		--for trackings on num pets equipped
		dataModule.EditData(player, "Pets", #petsEquipped, nil, "CurrentEquipped", "addition")
		--make pets move around player character
		local plrPetFolder = workspace.Player_Pets:FindFirstChild(player.Name)
		local petsToGive = {}
		for _, v in ipairs(petsEquipped) do
			for _, value in ipairs(petsFolder:GetChildren()) do
				if value:FindFirstChild(v) then
					table.insert(petsToGive, value:FindFirstChild(v))
				end
			end
		end
		for _, v in ipairs(petsToGive) do
			local petClone = v:Clone()
			petClone.Parent = plrPetFolder
		end
		
		updateMultipliers(player)
		
		return true
	else
		return false
	end
end

unequipPetRF.OnServerInvoke = function(player, key, petsToUnequip)
	dataModule.EditData(player, key, petsToUnequip)
	dataModule.EditData(player, "Pets", #petsToUnequip, nil, "CurrentEquipped", "subtraction")
	
	local plrPetFolder = workspace.Player_Pets:WaitForChild(player.Name)
	for _, v in ipairs(petsToUnequip) do
		local petToUnequip = plrPetFolder:FindFirstChild(v)
		if petToUnequip then
			petToUnequip:Destroy()
		end
	end
	updateMultipliers(player)
	
	return true
end

deletePetRF.OnServerInvoke = function(player, petToDelete)
	dataModule.EditData(player, nil, nil, nil, nil, nil, petToDelete)
	return true
end

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Wait()
	wait(5)
	local plrData = dataModule.ReturnData(player)
	if plrData then
		if #plrData["Pets"]["Equipped"] ~= 0 then
			local petsToGive = plrData["Pets"]["Equipped"]
			local plrPetFolder = workspace.Player_Pets:FindFirstChild(player.Name)
			local pets = {}
			for _, v in ipairs(petsToGive) do
				for _, value in ipairs(petsFolder:GetChildren()) do
					if value:FindFirstChild(v) then
						table.insert(pets, value:FindFirstChild(v))
					end
				end
			end
			for _, v in ipairs(pets) do
				local petClone = v:Clone()
				petClone.Parent = plrPetFolder
			end

			updateMultipliers(player)
		end
	end
end)

