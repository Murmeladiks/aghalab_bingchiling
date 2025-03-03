sniper_concussive_grenade_shard = class( {} )

--LinkLuaModifier( "modifier_sniper_concussive_grenade_shard", "heroes/sniper/sniper_concussive_grenade_shard", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function sniper_concussive_grenade_shard:GetIntrinsicModifierName()
	return "modifier_item_aghanims_shard"
end

-- modifier_sniper_concussive_grenade_shard = class({})

-- --------------------------------------------------------------------------------
-- -- Classifications
-- function modifier_sniper_concussive_grenade_shard:IsHidden()
-- 	return true
-- end

-- function modifier_sniper_concussive_grenade_shard:IsPurgeException()
-- 	return false
-- end

-- function modifier_sniper_concussive_grenade_shard:IsPurgable()
-- 	return false
-- end

-- function modifier_sniper_concussive_grenade_shard:IsPermanent()
-- 	return true
-- end



-- function modifier_sniper_concussive_grenade_shard:OnCreated(kv)
--     if IsServer() then
-- 		self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_item_aghanims_shard",{})
--     end
-- end
-- function modifier_sniper_concussive_grenade_shard:DeclareFunctions()
--     return {
--         MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
--     }
-- end
-- function modifier_sniper_concussive_grenade_shard:OnAbilityFullyCast(params)
--     if not IsServer() then
--         return
--     end

--     if params.unit ~= self:GetParent() then
--         return
--     end

--     if params.ability:GetAbilityName() ~= "sniper_concussive_grenade" then
--         return
--     end
--     local unit = self:GetParent()
--     self.sniper_concussive_grenade = unit:FindAbilityByName("sniper_concussive_grenade")
-- 	self.sniper_assassinate = unit:FindAbilityByName("sniper_assassinate")
    
-- 	local radius =self.sniper_concussive_grenade:GetSpecialValueFor("radius")
--     local cursorPos = params.ability:GetCursorPosition()
-- 	self.damage = self.sniper_assassinate:GetAbilityDamage() 
--     print(self.damage)
	
	
--     local enemies = FindUnitsInRadius(
--         unit:GetTeamNumber(),
--         cursorPos, 
--         nil, 
--         radius, 
--         DOTA_UNIT_TARGET_TEAM_ENEMY, 
--         DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
--         DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
--         0, 
--         false 
--     )


--     for _,enemy in pairs(enemies) do
--         if enemy and not enemy:IsNull() and enemy:IsAlive() and not enemy:IsInvulnerable() then
-- 			if self.sniper_assassinate:GetLevel()> 0  then
-- 				local damageTable = {
-- 					victim = enemy,
-- 					attacker = unit,
-- 					damage = self.damage,
-- 					damage_type = DAMAGE_TYPE_MAGICAL,
-- 					ability = self:GetAbility(), 
-- 				}
-- 				ApplyDamage( damageTable )
				
-- 			end 
			
--         end
--     end
    


  

   
-- end





