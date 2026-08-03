local limits_event = game:GetService("ReplicatedStorage").BarriersLimitEvent
local barriers_par = script.BarriersLimit
local players = game:GetService("Players")

players.PlayerAdded:Connect(function(player: Player)
	wait()
	
	if not barriers_par.Parent:IsA("Workspace") then
		return
	end
	
	limits_event:FireClient(player)
end)

wait()

barriers_par.Parent = game.Workspace

wait()