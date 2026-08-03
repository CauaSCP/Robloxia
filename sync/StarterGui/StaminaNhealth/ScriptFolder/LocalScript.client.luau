local ScreenGui = script.Parent.Parent
-- Ajustando para pegar o ViewportFrame corretamente pelo nome na sua imagem
local vpf = ScreenGui:WaitForChild("CharacterVPF") 
local worldModel = vpf:FindFirstChildOfClass("WorldModel") or Instance.new("WorldModel", vpf)
local player = game.Players.LocalPlayer

-- 1. Configurações da Câmera
local cam = Instance.new("Camera")
cam.FieldOfView = 25
cam.Parent = vpf
vpf.CurrentCamera = cam -- Agora vai funcionar porque vpf é o ViewportFrame

-- Iluminação
vpf.Ambient = Color3.fromRGB(200, 200, 200)
vpf.LightColor = Color3.fromRGB(255, 255, 255)
vpf.LightDirection = Vector3.new(-1, -1, -1)

local function setupHUD(char)
	if not char then return end

	worldModel:ClearAllChildren()

	if not player:HasAppearanceLoaded() then
		player.CharacterAppearanceLoaded:Wait()
	end
	task.wait(1) 

	char.Archivable = true
	local clonedChar = char:Clone()
	char.Archivable = false

	for _, item in ipairs(clonedChar:GetDescendants()) do
		if item:IsA("LuaSourceContainer") or item:IsA("Sound") then 
			item:Destroy() 
		end
	end

	clonedChar.Parent = worldModel

	local hrp = clonedChar:WaitForChild("HumanoidRootPart")
	-- Posiciona no centro do Viewport
	hrp.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(190), 0)

	-- Foco da Câmera
	local cameraOffset = Vector3.new(0, 1.5, 5)
	local targetPoint = Vector3.new(0, 1.5, 0)
	cam.CFrame = CFrame.new(cameraOffset, targetPoint)

	-- Animação
	local humanoid = clonedChar:FindFirstChildOfClass("Humanoid")
	if humanoid then
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://507766388"

		local track = animator:LoadAnimation(anim)
		track.Looped = true
		track:Play()
	end
end

if player.Character then
	task.spawn(setupHUD, player.Character)
end

player.CharacterAdded:Connect(function(newChar)
	task.spawn(setupHUD, newChar)
end)