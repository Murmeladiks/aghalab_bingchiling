snapfire_lil_shredder_explosive_shells = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_snapfire_lil_shredder_explosive_shells", "heroes/snapfire/snapfire_lil_shredder_explosive_shells", LUA_MODIFIER_MOTION_NONE )
function snapfire_lil_shredder_explosive_shells:GetIntrinsicModifierName()
	return "modifier_snapfire_lil_shredder_explosive_shells"
end

modifier_snapfire_lil_shredder_explosive_shells = class({})

function modifier_snapfire_lil_shredder_explosive_shells:IsHidden()
	return true
end

function modifier_snapfire_lil_shredder_explosive_shells:IsPurgeException()
	return false
end

function modifier_snapfire_lil_shredder_explosive_shells:IsPurgable()
	return false
end

function modifier_snapfire_lil_shredder_explosive_shells:IsPermanent()
	return true
end



function modifier_snapfire_lil_shredder_explosive_shells:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PRE_ATTACK,
     
    }
end

function modifier_snapfire_lil_shredder_explosive_shells:OnCreated(kv)
    if IsServer() then
        self.radius = 150
        self.shredderDamage = 0
    end
end
function modifier_snapfire_lil_shredder_explosive_shells:GetModifierPreAttack(params)
    if not IsServer() then
        return
    end
    
    local attacker = params.attacker

    if attacker ~= self:GetParent() then
        return
    end
   
        if self:GetParent():HasModifier("modifier_snapfire_lil_shredder_attack") then
            print("shredder_attack")
            self.canSplit = true
            
        else
            print("no_shredder_attack")
            self.canSplit = false
        end
    
end
function modifier_snapfire_lil_shredder_explosive_shells:OnAttackLanded(params)
    if not IsServer() then
        return
    end
    
    local attacker = params.attacker

    if attacker ~= self:GetParent() then
        return
    end

    if attacker:IsNull() or not attacker:IsAlive() then
        return
    end

    if params.target:IsNull() or params.target:IsBuilding() or params.target:IsOther() then
        return
    end

    if params.no_attack_cooldown then
        return
    end



    if  not self.canSplit then
        return
    end
    self.shredderAbility = self:GetParent():FindAbilityByName("snapfire_lil_shredder")
    self.shredderDamage = self.shredderAbility:GetSpecialValueFor("damage")  
    print(self.shredderDamage)  
    local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), params.target:GetOrigin(), nil, 175, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

   
    for _, enemy in ipairs(enemies) do
        if enemy and enemy:IsAlive() and not enemy:IsInvulnerable() and enemy ~= params.target then
            print("found enemies!")
            local totalDamage = 0
            local attackDamage = self:GetCaster():GetAverageTrueAttackDamage(params.target)

            print(attackDamage)
            totalDamage = attackDamage + self.shredderDamage
            print(totalDamage)
            local damageInfo = {
                victim = enemy,
                attacker = self:GetCaster(),
                damage = totalDamage,
                damage_type = DAMAGE_TYPE_MAGICAL,
            }

            ApplyDamage( damageInfo )
        end
    end
end
