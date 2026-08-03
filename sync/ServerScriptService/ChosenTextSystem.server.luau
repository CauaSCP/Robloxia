local debris = game:GetService("Debris")
local starterGui = game:GetService("StarterGui")

local chosenImgParent: Folder = script.FolderVal.Value
local chosenImg: ImageLabel?

while true do
    chosenImg = chosenImgParent:FindFirstChildOfClass("ImageLabel")

    if chosenImg ~= nil then
        break
    end

    task.wait()
end

local chosenKillerGui = starterGui:WaitForChild("ChosenKillerGui")
debris:AddItem(chosenKillerGui.ChosenImg)