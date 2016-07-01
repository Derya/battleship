
class BattleshipBot

  def initialize(difficulity)
    @stack = []
  end

  def set_ships(grid, ships)
    ships.each do |ship|
      set_randomly(grid, ship)
    end
  end

  # ingenius
  def set_randomly(grid, ship)
    ship.orientation = [:horizontal,:vertical].sample
    max_x = grid.size_x
    max_y = grid.size_y
    ship.orientation == :horizontal ? max_x -= ship.length - 1 : max_y -= ship.length - 1
    ship.x = rand(max_x)
    ship.y = rand(max_y)
    set_randomly(grid,ship) unless grid.add_ship(ship) == :added
  end

  # gets shot from the AI and returns whether ship instance if it was a hit or false if it was a miss
  def take_shot(grid)
    x,y = superbrain_shot_taker(grid)
    shot = grid.splash(x,y)
    while (shot == :out_of_coords || shot == :splashed) do
      x,y = superbrain_shot_taker(grid)
      shot = grid.splash(x,y)
    end
    # this is necessary
    shot
  end

  #TODO: implement AI here!
  def superbrain_shot_taker(grid)
    [rand(grid.size_x),rand(grid.size_y)]
  end

end
