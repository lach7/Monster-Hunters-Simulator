local gameSettings = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("GameSettings"))
local dataModule = require(game:GetService("ServerScriptService"):WaitForChild("Data"):WaitForChild("DataModule"))
local hitEnemies = {}

game.ReplicatedStorage.ToolRemoteEvents.DB.OnServerEvent:Connect(function(Player, Mouse, Tool)
	if Tool.Ammo.Value >= 1 then

		local GUI = Player.PlayerGui:WaitForChild("Weapons").DB

		local GoingToShootBullet = GUI.MainFrame:FindFirstChild("BulletImage")



		if GoingToShootBullet then
			GoingToShootBullet.ImageTransparency = 0.6
			GoingToShootBullet.Name = "UsedBullet"

			if Player.Character:WaitForChild("Reload").Value == false then
				Player.Character:WaitForChild("Reload").Value = true
				Tool.Barrel.ShootUI.Shoot.Visible = true
				Tool.Handle.ShootLight.Enabled = true
				Tool.Barrel.ShootUI.Shoot.ImageTransparency = 0.6

				local Shoot = Instance.new("Sound")
				Shoot.Parent = Tool.Handle
				Shoot.SoundId = "rbxassetid://3855292863"
				Shoot:Play()
				game.ServerScriptService.DB_Beam:Fire(Mouse, Tool)
				game.ServerScriptService.DB_Beam:Fire(Mouse, Tool)
				game.ServerScriptService.DB_Beam:Fire(Mouse, Tool)
				game.ServerScriptService.DB_Beam:Fire(Mouse, Tool)
				game.ServerScriptService.DB_Beam:Fire(Mouse, Tool)
				game.ServerScriptService.DB_Beam:Fire(Mouse, Tool)
				game.ServerScriptService.DB_Beam:Fire(Mouse, Tool)
				
				local rayDirection = Mouse
				local rayDesti = rayDirection - Tool.Handle.Position

				local Ignore = {Player.Character}
				local ray = Ray.new(Tool.Handle.Position, rayDesti)

				local Part, Position = workspace:FindPartOnRayWithIgnoreList(ray, Ignore)
				if Position then
					local enemies = {}
					for _, v in ipairs(workspace.Bays:GetChildren()) do
						for _, value in ipairs(v.Section1.Enemies:GetChildren()) do
							table.insert(enemies, value) 
						end
						for _, value in ipairs(v.Section2.Enemies:GetChildren()) do
							table.insert(enemies, value) 
						end
					end
					for i, v in pairs(enemies) do
						local dist = (v.HumanoidRootPart.Position - Position).Magnitude
						if dist <= 8 then
							local humanoid = v:FindFirstChild("Humanoid")
							if humanoid then
								local function DoDamage(amount, humanoid)
									humanoid.Health = humanoid.Health - 66
									
									local health = humanoid.Health
									local maxHealth = gameSettings["EnemyInfo"][v.Name]["Health"]
									v.Head.BillboardGui.Frame.Health.Text = tostring(health).."/"..tostring(maxHealth)
									v.Head.BillboardGui.Frame.HealthBar.Size = UDim2.new(0.897*(health/maxHealth), 0, 0.34,0)
								end

								game.ReplicatedStorage.Blood:Fire(Position)
								
								local Distance = (Mouse - Tool.Barrel.Position).Magnitude
								
								local gunInfoModule = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("gunInfo"))
								local plrData = dataModule.ReturnData(Player)
								local damageMulti = plrData["Multipliers"]["Attack"]
								local damageToDo
								if damageMulti then
									damageToDo = gunInfoModule[script.Name]["BaseDamage"] * damageMulti
								end


								DoDamage(damageToDo, humanoid)
									
									if humanoid.Health == 0 and not hitEnemies[v] then
										dataModule.EditData(Player, "Kills", 1, "addition")
										local plrData = dataModule.ReturnData(Player)	
										if plrData then
											local EXP = plrData["EXP"]
											local lvl = plrData["Level"]
										local EXPMult = plrData["Multipliers"]["BaseEXP"]
										local EXPtoReward = gameSettings["EnemyInfo"][v.Name]["EXP"] * EXPMult
											local newEXP = EXP + EXPtoReward
											local reqForNextLvl = lvl^2 + 100*lvl + 160
											
											if newEXP >= reqForNextLvl then
											newEXP = newEXP - reqForNextLvl
											local RS = game:GetService("ReplicatedStorage")
											local showSatsNotificationRe = RS:WaitForChild("InventoryRemotes"):WaitForChild("showStatsNotificationRE")
											showSatsNotificationRe:FireClient(Player)
											lvl = lvl + 1				
											Player.Character.Humanoid.Health = Player.Character.Humanoid.MaxHealth
											while newEXP >= lvl^2 +100*lvl + 160 do
												reqForNextLvl = lvl^2 +100*lvl + 160
												newEXP = newEXP - reqForNextLvl
												lvl = lvl + 1
												wait()
											end 
												dataModule.EditData(Player, "Level", lvl, "set")
												dataModule.EditData(Player, nil, nil, nil, nil, nil, nil, 1)
												Player.leaderstats.Level.Value = tostring(lvl)


											end
											dataModule.EditData(Player, "EXP", newEXP, "set")

											local ExpRE = game:GetService("ReplicatedStorage"):WaitForChild("GameRemotes"):WaitForChild("ExpRemote")
											ExpRE:FireClient(Player, EXPtoReward, lvl, EXP, reqForNextLvl)
										end
										hitEnemies[v] = true
									end
									
								
							end
						end
					end
				end



				wait(0.2)
				Tool.Barrel.ShootUI.Shoot.Visible = false
				Player.Character:WaitForChild("Reload").Value = false
				Tool.Handle.ShootLight.Enabled = false
				wait(1)
				Shoot:Destroy()
				



			end

		else
			
			Tool.Handle.NoAmmo:Play()
		end
	end
end)