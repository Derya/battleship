
class BattleshipBot

  def initialize(difficulity)
    @stack = []
  end

  def set_ships(grid, ships)
    ships.each do |ship|
      set_randomly(grid, ship)
    end
  end

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
    # TODO: implemented safely for now for testing. when features finished, this should be unecessary, or moved to the random shot taker 
    x,y = get_shot(grid)
    shot = grid.splash(x,y)
    while (shot == :out_of_coords || shot == :splashed) do
      x,y = get_shot(grid)
      shot = grid.splash(x,y)
    end
    shot
  end

  #TODO: implement AI difficulities here!
  def get_shot(grid)
    get_random_shot(grid)
  end

  def get_random_shot(grid)
    [rand(grid.max_x, rand(grid.max_y)]
  end

  def get_superbrain_shot(grid)
    prob_grid = calculate(grid)
    # TODO: find some enumerator to do this better
    best_keys = []
    best_val = -1
    prob_grid.each_pair do |key, value|
      best_keys << key if value == best_val
      best_keys = [key] if value > best_val
    end
    best_keys.sample
  end

  def calculate(grid)
    obstacle_grid = get_base_hash(grid)
    probability_grid = Hash.new(0)
    grid.living_ships.each do |ship|
      possible_locations(ship).each do |ship_base_coord|
        potential_ship = Ship.new(ship.length, "imaginary", ship.orientation, ship_base_coord[0], ship_base_coord[1])
        potential_ship.coordinates_occupied.each do |coord|
          probability_grid[coord] += 1
        end
      end
    end
    prob_grid
  end

  # so this is like, getting a hash that represents the 2d grid. its entries represent misses and hits on the grid.
  # misses that are part of destroyed ships are treated the same as misses, we care only the distinction between empty spots
  # misses/deadships and hits that are part of undestroyed ships
  def get_base_hash(grid)

  end

  def possible_locations(ship)
    locations = []
    case ship.orientation
    when :horizontal

    when  :vertical

    end
  end

end
