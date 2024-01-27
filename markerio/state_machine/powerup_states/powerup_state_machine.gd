class_name PowerLevelStateMachine
extends MyStateMachine

var states: Array[String] = ["small", "big", "fireflower"]
var current_state = 0

func level_up():
	if current_state == len(states) - 1:
		# Emit a signal or something to say that we should get points instead
		return
	else:
		current_state += 1
		transition_to(states[current_state])


func level_down():
	if current_state  == 0:
		# Emit a signal or something to say that we should get points instead
		markerio.die()
		return
	else:
		current_state -= 1
		transition_to(states[current_state])

func set_size(index: int) -> void:
	current_state = index
	transition_to(states[current_state])
