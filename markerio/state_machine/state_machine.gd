class_name StateMachine
extends Node

@export var markerio: Markerio
@export var state: MarkerioState


func _ready():
	for child in get_children():
		child.markerio = markerio

	transition_to(state.name)

func _process(delta):
	state.process(delta)


func _physics_process(delta):
	state.physics_process(delta)


func transition_to(state_name: String):
	if state:
		state.exit()
	state = get_node(state_name)
	state.enter()
