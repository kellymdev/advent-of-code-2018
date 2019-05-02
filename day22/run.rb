require_relative 'map_cave_system'

# depth = 510
# target_x = 10
# target_y = 10

depth = 8787
target_x = 10
target_y = 725

cave = MapCaveSystem.new(depth, target_x, target_y)
cave.calculate_cave_risk
