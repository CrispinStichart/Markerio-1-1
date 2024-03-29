class_name Markerio
extends CharacterBody2D

signal died


var acceleration: float = Constants.BLOCK_SIZE/2
var max_walk_speed: float = Constants.BLOCK_SIZE*5
var max_run_speed: float = Constants.BLOCK_SIZE*10
var jump_height: float = Constants.BLOCK_SIZE*4
var jump_velocity: float = 9102
var can_jump := true
var jumping := false

var can_break_bricks := false

var star_tween: Tween


var gravity := Constants.GRAVITY

var powerup_wanted := "Shroom"


@onready var sprite:Sprite2D = $Sprite2D
@onready var state_chart: StateChart = $StateChart
@onready var input: InputController = $input_controller_player


func _physics_process(delta):
	move_and_slide()

	$stomp_hitbox.position = velocity*delta

	handle_block_collision()


func handle_block_collision():
	"""
	It's possible for markerio to hit two blocks at once, if he's not standing under exactly only
	one. We want to prioritize the block that's closer to the center of him. We don't want to use
	a raycast in the center, because he should still be able to hit blocks on the edge of his
	hitbox.
	"""
	var blocks:Array = []
	for i in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		# Look for collisions with blocks that are from below. (snappedf is basically round()).
		if snappedf(collision.get_angle(), .01) == 3.14:
			for node in $block_detector.get_overlapping_bodies():
				if node.has_method("activate"):
					blocks.append(node)
			# Make Markerio fall down
			velocity.y = 0
			break

	if blocks:
		var closest = blocks[0]
		# This could be an if/else if I could garantee that there would be a max of two blocks,
		# like in real Mario. Which is currently true for this game. But I want to leave myself
		# open for changing that.
		for i in range(1, len(blocks)):
			var block = blocks[i]
			if abs(position.x - block.position.x) < abs(position.x - closest.position.x):
				closest = block


		closest.activate(powerup_wanted)


func eat_mushroom():
	state_chart.send_event("power_up")
	Sound.play_effect("crunch")


func eat_fire_flower():
	state_chart.send_event("power_up")
	Sound.play_effect("fireball")


func eat_star():
	state_chart.send_event("star")


func hit():
	state_chart.send_event("power_down")


func die():
	# So the killfloor can't call this again.
	if sprite.flip_v:
		return

	died.emit()
	disable_input()
	set_collision(false)
	sprite.flip_v = true
	velocity.x = 0
	velocity.y = -jump_velocity/2



func throw_fireball():
	var fireball: Fireball = InstanceManager.create("Fireball")
	fireball.direction = -1 if sprite.flip_h else 1
	add_sibling(fireball)
	fireball.global_position = global_position
	fireball.global_position.y -= 800
	Sound.play_effect("fireball")


func disable_input():
	input = $input_controller_dummy


func enable_input():
	input = $input_controller_player

func set_collision(should_collide: bool) -> void:
		set_collision_mask_value(2, should_collide)
		set_collision_layer_value(1, should_collide)
		for area: Area2D in [$hurtbox, $stomp_hitbox, $block_detector]:
			area.set_deferred("monitoring", should_collide)
			area.set_deferred("monitorable", should_collide)


func _on_stomp_hitbox_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body.has_method("hit"):
		body.hit()
		var p1 := global_position
		var p2 := global_position + velocity * get_physics_process_delta_time()
		var y: float = area.global_position.y - area.get_children()[0].shape.size.y/2
		var rise := p1.y - p2.y
		var run := p1.x - p2.x
		# In the normal case, we have to use the y = mx + b formula.
		var x: float
		if run != 0 and rise != 0:
			var m := rise/run
			var b := p1.y - (m * p1.x)
			x = (y-b)/m
		# But for a straight-up-and-down jump, or a lateral collision (easily triggered
		# by mario stepping off of a 1-high block into a goomba) the rise or run would be
		# zero, and the formula would result in division by zero. In this special case, x
		# is just the position of Mario.
		else:
			x = p1.x
		var point_of_impact = Vector2(x, y)

		# Now we can set mario's position to this point of impact, which is where his motion
		# was interupted by the goomba's skull, and make him bounce.
		global_position = point_of_impact
		velocity.y = -jump_velocity
		state_chart.send_event("airborne_without_jump")
		state_chart.send_event("started_rising")


