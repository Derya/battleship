require_relative 'alpha26_i26_converting'

class InvalidCoordError < Exception
end

class BattleshipInterface


  # human_coords should be string in format A3 or A,3 where the comma is
  # optional and could be any other character the user is delimiting the
  # coordinates by any random junk
  def human_to_coords(human_coords)
    str = human_coords.chomp.downcase
    # get the left part
    x = /^[a-z]+/.match(str)
    raise InvalidCoordError.new("couldn't parse user input") unless x && x[0]
    # convert to number, then to index
    x = x[0].to_i26 - 1
    # same for the right part
    y = /[0-9]+$/.match(str)
    raise InvalidCoordError.new("couldn't parse user input") unless y && y[0]
    y = y[0].to_i - 1
    [x,y]
  end

  # the reverse
  def coords_to_human(x,y)
    "#{(x+1).to_s26}#{y+1}".upcase
  end
end