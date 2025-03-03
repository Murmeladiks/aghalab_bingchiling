razor_static_link_heal = class( {} )

LinkLuaModifier( "modifier_razor_static_link_heal", "heroes/razor/razor_static_link_heal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_razor_static_link_heal_debuff", "heroes/razor/razor_static_link_heal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_razor_static_link_heal_buff", "heroes/razor/razor_static_link_heal", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function razor_static_link_heal:GetIntrinsicModifierName()
	return "modifier_razor_static_link_heal"
end

modifier_razor_static_link_heal = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_razor_static_link_heal:IsHidden()
	return true
end

function modifier_razor_static_link_heal:IsPurgeException()
	return false
end

function modifier_razor_static_link_heal:IsPurgable()
	return false
end

function modifier_razor_static_link_heal:IsPermanent()
	return true
end


function modifier_razor_static_link_heal:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_razor_static_link_heal:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_razor_static_link_heal:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "razor_static_link" then
        return
    end
	if params.target and not params.target:IsNull() and params.target:IsAlive() then
		local duration = params.ability:GetSpecialValueFor("drain_duration")
		
		if not params.target:HasModifier("modifier_razor_static_link_heal_debuff") then
			params.target:AddNewModifier(self:GetParent(),params.ability,"modifier_razor_static_link_heal_debuff",{duration=duration})
		else
			params.target:RemoveModifierByName("modifier_razor_static_link_heal_debuff")
			params.target:AddNewModifier(self:GetParent(),params.ability,"modifier_razor_static_link_heal_debuff",{duration=duration})
		end
		if not self:GetParent():HasModifier("modifier_razor_static_link_heal_buff") then
			self:GetParent():AddNewModifier(self:GetParent(),params.ability,"modifier_razor_static_link_heal_buff",{duration=duration})
		else
			self:GetParent():RemoveModifierByName("modifier_razor_static_link_heal_buff")
			self:GetParent():AddNewModifier(self:GetParent(),params.ability,"modifier_razor_static_link_heal_buff",{duration=duration})
		end
	end

end

modifier_razor_static_link_heal_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_razor_static_link_heal_debuff:IsHidden()
	return true
end

function modifier_razor_static_link_heal_debuff:IsPurgeException()
	return false
end

function modifier_razor_static_link_heal_debuff:IsPurgable()
	return false
end

function modifier_razor_static_link_heal_debuff:IsPermanent()
	return false
end

function modifier_razor_static_link_heal_debuff:OnCreated( kv )
	if IsServer() then
		
		self.damage = self:GetAbility():GetSpecialValueFor("drain_rate")*2.5
		
		self:StartIntervalThink(1)
		self:OnIntervalThink()
    end
end
function modifier_razor_static_link_heal_debuff:OnIntervalThink()
	
	
	if self:GetParent():HasModifier("modifier_razor_static_link_debuff")  then
		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}
		ApplyDamage(damageTable)	
		
	else
		self:StartIntervalThink(-1)
	end
		
end
modifier_razor_static_link_heal_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_razor_static_link_heal_buff:IsHidden()
	return true
end

function modifier_razor_static_link_heal_buff:IsPurgeException()
	return false
end

function modifier_razor_static_link_heal_buff:IsPurgable()
	return false
end

function modifier_razor_static_link_heal_buff:IsPermanent()
	return false
end

function modifier_razor_static_link_heal_buff:OnCreated( kv )
	if IsServer() then
		
		self.heal = self:GetAbility():GetSpecialValueFor("drain_rate")*2.5
		self:StartIntervalThink(1)
		self:OnIntervalThink()
    end
end
function modifier_razor_static_link_heal_buff:OnIntervalThink()
	self:GetParent():Heal(self.heal, self:GetAbility())		
end