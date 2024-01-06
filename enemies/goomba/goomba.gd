class_name Goomba
extends CharacterBody2D

var max_walk_speed: float = Game.BLOCK_SIZE*2
@export var direction: int = -1
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var x_offset: float


func _ready():
	$AnimatedSprite2D.play("walk")
	x_offset = sprite.offset.x

func _process(_delta):
	# We can't scale the whole goomba, because collision shapes can't be scaled.
	# Could use FlipH, but then we'd have to adjust the position of the sprite.
	# We're using a horizontal offset right now, which is applied before the scale.
	# Offsets are applied after the Flip.
	if velocity.x < 0:
		sprite.flip_h = true
		sprite.offset.x = -x_offset
	elif velocity.x > 0:
		sprite.flip_h = false
		sprite.offset.x = x_offset


func _physics_process(_delta):
	velocity.x = direction * max_walk_speed
	if not is_on_floor():
		velocity.y += Game.GRAVITY

	move_and_slide()

	for i in get_slide_collision_count():
		var collision:KinematicCollision2D = get_slide_collision(i)
		if collision.get_angle() != 0:
			direction *= -1


func squish():
	$CollisionShape2D.set_deferred("disabled", true)
	sprite.scale.y = .15
	sprite.position.y = 32 - (64*.15) / 2
	#max_walk_speed = 0
	#process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().create_timer(1).timeout.connect(queue_free)




func _on_kill_hitbox_body_entered(body):
	if body is Markerio:
		print(body.feet_position, " ", position)
		#if body.feet
		if body.feet_position.y < position.y:
			squish()
		else:
			body.take_damage()
