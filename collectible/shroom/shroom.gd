extends CharacterBody2D

var direction: int = 1


# Should this be character node? Or should we use an area to detect collision?
# With characters, we get move_and_slide, and bounce, which is honestly overkill.
# But we do get colision detection, which isn't nothing...
# Perhaps we should use an area and a collision, but the collision only collides
# with ground, not markerio.
# And the big issue is that
func _physics_process(_delta):
	if not is_on_floor():
		velocity.y += Game.GRAVITY

	velocity.x = Game.BLOCK_SIZE * 2 * direction
	move_and_slide()

	for i in get_slide_collision_count():
		var collision:KinematicCollision2D = get_slide_collision(i)
		if collision.get_angle() != 0:
			direction *= -1





func _on_pickup_area_body_entered(body):
	if body is Markerio:
		body.eat_mushroom()
		queue_free()
