AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.PrintName = "Cab-over"
ENT.Author = "desu"

ENT.GlideCategory = "tf2desu"
ENT.ChassisModel = "models/tf2enhanced/cabover.mdl"

DEFINE_BASECLASS( "base_glide_car" )

function ENT:GetFirstPersonOffset( _, localEyePos )
    localEyePos[3] = localEyePos[3] + 10

    return localEyePos
end

if CLIENT then
    ENT.CameraOffset = Vector( -500, 0, 120 )

    ENT.StartSound = "Glide.Engine.TruckStart"
    ENT.ExhaustPopSound = ""
    ENT.StartedSound = "glide/engines/start_tail_truck.wav"
    ENT.StoppedSound = "glide/engines/shut_down_truck_1.wav"
    ENT.HornSound = "glide/horns/large_truck_horn_1.wav"

    ENT.ReverseSound = "glide/alarms/reverse_warning.wav"
    ENT.BrakeLoopSound = "glide/wheels/rig_brake_disc_1.wav"
    ENT.BrakeReleaseSound = "glide/wheels/rig_brake_release.wav"
    ENT.BrakeSqueakSound = "Glide.Brakes.Squeak"

    ENT.ExhaustOffsets = {
        { pos = Vector( 17, 52, 0 ), angle = Angle( 0, -45, 0 ) }
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector( 140, 0, 15 ), angle = Angle(), width = 40 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 140, 0, 10 ), angle = Angle() }
    }

    ENT.Headlights = {
        { offset = Vector( 150, 34.5, 15 ) },
        { offset = Vector( 150, -34.5, 15 ) }
    }

    ENT.LightSprites = {
        { type = "headlight", offset = Vector( 150, 34.5, 15  ), dir = Vector( 1, 0, 0 ) },
        { type = "headlight", offset = Vector( 150, -34.5, 15  ), dir = Vector( 1, 0, 0 ) },
    }

    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "airbus" )
    end

    local POSE_DATA = {
        ["ValveBiped.Bip01_R_Calf"] = Angle( 0, -30, 0 ),
        ["ValveBiped.Bip01_L_Calf"] = Angle( 0, -30, 0 ),

        ["ValveBiped.Bip01_R_Clavicle"] = Angle( -10, 0, 0 ),
        ["ValveBiped.Bip01_L_Clavicle"] = Angle( 20, 0, 0 ),

        ["ValveBiped.Bip01_R_UpperArm"] = Angle( 40, 30, 35 ),
        ["ValveBiped.Bip01_L_UpperArm"] = Angle( -40, 0, -20 ),

        ["ValveBiped.Bip01_R_Forearm"] = Angle( -35, -100, 0 ),
        ["ValveBiped.Bip01_L_Forearm"] = Angle( 45, -90, 0 ),
    }

    function ENT:GetSeatBoneManipulations( seatIndex )
        if seatIndex == 1 then
            return POSE_DATA
        end
    end

    function ENT:OnActivateMisc()
        BaseClass.OnActivateMisc( self )

        self.steerWheeleId = self:LookupBone( "steer" )
    end

    local steerAngle = Angle()

    function ENT:OnUpdateAnimations()
        BaseClass.OnUpdateAnimations( self )

        if not self.steerWheeleId then return end
        local steer = self:GetSteering() * 160
        steerAngle[1] = steer
        self:ManipulateBoneAngles( self.steerWheeleId, steerAngle )
    end

end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.AngularDrag = Vector( -1, -0.5, -10 )
    ENT.ChassisMass = 4000
    ENT.IsHeavyVehicle = true

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 0, 0, 0 ) )
        self:SetSkin( math.random( 0, self:SkinCount() - 1 ) )
    end

    ENT.LightBodygroups = {
        { type = "headlight", bodyGroupId = 5, subModelId = 1 } -- Headlights
    }

    function ENT:GetGears()
        return {
            [-1] = 10, -- Reverse
            [0] = 0, -- Neutral (this number has no effect)
            [1] = 12,
            [2] = 7.5,
            [3] = 5.2,
            [4] = 4,
            [5] = 3.3,
            [6] = 2.9,
            [7] = 2.7
        }
    end

    function ENT:CreateFeatures()
        self.switchBaseDelay = 0.5

        self:SetSuspensionLength( 14 )
        self:SetSpringStrength( 1500 )
        self:SetSpringDamper( 6000 )

        self:SetSideTractionMultiplier( 90 )
        self:SetForwardTractionMax( 6000 )
        self:SetForwardTractionBias( 0.25 )
        self:SetSideTractionMax( 4000 )
        self:SetSideTractionMin( 5500 )

        self:SetDifferentialRatio( 0.3 )
        self:SetPowerDistribution( -0.25 )

        self:SetMinRPM( 500 )
        self:SetMaxRPM( 4000 )
        self:SetMinRPMTorque( 6000 )
        self:SetMaxRPMTorque( 7000 )

        self:SetBrakePower( 6000 )
        self:SetMaxSteerAngle( 45 )
        self:SetSteerConeMaxSpeed( 600 )
        self:SetSteerConeMaxAngle( 0.4 )
        self:SetCounterSteer( 0.2 )

        self:CreateSeat( Vector( 80, 27, 24 ), Angle( 0, 270, -5 ), Vector( 40, 80, 0 ), true )
        self:CreateSeat( Vector( 98, -27, 24 ), Angle( 0, 270, 5 ), Vector( -40, -80, 0 ), true )
        self:CreateSeat( Vector( 96, 0, 24 ), Angle( 0, 270, 5 ), Vector( -40, -80, 0 ), true )

        -- Front left
        self:CreateWheel( Vector( 108, 45, -4 ), {
            model = "models/tf2enhanced/cabover_wheel.mdl",
            modelAngle = Angle( 0, 0, 0 ),
            useModelSize = true,
            steerMultiplier = 1
        } )

        -- Front right
        self:CreateWheel( Vector( 108, -45, -4 ), {
            model = "models/tf2enhanced/cabover_wheel.mdl",
            modelAngle = Angle( 0, 180, 0 ),
            useModelSize = true,
            steerMultiplier = 1
        } )

        -- Rear left
        self:CreateWheel( Vector( -104, 45, -4 ), {
            model = "models/tf2enhanced/cabover_wheel_dual.mdl",
            modelAngle = Angle( 0, 0, 0 ),
            useModelSize = true
        } )

        -- Rear right
        self:CreateWheel( Vector( -104, -45, -4 ), {
            model = "models/tf2enhanced/cabover_wheel_dual.mdl",
            modelAngle = Angle( 0, 180, 0 ),
            useModelSize = true
        } )

        self:ChangeWheelRadius( 28 )
    end

    function ENT:GetSpawnColor()
        return self.Color
    end
end