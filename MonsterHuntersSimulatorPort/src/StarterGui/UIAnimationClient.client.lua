local RS = game:GetService("ReplicatedStorage")
local UIModule = require(RS:WaitForChild("UIAnimations"))

wait(8)
for _, ui in ipairs(script.Parent:GetDescendants()) do
	if ui:IsA("GuiButton") then
		UIModule.SetUp(ui)
	end
end


