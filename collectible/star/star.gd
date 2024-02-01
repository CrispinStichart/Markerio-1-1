class_name Star
extends CharacterBody2D

var speed: float = Constants.BLOCK_SIZE * 2
var jump_speed: float = Constants.BLOCK_SIZE * 10


func _physics_process(_delta):
	if is_on_floor():
		velocity.y = -jump_speed


func _on_collection_area_body_entered(body):
	if body is Markerio:
		var player = $AudioStreamPlayer2D
		$AudioStreamPlayer2D.reparent(body)
		player.volume_db = 0
		player.position = Vector2.ZERO
		player.global_position = body.global_position
		# Now on the Markerio side, the appropriate things can happen.
		body.eat_star()
		queue_free()
