pathfinder_marci_grapple_stun = class({})
LinkLuaModifier("modifier_pathfinder_marci_grapple_stun", "heroes/marci/pathfinder_marci_grapple_stun", LUA_MODIFIER_MOTION_NONE)

function pathfinder_marci_grapple_stun:GetIntrinsicModifierName()
	return "modifier_pathfinder_marci_grapple_stun"
end

function pathfinder_marci_grapple_stun:Spawn()
end

---@class modifier_pathfinder_marci_grapple_stun:CDOTA_Modifier_Lua
modifier_pathfinder_marci_grapple_stun = class({})

function modifier_pathfinder_marci_grapple_stun:IsHidden() return true end
function modifier_pathfinder_marci_grapple_stun:IsPurgable() return false end
function modifier_pathfinder_marci_grapple_stun:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

if IsClient() then return end

function modifier_pathfinder_marci_grapple_stun:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PRE_ATTACK,
	}
end

function modifier_pathfinder_marci_grapple_stun:OnCreated()
	self.disarm_duration = self:GetAbility():GetSpecialValueFor("disarm_duration")
end

function modifier_pathfinder_marci_grapple_stun:GetModifierPreAttack(params)
	local target = params.target
	local attacker = params.attacker
	local fury = attacker:FindModifierByName("modifier_marci_unleash_lua_fury")
	
	if target:HasModifier("modifier_marci_grapple_pf_debuff") then
		local unleash = attacker:FindAbilityByName("marci_unleash_lua")
		
		if unleash and unleash:IsTrained() then
			if not fury or not fury:HasStacks(MARCI_UNLEASH_STACK_DISPOSE_STUNNED) then
				attacker:AddNewModifier(attacker, unleash, "modifier_marci_unleash_lua_fury", { type = MARCI_UNLEASH_STACK_DISPOSE_STUNNED})
			end

			self:StartIntervalThink(0.1)
			return
		end
	end

	local fury = attacker:FindModifierByName("modifier_marci_unleash_lua_fury")
	if fury and fury:HasStacks(MARCI_UNLEASH_STACK_DISPOSE_STUNNED) then
		fury:RemoveStacks(MARCI_UNLEASH_STACK_DISPOSE_STUNNED)
		attacker:AddNewModifier(attacker, self:GetAbility(), "modifier_disarmed", { duration = self.disarm_duration })
		self:StartIntervalThink(-1)
	end
end

function modifier_pathfinder_marci_grapple_stun:OnIntervalThink()
	local attacker = self:GetParent()
	local target = attacker:GetAttackTarget()

	if not target or not target:HasModifier("modifier_marci_grapple_pf_debuff") then
		local fury = attacker:FindModifierByName("modifier_marci_unleash_lua_fury")
		if fury and fury:HasStacks(MARCI_UNLEASH_STACK_DISPOSE_STUNNED) then
			fury:RemoveStacks(MARCI_UNLEASH_STACK_DISPOSE_STUNNED)
			attacker:AddNewModifier(attacker, self:GetAbility(), "modifier_disarmed", { duration = self.disarm_duration })
			self:StartIntervalThink(-1)
		end
	end
end 