require_relative 'tile'
require_relative 'ship'

class Grid

  attr_reader :size_x, :size_y, :ships, :tiles

  def initialize(size_x, size_y)
    raise ArgumentError.new("dimensions must be positive") unless (size_x > 0) && (size_y > 0)
    @size_x = size_x
    @size_y = size_y

    # tiles[[x,y]] will get the tiles tile
    @tiles = Hash.new
    @size_x.times do |x|
      @size_y.times do |y|
        @tiles[[x,y]] = Tile.new
      end
    end
    # array of ships
    @ships = []
  end

  # safe method for adding a ship
  # tries to add a ship, returns :added, :out_of_coords, :intersects_ship
  def add_ship(ship)
    status = self.ship_addable?(ship)
    return status unless status == :addable
    ship.coordinates_occupied.each { |coordinate| self.tiles[coordinate].ship = ship }
    self.ships << ship
    :added
  end

  # sees if ship can be added, returns :addable, :out_of_coords, :intersects_ship
  def ship_addable?(ship)
    # first, check if ship origin is within grid
    return :out_of_coords unless ship.x >= 0 && ship.y >= 0
    return :out_of_coords unless ship.x < self.size_x && ship.y < self.size_y
    # second, check if rest of ship is within grid
    if ship.orientation == :horizontal
      return :out_of_coords unless ship.x + ship.length <= self.size_x
    elsif ship.orientation == :vertical
      return :out_of_coords unless ship.y + ship.length <= self.size_y
    else
      # we want program to break if ship doesn't have an orientation
      raise ArgumentError.new("must call with ship with location data, ship must be :horizontal or :vertical")
    end
    # third, check if ship intersects other ships
    self.ships.each { |other_ship| return :intersects_ship unless ship.clears?(other_ship) }
    # otherwise, ship is addable
    :addable
  end

  # tries to splash coordinate x,y, returns :splashed if already splashed, otherwise
  # nil if the splash is a miss or ship if it is a hit
  # returns :out_of_coords if coordinate is invalid
  def splash(x, y)
    return :out_of_coords unless x < self.size_x && y < self.size_y
    return :out_of_coords unless x >= 0 && y >= 0
    return :splashed if self.tiles[[x,y]].splashed
    self.tiles[[x,y]].splashed = true
    self.tiles[[x,y]].ship
  end

  # TODO: this needs spec
  def all_ships_dead?
    self.ships.each { |ship| return false unless self.dead?(ship) }
      true
  end

  # TODO: this needs spec
  def dead?(ship)
    ship.coordinates_occupied.each { |coord| return false unless self.tiles[coord].splashed }
    true
  end

  # def remove_ship(*args)
  #   if (args.length == 1) && (args[0].is_a? Ship)
        # DFGHJKDFGHJK
  #   elsif (args.length == 2) && (args[0].is_a? Integer) && (args[1].is_a? Integer)
      
  #   else
  #     raise ArgumentError.new("must call with 1 argument (ship) or 2 arguments (integer, integer)")
  #   end
  # end

  # # moves ship at x_old, y_old to x, y. need not be called with uppermost leftmost coordinate of ship?
  # # should not be called when game is underway?
  # def move_ship(x_old, y_old, x, y)
  #   #TODO: this
  # end

end