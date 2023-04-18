local Tool = script.Parent
Tool.Equipped:Connect(function()
	_G.ForceShiftLock = true
end)
Tool.Unequipped:Connect(function()
	_G.ForceShiftLock = false
end)