class_name Koopa
extends CharacterBody2D

var walk_speed = Game.BLOCK_SIZE * 2
var shell_speed = Game.BLOCK_SIZE * 12

@export var direction: int = -1
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var raycast_timeout:float = 0

var in_shell := false


func _ready():
	$AnimatedSprite2D.play("walk")


func _process(_delta):
	# We can't scale the whole goomba, because collision shapes can't be scaled.
	# Could use FlipH, but then we'd have to adjust the position of the sprite.
	# We're using a horizontal offset right now, which is applied before the scale.
	# Offsets are applied after the Flip.
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false


func _physics_process(delta):
	velocity.x = direction * (shell_speed if in_shell else walk_speed)


	move_and_slide()

	for i in get_slide_collision_count():
		var collision:KinematicCollision2D = get_slide_collision(i)
		if collision.get_angle() != 0:
			direction *= -1

	raycast_timeout -= delta
	if not in_shell and raycast_timeout <= 0 and not $ground_checker.is_colliding():
		direction *= -1
		raycast_timeout = 1.0

func tuck_into_shell():
	direction = 0
	$AnimatedSprite2D.play("shell")
	in_shell = true

func _on_kill_hitbox_body_entered(body):
	if body is Markerio:
		if in_shell and body.feet_position.y < position.y:
			direction = 0
			body.bounce()
		elif in_shell and direction == 0:
			direction = -1 if body.position.x > position.x else 1
		elif in_shell:
			body.take_damage()
		elif body.feet_position.y < position.y:
			body.bounce()
			tuck_into_shell()
		else:
			body.take_damage()
