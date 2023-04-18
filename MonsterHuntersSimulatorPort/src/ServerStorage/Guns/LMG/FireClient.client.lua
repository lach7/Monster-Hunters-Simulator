local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local BeingHeld = false
local Cooldown = true
local UserInputService = game:GetService("UserInputService")

local animationToPlay = nil
local function loadAnimation()
	local Id = "rbxassetid://12892080227"
	local AnimationNew = Instance.new("Animation")
	AnimationNew.AnimationId = Id
	animationToPlay = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(AnimationNew)
end
loadAnimation()

script.Parent.Equipped:Connect(function()
	BeingHeld = true
end)

script.Parent.Unequipped:Connect(function()
	BeingHeld = false
end)

local mouseDown = false

Mouse.Button1Down:Connect(function()
	mouseDown = true
end)

Mouse.Button1Up:Connect(function()
	mouseDown = false
end)

local function shoot()
	local GUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Weapons").LMG
	if (#GUI:WaitForChild("MainFrame"):GetChildren()) - 1 >= 1 then
		if Cooldown == true then
			if game.Players.LocalPlayer.Character:WaitForChild("Reload").Value == false then


				local GUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Weapons").LMG

				local GoingToShootBullet = GUI.MainFrame:FindFirstChild("BulletImage")



				if GoingToShootBullet then
					Cooldown = false
					local Old = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
					local camera = game.Workspace.CurrentCamera
					local Tool = script.Parent
					
					if animationToPlay then
						animationToPlay:Play()
					end
					local Mouse = game.Players.LocalPlayer:GetMouse()
					Mouse.TargetFilter = workspace.Player_Pets
					game.ReplicatedStorage.ToolRemoteEvents.LMG:FireServer(Mouse.Hit.Position, Tool)

					wait(0.09)
					Cooldown = true
					local plrSpeed = game.Players.LocalPlayer.Character:FindFirstChild("SpeedValueForGuns").Value
					game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = plrSpeed
				end
			end
		end
	end
end

game:GetService("RunService").Heartbeat:Connect(function()
	if mouseDown then
		if BeingHeld == true then
			local mouse = game.Players.LocalPlayer:GetMouse()
			local camera = workspace.CurrentCamera
			if UserInputService.TouchEnabled == true then
				local pos = Vector2.new(mouse.x, mouse.y)
				local center = camera.ViewportSize / 2
				local r = (pos - center) 
				
				--[[
				if r.x < 0 then
					-- left side
				elseif r.x > 0 then
					-- right side
					shoot()
				end
				]]
				shoot()
			else
				shoot()
			end
		end
	end
end)