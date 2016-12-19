function scene6_load()
	love.graphics.setBackgroundColor(153, 217, 234)
	love.audio.stop(bgmusic)
	
	clouds2 = {}
	clouds = {}
	bushes = {}
	bigexplosions = {}
	
	playerquad = 1
	
	if sunglasses then
		playerquad = 3
	end
	
	playeranimationtimer = 0
	starttimer = 0
	
	birds = {}
	splatters = {}
	
	shakeamount = 10
	
	fade = 0
	
	playerx = playerx or 50
	landingx = landingx or 50
	
	landdiff = playerx-landingx
	
	scoremul = round((1-math.abs(landdiff)/80)^8*4, 1) + 1
	
	stars = {}
	
	texts = {}
	texts[1] = "your awesome score:"
	texts[2] = points
	texts[3] = ""
	texts[4] = "radical landing mul:"
	texts[5] = scoremul
	texts[6] = ""
	texts[7] = "cray total:"
	texts[8] = math.ceil(points*scoremul)
	
	prevt = 0
	
	to = 0
	totimes = {8.55, 8.8, 9.4, 9.5, 9.7, 11.0, 12.3, 12.9, 13.2}
end

function scene6_update(dt)
	playeranimationtimer = playeranimationtimer + dt
	while playeranimationtimer > 0.1 do
		playeranimationtimer = playeranimationtimer - 0.1
		playerquad = playerquad + 1
		if playerquad == 3 then
			playerquad = 1
		elseif playerquad == 5 then
			playerquad = 3
		end
	end
	
	for i, v in pairs(bigexplosions) do
		v:update(dt)
	end

	if starttimer >= 0.7 and starttimer - dt < 0.7 then
		bigexplosionsound:play()
	end
	
	if starttimer < 0.2 then
	
	elseif starttimer < 0.5 then
		fade = 1
		
		if #explosions == 0 then
			table.insert(bigexplosions, bigexplosion:new(-4, -30))
			table.insert(bigexplosions, bigexplosion:new(-40, -30))
			table.insert(bigexplosions, bigexplosion:new(36, -30))
			table.insert(bigexplosions, bigexplosion:new(-4, -50))
		end
	elseif starttimer < 4 then
		if fade > 0.5 then
			fade = fade - dt/2
		end
	else
		if fade > 0 then
			fade = fade - dt/2
		end
	end
	
	
	if starttimer > 8.3 and starttimer - dt < 8.3 then
		credits:play()
	end
	
	if shakeamount > 0 then
		shakeamount = shakeamount - dt*3
	end
	
	for i = 1, 9 do
		if starttimer > totimes[i] then
			to = i
		end
	end
	
	if starttimer >= 15.7 and starttimer -dt < 15.7 then
		staralpha = 1
	
		stars = {}
		love.graphics.setBackgroundColor(0, 0, 0)
		for i = 1, 10 do
			table.insert(stars, star:new())
		end
	end
	for i,v in pairs(stars) do
		v:update(dt)
	end
end

function scene6_draw()
	local r, g, b = love.graphics.getColor()
	for i = 1, backgroundstripes, 1 do
		if math.mod(i, 2) == 1 then
			love.graphics.setColor(255, 255, 0, math.min(1, math.max(0, 1-(starttimer-7)/2))*255)
		else
			love.graphics.setColor(255, 0, 0, math.min(1, math.max(0, 1-(starttimer-7)/2))*255)
		end
		local pos = {31, 53}
		local alpha = math.rad((i/backgroundstripes + math.mod(sunrot/100, 1)) * 360)
		local point1 = {pos[1]*scale+200*scale*math.cos(alpha), pos[2]*scale+200*scale*math.sin(alpha)}
		
		local alpha = math.rad(((i+1)/backgroundstripes + math.mod(sunrot/100, 1)) * 360)
		local point2 = {pos[1]*scale+200*scale*math.cos(alpha), pos[2]*scale+200*scale*math.sin(alpha)}
		
		love.graphics.polygon("fill", pos[1]*scale, pos[2]*scale, point1[1], point1[2], point2[1], point2[2])
	end
	love.graphics.setColor(r, g, b, 255)
	for i,v in pairs(stars) do
		v:draw()
		v:draw()
		v:draw()
		v:draw()
	end
	
	love.graphics.translate(20*scale, 50*scale)
	love.graphics.rotate(math.pi/7)
	love.graphics.translate(-20*scale, -50*scale)
	
	for i, v in pairs(bigexplosions) do
		v:draw()
	end
	
	draw(groundwinimg, -168-landdiff, 56)
	love.graphics.drawq(winplayerimg, winplayerquad[playerquad], 30*scale, 55*scale, 0, scale, scale, 5, 13)
	
	love.graphics.translate(20*scale, 50*scale)
	love.graphics.rotate(-math.pi/7)
	love.graphics.translate(-20*scale, -50*scale)
	
	for i = 1, math.min(9, to) do
		local s = scale/2
		if i >= 8 then
			s = s * 2
			love.graphics.setColor(getrainbowcolor(math.random()))
		end
		if i == 9 then
			draw(titleimg, 65, 65, 0, 0.7, 0.7, 50, 14)
		else
			properprint(texts[i], 50-tostring(texts[i]):len()*s/2, 5*i, s)
		end
		love.graphics.setColor(255, 255, 255)
	end
end