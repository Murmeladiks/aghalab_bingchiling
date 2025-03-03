spectre_dispersion_proc= class( {} )

LinkLuaModifier( "modifier_spectre_dispersion_proc", "heroes/spectre/spectre_dispersion_proc", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_dispersion_proc_buff", "heroes/spectre/spectre_dispersion_proc", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_ring", "modifiers/generic/modifier_generic_ring", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function spectre_dispersion_proc:GetIntrinsicModifierName()
	return "modifier_spectre_dispersion_proc"
end



modifier_spectre_dispersion_proc= class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_dispersion_proc:IsHidden()
	return true
end

function modifier_spectre_dispersion_proc:IsPurgeException()
	return false
end

function modifier_spectre_dispersion_proc:IsPurgable()
	return false
end

function modifier_spectre_dispersion_proc:IsPermanent()
	return true
end


function modifier_spectre_dispersion_proc:OnCreated( kv )
	if IsServer() then
        
    end
end

	
function modifier_spectre_dispersion_proc:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end



function  modifier_spectre_dispersion_proc:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    
    self.spectre_dispersion = self:GetParent():FindAbilityByName("spectre_dispersion")
    if self.spectre_dispersion  and self.spectre_dispersion:GetLevel()>0 then
        self.chance =100 --self.spectre_dispersion:GetSpecialValueFor("damage_reflection_pct")
        if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
            if not self:GetParent():HasModifier("modifier_spectre_dispersion_proc_buff") then
                self:GetParent():AddNewModifier(self:GetParent(), self.spectre_dispersion, "modifier_spectre_dispersion_proc_buff", {duration = 3})
            end
        end

    end
end

modifier_spectre_dispersion_proc_buff= class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_dispersion_proc_buff:Precache( context )
	PrecacheResource( "particle", "particles/creatures/spectre/spectre_damage_ring.vpcf", context )
	
end
function modifier_spectre_dispersion_proc_buff:IsHidden()
	return false
end

function modifier_spectre_dispersion_proc_buff:IsPurgeException()
	return false
end

function modifier_spectre_dispersion_proc_buff:IsPurgable()
	return false
end

function modifier_spectre_dispersion_proc_buff:IsPermanent()
	return false
end


function modifier_spectre_dispersion_proc_buff:OnCreated( kv )
	if IsServer() then
        self.caster = self:GetParent()
        self.ability = self:GetAbility()
        self.radius = 700
        self.speed = 450
    end
end
function modifier_spectre_dispersion_proc_buff:DeclareFunctions()
    local funcs =
    {
       
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,

        
    }
    return funcs
end
function modifier_spectre_dispersion_proc_buff:GetModifierIncomingDamage_Percentage( params )
    if IsServer() then
        if params.attacker == nil or params.attacker:IsNull() or not params.attacker:IsAlive() or 
            params.attacker:IsBuilding() or params.attacker:IsOther() or params.attacker:IsInvulnerable() then
            return 0
        end

    

        if params.damage_flags == DOTA_DAMAGE_FLAG_REFLECTION then
            return 0
        end

        if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
            return 0
        end
        
        if self:GetParent():IsNull() or not self:GetParent():IsAlive() then
            return 0
        end

        local attacker = params.attacker
        local damage = params.damage 



      

        if attacker:GetTeam() ~= self:GetParent():GetTeam() then
            --Blade Mail 2 bonus damage
         
        self:StartDispersionPlasma(damage)
          

        end


        return 0
    end
    
    return 0
end
function modifier_spectre_dispersion_proc_buff:StartDispersionPlasma(damage)
    self.damage = damage
    -- play effects
    local effect = self:PlayEffects( self.radius, self.speed )

    -- create ring
    local pulse = self.caster:AddNewModifier(
        self.caster, -- player source
        self, -- ability source
        "modifier_generic_ring", -- modifier name
        {
            end_radius = self.radius,
            speed = self.speed,
            target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
            target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        } -- kv
    )
    pulse:SetCallback( function( enemy )
        if self and not self:IsNull() then
            self:OnHit( enemy )
        end
    end)

    pulse:SetEndCallback( function()
        -- set retract effects
        -- ParticleManager:SetParticleControl( effect, 1, Vector( speed, radius, -1 ) )

        ParticleManager:DestroyParticle( effect, false )
        ParticleManager:ReleaseParticleIndex( effect )
    end)
end

function modifier_spectre_dispersion_proc_buff:OnHit( enemy )
    if self.damage and self.damage > 0 then
        local caster = self:GetParent()

        -- apply damage
        local damageTable = {
            victim = enemy,
            attacker = caster,
            damage = self.damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self, --Optional.
        }
    
        ApplyDamage(damageTable)
    end
    
    -- Play effects
    local sound_cast = "Ability.PlasmaFieldImpact"
    EmitSoundOn( sound_cast, enemy )
end

--------------------------------------------------------------------------------
-- Effects
function modifier_spectre_dispersion_proc_buff:PlayEffects( radius, speed )
    -- Get Resources
    local particle_cast = "particles/creatures/spectre/spectre_damage_ring.vpcf"
    local sound_cast = "Ability.PlasmaField"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector( speed, radius, 1 ) )

    EmitSoundOn( sound_cast, self:GetCaster() )

    return effect_cast
end