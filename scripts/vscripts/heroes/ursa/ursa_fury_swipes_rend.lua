ursa_fury_swipes_rend = class( {} )

LinkLuaModifier( "modifier_ursa_fury_swipes_rend", "heroes/ursa/ursa_fury_swipes_rend", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ursa_fury_swipes_rend:GetIntrinsicModifierName()
	return "modifier_ursa_fury_swipes_rend"
end

modifier_ursa_fury_swipes_rend = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ursa_fury_swipes_rend:IsHidden()
	return true
end

function modifier_ursa_fury_swipes_rend:IsPurgeException()
	return false
end

function modifier_ursa_fury_swipes_rend:IsPurgable()
	return false
end

function modifier_ursa_fury_swipes_rend:IsPermanent()
	return true
end



function modifier_ursa_fury_swipes_rend:OnCreated(kv)
    if IsServer() then
        
    
    end
end
function modifier_ursa_fury_swipes_rend:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        
    }
end
function modifier_ursa_fury_swipes_rend:OnAttackLanded( params )
    if not IsServer() then return end
    if self:GetParent() ~= params.attacker then
        return
    end
    if params.attacker == params.target then 
        return
    end
    if params.target:IsBuilding() or params.target:IsOther() then
        return
    end
    local count  = 0
    count =  count + 1

    .
    
end




function modifier_ursa_fury_swipes_rend:OnTakeDamage( params )
    if not IsServer() then return end

    if self:GetParent() ~= params.attacker then
        return
    end

    if params.attacker == params.unit then 
        return
    end

    if params.unit:IsBuilding() or params.unit:IsOther() then
        return
    end

    if params.damage_flags == DOTA_DAMAGE_FLAG_REFLECTION then
        return
    end

    if not self.lifesteal or self.lifesteal == 0 then
        return
    end
    local lifesteal = 0 
    local spellsteal = 0
    -- inflictor means that is damage from abilities
    if params.unit:HasModifier("modifier_ursa_fury_swipes_damage_increase") then
        local buff = params.unit:FindModifierByName("modifier_ursa_fury_swipes_damage_increase")
        if buff then
            local stackcount = buff:GetStackCount()
             lifesteal = 3*stackcount
             spellsteal = 3*stackcount
           
        end
    end
    
    if params.inflictor then
        if params.inflictor ~= nil and params.attacker == self:GetParent() and params.unit ~= params.attacker then
            if params.damage_flags == DOTA_DAMAGE_FLAG_REFLECTION then
                return
            end

            if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
                return 0
            end
            if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
                return 0
            end
    
            local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker )
            ParticleManager:ReleaseParticleIndex( nFXIndex )
    
            local flLifesteal = params.damage * spellsteal / 100
            self:GetParent():Heal(heal, self:GetAbility())
        end
    else
        local healPercentage = lifesteal / 100
        local heal = params.damage * healPercentage

        self:GetParent():Heal(heal, self:GetAbility())
        self:PlayEffects()
    end
    
   
end
function modifier_ursa_fury_swipes_rend:PlayEffects()
    local particle_life_steal = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"

    -- Create Particle for caster life steal
    local effect_life_steal = ParticleManager:CreateParticle( particle_life_steal, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl( effect_life_steal, 1, self:GetParent():GetAbsOrigin() )
    ParticleManager:ReleaseParticleIndex( effect_life_steal )
end
