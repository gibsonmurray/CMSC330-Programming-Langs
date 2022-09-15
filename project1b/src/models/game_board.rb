require_relative 'position'
require_relative 'ship'

class GameBoard
    # @max_row is an `Integer`
    # @max_column is an `Integer`
    attr_reader :max_row, :max_column

    def initialize(max_row, max_column)
        @max_row = max_row
        @max_column = max_column
        @grid = Array.new(max_row) {Array.new(max_column) {Array.new(2, false)}} # false = no ship (0), no hit (1) // true otherwise
        
    end

    # adds a Ship object to the GameBoard
    # returns Boolean
    # Returns true on successfully added the ship, false otherwise
    # Note that Position pair starts from 1 to max_row/max_column
    def add_ship(ship)
        # checking to see if a ship is already in one of the positions intended to take up
        # if check passes then the ship will be added
        if ship.orientation == "Up"
            start_r = ship.start_position.row
            start_c = ship.start_position.column - 1            # has to subtract 1 for sake of indexing
            if start_r - ship.size < 0                          # checking to make sure ship will not go out of bounds
                return false
            end
            for row in (start_r - ship.size)..start_r - 1       # minus b/c going up in grid .. minus because cant count highest grid value
                if @grid[row][start_c][0] == true
                    return false
                end
            end
            for row in (start_r - ship.size)..start_r - 1
                @grid[row][start_c][0] = true                   # true = means a ship is in the grid
            end
        end
        if ship.orientation == "Down" 
            start_r = ship.start_position.row - 1
            start_c = ship.start_position.column - 1
            if start_r + ship.size > 10                         # checking to make sure ship will not go out of bounds
                return false
            end
            for row in start_r..(start_r + ship.size - 1)       # starts at starting point..plus because going down in grid
                if @grid[row][start_c][0] == true 
                    return false
                end
            end
            for row in start_r..(start_r + ship.size - 1) 
                @grid[row][start_c][0] = true
            end
        end
        if ship.orientation == "Left" 
            start_r = ship.start_position.row - 1               # has to subtract 1 for sake of indexing
            start_c = ship.start_position.column
            if start_c - ship.size < 0                          # checking to make sure ship will not go out of bounds
                return false
            end
            for col in (start_c - ship.size)..start_c - 1       # minus b/c going up in grid .. minus because cant count highest grid value
                if @grid[start_r][col][0] == true 
                    return false
                end
            end
            for col in (start_c - ship.size)..start_c - 1
                @grid[start_r][col][0] = true
            end
        end
        if ship.orientation == "Right" 
            start_r = ship.start_position.row - 1
            start_c = ship.start_position.column - 1
            if start_c + ship.size > 10                         # checking to make sure ship will not go out of bounds
                return false
            end
            for col in start_c..(start_c + ship.size - 1)       # starts at starting point..plus because going right in grid
                if @grid[start_r][col][0] == true 
                    return false
                end
            end
            for col in start_c..(start_c + ship.size - 1) 
                @grid[start_r][col][0] = true
            end
        end
        true
    end

    # return Boolean on whether attack was successful or not (hit a ship?)
    # return nil if Position is invalid (out of the boundary defined)
    def attack_pos(position)
        hit = false
        # check position
        if position.row > 10 && position.row < 1 && position.column > 10 && position.column < 1
            return nil
        end
        # update your grid
        row = position.row - 1
        col = position.column - 1
        @grid[row][col][1] = true
        # return whether the attack was successful or not
        if @grid[row][col][0]
            hit = true
        end
        hit
    end

    # Number of successful attacks made by the "opponent" on this player GameBoard
    def num_successful_attacks
        ans = 0
        for row in 0..@grid.length - 1
            for col in 0..@grid.length - 1
                if @grid[row][col][0] && @grid[row][col][1]
                    ans += 1
                end
            end
        end
        ans
    end

    # returns Boolean
    # returns True if all the ships are sunk.
    # Return false if at least one ship hasn't sunk.
    def all_sunk?
        true
    end


    # String representation of GameBoard (optional but recommended)
    # only works with a grid size 10
    def to_s
        spaces = Proc.new do
            for space in 0..5                               # 6 spaced format
                print " "
            end
        end
        # printing grid:
        for row in 0..@max_row                              # 0th index is just for formatting
            if row == 0 
                spaces.call
            end
            for col in 0..@max_column
                if row == 0 && col < 10
                    print (col + 1).to_s                    # prints column number
                    if col < 10 
                        spaces.call
                    end
                else
                    slot1 = "-"
                    slot2 = "-"
                    if @grid[row - 1][col - 1][0] == true
                        slot1 = "S"                         # S = ship
                    end
                    if @grid[row - 1][col - 1][1] == true
                        slot2 = "H"                         # H = hit
                    end
                    if col == 1
                        print (row).to_s + ": "
                        if row < @max_row
                            print " "
                        end
                    end
                    if row > 0 && col > 0
                        print " " + slot1 + ", " + slot2 + " "
                        if col < @max_column
                            print "|"
                        end
                    end
                end
            end
            puts "\n"
        end
    end
end

# Tests
test = GameBoard.new(10, 10)
position1 = Position.new(4, 10)
position2 = Position.new(8, 8)
position3 = Position.new(4, 2)
position4 = Position.new(8, 2)
ship1 = Ship.new(position1, "Left", 8)
ship2 = Ship.new(position2, "Down", 3)
ship3 = Ship.new(position3, "Up", 4)
ship4 = Ship.new(position4, "Right", 4)
puts test.add_ship(ship1)
puts test.add_ship(ship2)
puts test.add_ship(ship3)
puts test.add_ship(ship4)
puts test.attack_pos(position1)
puts test.num_successful_attacks
puts test