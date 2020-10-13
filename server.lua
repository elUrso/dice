-- written by Vitor Silva <vitor@silva.moe>

require "enet"

host = enet.host_create("localhost:6789")

color = "blue"
index = 0

function roll()
    if color == "blue" then
        color = "red"
    elseif color == "red" then
        color = "green"
    else
        color = "blue"
    end
end

while true do
    local event = host:service(100)
    if event then
        if event.type == "receive" then
            if event.data == "roll" then
                roll()
                host:broadcast(color)
            end
        end
    end
end