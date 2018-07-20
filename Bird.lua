Bird = Class{}

local GRAVITY = 20

function Bird:init(  )
	self.image = love.graphics.newImage('resources/bird.png')
	self.width = self.image:getWidth()
    self.height = self.image:getHeight()

	-- position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)    

    -- Y velocity; gravity
    self.dy = 0
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end