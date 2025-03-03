sniper_take_aim_shrapnel = class( {} )

LinkLuaModifier( "modifier_sniper_take_aim_shrapnel", "heroes/sniper/sniper_take_aim_shrapnel", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_shrapnel_lua_thinker", "heroes/sniper/sniper_take_aim_shrapnel", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_shrapnel_lua", "heroes/sniper/sniper_take_aim_shrapnel", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function sniper_take_aim_shrapnel:GetIntrinsicModifierName()
	return "modifier_sniper_take_aim_shrapnel"
end

modifier_sniper_take_aim_shrapnel = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_take_aim_shrapnel:IsHidden()
	return true
end

function modifier_sniper_take_aim_shrapnel:IsPurgeException()
	return false
end

function modifier_sniper_take_aim_shrapnel:IsPurgable()
	return false
end

function modifier_sniper_take_aim_shrapnel:IsPermanent()
	return true
end



function modifier_sniper_take_aim_shrapnel:OnCreated(kv)
    if IsServer() then
	
    end
end
function modifier_sniper_take_aim_shrapnel:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end
function modifier_sniper_take_aim_shrapnel:OnAttackLanded(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end

    
self.ability = params.attacker:FindAbilityByName("sniper_shrapnel")
    local point = params.target:GetAbsOrigin()
    
	if params.attacker:HasModifier("modifier_sniper_take_aim_bonus") then
		CreateModifierThinker(params.attacker, self.ability, "modifier_sniper_shrapnel_lua_thinker", {}, point, params.attacker:GetTeamNumber(), false)
	end

   
end

modifier_sniper_shrapnel_lua_thinker = class({})

--------------------------------------------------------------------------------
function modifier_sniper_shrapnel_lua_thinker:Precache( context )
	
	PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_shrapnel.vpcf", context )
end
-- Classifications
function modifier_sniper_shrapnel_lua_thinker:IsHidden()
	return true
end

function modifier_sniper_shrapnel_lua_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Aura
function modifier_sniper_shrapnel_lua_thinker:IsAura()
	return self.start
end
function modifier_sniper_shrapnel_lua_thinker:GetModifierAura()
	return "modifier_sniper_shrapnel_lua"
end
function modifier_sniper_shrapnel_lua_thinker:GetAuraRadius()
	return self.radius
end
function modifier_sniper_shrapnel_lua_thinker:GetAuraDuration()
	return 0.5
end
function modifier_sniper_shrapnel_lua_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_sniper_shrapnel_lua_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sniper_shrapnel_lua_thinker:OnCreated( kv )
	-- references
	self.delay = self:GetAbility():GetSpecialValueFor( "damage_delay" ) 
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" ) *0.5
	self.damage = self:GetAbility():GetSpecialValueFor( "shrapnel_damage" ) *0.5
	self.aura_stick = self:GetAbility():GetSpecialValueFor( "slow_duration" ) 
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" ) *0.5 

	self.start = false

	if IsServer() then
		self.direction = (self:GetParent():GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

		-- Start interval
		self:StartIntervalThink( 0.5 )

		-- effects
		self.sound_cast = "Hero_Sniper.ShrapnelShatter"
		EmitSoundOn( self.sound_cast, self:GetParent() )		
	end
end

function modifier_sniper_shrapnel_lua_thinker:OnDestroy( kv )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_sniper_shrapnel_lua_thinker:OnIntervalThink()
	if not self.start then
		self.start = true
		self:StartIntervalThink( self.duration )
		AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self.radius, self.duration, false )

		-- effects
		self:PlayEffects()
	else
		self:StopEffects()
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_sniper_shrapnel_lua_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_sniper/sniper_shrapnel.vpcf"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:SetParticleControlForward( self.effect_cast, 2, self.direction + Vector(0, 0, 0.1) )
end

function modifier_sniper_shrapnel_lua_thinker:StopEffects()
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	StopSoundOn( self.sound_cast, self:GetParent() )
end



modifier_sniper_shrapnel_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_shrapnel_lua:IsHidden()
	return true
end

function modifier_sniper_shrapnel_lua:IsDebuff()
	return true
end

function modifier_sniper_shrapnel_lua:IsPurgable()
	return false
end
function modifier_sniper_shrapnel_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_sniper_shrapnel_lua:OnCreated( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "shrapnel_damage" ) -- special value
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" ) -- special value

	local interval = 1
	self.caster = self:GetAbility():GetCaster()

	if IsServer() then
		-- precache damage
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self.caster,
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}

		-- start interval
		self:StartIntervalThink( interval )
		self:OnIntervalThink()
	end
end

function modifier_sniper_shrapnel_lua:OnRefresh( kv )
	
end

function modifier_sniper_shrapnel_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_sniper_shrapnel_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end
function modifier_sniper_shrapnel_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_sniper_shrapnel_lua:OnIntervalThink()
	-- if self.caster:IsAlive() then
		ApplyDamage(self.damageTable)
	-- end
end