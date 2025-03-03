snapfire_firesnap_cookie_freshly_baked = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_freshly_baked", "heroes/snapfire/snapfire_firesnap_cookie_freshly_baked", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_freshly_baked_bonus_damage", "heroes/snapfire/snapfire_firesnap_cookie_freshly_baked", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_freshly_baked_bonus_attackrange", "heroes/snapfire/snapfire_firesnap_cookie_freshly_baked", LUA_MODIFIER_MOTION_NONE )
function snapfire_firesnap_cookie_freshly_baked:GetIntrinsicModifierName()
	return "modifier_snapfire_firesnap_cookie_freshly_baked"
end

modifier_snapfire_firesnap_cookie_freshly_baked = class({})

function modifier_snapfire_firesnap_cookie_freshly_baked:IsHidden()
	return true
end

function modifier_snapfire_firesnap_cookie_freshly_baked:IsPurgeException()
	return false
end

function modifier_snapfire_firesnap_cookie_freshly_baked:IsPurgable()
	return false
end

function modifier_snapfire_firesnap_cookie_freshly_baked:IsPermanent()
	return true
end



function modifier_snapfire_firesnap_cookie_freshly_baked:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end

function modifier_snapfire_firesnap_cookie_freshly_baked:OnCreated(kv)
    if IsServer() then
    end
end

function modifier_snapfire_firesnap_cookie_freshly_baked:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    if params.ability:GetAbilityName() ~= "snapfire_firesnap_cookie"  then
        return
    end
    if params.target and params.target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
        return
    end
    local unit = self:GetParent()

    self.snapfire_firesnap_cookie = unit:FindAbilityByName("snapfire_firesnap_cookie")
    
   
       
            if params.target and not params.target:IsNull() and params.target:IsAlive() and not params.target:IsInvulnerable() then
                params.target:AddNewModifier(params.unit, self.snapfire_firesnap_cookie, "modifier_snapfire_firesnap_cookie_freshly_baked_bonus_damage", {duration = 6.5})
                if params.target:IsRangedAttacker() == true then
                    params.target:AddNewModifier(params.unit, self.snapfire_firesnap_cookie, "modifier_snapfire_firesnap_cookie_freshly_baked_bonus_attackrange", {duration = 6.5})
                end
            end
       
    

end

modifier_snapfire_firesnap_cookie_freshly_baked_bonus_damage = class({})

--------------------------------------------------------------------------------

function modifier_snapfire_firesnap_cookie_freshly_baked_bonus_damage:IsHidden()
    return true
end

--------------------------------------------------------------------------------

function modifier_snapfire_firesnap_cookie_freshly_baked_bonus_damage:IsPurgable()
    return false
end
function modifier_snapfire_firesnap_cookie_freshly_baked_bonus_damage:IsPermanent()
	return false
end
--------------------------------------------------------------------------------

function modifier_snapfire_firesnap_cookie_freshly_baked_bonus_damage:OnCreated( kv )
    if IsServer() then
        self.bonus_damage = 50
    end   
end

--------------------------------------------------------------------------------

function modifier_snapfire_firesnap_cookie_freshly_baked_bonus_damage:DeclareFunctions()
    local funcs =
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
    return funcs
end

-----------------------------------------------------------------------------------------

function modifier_snapfire_firesnap_cookie_freshly_baked_bonus_damage:GetModifierPreAttack_BonusDamage( params )
    return 50
end

--------------------------------------------------------------------------------
modifier_snapfire_firesnap_cookie_freshly_baked_bonus_attackrange = class({})
function modifier_snapfire_firesnap_cookie_freshly_baked_bonus_attackrange:IsHidden()
    return true
end

--------------------------------------------------------------------------------

function modifier_snapfire_firesnap_cookie_freshly_baked_bonus_attackrange:IsPurgable()
    return false
end
function modifier_snapfire_firesnap_cookie_freshly_baked_bonus_attackrange:IsPermanent()
	return false
end
--------------------------------------------------------------------------------

function modifier_snapfire_firesnap_cookie_freshly_baked_bonus_attackrange:OnCreated( kv )
    if IsServer() then
        self.attackrange = 250
    end   
end

--------------------------------------------------------------------------------

function modifier_snapfire_firesnap_cookie_freshly_baked_bonus_attackrange:DeclareFunctions()
    local funcs =
    {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }
    return funcs
end

-----------------------------------------------------------------------------------------

function modifier_snapfire_firesnap_cookie_freshly_baked_bonus_attackrange:GetModifierAttackRangeBonus( params )
    return 250
end
