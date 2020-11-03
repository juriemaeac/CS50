--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]

local BRONZE_MEDAL = love.graphics.newImage('bronze.png')
local SILVER_MEDAL = love.graphics.newImage('silver.png')
local GOLDEN_MEDAL = love.graphics.newImage('gold.png')

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()

	if self.score > 0 and self.score < 5 then
		love.graphics.draw(BRONZE_MEDAL, 190, 100)
	elseif self.score >= 5 and self.score < 10 then
		love.graphics.draw(SILVER_MEDAL, 190, 100)
	elseif self.score >= 10 then
		love.graphics.draw(GOLDEN_MEDAL, 190, 100)
	end
	
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 110, VIRTUAL_WIDTH, 'center')
	
	love.graphics.setFont(smallFont)
	if self.score == 0 then
		love.graphics.printf('You didnt get a medal! Sorry for the bad time.', 0, 130, VIRTUAL_WIDTH, 'center')
	elseif self.score > 0 and self.score < 5 then
		love.graphics.printf('You know have a bronze medal for reaching a score of ' .. tostring(self.score) .. '!', 0, 145, VIRTUAL_WIDTH, 'center')
	elseif self.score >= 5 and self.score < 10 then
		love.graphics.printf('You know have a silver medal for reaching a score of ' .. tostring(self.score) .. '!', 0, 145, VIRTUAL_WIDTH, 'center')
	elseif self.score >= 10 then
		love.graphics.printf('You know have a golden medal for reaching a score of ' .. tostring(self.score) .. '!', 0, 145, VIRTUAL_WIDTH, 'center')
	end

	love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end