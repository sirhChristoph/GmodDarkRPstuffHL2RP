local function InitializeTooManyDeaths()
    -- Define the teams you want to monitor
    local TEAMS_TO_MONITOR = {TEAM_CPR, TEAM_CPO, TEAM_CPTL, TEAM_OTAEO, TEAM_OTAES, TEAM_OTAMS, TEAM_OTAEE, TEAM_OTAME, TEAM_OTAOV, TEAM_OTAOR} -- Add the teams you want to monitor

    -- Define the sounds to play
    local SOUNDS_TO_PLAY = {
        "npc/overwatch/cityvoice/f_unrestprocedure1_spkr.wav"
    }

    -- Initialize a table to keep track of deaths for each team
    local deathCounter = {}
    local lastSoundTime = 0

    -- Function to reset the death counter for all teams
    local function resetDeathCounter()
        deathCounter = {}
        for _, teamID in ipairs(TEAMS_TO_MONITOR) do
            deathCounter[teamID] = {}
        end
    end

    -- Initialize the death counter table
    resetDeathCounter()

    -- Function to play multiple sounds sequentially
    local function playSoundsSequentially()
        local currentTime = CurTime()
        if currentTime - lastSoundTime >= 300 then -- Check if 5 minutes have passed
            for _, soundPath in ipairs(SOUNDS_TO_PLAY) do
                timer.Simple(_, function()
                    for _, player in ipairs(player.GetAll()) do
                        player:SendLua([[surface.PlaySound("]] .. soundPath .. [[")]])
                    end
                end)
            end
            lastSoundTime = currentTime -- Update the last sound play time
        end
    end

    -- Hook into the player death event
    hook.Add("PlayerDeath", "CheckTeamDeaths", function(victim, inflictor, attacker)
        local victimTeam = victim:Team()
        if table.HasValue(TEAMS_TO_MONITOR, victimTeam) then
            local currentTime = CurTime()
            table.insert(deathCounter[victimTeam], currentTime)

            -- Remove deaths that are older than 5 minutes
            for i = #deathCounter[victimTeam], 1, -1 do
                if currentTime - deathCounter[victimTeam][i] > 300 then
                    table.remove(deathCounter[victimTeam], i)
                end
            end

            -- Check if there are more than 3 deaths in the last 5 minutes for this team
            if #deathCounter[victimTeam] > 3 then
                -- Play the sounds sequentially
                playSoundsSequentially()

                -- Reset the death counter for this team
                deathCounter[victimTeam] = {}
            end
        end
    end)

    -- Optional: Reset the death counter every 5 minutes to avoid memory leaks
    timer.Create("ResetDeathCounterTimer", 300, 0, resetDeathCounter)
end

hook.Add("loadCustomDarkRPItems", "InitializeTooManyDeathsAfterJobs", InitializeTooManyDeaths)