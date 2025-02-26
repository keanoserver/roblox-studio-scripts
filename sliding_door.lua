-- Variables
local TweenService = game:GetService("TweenService")
local button1 = script.Parent.Parent.Button_door_garage -- Path to your first button
local button2 = script.Parent.Parent.Parent.button_garage1.Button_door_garage -- Path to your second button
local button3 = script.Parent.Parent.Parent.button_garage2.Button_door_garage -- Path to your third button
local doorModel1 = script.Parent.Parent.Parent.IronWall_garage -- First door
local doorModel2 = script.Parent.Parent.Parent.IronWall_garage1 -- Second door
local isOpen = false
local moveDistance = -18 -- Distance the door moves to the side
local moveTime = 5
local cooldownTime = 6 -- Cooldown time in seconds
local isCoolingDown = false

-- Function to create a tween for a part
local function createTween(part, endPosition, time)
	local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local tweenGoal = { Position = endPosition }
	local tween = TweenService:Create(part, tweenInfo, tweenGoal)
	return tween
end

-- Function to move the doors
local function moveDoors()
	for _, doorModel in ipairs({doorModel1, doorModel2}) do
		if doorModel then
			for _, part in ipairs(doorModel:GetChildren()) do
				if part:IsA("BasePart") then
					local targetPosition
					if isOpen then
						targetPosition = part.Position - Vector3.new(moveDistance, 0, 0)
					else
						targetPosition = part.Position + Vector3.new(moveDistance, 0, 0)
					end
					local tween = createTween(part, targetPosition, moveTime)
					tween:Play()
				end
			end
		end
	end
	isOpen = not isOpen
end

-- Function to handle button clicks
local function onButtonClick()
	if not isCoolingDown then
		isCoolingDown = true -- Start cooldown
		moveDoors()

		-- Disable buttons during cooldown
		button1.ClickDetector.MaxActivationDistance = 0
		button2.ClickDetector.MaxActivationDistance = 0
		button3.ClickDetector.MaxActivationDistance = 0

		wait(cooldownTime)

		-- Re-enable buttons after cooldown
		button1.ClickDetector.MaxActivationDistance = 10 -- Adjust distance as needed
		button2.ClickDetector.MaxActivationDistance = 10 -- Adjust distance as needed
		button3.ClickDetector.MaxActivationDistance = 10 -- Adjust distance as needed
		isCoolingDown = false -- End cooldown
	end
end

-- Connect button click events
button1.ClickDetector.MouseClick:Connect(onButtonClick)
button2.ClickDetector.MouseClick:Connect(onButtonClick)
button3.ClickDetector.MouseClick:Connect(onButtonClick)
