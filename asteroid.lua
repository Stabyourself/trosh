asteroid = class:new()

function asteroid:init(x, y, size)
	self.x = x or math.random(80)+10
	self.y = y or -10
	self.r = math.random(math.pi*20)/10
	self.size = size or 1
	self.rspeed = (math.random()*2-1)*10
	self.speedx = math.random(5)+20
	self.speedy = math.random(5)+10
	self.i = math.random(2)
	self.direction = math.random(2)
	if self.direction == 2 then
		self.direction = -1
	end
	
	if self.size == 1 then
		self.hp = 12*realasteroiddelay
	else
		self.hp = 6*realasteroiddelay
	end
end

function asteroid:update(dt)
	self.x = self.x + self.speedx*dt*self.direction
	self.y = self.y + self.speedy*dt

	if self.x > 90 then
		self.direction = -1
	elseif self.x < 10 then
		self.direction = 1
	end
	
	if self.y > 40 then
		self.speedy = 100
		self.direction = 0
	end
	
	self.r = self.r + self.rspeed*dt
	
	if self.y > 120 then
		self.dead = true
	end
	
	return self.dead
end

function asteroid:hit()
	self.hp = self.hp - 1
	if self.hp <= 0 then
		if self.size == 1 then
			table.insert(asteroids, asteroid:new(self.x, self.y, 2))
			table.insert(asteroids, asteroid:new(self.x, self.y, 2))
			pointsget(10)
		else
			pointsget(10)
		end
		lastexplosion = {self.x, self.y}
		self.dead = true
		table.insert(explosions, explosion:new(self.x-12, self.y-16))
		backgroundwhite = 1
	end
end

function asteroid:checkcol(x, y)
	if self.size == 1 then --big
		if math.abs(self.x-x) < 9 and math.abs(self.y-y) < 9 then
			return true
		end
	else
		if math.abs(self.x-x) < 6 and math.abs(self.y-y) < 6 then
			return true
		end
	end
	return false
end

function asteroid:draw()
	if self.size == 1 then
		draw(_G["asteroid-big" .. self.i .. "img"], self.x, self.y, self.r, 1, 1, 11, 9)
	else
		draw(_G["asteroid-small" .. self.i .. "img"], self.x, self.y, self.r, 1, 1, 11, 9)
	end
end