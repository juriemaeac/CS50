push = require 'push'
Class = require 'class'
require 'Paddle' 
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

AI_HIT = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    background = love.graphics.newImage("background.png")
    
    love.window.setTitle('Pong')
    math.randomseed(os.time())
    smallFont = love.graphics.newFont('font.ttf', 20)
    largeFont = love.graphics.newFont('font.ttf', 30)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('pad_hit.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('wall_hit.wav', 'static'),

        ['music'] = love.audio.newSource('bg.mp3', 'static')
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    player1Score = 0
    AIPlayerScore = 0
    servingPlayer = 'You'

    player1 = Paddle(10, 30, 5, 25)
    AIPlayer = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30, 5, 25)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    gameState = 'start'
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if gameState == 'serve' then
     
        ball.dy = math.random(-50, 50)
        if servingPlayer == 'You' then
            ball.dx = math.random(140, 200)
            AI_HIT = math.random(2, 10)
        else
            ball.dx = -math.random(140, 200)
            AI_HIT = math.random(2, 10)
        end
    elseif gameState == 'play' then
        
        if ball.dx > 0 then
            if ball.x > 100 then
                if AI_HIT < 7 then
                    if AIPlayer.y > ball.y then
                        AIPlayer.dy = -PADDLE_SPEED
                    elseif AIPlayer.y +40 < ball.y then     
                        AIPlayer.dy = PADDLE_SPEED       
                    else 
                        AIPlayer.dy = 0
                    end
                else
                    if AIPlayer.y - 3 > ball.y and AIPlayer.y - 0 > ball.y then
                        AIPlayer.dy = -PADDLE_SPEED
                    elseif AIPlayer.y +40 < ball.y and AIPlayer.y +23 < ball.y then     
                        AIPlayer.dy = PADDLE_SPEED       
                    else 
                        AIPlayer.dy = 0
                    end
                end
            end
        end

        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5
            AI_HIT = math.random(1, 10)

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end
        if ball:collides(AIPlayer) then
            ball.dx = -ball.dx * 1.03
            ball.x = AIPlayer.x - 4
            AIPlayer.dy = 0
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end

        --up
        if ball.y <= 12 then
            ball.y = 12
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        --down
        if ball.y >= VIRTUAL_HEIGHT - 16 then
            ball.y = VIRTUAL_HEIGHT - 16
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        --right side
        if ball.x < 12 then
            servingPlayer = 'You'
            AIPlayerScore = AIPlayerScore + 1
            sounds['score']:play()

            if AIPlayerScore == 3 then
                winningPlayer = 'Computer'
                gameState = 'done'
            else
                gameState = 'serve'
    
                ball:reset()
            end
        end

        --left side
        if ball.x > VIRTUAL_WIDTH - 12 then
            servingPlayer = 'Computer'
            player1Score = player1Score + 1
            sounds['score']:play()

            if player1Score == 3 then
                winningPlayer = 'You'
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
    end

    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    AIPlayer:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' or key == 'space'then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'

            ball:reset()

            player1Score = 0
            AIPlayerScore = 0

            if winningPlayer == 'You' then
                servingPlayer = 'Computer'
            else
                servingPlayer = 'You'
            end
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(255,255,255)
    love.graphics.draw(background)
    push:apply('start')
    
	--border
    love.graphics.rectangle("line", 5, 5, VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 15, segments)
	love.graphics.setLineWidth(2)
    --displayScore()

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf('Welcome to Pong!', 0, 30, VIRTUAL_WIDTH, 'center')
        love.graphics.rectangle('line', VIRTUAL_WIDTH / 2 - 160, VIRTUAL_HEIGHT / 2 - 40, 320, 80)
        love.graphics.printf('Press Enter to start!', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Note: best of 3 points.', 0, VIRTUAL_HEIGHT/2 + 80, VIRTUAL_WIDTH, 'center')
        
    elseif gameState == 'play' then
        ball:render()
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(servingPlayer .. " serve next!\nPress enter when ready",
        0, 30, VIRTUAL_WIDTH, 'center')
        --love.graphics.line(215, 232, 215, 6)
        displayScore()
        
    elseif gameState == 'done' then
        love.graphics.setFont(largeFont)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(winningPlayer .. ' wins!',0, 150, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, VIRTUAL_HEIGHT/2 + 80, VIRTUAL_WIDTH, 'center')
        displayScore()
    end

    player1:render()
    AIPlayer:render()
    
    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function displayScore()
    love.graphics.setFont(scoreFont)
    if player1Score > AIPlayerScore then
        love.graphics.setColor(0, 255, 0)
    elseif player1Score < AIPlayerScore then
        love.graphics.setColor(255, 0, 0)
    else
        love.graphics.setColor(255, 255, 255)
    end
    --love.graphics.print(tostring(player1Score),0,VIRTUAL_HEIGHT / 4 - 32,VIRTUAL_WIDTH,'center')
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,VIRTUAL_HEIGHT / 3)
    if player1Score < AIPlayerScore then
        love.graphics.setColor(0, 255, 0)
    elseif player1Score > AIPlayerScore then
        love.graphics.setColor(255, 0, 0)
    else
        love.graphics.setColor(255, 255, 255)
    end
    --love.graphics.print(tostring(AIPlayerScore),0,3 * VIRTUAL_HEIGHT / 4 - 32,VIRTUAL_WIDTH,'center')
    love.graphics.print(tostring(AIPlayerScore), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end
