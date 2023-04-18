local codeRedeemRequestRF = game:GetService("ReplicatedStorage"):WaitForChild("InventoryRemotes"):WaitForChild("codeRedeemRequest")
local codesInfo = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("codesInfo"))
local dataModule = require(game:GetService("ServerScriptService"):WaitForChild("Data"):WaitForChild("DataModule"))
local RS = game:GetService("ReplicatedStorage")
local CoinRemote = RS:WaitForChild("GameRemotes"):WaitForChild("CoinRemote")
local DiamondRemote = RS:WaitForChild("GameRemotes"):WaitForChild("DiamondRemote")

codeRedeemRequestRF.OnServerInvoke = function(player, text)
	if codesInfo[text] then
		local plrData = dataModule.ReturnData(player)
		if plrData["Codes"][text] == false then
			local rewards = codesInfo[text]
			plrData["Codes"][text] = true
			
			for key, value in pairs(rewards) do
				dataModule.EditData(player, key, value, "addition")
				if key == "Coins" then
					CoinRemote:FireClient(player, value)
				elseif key == "Diamonds" then
					DiamondRemote:FireClient(player, value)
				end
				return true, "Successfull"
			end
		else
			return nil, nil, "Already redeemed"
		end
		
	else
		return nil, nil, "Invalid code"
	end
end
