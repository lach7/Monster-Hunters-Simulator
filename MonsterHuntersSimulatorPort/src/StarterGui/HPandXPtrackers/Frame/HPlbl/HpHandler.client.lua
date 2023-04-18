
local hpLbl = script.Parent
local hpBar = script.Parent.Parent.HPbackground.HP
local plr = game.Players.LocalPlayer

while true do
	local character = plr.Character or plr.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	if humanoid then
		local health = humanoid.Health
		local maxHealth = humanoid.MaxHealth
		hpLbl.Text = tostring(math.floor(health)).."/"..tostring(maxHealth)
		if health < 5 then
			hpBar.Size = UDim2.new(0.05, 0, 1, 0)
		else
			hpBar.Size = UDim2.new(health/maxHealth, 0, 1, 0)
		end
	end
	wait(.1)
end

