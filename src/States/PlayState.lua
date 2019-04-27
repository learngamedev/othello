PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self._board = Board()
end

function PlayState:render()
    love.graphics.clear(5, 198, 25)
    self._board:render()
end

function PlayState:update(dt)
    self._board:update(dt)
end