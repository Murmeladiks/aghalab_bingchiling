modifier_marci_grapple_pf_mass_cleave = class({})

function modifier_marci_grapple_pf_mass_cleave:IsHidden() return false end
function modifier_marci_grapple_pf_mass_cleave:IsPurgable() return false end


function modifier_marci_grapple_pf_mass_cleave:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_marci_grapple_pf_mass_cleave:OnCreated()
	self:OnRefresh()
end

function modifier_marci_grapple_pf_mass_cleave:OnRefresh()
	if IsClient() then return end

	self.ability = self:GetAbility()
	
	self.cleave = self.ability:GetSpecialValueFor("cleave") * 0.01
	self.cleave_radius = self.ability:GetSpecialValueFor("cleave_radius")
	self.cleave_radius_end = self.ability:GetSpecialValueFor("cleave_radius_end")
	self.cleave_distance = self.ability:GetSpecialValueFor("cleave_distance")

	local attack_count = self.ability:GetSpecialValueFor("cleave_attacks")
	self:SetStackCount(attack_count)
end

function modifier_marci_grapple_pf_mass_cleave:GetModifierProcAttack_Feedback(params)
	local attacker = self:GetParent()
	local target = params.target
	local damage = params.original_damage * self.cleave
	local fx_name = "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf"

	DoCleaveAttack(attacker, target, self.ability, damage, self.cleave_radius, self.cleave_radius_end, self.cleave_distance, fx_name)

	self:DecrementStackCount()

	if self:GetStackCount() <= 0 then
		self:Destroy()
	end

end
