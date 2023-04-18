local dataStoreService = game:GetService("DataStoreService")

local saveData = dataStoreService:GetDataStore("saveData4")
local levelsLeaderBoardData = dataStoreService:GetOrderedDataStore("LevelsLeaderBoardData5")
local levelsLeaderboardSF = workspace.levelsLeaderboardDisplay.SurfaceGui.Frame.ScrollingFrame
local levelsSample = levelsLeaderboardSF.Parent.Sample

local Players = game:GetService("Players")

while true do
	local isAscending = false
	local pageSize = 100
	local levelsPages = levelsLeaderBoardData:GetSortedAsync(isAscending, pageSize)
	local levelsTop100 = levelsPages:GetCurrentPage()
	for _, v in ipairs(levelsLeaderboardSF:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end
	for rank, data in ipairs(levelsTop100) do
		local name = game:GetService("Players"):GetNameFromUserIdAsync(data.key)
		local level = data.value
		local lbItem = levelsSample:Clone()
		lbItem.Name = name
		lbItem.Parent = levelsLeaderboardSF
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