-- lua/autorun/server/rn_forcefield_command.lua
util.AddNetworkString("ToggleForcefield")

local allowedRanks = { "superadmin", "admin", "Administration", "owner", "Owner", "Founder", "founder", "Developer", "developer", "dev", "Moderator", "moderator" } -- Add your allowed ULX ranks here
local allowedJobs = { "Civil Protection Officer", "Civil Protection Team Leader", "OTA Echo One", "OTA Echo Soldier", "OTA Mace Soldier", "OTA Echo Enhanced", "OTA Mace Enhanced", "OTA Overseer", "OTA Ordinal" } -- Add your allowed jobs here
local maxDistance = 300 -- Maximum distance to allow the command
local validClasses = {
    ["rn_forcefield_normal"] = true,
    ["rn_forcefield_small"] = true,
    ["rn_forcefield_large"] = true,
    ["rn_forcefield_large_wide"] = true
}

local cooldowns = {} -- Table to store cooldowns

local function ToggleForcefield(ply)
    local rankAllowed = table.HasValue(allowedRanks, ply:GetUserGroup())
    local jobAllowed = table.HasValue(allowedJobs, team.GetName(ply:Team()))

    if not rankAllowed and not jobAllowed then return end

    local tr = ply:GetEyeTrace()
    if not tr.Entity or not tr.Entity:IsValid() or not validClasses[tr.Entity:GetClass()] then return end

    local forcefield = tr.Entity
    local distance = ply:GetPos():Distance(forcefield:GetPos())

    if distance > maxDistance then
        return
    end

    local state = forcefield:GetCollisionGroup() == COLLISION_GROUP_WORLD --COLLISION_GROUP_PASSABLE_DOOR
    forcefield:ToggleForcefield(state)

    ply:ChatPrint("Forcefield " .. (state and "enabled" or "disabled"))
end

hook.Add("PlayerSay", "ForcefieldCommand", function(ply, text)
    if string.lower(text) == "/ff" then
        local currentTime = CurTime()
        if cooldowns[ply] and cooldowns[ply] > currentTime then
            ply:ChatPrint("This command has a 3 second cooldown.")
            return ""
        end

        cooldowns[ply] = currentTime + 3
        ToggleForcefield(ply)
        return ""
    end
end)