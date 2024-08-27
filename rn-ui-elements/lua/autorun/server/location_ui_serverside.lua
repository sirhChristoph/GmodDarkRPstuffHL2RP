AddCSLuaFile("autorun/shared/cp_ota_team_definitions_shared.lua")
include("autorun/shared/cp_ota_team_definitions_shared.lua")

AddCSLuaFile("autorun/shared/city9locations.lua")
AddCSLuaFile("autorun/client/location_ui_clientside.lua")
local city9locations = include("autorun/shared/city9locations.lua")

-- Function to get the area message for a player
local function GetPlayerAreaMessage(player)
    local pos = player:GetPos()
    for _, location in ipairs(city9locations) do
        if pos:WithinAABox(location.min, location.max) then
            return location.message
        end
    end
    return "Location: UNKNOWN"
end

-- Network message to send area message to client
util.AddNetworkString("UpdateAreaMessage")

-- Timer to periodically update player area messages
hook.Add("Initialize", "CheckTeamDefinitions", function()
    timer.Create("CheckTeamDefinitions", 10, 0, function()
        if _G.allowedTeams then
            -- Timer to periodically update player area messages
            timer.Create("UpdatePlayerAreaMessages", 4, 0, function() --update every 4 seconds, change to whatever you want. More time means less server load.
                for _, player in ipairs(player.GetAll()) do
                    if _G.allowedTeams[player:Team()] then
                        local message = GetPlayerAreaMessage(player)
                        net.Start("UpdateAreaMessage")
                        net.WriteString(message)
                        net.Send(player)
                    else
                        net.Start("UpdateAreaMessage")
                        net.WriteString("")
                        net.Send(player)
                    end
                end
            end)
            timer.Remove("CheckTeamDefinitions")
        else
            print("Waiting for TeamDefinitions table to be defined...")
        end
    end)
end)
