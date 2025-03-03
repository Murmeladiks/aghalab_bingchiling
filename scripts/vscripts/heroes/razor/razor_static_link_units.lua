razor_static_link_units = class( {} )

LinkLuaModifier( "modifier_razor_static_link_units", "heroes/razor/razor_static_link_units", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_razor_static_link_units_debuff", "heroes/razor/razor_static_link_units", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_razor_static_link_units_buff", "heroes/razor/razor_static_link_units", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function razor_static_link_units:GetIntrinsicModifierName()
	return "modifier_razor_static_link_units"
end

modifier_razor_static_link_units = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_razor_static_link_units:IsHidden()
	return true
end

function modifier_razor_static_link_units:IsPurgeException()
	return false
end

function modifier_razor_static_link_units:IsPurgable()
	return false
end

function modifier_razor_static_link_units:IsPermanent()
	return true
end


function modifier_razor_static_link_units:OnCreated( kv )
	if IsServer() then
		

    end
end

function modifier_razor_static_link_units:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_razor_static_link_units:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "razor_static_link" then
        return
    end
   
	local count = params.ability:GetSpecialValueFor("drain_rate")*0.2 
	local castrange = params.ability:GetSpecialValueFor("AbilityCastRange")
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(), 
		self:GetParent():GetOrigin(), 
		nil, 
		castrange,
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
		FIND_CLOSEST, 
		false 
	)
	local enemiesToLink = {}
	for _, enemy in pairs(enemies) do
		if enemy and enemy:IsAlive() and not enemy:IsInvulnerable() and  (not params.target or enemy ~= params.target ) then
			table.insert(enemiesToLink, enemy)
		
			if #enemiesToLink == count then
				break
			end
			
		end
	end
	for _, enemy in pairs(enemiesToLink) do
		self:GetParent():SetCursorCastTarget(enemy)
		params.ability:OnSpellStart()
		if 	params.unit:HasAbility("razor_static_link_heal") then
			local duration = params.ability:GetSpecialValueFor("drain_duration")
			if not enemy:HasModifier("modifier_razor_static_link_units_debuff") then
				enemy:AddNewModifier(self:GetParent(),params.ability,"modifier_razor_static_link_units_debuff",{duration=duration})
			else
				enemy:RemoveModifierByName("modifier_razor_static_link_units_debuff")
				enemy:AddNewModifier(self:GetParent(),params.ability,"modifier_razor_static_link_units_debuff",{duration=duration})
			end
			
		end
	end
end


modifier_razor_static_link_units_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_razor_static_link_units_debuff:IsHidden()
	return true
end

function modifier_razor_static_link_units_debuff:IsPurgeException()
	return false
end

function modifier_razor_static_link_units_debuff:IsPurgable()
	return false
end

function modifier_razor_static_link_units_debuff:IsPermanent()
	return false
end

function modifier_razor_static_link_units_debuff:OnCreated( kv )
	if IsServer() then
		
		self.damage = self:GetAbility():GetSpecialValueFor("drain_rate")*2.5
		
		self:StartIntervalThink(1)
		self:OnIntervalThink()
    end
end
function modifier_razor_static_link_units_debuff:OnIntervalThink()
	
	
	if self:GetParent():HasModifier("modifier_razor_static_link_debuff")  then
		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}
		ApplyDamage(damageTable)	
		
	else
		self:StartIntervalThink(-1)
	end
		
end