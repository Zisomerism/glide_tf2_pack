AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "glide_nuva"
ENT.PrintName = "Nuva Highway Patrol"
ENT.Author = "desu"

ENT.GlideCategory = "tf2desu"
ENT.ChassisModel = "models/tf2enhanced/nuva.mdl"
ENT.CanSwitchSiren = true

if CLIENT then

    ENT.SirenLoopSound = ")glide/alarms/police_siren_1.wav"
    ENT.SirenLoopAltSound = ")glide/horns/police_horn_1.wav"

    ENT.SirenLights = {
        -- Top-right (blue) lights
        { offset = Vector( -12, -26, 64 ), dir = Vector( 0.6, 0, 0 ), time = 0.5, duration = 0.3, color = Glide.DEFAULT_SIREN_COLOR_B },
        { offset = Vector( -22, -26, 64 ), dir = Vector( -0.6, 0, 0 ), time = 0, duration = 0.3, color = Glide.DEFAULT_SIREN_COLOR_B },
        { offset = Vector( -12, -19, 65 ), dir = Vector( 0.7, -0.3, 0 ), time = 0, duration = 0.4, color = Glide.DEFAULT_SIREN_COLOR_B },

        -- Top-left (red) lights
        { offset = Vector( -12, 26, 64 ), dir = Vector( 0.6, 0, 0 ), time = 0.5, duration = 0.3, color = Glide.DEFAULT_SIREN_COLOR_A },
        { offset = Vector( -22, 26, 64 ), dir = Vector( -0.6, 0, 0 ), time = 0, duration = 0.3, color = Glide.DEFAULT_SIREN_COLOR_A },
        { offset = Vector( -12, 19, 65 ), dir = Vector( 0.7, 0.3, 0 ), time = 0.4, duration = 0.4, color = Glide.DEFAULT_SIREN_COLOR_A },
    }
end

if SERVER then
    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 0, 0, 0 ) )
        self:SetSkin( 3 )
        self:SetBodygroup( 12, 1 )
        self:SetBodygroup( 13, 1 )
        self:SetBodygroup( 14, 1 )
    end
end