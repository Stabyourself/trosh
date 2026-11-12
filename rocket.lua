rocket = class:new()

rocketspeed = 300
maxrocketspeed = 100

function rocket:init()
	self.x = 115
	self.y = 60
	self.r = 0
	self.speedx = 0
	self.ground = true
	self.startingoffset = 0
	self.thrusttimer = 0
	thrusts = {}
	machinegundelay = 0
	self.explosiondelay = 0
	self.explosiontimer = 0
end

function rocket:update(dt)
	if self.ground then
		if self.x > 50 then
			self.x = self.x - dt*50
			if self.x < 50 then
				self.x = 50
			end
		end
	else
		self.startingoffset = (math.random()*2-1)*0.5
	end
	
	if self.starting then
		self.startingtimer = self.startingtimer + dt
		self.startingoffset = (math.random()*2-1)*2
		
		if self.startingtimer > 2 then
			self.y = self.y - dt*5
			self:thrusts(dt)
		end
		
		if self.startingtimer > 7 then
			self.y = self.y + dt*50
			
			if self.y > 70 then
				self.starting = false
				self.y = 70
				changegamestate("scene3")
				self.inflight = true
			end
		end
	end
	
	if self.inflight then
		if love.keyboard.isDown("right") and self.x < 100 then
			self.speedx = self.speedx + dt*rocketspeed
		elseif self.speedx > 0 then
			self.speedx = math.max(0, self.speedx - dt*rocketspeed)
		end
		
		if love.keyboard.isDown("left") and self.x > 0 then
			self.speedx = self.speedx - dt*rocketspeed
		elseif self.speedx < 0 then
			self.speedx = math.min(0, self.speedx + dt*rocketspeed)
		end
		
		self.speedx = math.min(maxrocketspeed, math.max(-maxrocketspeed, self.speedx))
	
		self.x = self.x + self.speedx*dt
		if self.x > 100 then
			self.x = 100
		elseif self.x < 0 then
			self.x = 0
		end
			
		self.r = self.speedx/200
	
		if #pressedkeys > 0 then
			machinegundelay = machinegundelay + dt
			while machinegundelay > machinedelay do
				self:fire()
				machinegundelay = machinegundelay - machinedelay
			end
		end
		
		if wheatleytimer then
			wheatleytimer = wheatleytimer + dt*2
			wheatleyr = wheatleyr + dt*10
			
			if wheatleytimer >= 0.95 and wheatleytimer - dt*2 < 0.95 then
				table.insert(explosions, explosion:new(self.x-20, self.y-20))
				rocketimg = love.graphics.newImage("graphics/rocketkaputt.png")
				changegamestate("scene4")
				self.hit = true
				self.inflight = false
			end
		end
	end
	shakeamount = self.startingoffset*3
	
	if self.hit then
		wheatleytimer = wheatleytimer + dt*2
		wheatleyr = wheatleyr + dt*10
		if wheatleytimer < 4 then
			if self.r > 0 then
				self.r = self.r - dt
			else
				self.r = self.r + dt
			end
		else
			if self.r < math.pi*0.9 then
				self.r = self.r + dt
				starmover = -self.r
				self.y = self.y - dt*20
				if self.x > 10 then
					self.x = self.x - dt*10
				elseif self.x < 10 then
					self.x = self.x + dt*10
				end
			end
		end
		
		self.explosiontimer = self.explosiontimer + dt
		while self.explosiontimer > self.explosiondelay do
			self.explosiontimer = self.explosiontimer - self.explosiondelay
			self.explosiondelay = math.random(100)/300+0.1
			table.insert(explosions, explosion:new(self.x-16+math.random(16)-8, self.y-20+math.random(16)-8))
		end
		self.startingoffset = self.startingoffset*10
	end
	
	--THRUSTS
	local delete = {}
	
	for i, v in pairs(thrusts) do
		if v:update(dt) == true then
			table.insert(delete, i)
		end
	end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for i, v in pairs(delete) do
		table.remove(thrusts, v) --remove
	end
end

function rocket:fire()
	local outx = -math.sin(self.r) * -14 + self.x
	local outy = math.cos(self.r) * -14 + self.y
	
	table.insert(bullets, bullet:new(outx, outy, self.r))
end

function rocket:thrusts(dt) --if you know what I mean
	self.thrusttimer = self.thrusttimer + dt
	local delay = 0.01
	while self.thrusttimer > delay do
		self.thrusttimer = self.thrusttimer - delay
		table.insert(thrusts, thrust:new(self.x-6, self.y+10))
		table.insert(thrusts, thrust:new(self.x, self.y+10))
		table.insert(thrusts, thrust:new(self.x+6, self.y+10))
	end
end

function rocket:start()
	self.starting = true
	self.ground = false
	self.startingtimer = 0
end

function rocket:checkcol(x, y)
	if math.abs(self.x-x) < 16 and math.abs(self.y-y) < 16 then
		return true
	end
	return false
end

function rocket:draw()
	local r, g, b = love.graphics.getColor()
	for i, v in pairs(thrusts) do
		v:draw()
	end
	love.graphics.setColor(r, g, b)
	draw(rocketimg, self.x+self.startingoffset, self.y, self.r, 1, 1, 15, 16)
	
	if wheatleytimer then
		if wheatleytimer <= 0.95 then
			draw(wheatleyimg, self.x-20*(1-wheatleytimer/1), self.y-120*(1-wheatleytimer/1), wheatleyr, 1, 1, 8, 9)
		else
			draw(wheatleyimg, self.x-20*(1-0.95/1)-(wheatleytimer-0.95)*200, self.y-120*(1-wheatleytimer/1)+(wheatleytimer-0.95)*20, wheatleyr, 1, 1, 8, 9)
		end
	end
end

function rocket:wheatleyattack()
	wheatleytimer = 0
	wheatleyr = 0
	space:play()
end

--THRUST

thrust = class:new()

function thrust:init(x, y)
	self.x = x
	self.y = y
	self.starty = rockets[1].y
	self.dir = (math.random()*2-1)*0.4+math.pi/2 + rockets[1].r
	self.speed = 40
	self.life = 1
end

function thrust:update(dt)
	self.x = self.x + math.cos(self.dir)*self.speed*dt
	self.y = self.y + math.sin(self.dir)*self.speed*dt
	
	self.life = self.life - dt
	if self.life <= 0 then
		return true
	end
end

function thrust:draw()
	love.graphics.setColor(1, 1, 1, self.life)
	love.graphics.rectangle("fill", self.x*scale, self.y*scale+(rockets[1].y-self.starty)*scale, scale, scale)
end