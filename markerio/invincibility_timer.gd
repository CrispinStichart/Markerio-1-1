extends Node2D

var timer: float = 0

@onready var parent: Markerio = get_parent()

func _ready():
	if not parent.invincible:
		process_mode = Node.PROCESS_MODE_DISABLED



func _physics_process(delta):
	timer -= delta
	if timer <= 0:
		parent.invincible = false
		parent.has_star = false
		process_mode = Node.PROCESS_MODE_DISABLED

func set_invincibility(time: float = 1):
	timer = time
	parent.invincible = true
	process_mode = Node.PROCESS_MODE_INHERIT

