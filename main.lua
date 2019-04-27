require("src/Dependencies")

function love.load()
    gStateMachine = StateMachine{
        ["play"] = function() return PlayState() end,
        ["victory"] = function() return VictoryState() end
    }

    gStateMachine:change("play")
end

function love.draw()
    gStateMachine:render()
end

function love.update(dt)
    require("lib/lovebird").update()

    gStateMachine:update(dt)

    love.mouse.buttonsPressed = {}
end