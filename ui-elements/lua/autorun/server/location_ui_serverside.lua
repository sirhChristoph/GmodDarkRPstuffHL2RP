AddCSLuaFile("autorun/shared/cp_ota_team_definitions_shared.lua")
include("autorun/shared/cp_ota_team_definitions_shared.lua")

AddCSLuaFile("autorun/client/location_ui_clientside.lua")

-- Function to get the location table based on the current map
local function GetLocationTable()
    local mapName = game.GetMap()
    local locationFile = "autorun/shared/" .. mapName .. "locations.lua"
    
    if file.Exists(locationFile, "LUA") then
        AddCSLuaFile(locationFile)
        return include(locationFile)
    else
        print("Location file for map " .. mapName .. " not found!")
        return {}
    end
end

local locations = GetLocationTable()

-- Function to get the area message for a player
local function GetPlayerAreaMessage(player)
    local pos = player:GetPos()
    for _, location in ipairs(locations) do
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
