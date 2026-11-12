bird = class:new()

function bird:init(x, y)
	self.x = math.random(100)
	self.y = 90
	self.quad = 1
	self.quadtimer = 0
	self.speedx = (math.random()*2-1)*50
	self.speedy = math.random(30)+10
	
	self.dir = math.random(2)
	if self.dir == 2 then
		self.dir = -1
	end
end

function bird:update(dt)
	self.quadtimer = self.quadtimer + dt*5
	if self.quadtimer > 1 then
		self.quadtimer = self.quadtimer - 1
		if self.quad == 1 then
			self.quad = 2
		else
			self.quad = 1
		end
	end
	
	self.x = self.x + self.speedx*dt*self.dir
	self.y = self.y - self.speedy*dt
	
	if self.x > 100 then
		self.dir = -1
	elseif self.x < 0 then
		self.dir = 1
	end
	
	if self.y < -10 or self.dead then
		return true
	end
end

function bird:checkcol(x, y)
	if math.abs(self.x-x) < 7 and math.abs(self.y-y) < 4 then
		self.dead = true
		return true
	end
	return false
end

function bird:draw()
	love.graphics.draw(birdimg, birdquad[self.quad], self.x*scale, self.y*scale, 0, scale/2, scale/2, 14, 8)
end