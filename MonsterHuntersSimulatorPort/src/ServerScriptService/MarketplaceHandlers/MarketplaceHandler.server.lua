local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local dataModule = require(game:GetService("ServerScriptService"):WaitForChild("Data"):WaitForChild("DataModule"))
local RS = game:GetService("ReplicatedStorage")
local gamepassBoughtRE = RS:WaitForChild("InventoryRemotes"):WaitForChild("gamepassBoughtRE")

local productFunctions = {}

-- ProductId 1507451049 gives the user 50 gems
productFunctions[1507451049] = function(receipt, player)
	dataModule.EditData(player, "Diamonds", 50, "addition")
	return true
end
--200 gems
productFunctions[1507451289] = function(receipt, player)
	dataModule.EditData(player, "Diamonds", 200, "addition")
	return true
end
--600 gems
productFunctions[1507451416] = function(receipt, player)
	dataModule.EditData(player, "Diamonds", 600, "addition")
	return true
end
--1500 gems
productFunctions[1507451530] = function(receipt, player)
	dataModule.EditData(player, "Diamonds", 1500, "addition")
	return true
end
--6000 gems
productFunctions[1507451685] = function(receipt, player)
	dataModule.EditData(player, "Diamonds", 6000, "addition")
	return true
end
--20000 gems
productFunctions[1507451821] = function(receipt, player)
	dataModule.EditData(player, "Diamonds", 20000, "addition")
	return true
end
--+100 pet storage
productFunctions[154154230] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Pets"]["MaxStorage"] += 100
	plrData["Gamepasses"]["+100Storage"] = true
	gamepassBoughtRE:FireClient(player, "+100PetStorage")
	return true
end
--+40 pet storage
productFunctions[154153868] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Pets"]["MaxStorage"] += 40
	plrData["Gamepasses"]["+40Storage"] = true
	gamepassBoughtRE:FireClient(player, "+40PetStorage")
	return true
end
--+2 pet equip
productFunctions[154152603] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Pets"]["MaxEquipped"] += 2
	plrData["Gamepasses"]["+2PetEquip"] = true
	gamepassBoughtRE:FireClient(player, "+2PetEquip")
	return true
end
--+4 pet equip
productFunctions[154152858] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Pets"]["MaxEquipped"] += 4
	plrData["Gamepasses"]["+4PetEquip"] = true
	gamepassBoughtRE:FireClient(player, "+4PetEquip")
	return true
end
--open 3
productFunctions[154151056] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Gamepasses"]["Open3"] = true
	gamepassBoughtRE:FireClient(player, "Open3")
	return true
end
--x2Coins
productFunctions[154150375] = function(receipt, player)
	print("X2COINS")
	local plrData = dataModule.ReturnData(player)
	plrData["Multipliers"]["BaseCoins"] += 1
	plrData["Gamepasses"]["x2Coins"] = true
	gamepassBoughtRE:FireClient(player, "x2Coins")
	return true
end
--x2Diamonds
productFunctions[154150842] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Multipliers"]["BaseDiamonds"] += 1
	plrData["Gamepasses"]["x2Diamonds"] = true
	gamepassBoughtRE:FireClient(player, "x2Diamonds")
	return true
end
--x2EXP
productFunctions[154150668] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Multipliers"]["BaseEXP"] += 1
	plrData["Gamepasses"]["x2EXP"] = true
	gamepassBoughtRE:FireClient(player, "x2EXP")
	return true
end
--x5Luck
productFunctions[154153570] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Gamepasses"]["x5Luck"] = true
	local luckGamePassBoughtRE = RS:WaitForChild("InventoryRemotes"):WaitForChild("luckGamePassBoughtRE")
	luckGamePassBoughtRE:FireClient(player)
	gamepassBoughtRE:FireClient(player, "x5Luck")
	return true
end
--RPG
productFunctions[154148642] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Gamepasses"]["RPG"] = true
	local SS = game:GetService("ServerStorage")
	local gunToolsFolder = SS:WaitForChild("Guns")
	local gun = gunToolsFolder:FindFirstChild("RPG"):Clone()
	gun.Parent = player.Backpack
	gamepassBoughtRE:FireClient(player, "RPG")
	return true
end
--Flamethrower
productFunctions[154149002] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Gamepasses"]["Flamethrower"] = true
	local SS = game:GetService("ServerStorage")
	local gunToolsFolder = SS:WaitForChild("Guns")
	local gun = gunToolsFolder:FindFirstChild("Flamethrower"):Clone()
	gun.Parent = player.Backpack
	gamepassBoughtRE:FireClient(player, "Flamethrower")
	return true
end

--10R$
productFunctions[1508689897] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Donations"] += 10
	return true
end
--50R$
productFunctions[1507454242] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Donations"] += 50
	return true
end
--300R$
productFunctions[1507453462] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Donations"] += 300
	return true
end
--1500R$
productFunctions[1508695913] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Donations"] += 1500
	return true
end
local onPointsBoughtWithRobuxRE = RS:WaitForChild("InventoryRemotes"):WaitForChild("onPointsBoughtWithRobux")
--10 points
productFunctions[1510842033] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Points"] += 10
	onPointsBoughtWithRobuxRE:FireClient(player)
	return true
end
--25 points
productFunctions[1510842212] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Points"] += 25
	onPointsBoughtWithRobuxRE:FireClient(player)
	return true
end
--50 points
productFunctions[1510842365] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Points"] += 50
	onPointsBoughtWithRobuxRE:FireClient(player)
	return true
end
--100 points
productFunctions[1510842513] = function(receipt, player)
	local plrData = dataModule.ReturnData(player)
	plrData["Points"] += 100
	onPointsBoughtWithRobuxRE:FireClient(player)
	return true
end


--[[
local testingRF = game:GetService("ReplicatedStorage"):WaitForChild("TestingRF")
testingRF.OnServerInvoke = function(player, id)
	local handler = productFunctions[id]
	handler(nil, player)
end
]]

local MarketplaceService = game:GetService("MarketplaceService")

-- Function to handle a completed prompt and purchase
local function onPromptPurchaseFinished(player, purchasedPassID, purchaseSuccess)
	if purchaseSuccess then
		local handler = productFunctions[purchasedPassID]
		handler(nil, player)
		print("AHHASHF")
		-- Assign this player the ability or bonus related to the Pass
	end
end

-- Connect "PromptGamePassPurchaseFinished" events to the function
MarketplaceService.PromptGamePassPurchaseFinished:Connect(onPromptPurchaseFinished)

local function processReceipt(receiptInfo)
	local userId = receiptInfo.PlayerId
	local productId = receiptInfo.ProductId

	local player = Players:GetPlayerByUserId(userId)
	if player then
		-- Get the handler function associated with the developer product ID and attempt to run it
		local handler = productFunctions[productId]
		local success, result = pcall(handler, receiptInfo, player)
		if success then
			-- The user has received their benefits!
			-- return PurchaseGranted to confirm the transaction.
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			warn("Failed to process receipt:", receiptInfo, result)
		end
	end

	-- the user's benefits couldn't be awarded.
	-- return NotProcessedYet to try again next time the user joins.
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

-- Set the callback; this can only be done once by one script on the server!
MarketplaceService.ProcessReceipt = processReceipt