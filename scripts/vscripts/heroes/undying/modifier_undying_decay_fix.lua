LinkLuaModifier("modifier_undying_decay_fix_str", "heroes/undying/modifier_undying_decay_fix", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_zombie_stat", "heroes/undying/modifier_undying_decay_fix", LUA_MODIFIER_MOTION_NONE )
modifier_undying_decay_fix = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_undying_decay_fix:IsHidden()
	return true
end

function modifier_undying_decay_fix:IsPurgeException()
	return false
end

function modifier_undying_decay_fix:IsPurgable()
	return false
end

function modifier_undying_decay_fix:IsPermanent()
	return true
end




function modifier_undying_decay_fix:OnCreated(kv)
    if not IsServer() then
        return
    end
end
function modifier_undying_decay_fix:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_undying_decay_fix:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "undying_decay" then
        return
    end

    local unit = self:GetParent()

    self.undying_decay = unit:FindAbilityByName("undying_decay")
    
    if not self.undying_decay or self.undying_decay:GetLevel() == 0 then
        return
    end
    local radius = self.undying_decay:GetSpecialValueFor("radius")
    local pos = params.ability:GetCursorPosition()
    local enemylist = {}
    local duration = self.undying_decay:GetSpecialValueFor("decay_duration")
    local damage = self.undying_decay:GetSpecialValueFor("decay_damage")*0.5
    self.damageTable = {
        --victim =  target,
        attacker = self:GetParent(),
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = params.ability, --Optional.
    }
    
    local enemies = FindUnitsInRadius(
        unit:GetTeamNumber(),
        pos, 
        nil, 
        radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
        0, 
        false 
    )
    for _,enemy in pairs(enemies) do
		table.insert(enemylist,enemy)
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
                zombie:AddNewModifier(zombie,nil,"modifier_zombie_stat",{}) 
                zombie:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
            end
        end
    end
    if self:GetParent():HasAbility("undying_decay_triple") then
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
                    pos, 
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
                                zombie:AddNewModifier(zombie,nil,"modifier_zombie_stat",{}) 
                                zombie:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
                            end
                        end
                    end  
            end)

        end
    end
end
modifier_undying_decay_fix_str = class({})


function modifier_undying_decay_fix_str:IsPurgable()
	return false
end

function modifier_undying_decay_fix_str:IsPurgeException()
	return false
end

function modifier_undying_decay_fix_str:IsPermanent()
	return false
end
function modifier_undying_decay_fix:IsHidden()
	return false
end



function modifier_undying_decay_fix_str:OnCreated( kv )
    if not IsServer() then
        return
    end
	self.str_steal = self:GetAbility():GetSpecialValueFor("str_steal")
    self.str_scale_up = self:GetAbility():GetSpecialValueFor("str_scale_up")
    self:SetHasCustomTransmitterData(true)
end

function modifier_undying_decay_fix_str:OnRefresh()
	if IsServer() then
		self:SendBuffRefreshToClients()
	end
end
function modifier_undying_decay_fix_str:AddCustomTransmitterData()
    return {
       
		str_steal = self.str_steal,
		
    }
end
function modifier_undying_decay_fix_str:HandleCustomTransmitterData( data )
    self.str_steal = data.str_steal
	
end


--------------------------------------------------------------------------------

function modifier_undying_decay_fix_str:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MODEL_SCALE_CONSTANT
	}

	return funcs
end



function modifier_undying_decay_fix_str:GetModifierBonusStats_Strength()
	return self:GetStackCount() * self.str_steal
end

function modifier_undying_decay_fix_str:GetModifierModelScaleConstant()
	return 1+(self:GetStackCount() * self.str_scale_up/100)
end
modifier_zombie_stat = class({})

------------------------------------------------------------------------------

function modifier_zombie_stat:IsPurgable()
	return false
end

------------------------------------------------------------------------------

function modifier_zombie_stat:OnCreated( kv )
    if IsServer() then
      
    end
end


function modifier_zombie_stat:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end