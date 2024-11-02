--spaw a part

local DropperTemplate = game.ServerStorage:WaitForChild('DropperTemplate')

while task.wait(2) do
	local NewDropperPart = DropperTemplate:Clone()
	NewDropperPart.CFrame = script.Parent.Drop.CFrame - Vector3.new(0,2,0)
	NewDropperPart:SetAttribute('CashToGive', script.Parent:GetAttribute('CashPerDrop'))
	NewDropperPart.Parent = script.Parent.DropperParts
end
