modifier_juggernaut_mana_ward_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_juggernaut_mana_ward_effect:IsHidden()
	return false
end

function modifier_juggernaut_mana_ward_effect:IsDebuff()
	return false
end

function modifier_juggernaut_mana_ward_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_juggernaut_mana_ward_effect:OnCreated( kv )
	local ability = nil
	if IsServer() then
		ability = self:GetAbility():GetCaster():GetOwner():FindAbilityByName("juggernaut_healing_ward") -- special value
		
		self.regen = ability:GetLevelSpecialValueFor( "healing_ward_heal_amount" , ability:GetLevel() - 1) 
		self:SetHasCustomTransmitterData( true )
	end		
end

function modifier_juggernaut_mana_ward_effect:OnRefresh( kv )
	local ability = nil
	if IsServer() then
		ability = self:GetAbility():GetCaster():GetOwner():FindAbilityByName("juggernaut_healing_ward") -- special value

		self.regen = ability:GetLevelSpecialValueFor( "healing_ward_heal_amount" , ability:GetLevel() - 1)
		self:SetHasCustomTransmitterData( true )
	end	
end

function modifier_juggernaut_mana_ward_effect:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_juggernaut_mana_ward_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,		
	}

	return funcs
end


function modifier_juggernaut_mana_ward_effect:GetModifierTotalPercentageManaRegen()
	return self.regen
end

function modifier_juggernaut_mana_ward_effect:GetEffectName()
	return "particles/items_fx/healing_flask_c.vpcf"
end

function modifier_juggernaut_mana_ward_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



function modifier_juggernaut_mana_ward_effect:AddCustomTransmitterData( )
	return
	{
		regen = self.regen,
	}
end

--------------------------------------------------------------------------------

function modifier_juggernaut_mana_ward_effect:HandleCustomTransmitterData( data )
	self.regen = data.regen
end



