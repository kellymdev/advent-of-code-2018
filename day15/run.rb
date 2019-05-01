require_relative 'goblin_battle'

input = <<-INPUT
#######
#.G.E.#
#E.G.E#
#.G.E.#
#######
INPUT

# Part One
battle = GoblinBattle.new(input)
battle.battle_goblins