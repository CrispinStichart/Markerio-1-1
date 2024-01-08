class_name QuestionBlock
extends Block


func activate():
	if not activated:
		produce_item()
		activated = true
		modulate = Color(0.812, 0.812, 0.812)

func _to_string():
	return "BreakableBrick at " + str(position)
