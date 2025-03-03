
modifier_temple_guardian_wrath_thinker = class({})

-----------------------------------------------------------------------------

function modifier_temple_guardian_wrath_thinker:OnCreated( kv )
	if IsServer() then
		self.delay = self:GetAbility():GetSpecialValueFor( "delay" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.radius = self.radius + kv[ "extra_radius" ]
		self.blast_damage = self:GetAbility():GetSpecialValueFor( "blast_damage" )

		self:StartIntervalThink( self.delay )

		local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/dungeon_generic_blast_pre.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, self.delay, 1.0 ) )
		ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 175, 238, 238 ) )
		ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

-----------------------------------------------------------------------------

function modifier_temple_guardian_wrath_thinker:OnIntervalThink()
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/dungeon_generic_blast.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector ( self.radius, self.radius, self.radius ) )
		ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 175, 238, 238 ) )
		ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "TempleGuardian.Wrath.Explosion", self:GetParent() )
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false then
				local damageInfo =
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.blast_damage,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					ability = self:GetAbility(),
				}
				ApplyDamage( damageInfo )
			end
		end

		if RollPercentage( 3 ) then
			local vLocation = self:GetParent():GetAbsOrigin()
			if GridNav:CanFindPath( self:GetCaster():GetAbsOrigin(), vLocation ) then
				local newItem = CreateItem( "item_mana_potion", nil, nil )
				newItem:SetPurchaseTime( 0 )
				if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
					item:SetStacksWithOtherOwners( true )
				end

				local drop = CreateItemOnPositionSync( vLocation, newItem )
				newItem:LaunchLoot( true, 300, 0.75, vLocation,nil )
			end
		end

		UTIL_Remove( self:GetParent() )
	end
end

-----------------------------------------------------------------------------
