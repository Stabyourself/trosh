function love.load()
	isweb = love.system.getOS() == "Web"
	
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	require "class"
	require "menu"
	require "cloud"
	require "cloud2"
	require "bush"
	require "scene1"
	require "scene2"
	require "scene3"
	require "scene4"
	require "scene5"
	require "scene6"
	require "laser"
	require "enemy"
	require "explosion"
	require "bigexplosion"
	require "splatter"
	require "powerup"
	require "rocket"
	require "star"
	require "asteroid"
	require "bullet"
	require "bird"
	
	love.window.setIcon( love.image.newImageData("graphics/icon.png") )
	imagelist = {"title", "cloud1", "cloud2", "ground", "bush1", "bush2", "powerup", "rocket", "star", "asteroid-big1", "sunglasses", "awesome", "arrow", "groundwin",
				"asteroid-big2", "asteroid-small1", "asteroid-small2", "bullet", "littleexplosion", "warning", "wheatley", "alert", "randomshit", "bird"}
	
	for i = 1, #imagelist do
		_G[imagelist[i] .. "img"] = love.graphics.newImage("graphics/" .. imagelist[i] .. ".png")
	end
	
	fontimage = love.graphics.newImage("graphics/font.png")
	
	fontglyphs = "0123456789abcdefghijklmnopqrstuvwxyz.:/,'C-_>* !{}?"
	fontquads = {}
	for i = 1, string.len(fontglyphs) do
		fontquads[string.sub(fontglyphs, i, i)] = love.graphics.newQuad((i-1)*8, 0, 8, 8, 408, 8)
	end
	
	playerimg = love.graphics.newImage("graphics/trosh.png")
	playerquad = {love.graphics.newQuad(0, 0, 14, 25, 54, 25), love.graphics.newQuad(14, 0, 14, 25, 54, 25), love.graphics.newQuad(28, 0, 26, 12, 54, 25), love.graphics.newQuad(28, 12, 26, 12, 54, 25)}
	
	winplayerimg = love.graphics.newImage("graphics/troshwin.png")
	winplayerquad = {}
	for x = 1, 4 do
		winplayerquad[x] = love.graphics.newQuad((x-1)*11, 0, 11, 26, 44, 26)
	end
	
	enemyimg = love.graphics.newImage("graphics/enemy.png")
	enemyquad = {}
	for y = 1, 4 do
		for x = 1, 4 do
			enemyquad[(y-1)*4+x] = love.graphics.newQuad((x-1)*100, (y-1)*96, 100, 96, 400, 384)
		end
	end
	
	explosionimg = love.graphics.newImage("graphics/explosion.png")
	explosionquad = {}
	for y = 1, 5 do
		for x = 1, 5 do
			explosionquad[(y-1)*5+x] = love.graphics.newQuad((x-1)*66, (y-1)*81, 66, 81, 330, 405)
		end
	end
	
	bigexplosionimg = love.graphics.newImage("graphics/bigexplosion.png")
	bigexplosionquad = {}
	for y = 1, 5 do
		for x = 1, 5 do
			bigexplosionquad[(y-1)*5+x] = love.graphics.newQuad((x-1)*108, (y-1)*121, 108, 121, 540, 605)
		end
	end
	
	splatterimg = love.graphics.newImage("graphics/splatter.png")
	splatterquad = {}
	for x = 1, 6 do
		splatterquad[x] = love.graphics.newQuad((x-1)*64, 0, 64, 64, 384, 64)
	end
	
	birdquad = {love.graphics.newQuad(0, 0, 29, 16, 29, 32), love.graphics.newQuad(0, 16, 29, 16, 29, 32)}
	
	scale = 8
	if isweb then
		scale = webscale()
	end
	local w, h = love.window.getMode()
	if w ~= 100*scale or h ~= 80*scale then
		love.window.setMode(100*scale, 80*scale, {vsync = 1, msaa = 16})
	end
	
	bgmusic = love.audio.newSource("audio/trosong.ogg", "stream")
	bgmusic:setLooping(true)
	lasersound = love.audio.newSource("audio/laser.wav", "static")
	bigexplosionsound = love.audio.newSource("audio/bigexplosion.ogg", "static")
	explosionsound = love.audio.newSource("audio/explosion.wav", "static")
	launchsound = love.audio.newSource("audio/launch.ogg", "static")
	gunfire = love.audio.newSource("audio/gunfire.wav", "static")
	space = love.audio.newSource("audio/space.ogg", "static")
	sunglassessound = love.audio.newSource("audio/sunglasses.ogg", "static")
	splat = love.audio.newSource("audio/splat.ogg", "static")
	ding = love.audio.newSource("audio/ding.ogg", "static")
	credits = love.audio.newSource("audio/credits.ogg", "stream")
	approach = love.audio.newSource("audio/approach.ogg", "static")
	credits:setLooping(true)
	
	skipupdate = true
	shakeamount = 0
	shake = 0
	fade = 0
	playerframe = 1
	scoreanim = 1
	rainbowi = 0.5
	sini = 0
	sini2 = math.pi/2
	scrollx = 0
	points = 0
	machinedelay = 0.05
	stars = {}
	explosions = {}
	backgroundstripes = 10
	sunrot = 0
	
	lasers = {}
	
	realasteroiddelay = 1
	movement1speed = 100
	laserdelay = 0
	reallaserdelay = 0.4
	starttimer = 0
	if isweb then
		--browsers need a keypress before playing sound
		changegamestate("clicktostart")
	else
		changegamestate("menu")
	end
