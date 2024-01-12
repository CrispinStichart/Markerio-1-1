class_name Fireball
extends CharacterBody2D

var direction = 1
var speed: float = Constants.BLOCK_SIZE * 11
var jump_speed: float = Constants.BLOCK_SIZE * 15

var lifetime = 3

func _physics_process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
		
	if is_on_floor():
		velocity.y = -jump_speed
		
	rotate(.1)
	
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		if collision.get_collider() is Goomba or collision.get_collider() is Koopa:
			collision.get_collider().die()
			queue_free()
