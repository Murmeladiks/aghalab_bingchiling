LinkLuaModifier("modifier_bristleback_shock_and_awe_slow", "heroes/bristleback/warpath_pf/modifier_bristleback_shock_and_awe_slow", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

modifier_bristleback_shock_and_awe = class({})

--------------------------------------------------------------------------------

function modifier_bristleback_shock_and_awe:GetTexture()
	return "bristleback_warpath"
end

--------------------------------------------------------------------------------

function modifier_bristleback_shock_and_awe:RemoveOnDeath() return false end
function modifier_bristleback_shock_and_awe:IsPurgable() 	return false end

--------------------------------------------------------------------------------

function modifier_bristleback_shock_and_awe:DeclareFunctions()
	if IsClient() then return end
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}
end

--------------------------------------------------------------------------------

function modifier_bristleback_shock_and_awe:OnCreated()
	if IsClient() then return end
	self:GetParent():EmitSound("Bristleback.WarpathBuff")
end

--------------------------------------------------------------------------------

function modifier_bristleback_shock_and_awe:OnDestroy()
	if not IsServer() then return end
	local parent = self:GetParent()
	local warpath_mod = parent:FindModifierByName("modifier_bristleback_warpath_pf")

	if warpath_mod then
		warpath_mod:StartIntervalThink(self:GetAbility():GetSpecialValueFor("pathfinder_bristleback_warpath_shock_and_awe", "delay"))
	end
end

--------------------------------------------------------------------------------

function modifier_bristleback_shock_and_awe:GetModifierProcAttack_BonusDamage_Physical(event)
	local parent = self:GetParent()
	local target = event.target

	local warpath_stacks = parent:GetModifierStackCount("modifier_bristleback_warpath_pf", parent)
	local shock_and_awe = parent:FindAbilityByName("pathfinder_bristleback_warpath_shock_and_awe")

	if not shock_and_awe or shock_and_awe:IsNull() or not target or target:IsNull() then return end

	local aoe_radius = shock_and_awe:GetSpecialValueFor("effect_radius_per_stack") * warpath_stacks
	
	local enemies = FindUnitsInRadius(
		parent:GetTeamNumber(),
		target:GetAbsOrigin(),
		nil,
		aoe_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false
	)

	self:ReduceCooldown(#enemies * shock_and_awe:GetSpecialValueFor("cooldown_reduction"))

	for _, unit in pairs(enemies) do
		if unit ~= target then
			ApplyDamage({
				victim = unit,
				attacker = parent,
				damage = parent:GetAverageTrueAttackDamage(unit),
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
			})
		end

		if not unit:IsMagicImmune() then
			unit:AddNewModifier(parent, self:GetAbility(), "modifier_bristleback_shock_and_awe_slow", {duration = (1 - unit:GetStatusResistance()) * shock_and_awe:GetSpecialValueFor("slow_duration")})
		end
	end

	EmitSoundOn("OgreTank.GroundSmash.Lesser", target )

	local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN, parent )
	ParticleManager:SetParticleControl( nFXIndex, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( aoe_radius, aoe_radius, aoe_radius ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	self:Destroy()

	if #enemies == 1 then
		local big_damage = shock_and_awe:GetSpecialValueFor("pct_max_health_per_stack_on_single") / 100 * warpath_stacks * parent:GetMaxHealth()
		--the heal was big_damage + event.damage, which is 100% lifesteal on 1s cooldown, so i removed the event.damage addition
		parent:HealWithParams(big_damage, self:GetAbility(), false, true, parent, false)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, big_damage, nil)

		local effect_cast = ParticleManager:CreateParticle( "particles/items2_fx/magic_stick.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(effect_cast, 0, parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(effect_cast, 1, Vector(warpath_stacks / self:GetAbility():GetSpecialValueFor("max_stacks"), 0, 0))
		ParticleManager:ReleaseParticleIndex(effect_cast)

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemies[1], PATTACH_POINT_FOLLOW, "attach_hitloc", enemies[1]:GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, enemies[1]:GetOrigin() )
		ParticleManager:SetParticleControlForward( nFXIndex, 1, -parent:GetForwardVector() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemies[1], PATTACH_ABSORIGIN_FOLLOW, nil, enemies[1]:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Dungeon.BloodSplatterImpact.Lesser", enemies[1] )

		return big_damage
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_bristleback_shock_and_awe:ReduceCooldown(reduction)
	local parent = self:GetParent()

	for i = 0,16 do
		local ability = parent:GetAbilityByIndex(i)
		local item = parent:GetItemInSlot(i)

		if ability and not ability:IsNull() and ability:GetCooldownTimeRemaining() > 0 then
			local cooldown = ability:GetCooldownTimeRemaining()
			ability:EndCooldown()
			ability:StartCooldown(cooldown - reduction)
		end		

		if item and not item:IsNull() and item:GetCooldownTimeRemaining() > 0 then
			local cooldown = item:GetCooldownTimeRemaining()
			item:EndCooldown()
			item:StartCooldown(cooldown - reduction)
		end
	end
end

--------------------------------------------------------------------------------

function modifier_bristleback_shock_and_awe:GetEffectName()
	return "particles/units/heroes/hero_bristleback/bristleback_warpath_empower.vpcf"
end