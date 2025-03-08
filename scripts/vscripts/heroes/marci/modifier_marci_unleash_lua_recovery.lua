modifier_marci_unleash_lua_recovery = class({})

function modifier_marci_unleash_lua_recovery:IsHidden() return false end
function modifier_marci_unleash_lua_recovery:IsDebuff() return true end
function modifier_marci_unleash_lua_recovery:IsPurgable() return false end

function modifier_marci_unleash_lua_recovery:OnCreated(kv)
	self.parent = self:GetParent()

	if not IsServer() then return end
	self.success = kv.success == 1
end

function modifier_marci_unleash_lua_recovery:OnRefresh(kv)
	self:OnCreated(kv)
end

function modifier_marci_unleash_lua_recovery:OnDestroy()
	if not IsServer() then return end

	local main = self.parent:FindModifierByName("modifier_marci_unleash_lua")
	if not main then return end

	if self.forced then return end

	self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_marci_unleash_lua_fury", nil)
end

function modifier_marci_unleash_lua_recovery:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_marci_unleash_lua_recovery:GetActivityTranslationModifiers()
	return "unleash_recharge"
end

function modifier_marci_unleash_lua_recovery:GetModifierFixedAttackRate(params)
	if not self.parent:HasModifier("modifier_marci_unleash_lua_fury") then
		return self:GetDuration() + 0.5
	end
end

function modifier_marci_unleash_lua_recovery:ForceDestroy()
	self.forced = true
	self:Destroy()
end