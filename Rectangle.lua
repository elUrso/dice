-- written by Vitor Silva <vitor@silva.moe>

if Rectangle then return end

Rectangle = Object()

function Rectangle:toString()
    return "Rectangle w:" .. self.w .. " h:" .. self.h
end

function Rectangle:new(w, h)
    local newObject = Object(self)
    newObject.w = w
    newObject.h = h

    return newObject
end