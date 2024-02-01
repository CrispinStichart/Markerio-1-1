extends TileMap

const better_block_scene = preload("res://blocks/better_block/better_block.tscn")


var coords_to_classes := {
	Vector2i(0, 0): "brick",
	Vector2i(1, 0): null,
	Vector2i(2, 0): "question",
	Vector2i(3, 0): null,
	Vector2i(4, 0): "Coin",
	Vector2i(5, 0): "FireFlower",
	Vector2i(6, 0): "Shroom",
	Vector2i(7, 0): "Star",
	Vector2i(8, 0): "note",
}


func _ready():
	for pos in get_used_cells(0):
		var coords := get_cell_atlas_coords (0, pos)
		var block_class_name = coords_to_classes.get(coords)
		if block_class_name == null:
			continue

		# Get rid of the tile.
		erase_cell(0, pos)

		# Coins or any pre-spawned powerups.
		if block_class_name not in ["brick", "question", "note"]:
			var item = InstanceManager.create(block_class_name)
			add_child(item)
			item.global_position = Vector2(pos) * Constants.BLOCK_SIZE + Vector2.ONE * Constants.BLOCK_SIZE / 2
			continue

		# Create the instance of the block.
		var block:BetterBlock = better_block_scene.instantiate()
		add_child(block)

		# Set the appearance (ugly way of doing this, but oh well).
		var type: BetterBlock.Appearance
		if block_class_name == "brick":
			type = BetterBlock.Appearance.brick
		elif block_class_name == "question":
			type = BetterBlock.Appearance.question
		elif block_class_name == "note":
			type = BetterBlock.Appearance.note
		else:
			push_error("Aaaaaahhhhhh")
			assert(false)

		block.set_appearance(type)


		# Set the position of the new block, keeping in mind the origin is the
		# center of the block.
		block.global_position = Vector2(pos) * Constants.BLOCK_SIZE + Vector2.ONE * Constants.BLOCK_SIZE / 2


		# Now we see if there's an item attached to the block.
		var item_class_name = coords_to_classes.get(get_cell_atlas_coords(1, pos))
		if item_class_name == null and block_class_name == "question":
			block.chosen_action = BetterBlock.Action.PRODUCE_COIN
			block.coins = 1
		elif item_class_name == null and block_class_name == "brick":
			block.chosen_action = BetterBlock.Action.EXPLODE
		elif item_class_name == null and block_class_name == "note":
			block.chosen_action = BetterBlock.Action.CHANGE_MUSIC
		elif item_class_name != null:
			block.chosen_action = BetterBlock.Action.PRODUCE_ITEM
			block.item = item_class_name

		# Get rid of the item tile.
		erase_cell(1, pos)

