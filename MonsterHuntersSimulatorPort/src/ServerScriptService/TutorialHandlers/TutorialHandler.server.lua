local SSS = game:GetService("ServerScriptService")
local dataModule = require(SSS:WaitForChild("Data"):WaitForChild("DataModule"))
local RS = game:GetService("ReplicatedStorage")
local tutorialFolder = RS:WaitForChild("Tutorial")
local startTutorialRE = tutorialFolder:WaitForChild("StartTutorialRE")
local stagesRE = RS:WaitForChild("Tutorial"):WaitForChild("StagesRE")

local tutorialInfo = require(game:GetService("ReplicatedStorage"):WaitForChild("Tutorial"):WaitForChild("tutorialInfo"))
local tutorialPlayerStartedGameBE = game:GetService("ServerStorage"):WaitForChild("TutorialPlayerStartedGameBE")

local function stage9(player)
	local checkGuns = coroutine.wrap(function(player)
		local bool = false
		while bool == false do
			local plrData = dataModule.ReturnData(player)
			repeat
				plrData = dataModule.ReturnData(player)
				wait()
			until plrData ~= nil
			if plrData["Tutorial"]["HasCompleted"] == false then
				if #plrData["Guns"]["Unequipped"] > 0 then
					stagesRE:FireClient(player, nil, true)
					plrData["Tutorial"]["HasCompleted"] = true
					bool = true
				end
			else
				bool = true
			end
			
			wait()
		end
	end)
	checkGuns(player)
end

local function stage8(player)
	local checkCoins = coroutine.wrap(function(player)
		local bool = false
		while bool == false do
			local plrData = dataModule.ReturnData(player)
			repeat
				plrData = dataModule.ReturnData(player)
				wait()
			until plrData ~= nil
			if plrData["Tutorial"]["HasCompleted"] == false then
				if plrData["Coins"] >= 250 then
					stagesRE:FireClient(player, 9)
					stage9(player)
					plrData["Tutorial"]["Stage"] = 9
					bool = true
				end
			else
				bool = true
			end
			
			wait()
		end
	end)
	checkCoins(player)
end

local function stage7(player)
	local checkStats = coroutine.wrap(function(player)
		local bool = false
		while bool == false do
			local plrData = dataModule.ReturnData(player)
			repeat
				plrData = dataModule.ReturnData(player)
				wait()
			until plrData ~= nil
			if plrData["Tutorial"]["HasCompleted"] == false then
				for key, v in pairs(plrData["Multipliers"]) do
					if key:match("Points") then
						if v > 0 then
							stagesRE:FireClient(player, 8)
							plrData["Tutorial"]["Stage"] = 8
							stage8(player)
							bool = true
						end
					end
				end
			else
				bool = true
			end
			
			wait()
		end
	end)
	checkStats(player)
end

local function stage6(player)
	local checkLevel = coroutine.wrap(function(player)
		local bool = false
		while bool == false do
			local plrData = dataModule.ReturnData(player)
			repeat
				plrData = dataModule.ReturnData(player)
				wait()
			until plrData ~= nil
			if plrData["Tutorial"]["HasCompleted"] == false then
				if plrData["Level"] >= 4 then
					stagesRE:FireClient(player, 7)
					plrData["Tutorial"]["Stage"] = 7
					stage7(player)
					bool = true
				end
			else
				bool = true
			end
			
			wait()
		end
	end)
	checkLevel(player)
end

local function stage5(player)
	local checkPetEquip = coroutine.wrap(function(player)
		local bool = false
		while bool == false do
			local plrData = dataModule.ReturnData(player)
			repeat
				plrData = dataModule.ReturnData(player)
				wait()
			until plrData ~= nil
			if plrData["Tutorial"]["HasCompleted"] == false then
				if #plrData["Pets"]["Equipped"] > 0 then
					stagesRE:FireClient(player, 6)
					plrData["Tutorial"]["Stage"] = 6
					stage6(player)
					bool = true
				end
			else
				bool = true
			end
			
			wait()
		end
	end)
	checkPetEquip(player)
end

local function stage4(player)
	local checkPetBought = coroutine.wrap(function()
		local bool = false
		while bool == false do
			local plrData = dataModule.ReturnData(player)
			repeat
				plrData = dataModule.ReturnData(player)
				wait()
			until plrData ~= nil
			if plrData["Tutorial"]["HasCompleted"] == false then
				if #plrData["Pets"]["Unequipped"] > 0 then
					stagesRE:FireClient(player, 5)
					plrData["Tutorial"]["Stage"] = 5
					stage5(player)
					bool = true
				end
			else
				 bool = true
			end
			
			wait()
		end
	end)
	checkPetBought()
end

local function stage3(player)
	local checkCoins = coroutine.wrap(function(player)
		local bool = false
		while bool == false do
			local plrData = dataModule.ReturnData(player)
			repeat
				plrData = dataModule.ReturnData(player)
				wait()
			until plrData ~= nil
			if plrData["Tutorial"]["HasCompleted"] == false then
				if plrData["Coins"] >= 50 then
					stagesRE:FireClient(player, 4)
					plrData["Tutorial"]["Stage"] = 4
					stage4(player)
					bool = true
				end
			else
				bool = true
			end
			
			wait()
		end
	end)
	checkCoins(player)
end

local function stage2(player)
	local checkFor3Kills = coroutine.wrap(function(player)
		print(player)
		local bool = false
		while bool == false do
			local plrData = dataModule.ReturnData(player)
			repeat
				plrData = dataModule.ReturnData(player)
				wait()
			until plrData ~= nil
			if plrData["Tutorial"]["HasCompleted"] == false then
				stagesRE:FireClient(player, 2)
				plrData["Tutorial"]["Stage"] = 2
				if plrData["Kills"] >= 3 then
					stagesRE:FireClient(player, 3)
					plrData["Tutorial"]["Stage"] = 3
					stage3(player)
					bool = true
				end
			else
				bool = true
			end
			
			wait()
		end
	end)
	checkFor3Kills(player)
end

local function stage1(player, stage)
	if stage == 1 then
		stage1(player)
	elseif stage == 2 then
		stage2(player)
	elseif stage == 3 then
		stage3(player)
	elseif stage == 4 then
		stage4(player)
	elseif stage == 5 then
		stage5(player)
	elseif stage == 6 then
		stage6(player)
	elseif stage == 7 then
		stage7(player)
	elseif stage == 8 then
		stage8(player)
	elseif stage == 9 then
		stage9(player)
	end
end

tutorialPlayerStartedGameBE.Event:Connect(function(player)
	stage1(player, 2)
end)

game.Players.PlayerAdded:Connect(function(player)
	local plrData = dataModule.ReturnData(player)
	repeat 
		wait() 
		plrData = dataModule.ReturnData(player)
	until plrData ~= nil
	if plrData["Tutorial"]["HasCompleted"] == false then
		startTutorialRE:FireClient(player, plrData["Tutorial"]["Stage"])
		stage1(player, plrData["Tutorial"]["Stage"])
	end
end)

local skipTutorialRE = RS:WaitForChild('Tutorial'):WaitForChild("skipTutorialRE")
skipTutorialRE.OnServerEvent:Connect(function(player)
	local plrData = dataModule.ReturnData(player)
	plrData["Tutorial"]["HasCompleted"] = true
end)

