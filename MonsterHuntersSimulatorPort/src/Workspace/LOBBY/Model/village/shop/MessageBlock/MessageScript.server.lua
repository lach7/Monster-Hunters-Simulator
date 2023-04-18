-- Channy97 Scripts!

function onTouch(hit)

	if hit.Parent:FindFirstChild("Humanoid") ~= nil then

		if game.Players:FindFirstChild(hit.Parent.Name) ~= nil then
		local player = game.Players:FindFirstChild(hit.Parent.Name)

			if player:FindFirstChild("PlayerGui"):FindFirstChild("ScreenGui") == nil then
			sg = Instance.new("ScreenGui")
			sg.Parent = player:FindFirstChild("PlayerGui")
			end

		if player.PlayerGui.ScreenGui:FindFirstChild("MessageBox") == nil then

		local f = Instance.new("Frame")
		f.Name = "MessageBox"
		f.Position = UDim2.new(0.3, 0, 0.1, 0)
		f.Size = UDim2.new(0.4, 0, 0, 50)			-- If Text box needs to be bigger, simply change "0.4"
		f.Style = "RobloxRound"							-- Styles: "ChatBlue", "Chat Red", "Chat Green"
		f.Parent = player.PlayerGui:FindFirstChild("ScreenGui")

		local m = Instance.new("TextLabel")
		m.Position = UDim2.new(0.5, 0, 0.5, 0)
		m.FontSize = "Size14"							-- Font Sizes: 10, 11, 12, 14, 18, 24
		m.TextColor3 = Color3.new(1,1,1)				-- Colors: (1,0,0) = Red, (0,1,0) = Green, (0,0,1) = Blue
		m.Parent = f


-- TEXT SECTION --

-- The following will be simple enough to edit.
-- You may copy lines along with a waiting time, and edit the text/ wait time.

------------------------------------------

m.Text = "Sorry The Shop Is Closed"
m.TextColor3 = Color3.new(1,0,0)
wait(2)



------------------------------------------

		f:Destroy()
		end
		end
	end
end

script.Parent.Touched:connect(onTouch)

















