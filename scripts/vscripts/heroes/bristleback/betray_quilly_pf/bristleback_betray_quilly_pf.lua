LinkLuaModifier("modifier_quilly_betrayal_count", "heroes/bristleback/betray_quilly_pf/bristleback_betray_quilly_pf", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

bristleback_betray_quilly_pf = class({})

--------------------------------------------------------------------------------

function bristleback_betray_quilly_pf:Spawn()
	if IsClient() then return end
	self:SetLevel(1)
end

--------------------------------------------------------------------------------

function bristleback_betray_quilly_pf:OnSpellStart()
	local caster = self:GetCaster()
	local quilly = caster.quilly
	local flHPRatio = math.min( 1.0, quilly:GetMaxHealth() / 200 )

	if quilly and not quilly:IsNull() and quilly:IsAlive() then
		quilly:Kill(self, caster)

		local projectile = {
			Target = caster,
			Source = quilly,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
			Ability = self,
			EffectName = "particles/units/heroes/hero_nevermore/sf_necromastery_attack.vpcf",
			iMoveSpeed = 900,
			vSourceLoc = quilly:GetAbsOrigin(),
			bDrawsOnMinimap = false,
			bDodgeable = false,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 50,
			bProvidesVision = false,
			iVisionRadius = 0,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		ProjectileManager:CreateTrackingProjectile(projectile)
	end

	caster:AddNewModifier(caster, self, "modifier_quilly_betrayal_count", {})

	-- here's the pfx stuff
	quilly:EmitSound("Bristleback.BetrayQuilly")
	EmitSoundOnLocationWithCaster(quilly:GetAbsOrigin(), "Bristleback.QuillysBetrayal", caster)

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_betray_quilly.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, quilly:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx)

	local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(nFXIndex, 0, quilly, PATTACH_POINT_FOLLOW, "attach_hitloc", quilly:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(nFXIndex, 1, quilly:GetAbsOrigin())
	ParticleManager:SetParticleControlForward( nFXIndex, 1, RandomFloat( 0.5, 1.0 ) * flHPRatio * ( caster:GetAbsOrigin() - quilly:GetAbsOrigin() ):Normalized() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 10, quilly, PATTACH_ABSORIGIN_FOLLOW, "", quilly:GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	quilly:AddNoDraw()

	local call_quilly = caster:FindAbilityByName("bristleback_call_quilly_pf")
	if call_quilly and not call_quilly:IsNull() then
		call_quilly:UseResources(false, false, false, true)
	end
end

--------------------------------------------------------------------------------

function bristleback_betray_quilly_pf:OnProjectileHit(hTarget, vLocation)
	if not hTarget then return end
	local caster = self:GetCaster()

	local multiplier = self:GetSpecialValueFor("maximum_health_mana_regen")
	local healing = caster:GetMaxHealth() * multiplier / 100
	local mana_restore = caster:GetMaxMana() * multiplier / 100

	caster:Heal(healing, self)
	caster:GiveMana(mana_restore)

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, healing, nil)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, mana_restore, nil)
end

--------------------------------------------------------------------------------

modifier_quilly_betrayal_count = class({})

--------------------------------------------------------------------------------

function modifier_quilly_betrayal_count:IsPurgable() 		return false end
function modifier_quilly_betrayal_count:RemoveOnDeath()		return false end
function modifier_quilly_betrayal_count:IsPermanent()		return true end
function modifier_quilly_betrayal_count:GetAttributes()		return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

--------------------------------------------------------------------------------

function modifier_quilly_betrayal_count:OnCreated()
	if not IsServer() then return end
	self:SetStackCount(1)
end

--------------------------------------------------------------------------------

function modifier_quilly_betrayal_count:OnRefresh()
	if not IsServer() then return end
	self:IncrementStackCount()
end