io.stdout:setvbuf('no')
--[[Original game

Author: ZIPPS
Aloc, Jhon Robert
Antolin, John Lorenz
Castronuevo, Jurie Mae
Dioso, Dianne Yvory

]]


push = require 'push'
Class = require 'class'

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('SPLABOOM!')
    love.graphics.setDefaultFilter('nearest', 'nearest')

end