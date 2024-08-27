-- Define a function to check if all TEAM_* constants are defined
local function areTeamsDefined()
    return TEAM_CPR and TEAM_CPO and TEAM_CPTL and TEAM_OTAEO and TEAM_OTAES and TEAM_OTAMS and TEAM_OTAEE and TEAM_OTAME and TEAM_OTAOV and TEAM_OTAOR
end

-- Use the PostGamemodeLoaded hook to ensure the script runs after all jobs are defined
hook.Add("PostGamemodeLoaded", "CheckTeamsAndLoadOverlay", function()
    if areTeamsDefined() then
        -- Define the teams that should have the overlay
        local overlayTeams = {
            [TEAM_CPR] = true,
            [TEAM_CPO] = true,
            [TEAM_CPTL] = true,
            [TEAM_OTAEO] = true,
            [TEAM_OTAES] = true,
            [TEAM_OTAMS] = true,
            [TEAM_OTAEE] = true,
            [TEAM_OTAME] = true,
            [TEAM_OTAOV] = true,
            [TEAM_OTAOR] = true
        }

        -- Function to apply the overlay based on the player's team
        local function ApplyOverlay(ply)
            if overlayTeams[ply:Team()] then
                ply:SetNWBool("HasOverlay", true)
            else
                ply:SetNWBool("HasOverlay", false)
            end
        end

        -- Hook to apply the overlay when a player spawns
        hook.Add("PlayerSpawn", "ApplyOverlayOnSpawn", function(ply)
            ApplyOverlay(ply)
        end)

        -- Hook to apply the overlay when a player changes team
        hook.Add("OnPlayerChangedTeam", "ApplyOverlayOnJobChange", function(ply, oldTeam, newTeam)
            ApplyOverlay(ply)
        end)

        print("Overlay teams table successfully created.") --Debug print, can be removed.
    else
        print("Error: One or more TEAM_* constants are not defined.") --Debug print, can be removed.
    end
end)
