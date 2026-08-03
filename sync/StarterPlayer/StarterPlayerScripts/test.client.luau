local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

print("--- [SISTEMA DE TERROR K00LKID] INICIANDO ---")

--------------------------------------------------------------------------------
-- CONFIGURAÇÕES
--------------------------------------------------------------------------------
local DIST_LAYER_1 = 150
local DIST_LAYER_2 = 110
local DIST_LAYER_3 = 70
local DIST_CHASE = 35
local CHASE_COOLDOWN = 5 
local FADE_TIME = 0.3 
local MAX_VOLUME = 0.7

local player = Players.LocalPlayer

-- REFERÊNCIA DAS PASTAS (Corrigido: Music -> K00lkid)
local assets = ReplicatedStorage:WaitForChild("Assets")
local musicFolder = assets:WaitForChild("Music")
local killerMusicFolder = musicFolder:WaitForChild("K00lkid") -- A pasta que faltava!

print("[OK] Pasta de música do K00lkid encontrada.")

-- Tabela de sons
local sounds = {
	Layer1 = killerMusicFolder:WaitForChild("Layer1"),
	Layer2 = killerMusicFolder:WaitForChild("Layer2"),
	Layer3 = killerMusicFolder:WaitForChild("Layer3"),
	Chase = killerMusicFolder:WaitForChild("Chase"),
	LowLife = killerMusicFolder:WaitForChild("LowLife")
}

-- Configuração inicial
for name, sound in pairs(sounds) do
	sound.Volume = 0
	sound.Looped = true
	sound:Stop() 
	print("[CARREGADO] Som pronto: " .. name)
end

local lastChaseTime = 0
local isInChaseMode = false
local currentActiveState = "None"

--------------------------------------------------------------------------------
-- FUNÇÃO DE TRANSIÇÃO
--------------------------------------------------------------------------------
local function playState(stateName)
	if currentActiveState == stateName then return end

	print("[ESTADO] Alterado para: " .. stateName)
	currentActiveState = stateName

	for name, soundObj in pairs(sounds) do
		if name == stateName then
			soundObj.Volume = 0 
			soundObj:Play() -- Resetando para o começo conforme solicitado
			TweenService:Create(soundObj, TweenInfo.new(FADE_TIME), {Volume = MAX_VOLUME}):Play()
		else
			-- Fade out e Stop nos outros
			local tween = TweenService:Create(soundObj, TweenInfo.new(FADE_TIME), {Volume = 0})
			tween:Play()

			task.delay(FADE_TIME, function()
				if currentActiveState ~= name then
					soundObj:Stop()
				end
			end)
		end
	end
end

--------------------------------------------------------------------------------
-- LOOP PRINCIPAL
--------------------------------------------------------------------------------

print("[DEBUG] Aguardando modelo do Killer no Workspace...")
local killerModel = Workspace:WaitForChild("K00lkid") 
print("[OK] Killer detectado.")

--RunService.PreSimulation:Connect(function()
--	local char = player.Character
--	if not char then return end

--	local myRoot = char:FindFirstChild("HumanoidRootPart")
--	local myHum = char:FindFirstChild("Humanoid")
--	local killerRoot = killerModel:FindFirstChild("HumanoidRootPart")

--	-- Se o killer for deletado ou player morrer
--	if not myRoot or not myHum or myHum.Health <= 0 or not killerRoot then
--		if currentActiveState ~= "None" then
--			playState("None")
--		end
--		return
--	end

--	local distance = (killerRoot.Position - myRoot.Position).Magnitude
--	local stateToPlay = "None"
--	local currentTime = tick()

--	-- Lógica de Chase (Persistência)
--	if distance <= DIST_CHASE then
--		if not isInChaseMode then print("[!] CHASE INICIADA") end
--		isInChaseMode = true
--		lastChaseTime = currentTime
--	elseif isInChaseMode then
--		if (currentTime - lastChaseTime) > CHASE_COOLDOWN then
--			isInChaseMode = false
--			print("[?] CHASE ENCERRADA POR DISTÂNCIA")
--		end
--	end

--	-- Decisão do Som (Prioridade LowLife em Chase)
--	if isInChaseMode then
--		stateToPlay = (myHum.Health <= 25) and "LowLife" or "Chase"
--	else
--		if distance <= DIST_LAYER_3 then 
--			stateToPlay = "Layer3"
--		elseif distance <= DIST_LAYER_2 then 
--			stateToPlay = "Layer2"
--		elseif distance <= DIST_LAYER_1 then 
--			stateToPlay = "Layer1"
--		else 
--			stateToPlay = "None"
--		end
--	end

--	playState(stateToPlay)
--end)