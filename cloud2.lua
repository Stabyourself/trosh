cloud2 = class:new()

function cloud2:init(y)
	self.x = math.random()*100
	self.y = 120+y
	self.i = math.random(2)
	self.speed = -500
end

function cloud2:update(dt)
	self.y = self.y + self.speed*dt
	
	if self.y < -20 then
		self.y = self.y+140
		self.x = math.random()*100
		self.i = math.random(2)
	end
end

function cloud2:draw()
	draw(_G["cloud" .. self.i .. "img"], self.x, self.y, 0, 1, 1, 15)
end