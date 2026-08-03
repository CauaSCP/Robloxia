local test_service = game:GetService("TestService")
local storage = game:GetService("ReplicatedStorage")
local ViewportRotCall = storage.ViewportRotCall

local txt = string.format("[%s]: before setupHUD...", script.Name)
print(txt)

local rot_table = ViewportRotCall:InvokeServer()

-- for ind, coord in ipairs(rot_table) do
--     rot_table[ind] = math.rad(coord)
-- end

local rot_for_cframe = CFrame.fromEulerAnglesYXZ(unpack(rot_table))

local ScreenGui = script.Parent.Parent
-- Ajustando para pegar o ViewportFrame corretamente pelo nome na sua imagem
wait()
local bfr = ScreenGui:WaitForChild("MainFrame"):WaitForChild("VpMaster")
wait()

local vpf: ViewportFrame? = bfr:FindFirstChild("Real", true)

if vpf == nil then
	error("vpf not found")
end

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
	local cameraOffset = Vector3.new(0.25, 2.2, 7.4)
	local targetPoint = Vector3.new(0, 1.5, 0)

    cam.Focus = CFrame.new(targetPoint)
	cam.CFrame = CFrame.new(cameraOffset) * rot_for_cframe

    print("camera cframe:", cam.CFrame)

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