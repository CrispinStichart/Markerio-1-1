class_name Koopa
extends CharacterBody2D

var walk_speed = Constants.BLOCK_SIZE * 2
var shell_speed = Constants.BLOCK_SIZE * 12

var saw_ground := false

@export var direction: int = -1

@onready var sprite: Sprite2D = $Sprite2D
@onready var state_chart:StateChart = $StateChart
@onready var ground_checker: RayCast2D = $ground_checker

func _process(_delta):
	# We can't scale the whole goomba, because collision shapes can't be scaled.
	# Could use FlipH, but then we'd have to adjust the position of the sprite.
	# We're using a horizontal offset right now, which is applied before the scale.
	# Offsets are applied after the Flip.
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false


func _physics_process(_delta: float) -> void:
	velocity.y += Constants.GRAVITY

func hit():
	state_chart.send_event("hit")

func die():
	$kill_hitbox.set_deferred("monitoring", false)
	collision_mask = 0
	# So it can't collide with Markerio, but can be detected by the killfloor.
	# Doesn't work and shouldn't be needed, since we're disabling monitoring...
	$AnimatedSprite2D.flip_v = true
	velocity = Vector2(1, -1) * Constants.BLOCK_SIZE * 20


func _on_hitbox_area_entered(area: Area2D):
	var body = area.get_parent()
	print("hit: ", body)
	if body.has_method("hit"):
		body.hit()


func _on_walking_state_physics_processing(_delta: float) -> void:
	state_chart.send_event("walking")
	if ground_checker.is_colliding():
		saw_ground = true
	velocity.x = direction * walk_speed


	move_and_slide()

	if is_on_wall() or (saw_ground and not ground_checker.is_colliding()):
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
			


func _on_walking_state_entered() -> void:
	$AnimationPlayer.play("RESET")



func _on_kickbox_body_entered(body: Node2D) -> void:
	direction = -1 if global_position.x - body.global_position.x < 0 else 1
	state_chart.send_event("hit")



func _on_wiggle_state_entered() -> void:
	state_chart.send_event("start_wiggle")
