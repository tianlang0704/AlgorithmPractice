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
end

function Camera:GetPointArr()
	return self.pointArr
end

function Camera:SetPosition(v3)
	self.transform:SetCell(4, 1, v3.x)
	self.transform:SetCell(4, 2, v3.y)
	self.transform:SetCell(4, 3, v3.z)
end

function Camera:SetScale(x, y, z)
	self.transform:SetCell(1, 1, x)
	self.transform:SetCell(2, 2, y)
	self.transform:SetCell(3, 3, z)
end

function Camera:SetRotation(x, y, z)
	-- Quaternion
end

function Camera:GetTransform()
	return self.transform
end
return Camera