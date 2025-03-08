modifier_marci_unleash_lua = class({})

function modifier_marci_unleash_lua:IsHidden() return false end
function modifier_marci_unleash_lua:IsDebuff() return false end
function modifier_marci_unleash_lua:IsPurgable() return false end

function modifier_marci_unleash_lua:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.bonus_ms = self:GetAbility():GetSpecialValueFor("bonus_movespeed")

	if not IsServer() then return end

	self.parent:Purge( false, true, false, false, false )
	self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_marci_unleash_lua_fury", nil)

	self:PlayEffects()
end

function modifier_marci_unleash_lua:OnRefresh( kv )
	self.bonus_ms = self:GetAbility():GetSpecialValueFor("bonus_movespeed")	

	if not IsServer() then return end

	self.parent:Purge(false, true, false, false, false)
	self:PlayEffects()
end

function modifier_marci_unleash_lua:OnDestroy()
	if not IsServer() then return end

	local fury = self.parent:FindModifierByName("modifier_marci_unleash_lua_fury")
	if fury then
		fury:RemoveStacks(MARCI_UNLEASH_STACK_DEFAULT)
	end

	local recovery = self.parent:FindModifierByName("modifier_marci_unleash_lua_recovery")
	if recovery and recovery:GetDuration() ~= -1 then
		recovery:ForceDestroy()
	end
end

function modifier_marci_unleash_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE,
	}

	return funcs
end

function modifier_marci_unleash_lua:GetModifierAttackRangeOverride()
	local passive_shard = self.parent:FindAbilityByName("pathfinder_marci_unleash_passive")
	if passive_shard then
		return passive_shard.bonus_attack_range
	end
end

function modifier_marci_unleash_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_ms
end

function modifier_marci_unleash_lua:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Cast"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, self:GetParent() )
end