func _on_jump_enabled_state_physics_processing(_delta: float) -> void:
	if input.wants_jump():
		velocity.y = -jump_velocity
		state_chart.send_event("jump")
		Sound.play_effect("cap_popping_off")


func _on_grounded_state_physics_processing(_delta: float) -> void:
	if not is_on_floor():
		state_chart.send_event("airborne_without_jump")
		return

	var direction := input.get_direction()
	var is_running := input.wants_run()
	var max_speed: float = max_run_speed if is_running else max_walk_speed

	if direction:
		velocity.x += direction * acceleration
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		if signf(direction) != signf(velocity.x) and abs(velocity.x) > max_walk_speed:
			state_chart.send_event("skidding")
		else:
			state_chart.send_event("not_skidding")
	else:
		velocity.x = move_toward(velocity.x, 0 , acceleration)

	if velocity.x == 0:
		state_chart.send_event("idle")
	else:
		state_chart.send_event("moving")



func _on_airborne_state_physics_processing(delta: float) -> void:
	if is_on_floor():
		state_chart.send_event("on_floor")
		return

	velocity.y += gravity * delta
	velocity.y = min(velocity.y, jump_velocity)

	var direction := input.get_direction()
	if direction:
		var air_acceleration: float = acceleration*.5
		var added_movement: float = direction * air_acceleration
		# TODO: figure out how to cap this so I can't accelrate faster than walking
		# speed, but still can accelerate from a standstill, and deaccelrate from any speed
		var weight: float = clamp((-1/max_walk_speed**2) * velocity.x ** 2 + 1, 0, 1)
		velocity.x += added_movement * weight



func _on_normal_grav_state_physics_processing(_delta: float) -> void:
	if velocity.y > 0 or Input.is_action_just_released("jump"):
		state_chart.send_event("started_falling")


func _on_heavy_grav_state_entered() -> void:
	gravity = Constants.GRAVITY * 3


func _on_normal_grav_state_entered() -> void:
	gravity = Constants.GRAVITY


func _on_grounded_state_processing(_delta: float) -> void:
	var direction = input.get_direction()
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false


func _on_small_state_entered():
	powerup_wanted = "Shroom"
	can_break_bricks = false


func _on_big_state_entered():
	powerup_wanted = "FireFlower"
	can_break_bricks = true

func _on_fire_state_entered():
	powerup_wanted = "FireFlower"
	can_break_bricks = true


func _on_fire_state_input(_event):
	if input.wants_fireball():
		throw_fireball()


func _on_skidding_state_entered():
	Sound.play_effect("whiteboard_squeek")


func _on_no_star_state_entered():
	Sound.unpause_music()
	$star_hitbox.monitoring = false


func _on_star_active_state_entered():
	Sound.pause_music()

	set_invincible.call_deferred(true)

	var COLOR_START = Color(2, 2, 0, 1)
	var COLOR_END = Color(2, 1, 0, 1)
	var flash_duration: float = .1

	star_tween = create_tween()
	star_tween.tween_property(sprite, "self_modulate", COLOR_END, flash_duration)
	star_tween.tween_property(sprite, "self_modulate", COLOR_START, flash_duration)
	star_tween.set_loops()


func _on_star_active_state_exited():
	$AudioStreamPlayer2D.queue_free()

	set_invincible.call_deferred(false)

	sprite.self_modulate = Color.WHITE
	star_tween.stop()


func _on_star_hitbox_area_entered(area):
	var body = area.get_parent()
	if body.has_method("tumble_die"):
		body.tumble_die()

func set_invincible(is_invincible: bool):
	$star_hitbox.monitoring = is_invincible
	$stomp_hitbox.monitoring = not is_invincible
	$hurtbox.monitorable = not is_invincible

	$InvincibilityEffect.emitting = is_invincible
	$InvincibilityEffect.visible = is_invincible


func _on_dead_state_entered():
	die()
