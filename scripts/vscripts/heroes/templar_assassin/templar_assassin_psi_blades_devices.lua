templar_assassin_psi_blades_devices = class( {} )

LinkLuaModifier( "modifier_templar_assassin_psi_blades_devices", "heroes/templar_assassin/templar_assassin_psi_blades_devices", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function templar_assassin_psi_blades_devices:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf", context )
	
end
function templar_assassin_psi_blades_devices:GetIntrinsicModifierName()
	return "modifier_templar_assassin_psi_blades_devices"
end

modifier_templar_assassin_psi_blades_devices = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_templar_assassin_psi_blades_devices:IsHidden()
	return true
end

function modifier_templar_assassin_psi_blades_devices:IsPurgeException()
	return false
end

function modifier_templar_assassin_psi_blades_devices:IsPurgable()
	return false
end

function modifier_templar_assassin_psi_blades_devices:IsPermanent()
	return true
end


function modifier_templar_assassin_psi_blades_devices:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_templar_assassin_psi_blades_devices:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end


function  modifier_templar_assassin_psi_blades_devices:OnTakeDamage(params)
    if not IsServer() then return end



	if params.attacker ~= self:GetParent()  then
		return
	end
	
	if  params.inflictor and params.inflictor:GetAbilityName() =="templar_assassin_psi_blades" then
		self.chance = 15
		self.templar_assassin_psionic_trap = self:GetParent():FindAbilityByName("templar_assassin_psionic_trap")
		self.templar_assassin_trap = self:GetParent():FindAbilityByName("templar_assassin_trap")
		
		if self.templar_assassin_psionic_trap and self.templar_assassin_psionic_trap:GetLevel()>0 then
			--隐性装置天赋
			if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
				if params.unit then
					local pos = params.unit:GetAbsOrigin()
					self:GetParent():SetCursorPosition(pos)
					self.templar_assassin_psionic_trap:OnSpellStart()
					self.templar_assassin_trap:OnSpellStart()

					local damage = self.templar_assassin_psionic_trap:GetSpecialValueFor("trap_bonus_damage")
					local radius = self.templar_assassin_psionic_trap:GetSpecialValueFor("trap_radius")
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
						self.dummy = CreateUnitByName("npc_dota_dummy_caster_queen", pos, false, nil, nil, DOTA_TEAM_GOODGUYS)
						self:GetParent():SetCursorCastTarget(self.dummy)
						self.templar_assassin_psionic_trap_cuts:OnSpellStart()	
						Timers:CreateTimer(3.0, function()
							UTIL_Remove(self.dummy)
						end)
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
					--回音天赋
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
									--回血天赋
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
										--使用上面的傀儡来释放隐秘切入的弹道
										self:GetParent():SetCursorCastTarget(self.dummy)
										self.templar_assassin_psionic_trap_cuts:OnSpellStart()
										
									end
							end)
						end
					end



				end
			end
		end
	end

   
    
		
	

    

end