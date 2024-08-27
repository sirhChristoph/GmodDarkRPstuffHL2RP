-- Unique identifier for the hook
local LocationUIhook = "DrawAreaText_Unique"

-- Hook to draw text on the screen
hook.Add("HUDPaint", LocationUIhook, function()
    local message = LocalPlayer():GetNWString("AreaMessage", "")
    if message ~= "" then
        draw.SimpleText(message, "DebugOverlay", 40, 200, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
end)

-- Receive network message from server
net.Receive("UpdateAreaMessage", function()
    local message = net.ReadString()
    local player = LocalPlayer()
    if IsValid(player) then
        player:SetNWString("AreaMessage", message)
    end
end)