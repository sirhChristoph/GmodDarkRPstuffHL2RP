if (SERVER) then
    AddCSLuaFile()
end

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Instant Suit Charger"
ENT.Author = "sirhChristoph"
ENT.Spawnable = true
ENT.Category = "sirhChristoph"

local cooldown = {}

function ENT:Initialize()
    self:SetModel("models/props_combine/suit_charger001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
end

function ENT:Use(activator)
    if not activator:IsPlayer() then return end
    
    local teamAllowed = {TEAM_CPR, TEAM_CPO, TEAM_CPTL, TEAM_OTAEO, TEAM_OTAES, TEAM_OTAMS, TEAM_OTAEE, TEAM_OTAME, TEAM_OTAOV, TEAM_OTAOR} -- Replace with your specific teams
    if not table.HasValue(teamAllowed, activator:Team()) then return end

    local plyID = activator:SteamID()
    if cooldown[plyID] and cooldown[plyID] > CurTime() then
        return
    end

    if activator:Armor() >= activator:GetMaxArmor() then
        activator:EmitSound("items/suitchargeno1.wav", 75, 100, 0.3, CHAN_AUTO) -- Sound for full armor
        cooldown[plyID] = CurTime() + 1 -- 1-second cooldown
        return
    end

    activator:SetArmor(activator:GetMaxArmor())
    activator:EmitSound("items/suitchargeok1.wav", 75, 100, 0.3, CHAN_AUTO) -- Sound for successful use with volume control
    cooldown[plyID] = CurTime() + 1 -- 1-second cooldown
end