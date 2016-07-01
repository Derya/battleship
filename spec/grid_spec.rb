require_relative 'spec_helper'

RSpec.describe Grid do

  before :each do
    @grid_sizes = [[8,8],[2,2],[1,1],[8,2]]
    @grids = []
    @ships = []
    @grid_sizes.each_with_index do |gridsize, index|
      x = gridsize[0]
      y = gridsize[1]
      @grids << Grid.new(x,y)
      ships_sub = []
      ships_sub << Ship.new(x, "topship1", :horizontal, 0, 0)
      ships_sub << Ship.new(1, "topship2", :horizontal, x-1, 0)
      ships_sub << Ship.new(x, "botship1", :horizontal, 0, y-1)
      ships_sub << Ship.new(1, "botship2", :horizontal, x-1, y-1)
      ships_sub << Ship.new(y, "leftship1", :vertical, 0, 0)
      ships_sub << Ship.new(1, "leftship2", :vertical, 0, y-1)
      ships_sub << Ship.new(y, "rightship1", :vertical, x-1, 0)
      ships_sub << Ship.new(1, "rightship2", :vertical, x-1, y-1)
      @ships << ships_sub
    end
  end


  describe "#initialize" do
    it "initializes a grid of the specified size" do
      expect(Grid.new(7,6).size_x).to eq(7)
      expect(Grid.new(7,6).size_y).to eq(6)
    end

    it "won't initialize a grid with any 0 dimensions" do
      expect{Grid.new(0,1)}.to raise_error(ArgumentError)
      expect{Grid.new(0,0)}.to raise_error(ArgumentError)
    end
  end

  describe "#ship_addable?" do
    it "returns :out_of_coords for ships that are not within the boundaries of the grid" do
      @negativeship = Ship.new(3, "testship", :vertical, -1, 1)
      @grid_sizes.each_with_index do |dimensions, index|
        x = dimensions[0]
        y = dimensions[1]
        grid = @grids[index]
        expect(grid.ship_addable?(@negativeship)).to eq(:out_of_coords)
        @outsideship = Ship.new(1, "testship", :vertical, x, 0)
        expect(grid.ship_addable?(@outsideship)).to eq(:out_of_coords)
        @outsideship = Ship.new(x+1, "testship", :horizontal, 0, 0)
        expect(grid.ship_addable?(@outsideship)).to eq(:out_of_coords)
        @outsideship = Ship.new(1, "testship", :horizontal, 0, y)
        expect(grid.ship_addable?(@outsideship)).to eq(:out_of_coords)
        @outsideship = Ship.new(y+1, "testship", :vertical, 0, 0)
        expect(grid.ship_addable?(@outsideship)).to eq(:out_of_coords)
      end
    end

    it "returns :intersects_ship for ships that intersect ships on the grid already" do
      @ship1 = Ship.new(3, "testship", :horizontal, 2, 2)
      @ship2 = Ship.new(3, "testship", :vertical, 3, 1)
      @grid = Grid.new(8,8)
      @grid.add_ship(@ship1)
      expect(@grid.ship_addable?(@ship1)).to eq(:intersects_ship)
      expect(@grid.ship_addable?(@ship2)).to eq(:intersects_ship)
    end

    it "returns :addable for ships that can be added" do

      @grid_sizes.each_with_index do |dimensions, index|
        grid = @grids[index]
        @ships[index].each do |ship|
          expect(grid.ship_addable?(ship)).to eq(:addable)
        end
      end

    end

  end

  describe "#add_ship" do

    it "adds ship at the correct location and returns :added" do
      @grid_sizes.each_with_index do |dimensions, index|
        grid = @grids[index]
        @ships[index].each do |ship|
          grid.instance_variable_set(:@ships, [])
          expect(grid.add_ship(ship)).to eq(:added)
          expect(grid.ships.include?(ship)).to eq(true)
          expect(grid.tiles[[ship.x,ship.y]].ship).to eq(ship)
        end
      end
    end

  end

  describe "#splash" do

    it "returns :out_of_coords for invalid coordinates" do
      @grid_sizes.each_with_index do |dimensions, index|
        x = dimensions[0]
        y = dimensions[1]
        grid = @grids[index]
        expect(grid.splash(x,0)).to eq(:out_of_coords)
        expect(grid.splash(0,y)).to eq(:out_of_coords)
        expect(grid.splash(-1,0)).to eq(:out_of_coords)
        expect(grid.splash(0,-1)).to eq(:out_of_coords)
      end
    end

    it "returns nil and splashes the coordinates for misses" do
      @grid_sizes.each_with_index do |dimensions, index|
        x = dimensions[0]
        y = dimensions[1]
        grid = @grids[index]
        tests = [[0,0],[x-1,0],[0,y-1],[x-1,y-1],[x/2,y/2]]
        tests.each do |test|
          x = test[0]
          y = test[1]
          grid.tiles[[x,y]].instance_variable_set(:@splashed, false)
          expect(grid.splash(x,y)).to eq(nil)
          expect(grid.tiles[[x,y]].splashed).to eq(true)
        end
      end
    end

    it "returns the hit ship and splashes the coordinates for hits" do
      @grid_sizes.each_with_index do |dimensions, index|
        grid = @grids[index]
        @ships[index].each do |ship|
          x = ship.x
          y = ship.y
          grid.instance_variable_set(:@ships, [])
          grid.tiles[[x,y]].instance_variable_set(:@splashed, false)
          grid.add_ship(ship)
          expect(grid.splash(x,y)).to eq(ship)
        end
      end
    end

    it "returns :splashed if the coordinates were already splashed" do
      @grid_sizes.each_with_index do |dimensions, index|
        x = dimensions[0]
        y = dimensions[1]
        grid = @grids[index]
        tests = [[0,0],[x-1,0],[0,y-1],[x-1,y-1],[x/2,y/2]]
        tests.each do |test|
          x = test[0]
          y = test[1]
          grid.tiles[[x,y]].instance_variable_set(:@splashed, true)
          expect(grid.splash(x,y)).to eq(:splashed)
          grid.add_ship(Ship.new(1,"testship",:horizontal,x,y))
          expect(grid.splash(x,y)).to eq(:splashed)
        end
      end
    end

  end

end

