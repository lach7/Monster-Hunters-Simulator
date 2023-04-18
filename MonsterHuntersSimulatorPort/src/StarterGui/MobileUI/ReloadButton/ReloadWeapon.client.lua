local Cooldown = true
local contentActionService = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local Character = player.Character
Character:WaitForChild("Humanoid")
local Crouch = Character.Humanoid:LoadAnimation(game.ReplicatedStorage.ClientAnimations.Reload)

local function onReloadButtonClick()
	if Cooldown == true then
		Cooldown = false
		game.ReplicatedStorage.ReloadWeapon:FireServer()
		Crouch:Play()
		wait(2)
		Cooldown = true
	end
end

local reloadButton = script.Parent

if UIS.TouchEnabled then
	while true do
		if player.Character:FindFirstChildWhichIsA("Tool") then
			local tool = player.Character:FindFirstChildWhichIsA("Tool")
			if not tool.Name:match("Boss") then
				if tool.Name ~= "Flamethrower" then
					reloadButton.Visible = true
					reloadButton.MouseButton1Up:Connect(function()
						onReloadButtonClick()
					end)
				end
			end
		else
			reloadButton.Visible = false
		end
		wait(.1)
	end
end