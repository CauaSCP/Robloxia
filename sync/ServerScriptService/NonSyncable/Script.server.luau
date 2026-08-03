
-- DARK_WORLD_SERVER.lua
-- Atmosfera escura balanceada (terror jogável)

local Lighting = game:GetService("Lighting")

Lighting.Brightness = 20
Lighting.ClockTime = 0
Lighting.GlobalShadows = true
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0

-- Ambiente quase preto
Lighting.Ambient = Color3.fromRGB(6,6,6)
Lighting.OutdoorAmbient = Color3.fromRGB(6,6,6)

-- Fog (mais fechado agora)
Lighting.FogColor = Color3.fromRGB(0,0,0)
Lighting.FogStart = 15
Lighting.FogEnd = 130

-- ColorCorrection
local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
if not cc then
	cc = Instance.new("ColorCorrectionEffect")
	cc.Parent = Lighting
end

cc.Brightness = -0.35
cc.Contrast = 0.15
cc.Saturation = -0.45

-- Bloom bem leve (só pra lanterna)
local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
if not bloom then
	bloom = Instance.new("BloomEffect")
	bloom.Parent = Lighting
end

bloom.Intensity = 0.25
bloom.Size = 18
bloom.Threshold = 0.65

-- Atmosphere sutil
local atm = Lighting:FindFirstChildOfClass("Atmosphere")
if not atm then
	atm = Instance.new("Atmosphere")
	atm.Parent = Lighting
end

pcall(function()
	atm.Density = 0.3
	atm.Haze = 0.9
	atm.Color = Color3.fromRGB(4,4,4)
end)

print("[DarkWorld] Atmosfera aplicada (balanceada).")
