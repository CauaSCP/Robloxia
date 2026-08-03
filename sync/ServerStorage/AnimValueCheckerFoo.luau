local playAnimation = require(script.playAnim)

local meta_script: BaseScript
local function getAnimId(animValueName: string): (number|nil)
	local par: BaseScript|Instance|nil = ((meta_script :: Instance).Parent ::Instance).Parent

	assert(typeof(par) == "Instance", `{meta_script} doesn't have a Parent instance`)

	local childAnimVaue: IntValue|Instance|nil = par:FindFirstChild(animValueName)
	local full_name = par:GetFullName()

	if childAnimVaue == nil then
		warn(`1st argument [{animValueName}] could not find the child in {full_name}`)
		return
	end

	assert(childAnimVaue:IsA("IntValue"), `gotten child from {full_name} is not an IntValue but one {childAnimVaue.ClassName}`)

	return childAnimVaue.Value
end

export type type_of_required = (sc: BaseScript, character: Model) -> ()

local AnimValueCheckerFoo: type_of_required = function(sc, character): ()
	assert(typeof(sc) == "Instance", `{sc} is not even a roblox instance`)
	assert(not(sc:IsA("LocalScript")), `passed {sc.Name} is a LocalScript`)

	meta_script = sc
	local self = meta_script
	local valueOfAnimInst: ObjectValue|Instance = self.Parent

	assert(valueOfAnimInst:IsA("ObjectValue"), `{valueOfAnimInst} doesn't point to an Instance`)

	local animInst = valueOfAnimInst.Value
	assert(animInst ~= nil, `{valueOfAnimInst:GetFullName()} points to a nil Value`)

	local animId = getAnimId(animInst.Name)
	local tab = {i=0, e=0, d=0}
	
	if valueOfAnimInst.Value.Name:lower() == "idle" then
		tab.i = 1
	end
	
	if animId == nil then
		warn("animId is nil")
		return
	end

	playAnimation(character, (animId::number), tab)
end

return AnimValueCheckerFoo

