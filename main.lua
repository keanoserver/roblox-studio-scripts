local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Items = ReplicatedStorage:WaitForChild("Items")
local Tycoons = workspace:WaitForChild("Tycoons")
local PlaceholderTycoon = ReplicatedStorage:WaitForChild("Tycoon")

-- Clear out tycoon items
for _, Tycoon in pairs(CollectionService:GetTagged("Tycoon")) do
	if not Tycoon:IsDescendantOf(ReplicatedStorage) and Tycoon:FindFirstChild("Items") then
		Tycoon.Items:ClearAllChildren()
	else
		warn("Tycoon has no Items folder or is stored in ReplicatedStorage")
	end
end

-- Helper to find an item in the placeholder tycoon by ID
local function getItemInTycoonById(itemId, tycoon)
	for _, Item in tycoon.Items:GetChildren() do
		if Item:GetAttribute("Id") == itemId then
			return Item
		end
	end
	return nil
end

-- Helper to find an item in the global items folder by ID
local function getItem(itemId)
	for _, Item in Items:GetChildren() do
		if Item:GetAttribute("Id") == itemId then
			return Item
		end
	end
	return nil
end

-- Assign a tycoon to a player
local function assignTycoon(player)
	for _, Tycoon in Tycoons:GetChildren() do
		if not Tycoon:GetAttribute("Taken") then
			Tycoon:SetAttribute("Taken", true)
			Tycoon:SetAttribute("UserId", player.UserId)

			local sign = Tycoon:FindFirstChild("Decorations"):FindFirstChild("player_sign")
			local textLabel = sign and sign:FindFirstChild("Sign") and sign.Sign:FindFirstChild("SurfaceGui") and sign.Sign.SurfaceGui:FindFirstChild("TextLabel")

			if textLabel then
				textLabel.Text = player.Name
			else
				warn("Sign for Tycoon is not configured properly")
			end

			return Tycoon
		end
	end
	warn("No available tycoon for player " .. player.Name)
	return nil
end

-- Get the relative CFrame of an item in the placeholder tycoon
local function getRelativeCframe(itemId)
	local Item = getItemInTycoonById(itemId, PlaceholderTycoon)
	if Item and PlaceholderTycoon.PrimaryPart then
		return PlaceholderTycoon.PrimaryPart.CFrame:ToObjectSpace(Item:GetPivot())
	end
	warn("Could not find item or PrimaryPart for relative CFrame")
	return nil
end

-- Get a player's assigned tycoon
local function getTycoon(player)
	for _, Tycoon in Tycoons:GetChildren() do
		if Tycoon:GetAttribute("UserId") == player.UserId then
			return Tycoon
		end
	end
	return nil
end

-- Show buttons unlocked by a purchased item
local function showNextButtons(tycoon, purchasedItemId)
	for _, Button in CollectionService:GetTagged("Button") do
		if Button:GetAttribute("RequiredItemId") == purchasedItemId and Button:IsDescendantOf(tycoon) then
			Button.Transparency = 0
			Button.BillboardGui.Enabled = true
			Button.CanCollide = true
			Button.CanTouch = true
			Button:SetAttribute("Unlocked", false)

			-- Ensure all parts of the button are interactive
			for _, child in pairs(Button:GetChildren()) do
				if child:IsA("BasePart") then
					child.CanCollide = true
					child.CanTouch = true
				end
			end
		end
	end
end

-- Unlock an item for a player
local function unlockItem(player, itemId)
	if not itemId then
		warn("Attempted to unlock an item with a nil itemId")
		return false
	end

	local tycoon = getTycoon(player)
	if not tycoon then return false end

	local Item = getItem(itemId)
	if not Item then
		warn("Item with ID " .. tostring(itemId) .. " not found in Items folder")
		return false
	end

	local Cost = tonumber(Item:GetAttribute("Cost")) or 0
	if player.leaderstats.Cash.Value < Cost then return false end

	player.leaderstats.Cash.Value -= Cost

	local RelativeCF = getRelativeCframe(itemId)
	if not RelativeCF then return false end

	local WorldCF = tycoon.PrimaryPart.CFrame:ToWorldSpace(RelativeCF)
	local ClonedItem = Item:Clone()
	ClonedItem:PivotTo(WorldCF)
	ClonedItem.Parent = tycoon.Items

	showNextButtons(tycoon, itemId)
	return true
end

-- Handle button interactions
for _, Button in CollectionService:GetTagged("Button") do
	local ItemId = Button:GetAttribute("ItemId")
	local Item = getItem(ItemId)

	if Item then
		local label = Button:FindFirstChild("BillboardGui") and Button.BillboardGui:FindFirstChild("TextLabel")
		if label then
			label.Text = Item.Name .. " - " .. (Item:GetAttribute("Cost") or "N/A")
		else
			warn("Button BillboardGui or TextLabel is missing for ItemId: " .. tostring(ItemId))
		end
	else
		warn("Button references an invalid ItemId: " .. tostring(ItemId))
	end

	Button.Touched:Connect(function(hit)
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if not player or not Button:GetAttribute("ItemId") or Button:GetAttribute("Unlocked") then return end

		local tycoon = getTycoon(player)
		if not tycoon or not Button:IsDescendantOf(tycoon) then
			warn(player.Name .. " tried to touch a button not in their tycoon!")
			return
		end

		local success = unlockItem(player, ItemId)
		if success then
			Button.Transparency = 1
			Button.BillboardGui.Enabled = false
			Button.CanCollide = false
			Button.CanTouch = false
			Button:SetAttribute("Unlocked", true)
		end
	end)
end

-- Handle player addition
Players.PlayerAdded:Connect(function(player)
	local Tycoon = assignTycoon(player)
	if not Tycoon then return end

	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"

	local cash = Instance.new("IntValue", leaderstats)
	cash.Name = "Cash"
	cash.Value = 0

	-- Initialize buttons
	for _, Button in Tycoon.Buttons:GetChildren() do
		Button.Transparency = 1
		Button.BillboardGui.Enabled = false
		Button.CanCollide = false
		Button.CanTouch = false

		if not Button:GetAttribute("RequiredItemId") then
			Button.Transparency = 0
			Button.BillboardGui.Enabled = true
			Button.CanCollide = true
			Button.CanTouch = true
			Button:SetAttribute("Unlocked", false)
		end
	end
end)

-- Handle player removal
Players.PlayerRemoving:Connect(function(player)
	local Tycoon = getTycoon(player)
	if Tycoon then
		Tycoon.Items:ClearAllChildren()
		for _, Button in Tycoon.Buttons:GetChildren() do
			Button.Transparency = 0
			Button.BillboardGui.Enabled = true
			Button.CanCollide = true
			Button.CanTouch = true
			Button:SetAttribute("Unlocked", false)
		end
	end
end)
