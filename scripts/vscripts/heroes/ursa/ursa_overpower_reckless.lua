ursa_overpower_reckless = class( {} )

LinkLuaModifier( "modifier_ursa_overpower_reckless", "heroes/ursa/ursa_overpower_reckless", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ursa_overpower_reckless:GetIntrinsicModifierName()
	return "modifier_ursa_overpower_reckless"
end

modifier_ursa_overpower_reckless = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ursa_overpower_reckless:IsHidden()
	return true
end

function modifier_ursa_overpower_reckless:IsPurgeException()
	return false
end

function modifier_ursa_overpower_reckless:IsPurgable()
	return false
end

function modifier_ursa_overpower_reckless:IsPermanent()
	return true
end


function modifier_ursa_overpower_reckless:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_ursa_overpower_reckless:DeclareFunctions()
	local funcs = {
        
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function  modifier_ursa_overpower_reckless:OnAttackLanded(params)
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
    self.ursa_overpower = self:GetParent():FindAbilityByName("ursa_overpower")
    self.ursa_fury_swipes = self:GetParent():FindAbilityByName("ursa_fury_swipes")
    local debuffStacks = 0
    local furySwipeBonusDamage = 0
    if self:GetParent():HasModifier("modifier_ursa_overpower") then
        if params.target:HasModifier("modifier_ursa_fury_swipes_damage_increase") then
            local debuff = params.target:FindModifierByNameAndCaster("modifier_ursa_fury_swipes_damage_increase", self:GetParent())
            if debuff then
                debuffStacks = debuff:GetStackCount()
            end
        end
    
        if debuffStacks and debuffStacks > 0 then
            local dmgPerStack = self.ursa_fury_swipes:GetSpecialValueFor("damage_per_stack")
            furySwipeBonusDamage = debuffStacks * dmgPerStack          
        end
        local damage = self:GetParent():GetAttackDamage() + furySwipeBonusDamage
        DoCleaveAttack(self:GetParent(), params.target, self.ursa_overpower, damage, 150, 360, 650, "particles/items_fx/battlefury_cleave.vpcf")
    end
     

end
