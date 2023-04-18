local RS = game:GetService("ReplicatedStorage")

local GameRemote = RS:WaitForChild("GameRemotes"):WaitForChild("GameRemote")

local getDataRemote = RS:WaitForChild("Data"):WaitForChild("GetData")

local frame = script.Parent.GameInfo.Frame
local ExitBtn = frame.Exit
local WaveLbl = frame.Wave
local EnemiesKilledLbl = frame.EnemiesKilled

local maxGameWaves = 60
local finishedGameFrame = script.Parent:WaitForChild("GameInfo"):WaitForChild("FinishedGame")
local RS = game:GetService("ReplicatedStorage")

--Value False = start wave True = Edit Info
GameRemote.OnClientEvent:Connect(function(Wave, maxEnemies, enemiesKilled, died, isGameOver, bay, newActiveSection)
	
	if isGameOver == true then
		
		frame.Visible = false
		local pos = finishedGameFrame.Position
		finishedGameFrame.Position = pos - UDim2.new(0,0,1,0)
		local position1 = {
			Position = pos
		}
		local position2 = {
			Position = pos - UDim2.new(0,0,1,0)
		}
		local TI = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)
		local TS = game:GetService("TweenService")
		local tween1 = TS:Create(finishedGameFrame, TI, position1)
		local tween2 = TS:Create(finishedGameFrame, TI, position2)
		finishedGameFrame.Visible = true
		tween1:Play()
		wait(3)
		tween2:Play()	
		wait(1)
		finishedGameFrame.Visible = false
	else
	
			frame.Visible = true
			WaveLbl.Text = "Wave "..tostring(Wave).."/"..tostring(maxGameWaves)
			if enemiesKilled then
				EnemiesKilledLbl.Text = tostring(enemiesKilled).."/"..tostring(maxEnemies).." Enemies"
			else
				EnemiesKilledLbl.Text = "0/"..tostring(maxEnemies).." Enemies"
			end
			if died == true then
				frame.Visible = false
				WaveLbl.Text = "Wave 1/60"
				EnemiesKilledLbl.Text = "0/0 Enemies"
			end
		
	end
end)

ExitBtn.MouseButton1Up:Connect(function()
	game.Players.LocalPlayer.Character.Humanoid.Health = 0
	frame.Visible = false
end)




