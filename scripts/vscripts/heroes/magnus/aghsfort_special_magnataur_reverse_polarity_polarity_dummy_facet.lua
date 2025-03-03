aghsfort_special_magnataur_reverse_polarity_polarity_dummy_facet = class({})

function aghsfort_special_magnataur_reverse_polarity_polarity_dummy_facet:Spawn()
	if IsClient() then return end
	local hAbility = self:GetCaster():FindAbilityByName("magnataur_pf_reverse_polarity")
	hAbility:SetHidden(false)
	hAbility:SetLevel(self:GetCaster():FindAbilityByName("magnataur_pf_reverse_polarity_polarity"):GetLevel())
end
