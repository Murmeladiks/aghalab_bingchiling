modifier_bristleback_viscous_nasal_goo_pf_intrinsic = class({})

function modifier_bristleback_viscous_nasal_goo_pf_intrinsic:IsHidden() return true end
function modifier_bristleback_viscous_nasal_goo_pf_intrinsic:IsPurgable() return false end
function modifier_bristleback_viscous_nasal_goo_pf_intrinsic:IsDebuff() return false end
function modifier_bristleback_viscous_nasal_goo_pf_intrinsic:RemoveOnDeath() return false end

function modifier_bristleback_viscous_nasal_goo_pf_intrinsic:DeclareFunctions()
	if IsClient() then return {} end
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_bristleback_viscous_nasal_goo_pf_intrinsic:OnAttackLanded(kv)
	if kv.attacker ~= self:GetParent() then return end
	self:DirtyBrawlerInteraction()
end

function modifier_bristleback_viscous_nasal_goo_pf_intrinsic:DirtyBrawlerInteraction()
	local dirty_brawler = self:GetParent():FindAbilityByName("pathfinder_bristleback_viscous_nasal_goo_dirty_brawler")
	if not dirty_brawler or not dirty_brawler:IsTrained() then return end

	if not RollPercentage(dirty_brawler:GetSpecialValueFor("proc_chance")) or self:GetParent():HasModifier("modifier_bristleback_dirty_brawler_cooldown") then return end
	self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_bristleback_dirty_brawler_cooldown", {duration = dirty_brawler:GetSpecialValueFor("internal_cooldown")})

	local attack_target = self:GetParent():GetAttackTarget()
	if attack_target == nil or attack_target:IsNull() or not attack_target:IsAlive() then
		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			self:GetAbility():GetCastRange(self:GetParent():GetAbsOrigin(), self:GetParent()),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)
		if #enemies > 0 then attack_target = enemies[1] end
	end

	if attack_target and not attack_target:IsNull() then
		self:GetAbility():ViscousNasalGoo(attack_target)
	end
end


------
LinkLuaModifier("modifier_bristleback_dirty_brawler_cooldown", "heroes/bristleback/viscous_nasal_goo_pf/modifier_bristleback_viscous_nasal_goo_pf_intrinsic", LUA_MODIFIER_MOTION_NONE)
modifier_bristleback_dirty_brawler_cooldown = class({})

function modifier_bristleback_dirty_brawler_cooldown:IsHidden() return true end
function modifier_bristleback_dirty_brawler_cooldown:IsPurgable() return false end
function modifier_bristleback_dirty_brawler_cooldown:IsDebuff() return false end
function modifier_bristleback_dirty_brawler_cooldown:RemoveOnDeath() return false end
