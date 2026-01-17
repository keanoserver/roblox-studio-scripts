local button = script.Parent
local frame = script.Parent.Parent:WaitForChild("Frame")
local debounce = false

button.MouseButton1Up:Connect(function()

	if debounce == false then
		debounce = true

		frame.Visible = true
		script.Parent.Text = "CLOSE"

	elseif debounce == true then
		debounce = false

		frame.Visible = false
		script.Parent.Text = "SHOP"

	end
end)

