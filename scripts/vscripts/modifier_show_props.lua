modifier_show_props = class({})


function modifier_show_props:IsHidden()
    return true
end

function modifier_show_props:OnCreated()
    if IsServer() then
        self.index = ParticleManager:CreateParticleForPlayer("particles/ui/ui_sweeping_ring.vpcf", PATTACH_WORLDORIGIN, self:GetParent(), self:GetCaster():GetPlayerOwner())
        ParticleManager:SetParticleControl(self.index, 0, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl(self.index, 3, self:GetParent():GetOrigin())
    end
end

function modifier_show_props:OnDestroy()
    if IsServer() then
        if self.index ~= nil then
            ParticleManager:DestroyParticle(self.index, false)
        end
    end
end