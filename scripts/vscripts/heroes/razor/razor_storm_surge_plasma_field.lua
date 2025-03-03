razor_storm_surge_plasma_field = class( {} )

LinkLuaModifier( "modifier_razor_storm_surge_plasma_field", "heroes/razor/razor_storm_surge_plasma_field", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function razor_storm_surge_plasma_field:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_plasmafield.vpcf", context )
end
function razor_storm_surge_plasma_field:GetIntrinsicModifierName()
	return "modifier_razor_storm_surge_plasma_field"
end
function razor_storm_surge_plasma_field:OnSpellStart()
	self.unit = self:GetCursorTarget()
	local caster = self:GetCaster()
	self.razor_plasma_field = caster:FindAbilityByName("razor_plasma_field")
	local damage = self.razor_plasma_field:GetSpecialValueFor("damage_max")
	local radius = self.razor_plasma_field:GetSpecialValueFor( "radius" )
	local speed = 2544
	local pos = self.unit:GetAbsOrigin()
	local targets = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		pos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,	-- int, order filter
		false
	)
	for _,target in pairs(targets) do

		if target and not target:IsNull() and target:IsAlive() and not target:IsInvulnerable() then
			local damageTable = {
				victim = target,
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self.razor_plasma_field, --Optional.
			}
			ApplyDamage(damageTable)
		end
	end
	-- play effects
	local effect = self:PlayEffects( radius, speed )
	Timers:CreateTimer(0.15, function()
		if(self and not self:IsNull()) then
			ParticleManager:DestroyParticle( effect, false )
			ParticleManager:ReleaseParticleIndex( effect )
		end
	end)
end
function razor_storm_surge_plasma_field:PlayEffects( radius, speed )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_razor/razor_plasmafield.vpcf"
	local sound_cast = "Ability.PlasmaField"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.unit )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( speed, radius, 1 ) )
	EmitSoundOn( sound_cast, self.unit )

	return effect_cast
end
modifier_razor_storm_surge_plasma_field = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_razor_storm_surge_plasma_field:IsHidden()
	return true
end

function modifier_razor_storm_surge_plasma_field:IsPurgeException()
	return false
end

function modifier_razor_storm_surge_plasma_field:IsPurgable()
	return false
end

function modifier_razor_storm_surge_plasma_field:IsPermanent()
	return true
end


function modifier_razor_storm_surge_plasma_field:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_razor_storm_surge_plasma_field:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end


function  modifier_razor_storm_surge_plasma_field:OnTakeDamage( params )
    if not IsServer() then
        return
    end
	if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    
        
    if params.inflictor and params.inflictor:GetAbilityName() == "razor_storm_surge" then
        self.razor_plasma_field = self:GetCaster():FindAbilityByName("razor_plasma_field")
		if self.razor_plasma_field and self.razor_plasma_field:GetLevel()>0 then
			if params.unit and not params.unit:IsNull() and params.unit:IsAlive() then
				print("plasma!!!")
				self.ability = self:GetAbility()
				self:GetParent():SetCursorCastTarget(params.unit)
				self.ability:OnSpellStart()

			end
		end
    end



end

