AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.PrintName = "Steamroller"
ENT.Author = "desu"

ENT.GlideCategory = "tf2desu"
ENT.ChassisModel = "models/tf2enhanced/steamroller.mdl"

if CLIENT then
    ENT.CameraOffset = Vector( -340, 0, 50 )

    ENT.HornSound = "glide/horns/car_horn_med_1.wav"

    ENT.ExhaustOffsets = {
        { pos = Vector( -108, 25.5, -2 ), angle = Angle( -20, -14, 0 ) },
        { pos = Vector( -108, -24, -4 ), angle = Angle( -10, 12, 0 ) }
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector( 108, 0, 15 ), angle = Angle(), width = 40 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 48, 0, 25 ), angle = Angle() }
    }

    ENT.Headlights = {
        { offset = Vector( 102, 33.5, 15 ) },
        { offset = Vector( 102, -33.5, 15 ) }
    }

    ENT.LightSprites = {
        { type = "headlight", offset = Vector( 102, 33.5, 15  ), dir = Vector( 1, 0, 0 ) },
        { type = "headlight", offset = Vector( 102, -33.5, 15  ), dir = Vector( 1, 0, 0 ) },
    }

    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "speedo" )
    end
end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.AngularDrag = Vector( -0.5, -0.5, -5 )
    ENT.ChassisMass = 1100

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 0, 0, -20 ) )
    end

    ENT.LightBodygroups = {
        { type = "headlight", bodyGroupId = 8, subModelId = 1 } -- Headlights
    }

    function ENT:GetGears()
        return {
            [-1] = 2, -- Reverse
            [0] = 0, -- Neutral (this number has no effect)
            [1] = 2
        }
    end

    function ENT:CreateFeatures()
        self:SetSuspensionLength( 1 )
        self:SetSpringStrength( 5000 )
        self:SetSpringDamper( 5000 )

        self:SetForwardTractionMax( 400 )
        self:SetForwardTractionBias( -0.4 )
        self:SetSideTractionMin( 1000 )
        self:SetMaxSteerAngle( 25 )
        self:SetSteerConeChangeRate( 2 )

        self:SetMaxRPM( 2000 )
        self:SetMinRPMTorque( 2200 )
        self:SetMaxRPMTorque( 3000 )
        self:SetBrakePower( 2500 )

        self:SetDifferentialRatio( 0.1 )
        self:SetPowerDistribution( -1 )
        self:SetTransmissionEfficiency( 1 )

        self:CreateSeat( Vector( -42, 0, 36 ), Angle( 0, 270, -5 ), Vector( 40, 80, 0 ), true )

        -- Front
        self:CreateWheel( Vector( 52, 0, 0 ), {
            model = "models/tf2enhanced/steamroller_wheel_front.mdl",
            modelAngle = Angle( 0, 0, 0 ),
            modelScale = Vector( 1, 0.9, 1 ),
            steerMultiplier = 1,
            radius = 32
        } )

        -- Rear left
        self:CreateWheel( Vector( -40, 36, 4 ), {
            model = "models/tf2enhanced/steamroller_wheel_back.mdl",
            modelAngle = Angle( 0, 0, 0 ),
            modelScale = Vector( 1, 0.4, 1 ),
            radius = 36
        } )

        -- Rear right
        self:CreateWheel( Vector( -40, -36, 4 ), {
            model = "models/tf2enhanced/steamroller_wheel_back.mdl",
            modelAngle = Angle( 0, 180, 0 ),
            modelScale = Vector( 1, 0.4, 1 ),
            radius = 36
        } )
    end

    function ENT:GetSpawnColor()
        return self.Color
    end
end