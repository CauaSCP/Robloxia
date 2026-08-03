local storage = game:GetService("ServerStorage")
local parts_essentials = require(storage.PartsEssentials)

parts_essentials.physics_service:RegisterCollisionGroup(parts_essentials.within_hitbox_group())

game.Workspace.DescendantAdded:Connect(parts_essentials.processPart)

parts_essentials.for_loop_in_descs()
