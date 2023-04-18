local icons = script.Parent.Parent.Parent:WaitForChild("DefaultIcons"):WaitForChild("Frame")
local openButton = icons.Shop
local shopFr = script.Parent
local otherMenuInteractives = script.Parent.Parent:GetChildren()
local exitButton = shopFr.Exit
local RS = game:GetService("ReplicatedStorage")
local gamepassBoughtRE = RS:WaitForChild("InventoryRemotes"):WaitForChild("gamepassBoughtRE")

openButton.MouseButton1Up:Connect(function()
	openButton.ExclamationMark.Visible = false
	if shopFr.Visible == true then
		shopFr.Visible = false
		local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
		hpXpTrackers.Enabled = true
	else
		for _, v in ipairs(otherMenuInteractives) do
			if v.Name ~= "Shop" then
				v.Visible = false
			else
				shopFr.Visible = true
				local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
				hpXpTrackers.Enabled = false
			end 
		end
	end
end)

exitButton.MouseButton1Up:Connect(function()
	shopFr.Visible = false
	local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
	hpXpTrackers.Enabled = true
end)

local RS = game:GetService("ReplicatedStorage")
local flamethrowerModel = RS:WaitForChild("GunModels"):WaitForChild("Flamethrower")
local RPGmodel = RS:WaitForChild("GunModels"):WaitForChild("RPG"):Clone()
local flamethrowerDisplay = script.Parent.ExclusiveFrame.Flamethrower.Display
local rpgDisplay = script.Parent.ExclusiveFrame.RPG.Display
local Module3d = require(RS:WaitForChild("Module3D"))

local flameModel = Module3d:Attach3D(flamethrowerDisplay, flamethrowerModel)
flameModel:SetDepthMultiplier(.55)
flameModel:SetCFrame(CFrame.Angles(0,math.rad(90),math.rad(-30)))
flameModel.Visible = true

local rpgModel = Module3d:Attach3D(rpgDisplay, RPGmodel)
rpgModel:SetDepthMultiplier(.6)
rpgModel:SetCFrame(CFrame.Angles(0,math.rad(90),math.rad(-30)))
rpgModel.Visible = true

local btnNormalColours = {
	["Exclusive"] = Color3.fromRGB(85, 0, 127),
	["GamePass"] = Color3.fromRGB(170, 0, 0),
	["Diamonds"] = Color3.fromRGB(0, 85, 255),
	["Coins"] = Color3.fromRGB(255, 170, 0),
}
local btnSelectedColours = {
	["Exclusive"] = Color3.fromRGB(41, 0, 61),
	["GamePass"] = Color3.fromRGB(98, 0, 0),
	["Diamonds"] = Color3.fromRGB(0, 45, 135),
	["Coins"] = Color3.fromRGB(140, 93, 0),
}

local shopMenuBtns = script.Parent.ShopMenuBtns

for _, v in ipairs(shopMenuBtns:GetChildren()) do
	if v:IsA("TextButton") then
		v.MouseButton1Up:Connect(function()
			v.BackgroundColor3 = btnSelectedColours[v.Name]
			for _, value in ipairs(shopMenuBtns:GetChildren()) do
				if value.Name ~= v.Name and value:IsA("TextButton") then
					value.BackgroundColor3 = btnNormalColours[value.Name]
				end
			end			
			for _, frame in ipairs(script.Parent:GetChildren()) do
				if frame:IsA("Frame") and frame.Name ~= "ShopMenuBtns" then
					if frame.Name:match(v.Name) then
						frame.Visible = true
					else
						frame.Visible = false
					end			
				end
			end
		end)
	end
end

local diamondsDevProductIds = {
	["Diamondsx50"] = 1507451049, 
	["Diamondsx200"] = 1507451289, 
	["Diamondsx600"] = 1507451416, 
	["Diamondsx1500"] = 1507451530, 
	["Diamondsx6000"] = 1507451685, 
	["Diamondsx20000"] = 1507451821, 
}

local DiamondsFrame = shopFr.DiamondsFrame
local MarketplaceService = game:GetService("MarketplaceService")
local player = game.Players.LocalPlayer

