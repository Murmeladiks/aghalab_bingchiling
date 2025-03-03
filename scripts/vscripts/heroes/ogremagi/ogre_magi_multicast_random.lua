ogre_magi_multicast_random = class( {} )

LinkLuaModifier( "modifier_ogre_magi_multicast_random", "heroes/ogremagi/ogre_magi_multicast_random", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function ogre_magi_multicast_random:GetIntrinsicModifierName()
	return "modifier_ogre_magi_multicast_random"
end

modifier_ogre_magi_multicast_random = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_multicast_random:IsHidden()
	return true
end

function modifier_ogre_magi_multicast_random:IsPurgeException()
	return false
end

function modifier_ogre_magi_multicast_random:IsPurgable()
	return false
end

function modifier_ogre_magi_multicast_random:IsPermanent()
	return true
end
function modifier_ogre_magi_multicast_random:OnCreated(kv)
    if IsServer() then
		self:StartIntervalThink(1)
    end
end

function modifier_ogre_magi_multicast_random:OnRefresh( kv )
	-- references
	
end

function modifier_ogre_magi_multicast_random:OnRemoved()
end

function modifier_ogre_magi_multicast_random:OnDestroy()
end



function modifier_ogre_magi_multicast_random:OnIntervalThink()
    if not IsServer() then
        return
    end
	local ogre_magi_multicast = self:GetParent():FindAbilityByName("ogre_magi_multicast")
	if ogre_magi_multicast and ogre_magi_multicast:GetLevel()>0 then
        local chance = 15

        if RandomInt(1,100) > chance then return end        
        local radius = 900

        local abilities = {}
        for i=0,10 do
            local ability = self:GetParent():GetAbilityByIndex(i)
            if ability and bitand(ability:GetBehaviorInt(),DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 and bitand(ability:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_TEAM_ENEMY ) ~= 0 then           
				if ability:GetAbilityName() ~= "ogre_magi_unrefined_fireblast" then
                    table.insert(abilities, ability)
                end
            end
        end
        for i=0,6 do
            local item = self:GetParent():GetItemInSlot(i)
            if item and bitand(item:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_TEAM_ENEMY ) ~= 0  and bitand(item:GetBehaviorInt(),DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 then   
                table.insert(abilities, item)
            end
        end
        local chosen = abilities[RandomInt(1, #abilities)]
        
        if chosen then
            local enemies = FindUnitsInRadius(
				self:GetParent():GetTeamNumber(),	-- int, your team number
				self:GetParent():GetAbsOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				FIND_CLOSEST,	-- int, order filter
				false
			)
            local chosen_enemy = enemies[RandomInt(1,#enemies)]
            if chosen_enemy then
                self:GetParent():SetCursorCastTarget(chosen_enemy)
                chosen:OnSpellStart()               
            end
        end
	end
    
end

