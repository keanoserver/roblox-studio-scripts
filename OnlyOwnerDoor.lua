local function onTouched(hit)
	-- Get the Tycoon ancestor of the touched object
	local padTycoon = script.Parent:FindFirstAncestor("Tycoon")
	if not padTycoon then
		warn("No Tycoon ancestor found.")
		return
	end

	-- Get the UserId attribute from the Tycoon
	local ownerUserId = padTycoon:GetAttribute("UserId")
	if not ownerUserId then
		warn("UserId attribute is not set on this Tycoon.")
		return
	end

	-- Find the player based on the UserId
	local owner = game.Players:GetPlayerByUserId(ownerUserId)
	if not owner then
		warn("Owner not found in the game.")
		return
	end

	-- Check if the person touching is the owner
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player and player.UserId == ownerUserId then
		-- Actions for the owner touching the object
		script.Parent.Transparency = 0.5
		script.Parent.CanCollide = false
		print("Owner interaction detected!")
		wait(1)
		script.Parent.Transparency = 0
		script.Parent.CanCollide = true
	else
		-- Actions for non-owners
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.Health = 0
			print("Non-owner touched, health set to 0")
		end
	end
end

script.Parent.Touched:Connect(onTouched)
