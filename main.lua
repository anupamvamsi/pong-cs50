-- https://github.com/Ulydev/push
push = require('push')

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  fontLarge = love.graphics.setNewFont('font.ttf', 48)
  love.window.setTitle('Pong!')

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.draw()
  push:apply('start')

  love.graphics.clear(123 / 255, 21 / 255, 14 / 255, 255)
  love.graphics.setFont(fontLarge)
  love.graphics.print('PONG', VIRTUAL_WIDTH / 2 - 48, VIRTUAL_HEIGHT / 2 - 24)

  push:apply('end')
end

function love.keypressed(key)
  if (key == 'escape') then
    love.event.quit()
  end
end
