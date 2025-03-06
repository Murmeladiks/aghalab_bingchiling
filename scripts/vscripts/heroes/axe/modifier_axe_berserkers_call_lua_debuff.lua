modifier_axe_berserkers_call_lua_debuff = class({})
LinkLuaModifier( "modifier_axe_berserkers_call_special_health", "heroes/axe/axe_berserkers_call_lua", LUA_MODIFIER_MOTION_NONE )

function modifier_axe_berserkers_call_lua_debuff:IsHidden() 	return false end
function modifier_axe_berserkers_call_lua_debuff:IsDebuff() 	return true end
function modifier_axe_berserkers_call_lua_debuff:IsStunDebuff() return false end
function modifier_axe_berserkers_call_lua_debuff:IsPurgable() 	return false end


function modifier_axe_berserkers_call_lua_debuff:OnCreated( kv )
	self.parent = self:GetParent()
	self.caster = self:GetCaster()

	self.nAttackSpeed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")

	if not IsServer() then return end

	self.parent:SetForceAttackTarget(self.caster) -- for creeps
	self.parent:MoveToTargetToAttack(self.caster) -- for heroes
end

function modifier_axe_berserkers_call_lua_debuff:OnRemoved()
	if not IsServer() then return end
	if self.parent and not self.parent:IsNull() then
		self.parent:SetForceAttackTarget(nil)
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_axe_berserkers_call_lua_debuff:CheckState()
	return {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
end


function modifier_axe_berserkers_call_lua_debuff:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT	
	}
end

function modifier_axe_berserkers_call_lua_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.nAttackSpeed
end

function modifier_axe_berserkers_call_lua_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

function modifier_axe_berserkers_call_lua_debuff:OnDeath(params)
	if params.unit ~= self.parent then return end

	if self.caster:HasAbility("pathfinder_axe_special_berseker_call_health") then
		self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_axe_berserkers_call_special_health", {})
	end
end