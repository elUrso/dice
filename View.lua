-- written by Vitor Silva <vitor@silva.moe>

if View then return end

require "Frame"

View = Object()

function View:toString()
    return "View f(" .. self.f.toString() .. ")"
end

function View:new(x, y, w, h)
    local newObject = Object(self)
    newObject.f = Frame(x, y, w, h)
    newObject.c = love.graphics.newCanvas(w, h)
    newObject.draw = true
    newObject.updateOnDraw = false
    return newObject
end

function View:canvas()
    if self.delegate and self.updateOnDraw then
        self.delegate:updateCanvas()
    end
    return self.c
end

function View:point()
    return self.f.p.x, self.f.p.y
end

function View:canDraw()
    return self.draw
end

function View:isIn(point)
    if self.customCollisionChecker then
        return self.delegate:isIn(point)
    end
    return self:canDraw() and self.f:isIn(point)
end

function View:mousepressed(point, btn)
    if self.delegate and self.delegate.mousepressed then
        self.delegate:mousepressed(point, btn)
    end
end

function View:mousereleased(point, btn)
    if self.delegate and self.delegate.mousereleased then
        self.delegate:mousereleased(point, btn)
    end
end

function View:mousemoved(point)
    if self.delegate and self.delegate.mousemoved then
        self.delegate:mousemoved(point)
    end
end

function View:wheelmoved(point, dx, dy)
    if self.delegate and self.delegate.wheelmoved then
        self.delegate:wheelmoved(point, dx, dy)
    end
end

function View:resize(w, h)
    self.f.r.w = w
    self.f.r.h = h
    self.c = love.graphics.newCanvas(w, h)
end