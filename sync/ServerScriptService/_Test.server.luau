local module = require(game.Workspace.MainModule)

module:main()

local function DO(path: string, ClassName: string)
	local future_json: {[string]: string} = {}
	future_json['$className'] = ClassName

	table.freeze(future_json)

	module:pseudoStudio(path, future_json)
end

--local txt_s = '\n\n'

for key_as_path, class in pairs(module.rojo_conv) do
	if class and (key_as_path:find(".gui.json") == nil) then
		--txt_s ..= ((
		--	tostring("<%s> @is <%s>"):format(key_as_path, class)
		--).."\n\n")

		DO(key_as_path, class)
	end
end
--print(txt_s)
print(module:pseudoStudioResult())