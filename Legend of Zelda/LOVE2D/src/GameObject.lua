--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid
    self.consumable = def.consumable
    self.pickable = def.pickable or false

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    self.travel = def.travel or 0
    self.direction = def.direction or ""

    -- default empty collision callback
    self.onCollide = def.onCollide or function() end
    self.onConsume = def.onConsume or function() end
    self.onPick = def.onPick or function() end
end

function GameObject:collides(target)
    return not (target.x > self.x + self.width or self.x > target.x + target.width or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

function GameObject:update(player, room, dt)
    --self.direction = player.direction

    if self.type == "pot" and self.state == "broken" then 
        Timer.after(1, function ()                                        
            self.state = "removed"
        end)
    end

    if self.type == "pot" and self.state == 'projectile' then 
        if self.direction == "up" then
            self.y = self.y - .8
        elseif self.direction == "down" then
            self.y = self.y + 1
        elseif self.direction == "left" then
            self.x = self.x - 1
        elseif self.direction == "right" then
            self.x = self.x + 1
        end

        self.travel = self.travel + 1

        self:checkWallCollision(room, player)
        self:checkEntityCollision(room)

        if self.travel > TILE_SIZE * 3 then self.state = "broken" end
    end

end


function GameObject:checkWallCollision(room, player)
    local direction = self.direction
    if direction == 'left' then
        
        if self.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then 
            self.state = "broken"
        end
    elseif direction == 'right' then
        if self.x + self.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
            self.state = "broken"
        end
    elseif direction == 'up' then
        if self.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2 then 
            self.state = "broken"
        end
    elseif direction == 'down' then
        local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
            + MAP_RENDER_OFFSET_Y - TILE_SIZE

        if self.y + self.height >= bottomEdge then
            self.state = "broken"
        end
    end
end

function GameObject:checkEntityCollision(room)
    for i = #room.entities, 1, -1 do
        local entity = room.entities[i]

        -- check collision of entities with projectile object (pot)
        if entity:collides(self) then
            self.state = "broken"
            entity:damage(1)
            entity.onCollide(entity)
            gSounds['hit-enemy']:play()
        end 

    end
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end