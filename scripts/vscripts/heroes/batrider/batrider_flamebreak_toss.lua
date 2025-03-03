batrider_flamebreak_toss = class( {} )

LinkLuaModifier( "modifier_batrider_flamebreak_toss", "heroes/batrider/batrider_flamebreak_toss", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_batrider_flamebreak_toss_thinker", "heroes/batrider/batrider_flamebreak_toss", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function batrider_flamebreak_toss:Precache( context )	
	PrecacheResource( "particle", "particles/neutral_fx/black_dragon_fireball.vpcf", context )
    PrecacheResource( "particle", "particles/neutral_fx/mud_golem_hurl_boulder.vpcf", context )
end
function batrider_flamebreak_toss:GetIntrinsicModifierName()
	return "modifier_batrider_flamebreak_toss"
end
function batrider_flamebreak_toss:OnSpellStart()
	self.batrider_flamebreak = self:GetCaster():FindAbilityByName("batrider_flamebreak")
    self.hThinker = CreateModifierThinker( self:GetCaster(), self.batrider_flamebreak, "modifier_batrider_flamebreak_toss_thinker", { duration = -1 }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
		if self.hThinker ~= nil then
			local projectile =
			{
				Target = self.hThinker,
				Source = self:GetCaster(),
				Ability = self,
				EffectName = "particles/neutral_fx/mud_golem_hurl_boulder.vpcf",
				iMoveSpeed = self.batrider_flamebreak:GetSpecialValueFor("speed"),
				vSourceLoc = self:GetCaster():GetOrigin(),
				bDodgeable = false,
				bProvidesVision = true,
			}

			ProjectileManager:CreateTrackingProjectile( projectile )
            print("fire projectile")
		end
	
end

function batrider_flamebreak_toss:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		print("impact think")
        if self.hThinker ~= nil then
			local hBuff = self.hThinker:FindModifierByName( "modifier_batrider_flamebreak_toss_thinker" )
			if hBuff ~= nil then
				print("impact think")
                hBuff:OnIntervalThink()
			end
			self.hThinker = nil;
		end
	end

	return true
end

modifier_batrider_flamebreak_toss = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_batrider_flamebreak_toss:IsHidden()
	return true
end

function modifier_batrider_flamebreak_toss:IsPurgeException()
	return false
end

function modifier_batrider_flamebreak_toss:IsPurgable()
	return false
end

function modifier_batrider_flamebreak_toss:IsPermanent()
	return true
end


function modifier_batrider_flamebreak_toss:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_batrider_flamebreak_toss:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_batrider_flamebreak_toss:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "batrider_flamebreak" then
        print("fire flamebreak")
        self.batrider_flamebreak = self:GetParent():FindAbilityByName("batrider_flamebreak")
       
       
        local pos  = self:GetParent():GetCursorPosition()
        self:GetParent():SetCursorPosition(pos)
        self.ability = self:GetAbility()
        self.ability:OnSpellStart()
    
    end
   

end


modifier_batrider_flamebreak_toss_thinker = class({})

----------------------------------------------------------------------------------------

function modifier_batrider_flamebreak_toss_thinker:OnCreated( kv )
	if IsServer() then
		print("create modifier thinker")
        self.radius = self:GetAbility():GetSpecialValueFor( "explosion_radius" )
		self.area_duration = self:GetAbility():GetSpecialValueFor( "damage_duration" )
		self.linger_duration = self:GetAbility():GetSpecialValueFor( "damage_duration" )
		self.bImpact = false
	end
end

----------------------------------------------------------------------------------------

function modifier_batrider_flamebreak_toss_thinker:OnImpact()
	if IsServer() then
		print("impact!")
        local nFXIndex = ParticleManager:CreateParticle( "particles/neutral_fx/black_dragon_fireball.vpcf", PATTACH_WORLDORIGIN, nil );
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() );
		ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetOrigin() );
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( self.area_duration, 0, 0 ) );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		EmitSoundOn( "OgreMagi.Ignite.Target", self:GetParent() )
		
		self:SetDuration( self.area_duration, true )
		self.bImpact = true

		self:StartIntervalThink( 0.5 )
	end
end

----------------------------------------------------------------------------------------

function modifier_batrider_flamebreak_toss_thinker:OnIntervalThink()
	if IsServer() then
		if self.bImpact == false then
			self:OnImpact()
			return
		end
        local damage = math.floor(self:GetAbility():GetSpecialValueFor("damage_impact")*0.5)
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil then
				local damageTable = {
                    victim = enemy,
                    attacker = self:GetCaster(),
                    damage = damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility(), --Optional.
                }
                ApplyDamage( damageTable )
			end
		end
	end
end

----------------------------------------------------------------------------------------