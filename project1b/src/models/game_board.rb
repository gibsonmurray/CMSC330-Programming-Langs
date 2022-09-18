require_relative '../models/ship'
require_relative '../models/position'

class GameBoard
    # @max_row is an `Integer`
    # @max_column is an `Integer`
    attr_reader :max_row, :max_column

    def initialize(max_row, max_column)
        @max_row = max_row
        @max_column = max_column
        # false = no ship (i = 0), no hit (i = 1) // true otherwise
        @grid = Array.new(max_row) {Array.new(max_column) {Array.new(2, false)}} 
        @num_hit = 0
        @total_sizes = 0
    end

    # adds a Ship object to the GameBoard
    # returns Boolean
    # Returns true on successfully added the ship, false otherwise
    # Note that Position pair starts from 1 to max_row/max_column
    def add_ship(ship)
        # -1 to positions and size so it is in sync w/ array indexing
        start_r = ship.start_position.row - 1
        start_c = ship.start_position.column - 1
        size = ship.size - 1

        # How each section works:
        # checking to see if a ship is already in one of the positions intended to take up
        # if check passes then the ship will be added

        # checking valid starting point
        if start_r < 0 || start_r > @max_row - 1 || start_c < 0 || start_c > @max_column - 1
            return false
        end

        if ship.orientation == "Up"
            if ship.start_position.row - size < 1            # checking to make sure ship will not go out of bounds
                return false
            end
            for row in (start_r - size)..start_r      # minus b/c going up in grid
                if @grid[row][start_c][0] == true
                    return false
                end
                @grid[row][start_c][0] = true   
            end
        end
        if ship.orientation == "Down" 
            if ship.start_position.row + size > @max_row            
                return false
            end
            for row in start_r..(start_r + size)     
                if @grid[row][start_c][0] == true 
                    return false
                end
                @grid[row][start_c][0] = true
            end
        end
        if ship.orientation == "Left" 
            if ship.start_position.column - size < 1                     
                return false
            end
            for col in (start_c - size)..start_c
                if @grid[start_r][col][0] == true 
                    return false
                end
                @grid[start_r][col][0] = true
            end
        end
        if ship.orientation == "Right" 
            if ship.start_position.column + size > @max_column   
                return false
            end
            for col in start_c..(start_c + size)      
                if @grid[start_r][col][0] == true 
                    return false
                end
                @grid[start_r][col][0] = true
            end
        end
        @total_sizes += ship.size
        true
    end

    # return Boolean on whether attack was successful or not (hit a ship?)
    # return nil if Position is invalid (out of the boundary defined)
    def attack_pos(position)
        hit = false
        # check position
        if position.row > @max_row || position.row < 1 || position.column > @max_column || position.column < 1
            return nil
        end
        # update your grid
        row = position.row - 1
        col = position.column - 1
        @grid[row][col][1] = true
        # return whether the attack was successful or not
        if @grid[row][col][0]
            hit = true
            @num_hit += 1
        end
        hit
    end

    # Number of successful attacks made by the "opponent" on this player GameBoard
    def num_successful_attacks
        @num_hit
    end

    # returns Boolean
    # returns True if all the ships are sunk.
    # Return false if at least one ship hasn't sunk.
    def all_sunk?
        @num_hit == @total_sizes ? true : false
    end


    # This is wrong:
    def to_s
        slot1 = "-"
        slot2 = "-"
        for row in 0..@max_row - 1
            for col in 0..@max_column - 1
                if @grid[row][col][0]
                    slot1 = "S"                         # S = ship
                end
                if @grid[row][col][1]
                    slot2 = "H"                         # H = hit
                end
                print " " + slot1 + ", " + slot2 + " "
                if col < @max_column - 1
                    print " "
                end
            end
            puts "\n"
        end
        nil
    end
end

# Tests
test = GameBoard.new(10, 10)
# position = Position.new(1,1)
# ship = Ship.new(position, "Left", 1)
# puts test.add_ship(ship)
# position1 = Position.new(4, 10)
# position2 = Position.new(8, 8)
# position3 = Position.new(4, 2)
# position4 = Position.new(8, 2)
# ship1 = Ship.new(position1, "Left", 8)
# ship2 = Ship.new(position2, "Down", 3)
# ship3 = Ship.new(position3, "Up", 4)
# ship4 = Ship.new(position4, "Right", 4)
# test.add_ship(ship1)
# test.add_ship(ship2)
# test.add_ship(ship3)
# test.add_ship(ship4)
# test.attack_pos(position2)
# test.attack_pos(Position.new(9,8))
# test.attack_pos(Position.new(10,8))
# test.num_successful_attacks
# test.all_sunk?
# puts test.to_s

# position = Position.new(2,2)
# ship1 = Ship.new(position, "Right", 3)
# ship2 = Ship.new(position, "Right", 2)
# puts test.add_ship(ship1)
# puts test.add_ship(ship2)
# puts test