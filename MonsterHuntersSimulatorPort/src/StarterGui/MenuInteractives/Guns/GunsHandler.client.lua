local icons = script.Parent.Parent.Parent:WaitForChild("DefaultIcons"):WaitForChild("Frame")
local openButton = icons.Guns
local gunsFr = script.Parent
local otherMenuInteractives = script.Parent.Parent:GetChildren()
local exitButton = gunsFr.Exit
local RS = game:GetService("ReplicatedStorage")
local getGunsInfoRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("getGunsInfoRF")
local sample = script.Parent.Background.Sample
local Module3d = require(RS:WaitForChild('Module3D'))
local gunsFolder = RS:WaitForChild("GunModels")
local runService = game:GetService("RunService")
local convertShortModule = require(RS:WaitForChild("Data"):WaitForChild("ConvertShortModule"))
local equipGunsRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("equipGunRF")
local buyGunRF = RS:WaitForChild("InventoryRemotes"):WaitForChild("buyGunRF")
local errorMessageFrame = game.Players.LocalPlayer.PlayerGui:WaitForChild("ErrorUI"):WaitForChild('ErrorFrame')

local function loadGuns()
	local gunsInfo, plrGunsEquipped, plrGunsUnequipped = getGunsInfoRF:InvokeServer()
	for _, v in ipairs(gunsFr.Background.ScrollingFrame:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end
	
	-- Create a table of gun names
	local gun_names = {}
	for name, gun in pairs(gunsInfo) do
		if name ~= "RPG" and name ~= "Flamethrower" then
			table.insert(gun_names, name)
		end
	end

	-- Define a comparison function that sorts guns by their price
	local function compare_guns_by_price(gun_name1, gun_name2)
		return gunsInfo[gun_name1]["Price"] < gunsInfo[gun_name2]["Price"]
	end

	-- Sort the gun names by price
	table.sort(gun_names, compare_guns_by_price)
	
	for _, v in pairs(gun_names) do
		local newGunFrame = sample:Clone()
		newGunFrame.Name = gunsInfo[v]["Name"]
		newGunFrame.Frame.GunName.Text = gunsInfo[v]["DisplayName"]
		newGunFrame.Frame.Description.Text = gunsInfo[v]["Description"]
		if table.find(plrGunsEquipped, gunsInfo[v]["Name"]) then
		--its equipped
		
			newGunFrame.Equipped.Visible = true
			newGunFrame.BuyButton.Visible = false
			newGunFrame.Equip.Visible = false
		elseif table.find(plrGunsUnequipped, gunsInfo[v]["Name"]) then
			newGunFrame.Equip.Visible = true
			newGunFrame.Equipped.Visible = false
			newGunFrame.BuyButton.Visible = false
		else
			newGunFrame.BuyButton.Visible = true
			newGunFrame.Equipped.Visible = false
			newGunFrame.Equip.Visible = false
			newGunFrame.BuyButton.Price.Text = convertShortModule:ConvertShort(gunsInfo[v]["Price"])
		end
		local gunToDisplay = gunsFolder:FindFirstChild(gunsInfo[v]["Name"]):Clone()
		local gunModel = Module3d:Attach3D(newGunFrame.Frame.Display, gunToDisplay)
		if v == "LMG" then
			gunModel:SetDepthMultiplier(2.6)
		elseif v == "TacticalShotgun" then
			gunModel:SetDepthMultiplier(.9)
		else
			gunModel:SetDepthMultiplier(1.5)
		end
		
		gunModel:SetCFrame(CFrame.Angles(0,math.rad(90),math.rad(-30)))

		newGunFrame.Visible = true
		gunModel.Visible = true
		newGunFrame.Parent = gunsFr.Background.ScrollingFrame
	end	
	
	for _, v in ipairs(gunsFr.Background.ScrollingFrame:GetChildren()) do
		if v:IsA("Frame") then
			v.Equip.MouseButton1Up:Connect(function()
				local gun = v.Name
				local equipResult, errorMessage = equipGunsRF:InvokeServer(gun)
				if equipResult == true then
					loadGuns()
				else
					errorMessageFrame.Visible = true
					errorMessageFrame.ErrorText.Text = errorMessage
					wait(1)
					errorMessageFrame.Visible = false
				end
			end)
			v.BuyButton.MouseButton1Up:Connect(function()
				local gun = v.Name
				local buyResult, errorMessage = buyGunRF:InvokeServer(gun)
				if buyResult == true then
					loadGuns()
				else
					errorMessageFrame.Visible = true
					errorMessageFrame.ErrorText.Text = errorMessage
					wait(1)
					errorMessageFrame.Visible = false
				end
			end)
		end
	end
end

openButton.MouseButton1Up:Connect(function()
	if gunsFr.Visible == true then
		gunsFr.Visible = false
		local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
		hpXpTrackers.Enabled = true
	else
		for _, v in ipairs(otherMenuInteractives) do
			if v.Name ~= "Guns" then
				v.Visible = false
			else
				gunsFr.Visible = true
				local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
				hpXpTrackers.Enabled = false
				loadGuns()
			end 
		end
	end
end)

exitButton.MouseButton1Up:Connect(function()
	gunsFr.Visible = false
	local hpXpTrackers = game.Players.LocalPlayer.PlayerGui:WaitForChild("HPandXPtrackers")
	hpXpTrackers.Enabled = true
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function()
	loadGuns()
end)

wait(1)
loadGuns()
