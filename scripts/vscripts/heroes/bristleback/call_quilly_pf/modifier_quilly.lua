modifier_quilly = class({})

--------------------------------------------------------------------------------

function modifier_quilly:IsHidden() 		return true end
function modifier_quilly:IsPurgable() 		return false end

--------------------------------------------------------------------------------

function modifier_quilly:OnDestroy()
	if IsClient() then return end
	
	-- and the swap mechanic
	self:GetCaster():SwapAbilities("bristleback_betray_quilly_pf", "bristleback_call_quilly_pf", false, true)
end

--------------------------------------------------------------------------------

function modifier_quilly:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST}
end

--------------------------------------------------------------------------------

function modifier_quilly:OnAbilityFullyCast(kv)
	if IsClient() or kv.unit ~= self:GetParent():GetOwnerEntity() then return end

	local ability = kv.ability
	local unit = kv.target
	local parent = self:GetParent()
	if not ability or ability:IsNull() then return end

	if ability:GetAbilityName() == "bristleback_viscous_nasal_goo_pf" then
		if unit and not unit:IsNull() and unit:GetRangeToUnit(parent) <= ability:GetEffectiveCastRange(parent:GetAbsOrigin(), parent) then
			ability:ViscousNasalGoo(unit, true, false, parent)
		else
			local enemies = FindUnitsInRadius(
				parent:GetTeamNumber(),
				parent:GetAbsOrigin(),
				nil,
				ability:GetEffectiveCastRange(parent:GetAbsOrigin(), parent),
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)
			if #enemies > 0 then
				ability:ViscousNasalGoo(enemies[1], true, false, parent)
			end
		end
	end
	if ability:GetAbilityName() == "bristleback_quill_spray_pf" then
		ability:SpawnQuills(parent:GetAbsOrigin(), parent:GetForwardVector(), false, parent)
	end
end