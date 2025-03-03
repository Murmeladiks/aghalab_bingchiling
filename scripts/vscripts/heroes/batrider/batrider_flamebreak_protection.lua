batrider_flamebreak_protection = class( {} )

LinkLuaModifier( "modifier_batrider_flamebreak_protection", "heroes/batrider/batrider_flamebreak_protection", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_batrider_flamebreak_protection_buff", "heroes/batrider/batrider_flamebreak_protection", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function batrider_flamebreak_protection:GetIntrinsicModifierName()
	return "modifier_batrider_flamebreak_protection"
end
function batrider_flamebreak_protection:OnProjectileHit( target, location)
    if not IsServer() then
        return
    end

    if not target then return end

    -- perform attack as apply dmg:
    local attackDmg = self:GetCaster():GetAverageTrueAttackDamage(target)
    local dmgReduction =  0

    local finalDmgReduction = attackDmg * (100 - math.min(dmgReduction, 100))/100

    local damageTable = {
        victim = target,
        attacker = self:GetCaster(),
        damage = finalDmgReduction,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self, --Optional.
        damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
    }

    ApplyDamage(damageTable)
end

modifier_batrider_flamebreak_protection = class({})
function modifier_batrider_flamebreak_protection:IsPurgable()	return false end
function modifier_batrider_flamebreak_protection:IsPermanent()	return true end
function modifier_batrider_flamebreak_protection:IsHidden()   return true end

function modifier_batrider_flamebreak_protection:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.blockedOrbs = {
        drow_ranger_frost_arrows = true,
        ancient_apparition_chilling_touch = true,
        enchantress_impetus = true,
        viper_poison_attack = true,
        clinkz_searing_arrows = true,
        obsidian_destroyer_arcane_orb = true,
        silencer_glaives_of_wisdom = true
    }

    self.blockPassives = {
        templar_assassin_psi_blades = true,
        drow_ranger_marksmanship = true
    }

    self.use_modifier = false
    self.projectile_name = self:GetParent():GetRangedProjectileName()
	self.projectile_speed = self:GetParent():GetProjectileSpeed()
    self.maxAttacks = 5
end

function modifier_batrider_flamebreak_protection:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
        MODIFIER_EVENT_ON_ATTACK,
	}

	return funcs
end
function modifier_batrider_flamebreak_protection:OnAttack(params)
    if not IsServer() then
        return
    end

    local attacker = params.attacker

    if attacker ~= self:GetParent() then
        return
    end

    if attacker:IsNull() or not attacker:IsAlive() or not attacker:IsRangedAttacker() then
        return
    end

    if params.no_attack_cooldown then
		return
	end 
    if not attacker:HasModifier("modifier_batrider_flamebreak_protection_buff") then
        return
    end
    if self.split_shot then return end

    self:SplitShot( params.target, self.use_modifier)
