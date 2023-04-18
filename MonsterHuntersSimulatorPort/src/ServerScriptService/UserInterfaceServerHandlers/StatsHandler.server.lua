local SSS = game:GetService("ServerScriptService")
local RS = game:GetService("ReplicatedStorage")
local spendPointsRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("spendPointsRf")
local dataModule = require(SSS:WaitForChild("Data"):WaitForChild("DataModule"))
local loadHealthSpeedRE = RS:WaitForChild("InventoryRemotes"):WaitForChild("loadHealthSpeed")

spendPointsRF.OnServerInvoke = function(player, category)
	local plrData = dataModule.ReturnData(player)
	local plrPoints = plrData["Points"]
	
	if plrPoints >= 1 then
		local multiplier = plrData["Multipliers"][category]
		multiplier += 0.02
		plrData["Multipliers"][category] = multiplier
		plrData["Points"] -= 1
		local newPoints = plrData["Points"]
		local baseNum = plrData["Multipliers"]["Base"..category]
		if baseNum then
			baseNum = baseNum * multiplier
		end
		plrData["Multipliers"]["Points"..category] += 0.02
		
		if category == "Health" then
			local defaultHealth = plrData["Defaults"]["Health"]
			local baseHealthMult = plrData["Multipliers"]["BaseHealth"]
			local healthMultiplier = plrData["Multipliers"]["Health"]
			local totalMult = baseHealthMult * healthMultiplier
			local newHealth = defaultHealth * totalMult
			player.Character:WaitForChild("Humanoid").MaxHealth = newHealth
			player.Character:WaitForChild("Humanoid").Health += 2
		elseif category == "Speed" then
			local defaultSpeed = plrData["Defaults"]["Speed"]
			local baseSpeedMult = plrData["Multipliers"]["BaseSpeed"]
			local speedMultiplier = plrData["Multipliers"]["Speed"]
			local totalMult = baseSpeedMult * speedMultiplier
			local newSpeed = defaultSpeed * totalMult
			player.Character:WaitForChild("Humanoid").WalkSpeed = newSpeed
			local speedValueForGuns = player.Character:WaitForChild("SpeedValueForGuns")
			speedValueForGuns.Value = newSpeed
		end
		
		return true, nil, multiplier, newPoints, baseNum
	else
		return false, "Insufficient points"
	end
end

local function loadHealthSpeed(player)
	local plrData = dataModule.ReturnData(player)
	if plrData then
		local defaultHealth = plrData["Defaults"]["Health"]
		local baseHealthMult = plrData["Multipliers"]["BaseHealth"]
		local healthMultiplier = plrData["Multipliers"]["Health"]
		local totalMult = baseHealthMult * healthMultiplier
		local newHealth = defaultHealth * totalMult
		player.Character:WaitForChild("Humanoid").MaxHealth = newHealth
		player.Character:WaitForChild("Humanoid").Health = newHealth


		local defaultSpeed = plrData["Defaults"]["Speed"]
		local baseSpeedMult = plrData["Multipliers"]["BaseSpeed"]
		local speedMultiplier = plrData["Multipliers"]["Speed"]
		local totalMult = baseSpeedMult * speedMultiplier
		local newSpeed = defaultSpeed * totalMult
		player.Character:WaitForChild("Humanoid").WalkSpeed = newSpeed
		if not player.Character:FindFirstChild("SpeedValueForGuns") then
			local speedValueForGuns = Instance.new("IntValue")
			speedValueForGuns.Value = newSpeed
			speedValueForGuns.Parent = player.Character
			speedValueForGuns.Name = "SpeedValueForGuns"
		else
			player.Character:FindFirstChild("SpeedValueForGuns").Value = newSpeed
		end
		
	end
end

loadHealthSpeedRE.OnServerEvent:Connect(function(player)
	loadHealthSpeed(player)
end)

local resetRequestRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("resetRequestRF")

resetRequestRF.OnServerInvoke = function(player)
	local plrData = dataModule.ReturnData(player)
	local plrDiamonds = plrData["Diamonds"]
	local resetCost = 200
	if plrDiamonds >= resetCost then
		local pointsToRefund = 0
		for key, v in pairs(plrData["Multipliers"]) do
			if key:match("Points") then
				if v > 0 then
					local oldPointsMult = plrData["Multipliers"][key]
					print(oldPointsMult)
					local newstring, replaced = string.gsub(key, "Points", "")
					plrData["Multipliers"][newstring] = plrData["Multipliers"][newstring]/(oldPointsMult+1)
					local multiplierIncriments = 0.02
					pointsToRefund += v/multiplierIncriments
					plrData["Multipliers"][key] = 0
				end				
			end
		end
		print(plrData["Multipliers"])
		plrData["Points"] += math.floor(pointsToRefund)
		dataModule.EditData(player, "Diamonds", resetCost, "subtraction")
		loadHealthSpeed(player)
		return true, math.floor(pointsToRefund)
	else
		return false, nil, "Insufficient Diamonds"
	end
end


