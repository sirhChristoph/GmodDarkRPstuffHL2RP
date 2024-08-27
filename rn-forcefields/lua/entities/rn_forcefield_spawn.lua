-- forcefield.lua
-- Model:  models/hunter/plates/plate3x4.mdl

if (SERVER) then
    AddCSLuaFile();
end;

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.PrintName = "Spawn Forcefield [normal] /sff";
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


function ENT:ToggleSpawnForcefield(state)
    if state then
        self:SetCollisionGroup(COLLISION_GROUP_NONE)
        self:SetMaterial("effects/com_shield003a")
    else
        self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
        self:SetMaterial("effects/com_shield004a")
    end
end




-- Adds the text to the spawn forcefield

if CLIENT then
    surface.CreateFont("LargeFont", {
        font = "Arial", -- Font name
        size = 45, -- Font size
        weight = 400, -- Font weight
        antialias = true,
    })

    surface.CreateFont("SmallFont", {
        font = "Arial", -- Font name
        size = 25, -- Font size
        weight = 400, -- Font weight
        antialias = true,
    })

    function ENT:Draw()
        self:DrawModel()

        local ang = self:GetAngles()
        local pos = self:GetPos() + ang:Up() * 0 -- Adjust position as needed

        local ply = LocalPlayer()
        local plyPos = ply:GetPos()
        local distance = ply:GetPos():Distance(self:GetPos())
        local maxDistance = 300
        local alpha = math.Clamp(255 * (1 - distance / maxDistance), 0, 200)

        local dir = (plyPos - pos):GetNormalized()

        -- Lock the vertical component
        dir.z = 0
        dir:Normalize()

        ang = dir:Angle()
        ang:RotateAroundAxis(ang:Up(), 90)
        ang:RotateAroundAxis(ang:Forward(), 90)

        cam.Start3D2D(pos, ang, 0.1)
            draw.SimpleText("Spawn Forcefield", "LargeFont", 0, -50, Color(214, 207, 0, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("This will be solid when leaving spawn is not permitted", "SmallFont", 0, 0, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end

    function ENT:Think()
        local ply = LocalPlayer()
        if ply:GetPos():Distance(self:GetPos()) < 500 then
            self:SetNoDraw(false)
        else
            self:SetNoDraw(true)
        end
    end
end
