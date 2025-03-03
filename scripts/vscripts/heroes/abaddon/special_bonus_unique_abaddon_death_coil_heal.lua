special_bonus_unique_abaddon_death_coil_heal = class( {} )

LinkLuaModifier( "modifier_special_bonus_unique_abaddon_death_coil_heal", "heroes/abaddon/special_bonus_unique_abaddon_death_coil_heal", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function special_bonus_unique_abaddon_death_coil_heal:GetIntrinsicModifierName()
	return "modifier_special_bonus_unique_abaddon_death_coil_heal"
end

modifier_special_bonus_unique_abaddon_death_coil_heal = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_special_bonus_unique_abaddon_death_coil_heal:IsHidden()
	return true
end

function modifier_special_bonus_unique_abaddon_death_coil_heal:IsPurgeException()
	return false
end

function modifier_special_bonus_unique_abaddon_death_coil_heal:IsPurgable()
	return false
end

function modifier_special_bonus_unique_abaddon_death_coil_heal:IsPermanent()
	return true
end


function modifier_special_bonus_unique_abaddon_death_coil_heal:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_special_bonus_unique_abaddon_death_coil_heal:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_special_bonus_unique_abaddon_death_coil_heal:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    if not params.target then return end

    if params.ability:GetAbilityName() ~= "abaddon_death_coil" then
        return
    end
     
    local unit = self:GetParent()
    
	local hPlayerHeroIndex = unit:GetEntityIndex()
    self.abaddon_death_coil = unit:FindAbilityByName("abaddon_death_coil")
    if self.abaddon_death_coil and self.abaddon_death_coil:GetLevel() > 0 then
        local heal = self.abaddon_death_coil:GetSpecialValueFor("target_damage")*0.4
    	params.unit:Heal(heal, self:GetAbility())
    end
   
    
		
	

    

end