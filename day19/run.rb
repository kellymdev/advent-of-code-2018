require_relative 'flow_control'

# input = <<-INPUT
# #ip 0
# seti 5 0 1
# seti 6 0 2
# addi 0 1 0
# addr 1 2 3
# setr 1 0 0
# seti 8 0 4
# seti 9 0 5
# INPUT

input = <<-INPUT
#ip 3
addi 3 16 3
seti 1 6 1
seti 1 4 5
mulr 1 5 4
eqrr 4 2 4
addr 4 3 3
addi 3 1 3
addr 1 0 0
addi 5 1 5
gtrr 5 2 4
addr 3 4 3
seti 2 6 3
addi 1 1 1
gtrr 1 2 4
addr 4 3 3
seti 1 1 3
mulr 3 3 3
addi 2 2 2
mulr 2 2 2
mulr 3 2 2
muli 2 11 2
addi 4 8 4
mulr 4 3 4
addi 4 12 4
addr 2 4 2
addr 3 0 3
seti 0 2 3
setr 3 9 4
mulr 4 3 4
addr 3 4 4
mulr 3 4 4
muli 4 14 4
mulr 4 3 4
addr 2 4 2
seti 0 4 0
seti 0 3 3
INPUT

# Part One
control = FlowControl.new(input)
control.perform_instructions

# Part Two
one = FlowControl.new(input, [1, 0, 0, 0, 0, 0])
one.perform_instructions
