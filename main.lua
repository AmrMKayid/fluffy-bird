push = require 'lib/push'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


local background = love.graphics.newImage('resources/background.png')
local ground = love.graphics.newImage('resources/ground.png')


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Fluffy Bird')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()
    
    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background, 0, 0)

    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end