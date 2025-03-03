medusa_stone_gaze_stone_buff = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_medusa_stone_gaze_stone_buff", "heroes/medusa/medusa_stone_gaze_stone_buff", LUA_MODIFIER_MOTION_NONE )

function medusa_stone_gaze_stone_buff:GetIntrinsicModifierName()
	return "modifier_medusa_stone_gaze_stone_buff"
end



modifier_medusa_stone_gaze_stone_buff = class({})

--------------------------------------------------------------------------------
-- Classifications

function modifier_medusa_stone_gaze_stone_buff:IsHidden()
	return true
end

function modifier_medusa_stone_gaze_stone_buff:IsPurgeException()
	return false
end

function modifier_medusa_stone_gaze_stone_buff:IsPurgable()
	return false
end

function modifier_medusa_stone_gaze_stone_buff:IsPermanent()
	return true
end




function modifier_medusa_stone_gaze_stone_buff:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_medusa_stone_gaze_stone_buff:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH,
    }
end
function modifier_medusa_stone_gaze_stone_buff:OnDeath(params)
    if not IsServer() then
        return
    end
    if params.unit==self:GetParent() then
        return
    end
    self.medusa_stone_gaze = self:GetParent():FindAbilityByName("medusa_stone_gaze")
    local duration = self.medusa_stone_gaze:GetSpecialValueFor("duration")
    if  params.unit:HasModifier("modifier_medusa_stone_gaze_stone")  then
        if  RollPseudoRandomPercentage(25, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
            local enemies = FindUnitsInRadius(
                self:GetParent():GetTeamNumber(),	-- int, your team number
                params.unit:GetAbsOrigin(),	-- point, center point
                nil,	-- handle, cacheUnit. (not known)
                300,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                FIND_CLOSEST,	-- int, order filter
                false
            )
            for _,enemy in pairs( enemies ) do
                if enemy ~= nil   then
                    enemy:AddNewModifier(self:GetParent(), self.medusa_stone_gaze, "modifier_medusa_stone_gaze_stone", {duration = duration})
                    local damage = params.unit:GetMaxHealth()*0.1
                    local damagetable = 
                    {
                        victim = enemy,
                        attacker = self:GetParent(),
                        damage = damage,
                        damage_type = DAMAGE_TYPE_PHYSICAL,
                        ability = self:GetAbility(),
                    }
                    ApplyDamage(damagetable)
                end
            end   
        end           
     end

  

    
end

