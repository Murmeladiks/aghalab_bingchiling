LinkLuaModifier("modifier_undying_soul_rip_taunt", "heroes/undying/undying_soul_rip_taunt", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_tauntunit_stat", "heroes/undying/undying_soul_rip_taunt", LUA_MODIFIER_MOTION_NONE )
undying_soul_rip_taunt = class( {} )
function undying_soul_rip_taunt:GetIntrinsicModifierName()
	return "modifier_undying_soul_rip_taunt"
end

modifier_undying_soul_rip_taunt = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_undying_soul_rip_taunt:IsHidden()
	return true
end
function modifier_undying_soul_rip_taunt:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_beserkers_call.vpcf", context )
	
end
function modifier_undying_soul_rip_taunt:IsPurgeException()
	return false
end

function modifier_undying_soul_rip_taunt:IsPurgable()
	return false
end

function modifier_undying_soul_rip_taunt:IsPermanent()
	return true
end




function modifier_undying_soul_rip_taunt:OnCreated(kv)
    if not IsServer() then
        return
    end
end
function modifier_undying_soul_rip_taunt:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_undying_soul_rip_taunt:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "undying_soul_rip" then
        return
    end

    local unit = self:GetParent()

    self.undying_soul_rip = unit:FindAbilityByName("undying_soul_rip")
    
    if not self.undying_soul_rip or self.undying_soul_rip:GetLevel() == 0 then
        return
    end
    local enemylist = {}
    local damage = self.undying_soul_rip:GetSpecialValueFor("damage_per_unit")
    
    
    local radius = 350
    local pos = params.target:GetAbsOrigin()
    local tauntunit = CreateUnitByName("npc_dota_dummy_caster_undying", pos, true, nil, nil, DOTA_TEAM_GOODGUYS)
    tauntunit:AddNewModifier(tauntunit,nil,"modifier_tauntunit_stat",{})
    local particle_cast = "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf"
   
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, tauntunit )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		tauntunit,
		PATTACH_POINT_FOLLOW,
		"attach_mouth",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
    local enemies = FindUnitsInRadius( 
        self:GetParent():GetTeamNumber(), 
        pos, 
        nil, 
        radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_NONE, 
        0, 
        false )
        for _, enemy in pairs(enemies) do
            if enemy then
                enemy:AddNewModifier(tauntunit,nil,"modifier_axe_berserkers_call",{duration =1})
                
            end
        end
    for i = 1, 3, 1 do
        Timers:CreateTimer(1.0*i, function()
            local particle_cast = "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf"
   
            local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, tauntunit )
            ParticleManager:SetParticleControlEnt(
                effect_cast,
                1,
                tauntunit,
                PATTACH_POINT_FOLLOW,
                "attach_mouth",
                Vector(0,0,0), -- unknown
                true -- unknown, true
            )
            ParticleManager:ReleaseParticleIndex( effect_cast )
            local enemies = FindUnitsInRadius( 
                self:GetParent():GetTeamNumber(), 
                pos, 
                nil, 
                radius, 
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                DOTA_UNIT_TARGET_FLAG_NONE, 
                0, 
                false )
            for _, enemy in pairs(enemies) do
                if enemy then
                    enemy:AddNewModifier(tauntunit,nil,"modifier_axe_berserkers_call",{duration =1})
                    
                end
            end
                 
        end)
    end
    Timers:CreateTimer(4.0, function()
       
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
                for _, enemy in pairs(enemies) do
                    if enemy then
                        table.insert(enemylist,enemy)
                        	
                    end
                end
                local damageTable = {
                    --victim =  target,
                    attacker = self:GetParent(),
                    damage = damage*#enemylist,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = params.ability, --Optional.
                }
                for _, enemy in pairs(enemies) do
                    if enemy then
                       
                        damageTable.victim = enemy
                        ApplyDamage(damageTable)	
                    end
                end
                local heal = math.ceil(damage*#enemylist)
                self:GetParent():Heal(heal, nil)
        UTIL_Remove(tauntunit)
    end)
  
end
modifier_tauntunit_stat = class({})

------------------------------------------------------------------------------

function modifier_tauntunit_stat:IsPurgable()
	return false
end

------------------------------------------------------------------------------

function modifier_tauntunit_stat:OnCreated( kv )
    if IsServer() then
      
    end
end


function modifier_tauntunit_stat:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		
		[MODIFIER_STATE_INVULNERABLE] = true,
		
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end