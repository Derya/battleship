require_relative 'grid'

class BattleshipGame

  #attr_reader :player_grid, :opp_grid
  SHIPS = [
    Ship.new(5, "Aircraft Carrier"),
    Ship.new(4, "Battleship"),
    Ship.new(3, "Destroyer"),
    Ship.new(3, "Submarine"),
    Ship.new(2, "Patrol Boat")
  ]

  def initialize(presenter, opponent)
    @presenter = presenter
    @opponent = opponent

    @player_grid = Grid.new(8,8)
    @opp_grid = Grid.new(8,8)
    @winner = :none
    @opponent_ships = []
    ships = SHIPS
    ships.each { |ship| @opponent_ships << ship.clone}
    @player_ships = ships
  end

  def run
    setup
    until @winner != :none do
      run_turn
    end
    cleanup
  end

  private

  def setup
    # get presenter to have player set up each ship
    @presenter.set_ships(@player_grid, @player_ships)
    #@opponent.set_ships(@player_grid, @player_ships)
    # get AI to place their ships
    @opponent.set_ships(@opp_grid, @opponent_ships)
  end

  def run_turn
    @presenter.show_status(@player_grid, @opp_grid)
    player_turn
    @winner = :player if @opp_grid.all_ships_dead?
    opponent_turn unless @winner == :player
    @winner = :opp if @player_grid.all_ships_dead?
  end

  def player_turn
    ship = @presenter.get_shot(@opp_grid)
    if ship
      @presenter.show_hit_message(ship)
      @presenter.show_sunk_message(ship) if @opp_grid.dead?(ship)
    else
      @presenter.show_miss_message
    end
  end

  def opponent_turn
    ship = @opponent.take_shot(@player_grid)
    if ship
      @presenter.show_opponent_hit_message(ship)
      @presenter.show_friendly_sunk_message(ship) if @player_grid.dead?(ship)
    else
      @presenter.show_opponent_miss_message
    end
  end

  def cleanup
    @presenter.show_game_over(@winner)
  end



end








