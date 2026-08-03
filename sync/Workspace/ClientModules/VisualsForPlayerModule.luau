export type Foo = (self: CoreGui) -> (any|nil, any|nil)
export type MetaFoo = (foo: Foo) -> (nil|{[any]: any|nil})

local VisualsForPlayerModule = {}


function VisualsForPlayerModule.CoreGui(foo: Foo|nil): (BasePlayerGui|nil|{[any]: any|nil})
    local core_gui = game.CoreGui

    if foo == nil then
        return core_gui
    end

    if typeof(foo) == "function" then
        print("> el", core_gui)

        return table.pack(foo(core_gui))
    end

    local msg = tostring("parsed parameter is not a fuction but a [%s]...")

    if typeof(foo) == "Instance" then
        error(msg:format(tostring(foo.ClassName)))
    end

    error(msg:format(typeof(foo)))
end

function VisualsForPlayerModule:main(): MetaFoo
    local remote = script.CallingClient

    local onClientInvoke: MetaFoo = function()
        -- local _core_gui = VisualsForPlayerModule.CoreGui()

        -- if not(typeof(_core_gui) == "Instance" and _core_gui:IsA("CoreGui")) then
        --     error("gotten core_gui is not correct")
        -- end

        -- local core_gui: BasePlayerGui = _core_gui

        local local_foo: Foo = function(self)
            print("> lok", self)

            local it_is = false
            pcall(function()
                it_is = self:IsA("BasePlayerGui")
            end)

            if not it_is then
                error("gotten CoreGui is not correct")
            end

            local path_as_list = table.freeze({"CoreGui", "RobloxGui", "Backpack"})
            local whole_path = table.concat(path_as_list, "/")

            local top: Instance

            top = self
            local bottom: Instance = top

            local j: number

            for i = 1, (#(path_as_list)) do
                if path_as_list[i] ~= bottom.Name then
                    error(`path for '{path_as_list[i]}' is wrong at 'rbx://{whole_path}'!`)
                end

                j = math.min(i+1, #(path_as_list))

                bottom = bottom:WaitForChild(path_as_list[j])
            end

            print("> className: ", bottom.ClassName)
        end

		VisualsForPlayerModule.CoreGui(local_foo)
		
		return (nil)
	end
	
	remote.OnClientInvoke = onClientInvoke()
	
	return remote.OnClientInvoke
end

return VisualsForPlayerModule
