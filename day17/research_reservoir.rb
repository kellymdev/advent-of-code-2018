# frozen_string_literal: true

class ResearchReservoir
  X_COORDINATE_REGEX = /x=(\d+)(\.)*(\d+)*/
  Y_COORDINATE_REGEX = /y=(\d+)(\.)*(\d+)*/

  SPRING_LOCATION_X_COORD = 500
  SPRING_LOCATION_Y_COORD = 0

  SAND = '.'
  CLAY = '#'
  RESTING_WATER = '~'
  FALLING_WATER = '|'

  attr_reader :minimum_y_value, :maximum_y_value, :minimum_x_value, :maximum_x_value, :scan_data, :ground_water

  def initialize(clay_scan)
    @minimum_y_value = nil
    @maximum_y_value = nil
    @minimum_x_value = nil
    @maximum_x_value = nil
    @scan_data = format_scan_data(clay_scan)
    @ground_water = []
  end

  def find_water
    map_ground_water
    pour_water
  end

  private

  def map_ground_water
    create_ground_water_grid

    scan_data.each do |coordinate_pair|
      if coordinate_pair[:x].is_a?(Range)
        coordinate_pair[:x].each do |x_coordinate|
          @ground_water[coordinate_pair[:y] - minimum_y_value][x_coordinate] = CLAY
        end
      elsif coordinate_pair[:y].is_a?(Range)
        coordinate_pair[:y].each do |y_coordinate|
          @ground_water[y_coordinate - minimum_y_value][coordinate_pair[:x]] = CLAY
        end
      end
    end
  end

  def create_ground_water_grid
    raise 'Maximum x value of #{maximum_x_value} is greater than 1000' if maximum_x_value > 1000

    max_height = maximum_y_value - minimum_y_value
    @ground_water = Array.new(max_height) { Array.new(1000) { SAND } }
  end

  def pour_water
    y_coordinate = 0
    current_cell = @ground_water[y_coordinate][SPRING_LOCATION_X_COORD]

    while !clay?(current_cell) && !resting_water?(current_cell)
      fill_cell_with_falling_water(y_coordinate, SPRING_LOCATION_X_COORD)

      y_coordinate += 1

      current_cell = @ground_water[y_coordinate, SPRING_LOCATION_X_COORD]
    end

    fill_cell_with_resting_water(y_coordinate - 1, SPRING_LOCATION_X_COORD)
  end

  def fill_cell_with_falling_water(y_coordinate, x_coordinate)
    @ground_water[y_coordinate][x_coordinate] = FALLING_WATER
  end

  def fill_cell_with_resting_water(y_coordinate, x_coordinate)
    @ground_water[y_coordinate][x_coordinate] = RESTING_WATER
  end

  def clay?(cell_contents)
    cell_contents == CLAY
  end

  def water?(cell_contents)
    resting_water?(cell_contents) || falling_water?(cell_contents)
  end

  def resting_water?(cell_contents)
    cell_contents == RESTING_WATER
  end

  def falling_water?(cell_contents)
    cell_contents == FALLING_WATER
  end

  def format_scan_data(clay_scan)
    coordinate_pairs = clay_scan.split("\n")
    coordinate_pairs.map do |pair|
      x_matches = pair.match(X_COORDINATE_REGEX)
      x_coordinate = determine_coordinates(x_matches)

      y_matches = pair.match(Y_COORDINATE_REGEX)
      y_coordinate = determine_coordinates(y_matches)
      set_min_and_max_y_values(y_coordinate)

      {
        x: x_coordinate,
        y: y_coordinate
      }
    end
  end

  def determine_coordinates(matches)
    if matches[2] == '.'
      Range.new(matches[1].to_i, matches[3].to_i)
    else
      matches[1].to_i
    end
  end

  def set_min_and_max_y_values(y_coordinate)
    value = if y_coordinate.is_a?(Range)
      y_coordinate.last
    else
      y_coordinate
    end

    if minimum_y_value.nil? || value < minimum_y_value
      @minimum_y_value = value
    end

    if maximum_y_value.nil? || value > maximum_y_value
      @maximum_y_value = value
    end
  end

  def set_min_and_max_x_values(x_coordinate)
    value = if x_coordinate.is_a?(Range)
      x_coordinate.last
    else
      x_coordinate
    end

    if minimum_x_value.nil? || value < minimum_x_value
      @minimum_x_value = value
    end

    if maximum_x_value.nil? || value > maximum_x_value
      @maximum_x_value = value
    end
  end
end
