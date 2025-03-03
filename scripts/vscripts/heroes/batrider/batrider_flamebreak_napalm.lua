batrider_flamebreak_napalm = class( {} )

LinkLuaModifier( "modifier_batrider_flamebreak_napalm", "heroes/batrider/batrider_flamebreak_napalm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_batrider_flamebreak_napalm_thinker", "heroes/batrider/batrider_flamebreak_napalm", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function batrider_flamebreak_napalm:Precache( context )	
	
end
function batrider_flamebreak_napalm:GetIntrinsicModifierName()
	return "modifier_batrider_flamebreak_napalm"
end


modifier_batrider_flamebreak_napalm = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_batrider_flamebreak_napalm:IsHidden()
	return true
end

function modifier_batrider_flamebreak_napalm:IsPurgeException()
	return false
end

function modifier_batrider_flamebreak_napalm:IsPurgable()
	return false
end

function modifier_batrider_flamebreak_napalm:IsPermanent()
	return true
end


function modifier_batrider_flamebreak_napalm:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_batrider_flamebreak_napalm:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end


function  modifier_batrider_flamebreak_napalm:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    
        
    if params.inflictor and params.inflictor:GetAbilityName() == "batrider_flamebreak" then
        self.batrider_sticky_napalm = self:GetCaster():FindAbilityByName("batrider_sticky_napalm")
		if self.batrider_sticky_napalm and self.batrider_sticky_napalm:GetLevel()>0 then
			if not params.unit:HasModifier("modifier_batrider_flamebreak_napalm_thinker") then
				params.unit:AddNewModifier(self:GetParent(), params.inflictor, "modifier_batrider_flamebreak_napalm_thinker", {})
			end
		end
    end
   

end


modifier_batrider_flamebreak_napalm_thinker = class({})
function modifier_batrider_flamebreak_napalm_thinker:IsHidden()
	return true
end

function modifier_batrider_flamebreak_napalm_thinker:IsPurgeException()
	return false
end

function modifier_batrider_flamebreak_napalm_thinker:IsPurgable()
	return false
end

function modifier_batrider_flamebreak_napalm_thinker:IsPermanent()
	return false
end

----------------------------------------------------------------------------------------

function modifier_batrider_flamebreak_napalm_thinker:OnCreated( kv )
	if IsServer() then
		self.count  = 0
		self.batrider_sticky_napalm = self:GetCaster():FindAbilityByName("batrider_sticky_napalm")
        
		self:StartIntervalThink( 0.5 )
		
	end
end

----------------------------------------------------------------------------------------

function modifier_batrider_flamebreak_napalm_thinker:OnIntervalThink()
	if IsServer() then
		self.count  = self.count + 1
		print(self.count)
		
		
			local duration = self.batrider_sticky_napalm:GetSpecialValueFor("duration")
			if self:GetParent():HasModifier("modifier_flamebreak_damage") then
				if not self:GetParent():HasModifier("modifier_batrider_sticky_napalm") then
					local hbuff = self:GetParent():AddNewModifier(self:GetCaster(),self.batrider_sticky_napalm,"modifier_batrider_sticky_napalm",{duration = duration})
					hbuff:SetStackCount(1)
					self.count  = 0
				else
					local buff  = self:GetParent():FindModifierByName("modifier_batrider_sticky_napalm")
					
					if self:GetCaster():HasAbility("special_bonus_unique_batrider_sticky_napalm_infinity") then
					
						buff:SetStackCount(buff:GetStackCount()+self.count)
						buff:ForceRefresh()
					else
						local buffcount = buff:GetStackCount()
						if buffcount < 10 then
							buff:SetStackCount(buff:GetStackCount()+self.count)
							buff:ForceRefresh()
						else
							buff:SetStackCount(9)
							buff:ForceRefresh()
						end
					end
				end
			else
				self:StartIntervalThink( -1 )
				self:GetParent():RemoveModifierByName("modifier_batrider_flamebreak_napalm_thinker")
			end
		
        
	end
end

----------------------------------------------------------------------------------------