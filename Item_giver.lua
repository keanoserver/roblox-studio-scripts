local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local GAMEPASS_ID = 12345678 -- change to your gamepass ID
local TOOL_NAME = "Gravity_Coil" -- change to the item you want to give

local function giveItem(player)
	local tool = ServerStorage:FindFirstChild(TOOL_NAME)
	if tool then
		-- avoid duplicates
		if not player.Backpack:FindFirstChild(TOOL_NAME) 
			and not player.Character:FindFirstChild(TOOL_NAME) then
			tool:Clone().Parent = player.Backpack
		end
	end
end

-- When player joins → give item if they own the gamepass
Players.PlayerAdded:Connect(function(player)
	local ownsPass = false

	local success, result = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, GAMEPASS_ID)
	end)

	if success and result then
		giveItem(player)
	end
end)

-- When player buys the pass in-game
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, wasPurchased)
	if passId == GAMEPASS_ID and wasPurchased then
		giveItem(player)
	end
end)


