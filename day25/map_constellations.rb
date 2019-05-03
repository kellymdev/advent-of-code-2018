# frozen_string_literal: true

class MapConstellations
  COORDINATE_REGEX = /(-?\d+),(-?\d+),(-?\d+),(-?\d+)/

  attr_reader :points, :constellations

  def initialize(coordinate_list)
    @points = format_points(coordinate_list)
    @constellations = []
  end

  def count_constellations
    points.each do |point|
      find_constellation(point)
    end

    display_constellation_count
  end

  private

  def find_constellation(point)
    fits_in_constellations = []

    constellations.each.with_index do |constellation, index|
      if fits_in_constellation?(point, constellation)
        fits_in_constellations << index
      end
    end

    if fits_in_constellations.any?
      @constellations[fits_in_constellations.first] << point

      if fits_in_constellations.size > 1
        join_constellations(fits_in_constellations)
      end
    else
      @constellations << [point]
    end
  end

  def fits_in_constellation?(point, constellation)
    constellation.each do |constellation_point|
      if points_in_same_constellation?(point, constellation_point)
        return true
      end
    end
  end

  def points_in_same_constellation?(point, constellation_point)
    (point[:x_position] - constellation_point[:x_position]).abs + (point[:y_position] - constellation_point[:y_position]).abs + (point[:z_position] - constellation_point[:z_position]).abs + (point[:a_position] - constellation_point[:a_position]).abs <= 3
  end

  def join_constellations(constellations_to_join)
    constellation_to_add_to, *other_constellations = constellations_to_join

    add_to_constellation = other_constellations.flat_map do |constellation_index|
      @constellations[constellation_index]
    end

    @constellations[constellation_to_add_to] + add_to_constellation

    other_constellations.each do |constellation_index|
      @constellations[constellation_index] = nil
    end

    @constellations.compact
  end

  def format_points(coordinate_list)
    coordinates = coordinate_list.split("\n")
    coordinates.map do |coordinates|
      matches = coordinates.match(COORDINATE_REGEX)

      {
        x_position: matches[1].to_i,
        y_position: matches[2].to_i,
        z_position: matches[3].to_i,
        a_position: matches[4].to_i
      }
    end
  end

  def display_constellation_count
    puts "Constellation count: #{constellations.size}"
  end
end
