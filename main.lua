local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Items = ReplicatedStorage:WaitForChild('Items')
local Tycoons = game.Workspace:WaitForChild("Tycoons")
local PlaceholderTycoon = ReplicatedStorage:WaitForChild('Tycoon')

-- Clear out tycoon items
for _, Tycoon in pairs(CollectionService:GetTagged("Tycoon")) do
	if Tycoon:IsDescendantOf(ReplicatedStorage) then continue end
	if Tycoon.Items then
		Tycoon.Items:ClearAllChildren()
	else
		warn("Tycoon has no Items folder")
	end
end

-- Function to get item in tycoon by ID
local function getItemInTycoonById(itemId, tycoon)
	for _, Item in PlaceholderTycoon.Items:GetChildren() do
		if Item:GetAttribute('Id') == itemId then
			return Item
		end
	end
	return nil -- Return nil if no item is found
end

-- Function to get item in general by ID
local function getItem(itemId)
	for _, Item in Items:GetChildren() do
		if Item:GetAttribute("Id") == itemId then
			return Item
		end
	end
	return nil -- Return nil if item is not found
end

-- Assigns a tycoon to the player if one is available
local function assignTycoon(player)
	for _, Tycoon in Tycoons:GetChildren() do
		if not Tycoon:GetAttribute("Taken") then
			Tycoon:SetAttribute("Taken", true)
			Tycoon:SetAttribute("UserId", player.UserId)
			return Tycoon
		end
	end
	warn("No available tycoon for player " .. player.Name)
	return nil
end

-- Gets the relative CFrame of an item within the placeholder tycoon
local function getRelativeCframe(itemId)
	local Item = getItemInTycoonById(itemId, PlaceholderTycoon)
	if Item and PlaceholderTycoon.PrimaryPart then
		return PlaceholderTycoon.PrimaryPart.CFrame:ToObjectSpace(Item:GetPivot())
	end
	warn("Could not find item or PrimaryPart for relative CFrame")
	return nil
end

-- Gets a player's assigned tycoon
local function getTycoon(player)
	for _, tycoon in Tycoons:GetChildren() do
		if tycoon:GetAttribute("UserId") == player.UserId then
			return tycoon
		end
	end
	return nil
end

-- Unlocks an item for a player
local function unlockItem(player, itemId)
	if not itemId then
		warn("Attempted to unlock an item with a nil itemId.")
		return false
	end

	local tycoon = getTycoon(player)
	if not tycoon then return false end

	local Item = getItem(itemId)
	if not Item then
		warn("Item with ID " .. tostring(itemId) .. " not found in Items folder.")
		return false
	end

	Item = Item:Clone()
	local Cost = Item:GetAttribute('Cost') or 0

	if player.leaderstats.Cash.Value < Cost then
		return false
	end

	player.leaderstats.Cash.Value -= Cost

	local RelativeCF = getRelativeCframe(itemId)
	if not RelativeCF then return end

	local WorldCF = tycoon.PrimaryPart.CFrame:ToWorldSpace(RelativeCF)
	Item:PivotTo(WorldCF)
	Item.Parent = tycoon.Items

	return true
end

-- Button touch event
for _, Button in CollectionService:GetTagged("Button") do
	local ItemId = Button:GetAttribute('ItemId')
	local Item = getItem(ItemId)

	if Item and Button:FindFirstChild("BillboardGui") and Button.BillboardGui:FindFirstChild("TextLabel") then
		Button.BillboardGui.TextLabel.Text = Item.Name .. " - " .. (Item:GetAttribute('Cost') or "N/A")
	else
		warn("Button or BillboardGui/TextLabel issue with ItemId: " .. tostring(ItemId))
	end

	Button.Touched:Connect(function(hit)
		local itemId = Button:GetAttribute("ItemId")
		if not itemId then
			warn("Button missing 'ItemId' attribute.")
			return
		end

		if Button:GetAttribute('Unlocked') then return end

		local player = game.Players:GetPlayerFromCharacter(hit.Parent)
		if not player then return end

		local tycoon = getTycoon(player)
		if not tycoon then return end

		if not Button:IsDescendantOf(tycoon) then return end

		local success = unlockItem(player, itemId)
		if not success then return end

		Button.Transparency = 1
		Button.BillboardGui.Enabled = false
		Button:SetAttribute('Unlocked', true)
	end)
end

-- Player added event
game.Players.PlayerAdded:Connect(function(player)
	local Tycoon = assignTycoon(player)
	if not Tycoon then
		warn("Could not assign tycoon to " .. player.Name)
		return
	end

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = 'leaderstats'
	leaderstats.Parent = player

	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Value = 500
	cash.Parent = leaderstats
end)

game.Players.PlayerRemoving:Connect(function(player)
	local Tycoon = getTycoon(player)
	Tycoon.Items:ClearAllChildren()
	
	for _, Button in Tycoon.Button:GetChildren() do
		Button.Transparency = 0
		Button.BillboardGui.Enabled = true
	end
end)