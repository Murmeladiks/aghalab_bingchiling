lina_laguna_blade_snake = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_lina_laguna_blade_snake", "heroes/lina/lina_laguna_blade_snake", LUA_MODIFIER_MOTION_NONE )

function lina_laguna_blade_snake:GetIntrinsicModifierName()
	return "modifier_lina_laguna_blade_snake"
end
function lina_laguna_blade_snake:OnSpellStart()

	

end

modifier_lina_laguna_blade_snake = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lina_laguna_blade_snake:IsHidden()
	return true
end

function modifier_lina_laguna_blade_snake:IsPurgeException()
	return false
end

function modifier_lina_laguna_blade_snake:IsPurgable()
	return false
end

function modifier_lina_laguna_blade_snake:IsPermanent()
	return true
end



function modifier_lina_laguna_blade_snake:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_lina_laguna_blade_snake:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_lina_laguna_blade_snake:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "lina_laguna_blade" then
        return
    end
    local unit = self:GetParent()
    self.lina_laguna_blade = unit:FindAbilityByName("lina_laguna_blade")
    local maintarget = params.unit
    local radius = 600
    
    local enemies = FindUnitsInRadius(
        unit:GetTeamNumber(),
        unit:GetAbsOrigin(), 
        nil, 
        radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
        0, 
        false 
    )


    for _,enemy in pairs(enemies) do
        self:GetCaster():SetCursorCastTarget(enemy)
        self.lina_laguna_blade:OnSpellStart()
    end

  

   
end
