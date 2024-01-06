class_name BreakableBrick
extends Block

func activate():
	$CollisionShape2D.disabled = true
	$Sprite2D.visible = false
	$Explosion.emitting = true
	$Explosion.finished.connect(queue_free)

func bump():
	var t := create_tween()
	var half_duration: float = .1
	var bumped_position := position - Vector2(0, Game.BLOCK_SIZE / 2)
	t.tween_property(self, "position", bumped_position, half_duration)
	t.tween_property(self, "position", position, half_duration)


func _to_string():
	return "BreakableBrick at " + str(position)
