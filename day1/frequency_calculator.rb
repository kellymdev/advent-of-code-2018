# frozen_string_literal: true

class FrequencyCalculator
  attr_reader :current_frequency, :frequencies, :calibrate, :calculated_frequencies, :repeated_frequency

  def initialize(starting_frequency, input, calibrate:)
    @current_frequency = starting_frequency
    @frequencies = format_frequencies(input)
    @calibrate = calibrate
    @calculated_frequencies = []
    @repeated_frequency = nil
  end

  def calculate
    if calibrate
      find_first_repeated_frequency

      display_repeated_frequency
    else
      calculate_last_frequency
    end
  end

  private

  def find_first_repeated_frequency
    loop do
      frequencies.each do |frequency|
        calculate_frequency(frequency)

        if calculated_frequencies.include?(current_frequency)
          @repeated_frequency = current_frequency
          break
        else
          @calculated_frequencies << current_frequency
        end
      end

      break if @repeated_frequency
    end
  end

  def calculate_last_frequency
    frequencies.each do |frequency|
      start_frequency = current_frequency
      calculate_frequency(frequency)

      display_change(start_frequency, frequency)
    end
  end

  def calculate_frequency(frequency_change)
    symbol = frequency_change[0]
    change = frequency_change[1..-1].to_i

    case symbol
    when '+'
      add(change)
    when '-'
      subtract(change)
    end
  end

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

  def display_repeated_frequency
    puts "Repeated frequency is: #{repeated_frequency}"
  end
end
