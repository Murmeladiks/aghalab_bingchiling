sniper_assassinate_accumulate = class( {} )

LinkLuaModifier( "modifier_sniper_assassinate_accumulate", "heroes/sniper/sniper_assassinate_accumulate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_assassinate_accumulate_stack", "heroes/sniper/sniper_assassinate_accumulate", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function sniper_assassinate_accumulate:GetIntrinsicModifierName()
	return "modifier_sniper_assassinate_accumulate"
end

modifier_sniper_assassinate_accumulate = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_assassinate_accumulate:IsHidden()
	return true
end

function modifier_sniper_assassinate_accumulate:IsPurgeException()
	return false
end

function modifier_sniper_assassinate_accumulate:IsPurgable()
	return false
end

function modifier_sniper_assassinate_accumulate:IsPermanent()
	return true
end



function modifier_sniper_assassinate_accumulate:OnCreated(kv)
    if IsServer() then
        
       
   
end
end
function modifier_sniper_assassinate_accumulate:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH,
    }
end



function modifier_sniper_assassinate_accumulate:OnDeath(params)
    if not IsServer() then
        return
    end
    if params.attacker ~= self:GetParent() then
        return
    end
     
    if params.inflictor and params.inflictor:GetAbilityName() == "sniper_assassinate" then
       
        local buffModifier =   params.attacker:AddNewModifier(params.attacker,self:GetAbility(),"modifier_sniper_assassinate_accumulate_stack",{})
    
        if(buffModifier) then
            buffModifier:AddStack()    
        end
        
     end

  

    
end
modifier_sniper_assassinate_accumulate_stack = class({})


function modifier_sniper_assassinate_accumulate_stack:IsPurgable()
	return false
end

function modifier_sniper_assassinate_accumulate_stack:IsPurgeException()
	return false
end

function modifier_sniper_assassinate_accumulate_stack:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_sniper_assassinate_accumulate_stack:OnCreated( kv )
    if  IsServer() then
        self.damage  = 100
    end
    
	
	
end
function modifier_sniper_assassinate_accumulate_stack:OnRefresh( kv )
    if  IsServer() then
        self.damage  = 100
    end
	
end
function modifier_sniper_assassinate_accumulate_stack:AddStack()
    if  IsServer() then
        self:IncrementStackCount()
    end
	
   
   
end
--------------------------------------------------------------------------------




function modifier_sniper_assassinate_accumulate_stack:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		
	}

	return funcs
end



function modifier_sniper_assassinate_accumulate_stack:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "sniper_assassinate" then
        return
    end
    if params.target and not params.target:IsNull() and params.target:IsAlive() and not params.target:IsInvulnerable() then
		self.damgeaccumulate = self.damage *self:GetStackCount()
        print(self.damgeaccumulate)
        local damageTable = {
            victim = params.target,
            attacker = params.attacker,
            damage = self.damgeaccumulate,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(), 
        }
        ApplyDamage( damageTable )
    end 
end


