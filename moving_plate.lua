local plate = script.Parent
local startPos = plate.Position
local distance = 10 
local speed = 0.1
local direction = 1

while true do
	plate.Position = plate.Position + Vector3.new(speed * direction, 0, 0)

	local moved = (plate.Position - startPos).Magnitude

	if moved >= distance then
		direction = -direction
	end

	wait(0.05)
end
