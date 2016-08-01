

class Ship
  attr_reader :length, :name
  attr_accessor :x, :y, :orientation

  def initialize(length, name, orientation=nil, x=nil, y=nil)
    @length = length
    @name = name
    @orientation = orientation
    @x = x
    @y = y
  end

  # returns false if ships intersect, returns true if they don't intersect
  # may return true on incomplete location data on either ship...
  # TODO: ensure always returns true on incomplete location data? maybe?
  def clears?(another_ship)
    (self.coordinates_occupied & another_ship.coordinates_occupied).empty?
  end

  # toggles ship orientation, or, if orientation is given, then rotates to that orientation
  def rotate(orientation = nil)
    unless orientation.nil?
      self.orientation = orientation
    else
      self.orientation = :vertical if self.orientation = :horizontal
      self.orientation = :horitzontal if self.orientation = :vertical
    end
  end

  # returns array of coordinates this ship occupies
  def coordinates_occupied
    coordinates = []
    if self.orientation == :horizontal
      self.length.times { |i| coordinates << [self.x + i, self.y] }
    elsif self.orientation == :vertical
      self.length.times { |i| coordinates << [self.x, self.y + i] }
    end
    coordinates
  end


end