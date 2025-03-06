modifier_axe_battle_hunger_lua = class({})

function modifier_axe_battle_hunger_lua:IsHidden() return false end
function modifier_axe_battle_hunger_lua:IsDebuff() return false end
function modifier_axe_battle_hunger_lua:IsPurgable() return false end


function modifier_axe_battle_hunger_lua:OnCreated( kv )
	self.bonus = self:GetAbility():GetSpecialValueFor( "speed_bonus" )

	if not IsServer() then return end
	self:SetStackCount( 1 )	
end

function modifier_axe_battle_hunger_lua:OnRefresh( kv )
	self.bonus = self:GetAbility():GetSpecialValueFor( "speed_bonus" )

	if not IsServer() then return end
	self:IncrementStackCount()	
end


function modifier_axe_battle_hunger_lua:OnStackCountChanged( old )
	if not IsServer() then return end

	if self:GetStackCount() < 1 then
		self:Destroy()
	end
end

function modifier_axe_battle_hunger_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,		
	}
end


function modifier_axe_battle_hunger_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus * self:GetStackCount()
end
