hook.Add("OnNPCKilled", "DisableNPCWeaponDrop", function(npc)
    if IsValid(npc) then
        for _, weapon in ipairs(npc:GetWeapons()) do
            weapon:Remove()
        end
    end
end)