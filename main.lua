-- https://github.com/Ulydev/push
-- https://github.com/vrld/hump/blob/master/class.lua
push = require('push')
Class = require('class')

require 'Paddle'
require 'Ball'

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

  -- random seed
  math.randomseed(os.time())

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
  -- paddles
  player1 = Paddle(player1X, player1Y, PADDLE_W, PADDLE_H)
  player2 = Paddle(player2X, player2Y, PADDLE_W, PADDLE_H)

  ballX = VIRTUAL_WIDTH / 2 - BALL_WH / 2
  ballY = VIRTUAL_HEIGHT / 2 - BALL_WH / 2
  ball = Ball(ballX, ballY, BALL_WH, BALL_WH)

  player1Score = 0
  player2Score = 0

  gameState = 'start'
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'play'
    else
      gameState = 'start'
      ball:reset()
    end
  end
end

function love.update(dt)
  if love.keyboard.isDown('w') then
    player1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    player1.dy = PADDLE_SPEED
  else
    player1.dy = 0
  end

  if love.keyboard.isDown('up') then
    player2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    player2.dy = PADDLE_SPEED
  else
    player2.dy = 0
  end

  if gameState == 'play' then
    if ball:collided(player1) then
      ball.dx = -ball.dx * 1.03
      ball.x = player1.x + player1.width

      if ball.dy < 0 then
        ball.dy = -math.random(50, 200)
      else
        ball.dy = math.random(50, 200)
      end
    end

    if ball:collided(player2) then
      ball.dx = -ball.dx * 1.03
      ball.x = player2.x - ball.width

      if ball.dy < 0 then
        ball.dy = -math.random(50, 200)
      else
        ball.dy = math.random(50, 200)
      end
    end

    if ball.y <= 0 then
      ball.y = 0
      ball.dy = -ball.dy
    end

    if ball.y >= VIRTUAL_HEIGHT - ball.height then
      ball.y = VIRTUAL_HEIGHT - ball.height
      ball.dy = -ball.dy
    end

    ball:update(dt)
  end

  player1:update(dt)
  player2:update(dt)
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

  player1:draw()
  player2:draw()

  ball:draw()

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
