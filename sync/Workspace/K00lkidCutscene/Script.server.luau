-- Coloque este Script como filho do Model do personagem (script.Parent = Model)
-- LuaU / Roblox

local model = script.Parent
local ANIM_ID = "rbxassetid://139155559817497"
local WAIT_BEFORE_TELEPORT = 1.8
local TELEPORT_POSITION = Vector3.new(3575.458, 86.523, -3327.018)

-- Rush params (ajuste aqui)
local RUSH_SPEED = 120        -- studs/segundo (aumente para mais rápido)
local RUSH_DURATION = 0.6     -- segundos que o "rush" dura
local RUSH_MAXFORCE = 1e5     -- força máxima do BodyVelocity (muito alto = ignora física)

-- helpers
local function getHumanoid(m)
	for _, v in ipairs(m:GetDescendants()) do
		if v:IsA("Humanoid") then
			return v
		end
	end
	return nil
end

local function getHRP(m)
	-- tenta achar HumanoidRootPart, senão PrimaryPart
	local hrp = m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart
	return hrp
end

-- início
local humanoid = getHumanoid(model)
local hrp = getHRP(model)

if not humanoid or not hrp then
	warn("Script: não encontrou Humanoid ou HumanoidRootPart/PrimaryPart no modelo. Saindo.")
	return
end

-- garante que exista um Animator
local animator = humanoid:FindFirstChildOfClass("Animator")
if not animator then
	animator = Instance.new("Animator")
	animator.Parent = humanoid
end

-- cria e toca animação
local animation = Instance.new("Animation")
animation.AnimationId = ANIM_ID

local success, track = pcall(function()
	return animator:LoadAnimation(animation)
end)

if not success or not track then
	warn("Falha ao carregar animação. ID:", ANIM_ID)
else
	track:Play()
end

-- espera o tempo pedido
task.wait(WAIT_BEFORE_TELEPORT)

-- teleport (mantém a orientação do personagem: usa lookVector atual)
local look = hrp.CFrame.LookVector
local targetCFrame = CFrame.new(TELEPORT_POSITION, TELEPORT_POSITION + look)

-- uso SetPrimaryPartCFrame se PrimaryPart está definido, senão setamos o CFrame do HRP
if model.PrimaryPart then
	model:SetPrimaryPartCFrame(targetCFrame)
else
	hrp.CFrame = targetCFrame
end

-- agora o rush pra frente: aplicamos um BodyVelocity no HRP
local bodyVel = Instance.new("BodyVelocity")
bodyVel.Name = "RushBodyVelocity"
bodyVel.MaxForce = Vector3.new(RUSH_MAXFORCE, RUSH_MAXFORCE, RUSH_MAXFORCE)
bodyVel.Velocity = hrp.CFrame.LookVector * RUSH_SPEED
bodyVel.Parent = hrp

-- opcional: desabilitar controle momentaneamente (se for NPC humanoide)
-- humanoid.PlatformStand = true  -- descomente se quiser evitar interferência do Humanoid

task.delay(RUSH_DURATION, function()
	if bodyVel and bodyVel.Parent then
		bodyVel:Destroy()
	end
	-- humanoid.PlatformStand = false -- se você desabilitou acima, reabilite aqui
end)

-- fim
