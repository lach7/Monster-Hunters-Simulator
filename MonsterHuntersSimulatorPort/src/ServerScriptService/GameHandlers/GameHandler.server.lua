local SSS = game:GetService("ServerScriptService")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")

local gameSettings = require(SSS:WaitForChild("Modules"):WaitForChild("GameSettings"))
local startGameBE = SSS:WaitForChild("GameEvents"):WaitForChild("StartGame")
local gameRE = RS:WaitForChild("GameRemotes"):WaitForChild("GameRemote")
local ExpRE = RS:WaitForChild("GameRemotes"):WaitForChild("ExpRemote")
local CoinRemote = RS:WaitForChild("GameRemotes"):WaitForChild("CoinRemote")
local DiamondRemote = RS:WaitForChild("GameRemotes"):WaitForChild("DiamondRemote")
local capturesInfo = require(SSS:WaitForChild("Modules"):WaitForChild("capturesInfo"))
local captureNoticiationRE = RS:WaitForChild("InventoryRemotes"):WaitForChild("captureNotificationRE")

local dataModule = require(SSS:WaitForChild("Data"):WaitForChild("DataModule"))

local startWave = 15

local bayInformation = {
	["Bay1"] = {
		["Players"] = {},
		["Wave"] = nil,
		["Location"] = "Bay1",
		["ActiveSection"] = 1,
	},
	["Bay2"] = {
		["Players"] = {},
		["Wave"] = nil,
		["Location"] = "Bay2",
		["ActiveSection"] = 1,
	},
	["Bay3"] = {
		["Players"] = {},
		["Wave"] = nil,
		["Location"] = "Bay3",
		["ActiveSection"] = 1,
	},
	["Bay4"] = {
		["Players"] = {},
		["Wave"] = nil,
		["Location"] = "Bay4",
		["ActiveSection"] = 1,
	},
	["Bay5"] = {
		["Players"] = {},
		["Wave"] = nil,
		["Location"] = "Bay5",
		["ActiveSection"] = 1,
	},
	["Bay6"] = {
		["Players"] = {},
		["Wave"] = nil,
		["Location"] = "Bay6",
		["ActiveSection"] = 1,
	},
	["Bay7"] = {
		["Players"] = {},
		["Wave"] = nil,
		["Location"] = "Bay7",
		["ActiveSection"] = 1,
	},
}

--false = availble, true = taken
local bayAvailability = {false, false, false, false, false, false, false}

local WaveThemes = game:GetService("ServerStorage"):WaitForChild("WaveThemes")
local WaveThemesTbl = {
	WaveThemes["NatureWave"],
	WaveThemes["BarbieWave"],
	WaveThemes["SnowWave"],
	WaveThemes["FireWave"],	
}

local wavesPerTheme = 15


