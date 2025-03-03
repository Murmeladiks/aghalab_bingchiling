aghsfort_phantom_assassin_phantom_strike_damage_reduction = class( {} )

LinkLuaModifier( "modifier_aghsfort_phantom_assassin_phantom_strike_damage_reduction", "heroes/phantom_assassin/aghsfort_phantom_assassin_phantom_strike_damage_reduction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_strike_damage_reduction", "heroes/phantom_assassin/aghsfort_phantom_assassin_phantom_strike_damage_reduction", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function aghsfort_phantom_assassin_phantom_strike_damage_reduction:GetIntrinsicModifierName()
	return "modifier_aghsfort_phantom_assassin_phantom_strike_damage_reduction"
end


modifier_aghsfort_phantom_assassin_phantom_strike_damage_reduction = class({})
function modifier_aghsfort_phantom_assassin_phantom_strike_damage_reduction:IsPurgable()	return false end
function modifier_aghsfort_phantom_assassin_phantom_strike_damage_reduction:IsPermanent()	return true end
function modifier_aghsfort_phantom_assassin_phantom_strike_damage_reduction:IsHidden()   return true end

function modifier_aghsfort_phantom_assassin_phantom_strike_damage_reduction:OnCreated(kv)
  
end

function modifier_aghsfort_phantom_assassin_phantom_strike_damage_reduction:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function  modifier_aghsfort_phantom_assassin_phantom_strike_damage_reduction:OnAttackLanded( params )
    if not IsServer() then
        return
    end
    
    local attacker = params.attacker

    if attacker ~= self:GetParent() then
        return
    end

    if attacker:IsNull() or not attacker:IsAlive() then
        return
    end

    if params.target:IsNull() or not params.target:IsAlive() or params.target:IsBuilding() or params.target:IsOther() then
        return
    end

    if params.no_attack_cooldown then
		return
	end
    self.ability = self:GetParent():FindAbilityByName("phantom_assassin_phantom_strike")
    local duration = self.ability:GetSpecialValueFor("duration")
    if params.target and not params.target:IsNull() and not params.target:IsInvulnerable()  then
        
        
        params.target:AddNewModifier(self:GetCaster(),self.ability,"modifier_phantom_strike_damage_reduction",{duration = duration})
    
    end
    

end
modifier_phantom_strike_damage_reduction = class({})
function modifier_phantom_strike_damage_reduction:IsPurgable()	return true end
function modifier_phantom_strike_damage_reduction:IsPermanent()	return false end
function modifier_phantom_strike_damage_reduction:IsHidden()   return true end
function modifier_phantom_strike_damage_reduction:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end
function modifier_phantom_strike_damage_reduction:GetModifierDamageOutgoing_Percentage(params)

	return -85
end