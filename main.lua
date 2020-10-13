-- written by Vitor Silva <vitor@silva.moe>

require "Object"
require "Net"
require "Scene"
require "TTY"
require "Button"
require "Tile"

local scene = Scene()
tty = TTY()
local button = Button()
local tile = Tile()

tty:append("Hello world")
tty:update()

function button.onClick()
    Net.server:send("roll")
end

function Net.handler(data)
    local c = Color:fromDescription(data)
    if c then
        tile.color = c
        tile:update()
    end
end

scene:addChild(tty.view)
scene:addChild(button.view)
scene:addChild(tile.view)
scene:setTTY(tty)
scene:attach()