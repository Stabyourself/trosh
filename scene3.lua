function scene3_load()
	backgroundwhite = 0
	staralpha = 1
	asteroids = {}
	bullets = {}
	asteroidtimer = 0
	rockets = {rocket:new()}
	love.audio.play(bgmusic)
	rockets[1].x = 50
	rockets[1].y = 70
	rockets[1].ground = false
	rockets[1].inflight = true
	
	table.insert(asteroids, asteroid:new())
	
	if #stars == 0 then
		for i = 1, 10 do
			table.insert(stars, star:new())
		end
	end
	
	lastexplosion = {50, 40}
	
	pressedkeys = {}
	starttimer = 0
	warningtimer = 0
end

function scene3_update(dt)
	realasteroiddelay = math.max(0.05, 8/starttimer)
	backgroundwhite = math.max(0, backgroundwhite - dt)
	love.graphics.setBackgroundColor(math.random(127)*backgroundwhite, math.random(127)*backgroundwhite, math.random(127)*backgroundwhite)

	if starttimer < 35 then
		asteroidtimer = asteroidtimer + dt
		
		while asteroidtimer > realasteroiddelay do
			asteroidtimer = asteroidtimer - realasteroiddelay
			table.insert(asteroids, asteroid:new())
		end
	end

	for i, v in pairs(stars) do
		v:update(dt)
	end
	
	--ASTEROIDS
	local delete = {}
	
	for i, v in pairs(asteroids) do
		if v:update(dt) == true then
			table.insert(delete, i)
		end
	end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for i, v in pairs(delete) do
		table.remove(asteroids, v) --remove
	end
	
	--BULLETS
	local delete = {}
	
	for i, v in pairs(bullets) do
		if v:update(dt) == true then
			table.insert(delete, i)
		end
	end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for i, v in pairs(delete) do
		table.remove(bullets, v) --remove
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
	
	rockets[1]:update(dt)
	
	if (starttimer > 38 and starttimer < 40) or warningtimer > 0.1 then
		warningtimer = math.mod(warningtimer + dt*7, math.pi*2)
	end
	
	if starttimer >= 40 and starttimer - dt < 40 then
		rockets[1]:wheatleyattack()
	end
end

function scene3_draw()
	local r, g, b = love.graphics.getColor()
	love.graphics.setColor(math.random(255), math.random(255), math.random(255), 255*(1-scoreanim))
	for i = 1, backgroundstripes, 2 do
		local alpha = math.rad((i/backgroundstripes + math.mod(sunrot/100, 1)) * 360)
		local point1 = {lastexplosion[1]*scale+200*scale*math.cos(alpha), lastexplosion[2]*scale+200*scale*math.sin(alpha)}
		
		local alpha = math.rad(((i+1)/backgroundstripes + math.mod(sunrot/100, 1)) * 360)
		local point2 = {lastexplosion[1]*scale+200*scale*math.cos(alpha), lastexplosion[2]*scale+200*scale*math.sin(alpha)}
		
		love.graphics.polygon("fill", lastexplosion[1]*scale, lastexplosion[2]*scale, point1[1], point1[2], point2[1], point2[2])
	end
	love.graphics.setColor(r, g, b, 255)

	for i,v in pairs(stars) do
		v:draw()
	end
	for i,v in pairs(asteroids) do
		v:draw()
	end
	
	rockets[1]:draw()
	for i,v in pairs(bullets) do
		v:draw()
	end
	for i, v in pairs(explosions) do
		v:draw()
	end
	
	if (starttimer > 38 and starttimer < 40) or warningtimer > 0.1 then
		love.graphics.setColor(255, 0, 0, math.abs(math.sin(warningtimer))*255)
		draw(warningimg, -3+math.random(5)-3, 20+math.random(5)-3)
	end
end

function scene3_keypressed(key)
	if key ~= "left" and key ~= "up" and key ~= "right" and key ~= "down" then
		table.insert(pressedkeys, key)
	end
end

function scene3_keyreleased(key)
	for i = 1, #pressedkeys do
		if pressedkeys[i] == key then
			table.remove(pressedkeys, i)
			break
		end
	end
end