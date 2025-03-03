riki_smoke_screen_shard = class( {} )

LinkLuaModifier( "modifier_riki_smoke_screen_shard", "heroes/riki/riki_smoke_screen_shard", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_riki_smoke_screen_shard_thinker", "heroes/riki/riki_smoke_screen_shard", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function riki_smoke_screen_shard:GetIntrinsicModifierName()
	return "modifier_riki_smoke_screen_shard"
end

modifier_riki_smoke_screen_shard = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_riki_smoke_screen_shard:IsHidden()
	return true
end

function modifier_riki_smoke_screen_shard:IsPurgeException()
	return false
end

function modifier_riki_smoke_screen_shard:IsPurgable()
	return false
end

function modifier_riki_smoke_screen_shard:IsPermanent()
	return true
end



function modifier_riki_smoke_screen_shard:OnCreated(kv)
    if IsServer() then
		local firstitem = self:GetCaster():GetItemInSlot(0)
		if firstitem then
			--print(firstitem:GetName())
			local removeditem = self:GetCaster():TakeItem(firstitem)
			--print(removeditem:GetName())
			local item = CreateItem( "item_aghanims_shard", self:GetCaster(), self:GetCaster() )
			--如果身上没格子 直接加添加魔晶会失效
			--使用置换的方式添加魔晶
			--添加魔晶后给不能直接添加移除的物品
			if item then
				item:SetPurchaseTime( 0 )
				item:SetPurchaser( self:GetCaster() )
				self:GetCaster():AddItem( item )
				
				Timers:CreateTimer(0.1, function()
					if(self and not self:IsNull()) then
						self:GetCaster():AddItemByName(firstitem:GetName())
					end
				end)
				
			end
		else
			local item = CreateItem( "item_aghanims_shard", self:GetCaster(), self:GetCaster() )
			item:SetPurchaseTime( 0 )
			item:SetPurchaser( self:GetCaster() )
			self:GetCaster():AddItem( item )
		end
    end
end

function modifier_riki_smoke_screen_shard:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end

function modifier_riki_smoke_screen_shard:OnAbilityExecuted(params)
	if IsServer() then
		if params.unit == self:GetParent() and params.ability:GetAbilityName() == "riki_smoke_screen" then
			local cursorPos = params.ability:GetCursorPosition()
			
			if not cursorPos then
				return
			end

			local duration = params.ability:GetSpecialValueFor("AbilityDuration")
	
			CreateModifierThinker( self:GetParent(), params.ability, "modifier_riki_smoke_screen_shard_thinker", { duration = duration }, cursorPos, self:GetParent():GetTeamNumber(), false )
			
		end
	end
end

modifier_riki_smoke_screen_shard_thinker = class({})

----------------------------------------------------------------------------------------

function modifier_riki_smoke_screen_shard_thinker:OnCreated( kv )
	if IsServer() then
		self.caster = self:GetCaster()
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.agi = self:GetCaster():GetAgility()

		self:OnIntervalThink()
		self:StartIntervalThink( 0.5 )
	end
end



----------------------------------------------------------------------------------------

function modifier_riki_smoke_screen_shard_thinker:OnIntervalThink()
	if IsServer() then
		if not self.caster or self.caster:IsNull() then
			self:Destroy()
			return
		end
		
		--enemies
		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(), 
			self:GetParent():GetOrigin(), 
			nil, 
			self.radius + 50, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
			0, 
			false 
		)

		for _,enemy in pairs( enemies ) do
			if enemy and not enemy:IsNull() and not enemy:IsInvulnerable() then

				local damage = {
					victim = enemy,
					attacker = self.caster,
					damage = self.agi*0.5,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = self:GetAbility()
				}
		
				ApplyDamage( damage )
			end
		end

	end
end


function modifier_riki_smoke_screen_shard_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end

----------------------------------------------------------------------------------------