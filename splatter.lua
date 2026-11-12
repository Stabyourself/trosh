splatter = class:new()

function splatter:init(x, y)
	self.x = x
	self.y = y
	self.quad = 1
	self.quadtimer = 0
end

function splatter:update(dt)
	self.quadtimer = self.quadtimer + dt*30
	if self.quadtimer > 1 then
		self.quadtimer = self.quadtimer - 1
		self.quad = self.quad + 1
		if self.quad == 7 then
			return true
		end
	end
end

function splatter:draw()
	love.graphics.draw(splatterimg, splatterquad[self.quad], self.x*scale, self.y*scale, 0, scale/2, scale/2, 40, 40)
end