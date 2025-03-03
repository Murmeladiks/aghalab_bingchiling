

modifier_juggernaut_blade_fury_duplicate_thinker = class({})

function modifier_juggernaut_blade_fury_duplicate_thinker:IsAura()
    return true
end
function modifier_juggernaut_blade_fury_duplicate_thinker:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10001
end


--------------------------------------------------------------------------------

function modifier_juggernaut_blade_fury_duplicate_thinker:GetModifierAura()
    return "modifier_juggernaut_blade_fury_pull"
end

--------------------------------------------------------------------------------

function modifier_juggernaut_blade_fury_duplicate_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_juggernaut_blade_fury_duplicate_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end


function modifier_juggernaut_blade_fury_duplicate_thinker:GetAuraRadius()
    return self.radius + 25
end
function modifier_juggernaut_blade_fury_duplicate_thinker:OnCreated( kv )
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

        self:PlayEffects()
end

----------------------------------------------------------------------------------------
function modifier_juggernaut_blade_fury_duplicate_thinker:GetIntervalTick()
    local tick = 1

    if self:GetCaster() and not self:GetCaster():IsNull() then
        tick = self:GetCaster():GetSecondsPerAttack(false)

        if self.attackSpeedMultiplier and self.attackSpeedMultiplier > 0 then
            tick = tick / self.attackSpeedMultiplier
        end
    end

    return tick
end
function modifier_juggernaut_blade_fury_duplicate_thinker:OnIntervalThink()
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

                -- Play effects
                self:PlayEffects2( enemy )
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

function modifier_juggernaut_blade_fury_duplicate_thinker:OnDestroy( kv )
    if IsServer() then
        local sound_cast = "Hero_Juggernaut.BladeFuryStart"
        StopSoundOn( sound_cast, self:GetParent() )

        UTIL_Remove(self:GetParent())
    end
end

----------------------------------------------------------------------------------------

function modifier_juggernaut_blade_fury_duplicate_thinker:PlayEffects()
    local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf"
    local sound_cast = "Hero_Juggernaut.BladeFuryStart"

    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( effect_cast, 5, Vector( self.radius, 0, 0 ) )

    self:AddParticle(
        effect_cast,
        false,
        false,
        -1,
        false,
        false
    )

    EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_juggernaut_blade_fury_duplicate_thinker:PlayEffects2( target )
    local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )

    ParticleManager:ReleaseParticleIndex( effect_cast )
end