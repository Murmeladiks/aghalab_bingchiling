aghsfort_special_juggernaut_healing_ward_damage = class({})
LinkLuaModifier( "modifier_aghsfort_special_juggernaut_healing_ward_damage", "heroes/juggernaut/aghsfort_special_juggernaut_healing_ward_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghsfort_juggernaut_damage_ward", "heroes/juggernaut/aghsfort_special_juggernaut_healing_ward_damage", LUA_MODIFIER_MOTION_NONE )
function aghsfort_special_juggernaut_healing_ward_damage:GetIntrinsicModifierName()
	return "modifier_aghsfort_special_juggernaut_healing_ward_damage"
end

modifier_aghsfort_special_juggernaut_healing_ward_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_aghsfort_special_juggernaut_healing_ward_damage:IsHidden()
	return true
end

function modifier_aghsfort_special_juggernaut_healing_ward_damage:IsPurgeException()
	return false
end

function modifier_aghsfort_special_juggernaut_healing_ward_damage:IsPurgable()
	return false
end

function modifier_aghsfort_special_juggernaut_healing_ward_damage:IsPermanent()
	return true
end




function modifier_aghsfort_special_juggernaut_healing_ward_damage:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_aghsfort_special_juggernaut_healing_ward_damage:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_aghsfort_special_juggernaut_healing_ward_damage:OnAbilityFullyCast(params)
	if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "juggernaut_healing_ward" then
        return
    end
    

    local duration = 25  
    local friendlies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), params.unit:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_BOTH,DOTA_UNIT_TARGET_OTHER, DOTA_UNIT_TARGET_NONE, 0, false )
 
    --print("looking for allies")
    for _,friendly in pairs(friendlies) do
        print(friendly:GetName())
        if friendly and not friendly:IsNull() and friendly:GetName()=="npc_dota_base_additive" then
            
            
                --print("my ward!")

                friendly:AddNewModifier(
                self:GetCaster(), 
                params.ability,
                "modifier_aghsfort_juggernaut_damage_ward", 
                { duration = duration } )
            
        end
    end
end


--------------------------------------------------------------------------------

modifier_aghsfort_juggernaut_damage_ward = class({})

--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_damage_ward:IsPurgable() 		return false end
function modifier_aghsfort_juggernaut_damage_ward:DestroyOnExpire() 	return true end

--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_damage_ward:OnCreated(kv)
	 -- special value

    if IsServer() then
        self.radius = self:GetAbility():GetSpecialValueFor( "healing_ward_aura_radius" )
        self.maxhealth = self:GetCaster():GetMaxHealth()
        self.pct = self:GetAbility():GetSpecialValueFor( "healing_ward_heal_amount" )
        self.damage = self.maxhealth * self.pct / 400
        self.damageTable = {
            -- victim = target,
            attacker = self:GetCaster(),
            damage = self.damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(), --Optional.
        }
        self:StartIntervalThink(0.5)

        self:OnIntervalThink()
        
		
    end
	

	
end


function modifier_aghsfort_juggernaut_damage_ward:OnIntervalThink()
	if IsServer() then
        -- Find enemies in radius
        --print("looking for enemies")
        local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),   -- int, your team number
            self:GetParent():GetOrigin(),   -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            self.radius + 25,   -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,  -- int, flag filter
            FIND_ANY_ORDER,  -- int, order filter
            false   -- bool, can grow cache
        )

        -- damage enemies
        for _,enemy in pairs(enemies) do
            if enemy and not enemy:IsNull() and enemy:IsAlive() and not enemy:IsInvulnerable() then
                self.damageTable.victim = enemy
                ApplyDamage( self.damageTable )
    
            end
        end

        
    end
	
end



