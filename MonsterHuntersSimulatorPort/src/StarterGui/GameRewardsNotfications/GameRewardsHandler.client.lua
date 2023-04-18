local RS = game:GetService("ReplicatedStorage")

local frame = script.Parent:WaitForChild("Frame")
local notificationLbls = {
	notification1 = frame.Notification1,
	notification2 = frame.Notification2,
	notification3 = frame.Notification3,
	notification4 = frame.Notification4,
}

local XpRemote = RS:WaitForChild("GameRemotes"):WaitForChild("ExpRemote")
local CoinRemote = RS:WaitForChild("GameRemotes"):WaitForChild("CoinRemote")
local DiamondRemote = RS:WaitForChild("GameRemotes"):WaitForChild("DiamondRemote")

local activeNotifications = {
	false,
	false,
	false,
	false,
}

local Colors = {
	["EXP"] = Color3.fromRGB(5, 84, 255),
	["Coins"] = Color3.fromRGB(255, 170, 0),
	["Diamonds"] = Color3.fromRGB(0, 0, 127),
}

local function createNotification(index, AmountToReward, currency)
	activeNotifications[index] = true
	local notificationLbl = notificationLbls["notification"..tostring(index)]
	notificationLbl.TextColor3 = Colors[currency]
	notificationLbl.Text = "+"..tostring(AmountToReward).." "..currency
	notificationLbl.Visible = true
	wait(1)
	notificationLbl.Visible = false
	activeNotifications[index] = false	
end

local function areAllNotificationsTaken()
	for _, v in ipairs(activeNotifications) do
		if v == false then
			return false
		end
	end
	return true
end

XpRemote.OnClientEvent:Connect(function(ExpToReward)
	if ExpToReward then
		local hasBeenNotified = false
		if areAllNotificationsTaken() == false then
			--if not all taken
			for index, v in ipairs(activeNotifications) do
				if v == false and hasBeenNotified == false then
					hasBeenNotified = true

					coroutine.resume(coroutine.create(createNotification), index, ExpToReward, "EXP")
				end
			end
		else
			--if all taken
			for i, value in ipairs(activeNotifications) do
				value = false
			end
			coroutine.resume(coroutine.create(createNotification, 1, ExpToReward))		
		end
	end
end)

CoinRemote.OnClientEvent:Connect(function(CoinsToReward)
	if CoinsToReward then
		local hasBeenNotified = false
		if areAllNotificationsTaken() == false then
			--if not all taken
			for index, v in ipairs(activeNotifications) do
				if v == false and hasBeenNotified == false then
					hasBeenNotified = true

					coroutine.resume(coroutine.create(createNotification), index, CoinsToReward, "Coins")
				end
			end
		else
			--if all taken
			for i, value in ipairs(activeNotifications) do
				value = false
			end
			coroutine.resume(coroutine.create(createNotification, 1, CoinsToReward))		
		end
	end
end)

DiamondRemote.OnClientEvent:Connect(function(diamondsToReward)
	if diamondsToReward then
		local hasBeenNotified = false
		if areAllNotificationsTaken() == false then
			--if not all taken
			for index, v in ipairs(activeNotifications) do
				if v == false and hasBeenNotified == false then
					hasBeenNotified = true

					coroutine.resume(coroutine.create(createNotification), index, diamondsToReward, "Diamonds")
				end
			end
		else
			--if all taken
			for i, value in ipairs(activeNotifications) do
				value = false
			end
			coroutine.resume(coroutine.create(createNotification, 1, diamondsToReward))		
		end
	end
end)
