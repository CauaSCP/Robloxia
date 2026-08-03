local hum = script.Parent:FindFirstChildWhichIsA("Humanoid")
local run_service = game:GetService("RunService")

run_service.Heartbeat:Connect(function()
	hum.JumpPower = 0
	hum.JumpHeight = 0
end)