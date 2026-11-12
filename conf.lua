function love.conf(t)
	t.version = "11.5"
	t.identity = "trosh"
	t.console = false
	t.window.title = "TROSH: The Movie: The Game"
	t.window.icon = "graphics/icon.png"
	t.window.width = 800
	t.window.height = 640
	t.window.vsync = 1
	t.window.msaa = 16
	t.modules.physics = false
end
