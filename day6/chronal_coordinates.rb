# frozen_string_literal: true

class ChronalCoordinates
  COORDINATE_REGEX = /(\d+), (\d+)/
  BLANK_SQUARE = '.'

  attr_reader :coordinates, :max_height, :max_width, :area

  def initialize(coordinates)
    @max_height = 0
    @max_width = 0
    @coordinates = format_coordinates(coordinates)
    @area = create_area_plot
  end

  def find_largest_area
    plot_coordinates
    determine_closest_coordinates_to_each_square
  end

  private

  def format_coordinates(coordinates)
    pairs = coordinates.split("\n")

    pairs.map do |pair|
      matches = pair.match(COORDINATE_REGEX)

      x_value = matches[1]
      y_value = matches[2]

      if y_value > max_height
        @max_height = y_value
      end

      if x_value > max_width
        @max_width = x_value
      end

      {
        x_value: x_value,
        y_value: y_value
      }
    end
  end

  def create_area_plot
    Array.new(max_height) { Array.new(max_width) { BLANK_SQUARE } }
  end

  def plot_coordinates
    coordinates.each.with_index do |coordinate_pair, index|
      @area[coordinate_pair[:y_value]][coordinate_pair[:x_value]] = "A#{index}"
    end
  end

  def determine_closest_coordinates_to_each_square
    area.each.with_index do |row, y_index|
      row.each.with_index do |cell, x_index|
        next unless cell == BLANK_SQUARE

        determine_closest_coordinate(x_index, y_index)
      end
    end
  end

  def determine_closest_coordinate(x_index, y_index)
    
  end
end