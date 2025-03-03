spectre_spectral_dagger_trail = class( {} )

LinkLuaModifier( "modifier_spectre_spectral_dagger_trail", "heroes/spectre/spectre_spectral_dagger_trail", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_spectral_dagger_dm_thinker", "heroes/spectre/spectre_spectral_dagger_trail", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_spectral_dagger_dm_debuff", "heroes/spectre/spectre_spectral_dagger_trail", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function spectre_spectral_dagger_trail:GetIntrinsicModifierName()
	return "modifier_spectre_spectral_dagger_trail"
end

modifier_spectre_spectral_dagger_trail = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_spectral_dagger_trail:IsHidden()
	return true
end

function modifier_spectre_spectral_dagger_trail:IsPurgeException()
	return false
end

function modifier_spectre_spectral_dagger_trail:IsPurgable()
	return false
end

function modifier_spectre_spectral_dagger_trail:IsPermanent()
	return true
end



function modifier_spectre_spectral_dagger_trail:OnCreated(kv)
	self.ability = self:GetAbility()
    self.caster = self.ability:GetCaster()
    self.parent = self:GetParent()
    self.team = self.parent:GetTeamNumber()
    self:updateData(kv)
    if self.caster:IsIllusion() then
        return
    end
	if  IsServer() then
		
			
			self.spectre_spectral_dagger = self:GetParent():FindAbilityByName("spectre_spectral_dagger")
			self.pos = self.parent:GetAbsOrigin()
			self.trail_time = Time()
			self.trail_radius = 200
			self.trail_interval = self.trail_radius*0.7
			self.trail_duration = 2.5
			self.trail_max = 5
			self.trail_queue = Queue.new()
			self.spark_table = {
				duration = self.trail_duration,
				tick_rate = 0.5,
				radius = self.trail_radius
			}
			local hTinker = CreateModifierThinker(self.parent, self.ability, "modifier_spectre_spectral_dagger_dm_thinker", self.spark_table, self.pos, self.team, false)
			Queue.pushBack(self.trail_queue, hTinker)
			
			self:StartIntervalThink(FrameTime())
			
			self.bonus_movement_speed = self.spectre_spectral_dagger:GetSpecialValueFor("speed_bonus")
			print(self.bonus_movement_speed)
			--self.caster:AddNewModifier( self.caster, nil, "modifier_spectre_spectral_dagger_path_phased", { } )
			self:SetHasCustomTransmitterData(true)
			self:PlayEffects1()
    	
    end
end
function modifier_spectre_spectral_dagger_trail:OnRefresh(kv)
    if  IsServer() then
		self.spectre_spectral_dagger = self:GetParent():FindAbilityByName("spectre_spectral_dagger")
        self.bonus_movement_speed = self.spectre_spectral_dagger:GetSpecialValueFor("speed_bonus")
        self:SendBuffRefreshToClients()
        self:updateData(kv)
    end
end
function modifier_spectre_spectral_dagger_trail:CheckState()
	local state =
	{
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] =true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end
function modifier_spectre_spectral_dagger_trail:updateData( kv )
   
end



function modifier_spectre_spectral_dagger_trail:OnRemoved()
end

function modifier_spectre_spectral_dagger_trail:OnDestroy()
end


function modifier_spectre_spectral_dagger_trail:OnIntervalThink()
    if IsServer() then 
       
			local cpos = self.parent:GetAbsOrigin()
			local distance = VectorDistance2D(cpos, self.pos)
			local time = Time()
			if distance > self.trail_interval or time - self.trail_time > self.trail_duration then
				-- DebugDrawCircle(cpos, Vector(255,0,0), 200, 250, false, self.trail_duration)
				self.pos = cpos
				self.trail_time = time
				local hTinker = CreateModifierThinker(self.parent, self.ability, "modifier_spectre_spectral_dagger_dm_thinker", self.spark_table, self.pos, self.team, false)
				Queue.pushBack(self.trail_queue, hTinker)
				if Queue.length(self.trail_queue) > self.trail_max then
					hTinker = Queue.popFront(self.trail_queue)
					if IsValid(hTinker) then
						hTinker:Destroy()
					end
				end
			end
		
    end
end





function modifier_spectre_spectral_dagger_trail:PlayEffects1()
	
    
    self.nPreviewFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_spectre/spectre_shadow_path_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
    ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 100, 100, 100 ) )
    ParticleManager:SetParticleControl( self.nPreviewFX, 3, Vector( 255, 0, 100 ) )
