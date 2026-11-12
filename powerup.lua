powerup = class:new()

function powerup:init()
	self.x = 108
	self.y = math.random()*20+40
	self.speed = 30
	self.movement = 1
	self.blinktimer = 0
	self.blink = true
end

function powerup:update(dt)	
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
	
	self.blinktimer = self.blinktimer + dt
	if self.blinktimer > 0.2 then
		self.blinktimer = self.blinktimer - 0.5
		self.blink = not self.blink
	end

	self.x = self.x - self.speed*dt
end

function powerup:checkcol(x, y)
	if math.abs(self.x+8-x) < 10 and math.abs(self.y+4-y) < 10 then
		return true
	end
	return false
end

function powerup:draw()
	draw(powerupimg, self.x, self.y, 0, 1, 1, 8, 4)
	love.graphics.setColor(1, 0, 0)
	if self.x > 0 and self.blink then
		properprint("collect the powerup!!!", 10, 45, scale*0.5)
	end
end