local SoundRegionsWorkspace = game.Workspace:WaitForChild("SoundZones")
local disableMusicFrame = game.Players.LocalPlayer.PlayerGui:WaitForChild("MenuInteractives"):WaitForChild("Settings"):WaitForChild("DisableMusic")
local musicOffBtn = disableMusicFrame:WaitForChild("Off")
local musicOnBtn = disableMusicFrame:WaitForChild("On")
local soundRegionsFolder = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SoundRegions")

local Found = false
local musicShouldBePlaying = true

local function playMusic()
	for i, v in pairs (SoundRegionsWorkspace:GetChildren()) do

		Found = false
		local region = Region3.new(v.Position - (v.Size/2),v.Position + (v.Size/2))

		local parts = game.Workspace:FindPartsInRegion3WithWhiteList(region, game.Players.LocalPlayer.Character:GetDescendants())


		for _, part in pairs(parts) do
			-- Loop one by one through the parts table
			if part:FindFirstAncestor(game.Players.LocalPlayer.Name) then
				Found = true
				break
			else
				Found = false
			end
		end

		if Found == true then
			-- Start playing some music
			if soundRegionsFolder[v.Name].IsPlaying == false then
				soundRegionsFolder[v.Name]:Play()
				break
			end
		else
			soundRegionsFolder[v.Name]:Stop()
		end
	end
end

local function pauseMusic()
	for _, v in ipairs(soundRegionsFolder:GetChildren()) do
		if v:IsA("Sound") then
			if v.Playing == true then
				v:Stop()
			end
		end
	end
end

while wait(1) do
	soundRegionsFolder = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SoundRegions")
	musicOffBtn.MouseButton1Up:Connect(function()
		musicOffBtn.Visible = false
		musicOnBtn.Visible = true
		musicShouldBePlaying = false
		pauseMusic()
	end)
	musicOnBtn.MouseButton1Up:Connect(function()
		musicOnBtn.Visible = false
		musicOffBtn.Visible = true
		musicShouldBePlaying = true
		playMusic()
	end)
	
	if musicShouldBePlaying == true then
		playMusic()
	else
		pauseMusic()
	end
end