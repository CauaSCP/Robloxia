local tool = script.Parent
local humanoid = nil
local drinker = nil
local con = nil
local enabled = false

local drinked_event = script.Parent.ConsumedEvent

function onEquipped(mouse)
	tool.Handle.OpenSound:Play()
	humanoid = tool.Parent:FindFirstChild("Humanoid")
	if humanoid ~= nil then
		drinker = humanoid:LoadAnimation(tool.Drink)
	end
	con = mouse.Button1Down:connect(function() onButton1Down(mouse) end)
end

function onUnequipped(mouse)
	humanoid = nil
	if drinker ~= nil then
		drinker:remove()
		drinker = nil
	end
	if con ~= nil then
		con:disconnect()
	end
end

function onButton1Down(mouse)
	if enabled then
		return
	end
	
	enabled = true 

	drinked_event:FireServer()
	drinker:Play()

	tool.Handle.DrinkSound.Ended:Connect(function()
		script.Parent:Destroy()
		enabled = false
	end)

	tool.Handle.DrinkSound:Play()
end

tool.Equipped:connect(onEquipped)
tool.Unequipped:connect(onUnequipped)
