-- written by Vitor Silva <vitor@silva.moe>

if Point then return end

Point = Object()

function Point:toString()
    return "Point x:" .. self.x .. " y:" .. self.y
end

function Point:new(x, y)
    local newObject = Object(self)
    newObject.x = x
    newObject.y = y

    return newObject
end