LinkLuaModifier("modifier_aghsfort_special_magnataur_empower_charges", "heroes/magnus/aghsfort_special_magnataur_empower_charges", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_2_charges", "heroes/magnus/aghsfort_special_magnataur_empower_charges", LUA_MODIFIER_MOTION_NONE)
aghsfort_special_magnataur_empower_charges = class({})


function aghsfort_special_magnataur_empower_charges:GetIntrinsicModifierName()
	
	return "modifier_aghsfort_special_magnataur_empower_charges"
   
end

modifier_aghsfort_special_magnataur_empower_charges = class({})

--------------------------------------------------------------------------------

function modifier_aghsfort_special_magnataur_empower_charges:IsPurgable()	return false end
function modifier_aghsfort_special_magnataur_empower_charges:IsPermanent()	return true end
function modifier_aghsfort_special_magnataur_empower_charges:IsHidden()   return true end



function modifier_aghsfort_special_magnataur_empower_charges:OnCreated(table)
    if IsServer() then
        local unit = self:GetCaster()
         unit:AddNewModifier(unit, unit:FindAbilityByName("magnataur_pf_empower"), "modifier_generic_2_charges", { })
     end
end

modifier_generic_2_charges = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_2_charges:IsHidden()
	return not self.active
end

function modifier_generic_2_charges:IsDebuff()
	return false
end

function modifier_generic_2_charges:IsPurgable()
	return false
end

function modifier_generic_2_charges:DestroyOnExpire()
	return false
end

function modifier_generic_2_charges:RemoveOnDeath()
	return false
end

function modifier_generic_2_charges:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_2_charges:OnCreated( kv )
	-- references
	self.max_charges = 2
	if IsServer() then
		self.charge_time = self:GetAbility():GetEffectiveCooldown(self:GetAbility():GetLevel())
		self:SetHasCustomTransmitterData( true )
	end
	self.active = true

	if not IsServer() then return end
	self:SetStackCount( self.max_charges )
	self:CalculateCharge()
end

function modifier_generic_2_charges:OnRefresh( kv )
	-- references
	self.max_charges = 2
	
	if IsServer() then
		self.charge_time = self:GetAbility():GetEffectiveCooldown(self:GetAbility():GetLevel())
		self:SetHasCustomTransmitterData( true )
	end

	if not IsServer() then return end
	self:CalculateCharge()
end

function modifier_generic_2_charges:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_generic_2_charges:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_generic_2_charges:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit~=self:GetParent()  then
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
function modifier_generic_2_charges:OnIntervalThink()
	self:IncrementStackCount()
	self:StartIntervalThink(-1)
	self:CalculateCharge()
end

function modifier_generic_2_charges:CalculateCharge()
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
function modifier_generic_2_charges:SetActive( active )
	-- for server
	self.active = active

	-- todo: self.active should be known to client
end

function modifier_generic_2_charges:AddCustomTransmitterData( )
	return
	{
		charge_time = self.charge_time
	}
end

function modifier_generic_2_charges:HandleCustomTransmitterData( data )
	self.charge_time = data.charge_time
end