local Bomb = require 'bomb'

GameOverState = Class{__includes = BaseState}

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    love.graphics.newFont('font.otf', 10)
    love.graphics.setColor(175/255, 53/255, 42/255, 255/255)
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 2 - 48, VIRTUAL_WIDTH, 'center')
    
    love.graphics.newFont('font.otf', 10)
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
end