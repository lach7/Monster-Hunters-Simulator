print("Hello")

local DataModule = require(game.ServerScriptService.Data.DataModule)
local Players = game:GetService("Players")
local serverStorage = game:GetService("ServerStorage")

local replicatedStorage = game:GetService("ReplicatedStorage")
local getDataEvent = replicatedStorage:WaitForChild("Data"):WaitForChild("GetData")
local editDataEvent = replicatedStorage:WaitForChild("Data"):WaitForChild("EditData")
local dataStoreService = game:GetService("DataStoreService")
local SSS = game:GetService("ServerScriptService")
local RS = game:GetService("ReplicatedStorage")
local Settings = require(RS:WaitForChild("Data"):WaitForChild("ConvertShortModule"))

local ExpRemote = replicatedStorage:WaitForChild("GameRemotes"):WaitForChild("ExpRemote")

local saveData = dataStoreService:GetDataStore("savedata4")
local killsLeaderBoardData = dataStoreService:GetOrderedDataStore("KillsLeaderBoardData5")
local levelsLeaderBoardData = dataStoreService:GetOrderedDataStore("LevelsLeaderBoardData5")
local donationsLeaderBoardData = dataStoreService:GetOrderedDataStore("DonationsLeaderBoardData5")

local marketPlaceService = game:GetService("MarketplaceService")

local playerIdsToIgnore = {
	401350257, --lachontop
	791665175, --fcanozaj2
	452455964, --LachStar996_3
	451874028, --LachStar996_2
}

