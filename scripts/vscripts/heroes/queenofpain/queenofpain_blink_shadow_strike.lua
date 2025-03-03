queenofpain_blink_shadow_strike = class( {} )

LinkLuaModifier( "modifier_queenofpain_blink_shadow_strike", "heroes/queenofpain/queenofpain_blink_shadow_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_queen_of_pain_shadow_strike_lua", "heroes/queenofpain/queenofpain_blink_shadow_strike", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function queenofpain_blink_shadow_strike:GetIntrinsicModifierName()
	return "modifier_queenofpain_blink_shadow_strike"
end
function queenofpain_blink_shadow_strike:OnSpellStart()
    if IsServer() then
        local maintarget = self:GetCursorTarget()
        local point = maintarget:GetAbsOrigin()
        local point1 = self:GetCaster():GetAbsOrigin()
        self.ability = self:GetCaster():FindAbilityByName("queenofpain_shadow_strike")
        local projectile_name = "particles/units/heroes/hero_queenofpain/queen_shadow_strike.vpcf"
        local projectile_speed = self.ability:GetSpecialValueFor( "projectile_speed" )

        -- Find Units in Line
        local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(), point, point1, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0)

        -- Prebuilt Projectile info
        local info = {
            -- Target = target,
            Source = maintarget,
            Ability = self.ability,	
            EffectName = projectile_name,
            iMoveSpeed = projectile_speed,
            vSourceLoc= point,                -- Optional (HOW)
            bDodgeable = false,                                -- Optional
            bVisibleToEnemies = true,                         -- Optional
            bReplaceExisting = false,                         -- Optional
            bProvidesVision = false,                           -- Optional
        }

        -- create projectile to all enemies hit
        for _,enemy in pairs(enemies) do
            info.Target = enemy
            ProjectileManager:CreateTrackingProjectile(info)
        end
        local sound_cast = "Hero_QueenOfPain.ShadowStrike"
	    EmitSoundOn( sound_cast, self:GetCaster() )
        -- Play effects
        
    end
end
function queenofpain_blink_shadow_strike:OnProjectileHit( target, location )
	if target==nil or target:IsInvulnerable() or target:TriggerSpellAbsorb( self ) then
		return
	end

	local debuffDuration = self.ability:GetSpecialValueFor( "duration" )
	
	-- Add modifier
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self.ability, -- ability source
		"modifier_queen_of_pain_shadow_strike_lua", -- modifier name
		{ duration = debuffDuration } -- kv
	)	
end
modifier_queenofpain_blink_shadow_strike = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_queenofpain_blink_shadow_strike:IsHidden()
	return true
end

function modifier_queenofpain_blink_shadow_strike:IsPurgeException()
	return false
end

function modifier_queenofpain_blink_shadow_strike:IsPurgable()
	return false
end

function modifier_queenofpain_blink_shadow_strike:IsPermanent()
	return true
end



function modifier_queenofpain_blink_shadow_strike:OnCreated(kv)
    if IsServer() then
        
       
   
end
end
function modifier_queenofpain_blink_shadow_strike:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end
function modifier_queenofpain_blink_shadow_strike:OnAbilityExecuted(params)
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "queenofpain_blink" then
        return
    end
    
    if params.unit:FindAbilityByName("queenofpain_shadow_strike"):GetLevel()>0 then
        print("blink")
        
        self.vPos = self:GetParent():GetAbsOrigin()
        self.dummy = CreateUnitByName("npc_dota_dummy_caster_queen", self.vPos, false, nil, nil, DOTA_TEAM_GOODGUYS)
       
        
   end
end
 
   
    

