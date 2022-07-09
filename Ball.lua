Ball = Class {}

function Ball:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.dx = (math.random(2) == 1) and 100 or -100
  self.dy = math.random(-200, 200)
end

function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

function Ball:draw()
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - BALL_WH
  self.y = VIRTUAL_HEIGHT / 2 - BALL_WH

  self.dx = (math.random(2) == 1) and 100 or -100
  self.dy = math.random(-200, 200)
end
