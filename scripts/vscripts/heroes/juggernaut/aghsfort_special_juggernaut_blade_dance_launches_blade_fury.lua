aghsfort_special_juggernaut_blade_dance_launches_blade_fury = class({})
LinkLuaModifier( "modifier_aghsfort_special_juggernaut_blade_dance_launches_blade_fury", "heroes/juggernaut/aghsfort_special_juggernaut_blade_dance_launches_blade_fury", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghsfort_juggernaut_blade_fury_ally", "heroes/juggernaut/aghsfort_special_juggernaut_blade_dance_launches_blade_fury", LUA_MODIFIER_MOTION_NONE )
function aghsfort_special_juggernaut_blade_dance_launches_blade_fury:GetIntrinsicModifierName()
	return "modifier_aghsfort_special_juggernaut_blade_dance_launches_blade_fury"
end

modifier_aghsfort_special_juggernaut_blade_dance_launches_blade_fury = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_aghsfort_special_juggernaut_blade_dance_launches_blade_fury:IsHidden()
	return true
end

function modifier_aghsfort_special_juggernaut_blade_dance_launches_blade_fury:IsPurgeException()
	return false
end

function modifier_aghsfort_special_juggernaut_blade_dance_launches_blade_fury:IsPurgable()
	return false
end

function modifier_aghsfort_special_juggernaut_blade_dance_launches_blade_fury:IsPermanent()
	return true
end




function modifier_aghsfort_special_juggernaut_blade_dance_launches_blade_fury:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_aghsfort_special_juggernaut_blade_dance_launches_blade_fury:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end
function modifier_aghsfort_special_juggernaut_blade_dance_launches_blade_fury:OnAbilityExecuted(params)
	if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "juggernaut_blade_fury" then
        return
    end

    local allyDuration = params.ability:GetSpecialValueFor( "duration" )  
    local friendlies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), params.unit:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_NONE, 0, false )
    print("looking for allies")
    for _,friendly in pairs(friendlies) do
        
        if friendly ~= nil and friendly ~= params.unit then
            print("my friend!")
            if not friendly:HasModifier("modifier_aghsfort_juggernaut_blade_fury_ally") then
                friendly:AddNewModifier(
                self:GetCaster(), -- player source
                params.ability, -- ability source
                "modifier_aghsfort_juggernaut_blade_fury_ally", -- modifier name
                { duration = allyDuration } )-- kv
            else
                friendly:RemoveModifierByName("modifier_aghsfort_juggernaut_blade_fury_ally")
                friendly:AddNewModifier(
                self:GetCaster(), -- player source
                params.ability, -- ability source
                "modifier_aghsfort_juggernaut_blade_fury_ally", -- modifier name
                { duration = allyDuration } )-- kv
            end
        end
    end
end


--------------------------------------------------------------------------------

modifier_aghsfort_juggernaut_blade_fury_ally = class({})

--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_blade_fury_ally:IsPurgable() 		return false end
function modifier_aghsfort_juggernaut_blade_fury_ally:DestroyOnExpire() 	return true end

--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_blade_fury_ally:OnCreated(kv)
	self.radius = self:GetAbility():GetSpecialValueFor( "blade_fury_radius" ) -- special value

    if IsServer() then
        self.attackSpeedMultiplier = self:GetAbility():GetSpecialValueFor( "blade_fury_aspd_multiplier" ) -- special value
        self.dps = self:GetAbility():GetSpecialValueFor( "blade_fury_damage_per_tick" ) -- special value

        self.critChance = 0
        self.critValue = 0

        local bladeDance = self:GetCaster():FindAbilityByName("juggernaut_blade_dance")
        if bladeDance and bladeDance:GetLevel() > 0  then
            self.critChance = bladeDance:GetSpecialValueFor("blade_dance_crit_chance")
            self.critValue = bladeDance:GetSpecialValueFor("blade_dance_crit_mult")
        end
        
        self.damageTable = {
            -- victim = target,
            attacker = self:GetCaster(),
            damage = self.dps,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(), --Optional.
        }

        self.tick = self:GetIntervalTick()

        self:OnIntervalThink()
        self.intervalStarted = true
        self:StartIntervalThink(self.tick)
		print("particles!")
        local nBladeFuryFX = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(nBladeFuryFX, 5, Vector( self.radius, 0, 0))
		self:AddParticle(nBladeFuryFX, false, false, -1, false, false)
		self:GetParent():EmitSoundParams("Hero_Juggernaut.BladeFuryStart", -1, 0.55, -1)
		
    end
	

	
end

--------------------------------------------------------------------------------
function modifier_aghsfort_juggernaut_blade_fury_ally:GetIntervalTick()
    local tick = 1

    if self:GetCaster() and not self:GetCaster():IsNull() then
        tick = self:GetCaster():GetSecondsPerAttack(false)

        if self.attackSpeedMultiplier and self.attackSpeedMultiplier > 0 then
            tick = tick / self.attackSpeedMultiplier
        end
    end

    return tick
end



--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_blade_fury_ally:OnDestroy( kv )
	if IsClient() then return end
	local hParent = self:GetParent()
	
	hParent:StopSound("Hero_Juggernaut.BladeFuryStart")
	hParent:Purge(false, true, false, true, true)
end

--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_blade_fury_ally:OnIntervalThink()
	if IsServer() then
        -- Find enemies in radius
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

                if self.critValue > 0 and self.critChance > 0 and (self.critChance >= 100 or RollPercentage(self.critChance)) then
                    local critDamage = self.dps * self.critValue / 100
                    self.damageTable["damage"] = critDamage
                    
                    SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, enemy, critDamage, nil)
                end
                
                ApplyDamage( self.damageTable )
    
            end
        end

        if self.intervalStarted then
            local newTick = self:GetIntervalTick()

            if newTick and newTick > 0 then
                if self.tick ~= newTick then
                    self.tick = newTick
                    self:StartIntervalThink(newTick)
                end
            else
                self:StartIntervalThink(-1)
                self:Destroy()
            end
        end
    end
	
end

function modifier_aghsfort_juggernaut_blade_fury_ally:CheckState()
 

    local hState = {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,  
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }

    

    return hState
end


