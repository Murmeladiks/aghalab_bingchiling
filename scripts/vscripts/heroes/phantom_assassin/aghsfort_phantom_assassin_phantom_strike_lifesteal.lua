aghsfort_phantom_assassin_phantom_strike_lifesteal = class( {} )

LinkLuaModifier( "modifier_aghsfort_phantom_assassin_phantom_strike_lifesteal", "heroes/phantom_assassin/aghsfort_phantom_assassin_phantom_strike_lifesteal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_strike_lifesteal", "heroes/phantom_assassin/aghsfort_phantom_assassin_phantom_strike_lifesteal", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function aghsfort_phantom_assassin_phantom_strike_lifesteal:GetIntrinsicModifierName()
	return "modifier_aghsfort_phantom_assassin_phantom_strike_lifesteal"
end


modifier_aghsfort_phantom_assassin_phantom_strike_lifesteal = class({})
function modifier_aghsfort_phantom_assassin_phantom_strike_lifesteal:IsPurgable()	return false end
function modifier_aghsfort_phantom_assassin_phantom_strike_lifesteal:IsPermanent()	return true end
function modifier_aghsfort_phantom_assassin_phantom_strike_lifesteal:IsHidden()   return true end

function modifier_aghsfort_phantom_assassin_phantom_strike_lifesteal:OnCreated(kv)
  
end

function modifier_aghsfort_phantom_assassin_phantom_strike_lifesteal:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end
function modifier_aghsfort_phantom_assassin_phantom_strike_lifesteal:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "phantom_assassin_phantom_strike" then
        return
    end
    
    self.ability = self:GetParent():FindAbilityByName("phantom_assassin_phantom_strike")
    local duration = self.ability:GetSpecialValueFor("duration")
   
        
        
    params.unit:AddNewModifier(self:GetCaster(),self.ability,"modifier_phantom_strike_lifesteal",{duration = duration})
    
       
end

modifier_phantom_strike_lifesteal = class({})
function modifier_phantom_strike_lifesteal:IsPurgable()	return false end
function modifier_phantom_strike_lifesteal:IsPermanent()	return false end
function modifier_phantom_strike_lifesteal:IsHidden()   return true end

function modifier_phantom_strike_lifesteal:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_phantom_strike_lifesteal:OnAttackLanded( params )
    if IsServer() then
        local Target = params.target
        local Attacker = params.attacker
        if Attacker ~= nil and Attacker == self:GetParent() and Target ~= nil then
           

            local heal =  params.damage * 30 / 100 

           
            self:GetParent():Heal( heal, self:GetAbility() )

            local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally )
            ParticleManager:ReleaseParticleIndex( nFXIndex )
                
            
        end
    end
end