enemy = class:new()

function enemy:init()
	self.quad = 1
	self.x = 100
	self.y = math.random()*20+40
	self.quadtimer = 0
	self.movement = math.random(7)-4
	if self.movement > 0 then
		self.movement = 1
	elseif self.movement < 0 then
		self.movement = -1
	end
	self.speed = math.random(30)+40
	self.dead = false
end

function enemy:update(dt)
	self.quadtimer = self.quadtimer + dt*30
	if self.quadtimer > 1 then
		self.quadtimer = self.quadtimer - 1
		self.quad = self.quad + 1
		if self.quad == 17 then
			self.quad = 1
		end
	end
	
	if self.movement == 1 then
		self.y = self.y - dt*30
		if self.y < 40 then
			self.movement = -1
		end
	elseif self.movement == -1 then
		self.y = self.y + dt*30
		if self.y > 70 then
			self.movement = 1
		end
	end
	
	self.x = self.x - self.speed*dt
	
	if self.dead then
		return true
	end
end

function enemy:explode()
	self.dead = true
	table.insert(explosions, explosion:new(self.x-5, self.y-10))
	pointsget(1)
	skycolor = getrainbowcolor(math.random())
	love.graphics.setBackgroundColor(skycolor)
end

function enemy:checkcol(x, y, newx)
	if x < self.x+4 and newx > self.x+4 and math.abs(self.y+7-y) < 6 then
		return true
	end
	return false
end

function enemy:draw()
	love.graphics.draw(enemyimg, enemyquad[self.quad], self.x*scale, self.y*scale, 0, 0.1875*scale, 0.1875*scale)
end