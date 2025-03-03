sniper_shrapnel_death_blinding = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_sniper_shrapnel_death_blinding", "heroes/sniper/sniper_shrapnel_death_blinding", LUA_MODIFIER_MOTION_NONE )
function sniper_shrapnel_death_blinding:GetIntrinsicModifierName()
	return "modifier_sniper_shrapnel_death_blinding"
end


modifier_sniper_shrapnel_death_blinding = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_shrapnel_death_blinding:Precache( context )
	
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context )
end

function modifier_sniper_shrapnel_death_blinding:IsHidden()
	return true
end

function modifier_sniper_shrapnel_death_blinding:IsPurgeException()
	return false
end

function modifier_sniper_shrapnel_death_blinding:IsPurgable()
	return false
end

function modifier_sniper_shrapnel_death_blinding:IsPermanent()
	return true
end




function modifier_sniper_shrapnel_death_blinding:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_sniper_shrapnel_death_blinding:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_sniper_shrapnel_death_blinding:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "sniper_shrapnel" then
        return
    end
    local unit = self:GetParent()
    self.sniper_shrapnel = unit:FindAbilityByName("sniper_shrapnel")
    local radius =self.sniper_shrapnel:GetSpecialValueFor("radius")
    local duration = self.sniper_shrapnel:GetSpecialValueFor("duration")
    
    local cursorPos = params.ability:GetCursorPosition()
   
    local enemies = FindUnitsInRadius(
        unit:GetTeamNumber(),
        cursorPos, 
        nil, 
        radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
        0, 
        false 
    )


    for _,enemy in pairs(enemies) do
        if enemy and not enemy:IsNull() and enemy:IsAlive() and not enemy:IsInvulnerable() then
            enemy:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_keeper_of_the_light_blinding_light",{duration = duration})
        end
    end
    
  

    
end