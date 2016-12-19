function scene5_load()
	love.graphics.setBackgroundColor(153, 217, 234)
	love.audio.play(bgmusic)
	
	clouds2 = {}
	for i = 1, 3 do
		for y = 1, 8 do
			table.insert(clouds2, cloud2:new(math.random()*140))
		end
	end
	
	lastexplosion = {50, 40}
	
	starttimer = 0
	flyingquad = 3
	
	playerx = 50
	playery = 20
	pspeedx = 0
	pspeedy = 0
	
	birds = {}
	splatters = {}
	birdtimer = 0
	
	flyanimationtimer = 0
	
	shakeamount = 5
	awesometimer = 0
	
	screenx = 0
	
	landingtime = 2
	groundy = 90
	
	landing = false
end

function scene5_update(dt)
	if starttimer < 20 then
		birdtimer = birdtimer + dt
		local birddelay = 0.5
		while birdtimer > birddelay do
			birdtimer = birdtimer - birddelay
			table.insert(birds, bird:new())
		end
	end
	
	if starttimer >= 25 and starttimer - dt < 25 then
		landing = true
		timeleft = landingtime
		landingx = math.random(60)+20
	end
	
	if starttimer >= 25.4 and starttimer - dt < 25.4 then
		approach:play()
	end
	
	if landing then
		timeleft = timeleft - dt
		if timeleft <= 0 then
			timeleft = 0
			groundy = groundy - 400*dt
			if groundy <= playery-10 then
				changegamestate("scene6")
			end
		end
	end

	for i,v in pairs(clouds2) do
		v:update(dt)
	end
	
	flyanimationtimer = flyanimationtimer + dt
	while flyanimationtimer > 0.1 do
		flyanimationtimer = flyanimationtimer - 0.1
		if flyingquad == 3 then
			flyingquad = 4
		else
			flyingquad = 3
		end
	end
	
	if awesometimer > 0 then
		awesometimer = awesometimer - dt
	end
	
	if landing or starttimer < 24 then
		playermovement2(dt)
	else
		if playerx > 50 then
			playerx = playerx - 50*dt
		elseif playerx < 50 then
			playerx = playerx + 50*dt
		end
		
		if playery > 40 then
			playery = playery - 50*dt
		elseif playery < 40 then
			playery = playery + 50*dt
		end
	end
	
	
	--BIRDS
	local delete = {}
	
	for i, v in pairs(birds) do
		if v:update(dt) == true then
			table.insert(delete, i)
		end
	end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for i, v in pairs(delete) do
		table.remove(birds, v) --remove
	end
	
	
	--SPLATTERS
	local delete = {}
	
	for i, v in pairs(splatters) do
		if v:update(dt) == true then
			table.insert(delete, i)
		end
	end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for i, v in pairs(delete) do
		table.remove(splatters, v) --remove
	end
	
	for i, v in pairs(birds) do
		if v:checkcol(playerx, playery) then
			splat:stop()
			splat:play()
			pointsget(20)
			table.insert(splatters, splatter:new(v.x, v.y))
			skycolor = getrainbowcolor(math.random(), 400)
			love.graphics.setBackgroundColor(skycolor)
			lastexplosion = {v.x, v.y}
		end
	end
end

function playermovement2(dt)
	if love.keyboard.isDown("left") then
		playerx = math.max(0, playerx-dt*movement1speed)
	elseif love.keyboard.isDown("right") then
		playerx = math.min(100, playerx+dt*movement1speed)
	end
	
	if not landing then
		if love.keyboard.isDown("up") then
			playery = math.max(0, playery-dt*movement1speed)
		elseif love.keyboard.isDown("down") then
			playery = math.min(80, playery+dt*movement1speed)
		end
	end
end

function scene5_draw()
	local r, g, b = love.graphics.getColor()
	love.graphics.setColor(math.random(255), math.random(255), math.random(255), 100*math.min(1, (starttimer/2)))
	for i = 1, backgroundstripes, 2 do
		local pos = {playerx, playery}
		local alpha = math.rad((i/backgroundstripes + math.mod(sunrot/100, 1)) * 360)
		local point1 = {pos[1]*scale+200*scale*math.cos(alpha), pos[2]*scale+200*scale*math.sin(alpha)}
		
		local alpha = math.rad(((i+1)/backgroundstripes + math.mod(sunrot/100, 1)) * 360)
		local point2 = {pos[1]*scale+200*scale*math.cos(alpha), pos[2]*scale+200*scale*math.sin(alpha)}
		
		love.graphics.polygon("fill", pos[1]*scale, pos[2]*scale, point1[1], point1[2], point2[1], point2[2])
	end
	love.graphics.setColor(r, g, b, 255)

	for i,v in pairs(clouds2) do
		v:draw()
	end
	for i,v in pairs(birds) do
		v:draw()
	end
	for i,v in pairs(splatters) do
		v:draw()
	end
	
	if groundy < 90 then
		draw(groundwinimg, -200+landingx+2, groundy)
	end
	
	love.graphics.drawq(playerimg, playerquad[flyingquad], (playerx)*scale, playery*scale, 0, scale, scale, 13, 6)
	
	
	if sunglasses then
		draw(sunglassesimg, playerx+4, playery)
	end
	
	if awesometimer > 0 then
		draw(awesomeimg, (awesometimer*2-1)*100, 0)
		love.graphics.setColor(0, 0, 0)
		properprint("1000 points!", (awesometimer*2-1)*100+3, 73, scale)
		love.graphics.setColor(255, 255, 255)
	end
	
	if starttimer > 24 then
		if math.mod(starttimer*5, 2) >= 1 then
			love.graphics.setColor(255, 0, 0)
			properprint("land in the target!", 0, 20, scale/1.5)
			love.graphics.setColor(255, 255, 255)
		end
	end
	
	if landing then
		draw(arrowimg, math.max(8, landingx-(timeleft/landingtime)*80), 67, 0, 1, 1, 8)
		draw(arrowimg, math.min(91, landingx+(timeleft/landingtime)*80), 67, 0, -1, 1, 9)
	end
end

function scene5_action()
	if not sunglasses then
		sunglasses = true
		awesometimer = 1
		pointsget(1000)
		sunglassessound:play()
	end
end