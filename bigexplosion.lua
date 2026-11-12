bigexplosion = class:new()

function bigexplosion:init(x, y)
	self.x = x
	self.y = y
	self.quad = 1
	self.quadtimer = 0
end

function bigexplosion:update(dt)
	self.quadtimer = self.quadtimer + dt*3
	while self.quadtimer > 1 do
		self.quadtimer = self.quadtimer - 1
		self.quad = self.quad + 1
		if self.quad == 26 then
			return true
		end
	end
end

function bigexplosion:draw()
	local r, g, b = love.graphics.getColor()
	if starttimer > 0 then
		love.graphics.setColor(1, 1, 1, math.min(1, math.max(0, (1-starttimer/7))))
	end
	if self.quad <= 25 then
		love.graphics.draw(bigexplosionimg, bigexplosionquad[self.quad], self.x*scale, self.y*scale, 0, scale, scale)
	end
	love.graphics.setColor(r, g, b)
end