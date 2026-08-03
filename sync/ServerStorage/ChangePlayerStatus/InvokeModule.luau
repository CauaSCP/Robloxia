local Types = require(script.Parent.Parent.Consumables.TypesModule)

local module = function(calculation_methods: {[string|Types.Status]: Types.Method}, player: Player)
	script.Parent:Invoke(calculation_methods, player)
end

return module
