cloud = class:new()

function cloud:init(random, y)
	if y then
		self.starty = y
	end
	self.x = math.random()*100
	self.y = y or math.random()*20+3
	self.i = math.random(2)
	self.speed = math.random()*20+50
end

function cloud:update(dt)
	if not rockets or rockets[1].x > 50 then
		self.x = self.x - self.speed*dt
	else
		self.x = self.x - self.speed*0.3*dt
	end
	
	if self.x < - _G["cloud" .. self.i .. "img"]:getWidth() then
		self.x = 100
		self.y = self.starty or math.random()*20+3
		self.i = math.random(2)
		self.speed = math.random()*20+50
	end
end

function cloud:draw()
	draw(_G["cloud" .. self.i .. "img"], self.x, self.y)
end