function PlayerJoined(player)
	local plrData
	local plrCoins
	--check if plr has already played b4, if they have it will update their data
	local success, errormessage = pcall(function()
		plrData = saveData:GetAsync("Player_"..tostring(player.UserId))
	end)
	if success then		
		if plrData then
			--player has played before
			print("Successfully loaded data and player has joined before:", plrData)
		else
			--hasnt played before
			plrData = {
				["Coins"] = 0,
				["Diamonds"] = 0,
				["Rebirths"] = 0,
				["Pets"] = {
					["Equipped"] = {},
					["Unequipped"] = {},
					["MaxEquipped"] = 4,
					["CurrentEquipped"] = 0,
					["MaxStorage"] = 40,
					["CurrentStorageUse"] = 0,
				},
				["Multipliers"] = {
					--base multipliers are to be changed only for stuff like gamepass purchases
					["BaseAttack"] = 1,
					["BaseCoins"] = 1,
					["BaseHealth"] = 1,
					["BaseSpeed"] = 1,
					["BaseDiamonds"] = 1,
					["BaseEXP"] = 1,
					["Attack"] = 1,
					["Coins"] = 1,
					["Health"] = 1,
					["Speed"] = 1,
					["Diamonds"] = 1,
					["PointsAttack"] = 0,
					["PointsCoins"] = 0,
					["PointsSpeed"] = 0,
					["PointsHealth"] = 0,
					["PointsDiamonds"] = 0,
				},
				["Defaults"] = {
					["Attack"] = 10,
					["Coins"] = nil,
					["Health"] = 100,
					["Speed"] = 16,
				},	
				["Level"] = 1,
				["Kills"] = 0,
				["Points"] = 0,
				["EXP"] = 0,
				["Guns"] = {
					["Equipped"] = {"Silencer"},
					["Unequipped"] = {},
				},
				["Stats"] = {
					["Health"] = 0,
					["Attack"] = 0,
					["Speed"] = 0,
					["Luck"] = 0,
				},
				["Captures"] = {
					["Equipped"] = {},
					["Unequipped"] = {},
				},
				["Gamepasses"] = {
					["Open3"] = false,
					["x5Luck"] = false,
					["x2Coins"] = false,					
					["x2Diamonds"] = false,
					["x2EXP"] = false,			
					["+4PetEquip"] = false,
					["+2PetEquip"] = false,
					["+40PetStorage"] = false,
					["+100PetStorage"] = false,
					["RPG"] = false,
					["Flamethrower"] = false,
				},
				["Codes"] = {
					--storage for codes the player has redeemed
					["RELEASE"] = false,
				},
				["Donations"] = 0,
				["Tutorial"] = {
					["HasCompleted"] = false,
					["Stage"] = 1,
				},
			}
			
			local success, errormessage = pcall(function()
				saveData:SetAsync("Player_"..tostring(player.UserId), plrData)
				if not table.find(playerIdsToIgnore, player.UserId) then
					killsLeaderBoardData:SetAsync(player.UserId, 0)
					levelsLeaderBoardData:SetAsync(player.UserId, 1)
					donationsLeaderBoardData:SetAsync(player.UserId, 0)
				end
			end)
			if success then
				print("Player has never played before, successfulyl created starting data")
			else
				print(errormessage)
			end
		end	
		--lachontop
		if player.UserId == 401350257 then
			
		end
		--blaretiger
		if player.UserId == 327787222 then
			
		end
		--lachStar996_2
		if player.UserId == 451874028 then
			
		end
		
		if not plrData["Tutorial"] then
			plrData["Tutorial"] = {
				["HasCompleted"] = false,
				["Stage"] = 1,
			}
		end
		
		if not plrData["Codes"]["UPDATE1"] then
			plrData["Codes"]["UPDATE1"] = false
		end
		
		DataModule.AddPlayer(player, plrData)
	else
		--error loading data
		print(errormessage)
		player:Kick("Error loading data!")
	end
	
	local stats = Instance.new("IntValue")
	stats.Name = "leaderstats"
	stats.Parent = player
	
	local cash = Instance.new("StringValue")
	cash.Name = "Coins"
	cash.Parent = stats
	
	local level = Instance.new("StringValue")
	level.Name = "Level"
	level.Parent = stats
	
	local kills = Instance.new("StringValue")
	kills.Name = "Kills"
	kills.Parent = stats
	
	cash.Value = Settings:ConvertShort(plrData["Coins"])
	level.Value = tostring(plrData["Level"])
	kills.Value = tostring(plrData["Kills"])
	
	local newPlrFolder = Instance.new("Folder", workspace)
	newPlrFolder.Name = player.UserId
	
	local lvl = plrData["Level"]
	ExpRemote:FireClient(player, nil, lvl, plrData["EXP"], lvl^2 + 100*lvl + 160)
	
	--gamepass weapons
	if plrData["Gamepasses"]["RPG"] == true then
		table.insert(plrData["Guns"]["Equipped"], "RPG")
	end
	if plrData["Gamepasses"]["Flamethrower"] == true then
		table.insert(plrData["Guns"]["Equipped"], "Flamethrower")
	end
	--coins
	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 154150375) == true then
		if plrData["Gamepasses"]["x2Coins"] == false then
			plrData["Gamepasses"]["x2Coins"] = true
			plrData["Multipliers"]["BaseCoins"] += 1
		end
	end
	--diamonds
	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 154150842) == true then
		if plrData["Gamepasses"]["x2Diamonds"] == false then
			plrData["Gamepasses"]["x2Diamonds"] = true
			plrData["Multipliers"]["BaseDiamonds"] += 1
		end
	end
	--exp
	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 154150668) == true then
		if plrData["Gamepasses"]["x2EXP"] == false then
			plrData["Gamepasses"]["x2EXP"] = true
			plrData["Multipliers"]["BaseEXP"] += 1
		end
	end
	--x5 luck
	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 154153570) == true then
		if plrData["Gamepasses"]["x5Luck"] == false then
			plrData["Gamepasses"]["x5Luck"] = true
		end
	end
	--open 3
	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 154151056) == true then
		if plrData["Gamepasses"]["Open3"] == false then
			plrData["Gamepasses"]["Open3"] = true
		end
	end
	--+4 pet equip
	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 154152858) == true then
		if plrData["Gamepasses"]["+4PetEquip"] == false then
			plrData["Gamepasses"]["+4PetEquip"] = true
			plrData["Pets"]["MaxEquipped"] += 4
		end
	end
	--+2 pet equip
	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 154152603) == true then
		if plrData["Gamepasses"]["+2PetEquip"] == false then
			plrData["Gamepasses"]["+2PetEquip"] = true
			plrData["Pets"]["MaxEquipped"] += 2
		end
	end
	--+40 pet storage
	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 154153868) == true then
		if plrData["Gamepasses"]["+40PetStorage"] == false then
			plrData["Gamepasses"]["+40PetStorage"] = true
			plrData["Pets"]["MaxStorage"] += 40
		end
	end
	--+100 pet storage
	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 154154230) == true then
		if plrData["Gamepasses"]["+100PetStorage"] == false then
			plrData["Gamepasses"]["+100PetStorage"] = true
			plrData["Pets"]["MaxStorage"] += 100
		end
	end
	--RPG
	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 154148642) == true then
		if plrData["Gamepasses"]["RPG"] == false then
			plrData["Gamepasses"]["RPG"] = true
			table.insert(plrData["Guns"]["Equipped"], "RPG")
		end
	end
	--Flamethrower
	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 154149002) == true then
		if plrData["Gamepasses"]["Flamethrower"] == false then
			plrData["Gamepasses"]["Flamethrower"] = true
			table.insert(plrData["Guns"]["Equipped"], "Flamethrower")
		end
	end
	
	for _, v in ipairs(game:GetService("ServerScriptService"):GetChildren()) do
		if v:IsA("Script") then
			v.Enabled = true
		else
			for _, Script in ipairs(v:GetChildren()) do
				if Script:IsA("Script") then
					Script.Enabled = true
				end
			end
		end
	end
	
	local updateGamepassesOwnedRE = RS:WaitForChild("InventoryRemotes"):WaitForChild("updateGamepassesOwnedRE")
	updateGamepassesOwnedRE:FireClient(player, plrData["Gamepasses"])
 	
	
	local coinsRemote = game:GetService('ReplicatedStorage'):WaitForChild("CoinsDiamondsDisplayRemotes"):WaitForChild("CoinsRemote")
	local diamondsRemote = game:GetService('ReplicatedStorage'):WaitForChild("CoinsDiamondsDisplayRemotes"):WaitForChild("DiamondsRemote")
	
	coinsRemote:FireClient(player, Settings:ConvertShort(plrData["Coins"]))
	diamondsRemote:FireClient(player, Settings:ConvertShort(plrData["Diamonds"]))
