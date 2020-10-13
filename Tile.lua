-- written by Vitor Silva <vitor@silva.moe>
-- 64 by 76
if Tile then return end

require "View"
require "Color"

Tile = Object()

function Tile:new()
    local newObject = Object(Tile)

    newObject.view = View(200, 200, 64, 76)
    newObject.view.delegate = newObject
    newObject.view.customCollisionChecker = true
    newObject.color = Color:fromDescription("white")
    newObject.pressed = false

    newObject:update()

    return newObject
end

function Tile:update()
    local r, g, b, a = love.graphics.getColor()
    local canvas = love.graphics.getCanvas()

    love.graphics.setCanvas(self.view.c)
    love.graphics.setColor(Color.unpack(self.color))
    love.graphics.clear()

    if not self.pressed then love.graphics.line(0.5, 19, 0.5, 57, 32, 76, 63.5, 57, 63.5, 19, 32, 0, 0.5, 19) end

    love.graphics.setCanvas(canvas)
    love.graphics.setColor(r, g, b, a)
end

function Tile:mousepressed(_, _)
    self.pressed = true
    self:update()
end

function Tile:mousereleased(_, _)
    self.pressed = false
    self:update()
end

function Tile:isIn(point)
    point = self.view.f:offset(point)
    -- 64 x 76, lapse = 19
    if point.x >= 0 and point.x <76 then
        local x = point.x
        if x > 32 then x = 76 - x end
        local h = 19 - (x/32 * 19)
        if point.y >= h and point.y < 76 - h then
            return true
        end
    end
    return false
end