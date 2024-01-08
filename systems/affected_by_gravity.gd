extends Node

@export var gravity: float = Game.GRAVITY
@onready var parent: CharacterBody2D = get_parent()

func _physics_process(_delta):
	if not parent.is_on_floor():
		parent.velocity.y += gravity
		parent.velocity.y = min(parent.velocity.y, Game.MAX_FALL_SPEED)
