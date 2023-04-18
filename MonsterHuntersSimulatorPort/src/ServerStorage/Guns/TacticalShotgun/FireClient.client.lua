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

local function shoot()
	local GUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Weapons").Revolver
	if (#GUI:WaitForChild("MainFrame"):GetChildren()) - 1 >= 1 then
		if Cooldown == true then
			if game.Players.LocalPlayer.Character:WaitForChild("Reload").Value == false then
				Cooldown = false
				local Old = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
				local camera = game.Workspace.CurrentCamera
				local Tool = script.Parent
				animationToPlay:Play()
				local Mouse = game.Players.LocalPlayer:GetMouse()
				Mouse.TargetFilter = workspace.Player_Pets
				wait(0.2)
				local Ammo = script.Parent.Ammo.Value
				game.ReplicatedStorage.ToolRemoteEvents.TactShotgun:FireServer(Mouse.Hit.Position, Tool)
				camera.CFrame = camera.CFrame * CFrame.Angles(0.01,math.rad(0),0)
				wait(0.2)
				Cooldown = true
				wait(0.8)
				if game.Players.LocalPlayer.Character:WaitForChild("Reload").Value == true then
					if script.Parent.Ammo.Value < Ammo then

					else
						local plrSpeed = game.Players.LocalPlayer.Character:FindFirstChild("SpeedValueForGuns").Value
						game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = plrSpeed
					end
				end
			end
		end
	end
end

script.Parent.Activated:Connect(function()
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
end)