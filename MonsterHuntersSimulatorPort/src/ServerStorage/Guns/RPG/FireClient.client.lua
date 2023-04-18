local Cooldown = true
local UserInputService = game:GetService("UserInputService")

local animationToPlay = nil
local function loadAnimation()
	local Id = "rbxassetid://9270000540"
	local AnimationNew = Instance.new("Animation")
	AnimationNew.AnimationId = Id
	animationToPlay = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(AnimationNew)
end
loadAnimation()

local function shoot()
	local Gui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Weapons").RPG
	if Gui.MainFrame:FindFirstChild("BulletImage") then
		if game.Players.LocalPlayer.Character:WaitForChild("Reload").Value == false then
			if Cooldown == true  then
				Cooldown = false
				local Mouse = game.Players.LocalPlayer:GetMouse()
				Mouse.TargetFilter = workspace.Player_Pets
				animationToPlay:Play()
				game.ReplicatedStorage.ToolRemoteEvents.RPG:FireServer(script.Parent, Mouse.Hit.Position)
				wait(4.2)
				Cooldown = true
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