extends Node

@onready var parent: CharacterBody2D = get_parent()

var direction:float = 1

func _ready():
	if "direction" in get_parent():
		direction = get_parent().direction

func _physics_process(_delta):
	parent.velocity.x = direction * parent.speed

	parent.move_and_slide()
	for i in parent.get_slide_collision_count():
		var collision:KinematicCollision2D = parent.get_slide_collision(i)
		# TODO: look into this -- is this an issue when moving diagonally?
		#       It seems like it should be, but it's not. Strange.
		if parent is Star:
			print(collision.get_angle())
		if collision.get_angle() > .1 and collision.get_angle() < 3:
			direction *= -1
			break
