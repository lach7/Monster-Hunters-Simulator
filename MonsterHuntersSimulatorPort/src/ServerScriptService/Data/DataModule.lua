local data = {}
local playerData = {}

local Settings = require(game:GetService("ReplicatedStorage"):WaitForChild("Data"):WaitForChild("ConvertShortModule"))
function data.AddPlayer(player, data)
	playerData[player] = data
end

function data.ReturnData(player)
	return playerData[player]
end

function data.RemovePlayer(player)
	playerData[player] = nil
end

local coinsRemote = game:GetService('ReplicatedStorage'):WaitForChild("CoinsDiamondsDisplayRemotes"):WaitForChild("CoinsRemote")
local diamondsRemote = game:GetService('ReplicatedStorage'):WaitForChild("CoinsDiamondsDisplayRemotes"):WaitForChild("DiamondsRemote")
local gunInfo = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("gunInfo"))

function data.EditData(player, key, newData, mathMethod, key2, key2method, deletedPet, points)
	if key == "Level" then
		local plrLevel = playerData[player]["Level"]
		player.Character.Head.NameTag.Frame.Level.Text = "Level "..tostring(plrLevel + 1)
	end
	if mathMethod == "addition" then
		local oldata = playerData[player][key]
			playerData[player][key] = newData + oldata
			if key == "Coins" then
			game.Players[tostring(player)].leaderstats.Coins.Value = Settings:ConvertShort(oldata + newData)
			local plrGunsOwned = {}
			local shouldNotificationBeShown = false
			for _, v in pairs(playerData[player]["Guns"]["Equipped"]) do
				table.insert(plrGunsOwned, v)
			end
			for _, v in pairs(playerData[player]["Guns"]["Unequipped"]) do
				table.insert(plrGunsOwned, v)
			end
			for _, v in pairs(gunInfo) do
				if v["Price"] then
					if v["Price"] <= playerData[player]["Coins"] then
						if not table.find(plrGunsOwned, v["Name"]) then
							shouldNotificationBeShown = true
						end
					end
				end
			end
			coinsRemote:FireClient(player, Settings:ConvertShort(playerData[player]["Coins"]), shouldNotificationBeShown)
			elseif key == "Kills" then		
			game.Players[tostring(player)].leaderstats.Kills.Value = Settings:ConvertShort(oldata + newData)
		elseif key == "Diamonds" then
			diamondsRemote:FireClient(player, Settings:ConvertShort(playerData[player]["Diamonds"]))
	end
		
	elseif mathMethod == "subtraction" then
		local oldata = playerData[player][key]
		playerData[player][key] = oldata - newData
		if key == "Coins" then
			game.Players[tostring(player)].leaderstats.Coins.Value = Settings:ConvertShort(oldata - newData)
			coinsRemote:FireClient(player, Settings:ConvertShort(playerData[player]["Coins"]))
		elseif key == "Diamonds" then
			diamondsRemote:FireClient(player, Settings:ConvertShort(playerData[player]["Diamonds"]))
		end
	elseif mathMethod == "set" then
		playerData[player][key] = newData
	end
	--
	if key == "Pets" then
		if key2 == nil then
			for _, v in ipairs(newData) do
				table.insert(playerData[player]["Pets"]["Unequipped"], v)
			end
		else
			if key2method == "addition" then
				local oldata = playerData[player][key][key2]
				playerData[player][key][key2] = newData + oldata
			elseif key2method == "subtraction" then
				local oldata = playerData[player][key][key2]
				if oldata - newData >= 0 then
					playerData[player][key][key2] = oldata - newData	
				else
					playerData[player][key][key2] = 0
				end
				
			end
		end
		
	elseif key == "PetsEquip" then
		for _, v in ipairs(newData) do
			table.insert(playerData[player]["Pets"]["Equipped"], v)
			table.remove(playerData[player]["Pets"]["Unequipped"], table.find(playerData[player]["Pets"]["Unequipped"], v))
		end
	elseif key == "PetsUnequip" then
		for _, v in ipairs(newData) do
			table.remove(playerData[player]["Pets"]["Equipped"], table.find(playerData[player]["Pets"]["Equipped"], v))
			table.insert(playerData[player]["Pets"]["Unequipped"], v)
		end
	elseif key == "CurrentStorageUse" then
		local oldData = playerData[player]["Pets"]["CurrentStorageUse"]
		playerData[player]["Pets"]["CurrentStorageUse"] = oldData + newData
	end
	if deletedPet then
		local petToDelete = table.find(playerData[player]["Pets"]["Unequipped"], deletedPet)
		if petToDelete then
			table.remove(playerData[player]["Pets"]["Unequipped"], petToDelete)
			playerData[player]["Pets"]["CurrentStorageUse"] = playerData[player]["Pets"]["CurrentStorageUse"] - 1
			return true
		end
	end
	if points then
		playerData[player]["Points"] += 1
	end
end


return data
