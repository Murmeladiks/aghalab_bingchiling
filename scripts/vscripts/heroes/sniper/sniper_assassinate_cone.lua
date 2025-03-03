sniper_assassinate_cone = class( {} )

LinkLuaModifier( "modifier_sniper_assassinate_cone", "heroes/sniper/sniper_assassinate_cone", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_shrapnel_lua_thinker", "heroes/sniper/sniper_assassinate_cone", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_shrapnel_lua", "heroes/sniper/sniper_assassinate_cone", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function sniper_assassinate_cone:GetIntrinsicModifierName()
	return "modifier_sniper_assassinate_cone"
end
function sniper_assassinate_cone:OnSpellStart()
	if IsServer() then
	
   
	local maintarget = self:GetCursorTarget()
	local origin = maintarget:GetAbsOrigin()
	local direction = -maintarget:GetForwardVector()
	local angle = 80
	local length = 900
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
	
	-- local point = self:GetCursorPosition()

	-- load data
	local projectile_name = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf"
	local projectile_speed = 2000
	local extraTargets = {}
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if enemy and enemy ~= maintarget and enemy:IsAlive() and not enemy:IsInvulnerable()  then
				table.insert(extraTargets, enemy)
			end
		end


		for _, extraTarget in pairs(extraTargets) do
			-- Create Projectile
			local info = {
				Target = extraTarget,
				Source = maintarget,
				Ability = self,	
				EffectName = projectile_name,
				iMoveSpeed = projectile_speed,
				bReplaceExisting = false,                         -- Optional
				bProvidesVision = true,                           -- Optional
				iVisionRadius = 200,				-- Optional
				iVisionTeamNumber = self:GetCaster():GetTeamNumber(),        -- Optional
			}
			
			ProjectileManager:CreateTrackingProjectile(info)
			local sound_cast = "Ability.Assassinate"
			EmitSoundOn( sound_cast, maintarget )
			-- local sound_target = "Hero_Sniper.AssassinateProjectile"
			-- EmitSoundOn( sound_cast, target )
			
		end

		
	end

end
end
function sniper_assassinate_cone:OnProjectileHit_ExtraData( target, location, extradata )
	if IsServer() then
		-- cancel if gone
		if (not target) or target:IsInvulnerable() or target:IsOutOfGame() or target:TriggerSpellAbsorb( self ) then
			return
		end
		-- apply damage
		local damage = 500
		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)

		
		

		-- effects
		local sound_cast = "Hero_Sniper.AssassinateDamage"
		EmitSoundOn( sound_cast, target )
	end
end
function sniper_assassinate_cone:FindUnitsInCone_Custom(vStartPos, coneDirection, coneAngle, coneLength, bFrontalCone, teamNumber, nTeamFilter, nTypeFilter, nFlagFilter, nOrderFilter )
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
modifier_sniper_assassinate_cone = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_assassinate_cone:IsHidden()
	return true
end

function modifier_sniper_assassinate_cone:IsPurgeException()
	return false
end

function modifier_sniper_assassinate_cone:IsPurgable()
	return false
end

function modifier_sniper_assassinate_cone:IsPermanent()
	return true
end



function modifier_sniper_assassinate_cone:OnCreated(kv)
    if IsServer() then
	
    end
end
function modifier_sniper_assassinate_cone:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_sniper_assassinate_cone:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "sniper_assassinate" then
        return
    end
    local unit = self:GetParent()
	unit:SetCursorCastTarget(params.target)
	self:GetAbility():OnSpellStart()

    


   
end

