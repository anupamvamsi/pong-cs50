WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
  fontLarge = love.graphics.setNewFont('font.ttf', 48)
  love.graphics.setBackgroundColor(123 / 255, 21 / 255, 14 / 255, 255)
  love.window.setTitle('Pong!')
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })
end

function love.draw()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.graphics.setFont(fontLarge)
  love.graphics.print('PONG', WINDOW_WIDTH / 2 - 24, WINDOW_HEIGHT / 2 - 24)
end

function love.keypressed(key)
  if (key == 'escape') then
    love.event.quit()
  end
end
