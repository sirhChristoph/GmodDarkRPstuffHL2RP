--AddCSLuaFile()

--if ( SERVER ) then return end


-- ORIGINAL BELOW: anybody can open the door unless it is locked by the team that owns it using the DarkRP keys

--hook.Add("PlayerUse", "OpenFuncDoor", function(ply, ent)
--    if ent:GetClass() == "func_door" then
--        ent:Fire("Open")
--        return false -- Prevent default behavior
--    end
--end)



-- NEW VERSION BELOW: the door can only be opened (with the use key) if the player is the job(team) / doorgroup / owner of the door.



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
                for _, team in ipairs(allowedTeams) do
                    if ply:Team() == team then
                        hasAccess = true
                        break
                    end
                end
            end

            if hasAccess or ply == owner then
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

-- Note that the function to allow a single Job/Team to open a door does not work
-- Even if the player is the same Job/Team that owns the door, the following will be printed to chat
-- "You do not have access to open this door."