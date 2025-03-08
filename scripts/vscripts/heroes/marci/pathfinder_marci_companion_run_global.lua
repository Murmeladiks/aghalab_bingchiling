pathfinder_marci_companion_run_global = class({})

function pathfinder_marci_companion_run_global:OnUpgrade()
	local upgrade_table = {
		ability_name = "marci_companion_run_pf",
		special_value_name = "max_jump_distance",
		value = self:GetSpecialValueFor("bonus_leap_distance"),
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	}
	CAghanim:AddMinorAbilityUpgrade(self:GetCaster(), upgrade_table)
end