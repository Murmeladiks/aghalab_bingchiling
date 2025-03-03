witch_doctor_voodoo_restoration_cursed = class( {} )

LinkLuaModifier( "modifier_witch_doctor_voodoo_restoration_cursed", "heroes/witch_doctor/witch_doctor_voodoo_restoration_cursed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_witch_doctor_voodoo_restoration_cursed_aura", "heroes/witch_doctor/witch_doctor_voodoo_restoration_cursed", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function witch_doctor_voodoo_restoration_cursed:GetIntrinsicModifierName()
	return "modifier_witch_doctor_voodoo_restoration_cursed"
end


modifier_witch_doctor_voodoo_restoration_cursed = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_witch_doctor_voodoo_restoration_cursed:IsHidden()
	return true
end
function modifier_witch_doctor_voodoo_restoration_cursed:IsAura()
	return true
end
function modifier_witch_doctor_voodoo_restoration_cursed:IsPurgeException()
	return false
end

function modifier_witch_doctor_voodoo_restoration_cursed:IsPurgable()
	return false
end

function modifier_witch_doctor_voodoo_restoration_cursed:IsPermanent()
	return true
end



function modifier_witch_doctor_voodoo_restoration_cursed:OnCreated(kv)
    if IsServer() then
        self.witch_doctor_voodoo_restoration = self:GetParent():FindAbilityByName("witch_doctor_voodoo_restoration")
        self.canapplyaura = false
        self:StartIntervalThink(0.2)
    end
end
function modifier_witch_doctor_voodoo_restoration_cursed:OnIntervalThink()
    self.aura_radius = self.witch_doctor_voodoo_restoration:GetSpecialValueFor("radius")
    if self:GetParent():HasModifier("modifier_voodoo_restoration_heal") then
        self.canapplyaura = true
    else
        self.canapplyaura = false
    end
end
function modifier_witch_doctor_voodoo_restoration_cursed:GetModifierAura()
	return "modifier_witch_doctor_voodoo_restoration_cursed_aura"
end

function modifier_witch_doctor_voodoo_restoration_cursed:GetAuraRadius()
    return self.aura_radius
end

function modifier_witch_doctor_voodoo_restoration_cursed:GetAuraSearchTeam()	
    return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_witch_doctor_voodoo_restoration_cursed:GetAuraSearchType()
	if self.canapplyaura then
		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	end
	
	return DOTA_UNIT_TARGET_NONE
end

function modifier_witch_doctor_voodoo_restoration_cursed:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end



modifier_witch_doctor_voodoo_restoration_cursed_aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_witch_doctor_voodoo_restoration_cursed_aura:IsHidden()
	return true
end



function modifier_witch_doctor_voodoo_restoration_cursed_aura:IsPurgable()
	return false
end

function modifier_witch_doctor_voodoo_restoration_cursed_aura:OnCreated( kv )
    if IsServer() then  
        self.damage_reduction = 35
    end
end
function modifier_witch_doctor_voodoo_restoration_cursed_aura:DeclareFunctions()
    local funcs = 
    {  
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end
function modifier_witch_doctor_voodoo_restoration_cursed_aura:GetModifierIncomingDamage_Percentage( params )
    return self.damage_reduction
end
