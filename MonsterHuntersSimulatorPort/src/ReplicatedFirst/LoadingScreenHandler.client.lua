local RS = game:GetService("ReplicatedStorage")
local RF = game:GetService("ReplicatedFirst")
local ContentProvider = game:GetService("ContentProvider")

local assets = game:GetDescendants()

local ui1 = script.LoadingScreen:Clone()
player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

repeat wait() until game:IsLoaded()

ui1.Parent = playerGui

for i = 1, 100 do
	ui1:WaitForChild("Frame").LoadingBackground.LoadingText.Text = "Loading: "..math.floor((i/100)*100).."%"
	if i/100 > 0.1 then
		ui1.Frame.LoadingBackground.LoadingBar.Visible = true
		ui1.Frame.LoadingBackground.LoadingBar.Size = UDim2.new(i/100, 0, 1, 0)
	else
		ui1.Frame.LoadingBackground.LoadingBar.Visible = false
	end
	wait(0.1)
end

--[[
for i = 1, #assets do
	local asset = assets[i]
	
	ContentProvider:PreloadAsync({asset})
	ui1.Frame.LoadingBackground.LoadingText.Text = "Loading: "..math.floor((i/#assets)*100).."%"
	
	if i/#assets > 0.1 then
		ui1.Frame.LoadingBackground.LoadingBar.Visible = true
		ui1.Frame.LoadingBackground.LoadingBar.Size = UDim2.new(i/#assets, 0, 1, 0)
	end
end
]]

ui1:Destroy()