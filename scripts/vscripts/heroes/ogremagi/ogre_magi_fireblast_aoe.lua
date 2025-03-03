ogre_magi_fireblast_aoe = class( {} )

LinkLuaModifier( "modifier_ogre_magi_fireblast_aoe", "heroes/ogremagi/ogre_magi_fireblast_aoe", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ogre_magi_fireblast_aoe:GetIntrinsicModifierName()
	return "modifier_ogre_magi_fireblast_aoe"
end

modifier_ogre_magi_fireblast_aoe = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_fireblast_aoe:IsHidden()
	return true
end

function modifier_ogre_magi_fireblast_aoe:IsPurgeException()
	return false
end

function modifier_ogre_magi_fireblast_aoe:IsPurgable()
	return false
end

function modifier_ogre_magi_fireblast_aoe:IsPermanent()
	return true
end
function modifier_ogre_magi_fireblast_aoe:OnCreated(kv)
    if IsServer() then
		
    end
end
function modifier_ogre_magi_fireblast_aoe:DeclareFunctions()
	local funcs = {
       
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end




function modifier_ogre_magi_fireblast_aoe:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "ogre_magi_fireblast" then
        return
    end

    self.ogre_magi_fireblast = self:GetParent():FindAbilityByName("ogre_magi_fireblast")
    
	if params.target then
		local enemies = FindUnitsInRadius(
                            self:GetParent():GetTeamNumber(),	-- int, your team number
                            params.target:GetAbsOrigin(),	-- point, center point
                            nil,	-- handle, cacheUnit. (not known)
                            300,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                            DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                            FIND_CLOSEST,	-- int, order filter
                            false
                        )
						for _,enemy in pairs( enemies ) do
							if enemy ~= nil and not enemy:IsMagicImmune() then
								self:GetParent():SetCursorCastTarget(enemy)
								self.ogre_magi_fireblast:OnSpellStart()
							end
						end                
		
		
		

	end
        
end
