aghsfort_phantom_assassin_stifling_dagger_lua = class({})
LinkLuaModifier( "modifier_aghsfort_phantom_assassin_stifling_dagger_debuff", "abilities/heroes/phantom_assassin/aghsfort_phantom_assassin_stifling_dagger_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghsfort_phantom_assassin_stifling_dagger_attack", "abilities/heroes/phantom_assassin/aghsfort_phantom_assassin_stifling_dagger_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function aghsfort_phantom_assassin_stifling_dagger_lua:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_phantom_assassin/stifling_dagger_multicast_counter_stack.vpcf", context)
end

-- Ability Cast Filter
function aghsfort_phantom_assassin_stifling_dagger_lua:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local result = UnitFilter(
		hTarget,	-- Target Filter
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- Team Filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- Unit Filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- Unit Flag
		self:GetCaster():GetTeamNumber()	-- Team reference
	)
	
	if result ~= UF_SUCCESS then
		return result
	end

	return UF_SUCCESS
end

-- Ability Start
function aghsfort_phantom_assassin_stifling_dagger_lua:OnSpellStart()
	if IsServer() then
		print("dagger")
		local target = self:GetCursorTarget()
		self:CastDaggerOnTarget(target, false)

		--Special Upgrades:
		local multicastDaggerUpgrade = self:GetCaster():FindAbilityByName("aghsfort_phantom_assassin_stifling_dagger_multiple")
		if multicastDaggerUpgrade  then
			local chance_6 = 5
			local chance_4 = 25
			local chance_2 = 75

			local multiCast = 0

			if RollPseudoRandomPercentage(chance_6, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetCaster()) then
				multiCast = 6
			elseif RollPseudoRandomPercentage(chance_4, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_2, self:GetCaster()) then
				multiCast = 4
			elseif RollPseudoRandomPercentage(chance_2, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_3, self:GetCaster()) then
				multiCast = 2
			end
		
			if multiCast > 0 then
				if self.multicastFx then
					ParticleManager:DestroyParticle(self.multicastFx, false)
					self.multicastFx = nil
				end

				self.multicastFx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/stifling_dagger_multicast_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
				ParticleManager:SetParticleControl(self.multicastFx, 1, Vector(0, multiCast, 0))

				for i = 1, multiCast, 1 do
					Timers:CreateTimer(i * 0.25, function ()
						local destroyParticle = false
						if target and not target:IsNull() and target:IsAlive() and not target:IsInvulnerable() then
							self:CastDaggerOnTarget(target, false)
						else
							destroyParticle = true
						end

						if i == multiCast or destroyParticle then
							if self.multicastFx then
								ParticleManager:DestroyParticle(self.multicastFx, false)
								self.multicastFx = nil
							end
						end
					end)
				end
			end
		end
	end
end

function aghsfort_phantom_assassin_stifling_dagger_lua:CastDaggerOnTarget(target, ignoreExtraDaggersTalent)
	-- unit identifier
	local caster = self:GetCaster()

	self.chests = {
		npc_dota_crate = true,
		npc_dota_vase = true,
	}

	if not target or target:IsNull() then
		return
	end

	-- get projectile_data
	self.projectile_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf"

	self.projectile_speed = self:GetSpecialValueFor("dagger_speed")
	self.projectile_vision = 450

	local performExtraDaggers = false
	
	self.extraDaggersLimit = 0
	print("check if we have bounce ability")
	local bouncecastDaggerUpgrade = self:GetCaster():FindAbilityByName("aghsfort_phantom_assassin_stifling_dagger_attack")
	if bouncecastDaggerUpgrade  then
		print("bounce")
		performExtraDaggers = true
		self.extraDaggersLimit = 8
	else
		print("we have no bounce ability")
	end

	local daggerDirection = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()

	-- Create Projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = self.projectile_name,
		iMoveSpeed = self.projectile_speed,
		bReplaceExisting = false,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = self.projectile_vision,				-- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional

		ExtraData = {
			extra_daggers = performExtraDaggers,
			directionX = daggerDirection.x,
			directionY = daggerDirection.y,
			directionZ = daggerDirection.z,
		}
	}

	ProjectileManager:CreateTrackingProjectile(info)
	local coupDeGraceModifier = self:GetCaster():FindModifierByName("modifier_phantom_assassin_coup_de_grace_aghs2024")

    if coupDeGraceModifier then
        coupDeGraceModifier.initDaggerCastDirection = -daggerDirection
    end


	self:PlayEffects1(caster)
	
	if self:GetCaster():FindAbilityByName("special_bonus_unique_phantom_assassin") and self:GetCaster():FindAbilityByName("special_bonus_unique_phantom_assassin"):GetLevel() > 0 and not ignoreExtraDaggersTalent then
		local castRange = self:GetEffectiveCastRange(self:GetCaster():GetAbsOrigin(), nil)

		local enemies = FindUnitsInRadius( 
			self:GetCaster():GetTeamNumber(), 
			self:GetCaster():GetAbsOrigin(), 
			nil, 
			castRange, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
			FIND_ANY_ORDER, 
			false 
		)

		local maxExtraTargets = 2
		local extraTargets = {}

		for _, enemy in pairs(enemies) do
			if enemy and enemy:IsAlive() and enemy ~= target and not self.chests[enemy:GetUnitName()] and not enemy:IsInvulnerable() then
				table.insert(extraTargets, enemy)
			end

			if #extraTargets >= maxExtraTargets then
				break
			end
		end

		--if limit not reached, then allow to focus chests
		if #extraTargets < maxExtraTargets then
			for _, enemy in pairs(enemies) do
				if enemy and enemy:IsAlive() and enemy ~= target and self.chests[enemy:GetUnitName()] and not enemy:IsInvulnerable() then
					table.insert(extraTargets, enemy)
				end
	
				if #extraTargets >= maxExtraTargets then
					break
				end
			end
		end

		for _, extraTarget in pairs(extraTargets) do
			info["Target"] = extraTarget
			ProjectileManager:CreateTrackingProjectile(info)

			
		end
	end
