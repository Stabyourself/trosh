bush = class:new()

function bush:init()
	self.x = math.random()*100
	self.y = math.random()*20+57
	self.i = math.random(2)
	self.speed = 50
end

function bush:update(dt)
	if not rockets or rockets[1].x > 50 then
		self.x = self.x - self.speed*dt
	end
	
	if self.x < - _G["bush" .. self.i .. "img"]:getWidth() then
		self.x = 100
		self.y = math.random()*20+57
		self.i = math.random(2)
		self.speed = 50
	end
end

function bush:draw()
	draw(_G["bush" .. self.i .. "img"], self.x, self.y)
end