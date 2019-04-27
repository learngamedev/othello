VictoryState = Class {__includes = BaseState}

function VictoryState:enter(params)
    self._winner = params.winner
    self._player1Moves = params.player1Moves
    self._player2Moves = params.player2Moves
end

function VictoryState:render()
    love.graphics.setColor(255, 255, 255)
    if (self._winner == "draw") then
        love.graphics.printf(
            "Player 1 and Player 2 both have " .. self._player1Moves .. " moves",
            WINDOW_WIDTH / 2 - 130,
            WINDOW_HEIGHT / 2 - 10,
            260,
            "center"
        )
        love.graphics.printf("DRAW!!!!!!!!!!!", WINDOW_WIDTH / 2 - 70, 120, 140, "center")
    else
        love.graphics.printf(
            "Player 1 has " .. self._player1Moves .. " moves. Player 2 has " .. self._player2Moves .. " moves",
            WINDOW_WIDTH / 2 - 150,
            WINDOW_HEIGHT / 2 - 10,
            300,
            "center"
        )
        love.graphics.printf("Winner is " .. self._winner, WINDOW_WIDTH / 2 - 100, 120, 200, "center")
    end
end
