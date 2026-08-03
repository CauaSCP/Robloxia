

local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

local player = players.LocalPlayer
local camera = workspace.CurrentCamera

-- REFERÊNCIAS
local cameraPart = replicatedStorage:WaitForChild("CameraPart")
local teleportEvent = replicatedStorage.RemoteEvents:WaitForChild("TeleportPlayer")

local screenGui = script.Parent
local fadeFrame = screenGui:WaitForChild("FadeFrame")
local playButton = screenGui:WaitForChild("PlayButton") 

local menuAmbience = screenGui:WaitForChild("MenuAmbience")

-- CONFIG
local TILT = -10
local SWAY_SPEED = 1.2

-- 1. Forçar estado inicial da GUI toda vez que o script carregar (reset)
fadeFrame.BackgroundTransparency = 0
fadeFrame.Visible = true
playButton.Visible = true

local function updateCamera()
	local t = tick() * SWAY_SPEED
	local sway = CFrame.Angles(math.rad(TILT), math.sin(t*0.5)*0.02, 0)
	camera.CFrame = cameraPart.CFrame * sway + Vector3.new(0, math.sin(t*0.5)*0.2, 0)
end

local function applyState()
	local isMenu = player:GetAttribute("IsInMenu")

	if isMenu == true then
		-- Entrou no Menu
		camera.CameraType = Enum.CameraType.Scriptable
		runService:BindToRenderStep("MenuCam", 200, updateCamera)
		playButton.Visible = true
		tweenService:Create(fadeFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
		
		menuAmbience:Play()
	else
		-- Saiu do Menu
		runService:UnbindFromRenderStep("MenuCam")
		camera.CameraType = Enum.CameraType.Custom
		playButton.Visible = false
		tweenService:Create(fadeFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
		
		menuAmbience:Stop()
	end
end

-- Conectar clique do botão
playButton.MouseButton1Click:Connect(function()
	if player:GetAttribute("IsInMenu") == true then
		local tween = tweenService:Create(fadeFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0})
		tween:Play()
		tween.Completed:Wait()
		teleportEvent:FireServer()
	end
end)

-- Escutar mudanças no atributo
player:GetAttributeChangedSignal("IsInMenu"):Connect(applyState)

-- RODAR IMEDIATAMENTE AO CARREGAR (O Pulo do Gato)
-- Esperamos o atributo existir para não dar erro
if player:GetAttribute("IsInMenu") == nil then
	repeat task.wait(0.1) until player:GetAttribute("IsInMenu") ~= nil
end

applyState()