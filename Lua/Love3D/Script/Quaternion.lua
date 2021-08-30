local Quaternion = {}

function Quaternion.__index(t, k)
    local var = rawget(Quaternion, k)
	if var ~= nil then
		return var
	end
end

function Quaternion.__mul(a, b)
    local metaType = getmetatable(b)
    if (metaType == Vector3) then
        return a:MultiplyVector3(b)
    elseif (metaType == Quaternion) then
        return a:MultiplyQuaternion(b)
    end
end

function Quaternion.Identity()
    local newQuat  = Quaternion.New()
    newQuat:ResetIdentity()
    return newQuat
end

function Quaternion.New(quaternion)
    local inst = {}
    setmetatable(inst, Quaternion)
    inst:ctor(quaternion)
    return inst
end

function Quaternion:ctor(quaternion)
    if (quaternion) then
        self.i = quaternion.i
        self.j = quaternion.j
        self.k = quaternion.k
        self.r = quaternion.r
    else
        self:ResetIdentity()
    end
end

function Quaternion:ResetIdentity()
    self.r = 1
    self.i = 0
    self.j = 0
    self.k = 0
end

function Quaternion:SetByEuler(v3)
    local angleFactor = 1 / 180 * math.pi
    
    local cy = math.cos(v3.z * 0.5 * angleFactor)
    local sy = math.sin(v3.z * 0.5 * angleFactor)
    local cp = math.cos(v3.y * 0.5 * angleFactor)
    local sp = math.sin(v3.y * 0.5 * angleFactor)
    local cr = math.cos(v3.x * 0.5 * angleFactor)
    local sr = math.sin(v3.x * 0.5 * angleFactor)

    self.r = cr * cp * cy + sr * sp * sy
    self.i = sr * cp * cy - cr * sp * sy
    self.j = cr * sp * cy + sr * cp * sy
    self.k = cr * cp * sy - sr * sp * cy
end

function Quaternion:ToEuler()
    local resV3 = Vector3.New()
    -- roll (x-axis rotation)
    local sinr_cosp = 2 * (self.r * self.i + self.j * self.k)
    local cosr_cosp = 1 - 2 * (self.i * self.i + self.j * self.j)
    resV3.x = math.atan2(sinr_cosp, cosr_cosp)
    -- pitch (y-axis rotation)
    local sinp = 2 * (self.r * self.j - self.k * self.i)
    if (math.abs(sinp) >= 1) then
        -- resV3.y = std::copysign(M_PI / 2, sinp) // use 90 degrees if out of range
        resV3.y = math.pi / 2 * (sinp > 0 and 1 or -1)
    else
        resV3.y = math.asin(sinp)
    end
    -- yaw (z-axis rotation)
    local siny_cosp = 2 * (self.r * self.k + self.i * self.j)
    local cosy_cosp = 1 - 2 * (self.j * self.j + self.k * self.k)
    resV3.z = math.atan2(siny_cosp, cosy_cosp)
    local radToDegree = 1 / math.pi * 180 -- 57.295779513082
    resV3:MultiplyRealNumber(radToDegree)
    return resV3
end

function Quaternion:MultiplyVector3(v3)
    local resV3 = Vector3.New()
    local num 	= self.i * 2
	local num2 	= self.j * 2
	local num3 	= self.k * 2
	local num4 	= self.i * num
	local num5 	= self.j * num2
	local num6 	= self.k * num3
	local num7 	= self.i * num2
	local num8 	= self.i * num3
	local num9 	= self.j * num3
	local num10 = self.r * num
	local num11 = self.r * num2
	local num12 = self.r * num3
	
	resV3.x = (((1 - (num5 + num6)) * v3.x) + ((num7 - num12) * v3.y)) + ((num8 + num11) * v3.z)
	resV3.y = (((num7 + num12) * v3.x) + ((1 - (num4 + num6)) * v3.y)) + ((num9 - num10) * v3.z)
	resV3.z = (((num8 - num11) * v3.x) + ((num9 + num10) * v3.y)) + ((1 - (num4 + num5)) * v3.z)
    return resV3
end

function Quaternion:MultiplyQuaternion(q)
    local resQ = Quaternion.New()
    resQ.i = (((self.r * q.i) + (self.i * q.r)) + (self.j * q.k)) - (self.k * q.j)
    resQ.j = (((self.r * q.j) + (self.j * q.r)) + (self.k * q.i)) - (self.i * q.k)
    resQ.k = (((self.r * q.k) + (self.k * q.r)) + (self.i * q.j)) - (self.j * q.i)
    resQ.r = (((self.r * q.r) - (self.i * q.i)) - (self.j * q.j)) - (self.k * q.k)
    return resQ
end

function Quaternion:Normalized()
    local n = 1/math.sqrt(self.i * self.i + self.j * self.j + self.k * self.k + self.r * self.r)
    local newQ = Quaternion.New(self)
    newQ.i = newQ.i * n
    newQ.j = newQ.j * n
    newQ.k = newQ.k * n
    newQ.r = newQ.r * n
    return newQ
end

return Quaternion