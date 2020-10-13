-- written by Vitor Silva <vitor@silva.moe>

if TTY then return end

require "View"

TTY = Object()

function TTY:toString()
    return "TTY"
end

function TTY:new()
    local newObject = Object(self)

    newObject.content = {}

    newObject.state = {}

    newObject.state.cw = 20
    newObject.state.ch = 15

    newObject.state.click = false
    newObject.state.clickx = 0
    newObject.state.clicky = 0

    newObject.state.resize = false
    newObject.state.resizex = 0
    newObject.state.resizey = 0

    newObject.state.dx = 2
    newObject.state.dy = 0

    newObject.view = View(0, 0, newObject.state.cw * 12, newObject.state.ch * 14)
    newObject.view.delegate = newObject

    return newObject
end

function TTY:mousepressed(point, btn)
    if point.x > self.view.f.r.w - 16 and point.y > self.view.f.r.h - 16 then
        self.state.resize = true
        self.state.resizex = point.x
        self.state.resizey = point.y
    else
        self.state.click = true
        self.state.clickx = point.x
        self.state.clicky = point.y
    end
    self:update()
end

function TTY:mousereleased(point, btn)
    self:update()

    self.state.click = false
    self.state.resize = false
end



function TTY:wheelmoved(point, dx, dy)
    self.state.dx = self.state.dx - dx * 12
    self.state.dy = self.state.dy + dy * 16

    self.state.dx = self.state.dx < 2 and self.state.dx or 2
    self.state.dy = self.state.dy < 0 and self.state.dy or 0

    local minDy = (-16 * (#self.content + 1)) + self.view.f.r.h
    if (16 * (#self.content + 1)) < self.view.f.r.h then
        minDy = 0
    end
    self.state.dy = self.state.dy > minDy and self.state.dy or minDy
    self:update()
end


function TTY:mousemoved(point)
    if self.state.click then
        self.view.f.p.x = self.view.f.p.x + point.x - self.state.clickx
        self.view.f.p.y = self.view.f.p.y + point.y - self.state.clicky
    elseif self.state.resize then
        self.view:resize(self.view.f.r.w + point.x - self.state.resizex, self.view.f.r.h + point.y - self.state.resizey)
        self.state.resizex = point.x
        self.state.resizey = point.y
        self:update()
    end
end

function TTY:append(line)
    if type(line) == "string" then
        table.insert(self.content, line)
        if #self.content * 16 > self.view.f.r.h then
            self:wheelmoved(Point(0, 0), 0, -1)
        end
        self:update()
        return true, nil
    end
    return false, "[TTY] line isn't a string"
end

function TTY:flush()
    self.content = {}
end

function TTY:update()
    local oldCanvas = love.graphics.getCanvas()
    love.graphics.setCanvas(self.view.c)

    love.graphics.clear()

    for index, line in ipairs(self.content) do
        love.graphics.print(line, self.state.dx + 0, self.state.dy + (index - 1) * 16)
    end

    love.graphics.rectangle("line", 0.5, 0.5, self.view.f.r.w - 1, self.view.f.r.h - 1)

    love.graphics.rectangle("fill", self.view.f.r.w - 16.5, self.view.f.r.h - 16.5, 16, 16)

    love.graphics.setCanvas(oldCanvas)
end