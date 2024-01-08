extends TileMap

var coin := preload("res://collectible/coin/coin.tscn")
var question_block := preload("res://blocks/question/question_block.tscn")
var breakable := preload("res://blocks/breakable/brick.tscn")
var coin_block := preload("res://blocks/coin_block/coin_block.tscn")

func _ready():
	for pos in get_used_cells(0):
		var coords := get_cell_atlas_coords (0, pos)
		var block = null
		var item_coords = get_cell_atlas_coords(1, pos)
		if  coords == Vector2i(0, 0) and item_coords == Vector2i(4, 0):
			block = coin_block.instantiate()
		elif coords == Vector2i(0, 0):
			block = breakable.instantiate()
		elif coords == Vector2i(2, 0):
			block = question_block.instantiate()
			if item_coords == Vector2i(6, 0):
				block.item = QuestionBlock.Item.MUSHROOM
			elif coords == Vector2i(7, 0):
				block.item = QuestionBlock.Item.STAR
		elif coords == Vector2i(4, 0):
			block = coin.instantiate()
		else:
			continue

		# Get rid of the tile.
		erase_cell(0, pos)
		# Get rid of the item, if there is one.
		if item_coords != -Vector2i.ONE:
			erase_cell(1, pos)

		# Save the tile coordinates with the block (used when replacing blocks
		# during the game).
		block.tile_pos = pos

		# Add the child to the correct spot.
		var location: Node = self
		if block is Block:
			location = $blocks
		elif block is Coin:
			location = $coins
		location.add_child(block)

		# Set the position of the new block, keeping in mind the origin is the
		# center of the block.
		block.position = Vector2(pos) * Game.BLOCK_SIZE + Vector2.ONE * Game.BLOCK_SIZE / 2

