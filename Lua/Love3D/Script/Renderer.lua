local Renderer = {}

Renderer.__index = Renderer

function Renderer.New()
    local inst = {}
    setmetatable(inst, Renderer)
    inst:ctor()
    return inst
end

function Renderer:ctor()
    self.width = 800
    self.height = 600
    self.colorStack = {}
end

function Renderer:Setup(width, height)
    self.width = width or self.width
    self.height = height or self.height
    love.window.setMode(self.width, self.height)
    self.model = Model.New()
    self.model:LoadTeapod(width, height)
end

local manualSpeedX = 10
local manualSpeedY = 10
local manualSpeedZ = 10
local autoSeedX = 30
local autoSeedY = 30
local autoSeedZ = 30
local mouseLastX, mouseLastY
function Renderer:Update(dt)
    if (love.mouse.isDown(1)) then
        local rotateAmount = Vector3.New()
        -- 鼠标X
        local mouseX = love.mouse.getX()
        if (not mouseLastX) then mouseLastX = mouseX end
        local delta = mouseX - mouseLastX
        rotateAmount.y = delta * manualSpeedX * dt
        -- 鼠标Y
        local mouseY = love.mouse.getY()
        if (not mouseLastY) then mouseLastY = mouseY end
        local delta = mouseY - mouseLastY
        rotateAmount.x = -delta * manualSpeedY * dt
        -- 现在旋转
        local nowRotQ = self.model:GetRotation()
        local rotateAmountQ = Quaternion.New()
        rotateAmountQ:SetByEuler(rotateAmount)
        self.model:SetRotationByQuaternion(nowRotQ * rotateAmountQ)
        -- 更新
        mouseLastX = mouseX
        mouseLastY = mouseY
        return
    else
        mouseLastX = nil
        mouseLastY = nil
    end

    -- 自动旋转
    local nowRotQ = self.model:GetRotation()
    local deltaAngleX = dt * autoSeedX % 360
    local deltaAngleY = dt * autoSeedY % 360
    local deltaAngleZ = dt * autoSeedZ % 360
    local addQ = Quaternion.New()
    addQ:SetByEuler(Vector3.New(deltaAngleX, deltaAngleY, deltaAngleZ))
    self.model:SetRotationByQuaternion(nowRotQ * addQ)
end

-- 滚轮放大缩小
local scaleFactor = 2
function Renderer:WheelMoved(x, y)
    local modelTransform = self.model:GetTransform()
    local modelScaleV3 = modelTransform:GetScale()
    local mag = modelScaleV3:GetMagnitude()
    local newMag = mag + y * scaleFactor
    local unitV3 = modelScaleV3 / mag
    self.model:SetScale(unitV3 * newMag)
end

function Renderer:Draw()
    self:DrawModel(self.model)
end

function Renderer:DrawModel(model)
    -- 获取颜色
    local color = model:GetColor()
    -- 模型世界坐标
    local pointArr = model:GetWorldPointArr()
    -- 
    -- -- 画三角形
    -- for i = 1, #pointArr, 3 do
    --     local triangleArr = {pointArr[i], pointArr[i+1], pointArr[i+2]}
    --     self:DrawOneTriangle(triangleArr, color)
    -- end
    -- 画线
    for i = 1, #pointArr, 3 do
        local triangleArr = {pointArr[i], pointArr[i + 1]}
        self:DrawLine(triangleArr, color)
        local triangleArr = {pointArr[i + 1], pointArr[i + 2]}
        self:DrawLine(triangleArr, color)
        local triangleArr = {pointArr[i + 2], pointArr[i]}
        self:DrawLine(triangleArr, color)
    end
    -- -- 画点阵
    -- for _, point in ipairs(pointArr) do
    --     self:DrawPoint(point, color, true)
    -- end
end

