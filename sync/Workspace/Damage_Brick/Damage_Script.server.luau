local sp = script.Parent
local db, dmg, cd = false, sp.Damage.Value, sp.Cooldown.Value

local function onT(part)
    if part and part.Parent then
        local human = part.Parent:FindFirstChild("Humanoid")
        if human and db ~= true then
            db = true
            human:TakeDamage(dmg)
            wait(cd)
            db = false
        end
    end
end

sp.Touched:Connect(onT)