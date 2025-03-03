LinkLuaModifier("modifier_generic_3_charges", "heroes/snapfire/snapfire_scatterblast_double_barreled", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_snapfire_scatterblast_double_barrele", "heroes/snapfire/snapfire_scatterblast_double_barreled", LUA_MODIFIER_MOTION_NONE)
snapfire_scatterblast_double_barreled = class({})


function snapfire_scatterblast_double_barreled:GetIntrinsicModifierName()
	
	return "modifier_snapfire_scatterblast_double_barrele"
   
end

modifier_snapfire_scatterblast_double_barrele = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_snapfire_scatterblast_double_barrele:IsHidden()
    return true
end

function modifier_snapfire_scatterblast_double_barrele:IsPurgeException()
    return false
end

function modifier_snapfire_scatterblast_double_barrele:IsPurgable()
    return false
end

function modifier_snapfire_scatterblast_double_barrele:IsPermanent()
    return true
end

function modifier_snapfire_scatterblast_double_barrele:OnCreated(kv)
    if IsServer() then
       local unit = self:GetCaster()
        unit:AddNewModifier(unit, unit:FindAbilityByName("aghsfort_snapfire_scatterblast"), "modifier_generic_3_charges", { })
    end
end

modifier_generic_3_charges = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_3_charges:IsHidden()
    return not self.active
end

function modifier_generic_3_charges:IsDebuff()
    return false
end

function modifier_generic_3_charges:IsPurgable()
    return false
end

function modifier_generic_3_charges:DestroyOnExpire()
    return false
end

function modifier_generic_3_charges:RemoveOnDeath()
    return false
end

function modifier_generic_3_charges:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_3_charges:OnCreated( kv )
    -- references
    self.max_charges = 3
    if IsServer() then
        self.charge_time = self:GetAbility():GetEffectiveCooldown(self:GetAbility():GetLevel())
        self:SetHasCustomTransmitterData( true )
    end
    self.active = true

    if not IsServer() then return end
    self:SetStackCount( self.max_charges )
    self:CalculateCharge()
end

function modifier_generic_3_charges:OnRefresh( kv )
    -- references
    self.max_charges = 3
    
    if IsServer() then
        self.charge_time = self:GetAbility():GetEffectiveCooldown(self:GetAbility():GetLevel())
        self:SetHasCustomTransmitterData( true )
    end

    if not IsServer() then return end
    self:CalculateCharge()
end

function modifier_generic_3_charges:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_generic_3_charges:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }

    return funcs
end

function modifier_generic_3_charges:OnAbilityFullyCast( params )
    if IsServer() then
        if params.unit~=self:GetParent() then
            return
        end
        if params.ability==self:GetAbility() then
            if IsServer() then
                self.charge_time = self:GetAbility():GetEffectiveCooldown(self:GetAbility():GetLevel())
                self:SetHasCustomTransmitterData( true )
            end

            self:DecrementStackCount()
            self:CalculateCharge()
        end
        if params.ability:GetAbilityName()=="item_refresher_shard" or params.ability:GetAbilityName()=="item_refresher" then
            if IsServer() then
                self:SetStackCount( self.max_charges )
                self:CalculateCharge()
            end

            
        end
    end
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_generic_3_charges:OnIntervalThink()
    self:IncrementStackCount()
    self:StartIntervalThink(-1)
    self:CalculateCharge()
end

function modifier_generic_3_charges:CalculateCharge()
    if self.active then
        self:GetAbility():EndCooldown()
    end
    if self:GetStackCount()>=self.max_charges then
        -- stop charging
        self:SetDuration( -1, false )
        self:StartIntervalThink( -1 )
    else
        -- if not charging
        if self:GetRemainingTime() <= 0.05 then
            -- start charging
            local charge_time = self:GetAbility():GetEffectiveCooldown(self:GetAbility():GetLevel())
            if self.charge_time and self.active then
                charge_time = self.charge_time
            end
            self:StartIntervalThink( charge_time )
            self:SetDuration( charge_time, true )
        end

        -- set on cooldown if no charges
        if self:GetStackCount()==0 then
            self:GetAbility():StartCooldown( self:GetRemainingTime() )
        end
    end
end

--------------------------------------------------------------------------------
-- Helper
function modifier_generic_3_charges:SetActive( active )
    -- for server
    self.active = active

    -- todo: self.active should be known to client
end

function modifier_generic_3_charges:AddCustomTransmitterData( )
    return
    {
        charge_time = self.charge_time
    }
end

function modifier_generic_3_charges:HandleCustomTransmitterData( data )
    self.charge_time = data.charge_time
end