end
function modifier_batrider_flamebreak_protection:SplitShot(target, useModifiers )
    local attacker = self:GetParent()

    local enemies = FindUnitsInRadius(
        attacker:GetTeamNumber(),	-- int, your team number
        attacker:GetAbsOrigin(),	-- point, center point
        nil,	-- handle, cacheUnit. (not known)
        self:GetParent():Script_GetAttackRange()+100,	-- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER,	-- int, type filter
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
        FIND_ANY_ORDER,	-- int, order filter
        false	-- bool, can grow cache
    )

    local attacksPerform = {}

    local extraAttack = 0
    for _, enemy in ipairs(enemies) do
        if enemy and not enemy:IsNull() and enemy:IsAlive() and enemy ~= target then    
            if extraAttack >= self.maxAttacks then
                break
            end

            table.insert(attacksPerform, enemy)
            extraAttack = extraAttack + 1
        end
    end

    if #attacksPerform == 0 then
        return
    end

    if not useModifiers then
        for _, enemy in ipairs(attacksPerform) do
            -- launch projectile
			local info = {
				Target = enemy,
				Source = self:GetParent(),
				Ability = self:GetAbility(),	
				
				EffectName = self.projectile_name,
				iMoveSpeed = self.projectile_speed,
				bDodgeable = true,
			}

			ProjectileManager:CreateTrackingProjectile(info)
        end
    else
        local abilityToBlock = nil
        local abilityBlocked = false
    
        for abilityName, _ in pairs(self.blockedOrbs) do
            if self:GetParent():HasAbility(abilityName) then
                local ability = self:GetParent():FindAbilityByName(abilityName)
                if ability and ability:GetLevel() > 0 then
                    abilityToBlock = ability
                end
                break
            end
        end
        
        local passivesBlocked = {}

        for _, enemy in ipairs(attacksPerform) do
            self.split_shot = true
            self:GetParent():SetIntAttr("noProc", 1)
    
            --block auto-cast ability
            if abilityToBlock and abilityToBlock:GetAutoCastState() then 
                abilityToBlock:ToggleAutoCast()
                abilityBlocked = true
            end
    
            --block passives    
            for passiveName, _ in pairs(self.blockPassives) do
                if self:GetParent():HasAbility(passiveName) then
                    local ability = self:GetParent():FindAbilityByName(passiveName)
                    if ability and ability:GetLevel() > 0  then
                        local currentLevel = ability:GetLevel()
        
                        ability:SetLevel(0)
                        passivesBlocked[passiveName] = {
                            level = currentLevel
                        }
                    end
                end
            end
    
            attacker:PerformAttack(enemy, false, true, true, true, true, false, false)
            self.split_shot = false
            self:GetParent():SetIntAttr("noProc", 0)
        end

        --unlock auto-cast abilities
        if abilityBlocked and abilityToBlock then
            abilityToBlock:ToggleAutoCast()
            abilityBlocked = false
        end

        --unlock passives
        for passiveName, info in pairs(passivesBlocked) do
            local passiveToUnlock = self:GetParent():FindAbilityByName(passiveName)
            if passiveToUnlock and passiveToUnlock:GetLevel() == 0 and info.level and info.level > 0 then
                passiveToUnlock:SetLevel(info.level)
                passivesBlocked[passiveName] = nil
            end
        end

    end
end
function modifier_batrider_flamebreak_protection:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "batrider_flamebreak" then
        return
    end
    
    self.ability = self:GetParent():FindAbilityByName("batrider_flamebreak")
    local duration = self.ability:GetSpecialValueFor("damage_duration")
     --self
    if not self:GetParent():HasModifier("modifier_batrider_flamebreak_protection_buff") then
        self:GetParent():AddNewModifier(self:GetParent(),self.ability,"modifier_batrider_flamebreak_protection_buff",{duration = duration}) 
        
    else
        local buff =  self:GetParent():FindModifierByName("modifier_batrider_flamebreak_protection_buff")
        buff:ForceRefresh()
        
    end
    
        
        
   
        
end

modifier_batrider_flamebreak_protection_buff = class({})
function modifier_batrider_flamebreak_protection_buff:Precache( context )
end
function modifier_batrider_flamebreak_protection_buff:IsPurgable()	return false end
function modifier_batrider_flamebreak_protection_buff:IsPermanent()	return false end
function modifier_batrider_flamebreak_protection_buff:IsHidden()   return false end
function modifier_batrider_flamebreak_protection_buff:OnCreated(kv)
    if  IsServer() then        
    end      
end

function modifier_batrider_flamebreak_protection_buff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,

    }
    return funcs
end

function modifier_batrider_flamebreak_protection_buff:GetModifierAttackSpeedPercentage(params)
	return 100
end

function modifier_batrider_flamebreak_protection_buff:GetModifierAttackSpeed_Limit(params)
	return 1
end
function modifier_batrider_flamebreak_protection_buff:GetModifierIncomingDamage_Percentage( params )
    return -50
end