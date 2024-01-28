class_name Fireball
extends CharacterBody2D

var direction = 1
var speed: float = Constants.BLOCK_SIZE * 11
var jump_speed: float = Constants.BLOCK_SIZE * 10

var lifetime = 3
var hit_wall := false

func _ready():
	if "direction" in get_parent():
		direction = get_parent().direction


func _physics_process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

	rotate(.1)

	# Always bounce as soon as the floor is touched.
	if is_on_floor():
		velocity.y = -jump_speed
	# Apply gravity.
	else:
		velocity.y += Constants.GRAVITY * delta
		#velocity.y = min(velocity.y, Constants.MAX_FALL_SPEED)

	velocity.x = direction * speed

	move_and_slide()

	# Reset the flag (used to make sure the fireball doesn't get stuck).
	if not is_on_wall():
		hit_wall = false

	for i in get_slide_collision_count():
		# Handle bouncing off of wall.
		if is_on_wall() and not hit_wall:
			direction *= -1
			hit_wall = true

		# Handle killing enemies.
		var collision := get_slide_collision(i)
		if collision.get_collider().has_method("tumble_die"):
			collision.get_collider().tumble_die()
			queue_free()
			break