end

function aghsfort_phantom_assassin_stifling_dagger_lua:OnProjectileHit_ExtraData( hTarget, vLocation, extraData )
	local target = hTarget

	if not target or target:IsInvulnerable() or target:TriggerSpellAbsorb( self ) then 
		return 
	end

	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_aghsfort_phantom_assassin_stifling_dagger_attack",
		{}
	)

	local isMainDagger = extraData ~= nil and extraData.extra_daggers

	if isMainDagger then
		self:GetCaster().stiflingDaggerAttack = true
	else
		self:GetCaster().extraStiflingDagger = true
		self:GetCaster().blockCudgel = true
	end

	self:GetCaster():PerformAttack (
		hTarget,
		true,
		true,
		true,
		false,
		false,
		false,
		true
	)

	if isMainDagger then
		self:GetCaster().stiflingDaggerAttack = false
	else
		self:GetCaster().extraStiflingDagger = false
		self:GetCaster().blockCudgel = false
	end

	self:GetCaster():RemoveModifierByName("modifier_aghsfort_phantom_assassin_stifling_dagger_attack")

	hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_aghsfort_phantom_assassin_stifling_dagger_debuff",
		{duration = self:GetSpecialValueFor("duration")}
	)

	self:PlayEffects2( hTarget )

	if extraData and extraData.extra_daggers and extraData.directionX and extraData.directionY and extraData.directionZ then
		local direction = Vector(extraData.directionX, extraData.directionY, extraData.directionZ)
		local origin = hTarget:GetAbsOrigin() - direction * 50

		local length = 600
		local angle = 80

		-- find units
		local enemies = self:FindUnitsInCone_Custom(
			origin,
			direction,
			angle,
			length,
			true,
			self:GetCaster():GetTeamNumber(),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER
		)
		
		local extraTargets = {}

		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if #extraTargets >= self.extraDaggersLimit then
					break
				end

				if enemy and enemy ~= hTarget and enemy:IsAlive() and not enemy:IsInvulnerable() and not self.chests[enemy:GetUnitName()] then
					table.insert(extraTargets, enemy)
				end
			end

			--if limit not reached, then allow to focus chests
			if #extraTargets < self.extraDaggersLimit then
				for _, enemy in pairs(enemies) do
					if #extraTargets >= self.extraDaggersLimit then
						break
					end
	
					if enemy and enemy ~= hTarget and enemy:IsAlive() and not enemy:IsInvulnerable() and self.chests[enemy:GetUnitName()] then
						table.insert(extraTargets, enemy)
					end
				end
			end

			for _, extraTarget in pairs(extraTargets) do
				-- Create Projectile
				local info = {
					Target = extraTarget,
					Source = hTarget,
					Ability = self,	
					EffectName = self.projectile_name,
					iMoveSpeed = self.projectile_speed * 0.75,
					bReplaceExisting = false,                         -- Optional
					bProvidesVision = true,                           -- Optional
					iVisionRadius = self.projectile_vision,				-- Optional
					iVisionTeamNumber = self:GetCaster():GetTeamNumber(),        -- Optional
				}
				
				ProjectileManager:CreateTrackingProjectile(info)

				
			end

			self:PlayEffects1(hTarget)
		end
	end
