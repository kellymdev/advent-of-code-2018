require_relative 'determine_power_level'

input = 18
# input = 42

# input = 6392

# Part One
power = DeterminePowerLevel.new(input)
power.find_largest_power

# Part Two
most_power = DeterminePowerLevel.new(input)
most_power.find_largest_square
