local Frame = script.Parent.Parent.LevelFrame
local BarFrame = Frame.BarFrame
local Text = Frame.TextLabel
local Bar = BarFrame.Frame -- Frame da barra (parte que cresce)
local XPText = BarFrame.TextLabel

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Level = player:WaitForChild("leaderstats"):WaitForChild("Level")
local XP = player:WaitForChild("leaderstats2"):WaitForChild("XP")

local FrameBaseSize = UDim2.new(1, 0, 1, 0)

-- 🔹 XP necessário para o próximo level
local function GetRequiredXP(level)
	return (level + 1) * 25
end

-- 🔹 Atualiza barra e texto
local function UpdateUI()
	local requiredXP = GetRequiredXP(Level.Value)
	local progress = math.clamp(XP.Value / requiredXP, 0, 1)
	Text.Text = "LEVEL "..Level.Value

	Bar.Size = UDim2.new(progress, 0, 1, 0)
	XPText.Text = XP.Value.." / "..requiredXP.." XP"
end

-- 🔹 Conexões
XP:GetPropertyChangedSignal("Value"):Connect(UpdateUI)
Level:GetPropertyChangedSignal("Value"):Connect(UpdateUI)
UpdateUI()