end
function aghsfort_phantom_assassin_stifling_dagger_lua:FindUnitsInCone_Custom(vStartPos, coneDirection, coneAngle, coneLength, bFrontalCone, teamNumber, nTeamFilter, nTypeFilter, nFlagFilter, nOrderFilter )
    local result = {}

    if coneAngle <= 0 or coneAngle >= 180 or coneLength <= 0 then
        return result
    end

    local halfConeAngle = coneAngle * 0.5
    local radius = coneLength / math.cos(halfConeAngle * math.pi/180)

    local coneCenterFinalPos = vStartPos + coneDirection * radius

    local coneRightFinalPos = RotatePosition(vStartPos, QAngle(0, -halfConeAngle, 0), coneCenterFinalPos)
    local coneLeftFinalPos = RotatePosition(vStartPos, QAngle(0, halfConeAngle, 0), coneCenterFinalPos)



    local enemies = FindUnitsInRadius(
        teamNumber, 
        vStartPos,
        nil,
        radius,
        nTeamFilter, 
        nTypeFilter, 
        nFlagFilter,
        nOrderFilter,
        false
    )

    for _, enemy in pairs(enemies) do
        local enemyDirection = enemy:GetAbsOrigin() - vStartPos
        enemyDirection.z = 0

        local coneRightPosDirection = coneRightFinalPos - vStartPos
        coneRightPosDirection.z = 0

        local coneLeftPosDirection = coneLeftFinalPos - vStartPos
        coneLeftPosDirection.z = 0

        local enemyConeRightDirectionDot = DotProduct(coneRightPosDirection:Normalized(), enemyDirection:Normalized())
        local enemyConeLeftDirectionDot = DotProduct(coneLeftPosDirection:Normalized(), enemyDirection:Normalized())

        local enemyConeRightDirectionAngle = 180 * math.acos( enemyConeRightDirectionDot ) / math.pi
        local enemyConeLeftDirectionAngle = 180 * math.acos( enemyConeLeftDirectionDot ) / math.pi

        if enemyConeLeftDirectionAngle >= 0 and enemyConeLeftDirectionAngle <= coneAngle and enemyConeRightDirectionAngle < coneAngle then
            if bFrontalCone then
                table.insert(result, enemy)
            else
                local enemyDistance = enemyDirection:Length2D()

                if enemyDistance <= coneLength then
                    table.insert(result, enemy)
                else
                    local coneCenterPosDirection = coneCenterFinalPos - vStartPos
                    coneCenterPosDirection.z = 0
    
                    local enemyConeCenterDirectionDot = DotProduct(coneCenterPosDirection:Normalized(), enemyDirection:Normalized())
                    local enemyMaxAllowedDistance = coneLength / enemyConeCenterDirectionDot
    
                    if enemyDistance <= enemyMaxAllowedDistance then
                        table.insert(result, enemy)
                    end
                end
            end
        end
    end

    return result
end


--------------------------------------------------------------------------------
function aghsfort_phantom_assassin_stifling_dagger_lua:PlayEffects1(source)
	-- Get Resources
	local sound_cast = "Hero_PhantomAssassin.Dagger.Cast"

	-- Create Sound
	EmitSoundOn( sound_cast, source )
end

function aghsfort_phantom_assassin_stifling_dagger_lua:PlayEffects2( target )
	-- Get Resources
	local sound_target = "Hero_PhantomAssassin.Dagger.Target"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end

modifier_aghsfort_phantom_assassin_stifling_dagger_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_aghsfort_phantom_assassin_stifling_dagger_debuff:IsHidden()
    return false
end

function modifier_aghsfort_phantom_assassin_stifling_dagger_debuff:IsDebuff()
    return true
end

function modifier_aghsfort_phantom_assassin_stifling_dagger_debuff:IsStunDebuff()
    return false
end

function modifier_aghsfort_phantom_assassin_stifling_dagger_debuff:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_aghsfort_phantom_assassin_stifling_dagger_debuff:OnCreated( kv )
    -- references
    self.move_slow = self:GetAbility():GetSpecialValueFor( "move_slow" )
end

function modifier_aghsfort_phantom_assassin_stifling_dagger_debuff:OnRefresh( kv )
    -- references
    self.move_slow = self:GetAbility():GetSpecialValueFor( "move_slow" )    
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_aghsfort_phantom_assassin_stifling_dagger_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_aghsfort_phantom_assassin_stifling_dagger_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.move_slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_aghsfort_phantom_assassin_stifling_dagger_debuff:GetEffectName()
    return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf"
end

function modifier_aghsfort_phantom_assassin_stifling_dagger_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


modifier_aghsfort_phantom_assassin_stifling_dagger_attack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_aghsfort_phantom_assassin_stifling_dagger_attack:IsHidden()
    return true
end
function modifier_aghsfort_phantom_assassin_stifling_dagger_attack:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_aghsfort_phantom_assassin_stifling_dagger_attack:OnCreated( kv )
    -- references
    self.base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )    
    self.attack_factor = self:GetAbility():GetSpecialValueFor( "attack_factor" )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_aghsfort_phantom_assassin_stifling_dagger_attack:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }

    return funcs
end

function modifier_aghsfort_phantom_assassin_stifling_dagger_attack:GetModifierDamageOutgoing_Percentage( params )
    if IsServer() then
        return self.attack_factor
    end
end

function modifier_aghsfort_phantom_assassin_stifling_dagger_attack:GetModifierPreAttack_BonusDamage( params )
    if IsServer() then
        -- base damage will get reduced, so multiply it by its inverse
        return self.base_damage * 100 / math.abs(100 + self.attack_factor)
    end
end
