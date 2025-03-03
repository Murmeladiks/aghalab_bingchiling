aaghsfort_special_juggernaut_zen_ward = class({})
LinkLuaModifier( "modifier_aghsfort_special_juggernaut_zen_ward", "heroes/juggernaut/aaghsfort_special_juggernaut_zen_ward", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghsfort_juggernaut_blade_fury_manaward", "heroes/juggernaut/aaghsfort_special_juggernaut_zen_ward", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghsfort_juggernaut_damage_manaward", "heroes/juggernaut/aaghsfort_special_juggernaut_zen_ward", LUA_MODIFIER_MOTION_NONE )

function aaghsfort_special_juggernaut_zen_ward:GetIntrinsicModifierName()
	return "modifier_aghsfort_special_juggernaut_zen_ward"
end

modifier_aghsfort_special_juggernaut_zen_ward = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_aghsfort_special_juggernaut_zen_ward:IsHidden()
	return true
end

function modifier_aghsfort_special_juggernaut_zen_ward:IsPurgeException()
	return false
end

function modifier_aghsfort_special_juggernaut_zen_ward:IsPurgable()
	return false
end

function modifier_aghsfort_special_juggernaut_zen_ward:IsPermanent()
	return true
end




function modifier_aghsfort_special_juggernaut_zen_ward:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_aghsfort_special_juggernaut_zen_ward:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_aghsfort_special_juggernaut_zen_ward:OnAbilityFullyCast(params)
	if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "juggernaut_healing_ward" then
        return
    end

    local mana_ward_name = "juggernaut_zen_ward"
    local targetPoint = params.unit:GetCursorPosition()
    local caster = self:GetCaster()
    mana_ward = CreateUnitByName(mana_ward_name, targetPoint, true, caster, caster, caster:GetTeamNumber())
	local vRandomOffset = Vector(RandomInt(-300, 300), RandomInt(-300, 300), 0)
	local vSpawnPoint = targetPoint + vRandomOffset
	FindClearSpaceForUnit(mana_ward, vSpawnPoint, true)
	mana_ward:SetOwner(caster)	
    mana_ward:AddAbility("juggernaut_mana_ward_passive"):SetLevel(1)
	mana_ward:AddNewModifier(caster, self, "modifier_kill", {duration = 25})	
	mana_ward:SetControllableByPlayer(caster:GetPlayerID(), true)	
    mana_ward:SetContextThink(DoUniqueString(self:GetName()), function()        
            mana_ward:MoveToNPC(caster)                  
            return nil
            end, FrameTime())
    if caster:HasAbility("aghsfort_special_juggernaut_healing_ward_blade_fury") then
        self.juggernaut_blade_fury = params.unit:FindAbilityByName("juggernaut_blade_fury")
        local allyDuration = self.juggernaut_blade_fury:GetSpecialValueFor( "duration" )  
        if self.juggernaut_blade_fury:GetLevel()>0 then
            mana_ward:AddNewModifier(
                self:GetCaster(), -- player source
                self.juggernaut_blade_fury, -- ability source
                "modifier_aghsfort_juggernaut_blade_fury_manaward", -- modifier name
                { duration = allyDuration } )
        end
    end
    if caster:HasAbility("aghsfort_special_juggernaut_healing_ward_damage") then
        mana_ward:AddNewModifier(
            self:GetCaster(), -- player source
            params.ability, -- ability source
            "modifier_aghsfort_juggernaut_damage_manaward", -- modifier name
            { duration = 25 } )
    end
end


--------------------------------------------------------------------------------

modifier_aghsfort_juggernaut_blade_fury_manaward = class({})

--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_blade_fury_manaward:IsPurgable() 		return false end
function modifier_aghsfort_juggernaut_blade_fury_manaward:DestroyOnExpire() 	return true end

--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_blade_fury_manaward:OnCreated(kv)
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
function modifier_aghsfort_juggernaut_blade_fury_manaward:GetIntervalTick()
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

function modifier_aghsfort_juggernaut_blade_fury_manaward:OnDestroy( kv )
	if IsClient() then return end
	local hParent = self:GetParent()
	
	hParent:StopSound("Hero_Juggernaut.BladeFuryStart")
	hParent:Purge(false, true, false, true, true)
end

--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_blade_fury_manaward:OnIntervalThink()
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

function modifier_aghsfort_juggernaut_blade_fury_manaward:CheckState()
 

    local hState = {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,  
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }

    

    return hState
end


modifier_aghsfort_juggernaut_damage_manaward = class({})

--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_damage_manaward:IsPurgable() 		return false end
function modifier_aghsfort_juggernaut_damage_manaward:DestroyOnExpire() 	return true end

--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_damage_manaward:OnCreated(kv)
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


function modifier_aghsfort_juggernaut_damage_manaward:OnIntervalThink()
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

