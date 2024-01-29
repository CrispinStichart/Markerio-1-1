class_name QuestionBlock
extends Block

# Used for multi-coin block.
var timer: float = 3
var is_multi_coin := false

func _physics_process(delta):
	if not is_multi_coin:
		return

	timer -= delta
	if timer <= 0:
		SignalBus.send_signal("coin_block_expired", [tile_pos])
		queue_free()


func activate(item_wanted: String = ""):
	if not activated:
		if is_multi_coin or (item and "item_name" in item and item.item_name == "coin"):
			is_multi_coin = true
			produce_coin()
		elif not is_multi_coin:
			if item and item is Shroom and item_wanted == "FireFlower":
				item = secondary_item
			activated = true
			modulate = Color(0.5, 0.5, 0.5)

			produce_item()

func _to_string():
	return "BreakableBrick at " + str(position)
