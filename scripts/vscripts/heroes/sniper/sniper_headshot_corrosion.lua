sniper_headshot_corrosion = class( {} )

LinkLuaModifier( "modifier_sniper_headshot_corrosion", "heroes/sniper/sniper_headshot_corrosion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_headshot_corrosion_armor", "heroes/sniper/sniper_headshot_corrosion", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sniper_headshot_corrosion:GetIntrinsicModifierName()
	return "modifier_sniper_headshot_corrosion"
end

modifier_sniper_headshot_corrosion = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_headshot_corrosion:IsHidden()
	return true
end

function modifier_sniper_headshot_corrosion:IsPurgeException()
	return false
end

function modifier_sniper_headshot_corrosion:IsPurgable()
	return false
end

function modifier_sniper_headshot_corrosion:IsPermanent()
	return true
end



function modifier_sniper_headshot_corrosion:OnCreated(kv)
    if IsServer() then
	
    end
end
function modifier_sniper_headshot_corrosion:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end
function modifier_sniper_headshot_corrosion:OnAttackLanded(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    self.ability = params.attacker:FindAbilityByName("sniper_headshot")
    if  params.target:HasModifier("modifier_sniper_headshot_slow") then
        local buffmodifier =  params.target:AddNewModifier(params.attacker,self.ability,"modifier_sniper_headshot_corrosion_armor",{duration = 7})
        if buffmodifier then
            buffmodifier:AddStack()
        end
    end

   
end

modifier_sniper_headshot_corrosion_armor = class({})


function modifier_sniper_headshot_corrosion_armor:IsPurgable()
	return false
end

function modifier_sniper_headshot_corrosion_armor:IsPurgeException()
	return false
end

function modifier_sniper_headshot_corrosion_armor:IsPermanent()
	return false
end

--------------------------------------------------------------------------------

function modifier_sniper_headshot_corrosion_armor:OnCreated( kv )
    if  IsServer() then
        self.armor  = 2
		
    end
    
	
	
end
function modifier_sniper_headshot_corrosion_armor:OnRefresh( kv )
    if  IsServer() then
        self.armor  = 2
    end
	
end
function modifier_sniper_headshot_corrosion_armor:AddStack()
    if  IsServer() then
        self:IncrementStackCount()
        Timers:CreateTimer(7, function()
            if(self and not self:IsNull()) then
                self:DecrementStackCount()
            end
        end)
    end
	
   
   
end
--------------------------------------------------------------------------------




function modifier_sniper_headshot_corrosion_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		
	}

	return funcs
end



function modifier_sniper_headshot_corrosion_armor:GetModifierPhysicalArmorBonus(params)
	return -2*self:GetStackCount()
end


