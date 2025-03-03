

modifier_templar_assassin_psionic_trap_fix = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_templar_assassin_psionic_trap_fix:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf", context )
	
end
function modifier_templar_assassin_psionic_trap_fix:IsHidden()
	return true
end


function modifier_templar_assassin_psionic_trap_fix:IsPurgable()
	return false
end

function modifier_templar_assassin_psionic_trap_fix:IsPurgeException()
	return false
end


function modifier_templar_assassin_psionic_trap_fix:IsPermanent()
	return true
end
function modifier_templar_assassin_psionic_trap_fix:OnCreated( kv )
	if not IsServer() then return end	
end

function modifier_templar_assassin_psionic_trap_fix:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_templar_assassin_psionic_trap_fix:OnAbilityFullyCast( params )
	if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
	
    if params.ability:GetAbilityName() == "templar_assassin_psionic_trap"  then	
		-- 添加陷阱自身的伤害
		local pos = self:GetParent():GetCursorPosition()
		self.templar_assassin_trap = self:GetParent():FindAbilityByName("templar_assassin_trap")
		self.templar_assassin_trap:OnSpellStart()
		
		local radius =params.ability:GetSpecialValueFor("trap_radius")
		local damage = params.ability:GetSpecialValueFor("trap_bonus_damage")
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
				ability = params.ability, --Optional.
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
			local heal = params.ability:GetSpecialValueFor("trap_bonus_damage")*0.5
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
		--隐蔽回音天赋
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
							local heal = params.ability:GetSpecialValueFor("trap_bonus_damage")*0.5
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

