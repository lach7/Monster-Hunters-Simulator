local animationToPlay = nil
local function loadAnimation()
	local Id = "rbxassetid://8184333464"
	local AnimationNew = Instance.new("Animation")
	AnimationNew.AnimationId = Id
	animationToPlay = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(AnimationNew)
end
game.Players.LocalPlayer.CharacterAdded:Connect(function()
	loadAnimation()
end)
loadAnimation()

script.Parent.Equipped:Connect(function()
	if animationToPlay then
		animationToPlay:Play()
	end
	script.Parent.Unequipped:Connect(function()
		if animationToPlay then
			animationToPlay:Stop()
		end
	end)
end)