function scene1_load()
	shakeamount = 0
	shake = 0
	fade = 1
	enemies = {}
	powerups = {}
	enemytimer = 0
	nextenemy = 0
	nextstage = false
end

function scene1_update(dt)
	if shakeamount > 0 then
		shakeamount = math.max(0, shakeamount-dt*10)
	end
	
	enemytimer = enemytimer + dt
	while enemytimer > nextenemy and not nextstage do
		enemytimer = enemytimer - nextenemy
		if massenemies then
			nextenemy = math.random(10)/1000+.002
		else
			nextenemy = math.random(10)/10+.1
		end
		table.insert(enemies, enemy:new())
	end
	rainbowi = math.mod(rainbowi + dt/2, 1)
	

	for i, v in pairs(clouds) do
		v:update(dt)
	end
	for i, v in pairs(bushes) do
		v:update(dt)
	end
	for i, v in pairs(powerups) do
		v:update(dt)
	end
	
	if starttimer > 32 and starttimer - dt < 32 then
		table.insert(powerups, powerup:new())
	end
	
	if starttimer > 45 and starttimer - dt < 45 then
		nextstage = true
	end
	
	if starttimer > 47 and starttimer - dt < 47 then
		rockets = {rocket:new()}
	end
	
	if powerups[1] and powerups[1]:checkcol(playerx, playery) then
		reallaserdelay = 0.05
		massenemies = true
		powerups[1] = nil
	end
	
	--ENEMIES
	local delete = {}
	
	for i, v in pairs(enemies) do
		if v:update(dt) == true then
			table.insert(delete, i)
		end
	end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for i, v in pairs(delete) do
		table.remove(enemies, v) --remove
	end
	
	--EXPLOSION
	local delete = {}
	
	for i, v in pairs(explosions) do
		if v:update(dt) == true then
			table.insert(delete, i)
		end
	end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for i, v in pairs(delete) do
		table.remove(explosions, v) --remove
	end
	
	if fade > 0 then
		fade = math.max(0, fade-dt)
	end
	
	playerframetimer = playerframetimer + dt*10
	while playerframetimer >= 2 do
		playerframetimer = playerframetimer - 2
	end
	playerframe = math.floor(playerframetimer)+1
	
	if not rockets or rockets[1].x > 50 then
		scrollx = scrollx + dt*50
	end
	
	if rockets and rockets[1]:checkcol(playerx, playery) and rockets[1].x <= 50 then
		changegamestate("scene2")
	end
	
	playermovement1(dt)
	
	if rockets then
		rockets[1]:update(dt)
	end
end

function playermovement1(dt)
	if love.keyboard.isDown("left") then
		playerx = math.max(0, playerx-dt*movement1speed)
	elseif love.keyboard.isDown("right") then
		playerx = math.min(100, playerx+dt*movement1speed)
	end
	
	if love.keyboard.isDown("up") then
		playery = math.max(50, playery-dt*movement1speed)
	elseif love.keyboard.isDown("down") then
		playery = math.min(80, playery+dt*movement1speed)
	end
end

function scene1_action()
	shootlaser()
end

function shootlaser()
	if laserdelay == 0 then
		table.insert(lasers, laser:new(playerx, playery-8))
		lasersound:stop()
		lasersound:play()
		laserdelay = reallaserdelay
	end
end

function scene1_draw()
	local r, g, b = love.graphics.getColor()
	love.graphics.setColor(math.random(255), math.random(255), math.random(255), 255*(1-scoreanim))
	for i = 1, backgroundstripes, 2 do
		local alpha = math.rad((i/backgroundstripes + math.mod(sunrot/100, 1)) * 360)
		local point1 = {50*scale+100*scale*math.cos(alpha), 64*scale+100*scale*math.sin(alpha)}
		
		local alpha = math.rad(((i+1)/backgroundstripes + math.mod(sunrot/100, 1)) * 360)
		local point2 = {50*scale+100*scale*math.cos(alpha), 64*scale+100*scale*math.sin(alpha)}
		
		love.graphics.polygon("fill", 50*scale, 64*scale, point1[1], point1[2], point2[1], point2[2])
	end
	love.graphics.setColor(r, g, b, 255)

	for i, v in pairs(clouds) do
		v:draw()
	end
	
	for i = 1, 2 do
		draw(groundimg, -math.mod(scrollx, 100) + (i-1)*100, 59)
	end
	for i, v in pairs(bushes) do
		v:draw()
	end
	for i, v in pairs(enemies) do
		v:draw()
	end
	for i, v in pairs(explosions) do
		v:draw()
	end
	
	if rockets then
		rockets[1]:draw()
	end
	
	love.graphics.drawq(playerimg, playerquad[playerframe], playerx*scale, playery*scale, 0, scale, scale, 7, 12)
	for i, v in pairs(lasers) do
		v:draw()
	end
	love.graphics.setColor(255, 255, 255)
	for i, v in pairs(powerups) do
		v:draw()
	end
	
	if starttimer > 46 then
		love.graphics.setColor(255, 0, 0)
		properprint("get in the rocket!!!", 10, 45, scale*0.5)
	end
	love.graphics.setColor(255, 255, 255)
end