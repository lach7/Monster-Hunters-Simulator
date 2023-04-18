local myHuman = script.Parent:WaitForChild("Humanoid")
local myRoot = script.Parent:WaitForChild("HumanoidRootPart")
local head = script.Parent:WaitForChild("Head")
local lowerTorso = script.Parent:WaitForChild("LowerTorso")

local grab = script.Parent:WaitForChild("Grab")
local grabAnim = myHuman:LoadAnimation(grab)
grabAnim.Priority = Enum.AnimationPriority.Action

local grabSound = head:WaitForChild("Attack")

local clone = script.Parent:Clone()

local gameSettings = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("GameSettings"))

local damageIdo = gameSettings["EnemyInfo"][script.Parent.Name]["Damage"]

function findPath(target)
	local path = game:GetService("PathfindingService"):CreatePath()
	path:ComputeAsync(myRoot.Position,target.Position)
	local waypoints = path:GetWaypoints()

	if path.Status == Enum.PathStatus.Success then
		for i, waypoint in ipairs(waypoints) do
			myHuman:MoveTo(waypoint.Position)

			if (myRoot.Position - target.Position).magnitude < 6 then
				-- stop moving if within 10 studs of target
				attack(target)
				break
			end
			if (myRoot.Position - waypoints[1].Position).magnitude > 20 then

				findPath(target)
				break
			end
		end
		
	end
end

function attack(target)
	if (myRoot.Position - target.Position).magnitude < 5 then
		grabAnim:Play()
		grabSound:Play()
		if target.Parent ~= nil then
			target.Parent.Humanoid:TakeDamage(damageIdo)
		end
		wait(1)
	end
end

function findPlayer()
	for _, v in ipairs(game.Players:GetChildren()) do
		local plrPosition = v.Character.HumanoidRootPart.Position
		if (myRoot.Position - plrPosition).magnitude < 75 then
			return v.Character.HumanoidRootPart
		end
	end
end

function main()
	local target = findPlayer()
	if target then
		myHuman.WalkSpeed = 13.75
		findPath(target)
	end

	-- Add random jump behavior
	local jump_probability = 0.05 -- Adjust this value to change the frequency of jumps

	if math.random() < jump_probability then
		myHuman.Jump = true
	end
end

while wait(0.05) do
	main()
end