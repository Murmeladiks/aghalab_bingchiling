aghsfort_phantom_assassin_blur_regeneration = class( {} )

LinkLuaModifier( "modifier_aghsfort_phantom_assassin_blur_regeneration", "heroes/phantom_assassin/aghsfort_phantom_assassin_blur_regeneration", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghsfort_phantom_assassin_blur_regeneration_heal", "heroes/phantom_assassin/aghsfort_phantom_assassin_blur_regeneration", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function aghsfort_phantom_assassin_blur_regeneration:GetIntrinsicModifierName()
	return "modifier_aghsfort_phantom_assassin_blur_regeneration"
end


modifier_aghsfort_phantom_assassin_blur_regeneration = class({})
function modifier_aghsfort_phantom_assassin_blur_regeneration:IsPurgable()	return false end
function modifier_aghsfort_phantom_assassin_blur_regeneration:IsPermanent()	return true end
function modifier_aghsfort_phantom_assassin_blur_regeneration:IsHidden()   return true end

function modifier_aghsfort_phantom_assassin_blur_regeneration:OnCreated(kv)
  
end

function modifier_aghsfort_phantom_assassin_blur_regeneration:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end
function modifier_aghsfort_phantom_assassin_blur_regeneration:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "phantom_assassin_blur" then
        return
    end

    self:GetParent():AddNewModifier(self:GetCaster(),self.ability,"modifier_aghsfort_phantom_assassin_blur_regeneration_heal",{duration = 10})
  
        
end




modifier_aghsfort_phantom_assassin_blur_regeneration_heal = class({})
function modifier_aghsfort_phantom_assassin_blur_regeneration_heal:IsPurgable()	return false end
function modifier_aghsfort_phantom_assassin_blur_regeneration_heal:IsPermanent()	return false end
function modifier_aghsfort_phantom_assassin_blur_regeneration_heal:IsHidden()   return true end
function modifier_aghsfort_phantom_assassin_blur_regeneration_heal:OnCreated(kv)
    self:OnIntervalThink()
	self:StartIntervalThink( 0.5 )
    
    
   
end
function modifier_aghsfort_phantom_assassin_blur_regeneration_heal:OnIntervalThink()
    if  IsServer() then
        local maxHP = self:GetParent():GetMaxHealth()
        local heal = maxHP* 3 / 100
        self:GetParent():Heal( heal, nil )
    end
  
end