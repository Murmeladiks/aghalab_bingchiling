templar_assassin_psionic_trap_cuts = class( {} )
function templar_assassin_psionic_trap_cuts:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf", context )
	
end

function templar_assassin_psionic_trap_cuts:OnSpellStart()
	self.caster = self:GetCaster()
    local target = self:GetCursorTarget()
    self.templar_assassin_meld = self.caster:FindAbilityByName("templar_assassin_meld")
    self.templar_assassin_psi_blades = self.caster:FindAbilityByName("templar_assassin_psi_blades")
    self.templar_assassin_psionic_trap = self.caster:FindAbilityByName("templar_assassin_psionic_trap")
    self.templar_assassin_trap = self.caster:FindAbilityByName("templar_assassin_trap")
    self.chance = 15
    local projectile_name = "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf"
	local projectile_speed = 1000
	local projectile_vision = 200
    local info = {
		--Target = target,
		Source = target,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
	
		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = self.caster:GetTeamNumber(),        -- Optional
		ExtraData = {

		}
	}
    
    local radius = self.templar_assassin_psionic_trap:GetSpecialValueFor("trap_radius")
    local enemies = FindUnitsInRadius( 
        self:GetCaster():GetTeamNumber(), 
        target:GetAbsOrigin(), 
        nil, 
        radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
        0, 
        false )
        
    for _,enemy in pairs( enemies ) do
        if enemy then
            
            info.Target = enemy
            ProjectileManager:CreateTrackingProjectile(info)
        end
    end
	
   
	 			
end
function templar_assassin_psionic_trap_cuts:OnProjectileHit( target, location)
    if target==nil or target:IsInvulnerable() then
		return
	end
    --隐秘切入弹道造成的伤害
    local attackdamage =  self.caster:GetAverageTrueAttackDamage(nil)
    local bonusdamage = self.templar_assassin_meld:GetSpecialValueFor("bonus_damage")
    
    local totaldamage = attackdamage + bonusdamage
    print("totaldamage")
    print(totaldamage)
    local debuffDuration = 6
	
	--  banned
	-- target:AddNewModifier(
	-- 	self:GetCaster(), -- player source
	-- 	self.templar_assassin_meld, -- ability source
	-- 	"modifier_templar_assassin_meld_armor", -- modifier name
	-- 	{ duration = debuffDuration } -- kv
	-- )	
    self.damageTable = {
        victim =  target,
        attacker = self:GetCaster(),
        damage = totaldamage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self.templar_assassin_meld, --Optional.
    }
    ApplyDamage( self.damageTable )
    
  --隐性装置天赋
    
    if self.caster:HasAbility("templar_assassin_psi_blades_devices") then
        if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self.caster) then
            if target then
                --在敌方单位脚下放一个陷阱并引爆
                local pos = target:GetAbsOrigin()
                self.caster:SetCursorPosition(pos)
                self.templar_assassin_psionic_trap:OnSpellStart()
                self.templar_assassin_trap:OnSpellStart()
                --陷阱伤害
                local damage = self.templar_assassin_psionic_trap:GetSpecialValueFor("trap_bonus_damage")
                local radius = self.templar_assassin_psionic_trap:GetSpecialValueFor("trap_radius")
                local enemies = FindUnitsInRadius( 
                    self.caster:GetTeamNumber(), 
                    pos, 
                    nil, 
                    radius, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
                    0, 
                    false )
                self.damageTable = {
                    --victim =  target,
                    attacker = self.caster,
                    damage = damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self.templar_assassin_psionic_trap, --Optional.
                }
                
                for _,enemy in pairs( enemies ) do
                    if enemy then
                        self.damageTable.victim = enemy
                        ApplyDamage( self.damageTable )	    
                    end
                end
                --因为有隐秘切入，所以还需要放置另外一个傀儡
                self.dummy = CreateUnitByName("npc_dota_dummy_caster_queen", pos, false, nil, nil, DOTA_TEAM_GOODGUYS)
                self.caster:SetCursorCastTarget(self.dummy)
                self:OnSpellStart() 
                --记得移除傀儡
                Timers:CreateTimer(3.0, function()
					UTIL_Remove(self.dummy)
				end)
                --隐蔽回音天赋
                if self.caster:HasAbility("templar_assassin_psionic_trap_echo") then
                    for i = 1, 2, 1 do
                        Timers:CreateTimer(1.0*i, function()
                            --特效
                            local particle_cast = "particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf"
                            local sound_cast = "Hero_TemplarAssassin.Trap.Explode"
                            local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
                            ParticleManager:SetParticleControl( effect_cast, 0, pos )
                            ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 1, 1 ) )
                            EmitSoundOn( sound_cast, self:GetParent() )
                            --伤害
                            local enemies = FindUnitsInRadius( 
                                self.caster:GetTeamNumber(), 
                                pos, 
                                nil, 
                                radius, 
                                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
                                0, 
                                false )
                                
                    
                                for _,enemy in pairs( enemies ) do
                                    if enemy then
                                        self.damageTable.victim = enemy
                                        ApplyDamage( self.damageTable )	
                                        
                                    end
                                end
                                --每次引爆之后用上面的傀儡释放隐秘切入的弹道
                                self.caster:SetCursorCastTarget(self.dummy)
                                self:OnSpellStart()



                                --陷阱回血天赋
                                if self.caster:HasAbility("templar_assassin_psionic_trap_resurgence") then
                                    local heal = self.templar_assassin_psionic_trap:GetSpecialValueFor("trap_bonus_damage")*0.5
                                    local allies = FindUnitsInRadius( 
                                        self.caster:GetTeamNumber(), 
                                        pos, 
                                        nil, 
                                        radius, 
                                        DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
                                        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                                        DOTA_UNIT_TARGET_FLAG_NONE, 
                                        0, 
                                        false )
                                    
                                    
                                    for _,ally in pairs( allies ) do
                                        if ally then
                                            ally:Heal( heal, nil )
                                        end
                                    end
                                end	
                                
                               
                                
                        end)
                    end
                end
                --陷阱回血天赋
                if self.caster:HasAbility("templar_assassin_psionic_trap_resurgence") then
                    local heal = self.templar_assassin_psionic_trap:GetSpecialValueFor("trap_bonus_damage")*0.5
                    local allies = FindUnitsInRadius( 
                        self.caster:GetTeamNumber(), 
                        pos, 
                        nil, 
                        radius, 
                        DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
                        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                        DOTA_UNIT_TARGET_FLAG_NONE, 
                        0, 
                        false )
                    
                    
                    for _,ally in pairs( allies ) do
                        if ally then
                            ally:Heal( heal, nil )
                        end
                    end
                end
               
                
            end
        end
    end
end