abaddon_aphotic_shield_death_coil = class( {} )

LinkLuaModifier( "modifier_abaddon_aphotic_shield_death_coil", "heroes/abaddon/abaddon_aphotic_shield_death_coil", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function abaddon_aphotic_shield_death_coil:GetIntrinsicModifierName()
	return "modifier_abaddon_aphotic_shield_death_coil"
end

modifier_abaddon_aphotic_shield_death_coil = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_abaddon_aphotic_shield_death_coil:IsHidden()
	return true
end

function modifier_abaddon_aphotic_shield_death_coil:IsPurgeException()
	return false
end

function modifier_abaddon_aphotic_shield_death_coil:IsPurgable()
	return false
end

function modifier_abaddon_aphotic_shield_death_coil:IsPermanent()
	return true
end


function modifier_abaddon_aphotic_shield_death_coil:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_abaddon_aphotic_shield_death_coil:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_abaddon_aphotic_shield_death_coil:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    if not params.target then return end

    if params.ability:GetAbilityName() == "abaddon_death_coil" then
        self.abaddon_aphotic_shield = self:GetParent():FindAbilityByName("abaddon_aphotic_shield")
        if self.abaddon_aphotic_shield and self.abaddon_aphotic_shield:GetLevel() > 0 then
            self:GetCaster():SetCursorCastTarget(params.target)
            self.abaddon_aphotic_shield:OnSpellStart()
        end
    end
     
  
    if params.ability:GetAbilityName() == "abaddon_aphotic_shield" then
        self.abaddon_death_coil = self:GetParent():FindAbilityByName("abaddon_death_coil")
        if self.abaddon_death_coil and self.abaddon_death_coil:GetLevel() > 0 then
            self:GetCaster():SetCursorCastTarget(params.target)
            self.abaddon_death_coil:OnSpellStart()
        end
    end
   
    
		
	

    

end