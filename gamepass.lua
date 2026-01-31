local button = script.Parent
local player = game.Players.LocalPlayer
local gamePassId = script.Parent.GamepassId

button.MouseButton1Click:connect(function()
	if player then
		game:GetService("MarketplaceService"):PromptGamePassPurchase(player, gamePassId.Value)
	end
end)
