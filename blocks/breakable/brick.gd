class_name BreakableBrick
extends Block

var t: Tween

var original_position: Vector2:
	set(new_pos):
		if original_position == Vector2.ZERO:
			original_position = new_pos

func activate():
	$CollisionShape2D.disabled = true
	$Sprite2D.visible = false
	$Explosion.emitting = true
	$Explosion.finished.connect(queue_free)

func bump():
	t = create_tween()
	var half_duration: float = .1
	original_position = position
	var bumped_position := original_position - Vector2(0, Game.BLOCK_SIZE / 2)
	t.tween_property(self, "position", bumped_position, half_duration)
	t.tween_property(self, "position", original_position, half_duration)


func _to_string():
	return "BreakableBrick at " + str(position)
