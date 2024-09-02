-- Table to keep track of the last time a player pressed the use key
local lastUsePress = {}

hook.Add("PlayerUse", "OpenFuncDoorWithUseKey", function(ply, ent)
    if ent:GetClass() == "func_door" then
        -- Check if the player is pressing the use key
        if ply:KeyDown(IN_USE) then
            local doorgroup = ent:getKeysDoorGroup()
            local owner = ent:getDoorOwner()
            local allowedTeams = ent:getKeysDoorTeams()

            -- Check if the player is in the correct group or owns the door
            local hasAccess = false
            if doorgroup then
                hasAccess = table.HasValue(RPExtraTeamDoors[doorgroup] or {}, ply:Team())
            end

            -- Check if the player is in the allowed teams
            if allowedTeams and not hasAccess then
                for team, allowed in pairs(allowedTeams) do
                    if allowed and ply:Team() == team then
                        hasAccess = true
                        break
                    end
                end
            end

            if hasAccess or (owner and ply == owner) then
                ent:Fire("Open")
            else
                -- Get the current time
                local currentTime = CurTime()

                -- Check if the player has pressed the use key recently
                if not lastUsePress[ply] or currentTime - lastUsePress[ply] > 1 then
                    ply:ChatPrint("You do not have access to open this door.")
                    lastUsePress[ply] = currentTime
                end
            end
            return false -- Prevent default behavior
        end
    end
end)
