local generator = {}

-- Function to read lines from a file
function lines_from(file)
    lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end

-- Load the Bible text
bible_lines = lines_from("kjv.txt")

-- Function to generate a random Bible phrase
function generator.random_bible_phrase()
    math.randomseed(os.time())
    local random_line = math.random(1, #bible_lines)
    return bible_lines[random_line]
end


return generator
