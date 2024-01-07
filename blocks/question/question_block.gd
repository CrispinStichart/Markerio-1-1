class_name QuestionBlock
extends Block

enum Item {SINGLE_COIN, MULTIPLE_COINS, MUSHROOM, FIRE_FLOWER, ONE_UP}

@export var item := Item.SINGLE_COIN

func activate():
	if not activated:
		if item == Item.SINGLE_COIN:
			produce_coin()
		elif item == Item.MUSHROOM:
			produce_mushroom()
		activated = true
		modulate = Color(0.812, 0.812, 0.812)

func _to_string():
	return "BreakableBrick at " + str(position)
