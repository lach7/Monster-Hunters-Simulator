local MarketplaceService = game:GetService("MarketplaceService")
local player = game.Players.LocalPlayer

local ids = {
	["10R$"] = 1508689897,
	["50R$"] = 1507454242,
	["300R$"] = 1507453462,
	["1500R$"] = 1508695913,
}

local donationsFrame = script.Parent
local background = donationsFrame.Background

for _, v in ipairs(background:GetChildren()) do
	if v:IsA("TextButton") then
		v.MouseButton1Up:Connect(function()
			local productId = ids[v.Name]
			if productId then
				MarketplaceService:PromptProductPurchase(player, productId)
			end
		end)
	end
end

player:WaitForChild("PlayerGui"):WaitForChild("DonationBillboardGui"):WaitForChild("TextButton").MouseButton1Up:Connect(function()
	donationsFrame.Visible = not donationsFrame.Visible
end)

script.Parent.Exit.MouseButton1Up:Connect(function()
	donationsFrame.Visible = false
end)