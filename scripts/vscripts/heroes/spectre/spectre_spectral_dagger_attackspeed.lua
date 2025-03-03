spectre_spectral_dagger_attackspeed = class( {} )

LinkLuaModifier( "modifier_spectre_spectral_dagger_attackspeed", "heroes/spectre/spectre_spectral_dagger_attackspeed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_spectral_dagger_attackspeed_buff", "heroes/spectre/spectre_spectral_dagger_attackspeed", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function spectre_spectral_dagger_attackspeed:GetIntrinsicModifierName()
	return "modifier_spectre_spectral_dagger_attackspeed"
end

modifier_spectre_spectral_dagger_attackspeed = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_spectral_dagger_attackspeed:IsHidden()
	return true
end

function modifier_spectre_spectral_dagger_attackspeed:IsPurgeException()
	return false
end

function modifier_spectre_spectral_dagger_attackspeed:IsPurgable()
	return false
end

function modifier_spectre_spectral_dagger_attackspeed:IsPermanent()
	return true
end



function modifier_spectre_spectral_dagger_attackspeed:OnCreated(kv)
	
	if  IsServer() then	
        
    end
end




function modifier_spectre_spectral_dagger_attackspeed:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_MODIFIER_ADDED,
	}

	return funcs
end
function modifier_spectre_spectral_dagger_attackspeed:OnModifierAdded( params )
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then return end
    if  params.added_buff:GetName() == "modifier_spectre_spectral_dagger_in_path" then
      
        self.spectre_spectral_dagger = self:GetParent():FindAbilityByName("spectre_spectral_dagger")
        if not  params.unit:HasModifier("modifier_spectre_spectral_dagger_attackspeed_buff") then  
            params.unit:AddNewModifier(self:GetParent(),self.spectre_spectral_dagger,"modifier_spectre_spectral_dagger_attackspeed_buff",{})
        end 
        
    end			
end




modifier_spectre_spectral_dagger_attackspeed_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_spectral_dagger_attackspeed_buff:IsHidden()
	return true
end

function modifier_spectre_spectral_dagger_attackspeed_buff:IsPurgeException()
	return false
end

function modifier_spectre_spectral_dagger_attackspeed_buff:IsPurgable()
	return false
end

function modifier_spectre_spectral_dagger_attackspeed_buff:IsPermanent()
	return false
end
function modifier_spectre_spectral_dagger_attackspeed_buff:OnCreated(kv)	
	if  IsServer() then	
        
        self:StartIntervalThink(0.2)  	   
    end
end
function modifier_spectre_spectral_dagger_attackspeed_buff:OnRefresh(kv)	
	if  IsServer() then	
        self:StartIntervalThink(0.2)  	   
    end
end
function modifier_spectre_spectral_dagger_attackspeed_buff:OnIntervalThink()	

        if not self:GetParent():HasModifier("modifier_spectre_spectral_dagger_in_path") then    
            self:GetParent():RemoveModifierByName("modifier_spectre_spectral_dagger_attackspeed_buff")
        end

end
function modifier_spectre_spectral_dagger_attackspeed_buff:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
	}
	return funcs
end

function modifier_spectre_spectral_dagger_attackspeed_buff:GetModifierAttackSpeedPercentage()       
    
        return  self:GetAbility():GetSpecialValueFor("bonus_movespeed")  
    
end
