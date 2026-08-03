local starter_player = game:GetService("StarterPlayer")
local run_service = game:GetService("RunService")

run_service.PreSimulation:Connect(function()
	if script.PlayerOfChar.Value == nil then
		return
	end
	
	if not script.PlayerOfChar.Value.Parent:IsA("Players") then
		return
	end
	
	local clone = starter_player.StarterCharacterScripts.MovementAnimations
	
	clone.Parent = script.Parent
	clone.Enabled = true
end)