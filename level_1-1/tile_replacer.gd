extends TileMap


var coords_to_classes := {
	Vector2i(0, 0): BreakableBrick,
	Vector2i(1, 0): null,
	Vector2i(2, 0): QuestionBlock,
	Vector2i(3, 0): null,
	Vector2i(4, 0): Coin,
	Vector2i(5, 0): FireFlower,
	Vector2i(6, 0): Shroom,
	Vector2i(7, 0): Star,
	Vector2i(8, 0): null,
}

var blocks_to_coord := {
	"breakable": Vector2(0, 0),
	"question": Vector2(1, 0),
}
func _ready():
	for pos in get_used_cells(0):
		var coords := get_cell_atlas_coords (0, pos)
		var block_class_name = coords_to_classes.get(coords)
		if block_class_name == null:
			continue

		# Create the instance of the block.
		var block = InstanceManager.create(block_class_name)

		# Get rid of the tile.
		erase_cell(0, pos)

		# Add the instance to the correct subtree (needed by Game class).
		var location: Node = self
		if block is Block:
			location = $blocks
		elif block is Coin:
			location = $coins
		location.add_child(block)

		# Save the tile coordinates with the block (used when replacing blocks
		# during the game).
		block.tile_pos = pos

		# Set the position of the new block, keeping in mind the origin is the
		# center of the block.
		block.position = Vector2(pos) * Constants.BLOCK_SIZE + Vector2.ONE * Constants.BLOCK_SIZE / 2


		# I need to work on my names. `block` at this point could be a coin.
		if not block is Block:
			continue

		# Now we see if there's an item attached to the block.
		var item_class_name = coords_to_classes.get(get_cell_atlas_coords(1, pos))
		if item_class_name == null:
			continue

		# Get rid of the item tile.
		erase_cell(1, pos)

		block.add_item(InstanceManager.create(item_class_name))


