pathfinder_marci_unleash_passive = class({})
LinkLuaModifier("modifier_pathfinder_marci_unleash_passive", "heroes/marci/pathfinder_marci_unleash_passive", LUA_MODIFIER_MOTION_NONE)

function pathfinder_marci_unleash_passive:GetIntrinsicModifierName()
	return "modifier_pathfinder_marci_unleash_passive"
end

function pathfinder_marci_unleash_passive:Spawn()
	self.bonus_attack_range = self:GetLevelSpecialValueFor("bonus_attack_range", 1)
end

---@class modifier_pathfinder_marci_unleash_passive:CDOTA_Modifier_Lua
modifier_pathfinder_marci_unleash_passive = class({})

function modifier_pathfinder_marci_unleash_passive:IsHidden() return false end
function modifier_pathfinder_marci_unleash_passive:IsPurgable() return false end
function modifier_pathfinder_marci_unleash_passive:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_pathfinder_marci_unleash_passive:DestroyOnExpire() return false end

function modifier_pathfinder_marci_unleash_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_pathfinder_marci_unleash_passive:OnTooltip()
	return self:GetDuration()
end

if IsClient() then return end

function modifier_pathfinder_marci_unleash_passive:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = not self.parent:HasModifier("modifier_marci_unleash_lua_fury") and self.parent:HasModifier("modifier_marci_unleash_lua_passive")
	}
end

function modifier_pathfinder_marci_unleash_passive:GetActivityTranslationModifiers()
	if not self.parent:HasModifier("modifier_marci_unleash_lua_fury") then
		return "unleash_recharge"
	end
end

function modifier_pathfinder_marci_unleash_passive:OnCreated()
	self.parent = self:GetParent()

	local duration = self:GetAbility():GetEffectiveCooldown(-1)
	self:StartIntervalThink(duration)
	self:SetDuration(duration, true)
end

function modifier_pathfinder_marci_unleash_passive:OnIntervalThink()
	if self.parent:HasModifier("modifier_marci_unleash_lua") then return end
	local unleash = self.parent:FindAbilityByName("marci_unleash_lua")
	
	if unleash:IsTrained() then
		self.parent:AddNewModifier(self.parent, unleash, "modifier_marci_unleash_lua_fury", { type = MARCI_UNLEASH_STACK_PASSIVE })
	end

	local duration = self:GetAbility():GetEffectiveCooldown(-1)
	self:StartIntervalThink(duration)
	self:SetDuration(duration, true)
end
