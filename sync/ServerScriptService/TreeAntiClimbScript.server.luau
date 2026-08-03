-- Script para impedir que players subam nas árvores Tré
-- Verifica continuamente e empurra players para longe das árvores

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Lista de todas as Parts das árvores
local treeParts = {}

-- Função para adicionar uma Part de árvore à lista
local function addTreePart(part)
    if part and part:IsA("BasePart") and part.Name == "Part" then
        table.insert(treeParts, part)
    end
end

-- Função para configurar uma árvore
local function setupTree(model)
    if model:IsA("Model") and model.Name == "Tré" then
        local part = model:FindFirstChild("Part")
        addTreePart(part)
    end
end

-- Configurar árvores existentes
for _, descendant in Workspace:GetDescendants() do
    setupTree(descendant)
end

-- Configurar novas árvores adicionadas durante o jogo
Workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Model") and descendant.Name == "Tré" then
        setupTree(descendant)
    elseif descendant.Name == "Part" and descendant.Parent and descendant.Parent.Name == "Tré" then
        addTreePart(descendant)
    end
end)

-- Loop principal que verifica e empurra players
RunService.Heartbeat:Connect(function()
    for _, player in Players:GetPlayers() do
        local character = player.Character
        if not character then continue end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not hrp or humanoid.Health <= 0 then continue end
        
        local playerPos = hrp.Position
        
        -- Verificar cada árvore
        for _, treePart in treeParts do
            if not treePart or not treePart.Parent then continue end
            
            -- Calcular distância 3D real entre o player e a árvore
            local distance = (playerPos - treePart.Position).Magnitude
            
            -- Calcular o raio aproximado da árvore (baseado no tamanho)
            local treeRadius = math.max(treePart.Size.X, treePart.Size.Z) / 2
            
            -- Só ativar se o player estiver a 2 studs ou menos da hitbox da árvore
            local activationDistance = treeRadius + 0
            
            if distance < activationDistance then
                -- Player está muito perto da árvore, empurrar!
                
                -- Calcular direção do centro da árvore para o player
                local direction = (playerPos - treePart.Position).Unit
                
                -- Separar em componentes horizontal e vertical
                local horizontalDirection = Vector3.new(direction.X, 0, direction.Z).Unit
                
                -- Forças de knockback
                local knockbackForce = 20   -- Força horizontal
                local downForce = 50      -- Força vertical (para baixo)
                
                -- Aplicar knockback
                hrp.AssemblyLinearVelocity = Vector3.new(
                    horizontalDirection.X * knockbackForce,
                    -downForce,
                    horizontalDirection.Z * knockbackForce
                )
                
                -- Reduzir velocidade de caminhada
                humanoid.WalkSpeed = 0
                
                break -- Só precisa empurrar uma vez por frame
            end
        end
    end
end)