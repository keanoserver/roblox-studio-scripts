local function onTouched(hit)
	-- Check if the part touching has the attribute "CashToGive"
	if hit:GetAttribute("CashToGive") then
		-- Get the current CashToGive value from the touching part
		local currentCash = hit:GetAttribute("CashToGive")

		-- Double the CashToGive value
		local newCash = currentCash * 1.5

		-- Update the CashToGive attribute with the new value
		hit:SetAttribute("CashToGive", newCash)

		-- Optional: print the new CashToGive value to the output for testing
		print("New CashToGive value:", newCash)
	else
		print("The part touched does not have a CashToGive attribute.")
	end
end

-- Connect the onTouched function to the Touched event
script.Parent.Touched:Connect(onTouched)
