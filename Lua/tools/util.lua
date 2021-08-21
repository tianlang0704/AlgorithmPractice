--[[
-- Lua全局工具类，全部定义为全局函数、变量
-- TODO:
-- 1.SafePack和SafeUnpack会被大量使用，到时候看需要需要做记忆表降低GC
-- 岳溁松
--]]

local unpack = unpack or table.unpack

-- 解决原生pack的nil截断问题，SafePack与SafeUnpack要成对使用
function SafePack(...)
	local params = {...}
	params.n = select('#', ...)
	return params
end

-- 解决原生unpack的nil截断问题，SafePack与SafeUnpack要成对使用
function SafeUnpack(safe_pack_tb)
	return unpack(safe_pack_tb, 1, safe_pack_tb.n)
end

-- 对两个SafePack的表执行连接
function ConcatSafePack(safe_pack_l, safe_pack_r)
	local concat = {}
	for i = 1,safe_pack_l.n do
		concat[i] = safe_pack_l[i]
	end
	for i = 1,safe_pack_r.n do
		concat[safe_pack_l.n + i] = safe_pack_r[i]
	end
	concat.n = safe_pack_l.n + safe_pack_r.n
	safe_pack_l = nil
	safe_pack_r = nil
	return concat
end

-- 闭包绑定
function Bind(self, func)
	assert(self == nil or type(self) == "table")
	assert(func ~= nil and type(func) == "function")
	if self == nil then
		return function(...)
			return func(...)
		end
	else
		return function(...)
			return func(self, ...)
		end
	end
end

-- 回调绑定
-- 重载形式：
-- 1、成员函数、私有函数绑定：BindCallback(obj, callback, ...)
-- 2、闭包绑定：BindCallback(callback, ...)
function BindCallback(object, fuc)
	local bindFunc = nil
	if type(object) == "table" and type(fuc) == "function" then
		bindFunc = Bind(object, fuc)
	elseif type(object) == "function" then
		bindFunc = Bind(nil, object)
	else
		error("BindCallback : error params list!")
	end
	return bindFunc
end
