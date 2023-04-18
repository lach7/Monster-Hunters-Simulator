local codesActivationPart = workspace.CodeActivationPart
local player = game.Players.LocalPlayer
local codesFrame = script.Parent
local debounce = false
local debounce2 = false

codesActivationPart.Touched:Connect(function(part)
	if part.Parent:FindFirstChild("Humanoid") and debounce == false and debounce2 == false then
		if game.Players:GetPlayerFromCharacter(part.Parent) == player then
			if codesFrame.Visible == false then
				debounce = true
				local pos = codesFrame.Position
				codesFrame.Visible = true

				codesFrame.Position = pos - UDim2.new(0,0,1,0)
				local position1 = {
					Position = pos
				}
				local position2 = {
					Position = pos - UDim2.new(0,0,1,0)
				}
				local TI = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)
				local TS = game:GetService("TweenService")
				local tween1 = TS:Create(codesFrame, TI, position1)
				local tween2 = TS:Create(codesFrame, TI, position2)

				tween1:Play()
				codesFrame.Visible = true
				wait(1)
				debounce = false
			end
		end
	end
end)

local codeRedeemRequestRF = game:GetService("ReplicatedStorage"):WaitForChild("InventoryRemotes"):WaitForChild("codeRedeemRequest")
local successFrame = game.Players.LocalPlayer.PlayerGui:WaitForChild("SuccessUI"):WaitForChild("SuccessFrame")
local errorFrame = game.Players.LocalPlayer.PlayerGui:WaitForChild("ErrorUI"):WaitForChild("ErrorFrame")
script.Parent.Enter.MouseButton1Up:Connect(function()
	local textInputted = script.Parent.Background.EnterCodeBackground.EnterCodeBackground.TextBox.Text
	if textInputted then
		local codeRedeemRequest, successMessage,errorMessage = codeRedeemRequestRF:InvokeServer(textInputted)
		if codeRedeemRequest == true then
			script.Parent.Background.EnterCodeBackground.EnterCodeBackground.TextBox.Text = ""
			
			successFrame.SuccessMessage.Text = successMessage
			successFrame.Visible = true
			wait(1)
			successFrame.Visible = false
		else
			script.Parent.Background.EnterCodeBackground.EnterCodeBackground.TextBox.Text = ""

			errorFrame.ErrorText.Text = errorMessage
			errorFrame.Visible = true
			wait(1)
			errorFrame.Visible = false
		end
	end
end)

script.Parent.Exit.MouseButton1Up:Connect(function()
	codesFrame.Visible = false
	script.Parent.Background.EnterCodeBackground.EnterCodeBackground.TextBox.Text = ""
end)



