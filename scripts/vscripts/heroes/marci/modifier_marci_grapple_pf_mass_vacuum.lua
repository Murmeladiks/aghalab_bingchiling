modifier_marci_grapple_pf_mass_vacuum = class({})

function modifier_marci_grapple_pf_mass_vacuum:IsHidden() return true end
function modifier_marci_grapple_pf_mass_vacuum:IsPurgable() return false end

function modifier_marci_grapple_pf_mass_vacuum:CheckState() 
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end

if IsClient() then return end

function modifier_marci_grapple_pf_mass_vacuum:OnCreated(kv)
	self.pos = Vector(kv.target_x, kv.target_y, kv.target_z)
	self.direction = (self.pos - self:GetParent():GetAbsOrigin()):Normalized()
	
	local distance = (self.pos - self:GetParent():GetAbsOrigin()):Length2D()
	self.speed = distance / self:GetDuration()

	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
	end

end

function modifier_marci_grapple_pf_mass_vacuum:UpdateHorizontalMotion( me, dt )
	local pos = self.pos
	local dv = self.speed * dt
	
	if dv < (me:GetOrigin() - self.pos):Length2D() then
		pos = me:GetOrigin() + self.direction * dv
	end

	me:SetOrigin(pos)
end

function modifier_marci_grapple_pf_mass_vacuum:OnDestroy()
	self:GetParent():RemoveHorizontalMotionController( self )
end

function modifier_marci_grapple_pf_mass_vacuum:OnHorizontalMotionInterrupted()
	self:Destroy()
end