end

function clicktostart_load()
	love.graphics.setBackgroundColor(153/255, 217/255, 234/255)
	startrequested = false
end

function clicktostart_update(dt)
	rainbowi = math.fmod(rainbowi + dt/2, 1)
	sini = math.fmod(sini + dt*10, math.pi*2)
	sini2 = math.fmod(sini2 + dt*5, math.pi*2)
	
	if startrequested then
		starttimer = 0
		changegamestate("menu")
	end
end

function clicktostart_draw()
	love.graphics.setColor(getrainbowcolor(rainbowi, 420))
	draw(titleimg, 50, 23, math.sin(sini)/10, (math.sin(sini2)+1)/5+0.7, (math.sin(sini2)+1)/5+0.7, 50, 13)
	
	if math.fmod(starttimer*2, 2) < 1.4 then
		love.graphics.setColor(1, 0, 0)
		properprint("press any key", 24, 50, scale/2)
	end
	drawflashwarning()
	love.graphics.setColor(1, 1, 1)
end

function drawflashwarning()
	love.graphics.setColor(1, 0, 0)
	properprint("warning: flashing imagery", 25, 2, scale/4)
end

function clicktostart_keypressed()
	startrequested = true
end

function love.mousepressed()
	if gamestate == "clicktostart" then
		startrequested = true
	end
end

--web: biggest whole scale that fits the browser window, the page stretches the rest
function webscale()
	local size = love.js and love.js.eval and
		love.js.eval("Math.floor(innerWidth*devicePixelRatio)+' '+Math.floor(innerHeight*devicePixelRatio)")
	local w, h = string.match(size or "", "(%d+) (%d+)")
	if not w then
		return scale
	end
	return math.max(1, math.min(math.floor(tonumber(w)/100), math.floor(tonumber(h)/80)))
end

local webscaletimer = 0
function updatewebscale(dt)
	webscaletimer = webscaletimer + dt
	if webscaletimer < 0.5 then
		return
	end
	webscaletimer = 0
	local s = webscale()
	if s ~= scale then
		scale = s
		love.window.setMode(100*scale, 80*scale, {vsync = 1, msaa = 16})
	end
end

function love.update(dt)
	dt = math.min(dt, 1/30)
	if isweb then
		updatewebscale(dt)
	end
	if skipupdate then
		skipupdate = false
		return
	end
	
	sunrot = sunrot + dt*50
	
	starttimer = starttimer + dt
	
	if scoreanim < 1 then
		scoreanim = scoreanim + (1-scoreanim)*8*dt
	end
	
	if laserdelay > 0 then
		laserdelay = math.max(0, laserdelay-dt)
	end
	
	shake = math.random()*shakeamount*2-shakeamount
	
	if _G[gamestate .. "_update"] then
		_G[gamestate .. "_update"](dt)
	end
	
	--LASERS
	local delete = {}
	
	for i, v in pairs(lasers) do
		if v:update(dt) == true then
			table.insert(delete, i)
		end
	end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for i, v in pairs(delete) do
		table.remove(lasers, v) --remove
	end
