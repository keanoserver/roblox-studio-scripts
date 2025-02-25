script.Parent.Touched:Connect(function(hit)
	local cashToGive = hit:GetAttribute('CashToGive')
	if not cashToGive then return end

	local Tycoon = script.Parent:FindFirstAncestor("Tycoon")
	if not Tycoon then
		warn("Tycoon not found")
		return
	end

	local ownerUserId = Tycoon:GetAttribute("UserId")
	if not ownerUserId then
		warn("No Tycoon owner")
		return
	end

	local owner = game.Players:GetPlayerByUserId(ownerUserId)
	if owner and owner:FindFirstChild("leaderstats") then
		owner.leaderstats.Cash.Value += cashToGive
	else
		warn("Owner or leaderstats not found for UserId: " .. tostring(ownerUserId))
	end

	hit:Destroy()
end)
