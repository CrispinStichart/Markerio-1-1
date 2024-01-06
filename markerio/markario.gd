class_name Markerio
extends CharacterBody2D

enum States {SMALL, BIG, FIRE}
var power_level := States.SMALL
var acceleration: float = Game.BLOCK_SIZE
var max_walk_speed: float = Game.BLOCK_SIZE*5
var max_run_speed: float = Game.BLOCK_SIZE*10
var jump_height: float = Game.BLOCK_SIZE*4
var jump_speed: float = Game.BLOCK_SIZE*15
var can_jump := true
var jumping := false
var remaining_jump_height: float = 0

var feet_position: Vector2:
	get:
		var x = position.x
		var y = position.y + $CollisionShape2D.shape.size.y/2
		return Vector2(x, y)

@onready var sprite:AnimatedSprite2D = $sprite_scaler/AnimatedSprite2D

func _process(_delta):
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

	if velocity.x == 0:
		sprite.play("idle")
	elif sprite.animation != "run":
		sprite.play("run")

func _physics_process(_delta):
	var blocks:Array[Block] = []
	for i in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is Block and snappedf(collision.get_angle(), .01) == 3.14:
			for node in $block_detector.get_overlapping_bodies():
				if node is Block:
					blocks.append(node)
			velocity.y = 0
			remaining_jump_height = 0
			break


	if blocks:
		print(len(blocks))
		var closest:Block = blocks[0]

		for i in range(1, len(blocks)):
			var block: Block = blocks[i]
			print("Closest: ", closest, " Comparing against: ", block)
			print("   ", closest.position.x, ", ", block.position.x, ", ", position.x)
			if abs(position.x - block.position.x) < abs(position.x - closest.position.x):
				closest = block

		if closest is BreakableBrick and power_level == States.SMALL:
			closest.bump()
		else:
			print("Activating ", closest)
			closest.activate()

func eat_mushroom():
	if power_level == States.SMALL:
		power_level = States.BIG
		$sprite_scaler.scale *= 2
		$CollisionShape2D.shape.size *= 2
		$block_detector.position.y -= Game.BLOCK_SIZE / 2
		#$sprite_scaler.position.y -= sprite.sprite_frames.get_frame_texture("run", 0).get_height() / 2
	else:
		pass
		# Add to score


func take_damage():
	pass
