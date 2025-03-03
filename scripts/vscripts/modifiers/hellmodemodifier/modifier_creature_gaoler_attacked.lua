modifier_creature_gaoler_attacked = class({})

--------------------------------------------------------------------------------

function modifier_creature_gaoler_attacked:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_creature_gaoler_attacked:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_creature_gaoler_attacked:OnCreated( kv )
	
	if IsServer() then
        self:StartIntervalThink(6)
        self.cancasthook = true
	end
end

--------------------------------------------------------------------------------

function modifier_creature_gaoler_attacked:OnRefresh( kv )
	if IsServer() then
		
	end
end
function modifier_creature_gaoler_attacked:OnIntervalThink()
        self.cancasthook = true  
end
--------------------------------------------------------------------------------
function modifier_creature_gaoler_attacked:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end

function modifier_creature_gaoler_attacked:OnTakeDamage( params )
	if IsServer() then
		if params.attacker == self:GetParent()  then
            return
        end
       if self.cancasthook then
            if params.unit == self:GetParent() then
                if params.damage_type == 2 then
                    print("im hurt by magical dmg")
                    self.aghsfort_walrus_pudge_harpoon = self:GetParent():FindAbilityByName("aghsfort_walrus_pudge_harpoon")
                    print("self.aghsfort_walrus_pudge_harpoon:GetLevel()")
                    print(self.aghsfort_walrus_pudge_harpoon:GetLevel())
                    if self.aghsfort_walrus_pudge_harpoon then
                        local Range = 2000
                        local enemies = FindUnitsInRadius(
                                self:GetParent():GetTeamNumber(),	-- int, your team number
                                self:GetParent():GetAbsOrigin(),	-- point, center point
                                nil,	-- handle, cacheUnit. (not known)
                                Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                                DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                FIND_CLOSEST,	-- int, order filter
                                false
                            )
                            if enemies[1] and not enemies[1]:IsNull() and enemies[1]:IsAlive() and not enemies[1]:IsInvulnerable() then
                                print("enemy!")
                                local pos = enemies[1]:GetAbsOrigin()
                                self:GetParent():SetCursorPosition(pos)  
                                self.aghsfort_walrus_pudge_harpoon:OnSpellStart()
                                self.cancasthook = false
                            end
                    end
                end
            end
        end


       
	end
end

--------------------------------------------------------------------------------
function  modifier_creature_gaoler_attacked:OnAbilityExecuted(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "gaoler_shock" then
        
        self.storm_spirit_electric_vortex = self:GetParent():FindAbilityByName("storm_spirit_electric_vortex")
        local nLevel = GameRules.Aghanim:GetAscensionLevel()		
		self.storm_spirit_electric_vortex:SetLevel(nLevel)
 
        if self.storm_spirit_electric_vortex then
        
                        local Range = 600
                    
                        local enemies = FindUnitsInRadius(
                            self:GetParent():GetTeamNumber(),	-- int, your team number
                            self:GetParent():GetAbsOrigin(),	-- point, center point
                            nil,	-- handle, cacheUnit. (not known)
                            Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                            DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                            FIND_CLOSEST,	-- int, order filter
                            false
                        )
                        if enemies[1] and not enemies[1]:IsNull() and enemies[1]:IsAlive() and not enemies[1]:IsInvulnerable() then
                            self:GetParent():SetCursorCastTarget(enemies[1])
                            self.storm_spirit_electric_vortex:OnSpellStart()
                        end
      
        end
    end
     
end
