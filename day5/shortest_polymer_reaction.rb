# frozen_string_literal: true

require_relative 'polymer_reaction'
require 'byebug'

class ShortestPolymerReaction
  attr_reader :polymer, :current_polymer

  def initialize(polymer)
    @polymer = format_polymer(polymer)
    @current_polymer = []
  end

  def find_shortest_polymer
    lengths = find_polymer_lengths

    shortest = find_shortest_length(lengths)

    display_shortest_length(shortest.first, shortest.last)
  end

  private

  def format_polymer(polymer)
    formatted = polymer.chars
    formatted - ["\n"]
  end

  def find_polymer_lengths
    lengths = {}

    ("A".."Z").each do |unit_type|
      new_polymer = react_polymer(unit_type, polymer)

      lengths[unit_type] = PolymerReaction.new(current_polymer.join, show_polymer: false).reaction_size

      puts current_polymer.join
    end

    lengths
  end

  def react_polymer(unit_type, polymer_to_react)
    @current_polymer = polymer_to_react

    while contains_reaction?(unit_type, polymer_to_react) do
      scan_polymer_for_reactions(unit_type, polymer_to_react)
    end
  end

  def scan_polymer_for_reactions(unit_type, polymer_to_react)
    polymer_to_react.each.with_index do |unit, index|
      next unless unit_type_matches?(unit, unit_type)

      next if index + 1 == polymer_to_react.size

      unit_2 = polymer_to_react[index + 1]

      next unless reactive?(unit, unit_2)

      create_reaction(index)

      return
    end
  end

  def contains_reaction?(unit_type, polymer)
    polymer.each.with_index do |unit, index|
      next unless unit_type_matches?(unit, unit_type)

      next if index + 1 == polymer.size

      next unless reactive?(unit, polymer[index + 1])

      return true
    end

    false
  end

  def unit_type_matches?(unit, unit_type)
    unit == unit_type || unit.upcase == unit_type
  end

  def reactive?(unit_1, unit_2)
    unit_1.swapcase == unit_2
  end

  def find_shortest_length(length_hash)
    length_hash.min_by { |unit_type, length| length }
  end

  def create_reaction(index)
    @current_polymer[index] = nil
    @current_polymer[index + 1] = nil
    @current_polymer.compact!
  end

  def display_shortest_length(unit_type, length)
    puts "Unit type: #{unit_type}"
    puts "Shortest length: #{length}"
  end
end