end



modifier_spectre_spectral_dagger_dm_thinker = class({})
function modifier_spectre_spectral_dagger_dm_thinker:IsHidden()
    return true
end

function modifier_spectre_spectral_dagger_dm_thinker:IsPurgable()
    return false
end

function modifier_spectre_spectral_dagger_dm_thinker:OnCreated(kv)
    if IsServer() then
        self.parent = self:GetParent()
        self.ability = self:GetAbility()
        -- print(self.ability:GetName())
        self.caster = self.ability:GetCaster()
        self.team = self.parent:GetTeamNumber()
        self.pos = self.parent:GetAbsOrigin()
        -- print(self.parent:GetAbsOrigin())
        -- DebugDrawCircle(self.parent:GetAbsOrigin(), Vector(255,0,0), 100, 200, false, self:GetDuration())
        self.radius = kv.radius
        self.tick_rate = kv.tick_rate
        
        self:StartIntervalThink(kv.tick_rate)
    end
end

function modifier_spectre_spectral_dagger_dm_thinker:OnIntervalThink()
    if IsServer() then
        local enemies = FindUnitsInRadius(self.team, self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for _, enemy in pairs(enemies) do
            enemy:AddNewModifier(self.caster, self.ability, "modifier_spectre_spectral_dagger_dm_debuff", {
                duration = self:GetRemainingTime() + 2,
                tick_rate = self.tick_rate
            })
        end
    end
end

modifier_spectre_spectral_dagger_dm_debuff = class({})

function modifier_spectre_spectral_dagger_dm_debuff:IsPurgable()
    return true
end

function modifier_spectre_spectral_dagger_dm_debuff:OnCreated(kv)
   
   
    self.ability = self:GetAbility()
    self.caster = self.ability:GetCaster()
    self.parent = self:GetParent()
    
    self:SetHasCustomTransmitterData(true)
   
    if IsServer() then
        
        
        self:SendBuffRefreshToClients()

        self.tick_rate = kv.tick_rate
      
        self:StartIntervalThink(self.tick_rate)
    end
end

function modifier_spectre_spectral_dagger_dm_debuff:AddCustomTransmitterData()
    return {
        slow = self.ms_slow
    }
end

function modifier_spectre_spectral_dagger_dm_debuff:HandleCustomTransmitterData(data)
    self.ms_slow = data.slow
end

function modifier_spectre_spectral_dagger_dm_debuff:OnRefresh(kv)
    if IsServer() then
        if self.spectre_spectral_dagger and self.spectre_spectral_dagger:GetLevel()>0 then

            self.damage = self.spectre_spectral_dagger:GetSpecialValueFor("damage")*0.25 
        end
    end
end

function modifier_spectre_spectral_dagger_dm_debuff:DeclareFunctions()
    return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT}
end

function modifier_spectre_spectral_dagger_dm_debuff:OnIntervalThink()
    if IsServer() then
		
		-- print(self.ms_slow)

        self.spectre_spectral_dagger = self.caster:FindAbilityByName("spectre_spectral_dagger")
        if self.spectre_spectral_dagger and self.spectre_spectral_dagger:GetLevel()>0 then
            self.damage = self.spectre_spectral_dagger:GetSpecialValueFor("damage")*0.25 
            self.ms_slow = -self.spectre_spectral_dagger:GetSpecialValueFor("speed_bonus") 
           
            self.damage_table = {
                victim = self.parent,
                attacker = self.caster,
                damage = self.damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self.ability
            }
            ApplyDamage(self.damage_table)
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self.damage_table.victim, self.damage_table.damage, nil)
            if self.caster:HasAbility("spectre_spectral_dagger_desolate") then
                self.spectre_desolate = self.caster:FindAbilityByName("spectre_desolate")
                if self.spectre_desolate and self.spectre_desolate:GetLevel()>0 then
                    local damage = self.spectre_desolate:GetSpecialValueFor("bonus_damage")*0.25
                    local damage_table = {
                        victim = self.parent,
                        attacker = self.caster,
                        damage = damage,
                        damage_type = DAMAGE_TYPE_PURE,
                        ability = self.spectre_desolate
                    }
                    ApplyDamage(damage_table)
                end
            end
        end
    end
end

function modifier_spectre_spectral_dagger_dm_debuff:GetModifierMoveSpeedBonus_Constant()
    return self.ms_slow
end