
local Object = require 'lib.classic.classic'

function PlayState:init()
    
    self.score = 0
    self.timer = 600

    -- subtract 1 from timer every second
    Timer.every(1, function()
        self.timer = self.timer - 1

        -- play warning sound on timer if we get low
        if self.timer <= 5 then
            gSounds['clock']:play()
        end
    end)
end

function PlayState:enter(params)
    

end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- go back to start if time runs out
    if self.timer <= 0 then
        
        -- clear timers from prior PlayStates
        Timer.clear()
        
        gSounds['game-over']:play()

        gStateMachine:change('game-over', {
            score = self.score
        })
    end


    Timer.update(dt)
end

function PlayState:render()
    -- GUI text
    love.graphics.setColor(99, 155, 255, 255) 
    love.graphics.newFont('font.otf', 10)
    love.graphics.printf('Score: ' .. tostring(self.score), 20, 52, 182, 'center')
    love.graphics.printf('Timer: ' .. tostring(self.timer), 20, 108, 182, 'center')

end