end

local function saveFunction(player)
	local newData = DataModule.ReturnData(player)
	local success, errormessage = pcall(function()
		saveData:UpdateAsync("Player_"..tostring(player.UserId), function(pastData)
			if newData then
				return newData
			else
				return pastData
			end
		end)
		if not table.find(playerIdsToIgnore, player.UserId) then
			levelsLeaderBoardData:UpdateAsync(player.UserId, function(pastData)
				return tonumber((newData["Level"]))
			end)
			killsLeaderBoardData:UpdateAsync(player.UserId, function(pastData)
				return tonumber(newData["Kills"])
			end)
			donationsLeaderBoardData:UpdateAsync(player.UserId, function(pastData)
				return tonumber(newData["Donations"])
			end)
		end
	end)
end

function PlayerLeft(player)
	local newData = DataModule.ReturnData(player)
	local success, errormessage = pcall(function()
		saveData:UpdateAsync("Player_"..tostring(player.UserId), function(pastData)
			if newData then
				return newData
			else
				return pastData
			end
		end)
		if not table.find(playerIdsToIgnore, player.UserId) then
			levelsLeaderBoardData:UpdateAsync(player.UserId, function(pastData)
				return tonumber((newData["Level"]))
			end)
			killsLeaderBoardData:UpdateAsync(player.UserId, function(pastData)
				return tonumber(newData["Kills"])
			end)
			donationsLeaderBoardData:UpdateAsync(player.UserId, function(pastData)
				return tonumber(newData["Donations"])
			end)
		end
	end)
	if success then
		print("updated data")
	else
		print(errormessage)
	end
	
	DataModule.RemovePlayer(player)
end

local RunService = game:GetService("RunService")

game:BindToClose(function()
	if not RunService:IsStudio() and #Players:GetPlayers() > 1 then
		for _, player in ipairs(Players:GetPlayers()) do
			coroutine.wrap(saveFunction(player))
		end
	end
end)

function Example(player)
	local data = DataModule.ReturnData(player)
end

function retrieveData(player)
	return DataModule.ReturnData(player)
end

--value: true = add equip, false = remove equip
local function editEquipData(player, key, newValue)
	DataModule.EditData(key, newValue)
end
	
Players.PlayerAdded:Connect(PlayerJoined)
Players.PlayerRemoving:Connect(PlayerLeft)

getDataEvent.OnServerInvoke = retrieveData
editDataEvent.OnServerInvoke = editEquipData



