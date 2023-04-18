local RS = game:GetService("ReplicatedStorage")
local ExpRemote = RS:WaitForChild("GameRemotes"):WaitForChild("ExpRemote")

local HpXpTrackersFrame = script.Parent:WaitForChild("Frame")

ExpRemote.OnClientEvent:Connect(function(EXPTorwardINGORe, lvl, EXP, ExpToLevelUp)
	if lvl then
		HpXpTrackersFrame:WaitForChild("CurrentLvl").Text = "Level "..tostring(lvl)
		HpXpTrackersFrame:WaitForChild("NextLvl").Text = "Level "..tostring(lvl + 1)
	end
	if EXP and ExpToLevelUp then
		HpXpTrackersFrame:WaitForChild("EXPlbl").Text = tostring(EXP).."/"..tostring(ExpToLevelUp).." EXP"
		HpXpTrackersFrame:WaitForChild("EXPbackground").EXP.Size = UDim2.new(EXP/ExpToLevelUp, 0,1,0)
	end

end)

