undying_tombstone_corpses= class( {} )

LinkLuaModifier( "modifier_undying_tombstone_corpses", "heroes/undying/undying_tombstone_corpses", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_undying_decay_fix_str", "heroes/undying/modifier_undying_decay_fix", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_zombie_stat", "heroes/undying/modifier_undying_decay_fix", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function undying_tombstone_corpses:GetIntrinsicModifierName()
	return "modifier_undying_tombstone_corpses"
end



modifier_undying_tombstone_corpses= class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_undying_tombstone_corpses:IsHidden()
	return true
end

function modifier_undying_tombstone_corpses:IsPurgeException()
	return false
end

function modifier_undying_tombstone_corpses:IsPurgable()
	return false
end

function modifier_undying_tombstone_corpses:IsPermanent()
	return true
end


function modifier_undying_tombstone_corpses:OnCreated( kv )
	if IsServer() then
       
    end
end

function modifier_undying_tombstone_corpses:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end



function  modifier_undying_tombstone_corpses:OnDeath(params)
    if not IsServer() then
        return
    end

    if params.unit:GetName() ~= "npc_dota_unit_undying_zombie" then
        return
    end
    
    self.chance = 25
    self.undying_decay = self:GetParent():FindAbilityByName("undying_decay")
    if self.undying_decay and self.undying_decay:GetLevel()>0 then
        if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
                local duration = self.undying_decay:GetSpecialValueFor("decay_duration")
                local pos = params.unit:GetAbsOrigin()
                local radius = self.undying_decay:GetSpecialValueFor("radius")
                local particle_cast = "particles/units/heroes/hero_undying/undying_decay.vpcf"
                local sound_cast = "Hero_Undying.Decay.Target"
                local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
                ParticleManager:SetParticleControl( effect_cast, 0, pos )
                ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 1, 1 ) )
                EmitSoundOn( sound_cast, self:GetParent() )
               
                local damage = self.undying_decay:GetSpecialValueFor("decay_damage")*0.5
                self.damageTable = {
                    --victim =  target,
                    attacker = self:GetParent(),
                    damage = damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self.undying_decay, --Optional.
                }
                local enemylist = {}
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
                            table.insert(enemylist,enemy)
                        end
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
                                zombie:AddNewModifier(zombie,nil,"modifier_zombie_stat",{}) 
                                zombie:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
                            end
                        end
                    end 
                     
        end
    end
    

end