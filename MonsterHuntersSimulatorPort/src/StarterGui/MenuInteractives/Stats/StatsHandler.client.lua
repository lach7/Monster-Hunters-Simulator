local icons = script.Parent.Parent.Parent:WaitForChild("DefaultIcons"):WaitForChild("Frame")
local openButton = icons.Stats
local statsFr = script.Parent
local otherMenuInteractives = script.Parent.Parent:GetChildren()
local exitButton = script.Parent.Exit
local RS = game:GetService("ReplicatedStorage")
local getDataRF = RS:WaitForChild("Data"):WaitForChild("GetData")
local backgroundFrame = script.Parent.Background
local spendPointsRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("spendPointsRf")
local errorFrame = script.Parent.Parent.Parent:WaitForChild("ErrorUI"):WaitForChild("ErrorFrame")
local loadHealthSpeedRE = RS:WaitForChild("InventoryRemotes"):WaitForChild("loadHealthSpeed")

local function loadStats()
	local plrData = getDataRF:InvokeServer()
	loadHealthSpeedRE:FireServer()
	if plrData then
		local bases = {
			Coins = plrData["Multipliers"]["BaseCoins"],
			Attack = plrData["Multipliers"]["BaseAttack"],
			Health = plrData["Multipliers"]["BaseHealth"],
			Speed = plrData["Multipliers"]["BaseSpeed"],
		}
		local multipliers = {
			Coins = plrData["Multipliers"]["Coins"],
			Attack = plrData["Multipliers"]["Attack"],
			Health = plrData["Multipliers"]["Health"],
			Speed = plrData["Multipliers"]["Speed"],
		}
		local defaults = {
			Coins = plrData["Defaults"]["Coins"],
			Attack = plrData["Defaults"]["Attack"],
			Health = plrData["Defaults"]["Health"],
			Speed = plrData["Defaults"]["Speed"],
		}


		for _, v in ipairs(backgroundFrame:GetChildren()) do
			if v:IsA("Frame") then
				local multiplier = multipliers[v.Name]
				local default = defaults[v.Name]
				local base = bases[v.Name]
				local totalMult = base * multiplier
				if default ~= nil and v.Name ~= "Attack" then
					local total = default * totalMult
					--convert to 2dp
					total *= 100
					total = math.floor(total)
					total = total / 100
					--convert to 2dp
					totalMult *= 100
					totalMult = math.floor(totalMult)
					totalMult = totalMult / 100
					v.Stats.Text = tostring(total).."(x"..tostring(totalMult)..")"
				else
					--convert to 2dp
					totalMult *= 100
					totalMult = math.floor(totalMult)
					totalMult = totalMult / 100
					v.Stats.Text = "x"..tostring(totalMult)
				end
			end
		end

		local plrPoints = plrData["Points"]
		statsFr.Points.Text = "Points: "..tostring(plrPoints)
	end
end

local statsNotfication = game.Players.LocalPlayer.PlayerGui:WaitForChild("DefaultIcons").Frame.Stats.ExclamationMark

openButton.MouseButton1Up:Connect(function()
	if statsFr.Visible == true then
		statsFr.Visible = false
		local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
		hpXpTrackers.Enabled = true
	else
		for _, v in ipairs(otherMenuInteractives) do
			if v.Name ~= "Stats" then
				v.Visible = false
			else
				statsFr.Visible = true
				local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
				hpXpTrackers.Enabled = false
				statsNotfication.Visible = false
				loadStats()
			end 
		end
	end
end)

exitButton.MouseButton1Up:Connect(function()
	statsFr.Visible = false
	local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
	hpXpTrackers.Enabled = true
end)

for _, v in ipairs(statsFr.Background:GetChildren()) do
	if v:IsA("Frame") then
		v.AddBtn.MouseButton1Up:Connect(function()
			local spendPointsRequest, errorMessage, newMult, newPoints, baseNum = spendPointsRF:InvokeServer(v.Name)
			if spendPointsRequest == true then
				loadStats()				
			else
				--not enough points
				errorFrame.Visible = true
				errorFrame.ErrorText.Text = errorMessage
				wait(1)
				errorFrame.Visible = false
			end
		end)
	end
end

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
	loadStats()
end)


local resetRequestRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("resetRequestRF")

script.Parent.Reset.MouseButton1Up:Connect(function()
	script.Parent.Reset.Visible = false
	script.Parent.ConfirmationFrame.Visible = true
end)

script.Parent.ConfirmationFrame.Yes.MouseButton1Up:Connect(function()
	local resetRequest, pointsToRefund,errorMessage = resetRequestRF:InvokeServer()
	if resetRequest == true then
		script.Parent.Reset.Visible = true
		script.Parent.ConfirmationFrame.Visible = false
		loadStats()
	else
		local errorFrame = game.Players.LocalPlayer.PlayerGui:WaitForChild("ErrorUI").ErrorFrame
		errorFrame.ErrorText.Text = errorMessage
		errorFrame.Visible = true
		wait(1)
		errorFrame.Visible = false
	end
end)

script.Parent.ConfirmationFrame.No.MouseButton1Up:Connect(function()
	script.Parent.ConfirmationFrame.Visible = false
	script.Parent.Reset.Visible = true
end)

local gamepassBoughtRE = RS:WaitForChild("InventoryRemotes"):WaitForChild("gamepassBoughtRE")
gamepassBoughtRE.OnClientEvent:Connect(function(gamepassBought)
	loadStats()
end)

local showSatsNotificationRe = RS:WaitForChild("InventoryRemotes"):WaitForChild("showStatsNotificationRE")

showSatsNotificationRe.OnClientEvent:Connect(function()
	statsNotfication.Visible = true
end)

local ids = {
	["Buy10"] = 1510842033,
	["Buy25"] = 1510842212,
	["Buy50"] = 1510842365,
	["Buy100"] = 1510842513,
}

local marketPlaceService = game:GetService("MarketplaceService")

for _, v in ipairs(script.Parent.BuyPointsFrame:GetChildren()) do
	if v:IsA("Frame") then
		v.BuyBtn.MouseButton1Up:Connect(function()
			local productId = ids[v.Name]
			if productId then
				marketPlaceService:PromptProductPurchase(game.Players.LocalPlayer, productId)
			end
		end)
	end
end

local onPointsBoughtWithRobuxRE = RS:WaitForChild("InventoryRemotes"):WaitForChild("onPointsBoughtWithRobux")
onPointsBoughtWithRobuxRE.OnClientEvent:Connect(function()
	loadStats()
end)
 
loadStats()