gyrocopter_rocket_barrage_attack = class( {} )

LinkLuaModifier( "modifier_gyrocopter_rocket_barrage_attack", "heroes/gyrocopter/gyrocopter_rocket_barrage_attack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gyrocopter_rocket_barrage_dummy_stat", "heroes/gyrocopter/gyrocopter_rocket_barrage_attack", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function gyrocopter_rocket_barrage_attack:GetIntrinsicModifierName()
	return "modifier_gyrocopter_rocket_barrage_attack"
end


modifier_gyrocopter_rocket_barrage_attack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gyrocopter_rocket_barrage_attack:IsHidden()
	return true
end

function modifier_gyrocopter_rocket_barrage_attack:IsPurgeException()
	return false
end

function modifier_gyrocopter_rocket_barrage_attack:IsPurgable()
	return false
end

function modifier_gyrocopter_rocket_barrage_attack:IsPermanent()
	return true
end



function modifier_gyrocopter_rocket_barrage_attack:OnCreated(kv)
    if IsServer() then
        
       
   
end
end
function modifier_gyrocopter_rocket_barrage_attack:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
       
    }
end


function modifier_gyrocopter_rocket_barrage_attack:OnAttackLanded(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end

    

    self.ability = self:GetParent():FindAbilityByName("gyrocopter_rocket_barrage")
    self.chance = 20
    
	if self.ability and self.ability:GetLevel()> 0 then
		
        if params.target and not params.target:IsNull() and params.target:IsAlive() and not params.target:IsInvulnerable() then
			
				if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
					local vPos = params.target:GetAbsOrigin()
                    local dummy = CreateUnitByName("npc_aghsfort_gyrocopter_rocket_barrage_turret", vPos, true, nil, nil, DOTA_TEAM_GOODGUYS)
                    dummy:AddNewModifier(self:GetParent(), self.ability, "modifier_gyrocopter_rocket_barrage", {})
                    dummy:AddNewModifier(self:GetParent(), self.ability, "modifier_gyrocopter_rocket_barrage_dummy_stat", {})
                    Timers:CreateTimer(3, function()
                        UTIL_Remove(dummy)
                    end)
				end
			
		end 
	end
   
        
        
   
        
end


modifier_gyrocopter_rocket_barrage_dummy_stat = class({})

------------------------------------------------------------------------------

function modifier_gyrocopter_rocket_barrage_dummy_stat:IsPurgable()
	return false
end

------------------------------------------------------------------------------

function modifier_gyrocopter_rocket_barrage_dummy_stat:OnCreated( kv )
    if IsServer() then
      
    end
end


function modifier_gyrocopter_rocket_barrage_dummy_stat:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		
		[MODIFIER_STATE_INVULNERABLE] = true,
		
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end
