--autorun/client/death_counter_clientside.lua
-- Include shared definitions
include("autorun/shared/cp_ota_team_definitions_shared.lua")

local CivilProtectionDeaths = 0
local OTADeaths = 0

net.Receive("UpdateDeathCounters", function()
    CivilProtectionDeaths = net.ReadInt(32)
    OTADeaths = net.ReadInt(32)
end)

hook.Add("HUDPaint", "DisplayDeathCounters", function()
    local ply = LocalPlayer()
    if CivilProtectionTeams and OTATeams then
        if CivilProtectionTeams[ply:Team()] or OTATeams[ply:Team()] then
            draw.SimpleText("Civil Protection BSLs: " .. CivilProtectionDeaths, "DebugOverlay", 40, 160, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText("OTA BSLs: " .. OTADeaths, "DebugOverlay", 40, 180, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end
end)

hook.Add("OnPlayerChangedTeam", "RefreshScriptOnTeamChange", function(ply, oldTeam, newTeam)
    if ply == LocalPlayer() then
        include("autorun/client/death_counter_clientside.lua")
    end
end)