for _, v in ipairs(DiamondsFrame.ScrollingFrame:GetChildren()) do
	if v:IsA("Frame") then
		v.BuyBtn.MouseButton1Up:Connect(function()
			local productId = diamondsDevProductIds[v.Name]
			MarketplaceService:PromptProductPurchase(player, productId)
		end)
	end
end

local coinsFrame = shopFr:WaitForChild('CoinsFrame')
local buyCoinsRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("buyCoinsRF")
local successUI = script.Parent.Parent.Parent:WaitForChild("SuccessUI")
local errorUI = script.Parent.Parent.Parent:WaitForChild("ErrorUI")

local debounce = false

for _, v in ipairs(coinsFrame.ScrollingFrame:GetChildren()) do
	if v :IsA("Frame") then
		v.BuyBtn.MouseButton1Up:Connect(function()
			if debounce == false then
				debounce = true
				local buyCoinsRequest, errormessage = buyCoinsRF:InvokeServer(v.Name)
				if buyCoinsRequest == true then
					successUI:WaitForChild("SuccessFrame").Visible = true
					successUI:WaitForChild("SuccessFrame").SuccessMessage.Text = "Success!"
					wait(1)
					successUI:WaitForChild("SuccessFrame").Visible = false
				else
					errorUI:WaitForChild("ErrorFrame").Visible = true
					errorUI:WaitForChild("ErrorFrame").ErrorText.Text = errormessage
					wait(1)
					errorUI:WaitForChild("ErrorFrame").Visible = false
				end
				debounce = false
			end
		end)
	end
end

local gamePassIds = {
	["+100PetStorage"] = 154154230, 
	["+2PetEquip"] = 154152603, 
	["+40PetStorage"] = 154153868, 
	["+4PetEquip"] = 154152858, 
	["Open3"] = 154151056, 
	["x2Coins"] = 154150375, 
	["x2Diamonds"] = 154150842, 
	["x2EXP"] = 154150668, 
	["x5Luck"] = 154153570,
}

local gamePassFrame = shopFr.GamePassFrame
local testingRF = RS:WaitForChild("TestingRF")
local debounce = false

for _, v in ipairs(gamePassFrame.ScrollingFrame:GetChildren()) do
	if v:IsA("Frame") then
		v.BuyBtn.MouseButton1Up:Connect(function()
			local productId = gamePassIds[v.Name]
			MarketplaceService:PromptGamePassPurchase(player, productId)
			
			--[[
			testingRF:InvokeServer(productId)
			]]
		end)
	end
end

local exclusiveFrame = script.Parent.ExclusiveFrame

exclusiveFrame.Flamethrower.BuyBtn.MouseButton1Up:Connect(function()
	local productId = 154149002
	MarketplaceService:PromptGamePassPurchase(player, productId)
end)
exclusiveFrame.RPG.BuyBtn.MouseButton1Up:Connect(function()
	local productId = 154148642
	MarketplaceService:PromptGamePassPurchase(player, productId)
end)

local updateGamepassesOwnedRE = RS:WaitForChild("InventoryRemotes"):WaitForChild("updateGamepassesOwnedRE")

updateGamepassesOwnedRE.OnClientEvent:Connect(function(gamepasses)
	for gamepass, isOwned in pairs(gamepasses) do
		if isOwned == true then
			if gamepass ~= "RPG" and gamepass ~= "Flamethrower" then
				local frame = gamePassFrame.ScrollingFrame[gamepass]
				if frame then
					frame.Owned.Visible = true
					frame.BuyBtn.Visible = false
				end
			else
				local frame = exclusiveFrame[gamepass]
				if frame then
					frame.Owned.Visible = true
					frame.BuyBtn.Visible = false
				end
			end
		end
	end
end)

gamepassBoughtRE.OnClientEvent:Connect(function(gamepassName)
	if gamepassName ~= "RPG" and gamepassName ~="Flamethrower" then
		local gamepassFrame = script.Parent.GamePassFrame.ScrollingFrame:FindFirstChild(gamepassName)
		if gamepassFrame then
			gamepassFrame.Owned.Visible = true
			gamepassFrame.BuyBtn.Visibe = false
		end
	else
		local frame = script.Parent.ExclusiveFrame:FindFirstChild(gamepassName)
		if frame then
			frame.Owned.Visible = true
			frame.BuyBtn.Visibe = false
		end
	end
	
end)