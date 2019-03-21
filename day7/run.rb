require_relative 'order_instructions'

# input = <<-INPUT
# Step C must be finished before step A can begin.
# Step C must be finished before step F can begin.
# Step A must be finished before step B can begin.
# Step A must be finished before step D can begin.
# Step B must be finished before step E can begin.
# Step D must be finished before step E can begin.
# Step F must be finished before step E can begin.
# INPUT

input = <<-INPUT
Step S must be finished before step C can begin.
Step C must be finished before step R can begin.
Step L must be finished before step W can begin.
Step V must be finished before step B can begin.
Step P must be finished before step Y can begin.
Step M must be finished before step B can begin.
Step Y must be finished before step J can begin.
Step W must be finished before step T can begin.
Step N must be finished before step I can begin.
Step H must be finished before step O can begin.
Step O must be finished before step T can begin.
Step Q must be finished before step X can begin.
Step T must be finished before step K can begin.
Step A must be finished before step D can begin.
Step G must be finished before step K can begin.
Step D must be finished before step X can begin.
Step R must be finished before step J can begin.
Step U must be finished before step B can begin.
Step K must be finished before step J can begin.
Step B must be finished before step J can begin.
Step J must be finished before step E can begin.
Step E must be finished before step Z can begin.
Step F must be finished before step I can begin.
Step X must be finished before step Z can begin.
Step Z must be finished before step I can begin.
Step E must be finished before step F can begin.
Step R must be finished before step I can begin.
Step L must be finished before step Z can begin.
Step N must be finished before step O can begin.
Step O must be finished before step D can begin.
Step K must be finished before step I can begin.
Step R must be finished before step F can begin.
Step T must be finished before step F can begin.
Step N must be finished before step G can begin.
Step M must be finished before step D can begin.
Step F must be finished before step X can begin.
Step S must be finished before step D can begin.
Step Q must be finished before step F can begin.
Step L must be finished before step R can begin.
Step J must be finished before step F can begin.
Step L must be finished before step T can begin.
Step M must be finished before step H can begin.
Step D must be finished before step F can begin.
Step W must be finished before step B can begin.
Step C must be finished before step A can begin.
Step E must be finished before step I can begin.
Step P must be finished before step Q can begin.
Step A must be finished before step B can begin.
Step P must be finished before step R can begin.
Step C must be finished before step J can begin.
Step Y must be finished before step K can begin.
Step C must be finished before step L can begin.
Step E must be finished before step X can begin.
Step X must be finished before step I can begin.
Step A must be finished before step G can begin.
Step M must be finished before step E can begin.
Step C must be finished before step T can begin.
Step C must be finished before step Y can begin.
Step K must be finished before step E can begin.
Step H must be finished before step D can begin.
Step P must be finished before step K can begin.
Step D must be finished before step R can begin.
Step J must be finished before step X can begin.
Step H must be finished before step Z can begin.
Step M must be finished before step R can begin.
Step V must be finished before step U can begin.
Step K must be finished before step B can begin.
Step L must be finished before step Q can begin.
Step Y must be finished before step I can begin.
Step T must be finished before step G can begin.
Step U must be finished before step E can begin.
Step S must be finished before step Q can begin.
Step P must be finished before step G can begin.
Step P must be finished before step M can begin.
Step N must be finished before step J can begin.
Step P must be finished before step O can begin.
Step U must be finished before step J can begin.
Step C must be finished before step N can begin.
Step W must be finished before step R can begin.
Step B must be finished before step Z can begin.
Step F must be finished before step Z can begin.
Step O must be finished before step E can begin.
Step W must be finished before step N can begin.
Step A must be finished before step I can begin.
Step W must be finished before step J can begin.
Step R must be finished before step E can begin.
Step N must be finished before step B can begin.
Step M must be finished before step U can begin.
Step B must be finished before step E can begin.
Step V must be finished before step J can begin.
Step O must be finished before step I can begin.
Step Q must be finished before step T can begin.
Step Q must be finished before step U can begin.
Step L must be finished before step V can begin.
Step S must be finished before step Z can begin.
Step C must be finished before step P can begin.
Step P must be finished before step A can begin.
Step S must be finished before step G can begin.
Step N must be finished before step H can begin.
Step V must be finished before step H can begin.
Step B must be finished before step I can begin.
INPUT

# Part One
instructions = OrderInstructions.new(input)
instructions.determine_order
