local Tool = script.Parent;

enabled = true




function onActivated()
	if not enabled  then
		return
	end

	enabled = false
	Tool.Handle.DrinkSound:Play()
	wait(0.4)
	Tool.drinker.DrinkEmitter.Enabled = true
	wait(0.5)
	Tool.drinker.DrinkEmitter.Enabled = false
	wait(2.1)
	
	local h = Tool.Parent:FindFirstChild("Humanoid")
	if (h ~= nil) then
		if (h.MaxHealth > h.Health + 5) then
			h.Health = h.Health + 5
		else	
			h.Health = h.MaxHealth
		end
	end

	enabled = true

end

function onEquipped()
	Tool.Handle.OpenSound:Play()
	wait(0.3)
	Tool.Handle.ParticleEmitter.Enabled = true
	wait(0.5)
	Tool.Handle.ParticleEmitter.Enabled = false
end

script.Parent.Activated:connect(onActivated)
script.Parent.Equipped:connect(onEquipped)
