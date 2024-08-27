AddCSLuaFile("autorun/shared/cp_ota_team_definitions_shared.lua")
include("autorun/shared/cp_ota_team_definitions_shared.lua")

-- Initialize death counters
local CivilProtectionDeaths = 0
local OTADeaths = 0

-- Function to update the death counters
local function UpdateDeathCounters()
    net.Start("UpdateDeathCounters")
    net.WriteInt(CivilProtectionDeaths, 32)
    net.WriteInt(OTADeaths, 32)
    net.Broadcast()
end

-- Function to handle player deaths
local function OnPlayerDeath(victim, inflictor, attacker)
    if _G.CivilProtectionTeams and _G.CivilProtectionTeams[victim:Team()] then
        CivilProtectionDeaths = CivilProtectionDeaths + 1
        timer.Simple(180, function()
            CivilProtectionDeaths = CivilProtectionDeaths - 1
            UpdateDeathCounters()
        end)
    elseif _G.OTATeams and _G.OTATeams[victim:Team()] then
        OTADeaths = OTADeaths + 1
        timer.Simple(180, function()
            OTADeaths = CivilProtectionDeaths - 1
            UpdateDeathCounters()
        end)
    end
    UpdateDeathCounters()
end

-- Ensure the script runs only when the server is fully loaded
hook.Add("Initialize", "CheckTeamDefinitionsForDeathCounter", function()
    timer.Create("CheckTeamDefinitionsForDeathCounter", 10, 0, function()
        if _G.CivilProtectionTeams and _G.OTATeams then
            -- Hook to track player deaths
            hook.Add("PlayerDeath", "TrackPlayerDeaths", OnPlayerDeath)
            util.AddNetworkString("UpdateDeathCounters")
            timer.Remove("CheckTeamDefinitionsForDeathCounter")
        else
            print("Waiting for TeamDefinitions tables to be defined...")
        end
    end)
end)