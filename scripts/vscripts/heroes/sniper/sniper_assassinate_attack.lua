sniper_assassinate_attack = class( {} )

LinkLuaModifier( "modifier_sniper_assassinate_attack", "heroes/sniper/sniper_assassinate_attack", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sniper_assassinate_attack:GetIntrinsicModifierName()
	return "modifier_sniper_assassinate_attack"
end

modifier_sniper_assassinate_attack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_assassinate_attack:IsHidden()
	return true
end

function modifier_sniper_assassinate_attack:IsPurgeException()
	return false
end

function modifier_sniper_assassinate_attack:IsPurgable()
	return false
end

function modifier_sniper_assassinate_attack:IsPermanent()
	return true
end



function modifier_sniper_assassinate_attack:OnCreated(kv)
    if IsServer() then
        
       
   
end
end
function modifier_sniper_assassinate_attack:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
       
    }
end


function modifier_sniper_assassinate_attack:OnAttackLanded(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end

    

    self.ability = self:GetParent():FindAbilityByName("sniper_assassinate")
    self.sniper_headshot = self:GetCaster():FindAbilityByName("sniper_headshot")
    self.chance = self.sniper_headshot:GetSpecialValueFor("proc_chance")*0.5
    
	if self.ability and self.ability:GetLevel()> 0 then
		
        if params.target and not params.target:IsNull() and params.target:IsAlive() and not params.target:IsInvulnerable() then
			
				if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
					self:GetParent():SetCursorCastTarget(params.target)
                    self.ability:OnSpellStart()
				end
			
		end 
	end
   
        
        
   
        
end


