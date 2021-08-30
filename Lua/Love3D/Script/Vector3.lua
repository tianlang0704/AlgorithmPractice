local Vector3 = {}

function Vector3.__index(t, k)
    local var = rawget(Vector3, k)
	if var ~= nil then
		return var
	end
end

function Vector3.__tostring(t)
    return string.format("%s, %s, %s", t.x, t.y, t.z)
end

function Vector3.__add(a, b)
    return Vector3.New(a.x + b.x, a.y + b.y, a.z + b.z)
end

function Vector3.__sub(a, b)
    return Vector3.New(a.x - b.x, a.y - b.y, a.z - b.z)
end

function Vector3.__mul(a, b)
    local vNew = Vector3.New(a.x, a.y, a.z)
    if (type(b) == "number") then
        return vNew:MultiplyRealNumber(b)
    end
end

function Vector3.__div(a, b)
    local vNew = Vector3.New(a.x, a.y, a.z)
    if (type(b) == "number") then
        return vNew:DivideRealNumber(b)
    end
end

function Vector3.New(x, y, z)
    local inst = {}
    setmetatable(inst, Vector3)
    inst:ctor(x, y, z)
    return inst
end

function Vector3:ctor(x, y, z)
    self:SetXYZ(x, y, z)
    self.w = 1
end

function Vector3:SetXYZ(x, y, z)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
end

function Vector3:GetXY()
    return self.x, self.y
end

function Vector3:MultiplyRealNumber(r)
    self.x = self.x * r
    self.y = self.y * r
    self.z = self.z * r
    return self
end

function Vector3:DivideRealNumber(r)
    self.x = self.x / r
    self.y = self.y / r
    self.z = self.z / r
    return self
end

function Vector3:GetSqrMagnitude()
    return self.x * self.x + self.y * self.y + self.z * self.z
end

function Vector3:GetMagnitude()
    local sqrMag = self:GetSqrMagnitude()
    return math.sqrt(sqrMag)
end

function Vector3:GetNormalized()
    local mag = self:GetMagnitude()
    return self / mag
end

return Vector3