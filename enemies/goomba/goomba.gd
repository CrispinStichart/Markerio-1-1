class_name Goomba
extends CharacterBody2D

var speed: float = Constants.BLOCK_SIZE*2
var x_offset: float
var hit_wall := false
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


func _physics_process(delta):
	velocity.x = direction * speed

	move_and_slide()
	collision_no_stuck_on_eachother()

	if not is_on_floor():
		velocity.y += Constants.GRAVITY * delta
		velocity.y = min(velocity.y, Constants.MAX_FALL_SPEED)


func collision_no_stuck_on_eachother():
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var is_facing_object = signf(position.x - collision.get_position().x) == -direction

		if is_on_wall() and is_facing_object:
			direction *= -1


func hit():
	Sound.play_effect("goomba_squish")
	$CollisionShape2D.set_deferred("disabled", true)
	$hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$hitbox/CollisionShape2D.set_deferred("disabled", true)
	sprite.scale.y = .15
	# TODO: move them down so they squish flat against ground.
	direction = 0
	get_tree().create_timer(1).timeout.connect(queue_free)

func tumble_die():
	"""This is called when hit by shell, fireball, or star."""
	Sound.play_effect("goomba_thwack")
	$CollisionShape2D.set_deferred("disabled", true)
	$hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$hitbox/CollisionShape2D.set_deferred("disabled", true)
	get_tree().create_timer(1).timeout.connect(queue_free)
	velocity.y = -Constants.BLOCK_SIZE*8
	sprite.flip_v = true
	z_index = 1000


func _on_hitbox_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body.has_method("hit"):
		body.hit()
