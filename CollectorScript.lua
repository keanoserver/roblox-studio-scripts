script.Parent.Touched:Connect(function(hit)
	if hit:GetAttributes('CashToGive') then
		local Tycoon = script.Parent.Parent.Parent.Parent
		
		local OwnerId = Tycoon:GetAttributes('UserId')
		
		if not OwnerId then warn('No Tycoon Owner') return end
		
		hit:Destroy()
		
		local padTycoon = script.Parent:FindFirstAncestor("Tycoon")
		local ownerUserId = padTycoon:GetAttribute("UserId")
		local owner = game.Players:GetPlayerByUserId(ownerUserId)
		if owner and owner:FindFirstChild("leaderstats") then
			local cashToGive = hit:GetAttribute("CashToGive")
			owner.leaderstats.Cash.Value += cashToGive
		end	
	end
end)
