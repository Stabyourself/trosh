function scene4_load()
	backgroundwhite = 0
	staralpha = 1
	asteroids = {}
	bullets = {}
	love.audio.play(bgmusic)
	
	starttimer = 0
	alerttimer = 0
	flyingquad = 3
	
	pspeedx = 0
	pspeedy = 0
	
	playerx = nil
	
	flyanimationtimer = 0
end

function scene4_update(dt)
	if secondtimer then
		secondtimer = secondtimer + dt
	end
	for i, v in pairs(stars) do
		v:update(dt)
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
	
	if rockets[1] then
		rockets[1]:update(dt)
	end
	
	if (starttimer > 0 and starttimer < 3) or alerttimer > 0.1 then
		alerttimer = math.mod(alerttimer + dt*7, math.pi*2)
	end
	
	if jumped then
		if rockets[1] then
			rockets[1].x = rockets[1].x - dt*3
		end
		
		if rockets[1] and secondtimer > 2 and secondtimer - dt <= 2 then
			for i = 1, 20 do
				if explosions then
					table.insert(explosions, explosion:new(rockets[1].x-16+math.random(16)-8, rockets[1].y-20+math.random(16)-8))
				end
			end
			starmover = math.pi
			rockets[1] = nil
		end
		
		playerx = playerx + pspeedx*dt
		playery = playery + pspeedy*dt
		
		if pspeedx > 0 then
			pspeedx = pspeedx - dt*5
		end
		
		if playery >= 20 then
			playery = 20
			pspeedy = 0
		end
		
		if playerx >= 50 then
			pspeedx = 0
			playerx = 50
		end
	
		if secondtimer > 2 then
			local i = math.max(0, (1-(secondtimer-2)/2))
			staralpha = math.max(0, (1-(secondtimer-2)/2))*i
			love.graphics.setBackgroundColor(153*(1-i), 217*(1-i), 234*(1-i))
			
			if shakeamount < 5 then
				shakeamount = math.min(5, shakeamount+dt*3)
			elseif shakeamount > 5 then
				shakeamount = math.max(5, shakeamount-dt*3)
			end
		end
		
		if secondtimer > 4 then
			changegamestate("scene5")
		end
	end
	
	if starttimer >= 4.3 and starttimer - dt < 4.3 then
		playerx = rockets[1].x+4
		playery = rockets[1].y
	end
	
	if jumped then
		flyanimationtimer = flyanimationtimer + dt
		while flyanimationtimer > 0.1 do
			flyanimationtimer = flyanimationtimer - 0.1
			if flyingquad == 3 then
				flyingquad = 4
			else
				flyingquad = 3
			end
		end
	end
end

function scene4_draw()
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
	
	
	if playerx then
		local off = 0
		if rockets[1] then
			off = rockets[1].startingoffset
		end
		love.graphics.drawq(playerimg, playerquad[flyingquad], (playerx+off)*scale, playery*scale, 0, scale, scale, 13, 6)
	end
	
	if rockets[1] then
		rockets[1]:draw()
	end
	for i, v in pairs(explosions) do
		v:draw()
	end
	
	if (starttimer > 0 and starttimer < 3) or alerttimer > 0.1 then
		local i = math.abs(math.sin(alerttimer))
		love.graphics.setColor(255, 0, 0, i*100)
		love.graphics.rectangle("fill", 0, 0, 100*scale, 80*scale)
		love.graphics.setColor(255, 0, 0, i*255)
		draw(alertimg, 50+math.random(5)-3, 40+math.random(5)-3, (math.random()*2-1)*0.1, i*0.5+0.6, i*0.5+0.6, 54, 15)
		draw(randomshitimg, 50+math.random(20)-10, 40+math.random(20)-10, 0, 1, 1, 50, 42)
	end
	
	if starttimer > 4 and not jumped then
		love.graphics.setColor(255, 0, 0, math.random(255))
		properprint("jump!!", 0, 40, scale*3)
	end
end

function scene4_action()
	if starttimer > 4.3 and not jumped then
		jumped = true
		secondtimer = 0
		pspeedx = 20
		pspeedy = 2
	end
end