function Renderer:DrawOneTriangle(pointArr, color, isDrawPoints, isDrawMidPoints)
    table.sort(pointArr, function(a, b) return a.y < b.y end)
    local v1, v2, v3 = pointArr[1], pointArr[2], pointArr[3]
    if (isDrawPoints) then
        self:DrawPoint(v1, Color.New(1, 0, 0, 1))
        self:DrawPoint(v2, Color.New(1, 0, 0, 1))
        self:DrawPoint(v3, Color.New(1, 0, 0, 1))
    end
    if (v2.y == v3.y) then
        self:FillBottomFlatTriangle(pointArr, color)
    elseif (v1.y == v2.y) then
        self:FillTopFlatTriangle(pointArr, color)
    else
        local shortH = v2.y - v1.y
        local longH = v3.y - v1.y
        local longW = v3.x - v1.x
        local shortW = shortH / longH * longW
        v2 = Vector3.New(v2.x, math.floor(v2.y), v2.z)
        local v2p = Vector3.New(v2.x, v2.y + 1)
        local v4 = Vector3.New(v1.x + shortW, v2.y)
        local v4p = Vector3.New(v4.x, v4.y + 1)
        if (isDrawPoints and isDrawMidPoints) then
            self:DrawPoint(v4, Color.New(1, 0, 0, 1))
        end
        self:FillBottomFlatTriangle({v1, v2, v4}, color)
        self:FillTopFlatTriangle({v4p, v2p, v3}, color)
    end
end

function Renderer:FillBottomFlatTriangle(pointArr, color)
    if (color) then self:PushColor(color) end
    local v1, v2, v3 = pointArr[1], pointArr[2], pointArr[3]
    local inverseSlop21 = (v2.x - v1.x) / (v2.y - v1.y)
    local inverseSlop31 = (v3.x - v1.x) / (v3.y - v1.y)
    local h = v2.y - v1.y
    local startY = v1.y
    local endY = startY + h
    local x1, x2 = v1.x, v1.x
    for y = startY, endY do
        love.graphics.line(x1, y, x2, y)
        x1 = x1 + inverseSlop21
        x2 = x2 + inverseSlop31
    end
    if (color) then self:PopColor() end
end

function Renderer:FillTopFlatTriangle(pointArr, color)
    if (color) then self:PushColor(color) end
    local v1, v2, v3 = pointArr[1], pointArr[2], pointArr[3]
    local inverseSlop21 = -(v3.x - v2.x) / (v3.y - v2.y)
    local inverseSlop31 = -(v3.x - v1.x) / (v3.y - v1.y)
    local h = v3.y - v1.y
    local startY = v3.y
    local endY = startY - h
    local x1, x2 = v3.x, v3.x
    for y = startY, endY, -1 do
        love.graphics.line(x1, y, x2, y)
        x1 = x1 + inverseSlop31
        x2 = x2 + inverseSlop21
    end
    if (color) then self:PopColor() end
end

function Renderer:DrawLine(pointArr, color)
    if (color) then self:PushColor(color) end
    local xyArr = {}
    for index, value in ipairs(pointArr) do
        table.insert(xyArr, value.x)
        table.insert(xyArr, value.y)
    end
    love.graphics.line(xyArr)
    if (color) then self:PopColor() end
end

function Renderer:DrawPointArr(pointArr, color)
    if (color) then self:PushColor(color) end
    local xyArr = {}
    for index, value in ipairs(pointArr) do
        table.insert(xyArr, value.x)
        table.insert(xyArr, value.y)
    end
    love.graphics.setPointSize(2)
    love.graphics.points(xyArr)
    if (color) then self:PopColor() end
end

function Renderer:DrawPoint(vector3, color, isZSize)
    if (color) then self:PushColor(color) end
    local oldSize = love.graphics.getPointSize()
    if (isZSize) then
        love.graphics.setPointSize(3 + vector3.z / 50)
    else
        love.graphics.setPointSize(5)
    end
    love.graphics.points(vector3:GetXY())
    love.graphics.setPointSize(oldSize)
    if (color) then self:PopColor() end
end

function Renderer:PushColor(color)
    local curColor = Color.New(love.graphics.getColor())
    table.insert(self.colorStack, curColor)
    love.graphics.setColor(color:GetRGBA())
end

function Renderer:PopColor()
    local curColor = Color.New(love.graphics.getColor())
    local nextColor = table.remove(self.colorStack, #self.colorStack)
    love.graphics.setColor(nextColor:GetRGBA())
    return curColor
end


return Renderer