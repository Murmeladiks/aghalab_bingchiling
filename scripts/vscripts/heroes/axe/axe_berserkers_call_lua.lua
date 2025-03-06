axe_berserkers_call_lua = class({})
LinkLuaModifier( "modifier_axe_berserkers_call_lua", "heroes/axe/modifier_axe_berserkers_call_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_lua_debuff", "heroes/axe/modifier_axe_berserkers_call_lua_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_lua_blink_checker", "heroes/axe/axe_berserkers_call_lua", LUA_MODIFIER_MOTION_NONE )

function axe_berserkers_call_lua:Precache( context )
	PrecacheResource( "particle", "particles/items3_fx/fish_bones_active.vpcf", context )
end


modifier_axe_berserkers_call_lua_blink_checker = class({})

function modifier_axe_berserkers_call_lua_blink_checker:IsDebuff()		return false end
function modifier_axe_berserkers_call_lua_blink_checker:IsHidden()		return true end
function modifier_axe_berserkers_call_lua_blink_checker:RemoveOnDeath()	return false end
function modifier_axe_berserkers_call_lua_blink_checker:IsPurgable()	return false end


function axe_berserkers_call_lua:OnUpgrade()
	if not IsServer() then return end
	local caster = self:GetCaster()

	if caster:HasAbility("pathfinder_axe_special_berseker_call_blink") 
	and not caster:HasModifier("modifier_axe_berserkers_call_lua_blink_checker") then
		caster:AddNewModifier(caster, self, "modifier_axe_berserkers_call_lua_blink_checker", {})
	end
end


function axe_berserkers_call_lua:OnAbilityPhaseInterrupted()
	local caster = self:GetCaster()
	StopSoundOn("Hero_Axe.BerserkersCall.Start", caster)
	
	if IsServer() and caster:HasAbility("pathfinder_axe_special_berseker_call_blink") then
		self:StartCooldown(self:GetCooldown(self:GetLevel()))
	end
end

