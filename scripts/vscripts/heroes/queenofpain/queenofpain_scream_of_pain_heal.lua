queenofpain_scream_of_pain_heal = class( {} )

LinkLuaModifier( "modifier_queenofpain_scream_of_pain_heal", "heroes/queenofpain/queenofpain_scream_of_pain_heal", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function queenofpain_scream_of_pain_heal:GetIntrinsicModifierName()
	return "modifier_queenofpain_scream_of_pain_heal"
end
function queenofpain_scream_of_pain_heal:OnSpellStart()
	if IsServer() then
        local maintarget = self:GetCursorTarget()
        local point = maintarget:GetAbsOrigin()
        local caster = self:GetCaster()
        self.ability = self:GetCaster():FindAbilityByName("queenofpain_scream_of_pain")
        local projectile_name = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf"
        local projectile_speed = self.ability:GetSpecialValueFor("projectile_speed")


        local info = {
            Target = caster,
            Source = maintarget,
            Ability = self,	
            EffectName = projectile_name,
            iMoveSpeed = projectile_speed,
            vSourceLoc= point,                -- Optional (HOW)
            bDodgeable = false,                                -- Optional
            bVisibleToEnemies = true,                         -- Optional
            bReplaceExisting = false,                         -- Optional
            bProvidesVision = false,                           -- Optional
        }

       
        
        ProjectileManager:CreateTrackingProjectile(info)
       

        
       
    end
end
function queenofpain_scream_of_pain_heal:OnProjectileHit( target, location )
	if IsServer() then
        
        self.heal = self.ability:GetSpecialValueFor("damage")*0.1
        local level = self.ability:GetLevel()
        self.mana = self.ability:GetManaCost(level)*0.1
        print(self.heal)
        print(self.mana)
        self:GetCaster():Heal( self.heal, nil )
        self:GetCaster():GiveMana( self.mana)
       
    end
end

modifier_queenofpain_scream_of_pain_heal = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_queenofpain_scream_of_pain_heal:IsHidden()
	return true
end

function modifier_queenofpain_scream_of_pain_heal:IsPurgeException()
	return false
end

function modifier_queenofpain_scream_of_pain_heal:IsPurgable()
	return false
end

function modifier_queenofpain_scream_of_pain_heal:IsPermanent()
	return true
end



function modifier_queenofpain_scream_of_pain_heal:OnCreated(kv)
    if IsServer() then
        
       
   
end
end
function modifier_queenofpain_scream_of_pain_heal:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end
function modifier_queenofpain_scream_of_pain_heal:OnTakeDamage(params)
    if not IsServer() then
        return
    end
    if params.attacker ~= self:GetParent() then
        return
    end
     
    if params.inflictor and params.inflictor:GetAbilityName() == "queenofpain_scream_of_pain" then
       params.attacker:SetCursorCastTarget(params.unit)
       self:GetAbility():OnSpellStart()
    
        
     end
    
end
 
   
    



