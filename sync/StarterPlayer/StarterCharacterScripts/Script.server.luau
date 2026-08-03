local Lighting = game:GetService("Lighting")
local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
local Sky = Lighting:FindFirstChildOfClass("Sky")

Lighting.Ambient = Color3.fromRGB(0, 0, 0)
Lighting.Brightness = 1.19
Lighting.ClockTime = 12
Lighting.OutdoorAmbient = Color3.fromRGB(58, 39, 39)
Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)

Atmosphere.Density = 0.421
Atmosphere.Color = Color3.fromRGB(139, 42, 0)
Atmosphere.Decay = Color3.fromRGB(255, 107, 1)
Atmosphere.Glare = 0
Atmosphere.Haze = 0.1
		
Sky.SunAngularSize = 15
Sky.MoonAngularSize = 0
Sky.SkyboxUpContent = 35252826
	

