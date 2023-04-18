local autoSaveInterval = 60
local SSS = game:GetService("ServerScriptService")
local dataModule = require(SSS:WaitForChild("Data"):WaitForChild("DataModule"))
local dataStoreService = game:GetService("DataStoreService")

local savaData = dataStoreService:GetDataStore("saveData4")
local killsLeaderBoardData = dataStoreService:GetOrderedDataStore("KillsLeaderBoardData5")
local levelsLeaderBoardData = dataStoreService:GetOrderedDataStore("LevelsLeaderBoardData5")
local donationsLeaderBoardData = dataStoreService:GetOrderedDataStore("DonationsLeaderBoardData5")

local playerIdsToIgnore = {
	401350257, --lachontop
	791665175, --fcanozaj2
	452455964, --LachStar996_3
	451874028, --LachStar996_2
}

while true do
	wait(60)
	for _, v in ipairs(game.Players:GetChildren()) do
		local newPlrData = dataModule.ReturnData(v)
		local success, errormessage = pcall(function()
			savaData:UpdateAsync("Player_"..tostring(v.UserId), function(pastData)
				if newPlrData then
					return newPlrData
				else
					return pastData
				end
				
			end)
			if not table.find(playerIdsToIgnore, v.UserId) then
				levelsLeaderBoardData:UpdateAsync(v.UserId, function(pastData)
					return tonumber(newPlrData["Level"])
				end)
				killsLeaderBoardData:UpdateAsync(v.UserId, function(pastData)
					return tonumber(newPlrData["Kills"])
				end)
				donationsLeaderBoardData:UpdateAsync(v.UserId, function(pastData)
					return tonumber(newPlrData["Donations"])
				end)
			end
		end)
		if success then
			print("Successfull autosaved "..v.Name.."'s data!")
		else
			print("Error autosaving "..v.Name.."'s data!: "..errormessage)
		end
	end
end

