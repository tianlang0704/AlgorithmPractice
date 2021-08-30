local Color = {}

function Color.__index(t, k)
    local var = rawget(Color, k)
	if var ~= nil then
		return var
	end
end

function Color.New(r, g, b, a)
    local inst = {r = r, g = g, b = b, a = a}
    setmetatable(inst, Color)
    return inst
end

function Color:GetRGBA()
    return self.r, self.g, self.b, self.a
end

return Color