local RS = game:GetService("ReplicatedStorage")
local buyCoinsRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("buyCoinsRF")
local dataModule = require(game:GetService("ServerScriptService"):WaitForChild("Data"):WaitForChild("DataModule"))

local coinCosts = {
	["Coinsx500"] = 20, 
	["Coinsx2000"] = 60, 
	["Coinsx10000"] = 200, 
	["Coinsx50000"] = 700, 
	["Coinsx200000"] = 2000, 
	["Coinsx500000"] = 4000, 
}
local coinRewards = {
	["Coinsx500"] = 500, 
	["Coinsx2000"] = 2000, 
	["Coinsx10000"] = 10000, 
	["Coinsx50000"] = 50000, 
	["Coinsx200000"] = 200000, 
	["Coinsx500000"] = 500000, 
}

buyCoinsRF.OnServerInvoke = function(player, coinName)
	local coinCost = coinCosts[coinName]
	if coinCost then
		local plrData = dataModule.ReturnData(player)
		if plrData["Diamonds"] >= coinCost then
			local coinsToReward = coinRewards[coinName]
			dataModule.EditData(player, "Coins", coinsToReward, "addition")
			dataModule.EditData(player, "Diamonds", coinCost, "subtraction")
			return true
		else
			return false, "Insufficient Diamonds"
		end
	else
		return false, "Error"
	end
end
