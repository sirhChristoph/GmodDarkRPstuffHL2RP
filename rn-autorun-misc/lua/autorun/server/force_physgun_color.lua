-- By sirhChristoph

local function SetWhitePhysgunColor(ply)
    local whiteColor = Vector(1, 1, 1) -- RGB values for white color
    ply:SetWeaponColor(whiteColor)
end

hook.Add("PlayerSpawn", "SetWhitePhysgunColorOnSpawn", function(ply)
    SetWhitePhysgunColor(ply)
end)

hook.Add("Think", "MaintainWhitePhysgunColor", function()
    for _, ply in ipairs(player.GetAll()) do
        SetWhitePhysgunColor(ply)
    end
end)