end

function pointsget(i)
	points = points + i
	scoreanim = 0
	rainbowi = math.random()
	shakeamount = 10
end

function love.draw()
	love.graphics.translate(50*scale, 40*scale)
	love.graphics.rotate(shake/300)
	love.graphics.translate(-50*scale, -40*scale)
	
	love.graphics.translate(shake*scale/4, shake*scale/4)
	
	if _G[gamestate .. "_draw"] then
		_G[gamestate .. "_draw"]()
	end
	
	
	if gamestate ~= "menu" and gamestate ~= "clicktostart" and gamestate ~= "scene6" and not landing then
		local r, g, b = unpack(getrainbowcolor(rainbowi))
		
		local ar = r + (1-r)*scoreanim
		local ag = g + (1-g)*scoreanim
		local ab = b + (1-b)*scoreanim
		
		love.graphics.setColor(ar, ag, ab)
		
		local s = scale*0.5+(1-scoreanim)*10
		love.graphics.rotate((1-scoreanim)*0.4)
		properprint("score: " .. points, 2, 2, s)
		love.graphics.rotate(-(1-scoreanim)*0.4)
	end
	
	love.graphics.translate(-shake*scale/4, -shake*scale/4)
	
	
	love.graphics.translate(50*scale, 40*scale)
	love.graphics.rotate(-shake/300)
	love.graphics.translate(-50*scale, -40*scale)
	if fade > 0 then
		love.graphics.setColor(1, 1, 1, fade)
		love.graphics.rectangle("fill", 0, 0, 100*scale, 80*scale)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

function love.keypressed(key)
	if _G[gamestate .. "_keypressed"] then
		_G[gamestate .. "_keypressed"](key)
	end
	
	if key ~= "left" and key ~= "up" and key ~= "right" and key ~= "down" then
		if _G[gamestate .. "_action"] then
			_G[gamestate .. "_action"](key)
		end
	end
end

function love.keyreleased(key)
	if _G[gamestate .. "_keyreleased"] then
		_G[gamestate .. "_keyreleased"](key)
	end
end

function changegamestate(i)
	gamestate = i
	if _G[gamestate .. "_load"] then
		_G[gamestate .. "_load"]()
	end
end

function draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
	if not sx then
		sx = 1
	end
	if not sy then
		sy = 1
	end
	love.graphics.draw(drawable, x*scale, y*scale, r, sx*scale, sy*scale, ox, oy, kx, ky )
end

function round(num, idp) --Not by me
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function properprint(s, x, y, sc)
	local sc = sc or scale
	local startx = x
	local skip = 0
	for i = 1, string.len(tostring(s)) do
		if skip > 0 then
			skip = skip - 1
		else
			local char = string.sub(s, i, i)
			if fontquads[char] then
				love.graphics.draw(fontimage, fontquads[char], x*scale+((i-1)*8+1)*sc, y*scale, 0, sc, sc)
			end
		end
	end
end

function round(num, idp) --Not by me
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function getrainbowcolor(i, whiteness)
	local whiteness = whiteness or 255
	local r, g, b
	if i < 1/6 then
		r = 1
		g = i*6
		b = 0
	elseif i >= 1/6 and i < 2/6 then
		r = (1/6-(i-1/6))*6
		g = 1
		b = 0
	elseif i >= 2/6 and i < 3/6 then
		r = 0
		g = 1
		b = (i-2/6)*6
	elseif i >= 3/6 and i < 4/6 then
		r = 0
		g = (1/6-(i-3/6))*6
		b = 1
	elseif i >= 4/6 and i < 5/6 then
		r = (i-4/6)*6
		g = 0
		b = 1
	else
		r = 1
		g = 0
		b = (1/6-(i-5/6))*6
	end
	
	local add = 0
	if whiteness > 255 then
		add = whiteness-255
	end
	
	return {math.min(255, round(r*whiteness)+add)/255, math.min(255, round(g*whiteness)+add)/255, math.min(255, round(b*whiteness)+add)/255, 1}
end
