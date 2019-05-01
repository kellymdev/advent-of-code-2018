require_relative 'make_hot_chocolate'

# input = 9
# input = 5
# input = 18
# input = 2018

# input = 51589
# input = 01245
# input = 92510
# input = 59414

input = 919901

# Part One
hot_chocolate = MakeHotChocolate.new(input)
# hot_chocolate.find_scores

# Part Two
chocolate = MakeHotChocolate.new(input)
chocolate.find_recipe_count
