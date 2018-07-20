Bird = Class{}

function Bird:init(  )
	self.image = love.graphics.newImage('resources/bird.png')
	self.width = self.image:getWidth()
    self.height = self.image:getHeight()

	-- position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)    
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end