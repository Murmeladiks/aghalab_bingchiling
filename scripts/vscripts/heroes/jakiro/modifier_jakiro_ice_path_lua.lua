-- Created by Elfansoer
modifier_jakiro_ice_path_lua = class({})

function modifier_jakiro_ice_path_lua:IsStunDebuff() 	return true end
function modifier_jakiro_ice_path_lua:IsPurgable() 		return false end

function modifier_jakiro_ice_path_lua:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
end

function modifier_jakiro_ice_path_lua:DeclareFunctions() 
	return {	
		MODIFIER_EVENT_ON_DEATH, 
	}
end


function modifier_jakiro_ice_path_lua:OnDeath(params) 
	if not IsServer() or params.unit ~= self:GetParent() or params.unit == nil then return end

	if self:GetCaster():HasAbility("pathfinder_jakiro_ice_path_repeat") then
		local length = self:GetAbility():GetLevelSpecialValueFor("range", self:GetAbility():GetLevel() - 1)
		local a = params.unit:GetAbsOrigin() + params.unit:GetForwardVector() * 80
		local b = params.unit:GetAbsOrigin() + params.unit:GetForwardVector() * (length)
		self:GetAbility():IceFromAToB(a,b)
	end
end

function modifier_jakiro_ice_path_lua:GetEffectName()	
	return "particles/units/heroes/hero_jakiro/jakiro_icepath_debuff.vpcf"
end

function modifier_jakiro_ice_path_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_jakiro_sepcial_ice_path_armour = class({})
LinkLuaModifier( "modifier_jakiro_sepcial_ice_path", "heroes/jakiro/modifier_jakiro_ice_path_lua", LUA_MODIFIER_MOTION_NONE)


function modifier_jakiro_sepcial_ice_path_armour:IsHidden() 		return false end
function modifier_jakiro_sepcial_ice_path_armour:RemoveOnDeath() 	return false end
function modifier_jakiro_sepcial_ice_path_armour:IsDebuff() 		return false end

function modifier_jakiro_sepcial_ice_path_armour:OnCreated( kv )
	if IsServer() and self:GetAbility():GetCaster():HasAbility("pathfinder_jakiro_ice_path_armour") then
		local special = self:GetAbility():GetCaster():FindAbilityByName("pathfinder_jakiro_ice_path_armour")	

		self.resist_percent = special:GetLevelSpecialValueFor("resist_percent", 1)
		self.freeze_duration = special:GetLevelSpecialValueFor("freeze_duration", 1)
		self.ice_armour_talent = true

		
		self:SetHasCustomTransmitterData( true )		
	end
end

function modifier_jakiro_sepcial_ice_path_armour:AddCustomTransmitterData( )

	return
	{
		resist_percent = self.resist_percent,
		freeze_duration = self.freeze_duration,
		ice_armour_talent = self.ice_armour_talent,
	}
end

function modifier_jakiro_sepcial_ice_path_armour:HandleCustomTransmitterData( data )
	self.resist_percent = data.resist_percent
	self.freeze_duration = data.freeze_duration
	self.ice_armour_talent = data.ice_armour_talent
end

function modifier_jakiro_sepcial_ice_path_armour:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_jakiro_sepcial_ice_path_armour:GetModifierIncomingDamage_Percentage()
	if self.ice_armour_talent then
		return self.resist_percent * -1
	end
end

function modifier_jakiro_sepcial_ice_path_armour:OnAttackLanded(params)
	if not IsServer() or params.target ~= self:GetParent() then return end
	if self.ice_armour_talent then
		if params.attacker:IsMagicImmune() == false and params.attacker:IsInvulnerable() == false then		
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_crystalmaiden/maiden_frostbite.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, params.attacker, PATTACH_ABSORIGIN_FOLLOW, nil, params.attacker:GetAbsOrigin(), false )
			ParticleManager:ReleaseParticleIndex( nFXIndex );			

			params.attacker:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_jakiro_ice_path_lua", { duration = self.freeze_duration} )			
			EmitSoundOn( "IceDragonMaw.Trigger", params.attacker )							
		end
	end
end

function modifier_jakiro_sepcial_ice_path_armour:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_frosty_dire.vpcf"
end

function modifier_jakiro_sepcial_ice_path_armour:StatusEffectPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA 
end
