bullet = class:new()

function bullet:init(x, y, r)
	self.x = x
	self.y = y
	self.r = r
	gunfire:stop()
	gunfire:play()
end

function bullet:update(dt)
	if not self.kill then
		self.x = self.x + math.sin(self.r)*500*dt
		self.y = self.y - math.cos(self.r)*300*dt
		
		for i, v in pairs(asteroids) do
			if v:checkcol(self.x, self.y) and not v.dead then
				v:hit()
				self.kill = 0
			end
		end
	end
	
	if self.kill then
		self.kill = self.kill + dt
	end
	
	if self.kill and self.kill >= 0.2 then
		return true
	end
end

function bullet:draw()
	if self.kill then
		love.graphics.setColor(1, 1, 1, 1-self.kill/0.2)
		draw(littleexplosionimg, self.x, self.y, self.r, 1, 1, 8, 4)
		love.graphics.setColor(1, 1, 1, 1)
	else
		draw(bulletimg, self.x, self.y, self.r, 1, 1, 6, 4)
	end
end