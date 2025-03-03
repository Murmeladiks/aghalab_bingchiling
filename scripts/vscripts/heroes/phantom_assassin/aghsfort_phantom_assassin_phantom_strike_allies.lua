aghsfort_phantom_assassin_phantom_strike_allies = class( {} )

LinkLuaModifier( "modifier_aghsfort_phantom_assassin_phantom_strike_allies", "heroes/phantom_assassin/aghsfort_phantom_assassin_phantom_strike_allies", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function aghsfort_phantom_assassin_phantom_strike_allies:GetIntrinsicModifierName()
	return "modifier_aghsfort_phantom_assassin_phantom_strike_allies"
end


modifier_aghsfort_phantom_assassin_phantom_strike_allies = class({})
function modifier_aghsfort_phantom_assassin_phantom_strike_allies:IsPurgable()	return false end
function modifier_aghsfort_phantom_assassin_phantom_strike_allies:IsPermanent()	return true end
function modifier_aghsfort_phantom_assassin_phantom_strike_allies:IsHidden()   return true end

function modifier_aghsfort_phantom_assassin_phantom_strike_allies:OnCreated(kv)
  
end

function modifier_aghsfort_phantom_assassin_phantom_strike_allies:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end
function modifier_aghsfort_phantom_assassin_phantom_strike_allies:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "phantom_assassin_phantom_strike" then
        return
    end
    if params.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
        return
    end
    self.ability = self:GetParent():FindAbilityByName("phantom_assassin_phantom_strike")
    local duration = self.ability:GetSpecialValueFor("duration")
    if params.target and not params.target:IsNull() and not params.target:IsInvulnerable()  then
        
        
        params.target:AddNewModifier(self:GetCaster(),self.ability,"modifier_phantom_assassin_phantom_strike",{duration = duration})
    
    end

    
   
   
        
end



