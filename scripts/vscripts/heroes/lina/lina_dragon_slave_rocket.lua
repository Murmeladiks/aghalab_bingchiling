lina_dragon_slave_rocket = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_lina_dragon_slave_rocket", "heroes/lina/lina_dragon_slave_rocket", LUA_MODIFIER_MOTION_NONE )
function lina_dragon_slave_rocket:GetIntrinsicModifierName()
	return "modifier_lina_dragon_slave_rocket"
end
function lina_dragon_slave_rocket:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()


    self.lina_dragon_slave = self:GetCaster():FindAbilityByName("lina_dragon_slave")
	-- load data
	local projectile_name = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf"
	local projectile_distance = self.lina_dragon_slave:GetSpecialValueFor( "dragon_slave_distance" )
	local projectile_speed = self.lina_dragon_slave:GetSpecialValueFor( "dragon_slave_speed" )
	local projectile_start_radius = self.lina_dragon_slave:GetSpecialValueFor( "dragon_slave_width_initial" )
	local projectile_end_radius = self.lina_dragon_slave:GetSpecialValueFor( "dragon_slave_width_end" )

	-- get direction
	local direction = -self:GetCaster():GetForwardVector()
	direction.z = 0
	local projectile_direction = direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,

		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- Play effects
	local sound_cast = "Hero_Lina.DragonSlave.Cast"
	local sound_projectile = "Hero_Lina.DragonSlave"
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_projectile, self:GetCaster() )
end
function lina_dragon_slave_rocket:OnProjectileHitHandle( target, location, projectile )
	if not target then return end
    local damage = self.lina_dragon_slave:GetSpecialValueFor("dragon_slave_damage")*2
    
	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage ,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

	-- get direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
	direction.z = 0
	direction = direction:Normalized()

	-- play effects
	self:PlayEffects( target, direction )
end

--------------------------------------------------------------------------------
function lina_dragon_slave_rocket:PlayEffects( target, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

modifier_lina_dragon_slave_rocket = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lina_dragon_slave_rocket:IsHidden()
	return true
end

function modifier_lina_dragon_slave_rocket:IsPurgeException()
	return false
end

function modifier_lina_dragon_slave_rocket:IsPurgable()
	return false
end

function modifier_lina_dragon_slave_rocket:IsPermanent()
	return true
end




function modifier_lina_dragon_slave_rocket:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_lina_dragon_slave_rocket:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_lina_dragon_slave_rocket:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "lina_dragon_slave" then
        return
    end

    local unit = self:GetParent()

    self:GetAbility():OnSpellStart()

    unit:AddNewModifier(unit, self:GetAbility(), "modifier_force_boots_active", {})
    -- self.lina_light_strike_array = unit:FindAbilityByName("lina_light_strike_array")
    -- local radius =self.lina_light_strike_array:GetSpecialValueFor("radius")
    -- if not self.lina_light_strike_array or self.lina_light_strike_array:GetLevel() == 0 then
    --     return
    -- end
    
    -- local cursorPos = params.ability:GetCursorPosition()
    -- local pos = params.unit:GetAbsOrigin()
    -- local direction = self:GetParent():GetForwardVector()
    -- local distance = params.ability:GetSpecialValueFor("dragon_slave_distance")
    
    -- local newpos = pos + distance*direction
    -- local newpos1 = LerpVectors(pos,newpos,0.25)
    -- local newpos2 = LerpVectors(pos,newpos,0.5)
    -- local newpos3 = LerpVectors(pos,newpos,0.75)
    --     Timers:CreateTimer(0.25, function()
    --         if(self and not self:IsNull()) then
    --             self:GetCaster():SetCursorPosition(newpos1)
    --             self.lina_light_strike_array:OnSpellStart()
    --         end
    --     end)
    --     Timers:CreateTimer(0.5, function()
    --         if(self and not self:IsNull()) then
    --             self:GetCaster():SetCursorPosition(newpos2)
    --             self.lina_light_strike_array:OnSpellStart()
    --         end
    --     end)
    --     Timers:CreateTimer(0.75, function()
    --         if(self and not self:IsNull()) then
    --             self:GetCaster():SetCursorPosition(newpos3)
    --             self.lina_light_strike_array:OnSpellStart()
    --         end
    --     end)
    --     Timers:CreateTimer(1, function()
    --         if(self and not self:IsNull()) then
    --             self:GetCaster():SetCursorPosition(newpos)
    --             self.lina_light_strike_array:OnSpellStart()
    --         end
    --     end)
  
    
    
end