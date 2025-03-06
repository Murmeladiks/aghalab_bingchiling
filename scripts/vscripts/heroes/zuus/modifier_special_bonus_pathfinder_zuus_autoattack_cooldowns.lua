modifier_special_bonus_pathfinder_zuus_autoattack_cooldowns = class({})
function modifier_special_bonus_pathfinder_zuus_autoattack_cooldowns:IsHidden() return true end
function modifier_special_bonus_pathfinder_zuus_autoattack_cooldowns:RemoveOnDeath() return false end
function modifier_special_bonus_pathfinder_zuus_autoattack_cooldowns:IsPurgable() return false end
function modifier_special_bonus_pathfinder_zuus_autoattack_cooldowns:DeclareFunctions()
    if IsClient() then return {} end
    return {
		MODIFIER_EVENT_ON_ATTACK
    }
end

function modifier_special_bonus_pathfinder_zuus_autoattack_cooldowns:OnAttack(kv)
	if kv.attacker ~= self:GetParent() then return end
	local talent = self:GetParent():FindAbilityByName("special_unique_pathfinder_zuus_autoattack_cooldowns")
	if not talent or talent:IsNull() or talent:GetLevel() < 1 then return end

	for i = 0, 5 do
		local ability = self:GetParent():GetAbilityByIndex(i)
		local current_cooldown = ability:GetCooldownTimeRemaining()

		if current_cooldown > 0 then
			current_cooldown = current_cooldown - (ability:GetEffectiveCooldown(ability:GetLevel()) * talent:GetSpecialValueFor("value") / 100)
			ability:EndCooldown()
			if current_cooldown > 0 then ability:StartCooldown(current_cooldown) end
		end
	end
end
