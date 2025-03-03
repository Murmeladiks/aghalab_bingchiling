aghsfort_phantom_assassin_coup_de_grace_debuff = class( {} )

LinkLuaModifier( "modifier_aghsfort_phantom_assassin_coup_de_grace_debuff", "heroes/phantom_assassin/aghsfort_phantom_assassin_coup_de_grace_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_strike_damage_reduction", "heroes/phantom_assassin/aghsfort_phantom_assassin_coup_de_grace_debuff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function aghsfort_phantom_assassin_coup_de_grace_debuff:GetIntrinsicModifierName()
	return "modifier_aghsfort_phantom_assassin_coup_de_grace_debuff"
end


modifier_aghsfort_phantom_assassin_coup_de_grace_debuff = class({})
function modifier_aghsfort_phantom_assassin_coup_de_grace_debuff:IsPurgable()	return false end
function modifier_aghsfort_phantom_assassin_coup_de_grace_debuff:IsPermanent()	return true end
function modifier_aghsfort_phantom_assassin_coup_de_grace_debuff:IsHidden()   return true end

function modifier_aghsfort_phantom_assassin_coup_de_grace_debuff:OnCreated(kv)
  
end

function modifier_aghsfort_phantom_assassin_coup_de_grace_debuff:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function  modifier_aghsfort_phantom_assassin_coup_de_grace_debuff:OnAttackLanded( params )
    if not IsServer() then
        return
    end
    
    local attacker = params.attacker

    if attacker ~= self:GetParent() then
        return
    end

    if attacker:IsNull() or not attacker:IsAlive() then
        return
    end

    if params.target:IsNull() or not params.target:IsAlive() or params.target:IsBuilding() or params.target:IsOther() then
        return
    end

    self.ability = self:GetParent():FindAbilityByName("phantom_assassin_coup_de_grace")
	if self.ability and self.ability:GetLevel()> 0 then
		if params.target:HasModifier("modifier_phantom_assassin_mark_of_death") then
			local origin = params.target:GetAbsOrigin()
            local direction = -params.target:GetForwardVector()
            local angel = 80
            local length = 600
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
            for _, enemy in pairs(enemies) do
				

				if enemy and enemy ~= params.target and enemy:IsAlive() and not enemy:IsInvulnerable()  then
					enemy:AddNewModifier(self:GetCaster(),self.ability,"modifier_phantom_strike_damage_reduction",{duration = 15})
				end
			end
		end 
	end
    

end
function modifier_aghsfort_phantom_assassin_coup_de_grace_debuff:FindUnitsInCone_Custom(vStartPos, coneDirection, coneAngle, coneLength, bFrontalCone, teamNumber, nTeamFilter, nTypeFilter, nFlagFilter, nOrderFilter )
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
modifier_phantom_strike_damage_reduction = class({})
function modifier_phantom_strike_damage_reduction:IsPurgable()	return true end
function modifier_phantom_strike_damage_reduction:IsPermanent()	return false end
function modifier_phantom_strike_damage_reduction:IsHidden()   return true end
function modifier_phantom_strike_damage_reduction:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end
function modifier_phantom_strike_damage_reduction:GetModifierDamageOutgoing_Percentage(params)

	return -30
end