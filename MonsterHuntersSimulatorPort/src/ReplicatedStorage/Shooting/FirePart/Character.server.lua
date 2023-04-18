
local IfPlayer = {}

script.Parent.Touched:Connect(function(Obj)
	if Obj.Parent:FindFirstChild("Humanoid") then
		local Humanoid = Obj.Parent.Humanoid

		if (table.find(IfPlayer, Obj.Parent.Name) == nil) then
			table.insert(IfPlayer, Obj.Parent.Name)

			local function DoDamage(amount, humanoid)
				humanoid.Health = math.clamp(humanoid.Health - amount, 0.2, humanoid.MaxHealth)
			end
			local MainFire = game.ReplicatedStorage.Shooting.MainFire:Clone()
			MainFire.Parent = Obj.Parent:FindFirstChild("HumanoidRootPart")
			DoDamage(2, Humanoid)
			wait(0.2)
			DoDamage(3, Humanoid)
			wait(2)
			DoDamage(3, Humanoid)
			table.remove(IfPlayer, 1)
			wait(0.2)
			DoDamage(10, Humanoid)
			wait(2)
			DoDamage(3, Humanoid)
			wait(15)
			script.Parent:Destroy()
			print("Destroyed Fire!")
		end
	end
end)