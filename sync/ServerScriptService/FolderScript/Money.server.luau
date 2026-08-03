local PlayerStatsManager = {}

--// Serviços
local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

--// Configuração
local DataStore_Name = "CoinsStore"
local PlayerDataStore = DataStoreService:GetDataStore(DataStore_Name)

--// Cria a estrutura de estatísticas do jogador
local function CriarStatsPlayersFolder(player)
	local statsFolders = {
		leaderstats = Instance.new("Folder"),
		leaderstats2 = Instance.new("Folder")
	}

	statsFolders.leaderstats.Name = "leaderstats"
	statsFolders.leaderstats.Parent = player

	statsFolders.leaderstats2.Name = "leaderstats2"
	statsFolders.leaderstats2.Parent = player

	local Stats1 = {
		["Money"] = Instance.new("NumberValue"),
		["Level"] = Instance.new("NumberValue"),
	}

	local Stats2 = {
		["XP"] = Instance.new("NumberValue"),
	}

	for name, val in pairs(Stats1) do
		val.Name = name
		val.Parent = statsFolders.leaderstats
	end

	for name, val in pairs(Stats2) do
		val.Name = name
		val.Parent = statsFolders.leaderstats2
	end

	return statsFolders
end

--// Level System (Server)
local function GetRequiredXP(level)
	return (level + 1) * 25
end

local function SetupPlayer(player)
	local leaderstats = player:WaitForChild("leaderstats")
	local leaderstats2 = player:WaitForChild("leaderstats2")

	local Level = leaderstats:WaitForChild("Level")
	local XP = leaderstats2:WaitForChild("XP")

	XP.Changed:Connect(function()
		while XP.Value >= GetRequiredXP(Level.Value) do
			local requiredXP = GetRequiredXP(Level.Value)
			XP.Value -= requiredXP
			Level.Value += 1
		end
	end)
end

--// Carrega dados do jogador
function PlayerStatsManager.LoadPlayerData(player)
	local userId = player.UserId
	local statsFolders = CriarStatsPlayersFolder(player)

	local success, data = pcall(function()
		return PlayerDataStore:GetAsync(tostring(userId))
	end)

	if success and data then
		statsFolders.leaderstats["Money"].Value = data.Money or 100
		statsFolders.leaderstats["Level"].Value = data.Level or 0
		statsFolders.leaderstats2["XP"].Value = data.XP or 0
	else
		warn(`Falha ao carregar dados para {player.Name}: {(not success and data) or "Dados não encontrados"}`)

		statsFolders.leaderstats["Money"].Value = 100
		statsFolders.leaderstats["Level"].Value = 0
		statsFolders.leaderstats2["XP"].Value = 0
	end
end

--// Salva dados do jogador
function PlayerStatsManager.SavePlayerData(player)
	if not player:FindFirstChild("leaderstats") or not player:FindFirstChild("leaderstats2") then
		warn(`Estrutura de stats não encontrada para {player.Name}`)
		return
	end

	local userId = player.UserId

	local dataToSave = {
		Money = player.leaderstats["Money"].Value,
		Level = player.leaderstats["Level"].Value,
		XP = player.leaderstats2["XP"].Value
	}

	local success, err = pcall(function()
		PlayerDataStore:SetAsync(tostring(userId), dataToSave)
	end)

	if not success then
		warn(`Falha ao salvar os dados para {player.Name}: {err}`)
	end
end

--// Eventos de entrada e saída dos jogadores
Players.PlayerAdded:Connect(function(player)
	PlayerStatsManager.LoadPlayerData(player)
	task.spawn(function()
		SetupPlayer(player)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	PlayerStatsManager.SavePlayerData(player)
end)