class_name Shroom
extends CharacterBody2D

# Disable the collision if it's not moving. This is so it can slide up out of
# a block.

var move_speed: float = Constants.BLOCK_SIZE * 2
var item_name = "Shroom"

@export var speed: float = move_speed:
	set(new_speed):
		speed = new_speed
		$CollisionShape2D.disabled = speed == 0


func fully_extruded():
	speed = move_speed


func _on_pickup_area_body_entered(body):
	if body.has_method("eat_mushroom"):
		body.eat_mushroom()
		queue_free()
