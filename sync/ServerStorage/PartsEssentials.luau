export type Module = {
	physics_service: PhysicsService,
	within_hitbox_group: () -> string,
	getPossibeChar: (instance: Instance) -> Model?,
	isInACharacter: (instance: Instance) -> boolean,
	processPart: (part: BasePart|Instance, collision_group: string?) -> nil,
	for_loop_in_descs: () -> nil,
	collision_groups: {string}
}

local getPossibeChar = function(instance: Instance)
	return instance:FindFirstAncestorOfClass("Model")
end

local module: Module = {
	within_hitbox_group = function(...): string
		local group = "WithinHitbox"
		
		local _p: BasePart? = table.pack(...)[1]
		
		if _p ~= nil then
			pcall(function() 
				_p.CollisionGroup = group
			end)
		end
		
		return group
	end,
	physics_service = game:GetService("PhysicsService"),
	isInACharacter = function(instance: Instance): boolean
		local char: Model? = nil
		local hum: Humanoid? = nil
		
		while true do
			char = getPossibeChar(instance); if char == nil then
				return false
			end
			
			hum = char:FindFirstChildOfClass("Humanoid"); if hum == nil then
				instance = char
			end
			
			if hum ~= nil then
				return true
			end
			
			if char.Parent == game.Workspace then
				break
			end
			
			task.wait()
		end
		
		return false
	end
}

module.collision_groups = {
	"PlayerParts",
	"HitBox",
	"DynamicBarriers",
	"Default"
}

table.freeze(module.collision_groups)

module.getPossibeChar = getPossibeChar
function module.processPart(part: BasePart|Instance, collision_group: string?)
	if not part:IsA("BasePart") then
		return
	end
	
	if collision_group == nil then
		collision_group = module.within_hitbox_group()
	end
	
	local is_in_char = module.isInACharacter(part)
	
	if not is_in_char then
		part.CollisionGroup = collision_group
	end
	
	print(part:GetFullName(), is_in_char, part.CollisionGroup)
end

module.for_loop_in_descs = function()
	for _, desc in ipairs(game.Workspace:GetDescendants()) do
		module.processPart(desc)
	end
end

return module
