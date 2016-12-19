function menu_load()
	love.graphics.setBackgroundColor(153, 217, 234)
	clouds = {}
	bushes = {}
	love.audio.play(bgmusic)
	for i = 1, 5 do
		table.insert(clouds, cloud:new(true))
	end
	for i = 1, 30 do
		table.insert(bushes, bush:new(true))
	end
	
	textpos = {}
	for i = 0, 7 do
		textpos[i] = 10
	end
	playerframetimer = 0
	playery = 50
	playerx = 10
	--				 1    2   3    4     5     6      7
	startactions = {2.3, 4.6, 7, 8.20, 9.20, 10.20, 11.20}
	starti = 0
	
end

function menu_update(dt)
	for i, v in pairs(clouds) do
		v:update(dt)
	end
	for i, v in pairs(bushes) do
		v:update(dt)
	end
	
	scrollx = scrollx + dt*50
	
	rainbowi = math.mod(rainbowi + dt/2, 1)
	sini = math.mod(sini + dt*10, math.pi*2)
	sini2 = math.mod(sini2 + dt*5, math.pi*2)
	
	if starttimer > startactions[starti+1] then
		starti = starti+1
		if starti == 7 then
			changegamestate("scene1")
			return
		end
	end
	
	if starti >= 4 then
		shakeamount = shakeamount + dt*4
	end
	if starti >= 5 then
		shakeamount = shakeamount + dt*10
	end
	if starti >= 6 then
		shakeamount = shakeamount + dt*50
	end
	
	for i = -1, starti-1 do
		if i >= 0 then
			textpos[i] = textpos[i]+(textpos[i]^2*dt)
		end
	end
	
	playerframetimer = playerframetimer + dt*10
	while playerframetimer >= 2 do
		playerframetimer = playerframetimer - 2
	end
	playerframe = math.floor(playerframetimer)+1
	
	playermovement1(dt)
end

function menu_action()
	shootlaser()
end

function menu_draw()
	love.graphics.setColor(255, 255, 255)
	for i, v in pairs(clouds) do
		v:draw()
	end
	
	for i = 1, 2 do
		draw(groundimg, -math.mod(scrollx, 120) + (i-1)*120, 59)
	end
	for i, v in pairs(bushes) do
		v:draw()
	end
	
	love.graphics.drawq(playerimg, playerquad[playerframe], playerx*scale, playery*scale, 0, scale, scale, 7, 12)
	for i, v in pairs(lasers) do
		v:draw()
	end

	love.graphics.setColor(getrainbowcolor(rainbowi, 420))
	draw(titleimg, 50, 23, math.sin(sini)/10, (math.sin(sini2)+1)/5+0.7, (math.sin(sini2)+1)/5+0.7, 50, 13)
	
	love.graphics.setColor(255, 0, 0)
	if starti >= 0 then
		properprint("directed by maurice", 13, 40+textpos[0], scale/2)
	end
	if starti >= 1 then
		properprint("use arrow keys", 25, 40+textpos[1], scale/2)
	end
	if starti >= 2 then
		properprint("and any other button", 9, 40+textpos[2], scale/2)
	end
	if starti >= 3 then
		properprint("get ready...", 20, 40+textpos[3], scale/2)
	end
	if starti >= 4 then
		properprint("3", 40, 40+textpos[4], scale*2)
	end
	if starti >= 5 then
		properprint("2", 36, 40+textpos[5], scale*3)
	end
	if starti >= 6 then
		properprint("1", 32, 40+textpos[6], scale*4)
	end
	if starti >= 7 then
		properprint("go!", 10, 40+textpos[7], scale*6)
	end
	
	love.graphics.setColor(255, 255, 255)
end