templar_assassin_refraction_trap = class( {} )

LinkLuaModifier( "modifier_templar_assassin_refraction_trap", "heroes/templar_assassin/templar_assassin_refraction_trap", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function templar_assassin_refraction_trap:GetIntrinsicModifierName()
	return "modifier_templar_assassin_refraction_trap"
end

modifier_templar_assassin_refraction_trap = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_templar_assassin_refraction_trap:IsHidden()
	return true
end

function modifier_templar_assassin_refraction_trap:IsPurgeException()
	return false
end

function modifier_templar_assassin_refraction_trap:IsPurgable()
	return false
end

function modifier_templar_assassin_refraction_trap:IsPermanent()
	return true
end


function modifier_templar_assassin_refraction_trap:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_templar_assassin_refraction_trap:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end


function  modifier_templar_assassin_refraction_trap:OnAbilityExecuted(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "templar_assassin_refraction" then
       self.templar_assassin_psionic_trap = self:GetParent():FindAbilityByName("templar_assassin_psionic_trap")
       if self.templar_assassin_psionic_trap and self.templar_assassin_psionic_trap:GetLevel()>0 then
            local pos  = self:GetParent():GetAbsOrigin()
            self:GetParent():SetCursorPosition(pos)
            self.templar_assassin_psionic_trap:OnSpellStart()
            self.templar_assassin_trap = self:GetParent():FindAbilityByName("templar_assassin_trap")
		    --立即引爆
            self.templar_assassin_trap:OnSpellStart()
            local radius =self.templar_assassin_psionic_trap:GetSpecialValueFor("trap_radius")
            --伤害
		    local damage = self.templar_assassin_psionic_trap:GetSpecialValueFor("trap_bonus_damage")
		    local enemies = FindUnitsInRadius( 
			self:GetParent():GetTeamNumber(), 
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
				attacker = self:GetParent(),
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

            --隐秘切入天赋
            if self:GetParent():HasAbility("templar_assassin_psionic_trap_cuts") then
                self.templar_assassin_psionic_trap_cuts = self:GetParent():FindAbilityByName("templar_assassin_psionic_trap_cuts")
                self.templar_assassin_meld = self:GetParent():FindAbilityByName("templar_assassin_meld")
                if self.templar_assassin_meld and self.templar_assassin_meld:GetLevel()>0 then
                    
                    
                    self.dummy = CreateUnitByName("npc_dota_dummy_caster_queen", pos, false, nil, nil, DOTA_TEAM_GOODGUYS)
                    self:GetParent():SetCursorCastTarget(self.dummy)
                    self.templar_assassin_psionic_trap_cuts:OnSpellStart()
                    Timers:CreateTimer(3.0, function()
                        UTIL_Remove(self.dummy)
                    end)
                    
                end
            end
            --陷阱回血天赋
            if self:GetParent():HasAbility("templar_assassin_psionic_trap_resurgence") then
                local heal = self.templar_assassin_psionic_trap:GetSpecialValueFor("trap_bonus_damage")*0.5
                    local allies = FindUnitsInRadius( 
                    self:GetParent():GetTeamNumber(), 
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

            if self:GetParent():HasAbility("templar_assassin_psionic_trap_echo") then
                for i = 1, 2, 1 do
                    Timers:CreateTimer(1.0*i, function()
                        
                        local particle_cast = "particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf"
                        local sound_cast = "Hero_TemplarAssassin.Trap.Explode"
                        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
                        ParticleManager:SetParticleControl( effect_cast, 0, pos )
                        ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 1, 1 ) )
                        EmitSoundOn( sound_cast, self:GetParent() )
                        local enemies = FindUnitsInRadius( 
                            self:GetParent():GetTeamNumber(), 
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
                            --陷阱回血天赋
                            if self:GetParent():HasAbility("templar_assassin_psionic_trap_resurgence") then
                                local heal = self.templar_assassin_psionic_trap:GetSpecialValueFor("trap_bonus_damage")*0.5
                                    local allies = FindUnitsInRadius( 
                                    self:GetParent():GetTeamNumber(), 
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
                            --隐秘切入天赋
                            if self:GetParent():HasAbility("templar_assassin_psionic_trap_cuts") then
                                self.templar_assassin_psionic_trap_cuts = self:GetParent():FindAbilityByName("templar_assassin_psionic_trap_cuts")
                                self.templar_assassin_meld = self:GetParent():FindAbilityByName("templar_assassin_meld")
                                if self.templar_assassin_meld and self.templar_assassin_meld:GetLevel()>0 then
                                        
                                    self:GetParent():SetCursorCastTarget(self.dummy)
                                    self.templar_assassin_psionic_trap_cuts:OnSpellStart()
                                    
                                    
                                end
                            end
                    end)
                end
            end
















       end
    end
     
  
   
    
		
	

    

end