LinkLuaModifier("modifier_dragon_knight_pf_inherited_vigor", "heroes/dragon_knight/dragon_knight_pf_inherited_vigor", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

if dragon_knight_pf_inherited_vigor == nil then
	dragon_knight_pf_inherited_vigor = class({})
end

--------------------------------------------------------------------------------

function dragon_knight_pf_inherited_vigor:GetIntrinsicModifierName()
	return "modifier_dragon_knight_pf_inherited_vigor"
end

--------------------------------------------------------------------------------

if modifier_dragon_knight_pf_inherited_vigor == nil then
	modifier_dragon_knight_pf_inherited_vigor = class({})
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_inherited_vigor:IsHidden() return self:GetParent():PassivesDisabled() end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_inherited_vigor:OnCreated()
	self.nMultiplier = self:GetAbility():GetSpecialValueFor("regen_and_armor_multiplier_during_dragon_form")

	if IsClient() then return end
	self.nGoldArmor = 0
	self.nGoldMagicResist = 0

	self:SetHasCustomTransmitterData(true)

	self:StartIntervalThink(1.5)
end
--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_inherited_vigor:OnIntervalThink()
	local hCaster = self:GetCaster()

	if hCaster:HasAbility("pathfinder_dk_dragon_blood_gold") then
		local nArmorPerGold = hCaster:FindTalentValue("pathfinder_dk_dragon_blood_gold", "gold_per_armor")
		local nMagicResistPerGold = hCaster:FindTalentValue("pathfinder_dk_dragon_blood_gold", "gold_per_magic_resist")

		self.nGoldArmor = math.floor(hCaster:GetGold() / nArmorPerGold)
		self.nGoldMagicResist = math.floor(hCaster:GetGold() / nMagicResistPerGold)

		self:SendBuffRefreshToClients()
	end
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_inherited_vigor:AddCustomTransmitterData()
	return {
		nArmor = self.nGoldArmor,
		nMagicResist = self.nGoldMagicResist
	}
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_inherited_vigor:HandleCustomTransmitterData(data)
	self.nGoldArmor = data.nArmor
	self.nGoldMagicResist = data.nMagicResist
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_inherited_vigor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_inherited_vigor:GetModifierConstantHealthRegen()
	if not self:GetParent():PassivesDisabled() then
		local nValue = self:GetAbility():GetSpecialValueFor("base_health_regen") + self:GetAbility():GetSpecialValueFor("level_mult") * self:GetParent():GetLevel()
		
		if self:GetParent():HasModifier("modifier_dragon_knight_pf_elder_dragon_form") then
			return nValue * self.nMultiplier
		end

		return nValue
	end
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_inherited_vigor:GetModifierPhysicalArmorBonus()
	if not self:GetParent():PassivesDisabled() then
		local nValue = self:GetAbility():GetSpecialValueFor("base_armor") + self:GetAbility():GetSpecialValueFor("level_mult") * self:GetParent():GetLevel()

		if self:GetParent():HasModifier("modifier_dragon_knight_pf_elder_dragon_form") then
			return nValue * self.nMultiplier + self.nGoldArmor
		end

		return nValue + self.nGoldArmor
	end
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_inherited_vigor:GetModifierMagicalResistanceBonus()
	if not self:GetParent():PassivesDisabled() then
		return self.nGoldMagicResist
	end
end