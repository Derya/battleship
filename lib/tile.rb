

class Tile

  attr_accessor :splashed, :ship

  def initialize(ship = nil, is_splashed = false)
    @splashed = is_splashed
    @ship = ship
  end

end