function modifier_queenofpain_blink_shadow_strike:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "queenofpain_blink" then
        return
    end
    
       if params.unit:FindAbilityByName("queenofpain_shadow_strike"):GetLevel()>0 then
            self.queenofpain_shadow_strike = params.unit:FindAbilityByName("queenofpain_shadow_strike")
            if self.vPos and self.queenofpain_shadow_strike:GetLevel()> 0  then
               
                    print("dummy")
                    params.unit:SetCursorCastTarget(self.dummy)
                    self:GetAbility():OnSpellStart()
                    Timers:CreateTimer(0.5, function()
                        UTIL_Remove(self.dummy)
                    end)
                
                --local enemies = FindUnitsInLine(params.unit:GetTeamNumber(), self.vPos, self.vPos1, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0)
                -- for _,enemy in pairs(enemies) do
                --     if enemy and not enemy:IsNull() and enemy:IsAlive() and not enemy:IsInvulnerable() then
                --         params.unit:SetCursorCastTarget(enemy)
                --         self.queenofpain_shadow_strike:OnSpellStart()
                        
                --             -- if self:GetParent():HasAbility("queenofpain_shadow_strike_scream") and self:GetParent():FindAbilityByName("queenofpain_scream_of_pain"):GetLevel()>0 then
                --             --     if enemy:HasModifier("modifier_queenofpain_shadow_strike") then
                --             --         self:GetParent():SetCursorCastTarget(enemy)
                --             --         self.queenofpain_shadow_strike_scream = self:GetParent():FindAbilityByName("queenofpain_shadow_strike_scream")
                --             --         self.queenofpain_shadow_strike_scream:OnSpellStart()
                --             --     end
                --             -- end
                        
                           
                        
                       
                --     end
                -- end
            end
       end
    

        
end

modifier_queen_of_pain_shadow_strike_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_queen_of_pain_shadow_strike_lua:IsHidden()
	return false
end

function modifier_queen_of_pain_shadow_strike_lua:IsDebuff()
	return true
end

function modifier_queen_of_pain_shadow_strike_lua:IsStunDebuff()
	return false
end

function modifier_queen_of_pain_shadow_strike_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_queen_of_pain_shadow_strike_lua:OnCreated( kv )
	-- references
	self.max_slow = self:GetAbility():GetSpecialValueFor( "movement_slow" )
	local init_damage = self:GetAbility():GetSpecialValueFor( "strike_damage" )
	local tick_damage = self:GetAbility():GetSpecialValueFor( "duration_damage" )

	if IsServer() then
		-- Initialize Damage Table	 
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = init_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}
		ApplyDamage( self.damageTable )

		-- Initialize tick damage
		self.damageTable.damage = tick_damage

		-- Damage tick calculation, considering status resistance
		self.total_duration = self:GetRemainingTime()
		self.tick_instance = 5
		self.ticks = 0
		local tick_interval = self.total_duration/self.tick_instance

		-- Slow tick calculation
		self.tick_instance_slow = 15
		self.tick_interval_slow = self.total_duration/self.tick_instance_slow

		-- Start interval
		self:StartIntervalThink( tick_interval )

		-- play effects
		self:PlayEffects()
	end
end

function modifier_queen_of_pain_shadow_strike_lua:OnRefresh( kv )
	
end

function modifier_queen_of_pain_shadow_strike_lua:OnRemoved()
	-- ensure last tick happened
	if (self.ticks and self.tick_instance) and self.ticks < self.tick_instance then
		self:OnIntervalThink()
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_queen_of_pain_shadow_strike_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_queen_of_pain_shadow_strike_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.max_slow * (self:GetRemainingTime()/self.total_duration)
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_queen_of_pain_shadow_strike_lua:CheckState()
	local state = {
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = (self:GetParent():GetHealthPercent()<25),
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_queen_of_pain_shadow_strike_lua:OnIntervalThink()
	self.ticks = self.ticks + 1
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
-- function modifier_queen_of_pain_shadow_strike_lua:GetEffectName()
-- 	return "particles/units/heroes/hero_queenofpain/queen_shadow_strike_debuff.vpcf"
-- end

-- function modifier_queen_of_pain_shadow_strike_lua:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end

function modifier_queen_of_pain_shadow_strike_lua:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_queenofpain/queen_shadow_strike_debuff.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetParent():GetOrigin(), -- unknown
		true -- unknown, true
	)
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end