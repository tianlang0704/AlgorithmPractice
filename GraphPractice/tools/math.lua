--[[

Copyright (c) 2015 gameboxcloud.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

local math_ceil  = math.ceil
local math_floor = math.floor
local sqrt  = math.sqrt 
local atan2 = math.atan2
local cos   = math.cos
local sin   = math.sin  
local pi    = math.pi
local pi_d_180 = pi / 180    
local pi_180_d = 180 / pi
local pow   = math.pow

local ok, socket = pcall(function()
    return require("socket")
end)

function math.iszero(value)
    return math.abs(value) <= 0.000001
end

function math.round(value)
    value = tonumber(value) or 0
    return math_floor(value + 0.5)
end

function math.trunc(x)
    if x <= 0 then
        return math_ceil(x)
    end
    if math_ceil(x) == x then
        x = math_ceil(x)
    else
        x = math_ceil(x) - 1
    end
    return x
end

function math.newrandomseed()
    if socket then
        -- math.randomseed(socket.gettime() * 1000)
    else
        -- math.randomseed(os.time())
    end

    math.random()
    math.random()
    math.random()
    math.random()
end
-- start --

--------------------------------
-- 角度转弧度
-- @function [parent=#math] angle2radian

-- end --

function math.angle2radian(angle)
    return angle*math.pi/180
end

-- start --

--------------------------------
-- 弧度转角度
-- @function [parent=#math] radian2angle

-- end --

function math.radian2angle(radian)
    return radian/math.pi*180
end

-- -- 求圆上一个点的位置
-- function math.pointAtCircle(pos, radians, radius)
--     local px = pos.x
--     local py = pos.y
--     local pz = pos.z
--     return Vector3.new(px + cos(radians) * radius,py,pz - sin(radians) * radius)
-- end
