AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.PrintName = "Nuva"
ENT.Author = "desu"

ENT.GlideCategory = "tf2desu"
ENT.ChassisModel = "models/tf2enhanced/nuva.mdl"

DEFINE_BASECLASS( "base_glide_car" )

if CLIENT then
    ENT.CameraOffset = Vector( -340, 0, 50 )

    ENT.HornSound = "glide/horns/car_horn_med_7.wav"

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
        { type = "taillight", offset = Vector( -120, 34, 16.5 ), dir = Vector( -1, 0, 0 ) },
        { type = "taillight", offset = Vector( -120, -34, 16.5  ), dir = Vector( -1, 0, 0 ) },
        { type = "reverse", offset = Vector( -120, 28, 16.5  ), dir = Vector( -1, 0, 0 ) },
        { type = "reverse", offset = Vector( -120, -28, 16.5  ), dir = Vector( -1, 0, 0 ) },
        { type = "brake", offset = Vector( -120, 28, 16.5  ), dir = Vector( -1, 0, 0 ), signal = "left" },
        { type = "brake", offset = Vector( -120, -28, 16.5  ), dir = Vector( -1, 0, 0 ), signal = "right" },

        { type = "headlight", offset = Vector( 102, 33.5, 15  ), dir = Vector( 1, 0, 0 ) },
        { type = "headlight", offset = Vector( 102, -33.5, 15  ), dir = Vector( 1, 0, 0 ) },
    }

    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "dukes" )
    end

    function ENT:OnActivateMisc()
        BaseClass.OnActivateMisc( self )

        self.steerWheeleId = self:LookupBone( "steering_wheel" )
    end

    local steerAngle = Angle()

    function ENT:OnUpdateAnimations()
        BaseClass.OnUpdateAnimations( self )

        if not self.steerWheeleId then return end
        local steer = self:GetSteering() * 160
        steerAngle[2] = steer
        self:ManipulateBoneAngles( self.steerWheeleId, steerAngle )
    end
end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.AngularDrag = Vector( -0.5, -0.5, -5 )

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 0, 0, 0 ) )
        self:SetSkin( math.random( 0, self:SkinCount() - 2 ) )
    end

    ENT.LightBodygroups = {
        { type = "headlight", bodyGroupId = 8, subModelId = 1 } -- Headlights
    }

    function ENT:GetGears()
        return {
            [-1] = 2.5, -- Reverse
            [0] = 0, -- Neutral (this number has no effect)
            [1] = 2.8,
            [2] = 1.7,
            [3] = 1.2,
            [4] = 0.9,
        }
    end

    function ENT:CreateFeatures()
        self:SetSuspensionLength( 12 )
        self:SetSpringStrength( 350 )
        self:SetSpringDamper( 1800 )

        self:SetBrakePower( 2400 )

        self:CreateSeat( Vector( -26, 22, 0 ), Angle( 0, 270, -5 ), Vector( 40, 80, 0 ), true )
        self:CreateSeat( Vector( -8, -20, 0 ), Angle( 0, 270, 5 ), Vector( -40, -80, 0 ), true )

        self:CreateSeat( Vector( -60, 18, 2 ), Angle( 0, 270, 5 ), Vector( -40, -80, 0 ), true )
        self:CreateSeat( Vector( -60, -18, 0 ), Angle( 0, 270, 5 ), Vector( -40, -80, 0 ), true )

        -- Front left
        self:CreateWheel( Vector( 66.5, 40, 6 ), {
            model = "models/tf2enhanced/nuva_wheel.mdl",
            modelAngle = Angle( 0, 0, 0 ),
            modelScale = Vector( 1, 0.4, 1 ),
            steerMultiplier = 1
        } )

        -- Front right
        self:CreateWheel( Vector( 66.5, -40, 6 ), {
            model = "models/tf2enhanced/nuva_wheel.mdl",
            modelAngle = Angle( 0, 180, 0 ),
            modelScale = Vector( 1, 0.4, 1 ),
            steerMultiplier = 1
        } )

        -- Rear left
        self:CreateWheel( Vector( -70, 40, 6 ), {
            model = "models/tf2enhanced/nuva_wheel.mdl",
            modelAngle = Angle( 0, 0, 0 ),
            modelScale = Vector( 1, 0.4, 1 )
        } )

        -- Rear right
        self:CreateWheel( Vector( -70, -40, 6 ), {
            model = "models/tf2enhanced/nuva_wheel.mdl",
            modelAngle = Angle( 0, 180, 0 ),
            modelScale = Vector( 1, 0.4, 1 )
        } )

        self:ChangeWheelRadius( 18 )
    end

    function ENT:GetSpawnColor()
        return self.Color
    end
end