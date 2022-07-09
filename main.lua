-- https://github.com/Ulydev/push
push = require('push')

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

FONT_LARGE = 24
FONT_MED = 16
FONT_SMALL = 8

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  fontLarge = love.graphics.setNewFont('font.ttf', FONT_LARGE)
  fontMed = love.graphics.setNewFont('font.ttf', FONT_MED)
  fontSmall = love.graphics.setNewFont('font.ttf', FONT_SMALL)
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

  local gameStartText = "Press 'ENTER' to start"

  love.graphics.clear(123 / 255, 21 / 255, 14 / 255, 255)

  love.graphics.setFont(fontSmall)
  printTextInCenter(gameStartText)

  love.graphics.setFont(fontLarge)
  printTextInCenter('0 0')

  love.graphics.rectangle("fill", 5, 5, 5, 20)
  love.graphics.rectangle("fill", VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 25, 5, 20)

  push:apply('end')
end

-- [[ 'height' is an optional parameter. BUT is compulsory to pass when the font size of two consecutive texts being printed is the same, since the font size is being used to adjust the vertical placement of the text. ]]
function printTextInCenter(text, height)
  local font = love.graphics.getFont()
  local textW = font:getWidth(text)

  --[[ 'height' is an optional parameter, so if it is not passed as an argument, 'textH' will take the value of font:getHeight(). ]]
  local textH = height or font:getHeight()

  love.graphics.print(text, VIRTUAL_WIDTH / 2 - textW / 2, textH)
end

function love.keypressed(key)
  if (key == 'escape') then
    love.event.quit()
  end
end
