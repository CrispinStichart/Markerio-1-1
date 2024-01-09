class_name Goomba
extends CharacterBody2D

var speed: float = Game.BLOCK_SIZE*2
var x_offset: float

@export var direction: float = -1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


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


func squish():
	$CollisionShape2D.set_deferred("disabled", true)
	sprite.scale.y = .15
	sprite.position.y = 32 - (64*.15) / 2
	#max_walk_speed = 0
	#process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().create_timer(1).timeout.connect(queue_free)



func die():
	$kill_hitbox.set_deferred("monitoring", false)
	collision_mask = 0
	# So it can't collide with Markerio, but can be detected by the killfloor.
	# Doesn't work and shouldn't be needed, since we're disabling monitoring...
	$AnimatedSprite2D.flip_v = true
	velocity = Vector2(1, -1) * Game.BLOCK_SIZE * 20

func _on_kill_hitbox_body_entered(body):
	if body is Markerio:
		if body.has_star:
			die()
		elif body.feet_position.y < position.y:
			squish()
			body.bounce()
		else:
			body.take_damage()
