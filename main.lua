-- https://github.com/Ulydev/push
push = require('push')

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

FONT_LARGE = 24
FONT_MED = 16
FONT_SMALL = 8

PADDLE_W = 5
PADDLE_H = 20
PADDLE_SPEED = 200 -- pixels/sec

BALL_WH = 4

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

  player1X = 15
  player1Y = 15
  player2X = VIRTUAL_WIDTH - 25
  player2Y = VIRTUAL_HEIGHT - 35

  ballX = VIRTUAL_WIDTH / 2 - BALL_WH / 2
  ballY = VIRTUAL_HEIGHT / 2 - BALL_WH / 2

  player1Score = 0
  player2Score = 1
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.keypressed(key)
  if (key == 'escape') then
    love.event.quit()
  end
end

function love.update(dt)
  if love.keyboard.isDown('w') then
    player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
  elseif love.keyboard.isDown('s') then
    player1Y = math.min(VIRTUAL_HEIGHT - PADDLE_H, player1Y + PADDLE_SPEED * dt)
  end

  if love.keyboard.isDown('up') then
    player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
  elseif love.keyboard.isDown('down') then
    player2Y = math.min(VIRTUAL_HEIGHT - PADDLE_H, player2Y + PADDLE_SPEED * dt)
  end
end

function love.draw()
  push:apply('start')

  local gameStartText = "Press 'ENTER' to start"

  love.graphics.clear(123 / 255, 21 / 255, 14 / 255, 255)

  love.graphics.setFont(fontSmall)
  printTextInCenter(gameStartText)

  love.graphics.setFont(fontLarge)
  printTextInCenter(player1Score, 40)
  printTextInCenter(player2Score, -40)

  -- paddles
  love.graphics.rectangle("fill", player1X, player1Y, PADDLE_W, PADDLE_H)
  love.graphics.rectangle("fill", player2X, player2Y, PADDLE_W, PADDLE_H)

  -- ball
  love.graphics.rectangle("fill", ballX, ballY, BALL_WH, BALL_WH)
  push:apply('end')
end

-- [[ 'height' is an optional parameter. BUT is compulsory to pass when the font size of two consecutive texts being printed is the same, since the font size is being used to adjust the vertical placement of the text. ]]
function printTextInCenter(text, width, height)
  local font = love.graphics.getFont()
  local textW = 0
  if (width) then
    textW = width + font:getWidth(text)
  else
    textW = font:getWidth(text)
  end

  --[[ 'height' is an optional parameter, so if it is not passed as an argument, 'textH' will take the value of font:getHeight(). ]]
  local textH = height or font:getHeight()

  love.graphics.print(text, VIRTUAL_WIDTH / 2 - textW / 2, textH)
end
