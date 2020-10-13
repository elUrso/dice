-- written by Vitor Silva <vitor@silva.moe>

require "View"

if Scene then return end

Scene = Object()

function Scene:toString()
    return "Scene"
end

function Scene:new()
    local newObject = Object(self)
    newObject.layers = {{}}
    newObject.zorder = {1}
    newObject.w = love.graphics.getWidth()
    newObject.h = love.graphics.getHeight()
    newObject.state = {}
    return newObject
end

function Scene:addChild(view, layer)
    layer = layer or 1
    table.insert(self.layers[layer], view)
end

function Scene:setTTY(tty)
    self.state.tty = tty
end

function Scene:attach()
    function love.draw()
        local mode, alphamode = love.graphics.getBlendMode()
        love.graphics.setBlendMode("alpha", "premultiplied")

        for _, zkey in ipairs(self.zorder) do
            for _, view in pairs(self.layers[zkey]) do
                if view:canDraw() then
                    love.graphics.draw(view:canvas(), view:point())
                end
            end
        end

        love.graphics.setBlendMode(mode, alphamode)
    end

    function love.resize(width, height)
        self.w = width
        self.h = height
    end

    function love.mousepressed(x, y, btn)
        local point = Point(x, y)
        for _, zkey in ipairs(self.zorder) do
            for _, view in pairs(self.layers[zkey]) do
                if view:isIn(point) then
                    local _ = view.mousepressed and view:mousepressed(view.f:offset(point), btn)
                    self.state.pressed = view
                    goto out
                end
            end
        end

        ::out::
    end

    function love.mousereleased(x, y, btn)
        local point = Point(x, y)
        for _, zkey in ipairs(self.zorder) do
            for _, view in pairs(self.layers[zkey]) do
                if view:isIn(point) then
                    if self.state.pressed and self.state.pressed ~= view then
                        self.state.pressed:mousereleased(self.state.pressed.f:offset(point), btn)
                    end
                    local _ = view.mousereleased and view:mousereleased(view.f:offset(point), btn)
                    self.state.pressed = nil
                    goto out
                end
            end
        end

        if self.state.pressed then
            self.state.pressed:mousereleased(self.state.pressed.f:offset(point), btn)
        end

        ::out::
    end

    function love.mousemoved(x, y)
        local point = Point(x, y)

        if self.state.pressed then
            self.state.pressed:mousemoved(self.state.pressed.f:offset(point))
            return
        end

        for _, zkey in ipairs(self.zorder) do
            for _, view in pairs(self.layers[zkey]) do
                if view:isIn(point) then
                    if self.state.pressed and view ~= self.state.pressed then
                        self.state.pressed:mousereleased(self.state.pressed.f:offset(point), 0)
                    end
                    local _ = view.mousemoved and view:mousemoved(view.f:offset(point))
                    goto out
                end
            end
        end

        ::out::
    end

    function  love.mousefocus(focus)
        --local _ = self.state.tty and self.state.tty:append(focus and "mouse inside window" or "mouse outside window")
    end

    function love.wheelmoved(dx, dy)
        local x = love.mouse.getX()
        local y = love.mouse.getY()
        local point = Point(x, y)
        for _, zkey in ipairs(self.zorder) do
            for _, view in pairs(self.layers[zkey]) do
                if view:isIn(point) then
                    local _ = view.wheelmoved and view:wheelmoved(view.f:offset(point), dx, dy)
                end
                goto out
            end
        end

        ::out::
    end

    function love.update(dt)
        if Net then Net:service() end
    end
end