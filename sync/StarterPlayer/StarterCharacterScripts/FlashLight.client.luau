local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

local character = script.Parent
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local head = character:WaitForChild("Head")

local attachment = nil
local light = nil
local isOn = false
local connection = nil

-- CONFIGURAÇÕES
local TECLA_LANTERNA = Enum.KeyCode.F
local SUAV_LANTERNA = 0.15 
local SUAV_CORPO = 0.10    
local NOME_DO_BOTAO = "FlashLightButton" -- O nome exato que está no Explorer

-- Função para criar a luz
local function createLight()
	attachment = Instance.new("Attachment")
	attachment.Name = "MouseLightAttachment"
	attachment.Parent = head
	attachment.Position = Vector3.new(0, 0, -1.5) 

	light = Instance.new("SpotLight")
	light.Brightness = 3
	light.Range = 90
	light.Angle = 45
	light.Shadows = true
	light.Enabled = false
	light.Parent = attachment
end

-- Função que atualiza a posição da luz e do personagem
local function updateMovement()
	if isOn and light and attachment and rootPart then
		local targetPos = mouse.Hit.Position

		-- 1. Girar a LANTERNA (Seguindo o Mouse)
		local lightTargetCF = CFrame.lookAt(attachment.WorldPosition, targetPos)
		attachment.WorldCFrame = attachment.WorldCFrame:Lerp(lightTargetCF, SUAV_LANTERNA)

		-- 2. Girar o CORPO do Player (Apenas no eixo Y para não tombar)
		local rootLookPos = Vector3.new(targetPos.X, rootPart.Position.Y, targetPos.Z)
		local charTargetCF = CFrame.lookAt(rootPart.Position, rootLookPos)

		rootPart.CFrame = rootPart.CFrame:Lerp(charTargetCF, SUAV_CORPO)
	end
end

-- === NOVA FUNÇÃO CENTRAL PARA LIGAR/DESLIGAR ===
local function alternarLanterna()
	if not light then createLight() end

	isOn = not isOn
	light.Enabled = isOn

	if isOn then
		-- Desativa o giro padrão do Roblox e inicia a atualização suave
		humanoid.AutoRotate = false
		connection = runService.PreSimulation:Connect(updateMovement)
	else
		-- Devolve o controle ao Roblox e para o script
		humanoid.AutoRotate = true
		if connection then 
			connection:Disconnect() 
			connection = nil
		end
	end
end

-- === CONECTAR O TECLADO (TECLA F) ===
userInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == TECLA_LANTERNA then
		alternarLanterna()
	end
end)

-- === CONECTAR O BOTÃO DA UI (INTERFACE) ===
-- Função auxiliar para encontrar o botão recursivamente no PlayerGui
local function encontrarBotao(pai, nome)
	for _, filho in pairs(pai:GetDescendants()) do
		if filho.Name == nome and (filho:IsA("GuiButton") or filho:IsA("ImageButton") or filho:IsA("TextButton")) then
			return filho
		end
	end
	return nil
end

-- Tenta encontrar o botão e conectar o clique
task.spawn(function()
	local playerGui = player:WaitForChild("PlayerGui")
	-- Espera um pouco para garantir que a UI carregou
	local botaoUI = encontrarBotao(playerGui, NOME_DO_BOTAO)

	-- Se não achou de primeira, espera o botão aparecer
	if not botaoUI then
		-- Tenta procurar de novo caso tenha carregado depois
		wait(1) 
		botaoUI = encontrarBotao(playerGui, NOME_DO_BOTAO)
	end

	if botaoUI then
		-- Usa .Activated que funciona tanto pra PC (clique) quanto Mobile (toque)
		botaoUI.Activated:Connect(function()
			alternarLanterna()
		end)
		print("Botão da lanterna conectado com sucesso!")
	else
		warn("AVISO: O botão '"..NOME_DO_BOTAO.."' não foi encontrado na PlayerGui.")
	end
end)

-- Limpeza caso o personagem morra
humanoid.Died:Connect(function()
	if connection then connection:Disconnect() end
	if attachment then attachment:Destroy() end
end)