local lava = script.Parent

lava.Touched:Connect(function(hit)
	local char = hit.Parent --char = character
	local hum = char:FindFirstChild("Humanoid") --hum = humanoid
	
	if hum then 
		hum.Health = 0 
	end 
end)
