-- written by Vitor Silva <vitor@silva.moe>

if Object then return end

Object = {}

local mt = {}
local omt = {}

function mt.__call(_, super)
    local newObject = {}
    super = super or {}
    newObject.super = super

    setmetatable(newObject, omt)
    return newObject
end

function omt.__index(self, key)
    return self and self.super and self.super[key] or nil
end

function omt.__call(self, ...)
    return self.new and self.new(self, ...) or nil
end

--[[
for _, op in ipairs({"__add", "__sub", "__mul", "__div", "__mod", "__pow", "__concat"}) do
    omt[op] = function (lhs, rhs)
        return lhs[op] and lhs[op](lhs, rhs) or nil
    end
end

function omt.__unm(rhs)
    return rhs.__unm and rhs.__unm(rhs) or nil
end
]]



setmetatable(Object, mt)