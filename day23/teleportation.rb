# frozen_string_literal: true

class Teleportation
  NANOBOT_REGEX = /pos=<(-?\d+),(-?\d+),(-?\d+)>, r=(-?\d+)/

  attr_reader :nanobots, :nanobots_in_range, :strongest_nanobot

  def initialize(nanobot_positions)
    @nanobots = create_nanobots(nanobot_positions)
    @nanobots_in_range = 0
  end

  def find_nanobots_in_range
    find_strongest_nanobot

    nanobots.each do |nanobot|
      if nanobot_in_range?(nanobot)
        increment_nanobots_in_range
      end
    end

    display_nanobots_in_range
  end

  private

  def find_strongest_nanobot
    @strongest_nanobot ||= nanobots.max_by { |nanobot| nanobot[:radius] }
  end

  def nanobot_in_range?(nanobot)
    distance_from_strongest_nanobot(nanobot) <= strongest_nanobot[:radius]
  end

  def distance_from_strongest_nanobot(nanobot)
    (strongest_nanobot[:x_position] - nanobot[:x_position]).abs + (strongest_nanobot[:y_position] - nanobot[:y_position]).abs + (strongest_nanobot[:z_position] - nanobot[:z_position]).abs
  end

  def increment_nanobots_in_range
    @nanobots_in_range += 1
  end

  def create_nanobots(nanobot_positions)
    positions = nanobot_positions.split("\n")

    positions.map do |position|
      matches = position.match(NANOBOT_REGEX)

      {
        x_position: matches[1].to_i,
        y_position: matches[2].to_i,
        z_position: matches[3].to_i,
        radius: matches[4].to_i
      }
    end
  end

  def display_nanobots_in_range
    puts "Nanobots in range: #{nanobots_in_range}"
  end
end
