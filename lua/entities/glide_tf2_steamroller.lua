AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.PrintName = "Steamroller"
ENT.Author = "desu"

ENT.GlideCategory = "tf2desu"
ENT.ChassisModel = "models/tf2enhanced/steamroller.mdl"

DEFINE_BASECLASS( "base_glide_car" )

function ENT:GetFirstPersonOffset( _, localEyePos )
    localEyePos[1] = localEyePos[1] + 5
    localEyePos[3] = localEyePos[3] + 7

    return localEyePos
end

if CLIENT then
    ENT.CameraOffset = Vector( -340, 0, 50 )

    ENT.HornSound = "glide/horns/large_truck_horn_2.wav"
    ENT.ReverseSound = "glide/alarms/reverse_warning.wav"
    ENT.ExhaustOffsets = {
        { pos = Vector( 8, 18, 100 ), angle = Angle( 90, 0, 0 ) },
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector( 60, 0, 55 ), angle = Angle(), width = 40 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 50, 0, 57 ), angle = Angle() }
    }

    ENT.Headlights = {
        { offset = Vector( 50, 32, 57 ) },
        { offset = Vector( 50, -32, 57 ) }
    }

    ENT.LightSprites = {
        { type = "headlight", offset = Vector( 50, 32, 57  ), dir = Vector( 1, 0, 0 ) },
        { type = "headlight", offset = Vector( 50, -32, 57  ), dir = Vector( 1, 0, 0 ) },
    }

    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "hauler" )
    end

    local POSE_DATA = {
        ["ValveBiped.Bip01_R_Calf"] = Angle( 0, -30, 0 ),
        ["ValveBiped.Bip01_L_Calf"] = Angle( 0, -30, 0 ),

        ["ValveBiped.Bip01_R_Clavicle"] = Angle( -10, 0, 0 ),
        ["ValveBiped.Bip01_L_Clavicle"] = Angle( 10, 0, 0 ),

        ["ValveBiped.Bip01_R_UpperArm"] = Angle( 40, 30, 35 ),
        ["ValveBiped.Bip01_L_UpperArm"] = Angle( -10, -10, -20 ),

        ["ValveBiped.Bip01_R_Forearm"] = Angle( -35, -100, 0 ),
        ["ValveBiped.Bip01_L_Forearm"] = Angle( 45, -70, 0 ),
    }

    function ENT:GetSeatBoneManipulations( seatIndex )
        if seatIndex == 1 then
            return POSE_DATA
        end
    end

    function ENT:OnActivateMisc()
        BaseClass.OnActivateMisc( self )

        self.steerWheeleId = self:LookupBone( "steer" )
        self.frontWheelBaseId = self:LookupBone( "front_wheel_base_extrabone" )
        self.exhaustCoverId = self:LookupBone( "smoke_pipe_cover" )
    end

    local steerAngle = Angle()
    local wheelAngle = Angle()
    local exhaustAngle = Angle()
    local lerp = 0
    function ENT:OnUpdateAnimations()
        BaseClass.OnUpdateAnimations( self )
        if not self.frontWheelBaseId or not self.steerWheeleId or not self.exhaustCoverId then return end

        local rpmRatio = self:GetEngineThrottle() * -10
        lerp = Lerp( 0.1, lerp, rpmRatio )
        exhaustAngle[3] = -lerp * rpmRatio
        self:ManipulateBoneAngles( self.exhaustCoverId, exhaustAngle )

        local steer = self:GetSteering() * -24
        steerAngle[1] = steer
        self:ManipulateBoneAngles( self.steerWheeleId, steerAngle )

        wheelAngle[2] = steer
        self:ManipulateBoneAngles( self.frontWheelBaseId, wheelAngle )
    end

end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.AngularDrag = Vector( -0.5, -0.5, -5 )
    ENT.ChassisMass = 6000
    ENT.IsHeavyVehicle = true

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 0, 0, -20 ) )
        self:SetSkin( math.random( 0, self:SkinCount() - 1 ) )
    end

    ENT.LightBodygroups = {
        { type = "headlight", bodyGroupId = 7, subModelId = 1 } -- Headlights
    }

    function ENT:GetGears()
        return {
            [-1] = 3, -- Reverse
            [0] = 0, -- Neutral (this number has no effect)
            [1] = 3
        }
    end

    function ENT:CreateFeatures()
        self:SetSuspensionLength( 5 )
        self:SetSpringStrength( 6000 )
        self:SetSpringDamper( 30000 )

        self:SetForwardTractionMax( 10000 )
        self:SetForwardTractionBias( 0.4 )
        self:SetSideTractionMax( 20000 )
        self:SetSideTractionMin( 10000 )
        self:SetMaxSteerAngle( 25 )
        self:SetSteerConeChangeRate( 2 )

        self:SetMinRPM( 100 )
        self:SetMaxRPM( 2000 )
        self:SetMinRPMTorque( 4000 )
        self:SetMaxRPMTorque( 8000 )
        self:SetBrakePower( 10000 )

        self:SetDifferentialRatio( 0.3 )
        self:SetPowerDistribution( -1 )
        self:SetTransmissionEfficiency( 1 )

        self:CreateSeat( Vector( -42, 0, 36 ), Angle( 0, 270, -5 ), Vector( 40, 80, 0 ), true )

        -- Front
        self:CreateWheel( Vector( 52, 0, 0 ), {
            model = "models/tf2enhanced/steamroller_wheel_front.mdl",
            modelAngle = Angle( 0, 0, 0 ),
            modelScale = Vector( 1, 0.9, 1 ),
            steerMultiplier = 1,
            useModelSize = true,
            isBulletProof = true
        } )

        -- Rear left
        self:CreateWheel( Vector( -40, 36, 0 ), {
            model = "models/tf2enhanced/steamroller_wheel_back.mdl",
            modelAngle = Angle( 0, 0, 0 ),
            modelScale = Vector( 1, 0.4, 1 ),
            useModelSize = true,
            isBulletProof = true
        } )

        -- Rear right
        self:CreateWheel( Vector( -40, -36, 0 ), {
            model = "models/tf2enhanced/steamroller_wheel_back.mdl",
            modelAngle = Angle( 0, 180, 0 ),
            modelScale = Vector( 1, 0.4, 1 ),
            useModelSize = true,
            isBulletProof = true
        } )
    end

    function ENT:GetSpawnColor()
        return self.Color
    end
end