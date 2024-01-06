extends TileMap

var coin := preload("res://collectible/coin/coin.tscn")
var question_block := preload("res://blocks/question/question_block.tscn")
var breakable := preload("res://blocks/breakable/brick.tscn")


func _ready():
	for pos in get_used_cells(0):
		var coords := get_cell_atlas_coords (0, pos)
		var block = null
		if coords == Vector2i(0, 0):
			block = breakable.instantiate()
		elif coords == Vector2i(2, 0):
			block = question_block.instantiate()
		elif coords == Vector2i(4, 0):
			block = coin.instantiate()
		else:
			continue
		erase_cell(0, pos)
		add_child(block)
		block.position = Vector2(pos) * Game.BLOCK_SIZE + Vector2.ONE * Game.BLOCK_SIZE / 2
