require_relative 'battleship_game'
require_relative 'grid'
require_relative 'battleship_interface'
require_relative 'bash_interface'
require_relative 'battleship_bot'

class InvalidCoordError < Exception
end

# haha magic
class String
  Alpha26 = ("a".."z").to_a

  def to_i26
    result = 0
    downcase!
    (1..length).each do |i|
      char = self[-i]
      result += 26**(i-1) * (Alpha26.index(char) + 1)
    end
    result
  end
end

class Numeric
  Alpha26 = ("a".."z").to_a

  def to_s26
    return "" if self < 1
    s, q = "", self
    loop do
      q, r = (q - 1).divmod(26)
      s.prepend(Alpha26[r]) 
      break if q.zero?
    end
    s
  end
end

