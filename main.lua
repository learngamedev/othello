require("src/Dependencies")

function love.load()
end

function love.draw()
end

function love.update(dt)
    require("lib/lovebird").update()

    love.mouse.buttonsPressed = {}
end