require_relative 'collect_lumber'

# input = <<-INPUT
# .#.#...|#.
# .....#|##|
# .|..|...#.
# ..|#.....#
# #.#|||#|#|
# ...#.||...
# .|....|...
# ||...#|.#|
# |.||||..|.
# ...#.|..|.
# INPUT

input = <<-INPUT
.||.###.|.#|.|...|#|..##...|..#....#.|..|..##.#|..
..|..|#..##..|..#.......|#.#|##..|#...#...|.|..||.
#..#|..........#...#.#.|...||...##||..#..|#..#..||
......|#...#|.#|#..|.#.#|....#|...|.#.....#..|#.|.
.##.###||..#..||..|#.|...#.|.||..|.||.|##|#|...|..
.|...||....##||...##....|..#|....#|#.|..#..|.#.##.
.#...||#.....#|...#...#||#...###..|.#.||..#...||..
......|.|.|.#..#..#.|..|.#.#||..|||#.||..|.###..|.
......#|...|..#||..|##.#....#.#...|.....|.|.|.###.
......|.....##....|...|.##|.|..#..........|....#..
.|.|...|.||...#.....|.#...#.##....#..#..........|.
..|..|##.#...|.....#|.|.|..|....|.......|||.......
..#|..|...#..||.......|.|...#..........##.#..|#.|.
||#|.##...##.#.#||....#.||.#....#|....|...#.|.#|..
|.|.#.|.#..#|.#..|.#.||....#..|.|.|#..|||.|.|.#..#
..#..|#|.##....||#|.....|#..|...|##..|#....|##.#..
|...||...##.#..#.|....#..##|.|.#||#.#.|.#..|.#....
.#..||.|...#...#.#.#..#.||..#...#|.##......||||...
...#...|#|.....#|....#...##......##.#...|..#..#..|
.|..|||..|#.|....|#.##..||..#|....|....##.|.|.....
........#...|#......|##|##....##.#|#.|#|........|#
.|....##.|.||#..####..#.##|#....|...|#..##.......#
..|#.|.|..|...|.||.|#..|......#..#...|.#.#..###||.
#.##||.#||.|.|#|.....#|.#|...#|.#|#||#||.|#...#|.|
|..|..#...|##.|...........#.|##.|..##..||.#|..|||#
..|.|..|.|..|..||..##.|.#...#|..|.|..|#.##.#||....
.....#..|.|..|||.###...|#|#..|..#....#......##.|..
|...##.|.#.............|.#.#.....#|#..#...#...|.|.
|##|.|...|.|.....#|....##....|.#....|...##..#...|.
|.....##..#.#.|.|..|##.#|#.....||.#...|.#..#|.#|..
#.#..#......#........|.|..#|...###...|...#..#..#..
.||..#.....##.##..||.|...#.|..||.......|#|.|.#|..|
||##.....##...#...#|.#|....|||.|.#..#.#...|....|..
|....||...|.||......#...#.#..|.#..|.|##.|#........
..#.|.|...|.|..|#...#.|.|..|........#.|.#...|.|...
.#|.|.|.|#..##|.|..|.||.|.#.##..|...|.|....|...|..
|#..|....#...#|##.....|...|..#|..##.||#.#|...|#.||
|..#||...#.|......|..|#.##.#.....##.#|#...###||...
|.|.#..#|...|#.|...|...#.|.......##....#|...|.|.|#
...|...#..##|..|.....#.|...|.#..|.|#..|...........
...##|..#...#|...#...#..###..||....##.#..###.#|.|.
.#.|.....#...#..#|||#..|#||.#||.#..|.|.#|..#.#||..
#..|..#..||#.|##...|..#|.||#|####.#.|...|..|#|#...
|#..#..#..#..#.......|.#.|..||..|........|...#.|..
.|#.#....|..##..|..|||.|.#.||....|#|....|#...#|.#.
#..|.....||#....##.|...#.#|.......|..|||||..#..#|#
#|.#|..#....#|#...||..|......||.#|.|.|...||..#..#.
#|..|##..##|#...||..||#.#.|.|...#...#..||.|..#.|..
|#.....#..#.#.#...||.....|...||.#.#.|....|.||.#.#.
##.##|..||...|###|.||.||..#||..#.||.#|.||..|...|..
INPUT

# Part One
lumber = CollectLumber.new(input)
lumber.calculate_resource_value

# Part Two
lumber = CollectLumber.new(input, 1000000000)
lumber.calculate_resource_value
