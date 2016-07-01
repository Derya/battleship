require_relative 'battleship_game'
require_relative 'battleship_interface'
require_relative 'bash_interface'
require_relative 'battleship_bot'

class InvalidCoordError < Exception
end

SHIPS = [
  Ship.new(5, "Aircraft Carrier"),
  Ship.new(4, "Battleship"),
  Ship.new(3, "Destroyer"),
  Ship.new(3, "Submarine"),
  Ship.new(2, "Patrol Boat")
]

ui = BashInterface.new()
ai = BattleshipBot.new(:insane)
a = BattleshipGame.new(ui,ai,SHIPS)

a.run


