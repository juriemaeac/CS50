local bump = require "lib/bump"
local screen = require "lib/shack/shack"
local Vector = require 'vector'
local Player = require 'player'
local Enemy = require 'enemy'
local Bomb = require 'bomb'
local SoftObject = require 'softObject'
local Wall = require 'wall'
local Map = require 'map'
local cron = require 'cron'

local seconds = 180 --time limit
local msg = " "
local timer = cron.every(1, function() seconds = seconds - 1 end)

--after 180 secs saka lalabas
local atimer = cron.after(180, function() msg = "TIMES'S UP!!!" end) 
love.graphics.setDefaultFilter("nearest", "nearest")


audio = {
	battleMusic = love.audio.newSource('res/audio/music/background.mp3', 'stream'),
	explosion = love.audio.newSource('res/audio/sfx/Explosion1.wav', 'static'),
	collectPowerUp = love.audio.newSource('res/audio/sfx/collectPowerUp.wav', 'static'),
	clock = love.audio.newSource('res/audio/music/clock.wav', 'static'),
}

debug = false

function love.load() ----------------------------------------------------------------------------------------
	world = bump.newWorld()

	--background and tiles
	map = Map('dungeon')
	safetyGrid = {}
	for y = 1, map.height do
		safetyGrid[y] = {}
		for x = 1, map.width do
			safetyGrid[y][x] = 0
		end
	end

	player = Player(15, 15)
	world:add(player, player.position.x, player.position.y, player.width, player.height)
	
	--enemy1 = Enemy(15 * 17, 15 * 11) lower right ung location (pwede pang AI)
	enemy2 = Enemy(15 * 17, 15)
	--enemy3 = Enemy(15, 15 * 11) lower left ung location (pwede pang AI)
	--objects = {player, enemy1, enemy2, enemy3}
	objects = {player, enemy2}


	map:foreach(function(x, y, tile, collidable)
		local chance = math.random()
		if collidable == 0 and not map:isSpawnLocation(x, y) and chance < 0.7 then
			local softObject = SoftObject((x - 1) * 15, (y - 1) * 15, math.random(1,5))
			table.insert(objects, softObject)
			world:add(softObject, softObject.position.x, softObject.position.y, softObject.width, softObject.height)
		elseif collidable == 1 then
			local x = x - 1
			local y = y - 1
			local wall = Wall(x * 15, y * 15)
			table.insert(objects, wall)
		end
	end)

	--whole game size
	scale = 3.3
	background = love.graphics.newCanvas(width, height)
	arena = love.graphics.newCanvas(map.width * map.tilewidth, map.height * map.tileheight)

	--background music loop
	audio.battleMusic:play()
	audio.battleMusic:setLooping(true)

	--timer and score font and size
	love.graphics.setDefaultFilter('nearest', 'nearest')
	smallFont = love.graphics.newFont('font.ttf', 30)
	xsmallFont = love.graphics.newFont('font.ttf', 20)
	
end
function love.update(dt) ------------------------------------------------------------------------------------
	map:update(dt)
	screen:update(dt)

	for _, object in ipairs(objects) do
		object:update(dt)
	end

	local toRemove = {}
	for i, object in ipairs(objects) do
		if object.remove then
			table.insert(toRemove, i)
			world:remove(object)
		end
	end
	for i = #toRemove, 1, -1 do
		local index = toRemove[i]
		table.remove(objects, index)
	end
	timer:update(dt)
	atimer:update(dt)
end

function love.draw() ----------------------------------------------------------------------------------------
	
	--timer
	love.graphics.setFont(smallFont)
	--need pa ayusin timer, nag nenegative
	--kapag nag 0 times up then game over lalabas na ung winner
	love.graphics.print("Timer: "..seconds, 50, 10) 

	--need ayusin kapag lumabas to game over na
	--WE NEED STATES
	love.graphics.print(msg, 1050, 14) 
	love.graphics.setCanvas()

	--score
	--no score pa wala pang colored tiles
	love.graphics.setFont(smallFont)
	love.graphics.print("Player1 Score: ", 300, 10) 
	love.graphics.print("Player2 Score: ", 700, 10) 
	

	-- y-sort objects
	--kapag pinindot tab while in playing lalabas ung gridlines and fps
	table.sort(objects, function(a, b)
		return a.position.y + a.height < b.position.y + b.height
	end)
	love.graphics.setCanvas(arena)
	love.graphics.clear()
	map:drawWalls(0, 0)
	for _, object in ipairs(objects) do
		object:draw()
	end

	if debug then
		for _, item in ipairs(world:getItems()) do
			local x, y, w, h = world:getRect(item)
			love.graphics.rectangle('line', x, y, w, h)
		end
		love.graphics.print('FPS: ' .. love.timer.getFPS())
	end

	love.graphics.setCanvas(background)
	
	--floor
	map:drawFloor(68 - 15, 34 - 15)

	love.graphics.draw(map.background)
	love.graphics.setCanvas()

	screen:apply()
	love.graphics.push()
	love.graphics.scale(scale)
	--background (width, height)
	love.graphics.draw(background, 15, 15, 0, 1, 1, 0, 0)
	--crates (width, height)
	love.graphics.draw(arena, 67 - 15, 34 - 15, 0, 1, 1, 0, 0)
	love.graphics.pop()

end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	elseif key == 'tab' then
		debug = not debug
	elseif key == 'space' then
		if player.usedBombs < player.maxBombs then
			local tile = map:toWorld(map:toTile(player.position + Vector(6, 4)))
			local occupied = false
			local items, _ = world:queryRect(tile.x, tile.y, 15, 15)
			for _, item in ipairs(items) do
				if item:is(Bomb) then
					occupied = true
				end
			end
			if not occupied then
				local bomb = Bomb(player, tile.x, tile.y)
				table.insert(objects, bomb)
				player.usedBombs = player.usedBombs + 1
			end
		end
	
	end
end
