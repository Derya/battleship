require_relative 'battleship_game'
require_relative 'battleship_interface'
require_relative 'bash_interface'
require_relative 'battleship_bot'





BattleshipGame.new(BashInterface.new(),BattleshipBot.new(:insane)).run


