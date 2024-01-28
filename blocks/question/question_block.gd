class_name QuestionBlock
extends Block


func activate(item_wanted: String = ""):
	if not activated:

		if item and item is Shroom and item_wanted == "FireFlower":
			item = secondary_item
		produce_item()
		activated = true
		modulate = Color(0.812, 0.812, 0.812)

func _to_string():
	return "BreakableBrick at " + str(position)
