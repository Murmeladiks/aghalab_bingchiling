LinkLuaModifier("modifier_legion_commander_pf_press_the_attack",			"heroes/legion_commander/legion_commander_pf_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_commander_pf_press_the_attack_bkb",		"heroes/legion_commander/legion_commander_pf_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_commander_pf_press_the_attack_blademail", 	"heroes/legion_commander/legion_commander_pf_press_the_attack", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
legion_commander_pf_press_the_attack = class({})

--------------------------------------------------------------------------------

function legion_commander_pf_press_the_attack:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_press_owner.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_press_hero.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_press_the_attack_blademail.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_press_magic_resist.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_blademail.vpcf", context)
end

--------------------------------------------------------------------------------

function legion_commander_pf_press_the_attack:OnSpellStart()
	self:PTA(self:GetCursorTarget())
end

--------------------------------------------------------------------------------

function legion_commander_pf_press_the_attack:PTA(hTarget)
	local hCaster = self:GetCaster()
	local nDuration = self:GetSpecialValueFor("duration")

	local nCastFX = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_press_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControlForward(nCastFX, 0, hCaster:GetForwardVector())
	ParticleManager:ReleaseParticleIndex(nCastFX)

	hTarget:EmitSound("Hero_LegionCommander.PressTheAttack")

	hTarget:AddNewModifier(hCaster, self, "modifier_legion_commander_pf_press_the_attack", {duration = nDuration})	

	if hCaster:HasShard("pathfinder_special_lc_press_blademail") then
		hTarget:AddNewModifier(hCaster, self, "modifier_legion_commander_pf_press_the_attack_blademail", {duration = nDuration})
		hTarget:EmitSound("DOTA_Item.BladeMail.Activate")
	end

	if hCaster:HasShard("pathfinder_special_lc_press_bkb") then
		hTarget:AddNewModifier(hCaster, self, "modifier_legion_commander_pf_press_the_attack_bkb", {duration = nDuration})
	end
end

--------------------------------------------------------------------------------

modifier_legion_commander_pf_press_the_attack = class({})

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_press_the_attack:OnCreated(table)
	local hAbility = self:GetAbility()

	self.nMoveSpeed = hAbility:GetSpecialValueFor("move_speed")
	self.nHealthRegen = hAbility:GetSpecialValueFor("hp_regen")

	if IsClient() then return end
	local hParent = self:GetParent()

	hParent:Purge(false, true, false, true, true)

	local nBuffFX = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_press_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControl(nBuffFX, 1, hParent:GetOrigin())
	ParticleManager:SetParticleControlEnt(nBuffFX, 2, hParent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0, 0, 0), true)
	ParticleManager:SetParticleControl(nBuffFX, 3, hParent:GetAbsOrigin())
	self:AddParticle(nBuffFX, false, false, -1, false, false)
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_press_the_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_press_the_attack:GetModifierMoveSpeedBonus_Percentage()
	return self.nMoveSpeed
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_press_the_attack:GetModifierConstantHealthRegen()
	return self.nHealthRegen
end

--------------------------------------------------------------------------------

modifier_legion_commander_pf_press_the_attack_blademail = class( {} )

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_press_the_attack_blademail:IsHidden() return true end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_press_the_attack_blademail:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_press_the_attack_blademail:OnTakeDamage(event)
	if IsClient() then return end
	
	local hAttacker = event.attacker
	local hTarget = event.unit
	local nDamage = event.original_damage
	local nFlags = event.damage_flags

	if hTarget ~= self:GetParent() or hAttacker:IsBuilding() or hAttacker:IsOther() or hAttacker:GetTeam() == hTarget:GetTeam() then
		return
	end

	if bitand(nFlags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS or bitand(nFlags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return
	end

	ApplyDamage({
		attacker = hTarget,
		victim = hAttacker,
		damage = nDamage * self:GetCaster():FindTalentValue("pathfinder_special_lc_press_blademail", "percent") / 100,
		damage_type = event.damage_type,
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		ability = self:GetAbility()
	})
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_press_the_attack_blademail:GetEffectName()	
	return "particles/units/heroes/hero_legion_commander/legion_commander_press_the_attack_blademail.vpcf"	
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_press_the_attack_blademail:GetStatusEffectName()	
	return "particles/status_fx/status_effect_blademail.vpcf"	
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_press_the_attack_blademail:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------

modifier_legion_commander_pf_press_the_attack_bkb = class({})

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_press_the_attack_bkb:OnCreated()	
	local hCaster = self:GetCaster()

	self.nMagicResist = hCaster:FindTalentValue("pathfinder_special_lc_press_bkb", "magic_resist")
	self.nStatusResist = hCaster:FindTalentValue("pathfinder_special_lc_press_bkb", "status_resist")
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_press_the_attack_bkb:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING								
	}
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_press_the_attack_bkb:GetModifierMagicalResistanceBonus()
	return self.nMagicResist
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_press_the_attack_bkb:GetModifierStatusResistanceStacking()
	return self.nStatusResist
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_press_the_attack_bkb:GetEffectName()		
	return "particles/units/heroes/hero_legion_commander/legion_commander_press_magic_resist.vpcf"	
end