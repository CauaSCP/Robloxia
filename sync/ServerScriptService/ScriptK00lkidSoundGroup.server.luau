local sound_service = game:GetService("SoundService")

--for _, child in ipairs(sound_service:GetChildren()) do
--	print(">SoundService: ", child.Name, " | ", child.ClassName)
--end

local master_group = sound_service:WaitForChild("K00lkid")

local k00lkid_sounds = Instance.new("SoundGroup", master_group)
k00lkid_sounds.Name = "ForK00lkid"

--if master_group:IsA("SoundGroup") then
--	master_group.Volume = 0
--end
--k00lkid_sounds.Volume = 0.5

local music = game:GetService("ReplicatedStorage").Assets.Music

local for_sound_group_val: ObjectValue = music.K00lkid.SoundGroup
for_sound_group_val.Value = k00lkid_sounds

for _, c in ipairs(for_sound_group_val.Parent:GetChildren()) do
	if c:IsA("Sound") then
		c:Stop()
	end
end

--game:GetService("Players").PlayerAdded:Connect(function(player: Player)
--	music.K00lkidEvent:FireClient(player, music.K00lkid.SoundGroup.Value)
--end)