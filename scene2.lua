function scene2_load()
	starttimer = 0
	shakeamount = 0
	rockets[1].x = 50
	rockets[1]:start()
	launchsound:stop()
	launchsound:play()
	
	for y = 1, 30 do
		for i = 1, 5 do
			table.insert(clouds, cloud:new(true, -y*30))
		end
	end
	
	backgroundcolor = {love.graphics.getBackgroundColor()}
end

function scene2_update(dt)
	for i, v in pairs(clouds) do
		v:update(dt)
	end
	rockets[1]:update(dt)
	
	if starttimer > 7 then
		love.graphics.setBackgroundColor(0, 0, 0)
	elseif starttimer > 6 then
		local r, g, b = unpack(backgroundcolor)
		r = r*(1-(starttimer-6)/1)
		g = g*(1-(starttimer-6)/1)
		b = b*(1-(starttimer-6)/1)
		
		love.graphics.setBackgroundColor(r, g, b)
	end
	
	if starttimer > 7 then
		if starttimer - dt <= 7 then
			for i = 1, 10 do
				table.insert(stars, star:new())
			end
		end
		
		staralpha = math.min(1, (starttimer-7)/9)
	end
end

function scene2_draw()
	
	local launchoffset = 0
	if starttimer > 3 then
		launchoffset = 10^(starttimer-3)+(starttimer-3)*20
	end

	love.graphics.translate(0, launchoffset)
	
	for i, v in pairs(clouds) do
		v:draw()
	end
	
	for i = 1, 2 do
		draw(groundimg, -math.fmod(scrollx, 100) + (i-1)*100, 59)
	end
	for i, v in pairs(bushes) do
		v:draw()
	end
	love.graphics.translate(0, -launchoffset)
	
	
	for i,v in pairs(stars) do
		v:draw()
	end
	
	love.graphics.setColor(1, 1, 1, 1)
	
	rockets[1]:draw()
end