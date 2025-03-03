riki_tricks_of_the_trade_cudgel = class( {} )

LinkLuaModifier( "modifier_riki_tricks_of_the_trade_cudgel", "heroes/riki/riki_tricks_of_the_trade_cudgel", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_riki_tricks_of_the_trade_cudgel_buff", "heroes/riki/riki_tricks_of_the_trade_cudgel", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function riki_tricks_of_the_trade_cudgel:GetIntrinsicModifierName()
	return "modifier_riki_tricks_of_the_trade_cudgel"
end

modifier_riki_tricks_of_the_trade_cudgel = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_riki_tricks_of_the_trade_cudgel:IsHidden()
	return true
end

function modifier_riki_tricks_of_the_trade_cudgel:IsPurgeException()
	return false
end

function modifier_riki_tricks_of_the_trade_cudgel:IsPurgable()
	return false
end

function modifier_riki_tricks_of_the_trade_cudgel:IsPermanent()
	return true
end



function modifier_riki_tricks_of_the_trade_cudgel:OnCreated(kv)
    if IsServer() then
		
    end
end

function modifier_riki_tricks_of_the_trade_cudgel:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end

function modifier_riki_tricks_of_the_trade_cudgel:OnAbilityFullyCast(params)

	if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    
	if params.ability:GetAbilityName() == "riki_tricks_of_the_trade" then
		local duration = 2
		params.unit:AddNewModifier(params.unit,params.ability,"modifier_riki_tricks_of_the_trade_cudgel_buff",{duration = duration})
		
    end
end


modifier_riki_tricks_of_the_trade_cudgel_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_riki_tricks_of_the_trade_cudgel_buff:IsHidden()
	return true
end

function modifier_riki_tricks_of_the_trade_cudgel_buff:IsPurgeException()
	return false
end

function modifier_riki_tricks_of_the_trade_cudgel_buff:IsPurgable()
	return false
end

function modifier_riki_tricks_of_the_trade_cudgel_buff:IsPermanent()
	return false
end

function modifier_riki_tricks_of_the_trade_cudgel_buff:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end


function modifier_riki_tricks_of_the_trade_cudgel_buff:OnCreated(kv)
    if IsServer() then
		
        self.damage_radius = 250
		self.stun_duration = 1.0
    end
end
function modifier_riki_tricks_of_the_trade_cudgel_buff:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_riki_tricks_of_the_trade_cudgel_buff:OnAttackLanded( params )
    if IsServer() then
        local Attacker = params.attacker
        local Target = params.target

        if not Attacker or not Target then
            return
        end

        if Attacker ~= self:GetParent()  then
            return
        end


        local enemies = FindUnitsInRadius( Attacker:GetTeamNumber(), Target:GetOrigin(), Attacker, self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
        for _,enemy in pairs( enemies ) do
            if enemy ~= nil and not enemy:IsNull() and enemy:IsInvulnerable() == false then
                if enemy ~= Target then
                    local damageInfo = 
                    {
                        victim = enemy,
                        attacker = Attacker,
                        damage = params.original_damage,
                        damage_type = DAMAGE_TYPE_PHYSICAL,
                        ability = self:GetAbility(),
                    }
                    ApplyDamage( damageInfo )
                end
                if enemy:IsAlive() == false then
                    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
                    ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
                    ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
                    ParticleManager:SetParticleControlForward( nFXIndex, 1, -Attacker:GetForwardVector() )
                    ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
                    ParticleManager:ReleaseParticleIndex( nFXIndex )

                    EmitSoundOn( "Dungeon.BloodSplatterImpact.Medium", enemy )
                else
                    enemy:AddNewModifier( Attacker, self:GetAbility(), "modifier_stunned", { duration = self.stun_duration } )
                end
            end
        end

        
    end

    return 0
end