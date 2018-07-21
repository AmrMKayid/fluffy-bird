push = require 'lib/push'
Class = require 'lib/class'

require 'Bird'
require 'Pipe'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


local background = love.graphics.newImage('resources/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('resources/ground.png')
local groundScroll = 0

-- speed at which we should scroll our images, scaled by dt
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 413

-- our bird sprite
local bird = Bird()

-- our table of spawning Pipes
local pipes = {}

-- our timer for spawning pipes
local spawnTimer = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Fluffy Bird')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
	-- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    New function used to check our global input table for keys we activated during
    this frame, looked up by their string value.
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % VIRTUAL_WIDTH

	pipeSpawn(dt)

    bird:update(dt)

    -- reset input table
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    
    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background,  -backgroundScroll, 0)

	-- render all the pipes in our scene
    for k, pipe in pairs(pipes) do
        pipe:render()
    end

    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    bird:render()

    push:finish()
end


function pipeSpawn( dt )
	spawnTimer = spawnTimer + dt

    -- spawn a new Pipe if the timer is past 2 seconds
    if spawnTimer > 2 then
        table.insert(pipes, Pipe())
        print('Added new pipe!')
        spawnTimer = 0
    end

    -- for every pipe in the scene...
    for k, pipe in pairs(pipes) do
        pipe:update(dt)

        -- if pipe is no longer visible past left edge, remove it from scene
        if pipe.x < -pipe.width then
            table.remove(pipes, k)
        end
    end
end