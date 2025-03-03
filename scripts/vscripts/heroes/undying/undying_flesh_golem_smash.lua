LinkLuaModifier("modifier_undying_flesh_golem_smash", "heroes/undying/undying_flesh_golem_smash", LUA_MODIFIER_MOTION_NONE )

undying_flesh_golem_smash = class( {} )
function undying_flesh_golem_smash:GetIntrinsicModifierName()
	return "modifier_undying_flesh_golem_smash"
end

modifier_undying_flesh_golem_smash = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_undying_flesh_golem_smash:IsHidden()
	return true
end

function modifier_undying_flesh_golem_smash:IsPurgeException()
	return false
end

function modifier_undying_flesh_golem_smash:IsPurgable()
	return false
end

function modifier_undying_flesh_golem_smash:IsPermanent()
	return true
end




function modifier_undying_flesh_golem_smash:OnCreated(kv)
    if not IsServer() then
        return
    end
end
function modifier_undying_flesh_golem_smash:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end
function modifier_undying_flesh_golem_smash:OnAttackLanded(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    self.undying_flesh_golem = self:GetParent():FindAbilityByName("undying_flesh_golem") 
    local duration = self.undying_flesh_golem:GetSpecialValueFor("slow_duration")
    local damage = math.floor(self:GetParent():GetAverageTrueAttackDamage(nil)*0.5)
    local radius = 350
    self.damageTable = {
        --victim =  target,
        attacker = self:GetParent(),
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = params.ability, --Optional.
    }
    if self:GetParent():HasModifier("modifier_undying_flesh_golem") then
        local enemies = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),
            params.target:GetAbsOrigin(), 
            nil, 
            radius, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
            0, 
            false 
        )
        for _,enemy in pairs(enemies) do
            if enemy then
                self.damageTable.victim = enemy
                ApplyDamage( self.damageTable )	
                enemy:AddNewModifier(self:GetParent(),self.undying_flesh_golem,"modifier_undying_flesh_golem_slow",{duration = duration})
            end
        end
    end

  
end
