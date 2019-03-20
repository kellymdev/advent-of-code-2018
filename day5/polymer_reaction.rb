# frozen_string_literal: true

class PolymerReaction
  attr_reader :polymer, :show_polymer

  def initialize(polymer, show_polymer:)
    @polymer = format_polymer(polymer)
    @show_polymer = show_polymer
  end

  def react
    while contains_reaction?
      scan_string_for_reactions
      display_polymer if show_polymer
    end

    display_polymer_size
  end

  private

  def format_polymer(polymer)
    formatted = polymer.chars
    formatted - ["\n"]
  end

  def scan_string_for_reactions
    polymer.each.with_index do |unit, index|
      comparison = polymer[index + 1]

      next unless reactive?(unit, comparison)

      display_reaction(unit, comparison)
      create_reaction(index)

      return
    end
  end

  def reactive?(unit_1, unit_2)
    unit_1.swapcase == unit_2
  end

  def contains_reaction?
    polymer.each.with_index do |unit, index|
      next if index + 1 == polymer.size # we've reached the end of the polymer

      next unless reactive?(unit, polymer[index + 1])

      return true
    end

    false
  end

  def create_reaction(index)
    @polymer[index] = nil
    @polymer[index + 1] = nil
    @polymer.compact!
  end

  def display_polymer_size
    puts "Polymer size is: #{polymer.size}"
  end

  def display_polymer
    puts "Polymer is: #{polymer.join}"
  end

  def display_reaction(unit_1, unit_2)
    puts "#{unit_1} reacts with #{unit_2}"
  end
end
