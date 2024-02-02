class_name Koopa
extends CharacterBody2D

var walk_speed = Constants.BLOCK_SIZE * 2
var shell_speed = Constants.BLOCK_SIZE * 12

var saw_ground := false

@export var direction: int = -1

@onready var sprite: Sprite2D = $Sprite2D
@onready var state_chart:StateChart = $StateChart
@onready var ground_checker: RayCast2D = $ground_checker

# There's an issue where Markerio can trigger on_enter callbacks
# when mario is inside the area when the area is activated. There's no
# doubt a cleaner way to do it, but using a timer and some conditions works.
var hitbox_delay := .2
var hitbox_delay_timer := hitbox_delay

func _process(_delta):
	# We can't scale the whole goomba, because collision shapes can't be scaled.
	# Could use FlipH, but then we'd have to adjust the position of the sprite.
	# We're using a horizontal offset right now, which is applied before the scale.
	# Offsets are applied after the Flip.
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false


func _physics_process(delta: float) -> void:
	velocity.y += Constants.GRAVITY * delta

func hit():
	state_chart.send_event("hit")
	Sound.play_effect("koopa_shell_bonk")

func die():
	$kill_hitbox.set_deferred("monitoring", false)
	collision_mask = 0
	# So it can't collide with Markerio, but can be detected by the killfloor.
	# Doesn't work and shouldn't be needed, since we're disabling monitoring...
	$AnimatedSprite2D.flip_v = true
	velocity = Vector2(1, -1) * Constants.BLOCK_SIZE * 20


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


func _on_hitbox_area_entered(area: Area2D):
	var body = area.get_parent()
	if body.has_method("tumble_die"):
		body.tumble_die()
	elif body.has_method("hit") and hitbox_delay_timer < 0:
		body.hit()


func _on_walking_state_physics_processing(_delta: float) -> void:
	state_chart.send_event("walking")
	if ground_checker.is_colliding():
		saw_ground = true
	velocity.x = direction * walk_speed


	move_and_slide()

	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var is_facing_object = signf(position.x - collision.get_position().x) == -direction

		if (is_on_wall() and is_facing_object) or (saw_ground and not ground_checker.is_colliding()):
			direction *= -1
			saw_ground = false






func _on_in_shell_moving_state_physics_processing(_delta: float) -> void:
	velocity.x = direction * shell_speed

	move_and_slide()

	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)


		var is_facing_object = signf(position.x - collision.get_position().x) == -direction

		if is_on_wall() and is_facing_object:
			direction *= -1
			Sound.play_effect("koopa_shell_bonk")



func _on_walking_state_entered() -> void:
	$AnimationPlayer.play("RESET")


func _on_kickbox_body_entered(body: Node2D) -> void:
	if hitbox_delay_timer > 0:
		return
	direction = -1 if global_position.x - body.global_position.x < 0 else 1
	state_chart.send_event("hit")
	Sound.play_effect("koopa_shell_bonk")



func _on_wiggle_state_entered() -> void:
	state_chart.send_event("start_wiggle")



func _on_reset_hitbox_timer():
	hitbox_delay_timer = hitbox_delay


func _on_tick_hitbox_timer(delta):
	hitbox_delay_timer -= delta
