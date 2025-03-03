item_arcanist_potion = class({})
LinkLuaModifier( "modifier_item_arcanist_potion", "modifiers/modifier_item_arcanist_potion", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------


function item_arcanist_potion:OnSpellStart()
	if IsServer() then
		local kv =
		{
			duration = self:GetSpecialValueFor( "duration" ),
		}

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_arcanist_potion", kv )

		EmitSoundOn( "SpellAmpPotion.Activate", self:GetCaster() )

		self:SpendCharge(0)
	end
end