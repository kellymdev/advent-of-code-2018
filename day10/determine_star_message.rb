# frozen_string_literal: true

class DetermineStarMessage
  COORDINATE_REGEX = /position=<\s*(\-?\d+),\s*(\-?\d+)> velocity=<\s*(\-?\d+),\s*(\-?\d+)>/
  BLANK_SQUARE = '.'
  STAR = '#'

  attr_reader :coordinates, :max_width, :max_height, :stars, :seconds, :current_second

  def initialize(coordinates, seconds: 1)
    @coordinates = format_coordinates(coordinates)
    @seconds = seconds
    @current_second = 0
    @max_width = 0
    @max_height = 0
    @stars = nil
  end

  def view_stars
    set_up_star_plot

    while seconds >= current_second
      move_stars

      increment_current_second

      display_stars
    end

  end

  private

  def format_coordinates(coordinates)
    instructions = coordinates.split("\n")

    instructions.map do |instruction|
      matches = instruction.match(COORDINATE_REGEX)

      {
        x_position: matches[1].to_i,
        y_position: matches[2].to_i,
        x_velocity: matches[3].to_i,
        y_velocity: matches[4].to_i
      }
    end
  end

  def set_up_star_plot
    find_max_width
    find_max_height
    create_star_grid
    plot_stars
  end

  def find_max_width
    max = coordinates.max_by do |coordinate_set|
      coordinate_set[:x_position]
    end

    @max_width = max[:x_position] + 1
  end

  def find_max_height
    max = coordinates.max_by do |coordinate_set|
      coordinate_set[:y_position]
    end

    @max_height = max[:y_position] + 1
  end

  def create_star_grid
    @stars = Array.new(max_height) { Array.new(max_width) { BLANK_SQUARE } }
  end

  def plot_stars
    coordinates.each do |coordinate_set|
      @stars[coordinate_set[:y_position]][coordinate_set[:x_position]] = STAR
    end
  end

  def move_stars
    coordinates.each do |coordinate_set|
      move_star(coordinate_set)
    end
  end

  def move_star(coordinate_set)
    @stars[coordinate_set[:y_position]][coordinate_set[:x_position]] = BLANK_SQUARE

    coordinate_set[:y_position] += coordinate_set[:y_velocity]
    coordinate_set[:x_position] += coordinate_set[:x_velocity]

    @stars[coordinate_set[:y_position]][coordinate_set[:x_position]] = STAR
  end

  def increment_current_second
    @current_second += 1
  end

  def display_stars
    puts "At #{current_second} second/s:"

    stars.each do |row|
      puts row.join
    end

    puts
  end
end
