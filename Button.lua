-- written by Vitor Silva <vitor@silva.moe>

if Button then return end

require "View"

Button = Object()

function Button:new()
    local newObject = Object(self)

    newObject.view = View(100, 100, 32, 16)
    newObject.view.delegate = newObject
    newObject.view.updateOnDraw = false

    newObject.pressed = false

    newObject:update()
    return newObject
end

function Button:update()
    local r, g, b, a = love.graphics.getColor()
    local canvas = love.graphics.getCanvas()

    love.graphics.setCanvas(self.view.c)

    if self.pressed then
        love.graphics.setColor(255, 0, 0, 255)
    else
        love.graphics.setColor(0, 0, 255, 255)
    end
    love.graphics.rectangle("fill", 0.5, 0.5, 31, 15)

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle("line", 0.5, 0.5, 31, 15)

    love.graphics.setCanvas(canvas)
    love.graphics.setColor(r, g, b, a)
end

function Button:mousepressed(_, _)
    self.pressed = true
    self:update()
end

function Button:mousereleased(_, _)
    if self.pressed then
        tty:append("Button pressed")
        if self.onClick then
            self.onClick()
        end
    end
    self.pressed = false
    self:update()
end