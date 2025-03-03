medusa_split_shot_ally = class( {} )

LinkLuaModifier( "modifier_medusa_split_shot_ally", "heroes/medusa/medusa_split_shot_ally", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_medusa_split_shot_ally_buff", "heroes/medusa/medusa_split_shot_ally", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function medusa_split_shot_ally:GetIntrinsicModifierName()
	return "modifier_medusa_split_shot_ally"
end


modifier_medusa_split_shot_ally = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_medusa_split_shot_ally:IsHidden()
	return true
end

function modifier_medusa_split_shot_ally:IsPurgeException()
	return false
end

function modifier_medusa_split_shot_ally:IsPurgable()
	return false
end

function modifier_medusa_split_shot_ally:IsPermanent()
	return true
end



function modifier_medusa_split_shot_ally:OnCreated(kv)
    if IsServer() then
        
        self.canapplyaura = false
        self:StartIntervalThink(0.5)
    end
end
function modifier_medusa_split_shot_ally:OnIntervalThink()
    
    self.medusa_split_shot = self:GetParent():FindAbilityByName("medusa_split_shot")
    if self.medusa_split_shot and self.medusa_split_shot:GetLevel()>0 then
        if self.medusa_split_shot:GetToggleState() == true then
            
            local Range = 600
            local heroes = FindUnitsInRadius(
                self:GetParent():GetTeamNumber(),	-- int, your team number
                self:GetParent():GetAbsOrigin(),	-- point, center point
                nil,	-- handle, cacheUnit. (not known)
                Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                FIND_CLOSEST,	-- int, order filter
                false
            )
        
            
            for _, hero in pairs(heroes) do
                if hero and not hero:IsNull() and not hero:IsInvulnerable() then
                    
                    hero:AddNewModifier(self:GetParent(),self.medusa_split_shot,"modifier_medusa_split_shot_ally_buff",{})
                    
                end
            end
        else
            print("no split")
        end
    end
end






modifier_medusa_split_shot_ally_buff = class({})

--------------------------------------------------------------------------------

function modifier_medusa_split_shot_ally_buff:IsHidden()
    return true
end

--------------------------------------------------------------------------------

function modifier_medusa_split_shot_ally_buff:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_medusa_split_shot_ally_buff:OnCreated( kv )
   local medusa_split_shot = self:GetAbility()
   local pct = medusa_split_shot:GetSpecialValueFor("damage_modifier_tooltip")
   print("damage_modifier_tooltip")
   print(pct)
    self.bonus_damage = self:GetCaster():GetAgility()*pct/100
   print(self.bonus_damage)
end

--------------------------------------------------------------------------------

function modifier_medusa_split_shot_ally_buff:DeclareFunctions()
    local funcs =
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        
    }
    return funcs
end

-----------------------------------------------------------------------------------------

function modifier_medusa_split_shot_ally_buff:GetModifierPreAttack_BonusDamage( params )
    return self.bonus_damage
end

--------------------------------------------------------------------------------


