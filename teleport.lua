local teleportPart = script.Parent
local destination = workspace.Part2 

teleportPart.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")

	if humanoid then
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			rootPart.CFrame = destination.CFrame + Vector3.new(0, 3, 0)
		end
	end
end)
