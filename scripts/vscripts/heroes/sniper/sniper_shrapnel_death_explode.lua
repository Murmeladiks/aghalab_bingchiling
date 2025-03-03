sniper_shrapnel_death_explode = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_sniper_shrapnel_death_explode", "heroes/sniper/sniper_shrapnel_death_explode", LUA_MODIFIER_MOTION_NONE )
function sniper_shrapnel_death_explode:GetIntrinsicModifierName()
	return "modifier_sniper_shrapnel_death_explode"
end


modifier_sniper_shrapnel_death_explode = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_shrapnel_death_explode:Precache( context )
	
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context )
end

function modifier_sniper_shrapnel_death_explode:IsHidden()
	return true
end

function modifier_sniper_shrapnel_death_explode:IsPurgeException()
	return false
end

function modifier_sniper_shrapnel_death_explode:IsPurgable()
	return false
end

function modifier_sniper_shrapnel_death_explode:IsPermanent()
	return true
end




function modifier_sniper_shrapnel_death_explode:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_sniper_shrapnel_death_explode:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH,
    }
end
function modifier_sniper_shrapnel_death_explode:OnDeath(params)
    if not IsServer() then
        return
    end
    -- if params.attacker ~= self:GetParent() then
    --     return
    -- end
     
    if  params.unit:HasModifier("modifier_sniper_shrapnel_slow") or params.unit:HasModifier("modifier_sniper_shrapnel_lua") then
        print("looking for deadbody by sharpnel")
        self.sniper_shrapnel = params.attacker:FindAbilityByName("sniper_shrapnel")
        self.damage = self.sniper_shrapnel:GetSpecialValueFor("shrapnel_damage") *0.5
        self.postion = params.unit:GetAbsOrigin()
        self.radius = 325
        local enemies = FindUnitsInRadius(
            params.attacker:GetTeamNumber(),
            self.postion, 
            nil, 
            self.radius, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
            0, 
            false 
        )
    
    
        for _,enemy in pairs(enemies) do
            if enemy and not enemy:IsNull() and enemy:IsAlive() and not enemy:IsInvulnerable() then
                enemy:AddNewModifier(params.attacker,self.sniper_shrapnel,"modifier_stunned",{duration = 1})
                local damageTable = {
                    victim = enemy,
                    attacker = params.attacker,
                    damage = self.damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility(), 
                }
                ApplyDamage( damageTable )
                print(self.damage)
                local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
                ParticleManager:SetParticleControl( nFXIndex, 0, self.postion )
                ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1.0, 1.0, self.radius ) )
                ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 1.0, 1.0, self.radius ) )
                ParticleManager:ReleaseParticleIndex( nFXIndex )
    
            end
        end
     end
    

  

    
end