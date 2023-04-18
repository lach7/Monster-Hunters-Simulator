local Rocket = script.Parent
local Touched = true

script.Parent.Touched:Connect(function()
	script.Parent.Transparency = 1
	script.Parent.Anchored = true
	local OldPosition = Rocket.Position
	local ownerShipValue = Instance.new("StringValue")
	ownerShipValue.Value = script.Parent.Ownership.Value
	
	ownerShipValue.Name = "Ownership"
	Rocket:Destroy()
	
	if Touched == true then
		Touched = false
		-- Explosion system:
		local TweenService = game:GetService("TweenService")

		local Explode = game.ReplicatedStorage.Shooting.Explode:Clone()
		Explode.BrickColor = BrickColor.new("Bright orange")
		Explode.Parent = game.Workspace
		Explode.Position = OldPosition
		Rocket:Destroy()


		local TweenInformation = TweenInfo.new(0.2, Enum.EasingStyle.Linear,Enum.EasingDirection.InOut)
		local TweenGoal = {Size = Vector3.new(24.692, 24.692, 24.692)}
		local TweenAnimation = TweenService:Create(Explode, TweenInformation, TweenGoal)
		TweenAnimation:Play()
		local Ring = game.ReplicatedStorage.Shooting.SmokeRingExplode:Clone()
		ownerShipValue.Parent = Ring
		Ring.Damage.Value = 1000
		Ring.Parent = game.Workspace
		Ring.Position = Explode.Position
		Ring.Explode:Play()
		local Outburn = game.ReplicatedStorage.Shooting.Outburn:Clone()
		local Outburn2 = game.ReplicatedStorage.Shooting.Outburn2:Clone()
		Outburn2.Parent = game.Workspace
		Outburn.Parent = game.Workspace

		Outburn2.Position = Explode.Position
		Outburn.Position = Explode.Position
		local TweenInformation2 = TweenInfo.new(0.5, Enum.EasingStyle.Linear,Enum.EasingDirection.InOut)
		local TweenGoal2 = {Size = Vector3.new(41.679, 43.3, 40.63)}
		local TweenAnimation = TweenService:Create(Ring, TweenInformation, TweenGoal)
		TweenAnimation:Play()
		wait(0.6)

		Explode:Destroy()

		Ring.Transparency = 0.3
		Outburn.Transparency = 0.3
		Outburn2.Transparency = 0.3
		wait(0.1)
		Ring.Transparency = 0.4
		Outburn.Transparency = 0.4
		Outburn.Transparency = 0.4
		wait(0.1)
		Ring.Transparency = 0.5
		Outburn.Transparency = 0.5
		Outburn2.Transparency = 0.5
		wait(0.1)
		Ring.Transparency = 0.6
		Outburn.Transparency = 0.6
		Outburn2.Transparency = 0.6
		wait(0.1)
		Ring.Transparency = 0.7
		Outburn.Transparency = 0.7
		Outburn2.Transparency = 0.7
		Ring.DamageScript.Disabled = true
		wait(0.1)
		Ring.Transparency = 0.8
		Outburn.Transparency = 0.8
		Outburn2.Transparency = 0.8
		wait(0.1)
		Ring.Transparency = 0.9
		Outburn.Transparency = 0.9
		Outburn2.Transparency = 0.9
		wait(0.1)
		Ring.Transparency = 1
		Outburn.Transparency = 1
		Outburn2.Transparency = 1
		Ring:Destroy()
		Outburn:Destroy()
		Outburn2:Destroy()

		-- end!
	end
end)