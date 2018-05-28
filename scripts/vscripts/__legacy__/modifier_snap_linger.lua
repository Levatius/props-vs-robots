modifier_snap_linger = class({})


function modifier_snap_linger:OnCreated()
    if IsServer() then
        local parent = self:GetParent()
        local pos = parent:GetOrigin()
        local angles = parent:GetAnglesAsVector()
        local new_pos = Vector(math.floor(pos.x / 32.0 + 0.5) * 32.0, math.floor(pos.y / 32.0 + 0.5) * 32.0, pos.z)
        local new_angles = Vector(0, math.floor(angles.y / 45.0 + 0.5) * 45.0, 0)
        local vec_angles = Vector(math.cos(math.pi * new_angles.y / 180), math.sin(math.pi * new_angles.y / 180), 0)
        local face_vec = new_pos + vec_angles
        if GridNav:IsTraversable(new_pos) then
            parent:SetOrigin(new_pos)
            parent:FaceTowards(face_vec)
        end
    end
end

function modifier_snap_linger:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
    }
    return funcs
end

function modifier_snap_linger:GetModifierProvidesFOWVision()
    return 1
end