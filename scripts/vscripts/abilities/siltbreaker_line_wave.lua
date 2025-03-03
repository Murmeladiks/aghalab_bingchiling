
siltbreaker_line_wave = class({})
LinkLuaModifier( "modifier_siltbreaker_bubble", "modifiers/modifier_siltbreaker_bubble", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function siltbreaker_line_wave:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function siltbreaker_line_wave:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle(  "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 150, 150, 150 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 0, 220, 220 ) )

		EmitSoundOn( "Siltbreaker.LineWave.PreCast", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function siltbreaker_line_wave:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		StopSoundOn( "Siltbreaker.LineWave.PreCast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function siltbreaker_line_wave:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
        self.projectile_radius = self:GetSpecialValueFor( "projectile_radius" )
		self.cast_range = self:GetSpecialValueFor( "cast_range" )

		local vTargetPos = nil
		if self:GetCursorTarget() then
            vTargetPos = self:GetCursorTarget():GetOrigin()
        else
            vTargetPos = self:GetCursorPosition()
        end

		local vDir = vTargetPos - self:GetCaster():GetOrigin()
		vDir.z = 0.0
		vDir = vDir:Normalized()

		local info = {
			Source = self:GetCaster(),
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(), 
			bDeleteOnHit = true,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			EffectName = "particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_projectile.vpcf",
			fDistance = self.cast_range,
			
			fStartRadius = 115,
			fEndRadius = 115,
			vVelocity = vDir * self.projectile_speed,
			
			
			
			
		}
		ProjectileManager:CreateLinearProjectile( info )

		StopSoundOn( "Siltbreaker.LineWave.PreCast", self:GetCaster() )
		EmitSoundOn( "Siltbreaker.LineWave.Cast", self:GetCaster() )
	end
end

-------------------------------------------------------------------------------

function siltbreaker_line_wave:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and hTarget:IsRealHero() and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			local duration = -1
			if self:IsSinglePlayer() then
				duration = 5
			end
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_siltbreaker_bubble", { duration = duration } )
			EmitSoundOn( "Siltbreaker.LineWave.Impact", hTarget )

			return true
		end
	end

	return false
end
function siltbreaker_line_wave:IsSinglePlayer()
	
	local nPlayers = {}
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			table.insert(nPlayers, nPlayerID)
		end	
	end
	local length = table.getn(nPlayers)
	if length > 1 then
		return false
	else
		return true
	end

end
-------------------------------------------------------------------------------

