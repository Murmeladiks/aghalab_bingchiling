
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	hChain = thisEntity:FindAbilityByName( "kobold_soul_chain" )
	thisEntity:SetContextThink( "CastChainThink",CastChainThink, 1 )

	
end

function CastChainThink()
	if ( not thisEntity:IsAlive() ) then
        return nil
    end

    if GameRules:IsGamePaused() == true then
        return 1
    end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies == 0 then
        return 1
    end
	local hPoisonSpitTarget = nil

    for _,enemy in pairs( enemies ) do
        if enemy ~= nil and enemy:IsAlive() then
            local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
            if flDist > 0 and flDist <= 3000 then
                hPoisonSpitTarget = enemy
            end
        end
    end
	
	if hPoisonSpitTarget then
        if hChain:IsFullyCastable() then
            return Chain( hPoisonSpitTarget )
        end

        
    end
	return 0.5
end

function Chain( unit  )
	
	ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        TargetIndex = unit:entindex(),
        AbilityIndex = hChain:entindex(),
        Queue = false,
    })
    return 1
end




--------------------------------------------------------------------------------

