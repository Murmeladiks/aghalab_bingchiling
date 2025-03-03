aghsfort_special_magnataur_reverse_polarity_polarity_dummy = class({})

function aghsfort_special_magnataur_reverse_polarity_polarity_dummy:Spawn()
	if IsClient() then return end
	local hAbility = self:GetCaster():FindAbilityByName("magnataur_pf_reverse_polarity_polarity")
	hAbility:SetHidden(false)
	hAbility:SetLevel(self:GetCaster():FindAbilityByName("magnataur_pf_reverse_polarity"):GetLevel())
end
