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

FONT_ELARGE = 48
FONT_LARGE = 24
FONT_MED = 16
FONT_SMALL = 8

PADDLE_W = 5
PADDLE_H = 20
PADDLE_SPEED = 200 -- pixels/sec

BALL_WH = 4

function loadGame()
  -- paddles' X-Y coordinates
  player1X = 15
  player1Y = 15
  player2X = VIRTUAL_WIDTH - 25
  player2Y = VIRTUAL_HEIGHT - 35

  -- paddles
  player1 = Paddle(player1X, player1Y, PADDLE_W, PADDLE_H)
  player2 = Paddle(player2X, player2Y, PADDLE_W, PADDLE_H)

  -- ball
  ballX = VIRTUAL_WIDTH / 2 - BALL_WH / 2
  ballY = VIRTUAL_HEIGHT / 2 - BALL_WH / 2
  ball = Ball(ballX, ballY, BALL_WH, BALL_WH)

  -- initial scores
  player1Score = 0
  player2Score = 0

  servingPlayer = nil
end

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- random seed
  math.randomseed(os.time())

  -- font sizes in use
  fontELarge = love.graphics.setNewFont('font.ttf', FONT_ELARGE)
  fontLarge = love.graphics.setNewFont('font.ttf', FONT_LARGE)
  fontMed = love.graphics.setNewFont('font.ttf', FONT_MED)
  fontSmall = love.graphics.setNewFont('font.ttf', FONT_SMALL)
  love.window.setTitle('Pong!')

  -- virtual screen dimensions
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

  -- sounds
  sounds = {}
  sounds.ballDies = love.audio.newSource("sounds/ball_dies.wav", "static")
  sounds.paddleSize = love.audio.newSource("sounds/paddle_shrink.wav", "static")
  sounds.paddleHit = love.audio.newSource("sounds/paddle_hit.wav", "static")
  sounds.wallHit = love.audio.newSource("sounds/wall_hit.wav", "static")

  loadGame()
  gameState = 'start'
end

-- enabling resizing
function love.resize(w, h)
  push:resize(w, h)
end

-- exit and play state key presses
function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'end' then
      loadGame()
    end
    if gameState == 'start' then
      gameState = 'play'
    else
      gameState = 'start'
      ball:reset()
    end
  end
end

function love.update(dt)
  -- player1 (left paddle) movement
  if love.keyboard.isDown('w') then
    player1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    player1.dy = PADDLE_SPEED
  else
    player1.dy = 0
  end

  -- player2 (left paddle) movement
  if love.keyboard.isDown('up') then
    player2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    player2.dy = PADDLE_SPEED
  else
    player2.dy = 0
  end

  -- game play state PLAY
  if gameState == 'play' then
    -- collision detection => change ball direction and slightly increase speed
    -- ensure ball doesn't overlap / go into the paddle
    if ball:collided(player1) then
      sounds.paddleHit:play()
      ball.dx = -ball.dx * 1.03
      ball.x = player1.x + player1.width

      -- change ball Y direction velocity randomly on collision
      if ball.dy < 0 then
        ball.dy = -math.random(50, 200)
      else
        ball.dy = math.random(50, 200)
      end
    end

    if ball:collided(player2) then
      sounds.paddleHit:play()
      ball.dx = -ball.dx * 1.03
      ball.x = player2.x - ball.width

      if ball.dy < 0 then
        ball.dy = -math.random(50, 200)
      else
        ball.dy = math.random(50, 200)
      end
    end

    -- detect collision with top edge of the screen,
    -- reset ball position and deflect it
    if ball.y <= 0 then
      sounds.wallHit:play()
      ball.y = 0
      ball.dy = -ball.dy
    end

    -- detect collision with bottom edge and handle the ball
    if ball.y >= VIRTUAL_HEIGHT - ball.height then
      sounds.wallHit:play()
      ball.y = VIRTUAL_HEIGHT - ball.height
      ball.dy = -ball.dy
    end

    -- increment score - player2 scores
    if ball.x + ball.width < 0 then
      sounds.ballDies:play()
      player2Score = player2Score + 1
      gameWinText = "Player 2 scored!"

      love.timer.sleep(1.7)

      -- increase size, make it slower
      player2.height = player2.height + 3
      player2.dy = player2.dy - player2.dy / 3

      -- decrease size, make it faster
      player1.height = player1.height - 1
      player1.dy = player1.dy + player1.dy / 3
      sounds.paddleSize:play()

      ball:reset()

      -- player1 serves
      servingPlayer = player1
      gamePlayText = "Serving Player: Player 1"
      ball.dx = 100
      gameState = 'start'

      -- check winner and declare
      if checkWinner(player2Score) then
        gameFinalWinner = "PLAYER 2 WIN!"
        gameState = 'end'
      end
    end

    -- player1 scores
    if ball.x > VIRTUAL_WIDTH then
      sounds.ballDies:play()
      player1Score = player1Score + 1
      gameWinText = "Player 1 scored!"

      love.timer.sleep(1.7)

      -- increase size, make it slower
      player1.height = player1.height + 3
      player1.dy = player1.dy - player1.dy / 3

      -- decrease size, make it faster
      player2.height = player2.height - 1
      player2.dy = player2.dy + player2.dy / 3
      sounds.paddleSize:play()

      ball:reset()

      -- player2 serves
      servingPlayer = player2
      gamePlayText = "Serving Player: Player 2"
      ball.dx = -100
      gameState = 'start'

      -- check winner and declare
      if checkWinner(player1Score) then
        gameFinalWinner = "PLAYER 1 WIN!"
        gameState = 'end'
      end
    end

    ball:update(dt)
  end

  player1:update(dt)
  player2:update(dt)
end

function love.draw()
  push:apply('start')

  if gameState == 'end' then
    love.graphics.clear(12 / 255, 123 / 255, 14 / 255, 255)

    love.graphics.setFont(fontELarge)
    printTextInCenter(player1Score, 100, 48)
    printTextInCenter('-', 0, 48)
    printTextInCenter(player2Score, -100, 48)

    love.graphics.setFont(fontLarge)
    printTextInCenter(gameFinalWinner, nil, VIRTUAL_HEIGHT / 2 - FONT_LARGE / 2)
    love.graphics.setFont(fontSmall)
    printTextInCenter("Press 'ENTER' to replay!", nil, VIRTUAL_HEIGHT / 2 + FONT_LARGE)
  else
    -- fill background color
    love.graphics.clear(123 / 255, 21 / 255, 14 / 255, 255)

    love.graphics.setFont(fontSmall)

    local gameStartText = ""
    if player1Score == 0 and player2Score == 0 then
      gameWinText = ""
    end
    gamePlayText = ""

    if gameState == 'start' then
      gameStartText = "Press 'ENTER' to start"
      printTextInCenter(gameStartText)
      printTextInCenter(gameWinText, nil, 24)
    end

    if servingPlayer == nil then
      gamePlayText = "Random serve!"
    elseif servingPlayer == player1 then
      gamePlayText = "Now serving: Player 1"
    elseif servingPlayer == player2 then
      gamePlayText = "Now serving: Player 2"
    end

    printTextInCenter(gamePlayText, nil, 64)

    love.graphics.setFont(fontLarge)
    printTextInCenter(player1Score, 60, 36)
    printTextInCenter('-', 0, 36)
    printTextInCenter(player2Score, -60, 36)

    player1:draw()
    player2:draw()

    ball:draw()
  end

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

function checkWinner(playerScore)
  if playerScore == 10
  then
    return true
  end
end
