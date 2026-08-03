--local dyn_barriers: {BasePart} = {}

--local replicated_storage = game:GetService("ReplicatedStorage")
--local barriers_event = replicated_storage.BarriersLimitEvent

--local function barriers_spawning()
--	for i, b in ipairs(replicated_storage.DynamicBarrierSystem.DynamicBarriers:GetChildren()) do
--		if not(b:IsA("BasePart")) then
--			continue
--		end

--		local clon: BasePart = b:Clone()

--		local gui = replicated_storage.DynamicBarrierSystem.SurfaceGui:Clone()
--		gui.Parent = clon

--		clon.Parent = game.Workspace.MainMap.Secondary.BarrierSystem.DynamicSystem

--		table.insert(dyn_barriers, clon)

--		game:GetService("ReplicatedStorage").ToSetPosAndSizeFoo:Invoke(clon)
--	end
--end

--barriers_event.OnClientEvent:Connect(barriers_spawning)