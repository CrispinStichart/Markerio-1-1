extends Node

@onready var parent: CharacterBody2D = get_parent()

var direction:float = 1

var hit_wall := false

func _ready():
	if "direction" in get_parent():
		direction = get_parent().direction

func _physics_process(_delta):
	parent.velocity.x = direction * parent.speed

	parent.move_and_slide()
	if not parent.is_on_wall():
		hit_wall = false
	for i in parent.get_slide_collision_count():
		if parent.is_on_wall() and not hit_wall:
			direction *= -1
			hit_wall = true
