game.ReplicatedStorage.Tact.Event:Connect(function(Mouse, Tool)
	local EndPoint = Instance.new("Part")
	local StartPoint = Instance.new("Part")

	EndPoint.Transparency = 1
	EndPoint.Parent = game.Workspace
	
	local Damage = (Mouse - Tool.Handle.Position).Magnitude

	if Damage <= 50 then
		EndPoint.Position = Mouse + Vector3.new(math.random(0, 1.1), math.random(0, 1.1), math.random(0, 1.1))

	else
		EndPoint.Position = Mouse + Vector3.new(math.random(0, 6), math.random(0, 6), math.random(0, 6))
	end
	
	EndPoint.Size = Vector3.new(0.5, 0.5, 0.5)
	EndPoint.Anchored = true
	EndPoint.CanCollide = false

	StartPoint.Transparency = 1
	StartPoint.Parent = game.Workspace
	StartPoint.Position = Tool.Barrel.Position
	StartPoint.Size = Vector3.new(0.5, 0.5, 0.5)
	StartPoint.Anchored = true
	StartPoint.CanCollide = false

	local Beam = Instance.new("Beam")
	local Attachment_0 = Instance.new("Attachment")
	local Attachment_1 = Instance.new("Attachment")

	Beam.Parent = StartPoint
	Attachment_0.Parent = StartPoint
	Attachment_1.Parent = EndPoint
	Beam.Color = ColorSequence.new({ -- a color sequence shifting from white to blue
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 170, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 127)),
	}
	)
	Beam.LightEmission = 1
	Beam.Attachment1 = Attachment_1
	Beam.Attachment0 = Attachment_0
	Beam.Width0 = 0.002
	Beam.Width1 = 0.09
	Beam.FaceCamera = true

	wait(0.3)
	Attachment_0:Destroy()
	Beam:Destroy()
	Attachment_1:Destroy()
	EndPoint:Destroy()
	StartPoint:Destroy()
end)