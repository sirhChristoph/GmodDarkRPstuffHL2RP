-- Define the velocity reduction factor
local velocityReductionFactor = 0.7

-- Hook into the OnPlayerHitGround event
hook.Add("OnPlayerHitGround", "AntiBHOP", function(ply, inWater, onFloater, speed)
    if not inWater then
        local velocity = ply:GetVelocity()
        velocity.x = velocity.x * velocityReductionFactor
        velocity.y = velocity.y * velocityReductionFactor
        ply:SetVelocity(velocity - ply:GetVelocity())
    end
end)