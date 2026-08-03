local light = script.Parent
local part = script.Parent.Parent

while true do
	task.wait(math.random(0.6, 1.5))
	light.Enabled = true
	part.Material = Enum.Material.Neon
	task.wait(math.random(0.5, 1.6))
	light.Enabled = false
	part.Material = Enum.Material.Glass
end