class GameBoard
    # @max_row is an `Integer`
    # @max_column is an `Integer`
    attr_reader :max_row, :max_column

    def initialize(max_row, max_column)
        @max_row = max_row
        @max_column = max_column
        @grid = Array.new(max_row, Array.new(max_column, false))
    end

    # adds a Ship object to the GameBoard
    # returns Boolean
    # Returns true on successfully added the ship, false otherwise
    # Note that Position pair starts from 1 to max_row/max_column
    def add_ship(ship)
        start_r = ship.start_position.row
        start_c = ship.start_position.column
        if ship.orientation == "Up"
            for row in start_r..(start_r - ship.size)
                # figure it out
        end
        if ship.orientation == "Down"

        end
        if ship.orientation == "Left"

        end
        if ship.orientation == "Right"

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
        "STRING METHOD IS NOT IMPLEMENTED"
    end
end