function axe_berserkers_call_lua:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	EmitSoundOn("Hero_Axe.BerserkersCall.Start", caster)

	if not IsServer() then return end

	if caster:HasAbility("pathfinder_axe_special_berseker_call_blink") then
		if not caster:HasModifier("modifier_axe_berserkers_call_lua_blink_checker") then
			caster:AddNewModifier(caster, self, "modifier_axe_berserkers_call_lua_blink_checker", {})
		end

		local fx = ParticleManager:CreateParticle("particles/econ/events/ti6/blink_dagger_start_ti6_lvl2.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(fx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(fx)

		caster:SetAbsOrigin(self:GetCursorPosition())
		FindClearSpaceForUnit(caster, self:GetOrigin(), true)

		fx = ParticleManager:CreateParticle("particles/econ/events/ti6/blink_dagger_end_ti6_lvl2.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(fx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(fx)
	end

	return true
end

function axe_berserkers_call_lua:GetCastRange(vLocation, hTarget)
	if self:GetCaster():HasModifier("modifier_axe_berserkers_call_lua_blink_checker") then
		return 750 --have to hard code this shit
	end
	return self:GetSpecialValueFor("radius")
end

function axe_berserkers_call_lua:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function axe_berserkers_call_lua:GetBehavior()
	if self:GetCaster():HasModifier("modifier_axe_berserkers_call_lua_blink_checker") then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_AOE
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_AOE
	end	
end

function axe_berserkers_call_lua:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local point = caster:GetOrigin()

	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")	

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		0,
		false
	)

	if caster:HasAbility("pathfinder_axe_special_berseker_call_allies") then		
		local allies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			point,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			9000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		for _,ally in pairs(allies) do 
			self:PlayEffects(ally)
			ally:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_axe_berserkers_call_lua", -- modifier name
				{ duration = duration } -- kv
			)
   			local enemies2 = FindUnitsInRadius(
				caster:GetTeamNumber(),	-- int, your team number
				ally:GetAbsOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
				0,	-- int, order filter
				false	-- bool, can grow cache
			)
			for _,enemy2 in pairs(enemies2) do
				if enemy2.bAbsoluteNoCC ~= true then
					enemy2:AddNewModifier(
						caster, -- player source
						self, -- ability source
						"modifier_axe_berserkers_call_lua_debuff", -- modifier name
						{ duration = duration } -- kv
					)
				end
				if caster:HasAbility("pathfinder_axe_special_berseker_call_battle_hunger") then

					local heal_pct = caster:FindAbilityByName("pathfinder_axe_special_berseker_call_battle_hunger"):GetSpecialValueFor("heal_pct")
					local heal = caster:GetMaxHealth() / 100 * heal_pct

					caster:Heal(heal, self)
					local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
					ParticleManager:ReleaseParticleIndex( nFXIndex )

					local hunger = caster:FindAbilityByName("axe_battle_hunger_lua")
					if hunger and hunger:GetLevel() > 0 then
						hunger:OnSpellStartSingle(enemy2)
					end
				end
			end
		end
	end	

	-- call
	for _,enemy in pairs(enemies) do
		if enemy.bAbsoluteNoCC ~= true then
			enemy:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_axe_berserkers_call_lua_debuff", -- modifier name
				{ duration = duration } -- kv
			)
		end
		
		if caster:HasAbility("pathfinder_axe_special_berseker_call_battle_hunger") then

			local heal_pct = caster:FindAbilityByName("pathfinder_axe_special_berseker_call_battle_hunger"):GetSpecialValueFor("heal_pct")
			local heal = caster:GetMaxHealth() / 100 * heal_pct

			caster:Heal(heal, self)
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local hunger = caster:FindAbilityByName("axe_battle_hunger_lua")
			if hunger and hunger:GetLevel() > 0 then
				hunger:OnSpellStartSingle(enemy)
			end
		end
	end

	-- self buff    
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_axe_berserkers_call_lua", -- modifier name
		{ duration = duration } -- kv
	)

	-- play effects
	if #enemies>0 then
		local fx = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(fx, 1, Vector(radius,radius,radius))
		ParticleManager:ReleaseParticleIndex(fx)
		local sound_cast = "Hero_Axe.Berserkers_Call"
		EmitSoundOn( sound_cast, self:GetCaster() )
	end
	self:PlayEffects(caster)
end

--------------------------------------------------------------------------------
function axe_berserkers_call_lua:PlayEffects(sourceUnit)
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, sourceUnit )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_mouth",
		Vector(0,0,0),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end


modifier_axe_berserkers_call_special_health = class({})

function modifier_axe_berserkers_call_special_health:RemoveOnDeath() 	return false end
function modifier_axe_berserkers_call_special_health:IsPurgable()		return false end

function modifier_axe_berserkers_call_special_health:DeclareFunctions()
	return {		
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_axe_berserkers_call_special_health:OnDeath(params)
	if params.unit == self:GetParent() then
		self:SetStackCount( math.ceil(self:GetStackCount() / 2 ))
	end
end

function modifier_axe_berserkers_call_special_health:GetModifierExtraHealthBonus()	
    return self.health * self:GetStackCount()
end

function modifier_axe_berserkers_call_special_health:OnCreated(table)
	self:SetStackCount(1)
	self.health = self:GetCaster():FindAbilityByName("pathfinder_axe_special_berseker_call_health"):GetLevelSpecialValueFor("stack_health", 1)	
end

function modifier_axe_berserkers_call_special_health:OnRefresh()	
	self:IncrementStackCount()
	self.health = self:GetCaster():FindAbilityByName("pathfinder_axe_special_berseker_call_health"):GetLevelSpecialValueFor("stack_health", 1)	
end

function modifier_axe_berserkers_call_special_health:GetTexture()	
	return "axe_berserkers_call"
end

function modifier_axe_berserkers_call_special_health:GetModifierModelScale()
	local max_scale = 3 -- Set your max scale limit
	return math.min(self:GetStackCount() * 2, max_scale)
end

function modifier_axe_berserkers_call_special_health:GetModifierTurnRate_Percentage()	
	return self:GetStackCount() * -0.005
end
