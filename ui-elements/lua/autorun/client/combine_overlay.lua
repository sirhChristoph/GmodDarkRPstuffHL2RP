-- Hook to draw the overlay on the player's screen, just uses the default gmod binoc overlay
hook.Add("RenderScreenspaceEffects", "DrawJobOverlay", function()
    local ply = LocalPlayer()
    if ply:GetNWBool("HasOverlay", false) then
        local overlay = Material("effects/combine_binocoverlay")
        render.UpdateScreenEffectTexture()
        overlay:SetFloat("$alpha", 0.3) -- Adjust the alpha value as needed so its not too much
        render.SetMaterial(overlay)
        render.DrawScreenQuad()
    end
end)
