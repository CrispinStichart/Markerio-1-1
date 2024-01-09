class_name Markerio
extends CharacterBody2D

signal died

var acceleration: float = Game.BLOCK_SIZE
var max_walk_speed: float = Game.BLOCK_SIZE*5
var max_run_speed: float = Game.BLOCK_SIZE*10
var jump_height: float = Game.BLOCK_SIZE*4
var jump_speed: float = Game.BLOCK_SIZE*15
var can_jump := true
var jumping := false
var remaining_jump_height: float = 0

var invincible := false
var has_star := false

var move_animation = "run_small"
var idle_animation = "idle_small"


var feet_position: Vector2:
	get:
		var x = position.x
		var y = position.y + $small_collider.shape.size.y/2 # FIXME
		return Vector2(x, y)

@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var power_level_state_machine: PowerLevelStateMachine = $power_level_state_machine


func _process(_delta):
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

	# TODO: make mario freeze in run animation, index 3
	if velocity.x == 0 and velocity.y == 0:
		sprite.play(idle_animation)
	elif sprite.animation != move_animation:
		sprite.play(move_animation)


func _physics_process(delta):
	if jumping and remaining_jump_height > 0:
		$gravity.process_mode = Node.PROCESS_MODE_DISABLED
		remaining_jump_height -= jump_speed * delta
		velocity.y = -jump_speed
	elif is_on_floor():
		$gravity.process_mode = Node.PROCESS_MODE_INHERIT
		can_jump = true
		jumping = false
		remaining_jump_height = 0
	elif not is_on_floor() and remaining_jump_height <= 0:
		$gravity.process_mode = Node.PROCESS_MODE_INHERIT


	move_and_slide()

	handle_block_collision()


func handle_block_collision():
	"""
	It's possible for markerio to hit two blocks at once, if he's not standing under exactly only
	one. We want to prioritize the block that's closer to the center of him. We don't want to use
	a raycast in the center, because he should still be able to hit blocks on the edge of his
	hitbox.
	"""
	var blocks:Array[Block] = []
	for i in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		# Look for collisions with blocks that are from below. (snappedf is basically round()).
		if snappedf(collision.get_angle(), .01) == 3.14:
			for node in $block_detector.get_overlapping_bodies():
				if node is Block:
					blocks.append(node)
			# Make Markerio fall down, and disable his jump.
			velocity.y = 0
			remaining_jump_height = 0
			break

	if blocks:
		var closest:Block = blocks[0]
		# This could be an if/else if I could garantee that there would be a max of two blocks,
		# like in real Mario. Which is currently true for this game. But I want to leave myself
		# open for changing that.
		for i in range(1, len(blocks)):
			var block: Block = blocks[i]
			if abs(position.x - block.position.x) < abs(position.x - closest.position.x):
				closest = block

		if closest is BreakableBrick and power_level_state_machine.current_state == 0:
			closest.bump()
		else:
			closest.activate()


func eat_mushroom():
	power_level_state_machine.level_up()


func eat_fire_flower():
	power_level_state_machine.level_up()

func eat_star():
	has_star = true
	$invincibility_timer.set_invincibility(10)


func take_damage():
	if not invincible:
		power_level_state_machine.level_down()
		$invincibility_timer.set_invincibility()

func die():
	power_level_state_machine.set_size(0)
	died.emit()


func bounce():
	velocity.y = -jump_speed
