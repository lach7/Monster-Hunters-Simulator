local activationBox = workspace.StartBox
local leaveBox = workspace.LeaveBox
local Players = game:GetService("Players")
local playersInBox = {}
local countDownDuration = 10
local startWall = workspace.StartWall
local countDownText = startWall.SurfaceGui.CountdownText
local capturesInfo = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("capturesInfo"))
local dataModule = require(game:GetService("ServerScriptService"):WaitForChild("Data"):WaitForChild("DataModule"))
local TutorialPlayerStartedGameBE = game:GetService("ServerStorage"):WaitForChild("TutorialPlayerStartedGameBE")

local startGameBE = game:GetService("ServerScriptService"):WaitForChild("GameEvents"):WaitForChild("StartGame")

local playerIsInBox = false

local timerDuration = 5

local isRunning = false

local imageDebounces = {}

function TimerStart(duration)
	if playerIsInBox == true then
		local timerThread = coroutine.wrap(function()
			if isRunning == false then
				isRunning = true
				local i = timerDuration
				while i >= 0 and playerIsInBox == true do
					if playerIsInBox == true then
						startWall.SurfaceGui.CountdownText.Text = "("..tostring(i)..")"
						i = i - 1
						wait(1)
						if i == 0 then
							local waveToStartAt = 1
							local plrCapturesHolding = {}
							for _, playerInBox in ipairs(playersInBox) do
								local character = game.Players[playerInBox].Character
								for _, v in pairs(capturesInfo) do
									if character:FindFirstChild(v["Name"]) then
										table.insert(plrCapturesHolding, character:FindFirstChild(v["Name"]))
									end
								end
								local plrData = dataModule.ReturnData(game.Players[playerInBox])
								if plrData["Tutorial"]["HasCompleted"] == false then
									if plrData["Tutorial"]["Stage"] == 1 then
										TutorialPlayerStartedGameBE:Fire(game.Players[playerInBox])
									end
								end
							end
							for _, v in ipairs(plrCapturesHolding) do
								local captureWave = capturesInfo[v.Name]["WaveToBeat"]
								local waveToTeleport = capturesInfo[v.Name]["WaveToTeleport"]
								local highestCaptureWave
								if captureWave > waveToStartAt then
									waveToStartAt = waveToTeleport
								end								
							end
							startGameBE:Fire(playersInBox, waveToStartAt)
							
							playerIsInBox = false
							startWall.SurfaceGui.Instructions.Visible = true
							startWall.SurfaceGui.CountdownText.Visible = false
							imageDebounces = {}
							for _, v in ipairs(startWall.SurfaceGui.PlayersFrame:GetChildren()) do
								if v:IsA("ImageLabel") then
									v:Destroy()
								end
							end
							playersInBox = {}
						end
					else
						i = timerDuration
						isRunning = false
					end
				end	
				isRunning = false
			end		
		end)
		timerThread()
	end
end

local function addImage(plr)
	if not startWall.SurfaceGui.PlayersFrame:FindFirstChild(plr.Name) then
		if not table.find(imageDebounces, plr.Name) then
			table.insert(imageDebounces, plr.Name)
			local player = Players[plr.Name]
			local userId = player.UserId
			local thumbType = Enum.ThumbnailType.HeadShot
			local thumbSize = Enum.ThumbnailSize.Size420x420
			local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
			local imageLabel = startWall.SurfaceGui.Sample:Clone()
			imageLabel.Image = (isReady and content) or "rbxasset://textures/ui/GuiImagePlaceholder.png"
			imageLabel.Parent = startWall.SurfaceGui.PlayersFrame
			imageLabel.Visible = true
			imageLabel.Name = plr.Name
		
			
		end
	end
end

local function onPlayerEntered(plr)
	if not table.find(playersInBox, plr.Name) then
		-- remove any existing instances of player's name
		for i, name in ipairs(playersInBox) do
			if name == plr.Name then
				table.remove(playersInBox, i)
				break
			end
		end
		table.insert(playersInBox, plr.Name)
	end

	if #playersInBox < 6 then		
		if #playersInBox == 1 and playerIsInBox == false then
			playerIsInBox = true
			startWall.SurfaceGui.Instructions.Visible = false
			startWall.SurfaceGui.CountdownText.Visible = true
			TimerStart(timerDuration)
		else
			print("players in box is not 1")
		end
		if not startWall.SurfaceGui.PlayersFrame:FindFirstChild(plr.Name) then
			addImage(plr)
		end
	else
		print("MAX PLAYERS IN THE BOX")
	end
end






local function onPlayerLeft(plr)
	if table.find(playersInBox, plr.Name) then
		table.remove(playersInBox, table.find(playersInBox, plr.Name))
	end

	if #playersInBox == 0 then
		-- reset the countdown
		countDownText.Visible = false
		startWall.SurfaceGui.Instructions.Visible = true
		playerIsInBox = false
	end
	local image = startWall.SurfaceGui.PlayersFrame:FindFirstChild(plr.Name)
	if image then
		image:Destroy()
		table.remove(imageDebounces, table.find(imageDebounces, image.Name))
	end
