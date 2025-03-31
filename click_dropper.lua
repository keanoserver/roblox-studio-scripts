local DropperTemplate = game.ServerStorage:WaitForChild('DropperTemplate')
local button = script.Parent.button
local Ready = true

function MakeBlock ()
	if Ready then
		Ready = false
		local NewDropperPart = DropperTemplate:Clone()
		NewDropperPart.CFrame = script.Parent.Drop.CFrame - Vector3.new(0, 2, 0)

		-- Ensure the attribute is set
		local cashPerDrop = script.Parent:GetAttribute('CashPerDrop')
		if cashPerDrop then
			NewDropperPart:SetAttribute('CashToGive', cashPerDrop)
		else
			warn("CashPerDrop attribute not found on Dropper.")
		end

		NewDropperPart.Parent = script.Parent.DropperParts
		wait(0.5)
		Ready = true
	end
end

button.ClickDetector.MouseClick:Connect(MakeBlock)
