require_relative '../models/game_board'
require_relative '../models/ship'
require_relative '../models/position'

# return a populated GameBoard or nil
# Return nil on any error (validation error or file opening error)
# If 5 valid ships added, return GameBoard; return nil otherwise
def read_ships_file(path)
    if !read_file_lines(path)
        return nil
    end
    five_ships = 0
    ans = GameBoard.new(10, 10)
    read_file_lines(path) do |line|
        if (line =~ /^\((\d+),(\d+)\), (Right|Left|Up|Down), (\d+)$/) == 0 && five_ships < 5
            position = Position.new($1.to_i, $2.to_i)
            ship = Ship.new(position, $3.to_s, $4.to_i)
            if ans.add_ship(ship)
                five_ships += 1
            end
        end
    end
    if five_ships < 5
        return nil
    end
    ans
end


# return Array of Position or nil
# Returns nil on file open error
def read_attacks_file(path)
    if !read_file_lines(path)
        return nil
    end
    ans = []
    read_file_lines(path) do |line|
        if line =~ /^\(\d+,\d+\)$/
            position = Position.new($1.to_i, $2.to_i)
            ans << position
        end
    end
    ans
end


# ===========================================
# =====DON'T modify the following code=======
# ===========================================
# Use this code for reading files
# Pass a code block that would accept a file line
# and does something with it
# Returns True on successfully opening the file
# Returns False if file doesn't exist
def read_file_lines(path)
    return false unless File.exist? path
    if block_given?
        File.open(path).each do |line|
            yield line
        end
    end

    true
end
