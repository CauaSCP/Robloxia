local storage = game:GetService("ServerStorage")
local anim_instance_sel = script.Parent

local animValueCheckerFoo = require(storage.AnimValueCheckerFoo)
local character: Model? = nil

local PROP = "Value"
anim_instance_sel:GetPropertyChangedSignal(PROP):Connect(function()
	print(PROP, "|", anim_instance_sel.Value)
	
	task.spawn(function()
		while true do
			if character ~= nil then
				break
			end
			
			task.wait()
		end
		
		assert(character:IsA("Model"), `{character:GetFullName()} is not a Model but one {character.ClassName}`)
		task.wait()
		
		print("doing defer")
		task.defer(function()
			animValueCheckerFoo(script, character)
		end)
		print("done defer")
	end)
end)


script.Parent.ChangeCharacter.Event:Connect(function(c: Model)
	task.spawn(function()
		print(`characterChanged: {c}`)
		
		if typeof(c) ~= "Instance" then
			warn(`[ERROR]: {c} is not a Model`)
		end

		character = c
	end)
end)