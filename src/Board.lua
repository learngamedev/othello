Board = Class {}

local CELL_WIDTH, CELL_HEIGHT = 25, 25
local INDENTATION, SPACING = 2, 5

function Board:init()
    self._matrix = {}
    self._anchorX, self._anchorY = 0, 0
    self._currentCollider = nil
    self._possibleMoves = {}

    for i = 1, 8 do
        self._matrix[i] = {}
        for j = 1, 8 do
            self._matrix[i][j] = 0
        end
    end
    self._matrix[4][4], self._matrix[5][5] = 2, 2
    self._matrix[5][4], self._matrix[4][5] = 1, 1

    self:getAllPossibleMoves()
end

function Board:render()
    for i = 1, 8 do
        for j = 1, 8 do
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle(
                "line",
                self._anchorX + (INDENTATION + CELL_WIDTH) * (j - 1),
                self._anchorY + (SPACING + CELL_HEIGHT) * (i - 1),
                CELL_WIDTH,
                CELL_HEIGHT
            )

            if (self._matrix[i][j] == 1) then -- Black
                love.graphics.circle(
                    "fill",
                    self._anchorX + (INDENTATION + CELL_WIDTH) * (j - 1) + CELL_WIDTH / 2,
                    self._anchorY + (SPACING + CELL_HEIGHT) * (i - 1) + CELL_HEIGHT / 2,
                    10
                )
            elseif (self._matrix[i][j] == 2) then -- White
                love.graphics.setColor(255, 255, 255)
                love.graphics.circle(
                    "fill",
                    self._anchorX + (INDENTATION + CELL_WIDTH) * (j - 1) + CELL_WIDTH / 2,
                    self._anchorY + (SPACING + CELL_HEIGHT) * (i - 1) + CELL_HEIGHT / 2,
                    10
                )
            end
        end
    end

    if (CURRENT_PLAYER_TURN == 1) then
        love.graphics.setColor(0, 0, 0, 100)
    else
        love.graphics.setColor(255, 255, 255, 100)
    end
    for k, move in ipairs(self._possibleMoves) do
        love.graphics.circle(
            "fill",
            self._anchorX + (INDENTATION + CELL_WIDTH) * (move[2] - 1) + CELL_WIDTH / 2,
            self._anchorY + (SPACING + CELL_HEIGHT) * (move[1] - 1) + CELL_HEIGHT / 2,
            10
        )
    end
end

function Board:update(dt)
    if (#self._possibleMoves == 0) then
        CURRENT_PLAYER_TURN = CURRENT_PLAYER_TURN == 1 and 2 or 1
        self:getAllPossibleMoves()
        if (#self._possibleMoves == 0) then
            gStateMachine:change("victory", self:getWinner())
        end
    end

    for i = 1, 8 do
        for j = 1, 8 do
            self._currentCollider =
                Collider(
                self._anchorX + (INDENTATION + CELL_WIDTH) * (j - 1),
                self._anchorY + (SPACING + CELL_HEIGHT) * (i - 1),
                CELL_WIDTH,
                CELL_HEIGHT
            )
            if (self._currentCollider:checkCollisionWithCursor()) then
                if (love.mouse.wasPressed(1) and belongsTo(self._possibleMoves, {i, j})) then
                    self._matrix[i][j] = CURRENT_PLAYER_TURN
                    self:turnOverAt(i, j)
                    CURRENT_PLAYER_TURN = CURRENT_PLAYER_TURN == 1 and 2 or 1
                    self._possibleMoves = {}
                    self:getAllPossibleMoves()
                    return
                end
            end
        end
    end
end

function Board:getPossibleMovesAt(row, column)
    local index = column - 1
    while (self._matrix[row][index] ~= CURRENT_PLAYER_TURN and self._matrix[row][index] ~= 0 and index >= 2) do
        index = index - 1
    end
    if (self._matrix[row][index] == 0 and index + 1 ~= column) then
        table.insert(self._possibleMoves, {row, index})
    end

    local index = column + 1
    while (self._matrix[row][index] ~= CURRENT_PLAYER_TURN and self._matrix[row][index] ~= 0 and index <= 7) do
        index = index + 1
    end
    if (self._matrix[row][index] == 0 and index - 1 ~= column) then
        table.insert(self._possibleMoves, {row, index})
    end

    local index = row - 1
    while (index >= 2 and self._matrix[index][column] ~= CURRENT_PLAYER_TURN and self._matrix[index][column] ~= 0) do
        index = index - 1
    end
    if (index + 1 ~= row and self._matrix[index][column] == 0) then
        table.insert(self._possibleMoves, {index, column})
    end

    local index = row + 1
    while (index <= 7 and self._matrix[index][column] ~= CURRENT_PLAYER_TURN and self._matrix[index][column] ~= 0) do
        index = index + 1
    end
    if (index - 1 ~= row and self._matrix[index][column] == 0) then
        table.insert(self._possibleMoves, {index, column})
    end
end

function Board:getAllPossibleMoves()
    for i = 1, 8 do
        for j = 1, 8 do
            if (self._matrix[i][j] == CURRENT_PLAYER_TURN) then
                self:getPossibleMovesAt(i, j)
            end
        end
    end
end

function Board:turnOverAt(row, column)
    local first, last
    for i = 1, 8 do
        if (self._matrix[row][i] == CURRENT_PLAYER_TURN) then
            if (not first) then
                first = i
            else
                last = i
            end
        elseif (self._matrix[row][i] == 0) then
            first, last = nil, nil
        end

        if (first and last and first < last) then
            for j = first, last do
                self._matrix[row][j] = CURRENT_PLAYER_TURN
            end
        end
    end

    local first, last
    for i = 1, 8 do
        if (self._matrix[i][column] == CURRENT_PLAYER_TURN) then
            if (not first) then
                first = i
            else
                last = i
            end
        elseif (self._matrix[i][column] == 0) then
            first, last = nil, nil
        end

        if (first and last and first < last) then
            for j = first, last do
                self._matrix[j][column] = CURRENT_PLAYER_TURN
            end
        end
    end
end

function Board:getWinner()
    local player1Moves, player2Moves = 0, 0
    for i = 1, 8 do
        for j = 1, 8 do
            if (self._matrix[i][j] == 1) then
                player1Moves = player1Moves + 1
            elseif (self._matrix[i][j] == 2) then
                player2Moves = player2Moves + 1
            end
        end
    end

    local result = {["player1Moves"] = player1Moves, ["player2Moves"] = player2Moves}
    if (player1Moves > player2Moves) then
        result.winner = 1
        return result
    elseif (player2Moves > player1Moves) then
        result.winner = 2
        return result
    end
    result.winner = "draw"
    return result
end
