laser = class:new()

function laser:init(x, y)
	self.i = 0
	self.x = x
	self.y = y
end

function laser:update(dt)
	local oldi = self.i
	self.i = self.i + dt*5
	
	if self.i > 1 then
		return true
	end
	
	if enemies then
		for i, v in pairs(enemies) do
			if v:checkcol(self.x + oldi*100, self.y, self.x + self.i*100) then
				v:explode()
			end
		end
	end
end

function laser:draw()
	love.graphics.setColor(getrainbowcolor(math.random(), 400))
	love.graphics.rectangle("fill", self.x*scale, self.y*scale, 100*scale*self.i, scale*2)
end