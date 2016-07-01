require 'colorize'

class BashInterface < BattleshipInterface

  def set_ships(grid, ships)
    ships.each { |ship| place_ship(ship, grid) }
  end

  # TODO: maybe change this entirely to live ship moving
  def place_ship(ship, grid)
    print "\n\nPlace your #{ship.name}:\n"
    show_grid(grid, true)
    print_ship(ship)
    print "\n"
    ship.orientation = get_orientation(ship, grid)
    get_and_set_coordinates(ship, grid)
  end

  def show_status(player_grid, opponent_grid)
    # TODO: after? refractoring these methods, also change grids to display side by side
    show_grid(opponent_grid, false)
    print "\n"
    show_grid(player_grid, true)
  end

  def print_ship(ship)
    #TODO: implement use of max_digits = (grid.size_y/10)+1
    print "\n  " + ("   " * ship.length).colorize(:background => :light_black) + "\n"
  end

  def show_grid(grid, is_ally)
    # calculate maximum length of the row and column headers
    max_digits = (grid.size_y/10)+1
    max_letters = (grid.size_x/10)+1

    # add header
    out = get_header(max_digits, max_letters, grid.size_x, is_ally) + "\n"
    # add all our rows
    grid.size_y.times { |row_num| out << get_row(max_digits, max_letters, row_num, grid, is_ally) + "\n" }
    # add another header
    out << get_header(max_digits, max_letters, grid.size_x, is_ally) + "\n"

    print out
  end

  # method for getting shot input from user. returns ship on hit or nil (false?) on miss
  def get_shot(grid)
    print "Shell loaded captain! Enter coordinates to fire at: "
    x,y = get_coords
    shot_result = grid.splash(x,y)
    while (shot_result == :out_of_coords || shot_result == :splashed) do
      shot_result == :out_of_coords ? show_invalid_coord_msg(x,y) : show_splashed_msg(x,y)
      print "Enter coordinates to fire at: "
      x,y = get_coords
      shot_result = grid.splash(x,y)
    end
    shot_result
  end

  def show_game_over(winner)
    if winner == :player
      print color_good("You win!") + "\n"
    else
      print color_bad("You lose!") + "\n"
    end
  end

  def show_opponent_miss_message
    print color_neutral("Our enemies missed!") + "\n"
  end

  def show_opponent_hit_message(ship)
    print color_bad("Our enemies have scored a hit on our #{ship.name}!") + "\n"
  end

  def show_friendly_sunk_message(ship)
    print color_bad("Our #{ship.name} has been sunk!!!") + "\n"
  end

  def show_hit_message(ship)
    print color_good("A hit!") + "\n"
  end

  def show_miss_message
    print color_neutral("We missed!") + "\n"
  end

  def show_sunk_message(ship)
    print color_good("We've sunk their #{ship.name}!!!") + "\n"
  end

  private

  def get_coords
    begin
      x,y = human_to_coords(gets)
    rescue InvalidCoordError
      print "Enter column letter first, row second on the same line. "
      get_coords
    end
  end

  def show_invalid_coord_msg(x,y)
    print "But #{coords_to_human(x,y)} isn't a location that even exists in our universe captain!!!\n"
  end

  def show_splashed_msg(x,y)
    print "We've already shot at #{coords_to_human(x,y)}!\n"
  end

  def get_and_set_coordinates(ship, grid)
    print "Enter coordinates: "
    ship.x,ship.y = get_coords
    add_status = grid.add_ship(ship)
    until add_status == :added do
      print add_status == :out_of_coords ? "Invalid coordinate. " : "That would intersect another ship. "
      print "Enter coordinates: "
      ship.x,ship.y = get_coords
      add_status = grid.add_ship(ship)
    end
  end

  # TODO: probably replace this functionality with something cooler
  def get_orientation(ship, grid)
    print "Enter 1 for horizontal or 2 for vertical placement: "
    case gets.chomp
    when "1"
      :horizontal
    when "2"
      :vertical
    else
      get_orientation(ship, grid)
    end
  end

  def color_neutral(str)
    str.colorize(:color => :black, :background => :cyan)
  end

  def color_good(str)
    str.colorize(:color => :white, :background => :green)
  end

  def color_bad(str)
    str.colorize(:color => :white, :background => :red)
  end

  def get_row(max_digits, max_letters, row_number, grid, is_ally)
    # build our left and right row headers
    row_header_left = "#{row_number+1}".rjust(max_digits)
    row_header_right = "#{row_number+1}".ljust(max_digits)
    # colorize them based on which grid we are showing
    if is_ally
      row_header_left = row_header_left.colorize(:color => :white, :background => :black)
      row_header_right = row_header_right.colorize(:color => :white, :background => :black)
    else
      row_header_left = row_header_left.colorize(:color => :green, :background => :black)
      row_header_right = row_header_right.colorize(:color => :green, :background => :black)
    end
    # add all our tiles in this row, using left header as our final output string
    grid.size_x.times do |col|
      row_header_left << get_tile(grid.tiles[[col,row_number]], is_ally)
    end
    # add the other header
    row_header_left << row_header_right
  end

  def get_tile(tile, is_ally)
    if tile.ship && tile.splashed
      " X ".colorize(:color => :red, :background => :light_black)
    elsif tile.ship && !tile.splashed
      # for enemy map mode we must actually ensure we print this the same as !ship && !splashed
      is_ally ? "   ".colorize(:background => :light_black) : " ~ ".colorize(:color => :light_black, :background => :green)
    elsif !tile.ship && tile.splashed
      is_ally ? " X ".colorize(:color => :red, :background => :blue) : " X ".colorize(:color => :red, :background => :green)
    else #!tile.ship && !tile.splashed
      is_ally ? " ~ ".colorize(:color => :light_black, :background => :blue) : " ~ ".colorize(:color => :light_black, :background => :green)
    end
  end

  # TODO: implement
  def get_header(max_digits, max_letters, grid_width, is_ally)
    # spacing on left
    out = " " * max_digits
    # all the letters
    grid_width.times { |col_num| out << " #{(col_num+1).to_s26.upcase} " }
    # spacing on right
    out << " " * max_digits

    is_ally ? out.colorize(:color => :white, :background => :black) : out.colorize(:color => :green, :background => :black)
  end

end
