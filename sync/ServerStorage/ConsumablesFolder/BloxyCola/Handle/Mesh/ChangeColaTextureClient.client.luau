local client_modules_par = game.Workspace

--script.Parent = script.Parent.Handle.Mesh

local __get_nam_from = game.Workspace.ClientModules.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        --[[    

__nam will be:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            ]]	
	ChangeTextureBloxyCola


local cola_module = require(__get_nam_from)

local __nam: string = __get_nam_from.Name

local moduls: {[string]: cola_module.ChangeTextureBloxyCola}



local function getStorChildOrOther(sc: BaseScript): Instance
	return sc.Parent.Parent.Parent.Parent
end

local master: () -> (any|nil) = function()
	local _moduls: Instance = client_modules_par.ClientModules; local to_req = _moduls:WaitForChild(__nam); pcall(function() cola_module = require(to_req) end)

	moduls = {}
	moduls[__nam] = cola_module

	local cola_module_name = __nam
	local main = 'main'

	local _run: cola_module.main = moduls[cola_module_name][main]; return _run(script)
end

local res

task.spawn(function()
	pcall(function()
		cola_module = nil
		client_modules_par = getStorChildOrOther(script)
	end)

	print("texture waiting...")

	local w

	while true do
		w = getStorChildOrOther(script):FindFirstAncestorOfClass("Workspace")
		
		
		if not((getStorChildOrOther(script).Parent):IsA("ServerStorage")) and w ~= nil then
			print(script:GetFullName())
			client_modules_par = w

			res = master()
			break
		end

		task.wait()
	end
end)


return res