print("SERVER OK")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Assets = ReplicatedStorage:WaitForChild("Assets")
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local AttackRemote = RemoteEvents:WaitForChild("Attack")

local HitboxTemplate = Assets:WaitForChild("Hitboxes"):WaitForChild("Attack")

local cooldown = {}

AttackRemote.OnServerEvent:Connect(function(player)
	print("SERVER RECEBEU ATAQUE")

	if cooldown[player] then return end
	cooldown[player] = true

	local character = player.Character
	if not character then return end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local hitbox = HitboxTemplate:Clone()
	hitbox.Anchored = true
	hitbox.CanCollide = false
	hitbox.Transparency = 0.3
	hitbox.Size = Vector3.new(5,5,5)
	hitbox.CFrame = hrp.CFrame * CFrame.new(0,0,-5)
	hitbox.Parent = workspace

	AttackRemote:FireClient(player)

	task.delay(0.5, function()
		hitbox:Destroy()
	end)

	task.delay(1, function()
		cooldown[player] = nil
	end)
end)
