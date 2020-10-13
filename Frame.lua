-- written by Vitor Silva <vitor@silva.moe>

require "Rectangle"
require "Point"

if Frame then return end

Frame = Object()

function Frame:toString()
    return "Frame r(" .. self.r:toString() .. ") p(" .. self.p:toString() .. ")"
end

function Frame:new(x, y, w, h)
    local newObject = Object(self)
    newObject.r = Rectangle(w, h)
    newObject.p = Point(x, y)

    return newObject
end

function Frame:isIn(point)
    return point.x >= self.p.x and point.x < (self.p.x + self.r.w) and point.y >= self.p.y and (point.y < self.p.y + self.r.h)
end

function Frame:offset(point)
    return Point(point.x - self.p.x, point.y - self.p.y)
end