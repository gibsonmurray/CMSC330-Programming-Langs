class GameBoard
    # @max_row is an `Integer`
    # @max_column is an `Integer`
    attr_reader :max_row, :max_column

    def initialize(max_row, max_column)
        @max_row = max_row
        @max_column = max_column
        @grid = Array.new(max_row, Array.new(max_column, false)) # false/true = no ship in position/ship in position
    end

    # adds a Ship object to the GameBoard
    # returns Boolean
    # Returns true on successfully added the ship, false otherwise
    # Note that Position pair starts from 1 to max_row/max_column
    def add_ship(ship)
        start_r = ship.start_position.row
        start_c = ship.start_position.column

        # checking to make sure ship will not go out of bounds
        if start_r + ship.size > 10 || start_c + ship.size > 10 then
            return false
        end

        # checking to see if a ship is already in one of the positions intended to take up
        # if check passes then the ship will be added
        if ship.orientation == "Up" 
            for row in start_r..(start_r - ship.size)     # minus b/c going up in grid
                if @grid[row][start_c] == true then
                    return false
                end
            end
            for row in start_r..(start_r - ship.size) 
                @grid[row][start_c] = true                  # true = means a ship is in the grid
            end
        end
        if ship.orientation == "wn" 
            for row in start_r..(start_r + ship.size)     # plus because going wn in grid
                if @grid[row][start_c] == true 
                    return false
                end
            end
            for row in start_r..(start_r + ship.size) 
                @grid[row][start_c] = true
            end
        end
        if ship.orientation == "Left" 
            for col in start_c..(start_c - ship.size)     # minus because going left in grid
                if @grid[start_r][col] == true 
                    return false
                end
            end
            for col in start_c..(start_c - ship.size) 
                @grid[start_r][col] = true
            end
        end
        if ship.orientation == "Right" 
            for col in start_c..(start_c + ship.size)     # plus because going right in grid
                if @grid[start_r][col] == true 
                    return false
                end
            end
            for col in start_c..(start_c + ship.size) 
                @grid[start_r][col] = true
            end
        end
    end

    # return Boolean on whether attack was successful or not (hit a ship?)
    # return nil if Position is invalid (out of the boundary defined)
    def attack_pos(position)
        # check position

        # update your grid

        # return whether the attack was successful or not
        true
    end

    # Number of successful attacks made by the "opponent" on this player GameBoard
    def num_successful_attacks
        0
    end

    # returns Boolean
    # returns True if all the ships are sunk.
    # Return false if at least one ship hasn't sunk.
    def all_sunk?
        true
    end


    # String representation of GameBoard (optional but recommended)
    def to_s
        spaces = Proc.new do
            for space in 0..5               # 6 spaced format
                print " "
            end
        end
        # printing grid:
        for row in 1..@max_row            # 0th index is just for formatting
            if row == 1 
                for space in 0..3         # 4 spaces
                    print " "
                end
            end
            for col in 1..@max_column 
                if row == 1 
                    print (col).to_s    # prints column number
                    if col < 10 
                        spaces.call
                    end
                end
            end
            puts "\n"
        end
    end
end

test = GameBoard.new(10, 10)
puts test