local function initialiseGame(bay, plrsInGame)
	local gameThread = coroutine.wrap(function()
		print(bayAvailability)

		local loadWave
		bayInformation[bay]["ActiveSection"] = 1
		local enemiesInWave = {}
		local maxEnemies = gameSettings["Wave"..tostring(bayInformation[bay]["Wave"])]["NumEnemiesToKill"]
		local wave = bayInformation[bay]["Wave"]
		local enemiesSpawnedInGroup = 0
		local enemiesKilledInWave = 0
		local gameEnded = false
		
		local function endGame()
			gameEnded = true
			local waveDisplay1 = workspace.Bays[bay].Section1.WaveDisplay
			local waveDisplay2 = workspace.Bays[bay].Section2.WaveDisplay
			local section = workspace.Bays[bay]["Section"..tostring(bayInformation[bay]["ActiveSection"])]
			waveDisplay1.SurfaceGui.WaveNum.Text = "1"
			waveDisplay2.SurfaceGui.WaveNum.Text = "1"
			for _, v in ipairs(section.Enemies:GetChildren()) do
				v:Destroy()
			end

			bayAvailability[tonumber(string.match(bay, "%d+"))] = false
			bayInformation[bay]["Players"] = {}
			bayInformation[bay]["Wave"] = nil
			bayInformation[bay]["ActiveSection"] = 1
			coroutine.yield()
		end
		
		local debounce = false
		local checkForDeadHumanoid = coroutine.wrap(function()
			local stopCrashing = false
			while stopCrashing == false do
				for _, value in ipairs(enemiesInWave) do
					if value:FindFirstChild("Humanoid") then
						if value.Humanoid.Health <= 0 then
							enemiesKilledInWave = enemiesKilledInWave + 1
							for _, v in ipairs(plrsInGame) do
								--Value False = start game True = Edit Info	
								gameRE:FireClient(game.Players[v], wave, maxEnemies, enemiesKilledInWave)
							end
							local enemyValToRemove = table.find(enemiesInWave, value)
							if enemyValToRemove then

								table.remove(enemiesInWave, enemyValToRemove)
							end

							if enemiesKilledInWave == maxEnemies then
								--wave finished
								debounce = true
								local activeSection = bayInformation[bay]["ActiveSection"]
								if activeSection == 1 then
									bayInformation[bay]["ActiveSection"] = 2
								else
									bayInformation[bay]["ActiveSection"] = 1
								end
								enemiesSpawnedInGroup = 0
								enemiesKilledInWave = 0

								local coinsAwarded = gameSettings["Wave"..tostring(wave)]["Coins"]
								if coinsAwarded then

									for _, v in ipairs(plrsInGame) do
										local plrData = dataModule.ReturnData(game.Players:FindFirstChild(v))
										local coinsMultiplier = plrData["Multipliers"]["Coins"]
										local baseCoinsMult = plrData["Multipliers"]["BaseCoins"]
										local newCoinsAwarded = tostring(math.floor(coinsAwarded*(coinsMultiplier*baseCoinsMult)))
										dataModule.EditData(game.Players[v], "Coins", newCoinsAwarded, "addition")
										CoinRemote:FireClient(game.Players[v], newCoinsAwarded)
									end
								else
									local diamondsAwarded = gameSettings["Wave"..tostring(wave)]["Diamonds"]
									for _, v in ipairs(plrsInGame) do
										local plrData = dataModule.ReturnData(game.Players:FindFirstChild(v))
										local diamondsMultiplier = plrData["Multipliers"]["Diamonds"]
										local baseDiamondsMult = plrData["Multipliers"]["BaseDiamonds"]
										local newDiamondsAwarded = tostring(math.floor(diamondsAwarded*(diamondsMultiplier*baseDiamondsMult)))
										dataModule.EditData(game.Players[v], "Diamonds", newDiamondsAwarded, "addition")
										DiamondRemote:FireClient(game.Players[v], newDiamondsAwarded)
									end
								end
								for _, v in ipairs(plrsInGame) do
									local plrData = dataModule.ReturnData(game.Players[v])
									for _, value in pairs(capturesInfo) do

										if wave == value["WaveToBeat"] and not table.find(plrData["Captures"]["Unequipped"], value["Name"]) and not table.find(plrData["Captures"]["Equipped"], value["Name"]) then
											table.insert(plrData["Captures"]["Unequipped"], value["Name"])
											captureNoticiationRE:FireClient(game.Players[v])

										end
									end
								end



								if gameSettings["Wave"..tostring(wave)]["Coins"] then
									local Coin = SS:WaitForChild("GameItems"):WaitForChild("CoinEmmiter"):Clone()
									Coin.Position = Vector3.new(value.HumanoidRootPart.Position.X, 1, value.HumanoidRootPart.Position.Z)
									Coin.Parent = workspace
									value:Destroy()
									local pe = Coin.ParticleEmitter
									local COIN_SOUND = game:GetService("ReplicatedStorage"):WaitForChild("Sounds"):WaitForChild("CoinSoundEffect")
									local coinSound = COIN_SOUND:Clone()
									coinSound.Parent = Coin
									coinSound:Play()

									pe.Enabled = true
									wait(.25)
									pe.Enabled = false
									wait(1.5)
								else
									local Diamond = SS:WaitForChild("GameItems"):WaitForChild("DiamondEmmiter"):Clone()
									Diamond.Position = Vector3.new(value.HumanoidRootPart.Position.X, 1, value.HumanoidRootPart.Position.Z)
									Diamond.Parent = workspace
									value:Destroy()
									local pe = Diamond.ParticleEmitter
									local Diamond_SOUND = game:GetService("ReplicatedStorage"):WaitForChild("Sounds"):WaitForChild("DiamondSound")
									local diamondSound = Diamond_SOUND:Clone()
									diamondSound.Parent = Diamond
									diamondSound:Play()

									pe.Enabled = true
									wait(.25)
									pe.Enabled = false
									wait(1.5)
								end
								local maxWave = gameSettings["MaxWave"]
								if wave == maxWave then
									for _, v in ipairs(plrsInGame) do
										gameRE:FireClient(game.Players[v], wave+1, nil, nil, nil,true)
										game.Players[v].Character.HumanoidRootPart.CFrame = workspace.SpawnPosition.CFrame
										endGame()
									end				
								else
									wave = wave + 1
									loadWave("Wave"..tostring(wave))	
								end

							else
								value:Destroy()
							end
						end
					end
					for _, v in ipairs(plrsInGame) do
						local plr = game.Players:FindFirstChild(v)
						if plr then
							local char = plr.Character
							local humanoid = char:FindFirstChild("Humanoid")
							if humanoid.Health == 0 then
								local plrToRemove = table.find(plrsInGame, v)
								if plrToRemove then

									gameRE:FireClient(plr, nil, nil, nil, true)
									table.remove(plrsInGame, plrToRemove)

									if #plrsInGame == 0 then
										stopCrashing = true
										endGame()
										coroutine.yield()
									end
								end	

							end
						end
					end
				end
				--check if any players leave
				game:GetService("Players").PlayerRemoving:Connect(function(player)
					local isPlrInGame = table.find(plrsInGame, player.Name)
					if isPlrInGame then
						table.remove(plrsInGame, isPlrInGame)
						if #plrsInGame == 0  then
							stopCrashing = true
							endGame()
							coroutine.yield()
						end
					end
				end)
				wait(.25)
			end
		end)
		checkForDeadHumanoid()
		
		

		local function spawnEnemies(enemiesToSpawn)
			local section = workspace["Bays"][bay]["Section"..tostring(bayInformation[bay]["ActiveSection"])]
			if #section.Enemies:GetChildren() ~= 0 then
				for _, v in ipairs(section.Enemies:GetChildren()) do
					v:Destroy()
				end
			end
			
			local function setWaveTheme(waveThemeNumber)
				local waveModel = WaveThemesTbl[waveThemeNumber]
				local waveModelClone = waveModel:Clone()
				local activeSectionModel = section
				waveModelClone.Name = activeSectionModel.Name
				activeSectionModel.Name = "old"
				local cframeToTP = activeSectionModel.PrimaryPart.CFrame
				waveModelClone.Parent = activeSectionModel.Parent

				waveModelClone:SetPrimaryPartCFrame(cframeToTP)
				activeSectionModel:Destroy()
				section = workspace["Bays"][bay]["Section"..tostring(bayInformation[bay]["ActiveSection"])]
			end
			
			if wave/wavesPerTheme <= 1 then
				setWaveTheme(1)
			elseif wave/wavesPerTheme <=2 then
				setWaveTheme(2)
			elseif wave/wavesPerTheme <=3 then
				setWaveTheme(3)
			elseif wave/wavesPerTheme <=4 then
				setWaveTheme(4)
			end
			
			local waveDisplay = section.WaveDisplay
			waveDisplay.SurfaceGui.WaveNum.Text = tostring(wave)
			
			
			for _, enemyType in pairs (enemiesToSpawn) do	
				if gameEnded == false then
					local enemyToSpawn = enemyType["Name"]
					local startingNum = 1
					for i = startingNum, enemyType["Number"], 1 do
						if gameEnded == false then
							if enemiesSpawnedInGroup < 6 then
								enemiesSpawnedInGroup = enemiesSpawnedInGroup + 1
							else 
								enemiesSpawnedInGroup = 1
								wait(2)
							end

							local enemyToClone = SS:WaitForChild("EnemiesStorage"):FindFirstChild(enemyType["Name"])
							local clonedEnemy = enemyToClone:Clone()


							local cframeToTP = section.EnemySpawns["Spawn"..tostring(enemiesSpawnedInGroup)].CFrame

							clonedEnemy.Parent = section.Enemies
							clonedEnemy.HumanoidRootPart.CFrame = cframeToTP
							local currentWave = "Wave"..tostring(bayInformation[bay]["Wave"])

							local cloneHealth = gameSettings["EnemyInfo"][clonedEnemy.Name]["Health"]
							clonedEnemy.Head.BillboardGui.Frame.Health.Text = tostring(cloneHealth).."/"..tostring(cloneHealth)
							clonedEnemy.Humanoid.MaxHealth = cloneHealth
							clonedEnemy.Humanoid.Health = cloneHealth


							table.insert(enemiesInWave, clonedEnemy)
							
							
						else
							for _, v in ipairs(section.Enemies:GetChildren()) do
								v:Destroy()
							end
						end	
					end	
				end				
			end
		end

		loadWave = function(waveToLoad)	
			if waveToLoad then
				

				local activeSection = bayInformation[bay]["ActiveSection"]
				local section = workspace["Bays"][bay]["Section"..tostring(activeSection)]

				for i = 1, #plrsInGame, 1 do
					local posToTeleport = section.PlayerSpawns["Spawn"..tostring(i)]
					game.Players[plrsInGame[i]].Character.HumanoidRootPart.CFrame = CFrame.new(posToTeleport.Position)
				end
				maxEnemies = gameSettings[waveToLoad]["NumEnemiesToKill"]
				for _, v in ipairs(plrsInGame) do
					local player = game.Players:FindFirstChild(v)

					--Value False = start game True = Edit Info

					gameRE:FireClient(player, wave, maxEnemies, nil, nil, nil,bay, bayInformation[bay]["ActiveSection"])
					
					
				end
				coroutine.resume(coroutine.create(spawnEnemies),gameSettings[waveToLoad]["Enemies"])
			end
		end


		local waveToLoad = "Wave"..tostring(bayInformation[bay]["Wave"])
		loadWave(waveToLoad)
	end)
	gameThread()
end

startGameBE.Event:Connect(function(plrsInGame, waveToStartAt)
	local bayFound = false
	for number, v in ipairs(bayAvailability) do
		if bayFound == false then
			if v == false then
				bayFound = true
				bayAvailability[number] = true
				local bayChosen = "Bay"..tostring(number)
				for index, plr in ipairs(plrsInGame) do
					table.insert(bayInformation["Bay"..tostring(number)]["Players"], plr)
				end

				bayInformation["Bay"..tostring(number)]["Wave"] = waveToStartAt

				local maxEnemies = gameSettings["Wave"..tostring(bayInformation[bayChosen]["Wave"])]["NumEnemiesToKill"]
				local wave = bayInformation[bayChosen]["Wave"]

				initialiseGame(bayChosen, plrsInGame)
			end
		end	
	end
end)
