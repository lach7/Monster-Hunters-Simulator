local movePart = script.Parent

local TS = game:GetService("TweenService")
local TI = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)

local cFrame = {CFrame = movePart.CFrame - Vector3.new(0,-3,0)}

local tween = TS:Create(movePart, TI, cFrame)

tween:Play()