aghsfort_special_undying_consume_zombies_dummy = class( {} )

LinkLuaModifier( "modifier_aghsfort_special_undying_consume_zombies_dummy", "heroes/undying/aghsfort_special_undying_consume_zombies_dummy", LUA_MODIFIER_MOTION_NONE )
function aghsfort_special_undying_consume_zombies_dummy:OnSpellStart()
	
    local zombielist = {} 
    local zombies = FindUnitsInRadius( 
        self:GetCaster():GetTeamNumber(), 
        self:GetCaster():GetAbsOrigin(), 
        nil, 
        9999, 
        DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        0, 
        0, 
        false )
        for _,zombie in pairs( zombies ) do
            if zombie:GetName() == "npc_dota_unit_undying_zombie" then
                table.insert(zombielist,zombie)
                UTIL_Remove(zombie)
            end
        end    
    local count = #zombielist
    local maxhealth = self:GetCaster():GetMaxHealth()
    local heal = count*maxhealth*0.05
    self:GetCaster():Heal(heal,nil)
    local buff  = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_aghsfort_special_undying_consume_zombies_dummy", {duration = 5})
    if buff then
        buff:SetStackCount(count)
    end
    
end
modifier_aghsfort_special_undying_consume_zombies_dummy = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_aghsfort_special_undying_consume_zombies_dummy:IsHidden()
	return false
end

function modifier_aghsfort_special_undying_consume_zombies_dummy:IsPurgeException()
	return false
end

function modifier_aghsfort_special_undying_consume_zombies_dummy:IsPurgable()
	return false
end

function modifier_aghsfort_special_undying_consume_zombies_dummy:IsPermanent()
	return false
end


function modifier_aghsfort_special_undying_consume_zombies_dummy:OnCreated( kv )
	if IsServer() then		
       self.movespeed = 10
       self.attackspeed = 15
       self:SetHasCustomTransmitterData(true)
    end
end
function modifier_aghsfort_special_undying_consume_zombies_dummy:AddCustomTransmitterData()
    return {
       
		movespeed = self.movespeed,
		attackspeed = self.attackspeed,
		
    }
end
function modifier_aghsfort_special_undying_consume_zombies_dummy:HandleCustomTransmitterData( data )
    self.movespeed = data.movespeed
	self.attackspeed = data.attackspeed 
end
function modifier_aghsfort_special_undying_consume_zombies_dummy:DeclareFunctions()
	return {
       
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
    }

end
function modifier_aghsfort_special_undying_consume_zombies_dummy:GetModifierAttackSpeedBonus_Constant(params)
    return self.attackspeed*self:GetStackCount()
end
function modifier_aghsfort_special_undying_consume_zombies_dummy:GetModifierMoveSpeedBonus_Percentage(params)
    return self.movespeed*self:GetStackCount()
end
function modifier_aghsfort_special_undying_consume_zombies_dummy:GetModifierAttackSpeed_Limit(params)
	return 1
end
function modifier_aghsfort_special_undying_consume_zombies_dummy:GetModifierIgnoreMovespeedLimit(params)
	return 1
end