# frozen_string_literal: true

class FrequencyCalculator
  attr_reader :current_frequency, :frequencies

  def initialize(starting_frequency, input)
    @current_frequency = starting_frequency
    @frequencies = format_frequencies(input)
  end

  def calculate
    frequencies.each do |frequency|
      symbol = frequency[0]
      change = frequency[1..-1].to_i

      start_frequency = current_frequency

      case symbol
      when '+'
        add(change)
      when '-'
        subtract(change)
      end

      display_change(start_frequency, frequency)
    end
  end

  private

  def format_frequencies(input)
    input.split("\n")
  end

  def add(change)
    @current_frequency += change
  end

  def subtract(change)
    @current_frequency -= change
  end

  def display_change(start_frequency, frequency)
    puts "Current frequency: #{start_frequency}, change of #{frequency}; resulting frequency: #{current_frequency}"
  end
end
