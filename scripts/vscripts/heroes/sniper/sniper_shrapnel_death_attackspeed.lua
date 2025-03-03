sniper_shrapnel_death_attackspeed = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_sniper_shrapnel_death_attackspeed", "heroes/sniper/sniper_shrapnel_death_attackspeed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_shrapnel_death_attackspeed_stack", "heroes/sniper/sniper_shrapnel_death_attackspeed", LUA_MODIFIER_MOTION_NONE )
function sniper_shrapnel_death_attackspeed:GetIntrinsicModifierName()
	return "modifier_sniper_shrapnel_death_attackspeed"
end
function sniper_shrapnel_death_attackspeed:Precache( context )
	
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context )
end


modifier_sniper_shrapnel_death_attackspeed = class({})

--------------------------------------------------------------------------------
-- Classifications

function modifier_sniper_shrapnel_death_attackspeed:IsHidden()
	return true
end

function modifier_sniper_shrapnel_death_attackspeed:IsPurgeException()
	return false
end

function modifier_sniper_shrapnel_death_attackspeed:IsPurgable()
	return false
end

function modifier_sniper_shrapnel_death_attackspeed:IsPermanent()
	return true
end




function modifier_sniper_shrapnel_death_attackspeed:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_sniper_shrapnel_death_attackspeed:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH,
    }
end
function modifier_sniper_shrapnel_death_attackspeed:OnDeath(params)
    if not IsServer() then
        return
    end
    -- if params.attacker ~= self:GetParent() then
    --     return
    -- end
     
    --if params.inflictor and params.inflictor:GetAbilityName() == "sniper_shrapnel" then
       if  params.unit:HasModifier("modifier_sniper_shrapnel_slow") or params.unit:HasModifier("modifier_sniper_shrapnel_lua") then
        print("looking for deadbody by sharpnel")
        local buffModifier =  params.attacker:AddNewModifier(params.attacker,self:GetAbility(),"modifier_sniper_shrapnel_death_attackspeed_stack",{duration = 15})
    
        if(buffModifier) then
            buffModifier:AddStack()    
        end
        
        
     end

  

    
end

modifier_sniper_shrapnel_death_attackspeed_stack = class({})


function modifier_sniper_shrapnel_death_attackspeed_stack:IsPurgable()
	return false
end

function modifier_sniper_shrapnel_death_attackspeed_stack:IsPurgeException()
	return false
end

function modifier_sniper_shrapnel_death_attackspeed_stack:IsPermanent()
	return false
end

--------------------------------------------------------------------------------

function modifier_sniper_shrapnel_death_attackspeed_stack:OnCreated( kv )
    if  IsServer() then
        self.attackspeed  = 10
    end
    
	
	
end
function modifier_sniper_shrapnel_death_attackspeed_stack:OnRefresh( kv )
    if  IsServer() then
        self.attackspeed  = 10
    end
	
end
function modifier_sniper_shrapnel_death_attackspeed_stack:AddStack()
    if  IsServer() then
        self:IncrementStackCount()
        Timers:CreateTimer(15, function()
            if(self and not self:IsNull()) then
                self:DecrementStackCount()
            end
        end)
    end
	
   
   
end
--------------------------------------------------------------------------------




function modifier_sniper_shrapnel_death_attackspeed_stack:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
	}

	return funcs
end



function modifier_sniper_shrapnel_death_attackspeed_stack:GetModifierAttackSpeedBonus_Constant(params)
	return 10*self:GetStackCount()
end



--------------------------------------------------------------------------------

