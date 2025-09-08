local door = game.Workspace.Door
local button = game.Workspace.Button

local status = false

local function toggleDoor()
	if status == false then
		door.Transparency = 1
		door.CanCollide = false
		status = true
	else
		door.Transparency = 0
		door.CanCollide = true
		status = false
	end
end

button.ClickDetector.MouseClick:Connect(toggleDoor)
