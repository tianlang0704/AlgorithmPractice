local FourFourMatrix = {}

function FourFourMatrix.__index(t, k)
    local var = rawget(FourFourMatrix, k)
	if var ~= nil then
		return var
	end
end

function FourFourMatrix.__mul(a, b)
    local metaType = getmetatable(b)
    if (metaType == Vector3) then
        return a:MultiplyVector3(b)
    elseif (metaType == FourFourMatrix) then
        return a:Multiply44Matrix(b)
    end
end

function FourFourMatrix.Identity()
    local newMatrix  = FourFourMatrix.New()
    newMatrix:ResetIdentity()
    return newMatrix
end

function FourFourMatrix.New(fourFourMatrix)
    local inst = {}
    setmetatable(inst, FourFourMatrix)
    inst:ctor(fourFourMatrix)
    return inst
end

function FourFourMatrix:ctor(fourFourMatrix)
    if (fourFourMatrix) then
        self.matrix = Util:TableCopy(fourFourMatrix.matrix, 2)
    else
        self:ResetIdentity()
    end
end

function FourFourMatrix:ResetIdentity()
    self.matrix = {}
    for i = 1, 4 do
        local row = {}
        self.matrix[i] = row
        for j = 1, 4 do
            if (i == j) then
                row[j] = 1
            else
                row[j] = 0
            end
        end
    end
end

function FourFourMatrix:SetCell(x, y, value)
    self.matrix[x][y] = value
end

function FourFourMatrix:SetTranslation(v3)
    self.matrix[4][1] = v3.x
    self.matrix[4][2] = v3.y
    self.matrix[4][3] = v3.z
end

function FourFourMatrix:GetTranslation()
    local translation = Vector3.New()
    translation.x = self.matrix[4][1]
    translation.y = self.matrix[4][2]
    translation.z = self.matrix[4][3]
    return translation
end

function FourFourMatrix:SetScale(v3)
    self.matrix[1][1] = v3.x
    self.matrix[2][2] = v3.y
    self.matrix[3][3] = v3.z
end

function FourFourMatrix:GetScale()
    local scale = Vector3.New()
    scale.x = self.matrix[1][1]
    scale.y = self.matrix[2][2]
    scale.z = self.matrix[3][3]
    return scale
end

function FourFourMatrix:MultiplyVector3(v3)
    local resV3 = Vector3.New()
    resV3.x = self.matrix[1][1] * v3.x + self.matrix[1][2] * v3.y + self.matrix[1][3] * v3.z + self.matrix[4][1]
    resV3.y = self.matrix[2][1] * v3.x + self.matrix[2][2] * v3.y + self.matrix[2][3] * v3.z + self.matrix[4][2]
    resV3.z = self.matrix[3][1] * v3.x + self.matrix[3][2] * v3.y + self.matrix[3][3] * v3.z + self.matrix[4][3]
    return resV3
end

function FourFourMatrix:Multiply44Matrix(m4)
    local resM4 = FourFourMatrix.New()
    local target11 = m4.matrix[1][1]
    local target21 = m4.matrix[2][1]
    local target31 = m4.matrix[3][1]
    local target41 = m4.matrix[4][1]
    local target12 = m4.matrix[1][2]
    local target22 = m4.matrix[2][2]
    local target32 = m4.matrix[3][2]
    local target42 = m4.matrix[4][2]
    local target13 = m4.matrix[1][3]
    local target23 = m4.matrix[2][3]
    local target33 = m4.matrix[3][3]
    local target43 = m4.matrix[4][3]
    local target14 = m4.matrix[1][4]
    local target24 = m4.matrix[2][4]
    local target34 = m4.matrix[3][4]
    local target44 = m4.matrix[4][4]
    local self11 = self.matrix[1][1]
    local self21 = self.matrix[2][1]
    local self31 = self.matrix[3][1]
    local self41 = self.matrix[4][1]
    local self12 = self.matrix[1][2]
    local self22 = self.matrix[2][2]
    local self32 = self.matrix[3][2]
    local self42 = self.matrix[4][2]
    local self13 = self.matrix[1][3]
    local self23 = self.matrix[2][3]
    local self33 = self.matrix[3][3]
    local self43 = self.matrix[4][3]
    local self14 = self.matrix[1][4]
    local self24 = self.matrix[2][4]
    local self34 = self.matrix[3][4]
    local self44 = self.matrix[4][4]
    resM4.matrix[1][1] = self11 * target11 + self12 * target21 + self13 * target31 + self14 * target41
    resM4.matrix[2][1] = self21 * target11 + self22 * target21 + self23 * target31 + self24 * target41
    resM4.matrix[3][1] = self31 * target11 + self32 * target21 + self33 * target31 + self34 * target41
    resM4.matrix[4][1] = self41 * target11 + self42 * target21 + self43 * target31 + self44 * target41

    resM4.matrix[1][2] = self11 * target12 + self12 * target22 + self13 * target32 + self14 * target42
    resM4.matrix[2][2] = self21 * target12 + self22 * target22 + self23 * target32 + self24 * target42
    resM4.matrix[3][2] = self31 * target12 + self32 * target22 + self33 * target32 + self34 * target42
    resM4.matrix[4][2] = self41 * target12 + self42 * target22 + self43 * target32 + self44 * target42

    resM4.matrix[1][3] = self11 * target13 + self12 * target23 + self13 * target33 + self14 * target43
    resM4.matrix[2][3] = self21 * target13 + self22 * target23 + self23 * target33 + self24 * target43
    resM4.matrix[3][3] = self31 * target13 + self32 * target23 + self33 * target33 + self34 * target43
    resM4.matrix[4][3] = self41 * target13 + self42 * target23 + self43 * target33 + self44 * target43
    
    resM4.matrix[1][4] = self11 * target14 + self12 * target24 + self13 * target34 + self14 * target44
    resM4.matrix[2][4] = self21 * target14 + self22 * target24 + self23 * target34 + self24 * target44
    resM4.matrix[3][4] = self31 * target14 + self32 * target24 + self33 * target34 + self34 * target44
    resM4.matrix[4][4] = self41 * target14 + self42 * target24 + self43 * target34 + self44 * target44
    return resM4
end

return FourFourMatrix