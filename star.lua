star = class:new()

function star:init()
	self.x = math.random(100)
	self.y = math.random(80)-90
	self.speed = math.random(10)+1000
end

function star:update(dt)
	if not starmover then
		self.y = self.y + self.speed*dt
	else
		self.y = self.y + math.cos(starmover)*self.speed*dt
		self.x = self.x + math.sin(starmover)*self.speed*dt
	end
	
	if self.y > 110 or self.y < -10 or self.x > 110 or self.x < -10 then
		self.speed = math.random(10)+1000
		self.x = math.random(100)
		if self.y > 110 then
			self.y = self.y-120
		elseif self.y < -10 then
			self.y = self.y+120
		elseif self.x > 110 then
			self.x = self.x-120
		else
			self.x = self.x+120
		end
	end
end

function star:draw()
	local r, g, b = love.graphics.getColor()
	love.graphics.setColor(1, 1, 1, staralpha)
	draw(starimg, self.x, self.y, 0, 1, 1, 4.5)
	love.graphics.setColor(r, g, b)
end