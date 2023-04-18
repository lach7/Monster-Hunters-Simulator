math.randomseed(tick())

local gameSettings = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("GameSettings"))
local dataModule = require(game:GetService("ServerScriptService"):WaitForChild("Data"):WaitForChild("DataModule"))
local gunInfoModule = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("gunInfo"))
local ft = script.Parent.Parent
local animations = ft.Animations
local props = {}
local taggedTargets = {}
local firing = false

local remotes = Instance.new("Folder")
remotes.Name = "Remotes"
remotes.Parent = ft

function taggedTargets:Find(instance)
	for _, element in pairs(self) do
		if type(element) == "userdata" then
			if element == instance then
				return element
			end
		end
	end
	return false
end

function generateEvent(name)
	local remote = Instance.new("RemoteEvent")
	remote.Name = name
	remote.Parent = remotes
	return remote
end

function generateFunction(name)
	local remote = Instance.new("RemoteFunction")
	remote.Name = name
	remote.Parent = remotes
	return remote
end

local function DoDamage(amount, humanoid, character, Player)
	humanoid.Health = math.floor(humanoid.Health - amount)
	local health = humanoid.Health
	local maxHealth = gameSettings["EnemyInfo"][character.Name]["Health"]
	character.Head.BillboardGui.Frame.Health.Text = tostring(health).."/"..tostring(maxHealth)
	character.Head.BillboardGui.Frame.HealthBar.Size = UDim2.new(0.897*(health/maxHealth), 0, 0.34,0)

	if humanoid.Health == 0 then
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
				dataModule.EditData(Player, "Level", lvl, "set")
				dataModule.EditData(Player, nil, nil, nil, nil, nil, nil, 1)
				Player.leaderstats.Level.Value = tostring(lvl)
			end
			dataModule.EditData(Player, "EXP", newEXP, "set")

			local ExpRE = game:GetService("ReplicatedStorage"):WaitForChild("GameRemotes"):WaitForChild("ExpRemote")
			ExpRE:FireClient(Player, EXPtoReward, lvl, EXP, reqForNextLvl)
		end
	end
end

function ignite(character, Player)
	if not taggedTargets:Find(character) then
		if not game.Players:GetPlayerFromCharacter(character) then
			table.insert(taggedTargets, 1, character)
			for _, child in pairs(character:GetChildren()) do
				local flame = ft.FlamePart.Flame:Clone()
				flame.Size = NumberSequence.new({NumberSequenceKeypoint.new(0.0, 2), NumberSequenceKeypoint.new(0.2, 1.5), NumberSequenceKeypoint.new(0.4, 1), NumberSequenceKeypoint.new(0.6, 0.5), NumberSequenceKeypoint.new(0.8, 0.25), NumberSequenceKeypoint.new(1.0, 0.2)})
				flame.Lifetime = NumberRange.new(0.25, 1.5)
				flame.EmissionDirection = Enum.NormalId.Top
				flame.Acceleration = Vector3.new(0, 5, 0)
				flame.Parent = child
				local smoke = flame:Clone()
				smoke.Texture = "rbxassetid://133619974"
				smoke.Size = NumberSequence.new(1, 3)
				smoke.Lifetime = NumberRange.new(2, 4)
				smoke.Acceleration = Vector3.new(0, 1, 0)
				smoke.Rate = 50
				smoke.Color = ColorSequence.new(Color3.new(10/255, 10/255, 10/255), Color3.new(100/255, 100/255, 100/255))
				smoke.Parent = child
			end
			local anim = animations:FindFirstChild("Burn"..math.random(1, 3))
			if character:FindFirstChild("Humanoid") then
				character.Humanoid:LoadAnimation(anim):Play()
					local function damageFunction()
						repeat
							local plrData = dataModule.ReturnData(Player)
							local damageMulti = plrData["Multipliers"]["Attack"]
							local damageToDo
							if damageMulti then
								damageToDo = gunInfoModule["Flamethrower"]["BaseDamage"] * damageMulti
							end

							if character:FindFirstChild("Humanoid") then
								DoDamage(damageToDo, character.Humanoid, character, Player)
							else
								break
							end

							wait(0.25)
						until character == nil
					end
				coroutine.resume(coroutine.create(damageFunction))
			end
		end
	end
end

function generateNozzle(player)
	local char = player.Character	
	
	local attachment1 = Instance.new("Attachment")
	attachment1.Position = Vector3.new(1, -1, 1/2)
	attachment1.Parent = char.HumanoidRootPart
	
	local rope = Instance.new("RopeConstraint")
	rope.Attachment0 = ft.Rope.Attachment
	rope.Attachment1 = attachment1
	rope.Visible = true
	rope.Color = BrickColor.new("Really black")
	rope.Length = 2.25
	rope.Thickness = 0.35
	rope.Parent = ft
	
	table.insert(props, 1, attachment1)
	table.insert(props, 1, rope)
end

local makeNozzle = generateEvent("GenerateNozzle")
makeNozzle.OnServerEvent:Connect(generateNozzle)

local unmakeNozzle = generateEvent("RemoveNozzle")
unmakeNozzle.OnServerEvent:Connect(function(player)
	for i, v in pairs(props) do
		v:Destroy()
	end
end)

local fire = generateFunction("Fire")
fire.OnServerInvoke = function(player)
	local sound1 = Instance.new("Sound")
	sound1.Volume = 1
	sound1.SoundId = "rbxassetid://574293274"
	sound1.PlayOnRemove = true
	sound1.Parent = ft.BulletPart
	sound1:Destroy()
	ft.BulletPart.Fuel.Enabled = true
	wait(1/2)
	local fireSound = Instance.new("Sound")
	fireSound.Name = "FireSound"
	fireSound.Volume = 1
	fireSound.Looped = true
	fireSound.SoundId = "rbxassetid://6195348115"
	fireSound.Parent = ft.FlamePart
	fireSound:Play()
	ft.FlamePart.Fire.Enabled = true
	firing = true
	while firing do
		local ray = Ray.new(ft.FlamePart.Position, -25*ft.FlamePart.CFrame.upVector)
		local hitPart = workspace:FindPartOnRayWithIgnoreList(ray, player.Character:GetChildren())
		if hitPart then
			if hitPart.Parent:FindFirstChild("Humanoid") then
				ignite(hitPart.Parent, player)
			elseif hitPart.Parent.Parent:FindFirstChild("Humanoid") then
				ignite(hitPart.Parent.Parent, player)
			end
		end
		wait(0.2)
	end
end

stopFire = generateFunction("StopFire")
stopFire.OnServerInvoke = function(player)
	for _, child in pairs(ft.FlamePart:GetChildren()) do
		if child.Name == "FireSound" then
			child:Destroy()
		end
	end
	ft.BulletPart.Fuel.Enabled = false
	ft.FlamePart.Fire.Enabled = false
	firing = false
end