end





local pos1 = activationBox.Position - (activationBox.Size/2)
local pos2 = activationBox.Position + (activationBox.Size/2)
local region = Region3.new(pos1, pos2)

local playersInRegion = {}
while true do
	wait(.1)
	local partsInRegion = workspace:FindPartsInRegion3(region, nil, 1000)

	-- Check for players that have entered or left the region
	for _, part in pairs(partsInRegion) do
		if part.Parent then
			if part.Parent:FindFirstChild("Humanoid") ~= nil then
				local plr = Players:GetPlayerFromCharacter(part.Parent)
				if plr and not table.find(playersInRegion, plr) then
					onPlayerEntered(plr)
					table.insert(playersInRegion, plr)
				end
			end
		end
	end
	for i, plr in ipairs(playersInRegion) do
		local partFound = false
		for _, part in pairs(partsInRegion) do
			if part.Parent then
				if part.Parent:FindFirstChild("Humanoid") ~= nil and Players:GetPlayerFromCharacter(part.Parent) == plr then
					partFound = true
					break
				end
			end
		end
		if not partFound then
			onPlayerLeft(plr)
			table.remove(playersInRegion, i)
		end
	end
end

--[[

local function onPlayerEntered(plr)
	if not table.find(playersInBox, plr.Name) then
		table.insert(playersInBox, plr.Name)
	end
	
	print(playersInBox)
	if #playersInBox < 6 then		
		if #playersInBox == 1 and playerIsInBox == false then
			playerIsInBox = true
			startWall.SurfaceGui.Instructions.Visible = false
			startWall.SurfaceGui.CountdownText.Visible = true
			TimerStart(timerDuration)
		end
		if not startWall.SurfaceGui.PlayersFrame:FindFirstChild(plr.Name) then
			addImage(plr)
		end
	end
end

local function onPlayerLeft(plr)
	if table.find(playersInBox, plr.Name) then
		table.remove(playersInBox, table.find(playersInBox, plr.Name))
	end
	
	if #playersInBox == 0 then
		-- reset the countdown
		countDownText.Visible = false
		startWall.SurfaceGui.Instructions.Visible = true
		playerIsInBox = false
	end
	local image = startWall.SurfaceGui.PlayersFrame:FindFirstChild(plr.Name)
	if image then
		image:Destroy()
		table.remove(imageDebounces, table.find(imageDebounces, image.Name))
	end
end

local pos1 = activationBox.Position - (activationBox.Size/2)
local pos2 = activationBox.Position + (activationBox.Size/2)
local max= Vector3.new(activationBox.Position.X+activationBox.Size.X/2, activationBox.Position.Y+activationBox.Size.Y/2, activationBox.Position.Z+activationBox.Size.Z/2)
local region = Region3.new(pos1, pos2)

local playersInRegion = {}
while true do
	wait(.1)
	local partsInRegion = workspace:FindPartsInRegion3(region, nil, 1000)

	-- Check for players that have entered the region
	for _, part in pairs(partsInRegion) do
		if part.Parent:FindFirstChild("Humanoid") ~= nil then
			local plr = Players:GetPlayerFromCharacter(part.Parent)
			if table.find(playersInRegion, plr) == nil then
				print("player left")
			end
			if plr and not table.find(playersInRegion, plr.Name) then
				onPlayerEntered(part.Parent)
				table.insert(playersInRegion, plr)
				print("player enteredswsws")
			end
		end
	end


end

--[[
while true do
	wait(.1)
	local playersInRegion = {}
	local partsInRegion = workspace:FindPartsInRegion3(region, nil, 1000)
	for _, part in pairs(partsInRegion) do
		if part.Parent:FindFirstChild("Humanoid") ~= nil then
			onPlayerEntered(part.Parent)
			local plr = Players:GetPlayerFromCharacter(part.Parent)
			if not table.find(playersInRegion, plr.Name) and not table.find(playersInBox, plr.Name) then
				table.insert(playersInRegion, plr.Name)
				table.insert(playersInBox, plr.Name)
			end
		end
	end
	for _, v in ipairs(Players:GetChildren()) do
		print(table.find(playersInRegion, v.Name))
		--if not  then

		--	onPlayerLeft(v)		
		--end
	end 
end
]]
--[[
activationBox.Touched:Connect(function(hit)
	local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
	if plr and hit.Parent.Humanoid.Health > 0 then

		if table.find(playersInBox, plr.Name) == nil then
			table.insert(playersInBox, plr.Name)
			onPlayerEntered(plr)
		end 
	end
end)

leaveBox.TouchEnded:Connect(function(hit)
	local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
	if plr then
	local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
	--check if they r on the ground
		if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
			-- handle the touch ended event here
			onPlayerLeft(plr)
		end
	end	
end)
]]

