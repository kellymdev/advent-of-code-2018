require_relative 'map_constellations'

# input = <<-INPUT
# 0,0,0,0
# 3,0,0,0
# 0,3,0,0
# 0,0,3,0
# 0,0,0,3
# 0,0,0,6
# 9,0,0,0
# 12,0,0,0
# INPUT

input = <<-INPUT
-1,2,2,0
0,0,2,-2
0,0,0,-2
-1,2,0,0
-2,-2,-2,2
3,0,2,-1
-1,3,2,2
-1,0,-1,0
0,2,1,-2
3,0,0,0
INPUT

constellation_map = MapConstellations.new(input)
constellation_map.count_constellations
