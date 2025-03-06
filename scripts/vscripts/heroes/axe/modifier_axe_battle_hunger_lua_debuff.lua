modifier_axe_battle_hunger_lua_debuff = class({})

function modifier_axe_battle_hunger_lua_debuff:IsHidden() 		return false end
function modifier_axe_battle_hunger_lua_debuff:IsDebuff() 		return true end
function modifier_axe_battle_hunger_lua_debuff:IsStunDebuff() 	return false end
function modifier_axe_battle_hunger_lua_debuff:IsPurgable() 	return true end

function modifier_axe_battle_hunger_lua_debuff:OnCreated( kv )
	-- references
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()

	self.slow = self.ability:GetSpecialValueFor( "slow" )
	local damage = self.ability:GetSpecialValueFor( "damage_per_second" )
	local interval = 1

	if not IsServer() then return end

	self.damage_table = {
		victim = self.parent,
		attacker = self.caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self.ability,
	}

	self:StartIntervalThink(interval)		
	self:OnIntervalThink()
	self:OnRefresh()			
end

function modifier_axe_battle_hunger_lua_debuff:OnRefresh( kv )
	self.slow = self.ability:GetSpecialValueFor( "slow" )
	local damage = self.ability:GetSpecialValueFor( "damage_per_second" )
	
	if not IsServer() then return end

	self.damage_table.damage = damage * (self:GetStackCount() + 1)		

	if self:GetStackCount() < self.ability:GetSpecialValueFor("max_stacks") then
		self:IncrementStackCount()
	end
end

function modifier_axe_battle_hunger_lua_debuff:OnDestroy( kv )
	if not IsServer() then return end
	-- decrement buff stack
	local modifier = self.caster:FindModifierByName( "modifier_axe_battle_hunger_lua" )
	if modifier then
		modifier:DecrementStackCount()
	end
end

function modifier_axe_battle_hunger_lua_debuff:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_axe_battle_hunger_lua_debuff:OnDeath( params )
	if not IsServer() then return end
	if params.attacker ~= self.parent then return end

	self:Destroy()
end

function modifier_axe_battle_hunger_lua_debuff:OnTakeDamage( params )
	if not IsServer() then return end

	if params.attacker ~= self.caster then return end
	if params.unit ~= self.parent then return end
	if params.inflictor ~= self.ability then return end
	if not params.attacker:HasAbility("pathfinder_axe_special_battle_hunger_lifesteal") then return end		

	local special = params.attacker:FindAbilityByName("pathfinder_axe_special_battle_hunger_lifesteal")
	local amount = params.damage / 100 * special:GetLevelSpecialValueFor("percent", 1)
	local radius = special:GetLevelSpecialValueFor("radius", 1)
	local heroes = FindRadius(self.parent, radius, true)
	for _,hero in pairs(heroes) do
		hero:Heal(amount, self.ability)			

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
		ParticleManager:SetParticleControl(nFXIndex, 0, hero:GetAbsOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 1, hero:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail_scepter.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(effect, 0, hero:GetAbsOrigin())
		ParticleManager:SetParticleControl(effect, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(effect, 60, Vector(0,255,0))
		ParticleManager:SetParticleControl(effect, 61, Vector(1,1,1))
		ParticleManager:ReleaseParticleIndex( effect )
	end
end

function modifier_axe_battle_hunger_lua_debuff:OnAttackLanded( params )
	if not IsServer() then return end
	if params.attacker == self.parent then 
		if params.target == self.caster then 
			if params.target:HasAbility("pathfinder_axe_special_battle_hunger_refresh") then
				self:IncrementStackCount()
				self:ForceRefresh()
			end
		end

	elseif params.target == self.parent then
		local cdr_ability = self.caster:FindAbilityByName("pathfinder_axe_special_battle_hunger_culling_cdr")
		local cdr_value = cdr_ability and cdr_ability:GetLevelSpecialValueFor("cdr", 1) or 0
		for i=0, 10 do
			local ability = self.caster:GetAbilityByIndex(i)
			if ability and ability:GetLevel() > 0 and not ability:IsCooldownReady() and cdr_ability then					
				local current_cd = ability:GetCooldownTimeRemaining()
				local new_cd = current_cd - cdr_value

				ability:EndCooldown()
				ability:StartCooldown(new_cd > 0 and new_cd or 0)
			end
		end
	end
end

function modifier_axe_battle_hunger_lua_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_axe_battle_hunger_lua_debuff:OnIntervalThink()
	ApplyDamage( self.damage_table )	
end

function modifier_axe_battle_hunger_lua_debuff:GetEffectName()
	return "particles/units/heroes/hero_axe/axe_battle_hunger.vpcf"
end

function modifier_axe_battle_hunger_lua_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
