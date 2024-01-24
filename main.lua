-- Initialize player
local math = require("math")
local player = {}
player.x = 150
player.y = 150
player.oriantation = 0
-- Current animation frame
player.frame = 1

-- Sprite sheet textures
local spriteSheet = love.graphics.newImage("sprites.png")
player.width = 32 -- spriteSheet:getWidth()
player.height = 32 -- spriteSheet:getHeight()

-- Load grass texture
local grassTile = love.graphics.newImage("grassTile.png")

function love.load()
	player.destX = player.x
	player.destY = player.y
end

-- Handle player movement input
function love.keypressed(key)
	if key == "up" then
		player.destY = player.y - 10
		player.oriantation = math.pi / 2
	elseif key == "down" then
		player.destY = player.y + 10
		player.oriantation = math.pi * 3 / 2
	elseif key == "left" then
		player.destX = player.x - 10
		player.oriantation = 0
	elseif key == "right" then
		player.destX = player.x + 10
		player.oriantation = math.pi
	end
end

local lerp = function(a, b, t)
	if b == nil then return a end
	return a * (1 - t) + b * t
end

function love.update(dt)
	-- Interpolate to destination
	player.x = lerp(player.x, player.destX, dt * 3)
	player.y = lerp(player.y, player.destY, dt * 3)

	-- Animate sprite frame
	player.frame = player.frame + 6 * dt
	player.frame = player.frame % 4
end

function love.draw()
	-- Draw grass background
	love.graphics.draw(grassTile, 0, 0)
	-- Draw player sprite from sheet
	local frameWidth = player.width / 4
	local frameHeight = player.height / 4
	local frameX = (player.frame - 1) * frameWidth
	love.graphics.draw(
		spriteSheet,
		player.x,
		player.y,
		0, 
		0.2, 0.2,
		frameX, 0
	)
end
