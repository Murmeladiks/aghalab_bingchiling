sniper_take_aim_shooter = class( {} )

LinkLuaModifier( "modifier_sniper_take_aim_shooter", "heroes/sniper/sniper_take_aim_shooter", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_take_aim_shooter_attackspeed", "heroes/sniper/sniper_take_aim_shooter", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sniper_take_aim_shooter:GetIntrinsicModifierName()
	return "modifier_sniper_take_aim_shooter"
end

modifier_sniper_take_aim_shooter = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_take_aim_shooter:IsHidden()
	return true
end

function modifier_sniper_take_aim_shooter:IsPurgeException()
	return false
end

function modifier_sniper_take_aim_shooter:IsPurgable()
	return false
end

function modifier_sniper_take_aim_shooter:IsPermanent()
	return true
end



function modifier_sniper_take_aim_shooter:OnCreated(kv)
    if IsServer() then
	
    end
end
function modifier_sniper_take_aim_shooter:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end
function modifier_sniper_take_aim_shooter:OnAttackLanded(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
	self.ability = params.attacker:FindAbilityByName("sniper_take_aim")
	local duration = self.ability:GetSpecialValueFor("duration")
	if params.attacker:HasModifier("modifier_sniper_take_aim_bonus") then
		local buffmodifier = params.attacker:AddNewModifier(params.attacker,self:GetAbility(),"modifier_sniper_take_aim_shooter_attackspeed",{duration = duration})
		if buffmodifier then
			buffmodifier:AddStack()
		end
	end

   
end

modifier_sniper_take_aim_shooter_attackspeed = class({})


function modifier_sniper_take_aim_shooter_attackspeed:IsPurgable()
	return false
end

function modifier_sniper_take_aim_shooter_attackspeed:IsPurgeException()
	return false
end

function modifier_sniper_take_aim_shooter_attackspeed:IsPermanent()
	return false
end

--------------------------------------------------------------------------------

function modifier_sniper_take_aim_shooter_attackspeed:OnCreated( kv )
    if  IsServer() then
        self.attackspeed  = 50
		self.duration = kv.duration
    end
    
	
	
end
function modifier_sniper_take_aim_shooter_attackspeed:OnRefresh( kv )
    if  IsServer() then
        self.attackspeed  = 50
    end
	
end
function modifier_sniper_take_aim_shooter_attackspeed:AddStack()
    if  IsServer() then
        self:IncrementStackCount()
        Timers:CreateTimer(self.duration, function()
            if(self and not self:IsNull()) then
                self:DecrementStackCount()
            end
        end)
    end
	
   
   
end
--------------------------------------------------------------------------------




function modifier_sniper_take_aim_shooter_attackspeed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
	}

	return funcs
end



function modifier_sniper_take_aim_shooter_attackspeed:GetModifierAttackSpeedBonus_Constant(params)
	return 50*self:GetStackCount()
end


