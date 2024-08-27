--autorun/shared/cp_ota_team_definitions_shared.lua
hook.Add("loadCustomDarkRPItems", "DefineTeams", function() -- Waits for DarkRP to fully load to prevent NIL error with teams.
    -- Define the teams
    CivilProtectionTeams = {
        [TEAM_CPO] = true,
        [TEAM_CPR] = true,
        [TEAM_CPTL] = true,
    }

    OTATeams = {
        [TEAM_OTAEO] = true,
        [TEAM_OTAES] = true,
        [TEAM_OTAMS] = true,
        [TEAM_OTAEE] = true,
        [TEAM_OTAME] = true,
        [TEAM_OTAOV] = true,
        [TEAM_OTAOR] = true,
    }

    _G.allowedTeams = { -- globally accessible
        [TEAM_CPR] = true,
        [TEAM_CPO] = true,
        [TEAM_CPTL] = true,
        [TEAM_OTAEO] = true,
        [TEAM_OTAES] = true,
        [TEAM_OTAMS] = true,
        [TEAM_OTAEE] = true,
        [TEAM_OTAME] = true,
        [TEAM_OTAOV] = true,
        [TEAM_OTAOR] = true,
    }
end)
