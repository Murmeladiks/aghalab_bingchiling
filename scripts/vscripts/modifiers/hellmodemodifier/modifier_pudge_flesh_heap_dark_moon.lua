modifier_pudge_flesh_heap_dark_moon = class({})


function modifier_pudge_flesh_heap_dark_moon:IsPurgable()
	return false
end

function modifier_pudge_flesh_heap_dark_moon:IsPurgeException()
	return false
end

function modifier_pudge_flesh_heap_dark_moon:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_pudge_flesh_heap_dark_moon:OnCreated( kv )
	


	if IsServer() then	
	
	end
end

--------------------------------------------------------------------------------

function modifier_pudge_flesh_heap_dark_moon:OnRefresh( kv )
	

	if IsServer() then
		
	end
end

--------------------------------------------------------------------------------

function modifier_pudge_flesh_heap_dark_moon:DeclareFunctions()
	local funcs = {
		
		MODIFIER_EVENT_ON_DEATH,
		
	}

	return funcs
end

--------------------------------------------------------------------------------
function modifier_pudge_flesh_heap_dark_moon:OnDeath(params)
	if not IsServer() then return end

    if self:GetParent():IsNull() or not self:GetParent():IsAlive() then
        return
    end

	if params.attacker == nil or params.unit == nil then
		return
	end

	if params.unit == self:GetParent() then
		return
	end




	



	local vToCaster = self:GetParent():GetAbsOrigin() - params.unit:GetAbsOrigin()
	local flDistance = vToCaster:Length2D()
	if 600 >= flDistance then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		local heal = 50
		self:GetParent():Heal( heal, nil )
	end
end

--------------------------------------------------------------------------------

