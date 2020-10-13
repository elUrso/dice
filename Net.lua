--written by Vitor Silva <vitor@silva.moe>

if Net then return end

enet = require "enet"

Net = Object()

Net.host = enet.host_create()
Net.server = Net.host:connect "localhost:6789"

function Net:service()
    local event = Net.host:service(1)
    if event then
        if event.type == "receive" then
            print("Got: ", event.data)
            if self.handler then
                self.handler(event.data)
            end
        end
    end
end