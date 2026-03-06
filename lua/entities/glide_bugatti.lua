AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.PrintName = "Bugatti"
ENT.Author = "desu"

ENT.GlideCategory = "tf2desu"
ENT.ChassisModel = "models/tf2enhanced/bugatti.mdl"

if CLIENT then
    ENT.CameraOffset = Vector( -220, 0, 60 )

    ENT.HornSound = "glide/horns/car_horn_med_3.wav"

    ENT.ExhaustOffsets = {
        { pos = Vector( -76, -5.5, 2 ), angle = Angle( 0, 0, 0 ) }
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector( 60, 0, 15 ), angle = Angle(), width = 10 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 48, 0, 18 ), angle = Angle() }
    }

    ENT.Headlights = {
        { offset = Vector( 70, 14.5, 15 ) },
        { offset = Vector( 70, -14.5, 15 ) }
    }

    ENT.LightSprites = {
        { type = "headlight", offset = Vector( 70, 14.5, 15  ), dir = Vector( 1, 0, 0 ) },
        { type = "headlight", offset = Vector( 70, -14.5, 15  ), dir = Vector( 1, 0, 0 ) },
    }

    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "jb700" )
    end

    local POSE_DATA = {
        --["ValveBiped.Bip01_R_Thigh"] = Angle( 0, 90, 0 ),
        --["ValveBiped.Bip01_L_Thigh"] = Angle( 0, 90, 0 ),

        ["ValveBiped.Bip01_R_Calf"] = Angle( 0, -30, 0 ),
        ["ValveBiped.Bip01_L_Calf"] = Angle( 0, -30, 0 ),

        ["ValveBiped.Bip01_R_Clavicle"] = Angle( -10, 0, 0 ),
        ["ValveBiped.Bip01_L_Clavicle"] = Angle( 10, 0, 0 ),

        ["ValveBiped.Bip01_R_UpperArm"] = Angle( 20, 30, 30 ),
        ["ValveBiped.Bip01_L_UpperArm"] = Angle( -20, 10, -10 ),

        ["ValveBiped.Bip01_R_Forearm"] = Angle( -35, -80, 0 ),
        ["ValveBiped.Bip01_L_Forearm"] = Angle( 45, -70, 0 ),
    }

    function ENT:GetSeatBoneManipulations( seatIndex )
        if seatIndex == 1 then
            return POSE_DATA
        end
    end
end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.AngularDrag = Vector( -0.5, -0.5, -1 )

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 0, 0, 2 ) )
        self:SetSkin( math.random( 0, self:SkinCount() - 1 ) )
    end

    ENT.LightBodygroups = {
        { type = "headlight", bodyGroupId = 2, subModelId = 1 } -- Headlights
    }

    function ENT:CreateFeatures()
        self:SetSuspensionLength( 12 )
        self:SetSpringDamper( 1900 )

        self:SetCounterSteer( 0.8 )
        self:SetForwardTractionMax( 2200 )

        self:SetMinRPM( 200 )
        self:SetMaxRPM( 4500 )

        self:SetMinRPMTorque( 3800 )
        self:SetMaxRPMTorque( 4100 )

        self:SetPowerDistribution( -1 )
        self:SetTransmissionEfficiency( 1 )

        self:CreateSeat( Vector( -34, -5, -6 ), Angle( 0, 270, -5 ), Vector( 40, 80, 0 ), true )
        self:CreateSeat( Vector( -8, -20, 0 ), Angle( 0, 270, 5 ), Vector( -40, -80, 0 ), true )

        -- Front left
        self:CreateWheel( Vector( 65, 28.5, 10 ), {
            model = "models/tf2enhanced/bugatti_wheel.mdl",
            modelAngle = Angle( 0, 0, 0 ),
            modelScale = Vector( 1, 0.4, 1 ),
            steerMultiplier = 1
        } )

        -- Front right
        self:CreateWheel( Vector( 65, -28, 10 ), {
            model = "models/tf2enhanced/bugatti_wheel.mdl",
            modelAngle = Angle( 0, 180, 0 ),
            modelScale = Vector( 1, 0.4, 1 ),
            steerMultiplier = 1
        } )

        -- Rear left
        self:CreateWheel( Vector( -45, 30, 10 ), {
            model = "models/tf2enhanced/bugatti_wheel.mdl",
            modelAngle = Angle( 0, 0, 0 ),
            modelScale = Vector( 1, 0.4, 1 )
        } )

        -- Rear right
        self:CreateWheel( Vector( -45, -28.5, 10 ), {
            model = "models/tf2enhanced/bugatti_wheel.mdl",
            modelAngle = Angle( 0, 180, 0 ),
            modelScale = Vector( 1, 0.4, 1 )
        } )

        self:ChangeWheelRadius( 14 )
    end

    function ENT:GetSpawnColor()
        return self.Color
    end
end