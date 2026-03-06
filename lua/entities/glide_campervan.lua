AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.PrintName = "Campervan"
ENT.Author = "desu"

ENT.GlideCategory = "tf2desu"
ENT.ChassisModel = "models/tf2enhanced/campervan.mdl"

DEFINE_BASECLASS( "base_glide_car" )


function ENT:GetPlayerSitSequence( seatIndex )
    if seatIndex == 5 then
        return "sit_zen"
    elseif seatIndex == 1 then
        return "drive_jeep"
    end

    return "sit"
end

if CLIENT then
    ENT.CameraOffset = Vector( -400, 0, 120 )

    ENT.HornSound = "glide/horns/car_horn_med_1.wav"

    ENT.ExhaustOffsets = {
        { pos = Vector( -115, 16, -6 ), angle = Angle( 0, 0, 0 ) }
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector( 108, 0, 15 ), angle = Angle(), width = 40 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 48, 0, 25 ), angle = Angle() }
    }

    ENT.Headlights = {
        { offset = Vector( 110, 10, 30 ) },
        { offset = Vector( 110, -10, 30 ) }
    }

    ENT.LightSprites = {
        { type = "taillight", offset = Vector( -112, 36, 33.2 ), dir = Vector( -1, 0, 0 ) },
        { type = "taillight", offset = Vector( -112, -35, 33.2  ), dir = Vector( -1, 0, 0 ) },
        { type = "reverse", offset = Vector( -112, 36, 22 ), dir = Vector( -1, 0, 0 ) },
        { type = "reverse", offset = Vector( -112, -35, 22 ), dir = Vector( -1, 0, 0 ) },
        { type = "brake", offset = Vector( -112, 36, 22 ), dir = Vector( -1, 0, 0 ), signal = "left" },
        { type = "brake", offset = Vector( -112, -35, 22 ), dir = Vector( -1, 0, 0 ), signal = "right" },

        { type = "headlight", offset = Vector( 106, 11.5, 30  ), dir = Vector( 1, 0, 0 ) },
        { type = "headlight", offset = Vector( 106, -11.5, 30  ), dir = Vector( 1, 0, 0 ) },
    }

    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "speedo" )
    end

    local POSE_DATA = {
        ["ValveBiped.Bip01_R_Thigh"] = Angle( 0, 90, 0 ),
        ["ValveBiped.Bip01_L_Thigh"] = Angle( 0, 90, 0 ),

        ["ValveBiped.Bip01_R_Calf"] = Angle( 0, -70, 0 ),
        ["ValveBiped.Bip01_L_Calf"] = Angle( 0, -70, 0 ),

        ["ValveBiped.Bip01_R_Forearm"] = Angle( -40, 60, -30 ),
        ["ValveBiped.Bip01_L_Forearm"] = Angle( 40, 60, -30 ),
    }

    function ENT:GetSeatBoneManipulations( seatIndex )
        if seatIndex == 6 then
            return POSE_DATA
        end
    end

end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.AngularDrag = Vector( -1, -0.5, -10 )
    ENT.ChassisMass = 900

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 0, 0, 0 ) )
    end

    ENT.LightBodygroups = {
        { type = "headlight", bodyGroupId = 7, subModelId = 1 }, -- Headlights
        { type = "headlight", bodyGroupId = 8, subModelId = 1 },

        { type = "brake_or_taillight", bodyGroupId = 15, subModelId = 1 },
    }

    function ENT:CreateFeatures()
        self.switchBaseDelay = 0.5

        self:SetSuspensionLength( 12 )
        self:SetSpringStrength( 500 )
        self:SetSpringDamper( 1500 )

        self:SetBrakePower( 2000 )

        self:SetForwardTractionMax( 2800 )

        self:SetPowerDistribution( -0.4 )

        self:CreateSeat( Vector( 10, 20, 12 ), Angle( 0, 270, -5 ), Vector( 40, 80, 0 ), true )
        self:CreateSeat( Vector( 24, -20, 12 ), Angle( 0, 270, 5 ), Vector( -40, -80, 0 ), true )

        self:CreateSeat( Vector( -80, 40, 30 ), Angle( 0, 180, 0 ), Vector( -40, -80, 0 ), true )
        self:CreateSeat( Vector( -80, -40, 30 ), Angle( 0, 0, 0 ), Vector( -40, -80, 0 ), true )

        self:CreateSeat( Vector( -15, 16, 10 ), Angle( 0, 90, 0 ), Vector( -40, -80, 0 ), true )
        self:CreateSeat( Vector( 30, -10, 80 ), Angle( 0, 180, 90 ), Vector( -40, -80, 0 ), true )

        -- Front left
        self:CreateWheel( Vector( 87, 30, 0 ), {
            model = "models/tf2enhanced/campervan_wheel.mdl",
            modelAngle = Angle( 0, 0, 0 ),
            modelScale = Vector( 1, 0.4, 1 ),
            steerMultiplier = 1
        } )

        -- Front right
        self:CreateWheel( Vector( 87, -30, 0 ), {
            model = "models/tf2enhanced/campervan_wheel.mdl",
            modelAngle = Angle( 0, 180, 0 ),
            modelScale = Vector( 1, 0.4, 1 ),
            steerMultiplier = 1
        } )

        -- Rear left
        self:CreateWheel( Vector( -44, 30, -4 ), {
            model = "models/tf2enhanced/campervan_wheel.mdl",
            modelAngle = Angle( 0, 0, 0 ),
            modelScale = Vector( 1, 0.4, 1 )
        } )

        -- Rear right
        self:CreateWheel( Vector( -44, -30, -4 ), {
            model = "models/tf2enhanced/campervan_wheel.mdl",
            modelAngle = Angle( 0, 180, 0 ),
            modelScale = Vector( 1, 0.4, 1 )
        } )

        self:ChangeWheelRadius( 18 )
    end

    function ENT:GetSpawnColor()
        return self.Color
    end
end