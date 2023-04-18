local SSS = game:GetService("ServerScriptService")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")
local getCapturesInfoRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("getCapturesInfoRF")
local equipCaptureRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("equipCaptureRF")
local capturesInfoModule = require(SSS:WaitForChild("Modules"):WaitForChild("capturesInfo"))
local dataModule = require(SSS:WaitForChild("Data"):WaitForChild("DataModule"))
local captureToolsFolder = SS:WaitForChild("CaptureTools")

getCapturesInfoRF.OnServerInvoke = function(player)
	local plrData = dataModule.ReturnData(player) 
	if plrData then
		local plrCapturesEquipped = plrData["Captures"]["Equipped"]
		local plrCapturesUnequipped = plrData["Captures"]["Unequipped"]


		for _, v in ipairs(game.Players[player.Name].Backpack:GetChildren()) do
			if capturesInfoModule[v.Name] then
				v:Destroy()
			end
		end

		for _, v in ipairs(game.Players[player.Name].Character:GetChildren()) do
			if v:IsA("Tool") then
				if capturesInfoModule[v.Name] then
					v:Destroy()
				end
			end
		end

		for _, v in ipairs(plrCapturesEquipped) do
			local capture = captureToolsFolder:FindFirstChild(v):Clone()
			capture.Parent = game.Players[player.Name].Backpack
		end

		return capturesInfoModule, plrCapturesEquipped, plrCapturesUnequipped
	end
end

equipCaptureRF.OnServerInvoke = function(player, captureName)
	local plrData = dataModule.ReturnData(player)
	local oldEquipped = plrData["Captures"]["Equipped"]
	table.insert(plrData["Captures"]["Unequipped"], oldEquipped[1])
	plrData["Captures"]["Equipped"] = {captureName}
	return true
end
