-- lua/autorun/server/rn_spawn_forcefield_command.lua
util.AddNetworkString("ToggleSpawnForcefield")

local allowedRanks = { "superadmin", "admin", "Administration", "owner", "Owner", "Founder", "founder", "Developer", "developer", "dev", "Moderator", "moderator" } -- Add your allowed ULX ranks here
local allowedJobs = { "", "" } -- Add your allowed jobs here
local validClasses = {
    ["rn_forcefield_spawn"] = true
}

local function ToggleSpawnForcefield(ply)
    local rankAllowed = table.HasValue(allowedRanks, ply:GetUserGroup())
    local jobAllowed = table.HasValue(allowedJobs, team.GetName(ply:Team()))

    if not rankAllowed and not jobAllowed then return end

    -- Find all entities of the class "rn_forcefield_spawn"
    local spawnforcefields = ents.FindByClass("rn_forcefield_spawn")
    local newState

    for _, spawnforcefield in ipairs(spawnforcefields) do
        if spawnforcefield:IsValid() then
            local state = spawnforcefield:GetCollisionGroup() == COLLISION_GROUP_PASSABLE_DOOR
            spawnforcefield:ToggleSpawnForcefield(state)
            newState = state
        end
    end

    ply:ChatPrint("All Spawn Forcefields " .. (newState and "enabled" or "disabled"))
end

hook.Add("PlayerSay", "SpawnForcefieldCommand", function(ply, text)
    if string.lower(text) == "/sff" then
        ToggleSpawnForcefield(ply)
        return ""
    end
end)
