local player = game.Players.LocalPlayer
local part = game.WorkSpace:WaitForChild("DamagePart")

part.Touched:Connect(function()
	player.Character.Humanoid.Health -= 15
end)