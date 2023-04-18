game.ReplicatedStorage.ReloadWeapon.OnServerEvent:Connect(function(Player)
	local FoundTool = Player.Character:FindFirstChildWhichIsA("Tool")
	
	if FoundTool then
		local MaybeLauncher = FoundTool:FindFirstChild("Launcher")
		
		if MaybeLauncher then
			MaybeLauncher.Transparency = 0
		end
		local CheckAmmo = FoundTool:FindFirstChild("Ammo")
		
		
		if CheckAmmo then
			Player.Character:WaitForChild("Reload").Value = true
			
			local Id = "rbxassetid://9179952539"
			local AnimationNew = Instance.new("Animation")
			AnimationNew.AnimationId = Id
			local Humanoid = Player.Character.Humanoid:LoadAnimation(AnimationNew)
			Humanoid:Play()
			

			if FoundTool.Ammo then
				if FoundTool.Ammo.Value >= FoundTool.MaxAmmo.Value then
					local MaybeUI = (Player.PlayerGui:WaitForChild("Weapons"):FindFirstChild(FoundTool.Name))

					if MaybeUI then
						for i, v in pairs(MaybeUI.MainFrame:GetChildren()) do
							if v.Name == "UsedBullet" then
								v.ImageTransparency = 0
								v.Name = "BulletImage"
							end
						end
					end
				else
					FoundTool.Ammo.Value = FoundTool.Ammo.Value - FoundTool.Ammo.Value
				end
			end
			task.wait()
			
			Player.Character:WaitForChild("Reload").Value = false
			wait(0.2)
			local plrSpeed = Player.Character:FindFirstChild("SpeedValueForGuns").Value
			Player.Character.Humanoid.WalkSpeed = plrSpeed
		end
	end
end)