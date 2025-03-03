aghsfort_phantom_assassin_stifling_dagger_attack = class( {} )

LinkLuaModifier( "modifier_aghsfort_phantom_assassin_stifling_dagger_attack", "heroes/phantom_assassin/aghsfort_phantom_assassin_stifling_dagger_attack", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function aghsfort_phantom_assassin_stifling_dagger_attack:GetIntrinsicModifierName()
	return "modifier_aghsfort_phantom_assassin_stifling_dagger_attack"
end


modifier_aghsfort_phantom_assassin_stifling_dagger_attack = class({})
function modifier_aghsfort_phantom_assassin_stifling_dagger_attack:IsPurgable()	return false end
function modifier_aghsfort_phantom_assassin_stifling_dagger_attack:IsPermanent()	return true end
function modifier_aghsfort_phantom_assassin_stifling_dagger_attack:IsHidden()   return true end
function modifier_aghsfort_phantom_assassin_stifling_dagger_attack:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_aghsfort_phantom_assassin_stifling_dagger_attack:OnCreated(kv)
    if IsServer() then
        if IsServer() then
            self.caster = self:GetCaster()
            self.chance = 20
            self:SetHasCustomTransmitterData( true )
        end
    end
end



function modifier_aghsfort_phantom_assassin_stifling_dagger_attack:AddCustomTransmitterData()
	-- on server
	local data = {
		chance =  self.chance
		
	}

	return data
end
function modifier_aghsfort_phantom_assassin_stifling_dagger_attack:HandleCustomTransmitterData( data )
	-- on client
	self.chance = data.chance
	
end
function modifier_aghsfort_phantom_assassin_stifling_dagger_attack:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function  modifier_aghsfort_phantom_assassin_stifling_dagger_attack:OnAttackLanded( params )
    if not IsServer() then
        return
    end
    
    local attacker = params.attacker

    if attacker ~= self:GetParent() then
        return
    end

    if attacker:IsNull() or not attacker:IsAlive() then
        return
    end

    if params.target:IsNull() or not params.target:IsAlive() or params.target:IsBuilding() or params.target:IsOther() then
        return
    end

    if params.no_attack_cooldown then
		return
	end
    self.ability = self:GetParent():FindAbilityByName("phantom_assassin_stifling_dagger")
    local daggerRange = self.ability:GetEffectiveCastRange(self:GetParent():GetAbsOrigin(), nil)
    local enemies = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),	-- int, your team number
        self:GetParent():GetAbsOrigin(),	-- point, center point
        nil,	-- handle, cacheUnit. (not known)
        daggerRange,	-- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_CLOSEST,	-- int, order filter
        false
    )

    if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
        for _, enemy in pairs(enemies) do
            if enemy and not enemy:IsNull() and not enemy:IsInvulnerable()  then
                
                self:GetCaster():SetCursorCastTarget(enemy)
                self.ability:OnSpellStart()    
            end
        end
           
    end
	

    

end