aghsfort_juggernaut_omni_slash = class({})
LinkLuaModifier( "modifier_aghsfort_juggernaut_omni_slash", "heroes/juggernaut/aghsfort_juggernaut_omni_slash", LUA_MODIFIER_MOTION_NONE )

function aghsfort_juggernaut_omni_slash:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local bDuration = self:GetSpecialValueFor("duration")	

	-- Add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_aghsfort_juggernaut_omni_slash", -- modifier name
		{ duration = bDuration } -- kv
	)	

	
end


modifier_aghsfort_juggernaut_omni_slash = class({})

function modifier_aghsfort_juggernaut_omni_slash:IsHidden() 				return false end
function modifier_aghsfort_juggernaut_omni_slash:IsDebuff() 				return false end
function modifier_aghsfort_juggernaut_omni_slash:IsPurgable() 			return false end
function modifier_aghsfort_juggernaut_omni_slash:GetStatusEffectName() 	return "particles/status_fx/status_effect_omnislash.vpcf" end

function modifier_aghsfort_juggernaut_omni_slash:OnCreated( kv )
	self.slash_rate_divisor = self:GetAbility():GetSpecialValueFor("slash_rate_divisor")
	self.attack_speed_bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	self.damage_bonus = self:GetAbility():GetSpecialValueFor("damage_bonus")

	self.tick = 1 / (self:GetCaster():GetAttackSpeed(false) * self.slash_rate_divisor)
	self.radius = self:GetAbility():GetSpecialValueFor("bounce_radius")
	
	self.max_count = kv.duration/self.tick
	self.count = 0

	if IsServer() then
		-- First cast should jump onto target regardless of cast/bounce range
		local cast_target = self:GetCaster():GetCursorCastTarget()
		local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(effect, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(effect, 1, cast_target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(effect)
		self:GetCaster():SetAbsOrigin(cast_target:GetAbsOrigin())
		
		self:StartIntervalThink( self.tick )
		self:OnIntervalThink()
	end
end

function modifier_aghsfort_juggernaut_omni_slash:OnRefresh( kv )
	self.slash_rate_divisor = self:GetAbility():GetSpecialValueFor("slash_rate_divisor")
	self.attack_speed_bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	self.damage_bonus = self:GetAbility():GetSpecialValueFor( "damage_bonus")

	self.tick = 100 / (self:GetCaster():GetAttackSpeed(false) * self.slash_rate_divisor)
	self.radius = self:GetAbility():GetSpecialValueFor("bounce_radius")
	
	self.count = 0
end

function modifier_aghsfort_juggernaut_omni_slash:OnDestroy( kv )
	-- Stop effects
	local sound_cast = "Hero_Juggernaut.OmniSlash"
	StopSoundOn( sound_cast, self:GetParent() )
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_phased", {duration = 2})
	end
end

function modifier_aghsfort_juggernaut_omni_slash:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING] = false,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end

function modifier_aghsfort_juggernaut_omni_slash:OnIntervalThink()
	-- Find enemies in radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		self.count == 0 and FIND_CLOSEST or FIND_ANY_ORDER,	-- int, order filter
		false	-- bool, can grow cache
	)
	
	-- damage enemies
	for _,enemy in pairs(enemies) do  
		local caster = self:GetCaster()
		local direction = (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
		local prev_pos = caster:GetAbsOrigin()
		
		caster:PerformAttack(enemy, true, true, true, true, false, false, false)
		caster:SetAbsOrigin(enemy:GetAbsOrigin() + direction * (enemy:GetHullRadius() + 10))
		caster:FaceTowards(enemy:GetAbsOrigin())
		
		local current_pos = caster:GetAbsOrigin()      
		
		local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", PATTACH_POINT_FOLLOW, enemy)
		ParticleManager:SetParticleControl(effect, 0, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( effect )			

		local effect2 = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(effect2, 0, prev_pos)
		ParticleManager:SetParticleControl(effect2, 1, current_pos)
		ParticleManager:ReleaseParticleIndex( effect2 )
		EmitSoundOn("Hero_Juggernaut.OmniSlash", caster)
		EmitSoundOn("Hero_Juggernaut.OmniSlash.Damage", caster)		

		
		

		break        
	end

    
    if #enemies < 1 then
		self:Destroy()
	end

	-- counter
	self.count = self.count + 1

	self.tick = 1 / (self:GetCaster():GetAttackSpeed(false) * self.slash_rate_divisor)
	self:StartIntervalThink(self.tick)

end

function modifier_aghsfort_juggernaut_omni_slash:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_aghsfort_juggernaut_omni_slash:GetModifierPreAttack_BonusDamage()
	return self.damage_bonus
end
function modifier_aghsfort_juggernaut_omni_slash:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_bonus
end

function modifier_aghsfort_juggernaut_omni_slash:GetOverrideAnimation( params )
	return ACT_DOTA_OVERRIDE_ABILITY_4
end

function modifier_aghsfort_juggernaut_omni_slash:GetStatusEffectName()
	return "particles/status_fx/status_effect_omnislash.vpcf"
end
