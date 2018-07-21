push = require 'lib/push'
Class = require 'lib/class'

require 'Bird'
require 'Pipe'
require 'PipePair'

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

-- our table of spawning PipePairs
local pipePairs = {}

-- our timer for spawning pipes
local spawnTimer = 0

-- initialize our last recorded Y value for a gap placement to base other gaps off of
local lastY = -PIPE_HEIGHT + math.random(80) + 20

-- scrolling variable to pause the game when we collide with a pipe
local scrolling = true

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
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
            % BACKGROUND_LOOPING_POINT

        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
            % VIRTUAL_WIDTH

    	pipeSpawn(dt)

        bird:update(dt)
    end

    -- reset input table
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    
    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background,  -backgroundScroll, 0)

	-- render all the pipes in our scene
    for k, pair in pairs(pipePairs) do
        pair:render()
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
    	local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        lastY = y

        table.insert(pipePairs, PipePair(y))
        spawnTimer = 0
    end

    -- for every pipe in the scene...
    for k, pair in pairs(pipePairs) do
        pair:update(dt)

        for l, pipe in pairs(pair.pipes) do
            if bird:collides(pipe) then
                scrolling = false
            end
        end

        -- if pipe is no longer visible past left edge, remove it from scene
        if pair.x < -PIPE_WIDTH then
            pair.remove = true
        end
    end

    for k, pair in pairs(pipePairs) do
        if pair.remove then
            table.remove(pipePairs, k)
        end
    end
end