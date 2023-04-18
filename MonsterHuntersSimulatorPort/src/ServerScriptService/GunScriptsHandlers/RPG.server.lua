game.ReplicatedStorage.ToolRemoteEvents.RPG.OnServerEvent:Connect(function(Player, Tool, Mouse)
	
	if Tool.Ammo.Value >= 1 then
		local GUI = Player.PlayerGui:WaitForChild("Weapons").RPG

		local GoingToShootBullet = GUI.MainFrame:FindFirstChild("BulletImage")
		
		if GoingToShootBullet then
			GoingToShootBullet.ImageTransparency = 0.6
			GoingToShootBullet.Name = "UsedBullet"
			
			
			if Player.Character:WaitForChild("Reload").Value == false then
				Player.Character:WaitForChild("Reload").Value = true
				
				Tool.Launcher.Transparency = 1

				local Rocket = game.ReplicatedStorage.Shooting.Rocket:Clone()
				local ownerShipValue = Instance.new("StringValue")
				ownerShipValue.Value = Player.Name
				ownerShipValue.Parent = Rocket
				ownerShipValue.Name = "Ownership"
				local BodyVelocity = Instance.new("BodyVelocity")

				BodyVelocity.Parent = Rocket
				Rocket.Parent = game.Workspace
				Rocket.Position = Tool.Handle.Position + Vector3.new(0, 0, -2)
				Rocket.CFrame = CFrame.lookAt(Rocket.Position, Mouse)
				BodyVelocity.MaxForce = Vector3.new("inf", "inf", "inf")

				BodyVelocity.Velocity = (Mouse - Tool.Handle.Position).Unit * 45
				Rocket.Shoot:Play()
				Rocket.Script.Disabled = true

				wait(0.2)
				Rocket.Script.Disabled = false
				wait(1)
				Player.Character:WaitForChild("Reload").Value = false

				wait(10)
				
				if Rocket then
					Rocket:Destroy()
					
				end
			end
		end
	end
end)