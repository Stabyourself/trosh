explosion = class:new()

function explosion:init(x, y)
	self.x = x
	self.y = y
	self.quad = 1
	self.quadtimer = 0
	explosionsound:stop()
	explosionsound:play()
end

function explosion:update(dt)
	self.quadtimer = self.quadtimer + dt*60
	if self.quadtimer > 1 then
		self.quadtimer = self.quadtimer - 1
		self.quad = self.quad + 1
		if self.quad == 26 then
			return true
		end
	end
end

function explosion:draw()
	love.graphics.draw(explosionimg, explosionquad[self.quad], self.x*scale, self.y*scale, 0, 0.375*scale, 0.375*scale)
end