damage = script.Parent.Parent.Head.Settings.Damage

local remem = damage.Value

function onTouched(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player ~= nil then
	local def = player.Config.Defense
	local arm = player.Character:findFirstChild("Armour")
	
	if damage.Value <= def.Value then
	damage.Value = 0
	end
	if damage.Value > def.Value then
	damage.Value = damage.Value - def.Value
	end
	if arm ~= nil and damage.Value <= def.Value + arm.Value then
	damage.Value = 0
	end
	if arm ~= nil and damage.Value > def.Value + arm.Value then
	damage.Value = damage.Value - def.Value + arm.Value
	end
	local human = hit.Parent:findFirstChild("Humanoid")
	if (human ~= nil) then
		human:TakeDamage(damage.Value)
	end
	else
	if hit.Parent.Parent.Name == "Creature" then
	local hum = hit.Parent:findFirstChild("Humanoid")
	if hum == nil then return end
	hum:TakeDamage(damage.Value)
	end
	end
	damage.Value = remem
end

script.Parent.Touched:connect(onTouched)
