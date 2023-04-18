local SSS = game:GetService("ServerScriptService")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")
local getGunsInfoRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("getGunsInfoRF")
local equipGunRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("equipGunRF")
local buyGunRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("buyGunRF")
local gunsInfoModule = require(SSS:WaitForChild("Modules"):WaitForChild("gunInfo"))
local dataModule = require(SSS:WaitForChild("Data"):WaitForChild("DataModule"))
local gunToolsFolder = SS:WaitForChild("Guns")

getGunsInfoRF.OnServerInvoke = function(player)
	local plrData = dataModule.ReturnData(player) 
	local plrGunsEquipped = plrData["Guns"]["Equipped"]
	local plrGunsUnequipped = plrData["Guns"]["Unequipped"]
	
	
	for _, v in ipairs(game.Players[player.Name].Backpack:GetChildren()) do
		if gunsInfoModule[v.Name] and v.Name ~= "Flamethrower" and v.Name ~= "RPG" then
			v:Destroy()
		end
	end
	
	for _, v in ipairs(game.Players[player.Name].Character:GetChildren()) do
		if v:IsA("Tool") then
			if not table.find(plrGunsEquipped, v.Name) then
				if gunsInfoModule[v.Name] and v.Name ~= "Flamethrower" and v.Name ~= "RPG" then
					v.Parent = player.Backpack
					v:Destroy()
				end
				
			end
		end
	end	
	for _, v in ipairs(plrGunsEquipped) do
		local gun = gunToolsFolder:FindFirstChild(v):Clone()
		if not game.Players[player.Name].Backpack:FindFirstChild(gun.Name) and not player.Character:FindFirstChild(gun.Name) then
			gun.Parent = game.Players[player.Name].Backpack
		end
	end
	
	return gunsInfoModule, plrGunsEquipped, plrGunsUnequipped
end

equipGunRF.OnServerInvoke = function(player, gunName)
	local plrData = dataModule.ReturnData(player)
	local oldEquipped
	for _, v in ipairs(plrData["Guns"]["Equipped"]) do
		if v ~= "RPG" and v ~= "Flamethrower" then
			oldEquipped = v
		end
	end
	table.insert(plrData["Guns"]["Unequipped"], oldEquipped)
	for i, v in pairs(plrData["Guns"]["Equipped"]) do
		if v ~= "RPG" and v ~= "Flamethrower" then
			table.remove(plrData["Guns"]["Equipped"], i)
		end
	end
	table.insert(plrData["Guns"]["Equipped"], gunName)
	return true
end

buyGunRF.OnServerInvoke = function(player, gunName)
	local plrData = dataModule.ReturnData(player)
	local gunPrice = gunsInfoModule[gunName]["Price"]
	local plrCoins = plrData["Coins"]
	if plrCoins >= gunPrice then
		local oldEquipped
		for _, v in ipairs(plrData["Guns"]["Equipped"]) do
			if v ~= "RPG" and v ~= "Flamethrower" then
				oldEquipped = v
			end
		end
		table.insert(plrData["Guns"]["Unequipped"], oldEquipped)
		table.remove(plrData["Guns"]["Equipped"], table.find(plrData["Guns"]["Equipped"], oldEquipped))
		table.insert(plrData["Guns"]["Equipped"], gunName)
		dataModule.EditData(player, "Coins", gunPrice, "subtraction")
		
		return true
	else
		return false, "Insufficient coins"
	end
end

