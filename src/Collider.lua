Collider = Class {}

function Collider:init(x, y, width, height)
    self._x, self._y = x, y
    self._width, self._height = width, height
end

function Collider:checkCollision(other)
    return self._x < other._x + other._width 
        and other._x < self._x + self._width 
        and self._y < other._y + other._height 
        and other._y < self._y + self._height
end

function Collider:checkCollisionWithCursor()
    return self:checkCollision({_x = love.mouse.getX(), _y = love.mouse.getY(), _width = 1, _height = 1})
end
