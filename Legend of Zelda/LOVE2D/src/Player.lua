--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

-- function to check if a target can be picked by the player, based on distance; how close it player to the tareget object
function Player:canPick(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2

    return math.abs((self.x + self.width) - target.x) < 2 or 
            math.abs((target.x + target.width) - self.x) < 2 or 
            math.abs((selfY + selfHeight) - target.y) < 2 or 
            math.abs((target.y + target.height) - selfY) < 2
end

function Player:render()
    Entity.render(self)
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end