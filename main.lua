-- Initialize player
local math = require("math")
local player = {}
player.x = 30
player.y = 20
player.size = 32

-- Current animation frame
player.frame = 1

-- Sprite sheet textures
local spriteSheet = love.graphics.newImage("sprites.png")
-- Load grass texture
local grassTile = love.graphics.newImage("grassTile.png")

function love.load()
	player.destX = player.x
	player.destY = player.y
end

-- Handle player movement input
function love.keypressed(key)
	if key == "up" then
		player.destY = player.y - 2
	elseif key == "down" then
		player.destY = player.y + 2
	elseif key == "left" then
		player.destX = player.x - 2
	elseif key == "right" then
		player.destX = player.x + 2
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
	-- love.graphics.draw(grassTile, 0, 0)
	-- Draw player sprite from sheet
	local frameWidth = player.size / 4
	-- local frameX = (player.frame - 1) * frameWidth
	local frameX = (math.floor(player.frame) % 4) * frameWidth -- Ensure frameX is within valid range
	love.graphics.draw(spriteSheet, player.x,
		player.y, 0, 1, 1, frameX, 0, frameWidth, player.size)
end
