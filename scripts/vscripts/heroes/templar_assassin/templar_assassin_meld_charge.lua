templar_assassin_meld_charge = class( {} )

LinkLuaModifier( "modifier_templar_assassin_meld_charge", "heroes/templar_assassin/templar_assassin_meld_charge", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function templar_assassin_meld_charge:GetIntrinsicModifierName()
	return "modifier_templar_assassin_meld_charge"
end

modifier_templar_assassin_meld_charge = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_templar_assassin_meld_charge:IsHidden()
	return true
end

function modifier_templar_assassin_meld_charge:IsPurgeException()
	return false
end

function modifier_templar_assassin_meld_charge:IsPurgable()
	return false
end

function modifier_templar_assassin_meld_charge:IsPermanent()
	return true
end


function modifier_templar_assassin_meld_charge:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_templar_assassin_meld_charge:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,
	}

	return funcs
end


function  modifier_templar_assassin_meld_charge:OnTakeDamageKillCredit(params)
    if not IsServer() then return end



	if params.attacker ~= self:GetParent()  then
		return
	end
	if params.target:HasModifier("modifier_templar_assassin_meld_armor") then
		self.templar_assassin_refraction = self:GetParent():FindAbilityByName("templar_assassin_refraction")
		if self.templar_assassin_refraction and self.templar_assassin_refraction:GetLevel()>0 then
			local duration = self.templar_assassin_refraction:GetSpecialValueFor("duration")
			if self:GetParent():HasModifier("modifier_templar_assassin_refraction_damage") then
				local buff =self:GetParent():FindModifierByName("modifier_templar_assassin_refraction_damage")
				print("modifier count")
				print(buff:GetStackCount())
				if buff then
					buff:SetStackCount(buff:GetStackCount()+1)
					buff:ForceRefresh()
				end
			else
				local buff1 = self:GetParent():AddNewModifier(self:GetParent(),self.templar_assassin_refraction,"modifier_templar_assassin_refraction_damage",{duration = duration})
				if buff1 then
					buff1:SetStackCount(1)
				end
			end
		end
	end



   
    
		
	

    

end