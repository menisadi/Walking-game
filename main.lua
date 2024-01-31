local math = require("math")
local random_bible = require("bible_generator")

local player = {}
player.x = 150
player.y = 150
player.orientation = 0
player.frame = 1
player.width = 32
player.height = 32
player.destX = player.x
player.destY = player.y

local friend = {}
friend.x = 130
friend.y = 130
friend.width = 32
friend.height = 32

local spriteSheet = love.graphics.newImage("sprites.png")
local landTile = love.graphics.newImage("landTile.png")
local friendImage = love.graphics.newImage("Friend.png")

local dialogue = {
	text = "",
	timer = 0,
	duration = 3,
}

local keysPressed = {} -- Table to store keys currently being pressed

function love.keypressed(key)
	keysPressed[key] = true -- Mark the key as pressed
end

function love.keyreleased(key)
	keysPressed[key] = nil -- Remove the key from the table when released
end

function love.load()
	resetFriendPosition()
	-- Initialize dialogue variables
	dialogue.text = ""
	dialogue.displayedText = ""
	dialogue.currentIndex = 0
	dialogue.timer = 0
	dialogue.duration = 0.05
end

function resetFriendPosition()
	friend.x = math.random(0, love.graphics.getWidth() - friend.width)
	friend.y = math.random(0, love.graphics.getHeight() - friend.height)
end

local function lerp(a, b, t)
	if b == nil then
		return a
	end
	return a * (1 - t) + b * t
end

function displayFriendDialogue(text)
	dialogue.text = text
	dialogue.displayedText = ""
	dialogue.currentIndex = 0
	dialogue.timer = dialogue.duration
end

function love.update(dt)
	-- Update player movement based on keys being pressed
	local step_size = 20
	if keysPressed["up"] then
		player.destY = player.y - step_size
	elseif keysPressed["down"] then
		player.destY = player.y + step_size
	end
	if keysPressed["left"] then
		player.destX = player.x - step_size
	elseif keysPressed["right"] then
		player.destX = player.x + step_size
	end

	player.x = lerp(player.x, player.destX, dt * 3)
	player.y = lerp(player.y, player.destY, dt * 3)

	if player.x < 0 then
		player.x = love.graphics.getWidth()
		resetFriendPosition()
	elseif player.x > love.graphics.getWidth() then
		player.x = 0
		resetFriendPosition()
	end

	if player.y < 0 then
		player.y = love.graphics.getHeight()
		resetFriendPosition()
	elseif player.y > love.graphics.getHeight() then
		player.y = 0
		resetFriendPosition()
	end

	player.frame = player.frame + 6 * dt
	player.frame = player.frame % 4

	-- Check player-friend proximity
	local distance = math.sqrt((player.x - friend.x) ^ 2 + (player.y - friend.y) ^ 2)
	if distance < 50 then
		if dialogue.timer <= 0 then
			-- displayFriendDialogue("Hello again. Did you know that the time is: " .. os.date("%H:%M:%S"))
			-- dialogue.text = "Hello again. Did you know that the time is: " .. os.date("%H:%M:%S")
			dialogue.text = random_bible.random_bible_phrase()
		end
		dialogue.timer = dialogue.duration
	else
		dialogue.timer = 0
	end

	-- Update dialogue text display
	-- if dialogue.timer > 0 then
	--     dialogue.timer = dialogue.timer - dt
	--     if dialogue.timer <= 0 then
	--         dialogue.currentIndex = dialogue.currentIndex + 1
	--         dialogue.displayedText = dialogue.text:sub(1, dialogue.currentIndex)
	--         if dialogue.currentIndex < #dialogue.text then
	--             dialogue.timer = dialogue.duration
	--         end
	--     end
	-- end
end

function love.draw()
	love.graphics.draw(landTile, 0, 0)

	local frameWidth = player.width / 4
	local frameHeight = player.height / 4
	local frameX = (player.frame - 1) * frameWidth
	love.graphics.draw(spriteSheet, player.x, player.y, 0, 0.2, 0.2, frameX, 0)

	love.graphics.draw(friendImage, friend.x, friend.y, 0, 0.2, 0.2)
	if dialogue.timer > 0 then
		love.graphics.setColor(0, 0, 0, 0.7) -- Black with 70% opacity
		love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 50, love.graphics.getWidth(), 50)
		love.graphics.setColor(1, 1, 1) -- White text
		love.graphics.printf(dialogue.text, 0, love.graphics.getHeight() - 40, love.graphics.getWidth(), "left")
		-- love.graphics.printf(dialogue.displayedText, 30, love.graphics.getHeight() - 40, love.graphics.getWidth() - 60, "left")
	end
end
