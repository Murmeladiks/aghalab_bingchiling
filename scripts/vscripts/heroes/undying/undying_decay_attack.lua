undying_decay_attack = class( {} )

LinkLuaModifier( "modifier_undying_decay_attack", "heroes/undying/undying_decay_attack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_undying_decay_fix_str", "heroes/undying/modifier_undying_decay_fix", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_decay_zombie_stat", "heroes/undying/undying_decay_attack", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function undying_decay_attack:GetIntrinsicModifierName()
	return "modifier_undying_decay_attack"
end

modifier_undying_decay_attack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_undying_decay_attack:IsHidden()
	return true
end

function modifier_undying_decay_attack:IsPurgeException()
	return false
end

function modifier_undying_decay_attack:IsPurgable()
	return false
end

function modifier_undying_decay_attack:IsPermanent()
	return true
end


function modifier_undying_decay_attack:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_undying_decay_attack:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function  modifier_undying_decay_attack:OnAttackLanded(params)
	if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
	self.undying_decay = self:GetParent():FindAbilityByName("undying_decay")
	
    self.chance = 22
	if self.undying_decay and self.undying_decay:GetLevel()> 0 then	
		if params.target and not params.target:IsNull() and params.target:IsAlive()  then
			if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
				local pos = params.target:GetAbsOrigin()
				self:GetParent():SetCursorCastTarget(params.target)
				self.undying_decay:OnSpellStart()
				local radius = self.undying_decay:GetSpecialValueFor("radius")
				local duration = self.undying_decay:GetSpecialValueFor("decay_duration")
				local enemies = FindUnitsInRadius(
							self:GetParent():GetTeamNumber(),
							pos, 
							nil, 
							radius, 
							DOTA_UNIT_TARGET_TEAM_ENEMY, 
							DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 
							DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
							0, 
							false 
						)
				local enemylist = {}
				for _,enemy in pairs(enemies) do
					table.insert(enemylist,enemy)	  
				end
				if not self:GetParent():HasModifier("modifier_undying_decay_fix_str") then
					local  buffModifier = self:GetParent():AddNewModifier(self:GetParent(), self.undying_decay,"modifier_undying_decay_fix_str", { duration =duration})
					if(buffModifier) then
						buffModifier:SetStackCount(#enemylist)  
					end
				elseif self:GetParent():HasModifier("modifier_undying_decay_fix_str") then
					local buff = self:GetParent():FindModifierByName("modifier_undying_decay_fix_str") 
					if buff then
						buff:SetStackCount(buff:GetStackCount() + #enemylist)
						buff:ForceRefresh()
					end
				end
				if self:GetParent():HasAbility("undying_decay_zombies") then
					self.undying_tombstone = self:GetParent():FindAbilityByName("undying_tombstone")
					local duration = self.undying_tombstone:GetSpecialValueFor("duration")
					if  self.undying_tombstone and self.undying_tombstone:GetLevel()>0   then
						for _,enemy in pairs(enemies) do
							local zombie = CreateUnitByName("npc_dota_unit_undying_zombie",enemy:GetAbsOrigin(),true,self:GetParent(), self:GetParent(),self:GetParent():GetTeamNumber())  	
							zombie:AddNewModifier(zombie,nil,"modifier_decay_zombie_stat",{}) 
							zombie:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})  
						end	
					end
				end
				if self:GetParent():HasAbility("undying_decay_triple") then
					local damage = self.undying_decay:GetSpecialValueFor("decay_damage")*0.5
					self.damageTable = {
						--victim =  target,
						attacker = self:GetParent(),
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = params.ability, --Optional.
					}
					for i = 1, 2, 1 do
						Timers:CreateTimer(3.0*i, function()
							
							local particle_cast = "particles/units/heroes/hero_undying/undying_decay.vpcf"
							local sound_cast = "Hero_Undying.Decay.Target"
							local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
							ParticleManager:SetParticleControl( effect_cast, 0, pos )
							ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 1, 1 ) )
							EmitSoundOn( sound_cast, self:GetParent() )
							local enemies = FindUnitsInRadius( 
								self:GetParent():GetTeamNumber(), 
								cursorPos, 
								nil, 
								radius, 
								DOTA_UNIT_TARGET_TEAM_ENEMY, 
								DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
								DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
								0, 
								false )
							local enemylist = {}    
					
								for _,enemy in pairs( enemies ) do
									if enemy then
										self.damageTable.victim = enemy
										ApplyDamage( self.damageTable )	
										table.insert(enemylist,enemy)
									end
								end
								if not unit:HasModifier("modifier_undying_decay_fix_str") then
									local  buffModifier = unit:AddNewModifier(unit, self.undying_decay,"modifier_undying_decay_fix_str", { duration =duration})
									if(buffModifier) then
										buffModifier:SetStackCount(#enemylist)  
									end
								elseif unit:HasModifier("modifier_undying_decay_fix_str") then
									local buff = unit:FindModifierByName("modifier_undying_decay_fix_str") 
									if buff then
										buff:SetStackCount(buff:GetStackCount() + #enemylist)
										buff:ForceRefresh()
									end
								end 
								if self:GetParent():HasAbility("undying_decay_zombies") then
									self.undying_tombstone = self:GetParent():FindAbilityByName("undying_tombstone")
									local duration = self.undying_tombstone:GetSpecialValueFor("duration")
									if  self.undying_tombstone and self.undying_tombstone:GetLevel()>0   then
										for _,enemy in pairs(enemies) do
											local zombie = CreateUnitByName("npc_dota_unit_undying_zombie",enemy:GetAbsOrigin(),true,self:GetParent(), self:GetParent(),self:GetParent():GetTeamNumber())  	
											zombie:AddNewModifier(zombie,nil,"modifier_decay_zombie_stat",{}) 
											zombie:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})    
										end	
									end
								end   
						end)
			
					end
				end
			end	
		end
	end
		
	

    

end
modifier_decay_zombie_stat = class({})

------------------------------------------------------------------------------

function modifier_decay_zombie_stat:IsPurgable()
	return false
end

------------------------------------------------------------------------------

function modifier_decay_zombie_stat:OnCreated( kv )
    if IsServer() then
      
    end
end


function modifier_decay_zombie_stat:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end