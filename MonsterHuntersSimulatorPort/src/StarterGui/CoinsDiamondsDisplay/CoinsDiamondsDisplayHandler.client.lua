local RS = game:GetService("ReplicatedStorage")
local coinsRemote = RS:WaitForChild("CoinsDiamondsDisplayRemotes"):WaitForChild("CoinsRemote")
local diamondsRemote = RS:WaitForChild("CoinsDiamondsDisplayRemotes"):WaitForChild("DiamondsRemote")

local coinsLbl = script.Parent.MainFrame.Coins.Background.Coinslbl
local diamondslbl = script.Parent.MainFrame.Diamonds.Background.Diamondslbl

coinsRemote.OnClientEvent:Connect(function(newText, isAbleToAffordNewGun)
	coinsLbl.Text = newText
	if isAbleToAffordNewGun == true then
		game.Players.LocalPlayer.PlayerGui:WaitForChild("DefaultIcons").Frame.Guns.ExclamationMark.Visible = true
	end
end)

diamondsRemote.OnClientEvent:Connect(function(newText)
	diamondslbl.Text = newText
end)

local buyCoinsBtn = script.Parent.MainFrame.Coins.Background.BuyCoins
local buyDiamondsBtn = script.Parent.MainFrame.Diamonds.Background.BuyDiamonds
local shopFrame = game.Players.LocalPlayer.PlayerGui:WaitForChild("MenuInteractives").Shop
buyCoinsBtn.MouseButton1Up:Connect(function()
	shopFrame.Visible = true
	shopFrame.DiamondsFrame.Visible = false
	shopFrame.CoinsFrame.Visible = true
end)
buyDiamondsBtn.MouseButton1Up:Connect(function()
	shopFrame.Visible = true
	shopFrame.CoinsFrame.Visible = false
	shopFrame.DiamondsFrame.Visible = true
end)
