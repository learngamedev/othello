love.mouse.buttonsPressed = {}

function love.mousepressed(x, y, button, istouch, presses)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function belongsTo(parentTable, subTable)
    for i = 1, #parentTable do
        for j = 1, #parentTable[i] do
            if (parentTable[i][j] ~= subTable[j]) then
                break
            end
            if (j == 2) then
                return true
            end
        end
    end
    return false
end