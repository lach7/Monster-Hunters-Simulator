--Variables
local rep = game:GetService("ReplicatedStorage") 
local nametag = rep.NameTag 

local dataModule = require(game:GetService("ServerScriptService"):WaitForChild("Data"):WaitForChild("DataModule"))

--Functions

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		local plrData = dataModule.ReturnData(player)
		repeat 
			wait()
			plrData = dataModule.ReturnData(player) 
		until plrData ~= nil

		if not player.Character.Head:FindFirstChild("NameTag") then
			local char = player.Character
			--Varibles
			local head = char.Head
			local newtext = nametag:Clone() --Cloning the text.
			local playerNameLbl = newtext.Frame.PlayerName
			local lvltext = newtext.Frame.Level
			local humanoid = char.Humanoid

			humanoid.DisplayDistanceType = "None"

			--Main Text
			newtext.Parent = head
			newtext.Adornee = head
			playerNameLbl.Text = player.Name --Changes the text to the player's name.


			if plrData then
				local plrLevel = plrData["Level"]
				lvltext.Text = "Level "..tostring(plrLevel)
			else
				lvltext.Text = "Level 1"
			end				
		end
	end)
end)

--[[
while true do
	for _, player in ipairs(game.Players:GetChildren()) do
		player.CharacterAdded:Connect(function()
			print("characteradded")
			--wait until datahandler loads, idk if this works
			local plrData = dataModule.ReturnData(player)
			repeat plrData = dataModule.ReturnData(player) until plrData ~= nil
			print("B")

			if not player.Character.Head:FindFirstChild("NameTag") then
				local char = player.Character
				--Varibles
				local head = char.Head
				local newtext = nametag:Clone() --Cloning the text.
				local playerNameLbl = newtext.Frame.PlayerName
				local lvltext = newtext.Frame.Level
				local humanoid = char.Humanoid

				humanoid.DisplayDistanceType = "None"

				--Main Text
				newtext.Parent = head
				newtext.Adornee = head
				playerNameLbl.Text = player.Name --Changes the text to the player's name.

				
				if plrData then
					local plrLevel = plrData["Level"]
					lvltext.Text = "Level "..tostring(plrLevel)
				else
					lvltext.Text = "Level 1"
				end				
			end
		end)
	end
	wait(1)
end
]]