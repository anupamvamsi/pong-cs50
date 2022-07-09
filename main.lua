-- https://github.com/Ulydev/push
push = require('push')

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

FONT_LARGE = 24

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  fontLarge = love.graphics.setNewFont('font.ttf', FONT_LARGE)
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
  love.graphics.print('PONG', VIRTUAL_WIDTH / 2 - FONT_LARGE, VIRTUAL_HEIGHT / 4 - (FONT_LARGE / 2))

  love.graphics.rectangle("fill", 5, 5, 5, 20)
  love.graphics.rectangle("fill", VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 25, 5, 20)

  push:apply('end')
end

function love.keypressed(key)
  if (key == 'escape') then
    love.event.quit()
  end
end
