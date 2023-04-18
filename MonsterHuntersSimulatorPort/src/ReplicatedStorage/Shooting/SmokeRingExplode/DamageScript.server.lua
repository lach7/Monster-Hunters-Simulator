
local IfPlayer = {}
local killDebounces = {}

script.Parent.Touched:Connect(function(Obj)
	if Obj.Parent:FindFirstChild("Humanoid") and Obj:FindFirstAncestor("Enemies") then
		local Humanoid = Obj.Parent.Humanoid	
		local character = Obj.Parent
		local gameSettings = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("GameSettings"))
		local dataModule = require(game:GetService("ServerScriptService"):WaitForChild("Data"):WaitForChild("DataModule"))
		local gunInfoModule = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("gunInfo"))
		local Player = game.Players:FindFirstChild(script.Parent.Ownership.Value)
		local function DoDamage(amount, humanoid)
			humanoid.Health = math.floor(humanoid.Health - amount)
			local health = humanoid.Health
			local maxHealth = gameSettings["EnemyInfo"][character.Name]["Health"]
			character.Head.BillboardGui.Frame.Health.Text = tostring(health).."/"..tostring(maxHealth)
			character.Head.BillboardGui.Frame.HealthBar.Size = UDim2.new(0.897*(health/maxHealth), 0, 0.34,0)
	
			if humanoid.Health == 0 and not table.find(killDebounces, Obj.Parent) then
				dataModule.EditData(Player, "Kills", 1, "addition")
				local plrData = dataModule.ReturnData(Player)	
				if plrData then
					local EXP = plrData["EXP"]
					local lvl = plrData["Level"]
					local EXPMult = plrData["Multipliers"]["BaseEXP"]
					local EXPtoReward = gameSettings["EnemyInfo"][character.Name]["EXP"] * EXPMult
					local newEXP = EXP + EXPtoReward
					local reqForNextLvl = lvl^2 + 100*lvl + 160

					if newEXP >= reqForNextLvl then
						newEXP = newEXP - reqForNextLvl
						lvl = lvl + 1
						local RS = game:GetService("ReplicatedStorage")
						local showSatsNotificationRe = RS:WaitForChild("InventoryRemotes"):WaitForChild("showStatsNotificationRE")
						showSatsNotificationRe:FireClient(Player)
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
				table.insert(killDebounces, Obj.Parent)
			end
		end

		local plrData = dataModule.ReturnData(Player)
		local damageMulti = plrData["Multipliers"]["Attack"]
		local damageToDo
		if damageMulti then
			damageToDo = gunInfoModule["Flamethrower"]["BaseDamage"] * damageMulti
		end


		DoDamage(damageToDo, Humanoid)
	end
end)