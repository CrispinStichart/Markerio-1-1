class_name Star
extends CharacterBody2D

var speed: float = Game.BLOCK_SIZE * 2
var jump_speed: float = Game.BLOCK_SIZE * 10


func _physics_process(_delta):
	if is_on_floor():
		velocity.y = -jump_speed


func _on_collection_area_body_entered(body):
	if body is Markerio:
		body.eat_star()
		queue_free()
