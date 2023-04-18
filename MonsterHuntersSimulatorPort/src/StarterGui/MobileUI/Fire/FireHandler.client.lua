local Cooldown = true
local contentActionService = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local firing = false
local cooled = true

function fire(remotes)
	
end

local function onFireButtonClick(ft)
	local remotes = ft:WaitForChild("Remotes")
	if cooled and not firing then
		cooled = false
		firing = true
		remotes.Fire:InvokeServer()
		repeat
			if not firing then
				remotes.StopFire:InvokeServer()
			end
			wait(0.5)
		until cooled
	end
end

local function onFireButtonRelease(ft)
	local remotes = ft:WaitForChild("Remotes")
	firing = false
	wait(0.5)
	remotes.StopFire:InvokeServer()
	wait(1)
	cooled = true
end

local fireButton = script.Parent

if UIS.TouchEnabled then
	while true do
		if player.Character:FindFirstChildWhichIsA("Tool") then
			local tool = player.Character:FindFirstChildWhichIsA("Tool")
			if tool.Name == "Flamethrower" then
				fireButton.Visible = true
				fireButton.MouseButton1Down:Connect(function()
					onFireButtonClick(tool)
				end)
				fireButton.MouseButton1Up:Connect(function()
					onFireButtonRelease(tool)
				end)
			else
				fireButton.Visible = false
			end
		else
			fireButton.Visible = false
		end
		wait(.1)
	end
end
