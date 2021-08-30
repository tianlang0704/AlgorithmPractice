local Camera = {}

Camera.__index = Camera

function Camera.New()
    local inst = {}
	setmetatable(inst, Camera)
	inst:ctor()
    return inst
end

function Camera:ctor()
	self.transform = FourFourMatrix.New()
	self.invTransform = FourFourMatrix.New()
	self.rotation = Quaternion.New()
	self.projection = FourFourMatrix.New()
end

function Camera:GetPointArr()
	return self.pointArr
end

function Camera:SetPosition(v3)
	self.transform:SetCell(4, 1, v3.x)
	self.transform:SetCell(4, 2, v3.y)
	self.transform:SetCell(4, 3, v3.z)
	self:UpdateInverseTransform()
end

function Camera:SetScale(x, y, z)
	self.transform:SetCell(1, 1, x)
	self.transform:SetCell(2, 2, y)
	self.transform:SetCell(3, 3, z)
	self:UpdateInverseTransform()
end

function Camera:SetSimpleProjection(angleOfView, near, far)
    -- set the basic projection matrix
    local scale = 1 / math.tan(angleOfView * 0.5 * math.pi / 180)
    self.projection.matrix[1][1] = scale -- scale the x coordinates of the projected point 
    self.projection.matrix[2][2] = scale -- scale the y coordinates of the projected point 
    self.projection.matrix[3][3] = -far / (far - near) -- used to remap z to [0,1] 
    self.projection.matrix[3][4] = -far * near / (far - near) -- used to remap z [0,1] 
    self.projection.matrix[4][3] = -1 -- set w = -z 
    self.projection.matrix[4][4] = 0
end

function Camera:GetProjectionMatrix()
	return self.projection
end

function Camera:UpdateInverseTransform()
	self.invTransform = self.transform:Invert()
end

function Camera:GetInverseTransform()
	return self.invTransform
end

function Camera:SetRotation(quat)
	self.rotation = quat
end

function Camera:GetRotation()
	return self.rotation
end

function Camera:GetTransform()
	return self.transform
end

function Camera:ProcessProjection(worldPointArr, width, height)
    local worldToCamera = self:GetInverseTransform()     -- 相机坐标
    local projection = self:GetProjectionMatrix()        -- 相机投射
    local pointArr = {}
    for index, value in ipairs(worldPointArr) do
        value = worldToCamera * value
        value = projection * value
        if (value.w ~= 1) then
            value = value / value.w
        end
        value.x = (value.x + 1) * 0.5 * width
        value.y = (value.y + 1) * 0.5 * height
        pointArr[index] = value
    end
	return pointArr
end

return Camera