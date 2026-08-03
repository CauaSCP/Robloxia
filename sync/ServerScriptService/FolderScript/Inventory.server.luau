local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("PlayerData")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

--- StarterData
local StarterData = {
	Inventory = {},
	GamePass = {},
}
--- PlayerAdded
game.Players.PlayerAdded:Connect(function(Player)
	local success, data = pcall(function()
		return DataStore:GetAsync(tostring(Player.UserId))
	end)

	local PlayerData = data or StarterData

	local PlayerInventory = Instance.new("Folder")
	PlayerInventory.Name = "PlayerInventory"
	PlayerInventory.Parent = Player

	local PlayerGamePass = Instance.new("Folder")
	PlayerGamePass.Name = "PlayerGamePass"
	PlayerGamePass.Parent = Player

	for i, v in ipairs(PlayerData.Inventory) do
		local item = game.ServerStorage.InventoryFolder:FindFirstChild(v)
		if item then
			item:Clone().Parent = PlayerInventory
		end
	end
	for i, v in ipairs(PlayerData.GamePass) do
		local item = game.ServerStorage.GamePassFolder:FindFirstChild(v)
		if item then
			item:Clone().Parent = PlayerGamePass
		end
	end
end)
--- PlayerRemoving
game.Players.PlayerRemoving:Connect(function(Player)
	local PlayerData = {
		Inventory = {},
		GamePass = {},
	}

	for _, v in ipairs(Player:FindFirstChild("PlayerInventory"):GetChildren()) do
		table.insert(PlayerData.Inventory, v.Name)
	end
	for _, v in ipairs(Player:FindFirstChild("PlayerGamePass"):GetChildren()) do
		table.insert(PlayerData.GamePass, v.Name)
	end

	pcall(function()
		DataStore:SetAsync(tostring(Player.UserId), PlayerData)
	end)
end)

-- Reaparecimento do personagem (reativa o equipamento)
game.Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function()
		-- Espera o inventário ser carregado
		local PlayerInventory = Player:WaitForChild("PlayerInventory")
		
		-- Tools
		for _, v in ipairs(PlayerInventory:GetChildren()) do
			if v:IsA("Tool") then
				local clone = v:Clone()
				clone.Parent = Player.Backpack
			end
		end
	end)
end)