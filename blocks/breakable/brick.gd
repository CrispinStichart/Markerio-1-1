class_name BreakableBrick
extends Block

var t: Tween
signal expired(Vector2i)

var original_position: Vector2:
	set(new_pos):
		if original_position == Vector2.ZERO:
			original_position = new_pos

func activate(item_wanted: String = ""):
	if activated:
		return
	if item:
		if item is Shroom and item_wanted == "FireFlower":
			item = secondary_item
		spit_out_item()
		return
	$CollisionShape2D.disabled = true
	$Sprite2D.visible = false
	$Explosion.emitting = true
	$Explosion.finished.connect(queue_free)

func bump():
	if activated:
		return
	if item:
		spit_out_item()
		return
	t = create_tween()
	var half_duration: float = .1
	original_position = position
	var bumped_position := original_position - Vector2(0, Constants.BLOCK_SIZE / 2)
	t.tween_property(self, "position", bumped_position, half_duration)
	t.tween_property(self, "position", original_position, half_duration)

func spit_out_item():
	activated = true
	produce_item()
	$Sprite2D.texture = load("res://blocks/unbreakable/unbreakable.png")

func _to_string():
	return "BreakableBrick at " + str(position)
