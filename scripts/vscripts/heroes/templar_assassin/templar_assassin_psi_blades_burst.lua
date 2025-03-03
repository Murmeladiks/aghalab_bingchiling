templar_assassin_psi_blades_burst = class( {} )

LinkLuaModifier( "modifier_templar_assassin_psi_blades_burst", "heroes/templar_assassin/templar_assassin_psi_blades_burst", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function templar_assassin_psi_blades_burst:GetIntrinsicModifierName()
	return "modifier_templar_assassin_psi_blades_burst"
end

modifier_templar_assassin_psi_blades_burst = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_templar_assassin_psi_blades_burst:IsHidden()
	return true
end

function modifier_templar_assassin_psi_blades_burst:IsPurgeException()
	return false
end

function modifier_templar_assassin_psi_blades_burst:IsPurgable()
	return false
end

function modifier_templar_assassin_psi_blades_burst:IsPermanent()
	return true
end


function modifier_templar_assassin_psi_blades_burst:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_templar_assassin_psi_blades_burst:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function  modifier_templar_assassin_psi_blades_burst:OnAttackLanded(params)
    if not IsServer() then return end



	if params.attacker ~= self:GetParent()  then
		return
	end
	
	
	self.templar_assassin_psi_blades = self:GetParent():FindAbilityByName("templar_assassin_psi_blades")
	if self.templar_assassin_psi_blades and self.templar_assassin_psi_blades:GetLevel()>0 then
			
		if params.target then
			local radius = 175
			local damage = self:GetParent():GetAverageTrueAttackDamage(nil)
			self.damageTable = {
				-- victim = target,
				attacker = self:GetParent(),
				damage = damage,	
				damage_type = DAMAGE_TYPE_PURE,
				ability = self:GetAbility(), --Optional.
				}
	
				local enemies = FindUnitsInRadius( 
					self:GetParent():GetTeamNumber(), 
					params.target:GetAbsOrigin(), 
					nil, 
					radius, 
					DOTA_UNIT_TARGET_TEAM_ENEMY, 
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
					0, 
					false
				 )
					for _,enemy in pairs(enemies) do
						if enemy and enemy~=params.target and not enemy:IsNull() and enemy:IsAlive() and not enemy:IsInvulnerable()  then
							self.damageTable.victim = enemy
							ApplyDamage( self.damageTable )
						end
					end
		end
	end	

end