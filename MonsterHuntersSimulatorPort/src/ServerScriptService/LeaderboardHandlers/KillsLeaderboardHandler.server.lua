local dataStoreService = game:GetService("DataStoreService")

local saveData = dataStoreService:GetDataStore("saveData4")
local killsLeaderBoardData = dataStoreService:GetOrderedDataStore("KillsLeaderBoardData5")
local killsLeaderboardSF = workspace.killsLeaderboardDisplay.SurfaceGui.Frame.ScrollingFrame
local killsSample = killsLeaderboardSF.Parent.Sample

local Players = game:GetService("Players")

while true do
	local isAscending = false
	local pageSize = 100
	local killsPages = killsLeaderBoardData:GetSortedAsync(isAscending, pageSize)
	local killsTop100 = killsPages:GetCurrentPage()
	for _, v in ipairs(killsLeaderboardSF:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end
	for rank, data in ipairs(killsTop100) do
		local name = game:GetService("Players"):GetNameFromUserIdAsync(data.key)
		local kills = data.value
		local lbItem = killsSample:Clone()
		lbItem.Name = name
		lbItem.Parent = killsLeaderboardSF
		lbItem.PlayerName.Text = name
		lbItem.PlayerData.Text = data.value
		lbItem.DataShadow.Text = data.value
		lbItem.Rank.Text = rank
		local thumbType = Enum.ThumbnailType.HeadShot
		local thumbSize = Enum.ThumbnailSize.Size420x420
		local content, isReady = Players:GetUserThumbnailAsync(data.key, thumbType, thumbSize)
		local imageLabel = lbItem.imageDisplay
		imageLabel.Image = (isReady and content) or "rbxasset://textures/ui/GuiImagePlaceholder.png"
		imageLabel.Visible = true
		lbItem.Visible = true
	end
	wait(120)
end