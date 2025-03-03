spectre_spectral_dagger_desolate = class( {} )

LinkLuaModifier( "modifier_spectre_spectral_dagger_desolate", "heroes/spectre/spectre_spectral_dagger_desolate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_spectral_dagger_desolate_buff", "heroes/spectre/spectre_spectral_dagger_desolate", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function spectre_spectral_dagger_desolate:GetIntrinsicModifierName()
	return "modifier_spectre_spectral_dagger_desolate"
end

modifier_spectre_spectral_dagger_desolate = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_spectral_dagger_desolate:IsHidden()
	return true
end

function modifier_spectre_spectral_dagger_desolate:IsPurgeException()
	return false
end

function modifier_spectre_spectral_dagger_desolate:IsPurgable()
	return false
end

function modifier_spectre_spectral_dagger_desolate:IsPermanent()
	return true
end



function modifier_spectre_spectral_dagger_desolate:OnCreated(kv)
	
	if  IsServer() then		
    	
    end
end



function modifier_spectre_spectral_dagger_desolate:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_MODIFIER_ADDED,
	}

	return funcs
end
function modifier_spectre_spectral_dagger_desolate:OnModifierAdded( params )
   if not IsServer() then
        return
    end
    if params.unit == self:GetParent() then return end
    if  params.added_buff:GetName() == "modifier_spectre_spectral_dagger_in_path" then
       
        self.spectre_desolate =  self:GetParent():FindAbilityByName("spectre_desolate")
        if self.spectre_desolate and self.spectre_desolate:GetLevel()>0 then
            if params.unit and not params.unit:IsMagicImmune() then
                if not  params.unit:HasModifier("modifier_spectre_spectral_dagger_desolate_buff") then
                  
                    params.unit:AddNewModifier(self:GetParent(),self.spectre_desolate,"modifier_spectre_spectral_dagger_desolate_buff",{})
                else
                    local buff = params.unit:FindModifierByName("modifier_spectre_spectral_dagger_desolate_buff")
                    buff:ForceRefresh()
                end
            
            end
            
        end
    end
   

			
end




modifier_spectre_spectral_dagger_desolate_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_spectral_dagger_desolate_buff:IsHidden()
	return true
end

function modifier_spectre_spectral_dagger_desolate_buff:IsPurgeException()
	return false
end

function modifier_spectre_spectral_dagger_desolate_buff:IsPurgable()
	return false
end

function modifier_spectre_spectral_dagger_desolate_buff:IsPermanent()
	return false
end
function modifier_spectre_spectral_dagger_desolate_buff:OnCreated(kv)	
	if  IsServer() then	
		self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage")*0.25
        self:StartIntervalThink(0.5)	
    end
end
function modifier_spectre_spectral_dagger_desolate_buff:OnRefresh(kv)	
	if  IsServer() then	
		self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage")*0.25
        self:StartIntervalThink(0.5)	
    end
end
function modifier_spectre_spectral_dagger_desolate_buff:OnIntervalThink()
    if self:GetParent():HasModifier("modifier_spectre_spectral_dagger_in_path") then
        
        
            
            local damage_table = {
                victim = self:GetParent(),
                attacker = self:GetCaster(),
                damage = self.damage,
                damage_type = DAMAGE_TYPE_PURE,
                ability = self.spectre_desolate
            }
            ApplyDamage(damage_table)
       
    else
        self:StartIntervalThink(-1)
    end
end



