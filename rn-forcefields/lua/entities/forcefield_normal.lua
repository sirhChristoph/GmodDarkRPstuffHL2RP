-- forcefield.lua
-- Model:  models/hunter/plates/plate3x4.mdl

if (SERVER) then
    AddCSLuaFile();
end;

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.PrintName = "Forcefield [normal] /ff";
ENT.Author = "sirhChristoph";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.Category = "sirhChristoph";

function ENT:Initialize()
    self:SetModel("models/hunter/plates/plate3x4.mdl")
    self:SetMaterial("effects/com_shield003a")
    self:SetColor(Color(255, 255, 255, 255))
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_NONE)
end

function ENT:ToggleForcefield(state)
    if state then
        self:SetCollisionGroup(COLLISION_GROUP_NONE)
        self:SetMaterial("effects/com_shield003a")
    else
        self:SetCollisionGroup(COLLISION_GROUP_WORLD) --COLLISION_GROUP_PASSABLE_DOOR
        self:SetMaterial("Models/effects/vol_light001")
    end
end
