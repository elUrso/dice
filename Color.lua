--written by Vitor Silva <vitor@silva.moe>

if Color then return end

Color = {}

local color = function (r, g, b, a)
    return {r, g, b, a}
end

Color.reference = {
    red = color(255, 0, 0, 255),
    green = color(0, 255, 0, 255),
    blue = color(0, 0, 255, 255),
    white = color(255, 255, 255, 255)
}

function Color:fromDescription(desc)
    return self.reference[desc]
end

function Color.unpack(color)
    return color[1], color[2], color[3], color[4]
end